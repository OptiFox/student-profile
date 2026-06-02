/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.utils.DBConnection;
import com.spis.dto.AchievementLogDTO;
import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author daniel
 */
public class AchievementDAO {
    // fetch all achievements recorded by supervisors
    public static ArrayList<AchievementLogDTO> getAchievementsByRecorder(String username) {
        ArrayList<AchievementLogDTO> list = new ArrayList<>();
        String query = "SELECT a.achievement_id, e.event_name, e.event_date, s.student_name, a.comp_level, a.result " 
                + "FROM Achievements a, Events e, Students s "
                + "WHERE a.event_id = e.event_id " 
                + "AND a.student_id = s.student_id " 
                + "AND a.recorded_by = ? " 
                + "ORDER BY e.event_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AchievementLogDTO dto = new AchievementLogDTO();
                    
                    dto.setAchievementId(rs.getInt("attendance_id"));
                    dto.setEventName(rs.getString("event_name"));
                    dto.setEventDate(rs.getDate("event_date"));
                    dto.setStudentName(rs.getString("student_name"));
                    dto.setCompLevel(rs.getString("comp_level"));
                    dto.setResult(rs.getString("result"));
                    
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            System.out.println("Error in AchievementDAO.getAchievementsByRecorder: " + e.getMessage());
        }
        
        return list;
    }
    
    public static boolean deleteAchievement(int achievementId) {
        String query = "DELETE FROM Achievements WHERE achievement_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, achievementId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
