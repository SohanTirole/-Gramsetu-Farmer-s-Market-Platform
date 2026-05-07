package com.gramsetu.controller;

import com.gramsetu.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired private CropService cropService;
    @Autowired private UserService userService;
    @Autowired private OrderService orderService;
    @Autowired private JdbcTemplate jdbc;

    @GetMapping({"/", "/home"})
    public String home(Model m) {
        m.addAttribute("recentCrops",  cropService.getAll().stream().limit(8).toList());
        m.addAttribute("totalFarmers", userService.countFarmers());
        m.addAttribute("totalCrops",   cropService.totalCount());
        m.addAttribute("totalOrders",  orderService.totalCount());
        m.addAttribute("totalSvc",     userService.countSvc());
        return "common/home";
    }

    @GetMapping("/crops/list")
    public String cropList(@RequestParam(required=false) String keyword,
                           @RequestParam(required=false) String category,
                           @RequestParam(required=false) String state,
                           Model m) {
        m.addAttribute("crops",    cropService.search(keyword, category, state));
        m.addAttribute("keyword",  keyword);
        m.addAttribute("category", category);
        m.addAttribute("state",    state);
        return "common/crop-list";
    }

    @GetMapping("/crops/detail/{id}")
    public String cropDetail(@PathVariable int id, Model m) {
        m.addAttribute("crop", cropService.getById(id));
        return "common/crop-detail";
    }

    @GetMapping("/schemes")
    public String schemes(Model m) {
        m.addAttribute("schemes", jdbc.queryForList("SELECT * FROM govt_schemes WHERE is_active=1 ORDER BY scheme_name"));
        return "common/schemes";
    }

    @GetMapping("/prices")
    public String prices(@RequestParam(required=false) String state, Model m) {
        List<Map<String,Object>> prices;
        if (state != null && !state.isEmpty()) {
            prices = jdbc.queryForList("SELECT * FROM price_history WHERE state=? ORDER BY recorded_date DESC LIMIT 50", state);
        } else {
            prices = jdbc.queryForList("SELECT * FROM price_history ORDER BY recorded_date DESC LIMIT 50");
        }
        m.addAttribute("prices", prices);
        m.addAttribute("selectedState", state);
        return "common/price-trends";
    }

    @GetMapping("/forum")
    public String forum(@RequestParam(required=false) String category, Model m) {
        String sql = "SELECT fp.*, u.name AS author_name, u.role AS author_role, " +
                     "(SELECT COUNT(*) FROM forum_replies fr WHERE fr.post_id=fp.id) AS reply_count " +
                     "FROM forum_posts fp JOIN users u ON fp.user_id=u.id ";
        List<Map<String,Object>> posts;
        if (category != null && !category.isEmpty()) {
            posts = jdbc.queryForList(sql + "WHERE fp.category=? ORDER BY fp.created_at DESC", category);
        } else {
            posts = jdbc.queryForList(sql + "ORDER BY fp.created_at DESC");
        }
        m.addAttribute("posts", posts);
        m.addAttribute("selectedCategory", category);
        return "common/forum";
    }

    @GetMapping("/forum/post/{id}")
    public String forumPost(@PathVariable int id, Model m) {
        m.addAttribute("post", jdbc.queryForMap(
            "SELECT fp.*, u.name AS author_name, u.role AS author_role " +
            "FROM forum_posts fp JOIN users u ON fp.user_id=u.id WHERE fp.id=?", id));
        m.addAttribute("replies", jdbc.queryForList(
            "SELECT fr.*, u.name AS author_name, u.role AS author_role " +
            "FROM forum_replies fr JOIN users u ON fr.user_id=u.id " +
            "WHERE fr.post_id=? ORDER BY fr.created_at", id));
        return "common/forum-post";
    }
}
