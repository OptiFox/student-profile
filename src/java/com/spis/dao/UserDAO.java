/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.models.User;
import com.spis.utils.DBConnection;
import com.spis.utils.SecurityUtils;
import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author daniel
 */
public class UserDAO {
    public static boolean addUser(User user) {
        String query = "INSERT INTO Users (username, password, role, assigned_category, assigned_unit) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getAssignedCategory());
            stmt.setString(5, user.getAssignedUnit());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error adding user: " + e.getMessage());
            return false;
        }
    }
    
    public static User authenticateUser(String username, String password) {
        String query = "SELECT * FROM Users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String savedHash = rs.getString("password");
                    
                    if (SecurityUtils.verifyPassword(password, savedHash)) {
                        return new User (
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            savedHash,
                            rs.getString("role"),
                            rs.getString("assigned_category"),
                            rs.getString("assigned_unit")
                        );
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error authenticating user: " + e.getMessage());
        }
        
        return null;
    }
    
    // get all supervisors for admin table
    public static ArrayList<User> getAllSupervisors() {
        ArrayList<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE role = 'SUPERVISOR' ORDER BY assigned_category, assigned_unit";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("assigned_category"),
                    rs.getString("assigned_unit")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error fetching supervisors: " + e.getMessage());
        }
        
        return list;
    }
}
