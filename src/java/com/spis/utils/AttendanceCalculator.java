/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.utils;

/**
 *
 * @author daniel
 */
public class AttendanceCalculator {
    public String getPercentage(int total, int hadir) {
        if (total == 0) return "0";
        double percentage = ((double) hadir / total) * 100;

        return String.format("%.0f", percentage);
    }
}
