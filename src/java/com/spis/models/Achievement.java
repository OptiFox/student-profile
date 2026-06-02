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
public class Achievement implements Serializable {
    private int achievementId;
    private int studentId;
    private int eventId;
    private String compLevel;
    private String result;
    private String recordedBy;

    // constructors
    public Achievement() {}

    public Achievement(int achievementId, int studentId, int eventId, 
                       String compLevel, String result, String recordedBy) {
        this.achievementId = achievementId;
        this.studentId = studentId;
        this.eventId = eventId;
        this.compLevel = compLevel;
        this.result = result;
        this.recordedBy = recordedBy;
    }

    // getters
    public int getAchievementId() { return achievementId; }
    public int getStudentId() { return studentId; }
    public int getEventId() { return eventId; }
    public String getCompLevel() { return compLevel; }
    public String getResult() { return result; }
    public String getRecordedBy() { return recordedBy; }

    // setters
    public void setAchievementId(int achievementId) { this.achievementId = achievementId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public void setCompLevel(String compLevel) { this.compLevel = compLevel; }
    public void setResult(String result) { this.result = result; }
    public void setRecordedBy(String recordedBy) { this.recordedBy = recordedBy; }
}
