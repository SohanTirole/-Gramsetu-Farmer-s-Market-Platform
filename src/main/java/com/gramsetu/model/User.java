package com.gramsetu.model;

import java.time.LocalDateTime;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;
    private String village;
    private String district;
    private String state;
    private String aadhaar;
    private boolean active;
    private LocalDateTime createdAt;

    public User() {}

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getVillage() { return village; }
    public void setVillage(String village) { this.village = village; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getAadhaar() { return aadhaar; }
    public void setAadhaar(String aadhaar) { this.aadhaar = aadhaar; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getDisplayRole() {
        return role == null ? "" : role.replace("ROLE_", "");
    }
    public String getInitials() {
        return (name != null && !name.isEmpty()) ? String.valueOf(name.charAt(0)).toUpperCase() : "?";
    }
}
