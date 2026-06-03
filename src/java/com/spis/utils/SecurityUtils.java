/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.spis.utils;

import com.password4j.Password;

/**
 *
 * @author daniel
 */
public class SecurityUtils {
    // hash password with bcrypt
    public static String hashPassword(String plainTextPassword) {
        return Password.hash(plainTextPassword).withBcrypt().getResult();
    }
    
    // verify user password input against database hash
    public static boolean verifyPassword(String plainTextPassword, String databaseHash) {
        return Password.check(plainTextPassword, databaseHash).withBcrypt();
    }
}
