package com.gramsetu.service;

import com.gramsetu.dao.CropDAO;
import com.gramsetu.dao.OrderDAO;
import com.gramsetu.model.Crop;
import com.gramsetu.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class OrderService {

    @Autowired private OrderDAO orderDAO;
    @Autowired private CropDAO  cropDAO;

    @Transactional
    public int placeOrder(int buyerId, int cropId, BigDecimal qty, String payMethod, String address) {
        Crop crop = cropDAO.findById(cropId);
        if (crop == null || !crop.isAvailable())
            throw new RuntimeException("Crop is not available.");
        if (crop.getQuantity().compareTo(qty) < 0)
            throw new RuntimeException("Requested quantity (" + qty + ") exceeds available stock (" + crop.getQuantity() + ").");

        Order o = new Order();
        o.setBuyerId(buyerId);
        o.setCropId(cropId);
        o.setQuantity(qty);
        o.setTotalPrice(crop.getPricePerUnit().multiply(qty));
        o.setPaymentMethod(payMethod);
        o.setDeliveryAddress(address);

        int orderId = orderDAO.save(o);
        cropDAO.reduceQuantity(cropId, qty);
        return orderId;
    }

    public Order getById(int id)               { return orderDAO.findById(id); }
    public List<Order> getByBuyer(int bid)     { return orderDAO.findByBuyerId(bid); }
    public List<Order> getByFarmer(int fid)    { return orderDAO.findByFarmerId(fid); }
    public List<Order> getAll()                { return orderDAO.findAll(); }
    public int totalCount()                    { return orderDAO.totalCount(); }

    @Transactional
    public void updateStatus(int id, String status) { orderDAO.updateStatus(id, status); }

    @Transactional
    public void markPaid(int id) {
        orderDAO.updatePaymentStatus(id, "PAID");
        orderDAO.updateStatus(id, "CONFIRMED");
    }
}
