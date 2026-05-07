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

// ═══════════════════════════════════════════════════════════════
//  SVC Controller
// ═══════════════════════════════════════════════════════════════
@Controller
@RequestMapping("/svc")
class SvcController {

    @Autowired private UserService userService;
    @Autowired private CropService cropService;
    @Autowired private NotificationService notifService;
    @Autowired private FileUploadUtil fileUtil;
    @Autowired private SecurityUtil secUtil;
    @Autowired private JdbcTemplate jdbc;

    private int getSvcId(int uid) {
        try {
            Integer sid = jdbc.queryForObject(
                "SELECT id FROM svc_agents WHERE user_id=?", Integer.class, uid);
            return sid != null ? sid : -1;
        } catch (Exception e) {
            return -1;
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(Model m) {
        User svc = secUtil.getCurrentUser();
        if (svc == null) return "redirect:/auth/login";
        int sid = getSvcId(svc.getId());
        m.addAttribute("svc", svc);
        if (sid > 0) {
            m.addAttribute("agentInfo",
                jdbc.queryForMap("SELECT * FROM svc_agents WHERE id=?", sid));
            m.addAttribute("recentCrops", jdbc.queryForList(
                "SELECT c.*, u.name AS farmer_name FROM crops c JOIN users u ON c.farmer_id=u.id " +
                "WHERE c.svc_agent_id=? ORDER BY c.listed_at DESC LIMIT 8", sid));
            m.addAttribute("recentAdvisories", jdbc.queryForList(
                "SELECT sa.*, u.name AS farmer_name FROM soil_advisory sa " +
                "JOIN users u ON sa.farmer_id=u.id " +
                "WHERE sa.svc_agent_id=? ORDER BY sa.submitted_at DESC LIMIT 5", sid));
            m.addAttribute("cropCount",
                jdbc.queryForObject("SELECT COUNT(*) FROM crops WHERE svc_agent_id=?", Integer.class, sid));
            m.addAttribute("schemeCount",
                jdbc.queryForObject("SELECT COUNT(*) FROM scheme_applications WHERE svc_agent_id=?", Integer.class, sid));
        }
        m.addAttribute("unread", notifService.countUnread(svc.getId()));
        return "svc/dashboard";
    }

    @GetMapping("/register-farmer")
    public String regFarmerForm(Model m) {
        m.addAttribute("farmer", new User());
        return "svc/register-farmer";
    }

    @PostMapping("/register-farmer")
    public String registerFarmer(@ModelAttribute User farmer, RedirectAttributes ra) {
        if (farmer.getName() == null || farmer.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Farmer name is required.");
            return "redirect:/svc/register-farmer";
        }
        if (farmer.getEmail() == null || farmer.getEmail().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Farmer email is required.");
            return "redirect:/svc/register-farmer";
        }
        int uid = secUtil.getCurrentUserId();
        farmer.setRole("ROLE_FARMER");
        if (farmer.getPassword() == null || farmer.getPassword().isEmpty()) {
            farmer.setPassword("Farmer@123");
        }
        try {
            int fid = userService.register(farmer);
            int sid = getSvcId(uid);
            if (sid > 0) {
                jdbc.update(
                    "UPDATE svc_agents SET farmers_registered=farmers_registered+1 WHERE id=?", sid);
            }
            ra.addFlashAttribute("successMsg",
                "Farmer " + farmer.getName() + " registered with ID: " + fid);
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Registration failed: " + e.getMessage());
        }
        return "redirect:/svc/register-farmer";
    }

    @GetMapping("/farmers")
    public String farmers(Model m) {
        int sid = getSvcId(secUtil.getCurrentUserId());
        if (sid > 0) {
            m.addAttribute("farmers", jdbc.queryForList(
                "SELECT DISTINCT u.*, " +
                "(SELECT COUNT(*) FROM crops c WHERE c.farmer_id=u.id AND c.svc_agent_id=?) AS cropCount " +
                "FROM users u JOIN crops c ON u.id=c.farmer_id WHERE c.svc_agent_id=? ORDER BY u.name",
                sid, sid));
        } else {
            m.addAttribute("farmers", jdbc.queryForList(
                "SELECT id,name,phone,village,district,state FROM users " +
                "WHERE role='ROLE_FARMER' AND is_active=1 ORDER BY name"));
        }
        return "svc/farmers";
    }

    @GetMapping("/list-crop")
    public String listCropForm(Model m) {
        m.addAttribute("farmers", jdbc.queryForList(
            "SELECT id,name,village FROM users WHERE role='ROLE_FARMER' AND is_active=1 ORDER BY name"));
        m.addAttribute("crop", new Crop());
        return "svc/list-crop";
    }

    @PostMapping("/list-crop")
    public String listCrop(@ModelAttribute Crop crop,
                           @RequestParam(required = false) MultipartFile photo,
                           RedirectAttributes ra) {
        if (crop.getName() == null || crop.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Crop name is required.");
            return "redirect:/svc/list-crop";
        }
        int sid = getSvcId(secUtil.getCurrentUserId());
        crop.setSvcAgentId(sid > 0 ? sid : null);
        try {
            cropService.addCrop(crop, photo);
            if (sid > 0) {
                jdbc.update(
                    "UPDATE svc_agents SET commission_earned=commission_earned+20 WHERE id=?", sid);
            }
            ra.addFlashAttribute("successMsg", "Crop listed! ₹20 commission credited.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/svc/dashboard";
    }

    @GetMapping("/soil-advisory")
    public String soilAdvisory(Model m) {
        int sid = getSvcId(secUtil.getCurrentUserId());
        m.addAttribute("farmers", jdbc.queryForList(
            "SELECT id,name,village FROM users WHERE role='ROLE_FARMER' AND is_active=1 ORDER BY name"));
        m.addAttribute("advisories", sid > 0
            ? jdbc.queryForList(
                "SELECT sa.*, u.name AS farmer_name FROM soil_advisory sa " +
                "JOIN users u ON sa.farmer_id=u.id " +
                "WHERE sa.svc_agent_id=? ORDER BY sa.submitted_at DESC", sid)
            : List.of());
        return "svc/soil-advisory";
    }

    @PostMapping("/soil-advisory/submit")
    public String submitSoilAdvisory(@RequestParam int farmerId,
                                     @RequestParam String soilDescription,
                                     @RequestParam(required = false) MultipartFile photo,
                                     RedirectAttributes ra) {
        if (soilDescription == null || soilDescription.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Soil description is required.");
            return "redirect:/svc/soil-advisory";
        }
        int sid = getSvcId(secUtil.getCurrentUserId());
        String photoUrl = null;
        try {
            if (photo != null && !photo.isEmpty()) photoUrl = fileUtil.uploadFile(photo, "soil");
            jdbc.update(
                "INSERT INTO soil_advisory (farmer_id,svc_agent_id,photo_url,soil_description) VALUES (?,?,?,?)",
                farmerId, sid > 0 ? sid : null, photoUrl, soilDescription.trim());
            if (sid > 0) {
                jdbc.update(
                    "UPDATE svc_agents SET commission_earned=commission_earned+20 WHERE id=?", sid);
            }
            ra.addFlashAttribute("successMsg", "Advisory submitted! ₹20 commission credited.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/svc/soil-advisory";
    }

    @GetMapping("/scheme-apply")
    public String schemeApply(Model m) {
        int sid = getSvcId(secUtil.getCurrentUserId());
        m.addAttribute("farmers", jdbc.queryForList(
            "SELECT id,name,village FROM users WHERE role='ROLE_FARMER' AND is_active=1 ORDER BY name"));
        m.addAttribute("schemes", jdbc.queryForList(
            "SELECT id,scheme_name FROM govt_schemes WHERE is_active=1 ORDER BY scheme_name"));
        m.addAttribute("applications", sid > 0
            ? jdbc.queryForList(
                "SELECT sa.*, gs.scheme_name, u.name AS farmer_name FROM scheme_applications sa " +
                "JOIN govt_schemes gs ON sa.scheme_id=gs.id " +
                "JOIN users u ON sa.farmer_id=u.id " +
                "WHERE sa.svc_agent_id=? ORDER BY sa.applied_at DESC", sid)
            : List.of());
        return "svc/schemes";
    }

    @PostMapping("/scheme-apply/submit")
    public String submitScheme(@RequestParam int farmerId,
                               @RequestParam int schemeId,
                               RedirectAttributes ra) {
        int sid = getSvcId(secUtil.getCurrentUserId());
        jdbc.update(
            "INSERT INTO scheme_applications (farmer_id,svc_agent_id,scheme_id) VALUES (?,?,?)",
            farmerId, sid > 0 ? sid : null, schemeId);
        if (sid > 0) {
            jdbc.update(
                "UPDATE svc_agents SET commission_earned=commission_earned+50 WHERE id=?", sid);
        }
        ra.addFlashAttribute("successMsg", "Scheme application submitted! ₹50 commission credited.");
        return "redirect:/svc/scheme-apply";
    }

    @GetMapping("/profile")
    public String profile(Model m) {
        m.addAttribute("user", secUtil.getCurrentUser());
        return "svc/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User u, RedirectAttributes ra) {
        u.setId(secUtil.getCurrentUserId());
        userService.updateProfile(u);
        ra.addFlashAttribute("successMsg", "Profile updated!");
        return "redirect:/svc/profile";
    }
}

// ═══════════════════════════════════════════════════════════════
//  Agronomist Controller
// ═══════════════════════════════════════════════════════════════
@Controller
@RequestMapping("/agro")
class AgronomistController {

    @Autowired private NotificationService notifService;
    @Autowired private SecurityUtil secUtil;
    @Autowired private JdbcTemplate jdbc;

    @GetMapping("/dashboard")
    public String dashboard(Model m) {
        User agro = secUtil.getCurrentUser();
        if (agro == null) return "redirect:/auth/login";
        List<Map<String, Object>> pending = jdbc.queryForList(
            "SELECT sa.*, u.name AS farmer_name FROM soil_advisory sa " +
            "JOIN users u ON sa.farmer_id=u.id " +
            "WHERE sa.status IN ('PENDING','IN_REVIEW') ORDER BY sa.submitted_at");
        m.addAttribute("agro", agro);
        m.addAttribute("pendingAdvisories", pending);
        m.addAttribute("pendingCount", pending.size());
        m.addAttribute("completedCount", jdbc.queryForObject(
            "SELECT COUNT(*) FROM soil_advisory WHERE agronomist_id=?", Integer.class, agro.getId()));
        m.addAttribute("unread", notifService.countUnread(agro.getId()));
        return "agro/dashboard";
    }

    @GetMapping("/advisories")
    public String advisories(Model m) {
        m.addAttribute("advisories", jdbc.queryForList(
            "SELECT sa.*, u.name AS farmer_name, u.village AS farmer_village " +
            "FROM soil_advisory sa JOIN users u ON sa.farmer_id=u.id ORDER BY sa.submitted_at DESC"));
        return "agro/advisories";
    }

    @PostMapping("/advisories/respond/{id}")
    public String respond(@PathVariable int id,
                          @RequestParam String recommendation,
                          RedirectAttributes ra) {
        if (recommendation == null || recommendation.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Recommendation cannot be empty.");
            return "redirect:/agro/advisories";
        }
        int agroId = secUtil.getCurrentUserId();
        jdbc.update(
            "UPDATE soil_advisory SET agronomist_id=?,recommendation=?,status='COMPLETED',responded_at=NOW() WHERE id=?",
            agroId, recommendation.trim(), id);
        Map<String, Object> sa = jdbc.queryForMap(
            "SELECT farmer_id FROM soil_advisory WHERE id=?", id);
        notifService.notifyAdvisoryResponded(((Number) sa.get("farmer_id")).intValue());
        ra.addFlashAttribute("successMsg", "Recommendation sent to farmer!");
        return "redirect:/agro/advisories";
    }

    @GetMapping("/profile")
    public String profile(Model m) {
        m.addAttribute("user", secUtil.getCurrentUser());
        return "agro/profile";
    }
}

// ═══════════════════════════════════════════════════════════════
//  Admin Controller
// ═══════════════════════════════════════════════════════════════
@Controller
@RequestMapping("/admin")
class AdminController {

    @Autowired private UserService userService;
    @Autowired private CropService cropService;
    @Autowired private OrderService orderService;
    @Autowired private NotificationService notifService;
    @Autowired private JdbcTemplate jdbc;

    private static final Set<String> VALID_ORDER_STATUSES =
        Set.of("PENDING", "CONFIRMED", "PACKED", "DISPATCHED", "DELIVERED", "CANCELLED");

    @GetMapping("/dashboard")
    public String dashboard(Model m) {
        m.addAttribute("totalFarmers",     userService.countFarmers());
        m.addAttribute("totalBuyers",      userService.countBuyers());
        m.addAttribute("totalSvc",         userService.countSvc());
        m.addAttribute("totalAgronomists", userService.countAgronomists());
        m.addAttribute("totalCrops",       cropService.totalCount());
        m.addAttribute("totalOrders",      orderService.totalCount());
        m.addAttribute("pendingAdvisory",  jdbc.queryForObject(
            "SELECT COUNT(*) FROM soil_advisory WHERE status='PENDING'", Integer.class));
        m.addAttribute("recentUsers",      jdbc.queryForList(
            "SELECT id,name,email,role,state,is_active FROM users ORDER BY created_at DESC LIMIT 10"));
        m.addAttribute("recentOrders",     orderService.getAll().stream().limit(10).toList());
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(@RequestParam(required = false) String role, Model m) {
        m.addAttribute("users", role != null && !role.isEmpty()
            ? userService.getByRole("ROLE_" + role)
            : userService.getAllUsers());
        m.addAttribute("selectedRole", role);
        return "admin/users";
    }

    /** Deactivate via POST to prevent accidental/CSRF deactivation via GET links */
    @PostMapping("/users/deactivate/{id}")
    public String deactivate(@PathVariable int id, RedirectAttributes ra) {
        userService.deactivate(id);
        ra.addFlashAttribute("successMsg", "User deactivated.");
        return "redirect:/admin/users";
    }

    @GetMapping("/crops")
    public String crops(Model m) {
        m.addAttribute("crops", cropService.getAll());
        return "admin/crops";
    }

    @GetMapping("/orders")
    public String orders(Model m) {
        m.addAttribute("orders", orderService.getAll());
        return "admin/orders";
    }

    @PostMapping("/orders/status/{id}")
    public String updateOrderStatus(@PathVariable int id,
                                    @RequestParam("status") String status,
                                    RedirectAttributes ra) {
        if (!VALID_ORDER_STATUSES.contains(status)) {
            ra.addFlashAttribute("errorMsg", "Invalid order status.");
            return "redirect:/admin/orders";
        }
        orderService.updateStatus(id, status);
        ra.addFlashAttribute("successMsg", "Order status updated.");
        return "redirect:/admin/orders";
    }

    @GetMapping("/advisories")
    public String advisories(Model m) {
        m.addAttribute("advisories", jdbc.queryForList(
            "SELECT sa.*, u.name AS farmer_name FROM soil_advisory sa " +
            "JOIN users u ON sa.farmer_id=u.id ORDER BY sa.submitted_at DESC"));
        return "admin/advisories";
    }

    @GetMapping("/schemes")
    public String schemes(Model m) {
        m.addAttribute("schemes", jdbc.queryForList(
            "SELECT * FROM govt_schemes ORDER BY scheme_name"));
        m.addAttribute("applications", jdbc.queryForList(
            "SELECT sa.*, gs.scheme_name, u.name AS farmer_name FROM scheme_applications sa " +
            "JOIN govt_schemes gs ON sa.scheme_id=gs.id " +
            "JOIN users u ON sa.farmer_id=u.id ORDER BY sa.applied_at DESC"));
        return "admin/schemes";
    }

    @PostMapping("/schemes/add")
    public String addScheme(@RequestParam("schemeName")  String schemeName,
                            @RequestParam("ministry")    String ministry,
                            @RequestParam("description") String description,
                            @RequestParam(value = "eligibility", required = false) String eligibility,
                            @RequestParam(value = "benefits",    required = false) String benefits,
                            @RequestParam(value = "applyUrl",    required = false) String applyUrl,
                            RedirectAttributes ra) {
        if (schemeName == null || schemeName.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Scheme name is required.");
            return "redirect:/admin/schemes";
        }
        jdbc.update(
            "INSERT INTO govt_schemes (scheme_name,ministry,description,eligibility,benefits,apply_url) VALUES (?,?,?,?,?,?)",
            schemeName.trim(), ministry, description, eligibility, benefits, applyUrl);
        ra.addFlashAttribute("successMsg", "Scheme added.");
        return "redirect:/admin/schemes";
    }

    /** Toggle a scheme's active status */
    @PostMapping("/schemes/toggle/{id}")
    public String toggleScheme(@PathVariable int id, RedirectAttributes ra) {
        jdbc.update("UPDATE govt_schemes SET is_active = NOT is_active WHERE id = ?", id);
        ra.addFlashAttribute("successMsg", "Scheme status toggled.");
        return "redirect:/admin/schemes";
    }

    @PostMapping("/schemes/update/{id}")
    public String updateSchemeApp(@PathVariable int id,
                                  @RequestParam("status") String status,
                                  @RequestParam(value = "remarks", required = false) String remarks,
                                  RedirectAttributes ra) {
        jdbc.update(
            "UPDATE scheme_applications SET status=?,remarks=? WHERE id=?", status, remarks, id);
        Map<String, Object> app = jdbc.queryForMap(
            "SELECT sa.farmer_id, gs.scheme_name FROM scheme_applications sa " +
            "JOIN govt_schemes gs ON sa.scheme_id=gs.id WHERE sa.id=?", id);
        notifService.notifySchemeUpdated(
            ((Number) app.get("farmer_id")).intValue(),
            (String) app.get("scheme_name"), status);
        ra.addFlashAttribute("successMsg", "Application status updated.");
        return "redirect:/admin/schemes";
    }

    @GetMapping("/prices")
    public String prices(Model m) {
        m.addAttribute("prices", jdbc.queryForList(
            "SELECT * FROM price_history ORDER BY recorded_date DESC LIMIT 100"));
        return "admin/prices";
    }

    @PostMapping("/prices/add")
    public String addPrice(@RequestParam("cropName")     String cropName,
                           @RequestParam("mspPrice")     double mspPrice,
                           @RequestParam("marketPrice")  double marketPrice,
                           @RequestParam("state")        String state,
                           RedirectAttributes ra) {
        if (cropName == null || cropName.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Crop name is required.");
            return "redirect:/admin/prices";
        }
        jdbc.update(
            "INSERT INTO price_history (crop_name,msp_price,market_price,state,recorded_date) VALUES (?,?,?,?,CURDATE())",
            cropName.trim(), mspPrice, marketPrice, state);
        ra.addFlashAttribute("successMsg", "Price record added.");
        return "redirect:/admin/prices";
    }

    @GetMapping("/svc-agents")
    public String svcAgents(Model m) {
        m.addAttribute("agents", jdbc.queryForList(
            "SELECT sa.*, u.name AS agent_name, u.email, u.phone, u.state " +
            "FROM svc_agents sa JOIN users u ON sa.user_id=u.id ORDER BY u.name"));
        m.addAttribute("svcUsers", jdbc.queryForList(
            "SELECT id, name FROM users WHERE role='ROLE_SVC' AND is_active=1 ORDER BY name"));
        return "admin/svc-agents";
    }

    @PostMapping("/svc-agents/register")
    public String registerSvc(@RequestParam int userId,
                              @RequestParam String centreName,
                              @RequestParam String villagesCovered,
                              RedirectAttributes ra) {
        if (centreName == null || centreName.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Centre name is required.");
            return "redirect:/admin/svc-agents";
        }
        jdbc.update(
            "INSERT INTO svc_agents (user_id,centre_name,villages_covered) VALUES (?,?,?)",
            userId, centreName.trim(), villagesCovered);
        ra.addFlashAttribute("successMsg", "SVC Agent registered.");
        return "redirect:/admin/svc-agents";
    }

    @PostMapping("/notify/broadcast")
    public String broadcast(@RequestParam("role")    String role,
                            @RequestParam("message") String message,
                            RedirectAttributes ra) {
        if (message == null || message.trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Message cannot be empty.");
            return "redirect:/admin/dashboard";
        }
        List<Map<String, Object>> users = jdbc.queryForList(
            "SELECT id FROM users WHERE role=? AND is_active=1", "ROLE_" + role);
        users.forEach(u -> notifService.send(
            ((Number) u.get("id")).intValue(), message.trim(), "BROADCAST"));
        ra.addFlashAttribute("successMsg",
            "Notification sent to " + users.size() + " " + role + "(s).");
        return "redirect:/admin/dashboard";
    }
}
