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
public class Event implements Serializable {
    private int eventId;
    private String eventName;
    private String eventType;
    private Date eventDate;
    private String description;
    
    // constructors
    public Event() {}
    
    public Event(int eventId, String eventName, String eventType, Date eventDate, String description) {
        this.eventId = eventId;
        this.eventName = eventName;
        this.eventType = eventType;
        this.eventDate = eventDate;
        this.description = description;
    }
    
    // getters
    public int getEventId() { return eventId; }
    public String getEventName() { return eventName; }
    public String getEventType() { return eventType; }
    public java.util.Date getEventDate() { return eventDate; }
    public String getDescription() { return description; }

    // setters
    public void setEventId(int eventId) { this.eventId = eventId; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public void setEventType(String eventType) { this.eventType = eventType; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
    public void setDescription(String description) { this.description = description; }
}
