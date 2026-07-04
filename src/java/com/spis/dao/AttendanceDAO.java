/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.utils.DBConnection;
import com.spis.dto.AttendanceLogDTO;
import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author daniel
 */
public class AttendanceDAO {
    // fetch recent attendance to list
    public static ArrayList<AttendanceLogDTO> getRecentAttendance(String unitName) {
        ArrayList<AttendanceLogDTO> list = new ArrayList<>();
        String query = "SELECT a.attendance_id, a.meet_date, a.activity_title, s.student_name, s.grade_year, s.class_name, a.status "
                + "FROM Attendance a, Students s "
                + "WHERE a.student_id = s.student_id "
                + "AND a.unit_name = ? "
                + "ORDER BY a.meet_date DESC, s.student_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, unitName);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AttendanceLogDTO dto = new AttendanceLogDTO();
                    
                    dto.setAttendanceId(rs.getInt("attendance_id"));
                    dto.setMeetDate(rs.getDate("meet_date"));
                    dto.setActivityTitle(rs.getString("activity_title"));
                    dto.setStudentName(rs.getString("student_name"));
                    dto.setClassInfo(rs.getInt("grade_year") + " " + rs.getString("class_name"));
                    dto.setStatus(rs.getString("status"));

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            System.out.println("Error in AttendanceDAO.getRecentAttendance: " + e.getMessage());
        }
        
        return list;
    }
    
    public static boolean saveAttendanceBatch(ArrayList<com.spis.models.Attendance> records) throws Exception {
        String insertQuery = "INSERT INTO Attendance (student_id, unit_name, meet_date, activity_title, extra_notes, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
             
            for (com.spis.models.Attendance record : records) {
                stmt.setInt(1, record.getStudentId());
                stmt.setString(2, record.getUnitName());
                stmt.setDate(3, record.getMeetDate());
                stmt.setString(4, record.getActivityTitle());
                stmt.setString(5, record.getExtraNotes());
                stmt.setString(6, record.getStatus());
                
                stmt.addBatch(); // Queue it up
            }
            
            int[] results = stmt.executeBatch(); // Fire them all at once
            return results.length > 0;
        }
    }
    
    public static int[] getAttendanceStats(int studentId) {
        int[] stats = new int[]{0, 0}; // Index 0 = Total Meets, Index 1 = Total Attended
        String query = "SELECT COUNT(attendance_id) AS total_meet, "
                     + "COUNT(CASE WHEN status='Hadir' THEN 1 END) AS total_hadir "
                     + "FROM Attendance WHERE student_id = ?";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
             stmt.setInt(1, studentId);
             try (ResultSet rs = stmt.executeQuery()) {
                 if (rs.next()) {
                     stats[0] = rs.getInt("total_meet");
                     stats[1] = rs.getInt("total_hadir");
                 }
             }
        } catch (Exception e) {
             System.out.println("Error fetching attendance stats: " + e.getMessage());
        }
        return stats;
    }
    
    // delete a specific attendance entry for undo function
    public static boolean deleteAttendance(int attendanceId) {
        String query = "DELETE FROM Attendance WHERE attendance_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);) {
            
            stmt.setInt(1, attendanceId);
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in AttendanceDAO.deleteAttendance: " + e.getMessage());
            return false;
        }
    }
}
