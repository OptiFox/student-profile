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
                <h1>SPIS</h1>
                <p class="subtitle">Sistem Profil Pelajar & PAJSK</p>
                
                <%= alertMessage %>
                
                <form action="login.jsp" method="post">
                    <div style="margin-bottom: 15px;">
                        <label for="username">Nama Pengguna:</label>
                        <input type="text" id="username" name="username" required placeholder="Sila masukkan ID...">
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <label for="password">Kata Laluan:</label>
                        <input type="password" id="password" name="password" required placeholder="Sila masukkan kata laluan...">
                    </div>
                    
                    <button type="submit" class="btn-success" style="width: 100%; margin-top: 10px; padding: 12px; font-size: 1.1em;">Log Masuk</button>
                </form>
            </div>
        </div>
    </body>
</html>