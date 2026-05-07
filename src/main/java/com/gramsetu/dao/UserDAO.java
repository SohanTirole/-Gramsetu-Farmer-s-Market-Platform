package com.gramsetu.dao;

import com.gramsetu.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class UserDAO {

    @Autowired private JdbcTemplate jdbc;

    private final RowMapper<User> mapper = (rs, rn) -> {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setVillage(rs.getString("village"));
        u.setDistrict(rs.getString("district"));
        u.setState(rs.getString("state"));
        u.setAadhaar(rs.getString("aadhaar"));
        u.setActive(rs.getInt("is_active") == 1);
        if (rs.getTimestamp("created_at") != null)
            u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return u;
    };

    public User findByEmail(String email) {
        try { return jdbc.queryForObject("SELECT * FROM users WHERE email=? AND is_active=1", mapper, email); }
        catch (EmptyResultDataAccessException e) { return null; }
    }

    public User findById(int id) {
        try { return jdbc.queryForObject("SELECT * FROM users WHERE id=?", mapper, id); }
        catch (EmptyResultDataAccessException e) { return null; }
    }

    public int save(User u) {
        jdbc.update("INSERT INTO users (name,email,password,phone,role,village,district,state,aadhaar,is_active) VALUES (?,?,?,?,?,?,?,?,?,1)",
            u.getName(), u.getEmail(), u.getPassword(), u.getPhone(), u.getRole(),
            u.getVillage(), u.getDistrict(), u.getState(), u.getAadhaar());
        return jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
    }

    public void update(User u) {
        jdbc.update("UPDATE users SET name=?,phone=?,village=?,district=?,state=? WHERE id=?",
            u.getName(), u.getPhone(), u.getVillage(), u.getDistrict(), u.getState(), u.getId());
    }

    public void updatePassword(int id, String encoded) {
        jdbc.update("UPDATE users SET password=? WHERE id=?", encoded, id);
    }

    public boolean emailExists(String email) {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM users WHERE email=?", Integer.class, email);
        return c != null && c > 0;
    }

    public List<User> findAll() {
        return jdbc.query("SELECT * FROM users ORDER BY created_at DESC", mapper);
    }

    public List<User> findByRole(String role) {
        return jdbc.query("SELECT * FROM users WHERE role=? AND is_active=1 ORDER BY name", mapper, role);
    }

    public void deactivate(int id) { jdbc.update("UPDATE users SET is_active=0 WHERE id=?", id); }

    public int countByRole(String role) {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM users WHERE role=? AND is_active=1", Integer.class, role);
        return c != null ? c : 0;
    }
}
