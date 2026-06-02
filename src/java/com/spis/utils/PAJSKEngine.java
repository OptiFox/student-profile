/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author daniel
 */
public class PAJSKEngine {
    // Attendance (Kehadiran)
    public int getAttendanceScore(int totalMeetings, int totalAttended) {
        if (totalMeetings == 0) return 0;
        
        double percentage = ((double) totalAttended / totalMeetings);
        return (int) Math.round(percentage * 50);
    }
    
    // Roles (Jawatan)
    public int getRoleScore(String r1, String r2, String r3) {
        String[] roles = {
            r1 != null ? r1 : "",
            r2 != null ? r2 : "",
            r3 != null ? r3 : ""
        };
        
        int maxScore = 1; // Default Ahli Biasa
        
        for (String r : roles) {
            if (r.equalsIgnoreCase("Pengerusi")) maxScore = Math.max(maxScore, 10);
            else if (r.equalsIgnoreCase("Naib Pengerusi")) maxScore = Math.max(maxScore, 8);
            else if (r.equalsIgnoreCase("Setiausaha") || r.equalsIgnoreCase("Bendahari")) maxScore = Math.max(maxScore, 6);
            else if (r.equalsIgnoreCase("Penolong Setiausaha") || r.equalsIgnoreCase("Penolong Bendahari")) maxScore = Math.max(maxScore, 5);
            else if (r.equalsIgnoreCase("Ahli Jawatankuasa (AJK)")) maxScore = Math.max(maxScore, 4);
        }
        
        return maxScore;
    }
    
    // Involvement (Penglibatan)
    public int getInvolvementScore(int totalAttended) {
        if (totalAttended >= 10) return 20;
        if (totalAttended >= 5) return 15;
        if (totalAttended > 0) return 10;
        return 0;
    }
    
    // Achievement (Pencapaian)
    public int getAchievementScore(Connection conn, int studentId) {
        int maxScore = 0;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            stmt = conn.prepareStatement("SELECT result FROM Achievements WHERE student_id = ?");
            stmt.setInt(1, studentId);
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                String result = rs.getString("result");
                
                if (result.equalsIgnoreCase("Johan")) maxScore = Math.max(maxScore, 20);
                else if (result.equalsIgnoreCase("Naib Johan")) maxScore = Math.max(maxScore, 15);
                else if (result.equalsIgnoreCase("Ketiga")) maxScore = Math.max(maxScore, 10);
                else maxScore = Math.max(maxScore, 5);
            }
        } catch (Exception e) {
            System.out.println("Error in PAJSKEngine (Achievements): " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (Exception e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return maxScore;
    }
    
    public String getGrade(int totalScore) {
        if (totalScore >= 80) return "A";
        if (totalScore >= 60) return "B";
        if (totalScore >= 40) return "C";
        if (totalScore >= 20) return "D";
        return "E";
    }
}
