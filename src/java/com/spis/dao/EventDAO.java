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
 *
 * @author daniel
 */
public class EventDAO {
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
                event.setEventDate(rs.getDate("event_date"));
                
                list.add(event);
            }
        } catch (Exception e) {
            System.out.println("Error in EventDAO.getAllEvents: " + e.getMessage());
        }
        
        return list;
    }
}
