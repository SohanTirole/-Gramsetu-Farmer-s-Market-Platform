package com.gramsetu.controller;

import com.gramsetu.model.*;
import com.gramsetu.service.*;
import com.gramsetu.util.SecurityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/buyer")
public class BuyerController {

    @Autowired private OrderService orderService;
    @Autowired private CropService cropService;
    @Autowired private UserService userService;
    @Autowired private NotificationService notifService;
    @Autowired private SecurityUtil secUtil;
    @Autowired private JdbcTemplate jdbc;

    @GetMapping("/dashboard")
    public String dashboard(Model m) {
        User buyer = secUtil.getCurrentUser();
        if (buyer == null) return "redirect:/auth/login";
        List<Order> orders = orderService.getByBuyer(buyer.getId());
        long active = orders.stream()
            .filter(o -> !"DELIVERED".equals(o.getStatus()) && !"CANCELLED".equals(o.getStatus()))
            .count();
        m.addAttribute("buyer", buyer);
        m.addAttribute("recentOrders", orders.stream().limit(5).toList());
        m.addAttribute("totalOrders", orders.size());
        m.addAttribute("activeOrders", active);
        m.addAttribute("unread", notifService.countUnread(buyer.getId()));
        return "buyer/dashboard";
    }

    @GetMapping("/order/place/{cropId}")
    public String placeOrderForm(@PathVariable int cropId, Model m) {
        Crop crop = cropService.getById(cropId);
        if (crop == null || !crop.isAvailable()) {
            m.addAttribute("errorMsg", "This crop is not available.");
            return "redirect:/crops/list";
        }
        m.addAttribute("crop", crop);
        return "buyer/place-order";
    }

    @PostMapping("/order/place/{cropId}")
    public String placeOrder(@PathVariable int cropId,
                             @RequestParam BigDecimal quantity,
                             @RequestParam String paymentMethod,
                             @RequestParam String deliveryAddress,
                             RedirectAttributes ra) {
        User buyer = secUtil.getCurrentUser();
        if (buyer == null) return "redirect:/auth/login";

        // Basic input validation
        if (quantity == null || quantity.compareTo(BigDecimal.ZERO) <= 0) {
            ra.addFlashAttribute("errorMsg", "Quantity must be greater than zero.");
            return "redirect:/crops/detail/" + cropId;
        }
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Delivery address is required.");
            return "redirect:/buyer/order/place/" + cropId;
        }
        if (deliveryAddress.length() > 500) {
            ra.addFlashAttribute("errorMsg", "Delivery address is too long.");
            return "redirect:/buyer/order/place/" + cropId;
        }

        try {
            int orderId = orderService.placeOrder(
                buyer.getId(), cropId, quantity, paymentMethod, deliveryAddress.trim());
            Map<String, Object> crop = jdbc.queryForMap(
                "SELECT c.name, c.farmer_id FROM crops c WHERE c.id=?", cropId);
            int farmerId = ((Number) crop.get("farmer_id")).intValue();
            notifService.notifyOrderPlaced(farmerId, buyer.getId(), (String) crop.get("name"));
            ra.addFlashAttribute("successMsg", "Order #" + orderId + " placed successfully!");
        } catch (RuntimeException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/crops/detail/" + cropId;
        }
        return "redirect:/buyer/orders";
    }

    @GetMapping("/orders")
    public String myOrders(Model m) {
        m.addAttribute("orders", orderService.getByBuyer(secUtil.getCurrentUserId()));
        return "buyer/my-orders";
    }

    @GetMapping("/orders/detail/{id}")
    public String orderDetail(@PathVariable int id, Model m) {
        int uid = secUtil.getCurrentUserId();
        Order order = orderService.getById(id);
        // Ownership check: buyer may only view their own orders
        if (order == null || order.getBuyerId() != uid) {
            m.addAttribute("errorMsg", "Order not found.");
            return "redirect:/buyer/orders";
        }
        m.addAttribute("order", order);
        m.addAttribute("logistics", jdbc.queryForList(
            "SELECT * FROM logistics WHERE order_id=? ORDER BY created_at DESC", id));
        return "buyer/order-detail";
    }

    /**
     * Cancel order — POST to prevent CSRF via GET link.
     * Only PENDING orders owned by this buyer can be cancelled.
     */
    @PostMapping("/orders/cancel/{id}")
    public String cancelOrder(@PathVariable int id, RedirectAttributes ra) {
        int uid = secUtil.getCurrentUserId();
        Order o = orderService.getById(id);
        if (o == null || o.getBuyerId() != uid) {
            ra.addFlashAttribute("errorMsg", "Order not found.");
        } else if (!"PENDING".equals(o.getStatus())) {
            ra.addFlashAttribute("errorMsg", "Only pending orders can be cancelled.");
        } else {
            orderService.updateStatus(id, "CANCELLED");
            ra.addFlashAttribute("successMsg", "Order cancelled successfully.");
        }
        return "redirect:/buyer/orders";
    }

    @GetMapping("/profile")
    public String profile(Model m) {
        m.addAttribute("user", secUtil.getCurrentUser());
        return "buyer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User u, RedirectAttributes ra) {
        u.setId(secUtil.getCurrentUserId());
        userService.updateProfile(u);
        ra.addFlashAttribute("successMsg", "Profile updated!");
        return "redirect:/buyer/profile";
    }

    @GetMapping("/notifications")
    public String notifications(Model m) {
        int uid = secUtil.getCurrentUserId();
        m.addAttribute("notifications", notifService.getForUser(uid));
        notifService.markAllRead(uid);
        return "buyer/notifications";
    }
}
