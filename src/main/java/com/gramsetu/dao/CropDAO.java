package com.gramsetu.dao;

import com.gramsetu.model.Crop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class CropDAO {

    @Autowired private JdbcTemplate jdbc;

    private static final String JOIN =
        "SELECT c.*, u.name AS farmer_name, u.phone AS farmer_phone, u.village AS farmer_village " +
        "FROM crops c JOIN users u ON c.farmer_id=u.id ";

    private final RowMapper<Crop> mapper = (rs, rn) -> {
        Crop c = new Crop();
        c.setId(rs.getInt("id"));
        c.setFarmerId(rs.getInt("farmer_id"));
        c.setSvcAgentId((Integer) rs.getObject("svc_agent_id"));
        c.setName(rs.getString("name"));
        c.setCategory(rs.getString("category"));
        c.setQuantity(rs.getBigDecimal("quantity"));
        c.setUnit(rs.getString("unit"));
        c.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
        c.setDescription(rs.getString("description"));
        c.setPhotoUrl(rs.getString("photo_url"));
        c.setState(rs.getString("state"));
        c.setDistrict(rs.getString("district"));
        c.setAvailable(rs.getInt("is_available") == 1);
        if (rs.getTimestamp("listed_at") != null)
            c.setListedAt(rs.getTimestamp("listed_at").toLocalDateTime());
        try { c.setFarmerName(rs.getString("farmer_name")); } catch (Exception ignored) {}
        try { c.setFarmerPhone(rs.getString("farmer_phone")); } catch (Exception ignored) {}
        try { c.setFarmerVillage(rs.getString("farmer_village")); } catch (Exception ignored) {}
        return c;
    };

    public List<Crop> findAll() {
        return jdbc.query(JOIN + "WHERE c.is_available=1 ORDER BY c.listed_at DESC", mapper);
    }

    /**
     * Safe parameterized search — no SQL injection risk.
     */
    public List<Crop> search(String keyword, String category, String state) {
        StringBuilder sql = new StringBuilder(JOIN + "WHERE c.is_available=1");
        List<Object> params = new ArrayList<>();

        if (keyword  != null && !keyword.trim().isEmpty()) {
            sql.append(" AND c.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND c.category = ?");
            params.add(category.trim());
        }
        if (state    != null && !state.trim().isEmpty()) {
            sql.append(" AND c.state = ?");
            params.add(state.trim());
        }
        sql.append(" ORDER BY c.listed_at DESC");
        return jdbc.query(sql.toString(), mapper, params.toArray());
    }

    public Crop findById(int id) {
        try { return jdbc.queryForObject(JOIN + "WHERE c.id=?", mapper, id); }
        catch (EmptyResultDataAccessException e) { return null; }
    }

    public List<Crop> findByFarmerId(int fid) {
        return jdbc.query(JOIN + "WHERE c.farmer_id=? ORDER BY c.listed_at DESC", mapper, fid);
    }

    public int save(Crop c) {
        jdbc.update(
            "INSERT INTO crops (farmer_id,svc_agent_id,name,category,quantity,unit,price_per_unit,description,photo_url,state,district,is_available) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,1)",
            c.getFarmerId(), c.getSvcAgentId(), c.getName(), c.getCategory(), c.getQuantity(),
            c.getUnit(), c.getPricePerUnit(), c.getDescription(), c.getPhotoUrl(),
            c.getState(), c.getDistrict());
        return jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
    }

    public void update(Crop c) {
        jdbc.update(
            "UPDATE crops SET name=?,category=?,quantity=?,unit=?,price_per_unit=?,description=?,photo_url=?,is_available=? " +
            "WHERE id=? AND farmer_id=?",
            c.getName(), c.getCategory(), c.getQuantity(), c.getUnit(), c.getPricePerUnit(),
            c.getDescription(), c.getPhotoUrl(), c.isAvailable() ? 1 : 0, c.getId(), c.getFarmerId());
    }

    public void reduceQuantity(int cropId, java.math.BigDecimal qty) {
        jdbc.update("UPDATE crops SET quantity = quantity - ? WHERE id = ?", qty, cropId);
        jdbc.update("UPDATE crops SET is_available = 0 WHERE id = ? AND quantity <= 0", cropId);
    }

    public void delete(int cropId, int farmerId) {
        jdbc.update("DELETE FROM crops WHERE id=? AND farmer_id=?", cropId, farmerId);
    }

    public int countByFarmerId(int fid) {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM crops WHERE farmer_id=?", Integer.class, fid);
        return c != null ? c : 0;
    }

    public int totalCount() {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM crops", Integer.class);
        return c != null ? c : 0;
    }
}
