/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author daniel
 */
public class DBConnection {
    private static final String DB_URL = "jdbc:derby://localhost:1527/StudentProfileDB";
    private static final String DB_USER = "app";
    private static final String DB_PASSWORD = "app";
    
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
