package com.gramsetu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NotificationService {

    @Autowired private JdbcTemplate jdbc;

    public void send(int userId, String message, String type) {
        jdbc.update("INSERT INTO notifications (user_id,message,type) VALUES (?,?,?)", userId, message, type);
    }

    public List<Map<String, Object>> getForUser(int userId) {
        return jdbc.queryForList(
            "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 25", userId);
    }

    public int countUnread(int userId) {
        Integer c = jdbc.queryForObject(
            "SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0", Integer.class, userId);
        return c != null ? c : 0;
    }

    public void markAllRead(int userId) {
        jdbc.update("UPDATE notifications SET is_read=1 WHERE user_id=?", userId);
    }

    public void notifyOrderPlaced(int farmerId, int buyerId, String cropName) {
        send(farmerId, "New order received for: " + cropName, "ORDER");
        send(buyerId,  "Your order for " + cropName + " placed successfully.", "ORDER");
    }

    public void notifyOrderUpdated(int buyerId, String cropName, String status) {
        send(buyerId, "Your order for " + cropName + " is now: " + status, "ORDER");
    }

    public void notifyAdvisoryResponded(int farmerId) {
        send(farmerId, "Your soil advisory request has received an expert response.", "ADVISORY");
    }

    public void notifySchemeUpdated(int farmerId, String scheme, String status) {
        send(farmerId, "Scheme application for " + scheme + " updated to: " + status, "SCHEME");
    }
}
