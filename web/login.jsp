<%-- 
    Document   : login
    Created on : May 25, 2026, 10:14:00 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
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
        
        <form action="login.jsp" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">Log Masuk</button>
        </form>
        
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String usernameInput = request.getParameter("username");
                String passwordInput = request.getParameter("password");
                
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
            
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    String query = "SELECT role, assigned_unit, assigned_category FROM Users WHERE username = ? AND password = ?";
                
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, usernameInput);
                    stmt.setString(2, passwordInput);
                
                    rs = stmt.executeQuery();
                
                    if (rs.next()) {
                        String userRole = rs.getString("role");
                        String userUnit = rs.getString("assigned_unit");
                        
                        session.setAttribute("username", usernameInput);
                        session.setAttribute("userRole", userRole);
                        session.setAttribute("assignedUnit", userUnit);
                        session.setAttribute("assignedCategory", rs.getString("assigned_category"));
                    
                        // Only admin can access admin dashboard
                        if ("ADMIN".equals(userRole)) {
                            response.sendRedirect("admin_dashboard.jsp");
                        } else {
                            response.sendRedirect("supervisor_dashboard.jsp");
                        }
                    } else {
                        out.println("<p class='error-text'>Ralat: Username atau password tidak sah.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }   
            }
        %>
    </body>
</html>
