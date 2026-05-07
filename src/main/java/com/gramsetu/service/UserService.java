package com.gramsetu.service;

import com.gramsetu.dao.UserDAO;
import com.gramsetu.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserService {

    @Autowired private UserDAO userDAO;
    @Autowired private BCryptPasswordEncoder passwordEncoder;

    @Transactional
    public int register(User user) {
        if (userDAO.emailExists(user.getEmail()))
            throw new RuntimeException("Email already registered: " + user.getEmail());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userDAO.save(user);
    }

    public User getById(int id)            { return userDAO.findById(id); }
    public User getByEmail(String email)   { return userDAO.findByEmail(email); }
    public List<User> getAllUsers()         { return userDAO.findAll(); }
    public List<User> getByRole(String r)  { return userDAO.findByRole(r); }
    public boolean emailExists(String e)   { return userDAO.emailExists(e); }

    @Transactional
    public void updateProfile(User u) { userDAO.update(u); }

    @Transactional
    public boolean changePassword(int id, String oldPw, String newPw) {
        User u = userDAO.findById(id);
        if (u == null || !passwordEncoder.matches(oldPw, u.getPassword())) return false;
        userDAO.updatePassword(id, passwordEncoder.encode(newPw));
        return true;
    }

    @Transactional
    public void deactivate(int id) { userDAO.deactivate(id); }

    public int countFarmers()     { return userDAO.countByRole("ROLE_FARMER"); }
    public int countBuyers()      { return userDAO.countByRole("ROLE_BUYER"); }
    public int countSvc()         { return userDAO.countByRole("ROLE_SVC"); }
    public int countAgronomists() { return userDAO.countByRole("ROLE_AGRONOMIST"); }
}
