package com.gramsetu.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Crop {
    private int id;
    private int farmerId;
    private Integer svcAgentId;
    private String name;
    private String category;
    private BigDecimal quantity;
    private String unit;
    private BigDecimal pricePerUnit;
    private String description;
    private String photoUrl;
    private String state;
    private String district;
    private boolean available;
    private LocalDateTime listedAt;

    // Joined fields
    private String farmerName;
    private String farmerPhone;
    private String farmerVillage;

    public Crop() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getFarmerId() { return farmerId; }
    public void setFarmerId(int farmerId) { this.farmerId = farmerId; }
    public Integer getSvcAgentId() { return svcAgentId; }
    public void setSvcAgentId(Integer svcAgentId) { this.svcAgentId = svcAgentId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public BigDecimal getPricePerUnit() { return pricePerUnit; }
    public void setPricePerUnit(BigDecimal pricePerUnit) { this.pricePerUnit = pricePerUnit; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }
    public LocalDateTime getListedAt() { return listedAt; }
    public void setListedAt(LocalDateTime listedAt) { this.listedAt = listedAt; }
    public String getFarmerName() { return farmerName; }
    public void setFarmerName(String farmerName) { this.farmerName = farmerName; }
    public String getFarmerPhone() { return farmerPhone; }
    public void setFarmerPhone(String farmerPhone) { this.farmerPhone = farmerPhone; }
    public String getFarmerVillage() { return farmerVillage; }
    public void setFarmerVillage(String farmerVillage) { this.farmerVillage = farmerVillage; }
}
