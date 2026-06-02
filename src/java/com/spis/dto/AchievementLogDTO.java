/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.dto;

import java.sql.Date;

/**
 *
 * @author daniel
 */
public class AchievementLogDTO {
    private int achievementId;
    private String eventName;
    private Date eventDate;
    private String studentName;
    private String compLevel;
    private String result;

    // getters
    public int getAchievementId() { return achievementId; }
    public String getEventName() { return eventName; }
    public Date getEventDate() { return eventDate; }
    public String getStudentName() { return studentName; }
    public String getCompLevel() { return compLevel; }
    public String getResult() { return result; }

    // setters
    public void setAchievementId(int achievementId) { this.achievementId = achievementId; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public void setCompLevel(String compLevel) { this.compLevel = compLevel; }
    public void setResult(String result) { this.result = result; }
}
