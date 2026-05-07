package com.gramsetu.controller;

import com.gramsetu.model.*;
import com.gramsetu.service.*;
import com.gramsetu.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/farmer")
public class FarmerController {

    @Autowired private CropService cropService;
    @Autowired private OrderService orderService;
    @Autowired private UserService userService;
    @Autowired private NotificationService notifService;
    @Autowired private SecurityUtil secUtil;
    @Autowired private JdbcTemplate jdbc;

    private static final Set<String> VALID_STATUSES =
        Set.of("CONFIRMED", "PACKED", "DISPATCHED", "DELIVERED");

    // ── Dashboard ────────────────────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(Model m) {
        User farmer = secUtil.getCurrentUser();
        if (farmer == null) return "redirect:/auth/login";
        List<Order> orders = orderService.getByFarmer(farmer.getId());
        long pending = orders.stream().filter(o -> "PENDING".equals(o.getStatus())).count();
        m.addAttribute("farmer",       farmer);
        m.addAttribute("crops",        cropService.getByFarmer(farmer.getId()));
        m.addAttribute("orders",       orders);
        m.addAttribute("cropCount",    cropService.countByFarmer(farmer.getId()));
        m.addAttribute("orderCount",   orders.size());
        m.addAttribute("pendingOrders", pending);
        m.addAttribute("unread",       notifService.countUnread(farmer.getId()));
        return "farmer/dashboard";
    }

    // ── Crops ────────────────────────────────────────────────────────

    @GetMapping("/crops")
    public String mycrops(Model m) {
        m.addAttribute("crops", cropService.getByFarmer(secUtil.getCurrentUserId()));
        return "farmer/my-crops";
    }

    @GetMapping("/crops/add")
    public String addForm(Model m) {
        m.addAttribute("crop", new Crop());
        return "farmer/add-crop";
    }

    @PostMapping("/crops/add")
    public String addCrop(@ModelAttribute Crop crop,
                          @RequestParam(required = false) MultipartFile photo,
                          RedirectAttributes ra) {
        // Validation
        if (crop.getName() == null || crop.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Crop name is required.");
            return "redirect:/farmer/crops/add";
        }
        if (crop.getQuantity() == null || crop.getQuantity().signum() <= 0) {
            ra.addFlashAttribute("errorMsg", "Quantity must be greater than zero.");
            return "redirect:/farmer/crops/add";
        }
        if (crop.getPricePerUnit() == null || crop.getPricePerUnit().signum() <= 0) {
            ra.addFlashAttribute("errorMsg", "Price must be greater than zero.");
            return "redirect:/farmer/crops/add";
        }

        User f = secUtil.getCurrentUser();
        crop.setFarmerId(f.getId());
        crop.setState(f.getState());
        crop.setDistrict(f.getDistrict());
        crop.setName(crop.getName().trim());

        try {
            cropService.addCrop(crop, photo);
            ra.addFlashAttribute("successMsg", "Crop listed successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/farmer/crops";
    }

    @GetMapping("/crops/edit/{id}")
    public String editForm(@PathVariable int id, Model m) {
        Crop crop = cropService.getById(id);
        int uid = secUtil.getCurrentUserId();
        if (crop == null || crop.getFarmerId() != uid) {
            m.addAttribute("errorMsg", "Crop not found.");
            return "redirect:/farmer/crops";
        }
        m.addAttribute("crop", crop);
        return "farmer/edit-crop";
    }

    @PostMapping("/crops/edit/{id}")
    public String editCrop(@PathVariable int id,
                           @ModelAttribute Crop crop,
                           @RequestParam(required = false) MultipartFile photo,
                           RedirectAttributes ra) {
        int uid = secUtil.getCurrentUserId();
        crop.setId(id);
        crop.setFarmerId(uid);

        if (crop.getName() == null || crop.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Crop name is required.");
            return "redirect:/farmer/crops/edit/" + id;
        }
        crop.setName(crop.getName().trim());

        try {
            cropService.updateCrop(crop, photo);
            ra.addFlashAttribute("successMsg", "Crop updated!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Update failed: " + e.getMessage());
        }
        return "redirect:/farmer/crops";
    }

    @PostMapping("/crops/delete/{id}")
    public String deleteCrop(@PathVariable int id, RedirectAttributes ra) {
        cropService.deleteCrop(id, secUtil.getCurrentUserId());
        ra.addFlashAttribute("successMsg", "Crop removed.");
        return "redirect:/farmer/crops";
    }

    // ── Orders ───────────────────────────────────────────────────────

    @GetMapping("/orders")
    public String myOrders(Model m) {
        m.addAttribute("orders", orderService.getByFarmer(secUtil.getCurrentUserId()));
        return "farmer/my-orders";
    }

    /**
     * Update order status — POST (not GET) to prevent CSRF.
     * Only allows valid forward-progressing statuses.
     */
    @PostMapping("/orders/status/{id}")
    public String updateStatus(@PathVariable int id,
                               @RequestParam("status") String status,
                               RedirectAttributes ra) {
        if (!VALID_STATUSES.contains(status)) {
            ra.addFlashAttribute("errorMsg", "Invalid status.");
            return "redirect:/farmer/orders";
        }
        Order o = orderService.getById(id);
        if (o == null) {
            ra.addFlashAttribute("errorMsg", "Order not found.");
            return "redirect:/farmer/orders";
        }
        // Ownership: verify crop belongs to this farmer
        Crop crop = cropService.getById(o.getCropId());
        if (crop == null || crop.getFarmerId() != secUtil.getCurrentUserId()) {
            ra.addFlashAttribute("errorMsg", "Access denied.");
            return "redirect:/farmer/orders";
        }
        orderService.updateStatus(id, status);
        notifService.notifyOrderUpdated(o.getBuyerId(), o.getCropName(), status);
        ra.addFlashAttribute("successMsg", "Order status updated to: " + status);
        return "redirect:/farmer/orders";
    }

    // ── Soil Advisory ────────────────────────────────────────────────

    @GetMapping("/soil-advisory")
    public String soilAdvisory(Model m) {
        int fid = secUtil.getCurrentUserId();
        m.addAttribute("advisories", jdbc.queryForList(
            "SELECT sa.*, u.name AS agronomist_name FROM soil_advisory sa " +
            "LEFT JOIN users u ON sa.agronomist_id=u.id " +
            "WHERE sa.farmer_id=? ORDER BY sa.submitted_at DESC", fid));
        return "farmer/soil-advisory";
    }

    @PostMapping("/soil-advisory/submit")
    public String submitSoilAdvisory(@RequestParam String soilDescription,
                                     @RequestParam(required = false) MultipartFile photo,
                                     RedirectAttributes ra) {
        if (soilDescription == null || soilDescription.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Please describe your soil condition.");
            return "redirect:/farmer/soil-advisory";
        }
        int fid = secUtil.getCurrentUserId();
        String photoUrl = null;
        try {
            if (photo != null && !photo.isEmpty()) {
                photoUrl = new com.gramsetu.util.FileUploadUtil().uploadFile(photo, "soil");
            }
            jdbc.update(
                "INSERT INTO soil_advisory (farmer_id,photo_url,soil_description) VALUES (?,?,?)",
                fid, photoUrl, soilDescription.trim());
            ra.addFlashAttribute("successMsg", "Soil advisory request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Submission failed: " + e.getMessage());
        }
        return "redirect:/farmer/soil-advisory";
    }

    // ── Price Trends ─────────────────────────────────────────────────

    @GetMapping("/prices")
    public String prices(Model m) {
        User f = secUtil.getCurrentUser();
        if (f != null && f.getState() != null && !f.getState().isEmpty()) {
            m.addAttribute("prices", jdbc.queryForList(
                "SELECT * FROM price_history WHERE state=? ORDER BY recorded_date DESC LIMIT 30",
                f.getState()));
        } else {
            m.addAttribute("prices", jdbc.queryForList(
                "SELECT * FROM price_history ORDER BY recorded_date DESC LIMIT 30"));
        }
        return "farmer/price-trends";
    }

    // ── Schemes ──────────────────────────────────────────────────────

    @GetMapping("/schemes")
    public String schemes(Model m) {
        int fid = secUtil.getCurrentUserId();
        m.addAttribute("schemes", jdbc.queryForList(
            "SELECT * FROM govt_schemes WHERE is_active=1 ORDER BY scheme_name"));
        m.addAttribute("myApplications", jdbc.queryForList(
            "SELECT sa.*, gs.scheme_name FROM scheme_applications sa " +
            "JOIN govt_schemes gs ON sa.scheme_id=gs.id " +
            "WHERE sa.farmer_id=? ORDER BY sa.applied_at DESC", fid));
        return "farmer/schemes";
    }

    @PostMapping("/schemes/apply/{schemeId}")
    public String applyScheme(@PathVariable int schemeId, RedirectAttributes ra) {
        int fid = secUtil.getCurrentUserId();
        // Prevent duplicate applications
        Integer existing = jdbc.queryForObject(
            "SELECT COUNT(*) FROM scheme_applications WHERE farmer_id=? AND scheme_id=?",
            Integer.class, fid, schemeId);
        if (existing != null && existing > 0) {
            ra.addFlashAttribute("errorMsg", "You have already applied for this scheme.");
        } else {
            jdbc.update("INSERT INTO scheme_applications (farmer_id,scheme_id) VALUES (?,?)",
                fid, schemeId);
            ra.addFlashAttribute("successMsg", "Scheme application submitted!");
        }
        return "redirect:/farmer/schemes";
    }

    // ── Profile ──────────────────────────────────────────────────────

    @GetMapping("/profile")
    public String profile(Model m) {
        m.addAttribute("user", secUtil.getCurrentUser());
        return "farmer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User u, RedirectAttributes ra) {
        if (u.getName() == null || u.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Name cannot be empty.");
            return "redirect:/farmer/profile";
        }
        u.setId(secUtil.getCurrentUserId());
        userService.updateProfile(u);
        ra.addFlashAttribute("successMsg", "Profile updated!");
        return "redirect:/farmer/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam(value = "confirmNewPassword", required = false) String confirmNew,
                                 RedirectAttributes ra) {
        if (newPassword == null || newPassword.length() < 6) {
            ra.addFlashAttribute("errorMsg", "New password must be at least 6 characters.");
            return "redirect:/farmer/profile";
        }
        if (confirmNew != null && !newPassword.equals(confirmNew)) {
            ra.addFlashAttribute("errorMsg", "New passwords do not match.");
            return "redirect:/farmer/profile";
        }
        boolean ok = userService.changePassword(secUtil.getCurrentUserId(), oldPassword, newPassword);
        if (ok) ra.addFlashAttribute("successMsg", "Password changed successfully!");
        else    ra.addFlashAttribute("errorMsg", "Current password is incorrect.");
        return "redirect:/farmer/profile";
    }

    // ── Notifications ────────────────────────────────────────────────

    @GetMapping("/notifications")
    public String notifications(Model m) {
        int uid = secUtil.getCurrentUserId();
        m.addAttribute("notifications", notifService.getForUser(uid));
        notifService.markAllRead(uid);
        return "farmer/notifications";
    }

    // ── Forum ────────────────────────────────────────────────────────

    @GetMapping("/forum/new")
    public String newPostForm() {
        return "common/forum-new";
    }

    @PostMapping("/forum/new")
    public String newPost(@RequestParam("title") String title,
                          @RequestParam("content") String content,
                          @RequestParam("category") String category,
                          RedirectAttributes ra) {
        if (title == null || title.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Title and content are required.");
            return "redirect:/farmer/forum/new";
        }
        // Validate category to prevent injection
        Set<String> validCats = Set.of("CROP_ADVICE", "PEST_ALERT", "MARKET_INFO", "GENERAL");
        if (!validCats.contains(category)) {
            ra.addFlashAttribute("errorMsg", "Invalid category.");
            return "redirect:/farmer/forum/new";
        }
        jdbc.update(
            "INSERT INTO forum_posts (user_id,title,content,category) VALUES (?,?,?,?)",
            secUtil.getCurrentUserId(), title.trim(), content.trim(), category);
        ra.addFlashAttribute("successMsg", "Post published!");
        return "redirect:/forum";
    }

    @PostMapping("/forum/reply/{postId}")
    public String reply(@PathVariable int postId,
                        @RequestParam("content") String content,
                        RedirectAttributes ra) {
        if (content == null || content.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Reply cannot be empty.");
            return "redirect:/forum/post/" + postId;
        }
        String role = secUtil.getCurrentUserRole();
        boolean expert = "ROLE_AGRONOMIST".equals(role) || "ROLE_ADMIN".equals(role);
        jdbc.update(
            "INSERT INTO forum_replies (post_id,user_id,content,is_expert) VALUES (?,?,?,?)",
            postId, secUtil.getCurrentUserId(), content.trim(), expert ? 1 : 0);
        ra.addFlashAttribute("successMsg", "Reply posted.");
        return "redirect:/forum/post/" + postId;
    }

    @PostMapping("/forum/upvote/{postId}")
    public String upvote(@PathVariable int postId) {
        jdbc.update("UPDATE forum_posts SET upvotes = upvotes + 1 WHERE id = ?", postId);
        return "redirect:/forum/post/" + postId;
    }
}
