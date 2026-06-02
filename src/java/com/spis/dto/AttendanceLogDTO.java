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
public class AttendanceLogDTO {
    private int attendanceId;
    private Date meetDate;
    private String activityTitle;
    private String studentName;
    private String classInfo;
    private String status;

    // getters
    public int getAttendanceId() { return attendanceId; }
    public Date getMeetDate() { return meetDate; }
    public String getActivityTitle() { return activityTitle; }
    public String getStudentName() { return studentName; }
    public String getClassInfo() { return classInfo; }
    public String getStatus() { return status; }

    // setters
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }
    public void setMeetDate(Date meetDate) { this.meetDate = meetDate; }
    public void setActivityTitle(String activityTitle) { this.activityTitle = activityTitle; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public void setClassInfo(String classInfo) { this.classInfo = classInfo; }
    public void setStatus(String status) { this.status = status; }
}
