package com.gramsetu.controller;

import com.gramsetu.model.User;
import com.gramsetu.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Set;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired private UserService userService;

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Set<String> ALLOWED_ROLES = Set.of(
        "ROLE_FARMER", "ROLE_BUYER", "ROLE_SVC", "ROLE_AGRONOMIST", "ROLE_NGO");

    @GetMapping("/login")
    public String login(@RequestParam(required = false) String error,
                        @RequestParam(required = false) String logout,
                        @RequestParam(required = false) String expired,
                        Model m) {
        if (error   != null) m.addAttribute("errorMsg", "Invalid email or password.");
        if (logout  != null) m.addAttribute("successMsg", "You have been logged out.");
        if (expired != null) m.addAttribute("errorMsg", "Session expired. Please login again.");
        return "common/login";
    }

    @GetMapping("/register")
    public String registerForm(Model m) {
        m.addAttribute("user", new User());
        return "common/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user,
                           @RequestParam("confirmPassword") String confirmPassword,
                           RedirectAttributes ra) {

        // Name validation
        if (user.getName() == null || user.getName().trim().isEmpty()) {
            ra.addFlashAttribute("errorMsg", "Full name is required.");
            return "redirect:/auth/register";
        }

        // Email validation
        if (user.getEmail() == null || !EMAIL_PATTERN.matcher(user.getEmail().trim()).matches()) {
            ra.addFlashAttribute("errorMsg", "Please enter a valid email address.");
            return "redirect:/auth/register";
        }

        // Password validation
        if (user.getPassword() == null || user.getPassword().length() < 6) {
            ra.addFlashAttribute("errorMsg", "Password must be at least 6 characters.");
            return "redirect:/auth/register";
        }
        if (!user.getPassword().equals(confirmPassword)) {
            ra.addFlashAttribute("errorMsg", "Passwords do not match.");
            return "redirect:/auth/register";
        }

        // Role validation — prevent users from self-assigning ADMIN
        if (user.getRole() == null || !ALLOWED_ROLES.contains(user.getRole())) {
            ra.addFlashAttribute("errorMsg", "Please select a valid role.");
            return "redirect:/auth/register";
        }

        // Sanitize inputs
        user.setName(user.getName().trim());
        user.setEmail(user.getEmail().trim().toLowerCase());

        try {
            userService.register(user);
            ra.addFlashAttribute("successMsg", "Registration successful! Please login.");
            return "redirect:/auth/login";
        } catch (RuntimeException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/auth/register";
        }
    }
}
