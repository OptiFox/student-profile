/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.models.Student;
import com.spis.utils.DBConnection;
import java.sql.*;

/**
 *
 * @author daniel
 */
public class StudentDAO {
    public static boolean addStudent(Student student) {
        String query = "INSERT INTO Students (student_name, mykid, gender, race, grade_year, class_name, uniform_unit, club, sport) "
                     + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, student.getStudentName());
            stmt.setString(2, student.getMykid());
            stmt.setString(3, student.getGender());
            stmt.setString(4, student.getRace());
            stmt.setInt(5, student.getGradeYear());
            stmt.setString(6, student.getClassName());
            stmt.setString(7, student.getUniformUnit());
            stmt.setString(8, student.getClub());
            stmt.setString(9, student.getSport());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error adding student: " + e.getMessage());
            return false;
        }
    }
}
