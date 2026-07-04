<%-- 
    Document   : login
    Created on : May 25, 2026, 10:14:00 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.spis.models.User, com.spis.dao.UserDAO" %>

<%
    String alertMessage = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String usernameInput = request.getParameter("username");
        String passwordInput = request.getParameter("password");
        
        try {
            User loggedInUser = UserDAO.authenticateUser(usernameInput, passwordInput);
            
            if (loggedInUser != null) {
                session.setAttribute("currentUser", loggedInUser);
                session.setAttribute("username", loggedInUser.getUsername());
                session.setAttribute("userRole", loggedInUser.getRole());
                session.setAttribute("assignedUnit", loggedInUser.getAssignedUnit());
                session.setAttribute("assignedCategory", loggedInUser.getAssignedCategory());
                
                // Redirect and stop loading the rest of this page
                if ("ADMIN".equals(loggedInUser.getRole())) {
                    response.sendRedirect("admin_dashboard.jsp");
                    return; 
                } else {
                    response.sendRedirect("supervisor_dashboard.jsp");
                    return; 
                }
            } else {
                alertMessage = "<p style='color: #e74c3c; font-weight: bold; margin-bottom: 15px;'>Log masuk gagal. Nama pengguna atau kata laluan tidak sah.</p>";
            }
        } catch (Exception e) {
            alertMessage = "<p style='color: #e74c3c; font-weight: bold; margin-bottom: 15px;'>Ralat sistem: " + e.getMessage() + "</p>";
        }   
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css">
        <title>SPIS - Log Masuk</title>
    </head>
    <body>
        <div class="login-wrapper">
            <div class="login-card">
                <h1 style="color: #2c3e50; font-size: 2.2em; margin-bottom: 5px; margin-top: 0;">SPIS</h1>
                <p class="subtitle" style="color: #7f8c8d; margin-bottom: 25px; margin-top: 0;">Sistem Profil Pelajar & PAJSK</p>
                
                <%= alertMessage %>
                
                <form action="login.jsp" method="post" style="display: flex; flex-direction: column; gap: 15px; text-align: left;">
                    <div>
                        <label for="username" style="font-weight: bold; color: #34495e; font-size: 0.9em;">Nama Pengguna:</label>
                        <input type="text" id="username" name="username" required placeholder="Sila masukkan ID..." style="padding: 12px; border: 1px solid #bdc3c7; border-radius: 6px; width: 100%; box-sizing: border-box; margin-top: 5px;">
                    </div>
                    
                    <div>
                        <label for="password" style="font-weight: bold; color: #34495e; font-size: 0.9em;">Kata Laluan:</label>
                        <input type="password" id="password" name="password" required placeholder="Sila masukkan kata laluan..." style="padding: 12px; border: 1px solid #bdc3c7; border-radius: 6px; width: 100%; box-sizing: border-box; margin-top: 5px;">
                    </div>
                    
                    <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px; padding: 12px; font-size: 1.1em; border: none; border-radius: 6px; background-color: #3498db; color: white; cursor: pointer;">Log Masuk</button>
                </form>
                
                <div style="margin-top: 25px; padding-top: 20px; border-top: 1px solid #eaedf1;">
                    <a href="index.html" style="color: #3498db; text-decoration: none; font-size: 0.95em; font-weight: bold;">&larr; Kembali ke Laman Utama</a>
                </div>
            </div>
        </div>
    </body>
</html>