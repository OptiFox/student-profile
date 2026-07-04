/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.models.Event;
import com.spis.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;

/**
 *s
 * @author daniel
 */
public class EventDAO {
    public static boolean addEvent(Event event) {
        String query = "INSERT INTO Events (event_name, event_type, event_date, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, event.getEventName());
            stmt.setString(2, event.getEventType());
            stmt.setDate(3, event.getEventDate());
            stmt.setString(4, event.getDescription());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error adding event: " + e.getMessage());
            return false;
        }
    }
    
    public static ArrayList<Event> getAllEvents() {
        ArrayList<Event> list = new ArrayList<>();
        String query = "SELECT * FROM Events ORDER BY event_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Event event = new Event();
                
                event.setEventId(rs.getInt("event_id"));
                event.setEventName(rs.getString("event_name"));
                event.setEventType(rs.getString("event_type"));
                event.setDescription(rs.getString("description"));
                event.setEventDate(rs.getDate("event_date"));
                
                list.add(event);
            }
        } catch (Exception e) {
            System.out.println("Error in EventDAO.getAllEvents: " + e.getMessage());
        }
        
        return list;
    }
}
