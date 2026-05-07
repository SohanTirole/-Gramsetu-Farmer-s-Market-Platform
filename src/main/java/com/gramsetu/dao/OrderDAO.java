package com.gramsetu.dao;

import com.gramsetu.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class OrderDAO {

    @Autowired private JdbcTemplate jdbc;

    private static final String JOIN =
        "SELECT o.*, b.name AS buyer_name, b.phone AS buyer_phone, " +
        "c.name AS crop_name, f.name AS farmer_name, f.phone AS farmer_phone " +
        "FROM orders o " +
        "JOIN users b  ON o.buyer_id=b.id " +
        "JOIN crops c  ON o.crop_id=c.id " +
        "JOIN users f  ON c.farmer_id=f.id ";

    private final RowMapper<Order> mapper = (rs, rn) -> {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setBuyerId(rs.getInt("buyer_id"));
        o.setCropId(rs.getInt("crop_id"));
        o.setQuantity(rs.getBigDecimal("quantity"));
        o.setTotalPrice(rs.getBigDecimal("total_price"));
        o.setStatus(rs.getString("status"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        if (rs.getTimestamp("ordered_at")   != null) o.setOrderedAt(rs.getTimestamp("ordered_at").toLocalDateTime());
        if (rs.getTimestamp("delivered_at") != null) o.setDeliveredAt(rs.getTimestamp("delivered_at").toLocalDateTime());
        try { o.setBuyerName(rs.getString("buyer_name")); }   catch (Exception ignored) {}
        try { o.setBuyerPhone(rs.getString("buyer_phone")); }  catch (Exception ignored) {}
        try { o.setCropName(rs.getString("crop_name")); }      catch (Exception ignored) {}
        try { o.setFarmerName(rs.getString("farmer_name")); }  catch (Exception ignored) {}
        try { o.setFarmerPhone(rs.getString("farmer_phone")); } catch (Exception ignored) {}
        return o;
    };

    public int save(Order o) {
        jdbc.update("INSERT INTO orders (buyer_id,crop_id,quantity,total_price,payment_method,delivery_address) VALUES (?,?,?,?,?,?)",
            o.getBuyerId(), o.getCropId(), o.getQuantity(), o.getTotalPrice(), o.getPaymentMethod(), o.getDeliveryAddress());
        return jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
    }

    public Order findById(int id) {
        try { return jdbc.queryForObject(JOIN + "WHERE o.id=?", mapper, id); }
        catch (EmptyResultDataAccessException e) { return null; }
    }

    public List<Order> findByBuyerId(int bid) {
        return jdbc.query(JOIN + "WHERE o.buyer_id=? ORDER BY o.ordered_at DESC", mapper, bid);
    }

    public List<Order> findByFarmerId(int fid) {
        return jdbc.query(JOIN + "WHERE f.id=? ORDER BY o.ordered_at DESC", mapper, fid);
    }

    public List<Order> findAll() {
        return jdbc.query(JOIN + "ORDER BY o.ordered_at DESC", mapper);
    }

    public void updateStatus(int id, String status) {
        jdbc.update("UPDATE orders SET status=? WHERE id=?", status, id);
        if ("DELIVERED".equals(status)) jdbc.update("UPDATE orders SET delivered_at=NOW() WHERE id=?", id);
    }

    public void updatePaymentStatus(int id, String ps) {
        jdbc.update("UPDATE orders SET payment_status=? WHERE id=?", ps, id);
    }

    public int countByBuyerId(int bid) {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM orders WHERE buyer_id=?", Integer.class, bid);
        return c != null ? c : 0;
    }

    public int totalCount() {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM orders", Integer.class);
        return c != null ? c : 0;
    }
}
