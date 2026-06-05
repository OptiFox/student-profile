/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dao;

import com.spis.models.Student;
import com.spis.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;

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
    
    public static ArrayList<Student> getAllStudents() {
        ArrayList<Student> list = new ArrayList<>();
        String query = "SELECT * FROM Students ORDER BY grade_year ASC, class_name ASC, student_name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(new Student(
                    rs.getInt("student_id"),
                    rs.getString("student_name"),
                    rs.getString("mykid"),
                    rs.getString("gender"),
                    rs.getString("race"),
                    rs.getInt("grade_year"),
                    rs.getString("class_name"),
                    rs.getString("uniform_unit"),
                    rs.getString("club"),
                    rs.getString("sport"),
                    rs.getString("uniform_role"),
                    rs.getString("club_role"),
                    rs.getString("sport_role")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error fetching students: " + e.getMessage());
        }
        
        return list;
    }
}
