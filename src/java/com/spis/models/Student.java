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
public class Student implements Serializable {
    private int studentId;
    private String studentName;
    private String mykid;
    private String gender;
    private String race;
    private int gradeYear;
    private String className;
    private String uniformUnit;
    private String club;
    private String sport;
    private String uniformRole;
    private String clubRole;
    private String sportRole;
    
    // constructors
    public Student() {}
    
    public Student(int studentId, String studentName, String mykid, String gender, 
            String race, int gradeYear, String className, 
            String uniformUnit, String club, String sport, 
            String uniformRole, String clubRole, String sportRole) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.mykid = mykid;
        this.gender = gender;
        this.race = race;
        this.gradeYear = gradeYear;
        this.className = className;
        this.uniformUnit = uniformUnit;
        this.club = club;
        this.sport = sport;
        this.uniformRole = uniformRole;
        this.clubRole = clubRole;
        this.sportRole = sportRole;
    }
    
    // getters
    public int getStudentId() { return studentId; }
    public String getStudentName() { return studentName; }
    public String getMykid() { return mykid; }
    public String getGender() { return gender; }
    public String getRace() { return race; }
    public int getGradeYear() { return gradeYear; }
    public String getClassName() { return className; }
    public String getUniformUnit() { return uniformUnit; }
    public String getClub() { return club; }
    public String getSport() { return sport; }
    public String getUniformRole() { return uniformRole; }
    public String getClubRole() { return clubRole; }
    public String getSportRole() { return sportRole; }
    
    // setters
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public void setMykid(String mykid) { this.mykid = mykid; }
    public void setGender(String gender) { this.gender = gender; }
    public void setRace(String race) { this.race = race; }
    public void setGradeYear(int gradeYear) { this.gradeYear = gradeYear; }
    public void setClassName(String className) { this.className = className; }
    public void setUniformUnit(String uniformUnit) { this.uniformUnit = uniformUnit; }
    public void setClub(String club) { this.club = club; }
    public void setSport(String sport) { this.sport = sport; }
    public void setUniformRole(String uniformRole) { this.uniformRole = uniformRole; }
    public void setClubRole(String clubRole) { this.clubRole = clubRole; }
    public void setSportRole(String sportRole) { this.sportRole = sportRole; }
}
