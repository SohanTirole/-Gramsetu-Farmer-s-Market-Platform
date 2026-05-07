package com.gramsetu.util;

import com.gramsetu.dao.UserDAO;
import com.gramsetu.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class SecurityUtil {

    @Autowired
    private UserDAO userDAO;

    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) return null;
        return userDAO.findByEmail(auth.getName());
    }

    public int getCurrentUserId() {
        User u = getCurrentUser();
        return u != null ? u.getId() : -1;
    }

    public String getCurrentUserRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null) return null;
        return auth.getAuthorities().stream().findFirst().map(Object::toString).orElse(null);
    }
}
