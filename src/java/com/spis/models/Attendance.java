/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.models;

import java.io.Serializable;
import java.sql.Date;

/**
 *
 * @author daniel
 */
public class Attendance implements Serializable {
    private int attendanceId;
    private int studentId;
    private String unitName;
    private Date meetDate;
    private String activityTitle;
    private String extraNotes;
    private String status;

    // constructors
    public Attendance() {}

    public Attendance(int attendanceId, int studentId, String unitName, Date meetDate, 
                      String activityTitle, String extraNotes, String status) {
        this.attendanceId = attendanceId;
        this.studentId = studentId;
        this.unitName = unitName;
        this.meetDate = meetDate;
        this.activityTitle = activityTitle;
        this.extraNotes = extraNotes;
        this.status = status;
    }

    // getters
    public int getAttendanceId() { return attendanceId; }
    public int getStudentId() { return studentId; }
    public String getUnitName() { return unitName; }
    public Date getMeetDate() { return meetDate; }
    public String getActivityTitle() { return activityTitle; }
    public String getExtraNotes() { return extraNotes; }
    public String getStatus() { return status; }

    // setters
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public void setUnitName(String unitName) { this.unitName = unitName; }
    public void setMeetDate(Date meetDate) { this.meetDate = meetDate; }
    public void setActivityTitle(String activityTitle) { this.activityTitle = activityTitle; }
    public void setExtraNotes(String extraNotes) { this.extraNotes = extraNotes; }
    public void setStatus(String status) { this.status = status; }
}
