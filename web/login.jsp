<%-- 
    Document   : login
    Created on : May 25, 2026, 10:14:00 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.spis.models.User, com.spis.dao.UserDAO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css">
        
        <title>SPIS - Log Masuk</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Log Masuk Pengguna</h1>
        </header>
        
        <div class="flex-center">
            <h2>Log Masuk</h2>
            <fieldset>
                <form action="login.jsp" method="post">
                    <label for="username">Nama Pengguna:</label>
                    <input type="text" id="username" name="username" required>

                    <label for="password">Kata Laluan:</label>
                    <input type="password" id="password" name="password" required>

                    <button type="submit" class="btn-success">Log Masuk</button>
                </form>
            </fieldset>
        </div>
        
        <%
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
                    
                        // Only admin can access admin dashboard
                        if ("ADMIN".equals(loggedInUser.getRole())) {
                            response.sendRedirect("admin_dashboard.jsp");
                        } else {
                            response.sendRedirect("supervisor_dashboard.jsp");
                        }
                    } else {
                        out.println("<p class='error-text'>Log masuk gagal. Nama pengguna atau kata laluan tidak sah.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat sistem: " + e.getMessage() + "</p>");
                }   
            }
        %>
    </body>
</html>
