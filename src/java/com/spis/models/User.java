/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.models;

import java.io.Serializable;

/**
 *
 * @author daniel
 */
public class User implements Serializable {
    private int userId;
    private String username;
    private String password;
    private String role;
    private String assignedCategory;
    private String assignedUnit;
    
    // constructors
    public User() {}
    
    public User(int userId, String username, String password, String role, String assignedCategory, String assignedUnit) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.role = role;
        this.assignedCategory = assignedCategory;
        this.assignedUnit = assignedUnit;
    }
    
    // getters
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getAssignedCategory() { return assignedCategory; }
    public String getAssignedUnit() { return assignedUnit; }
    
    // setters
    public void setUserId(int userId) { this.userId = userId; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(String role) { this.role = role; }
    public void setAssignedCategory(String assignedCategory) { this.assignedCategory = assignedCategory; }
    public void setAssignedUnit(String assignedUnit) { this.assignedUnit = assignedUnit; }
}
