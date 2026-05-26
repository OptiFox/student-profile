<%-- 
    Document   : manage_supervisors
    Created on : May 26, 2026, 10:29:39 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    // Checks if the user is admin or not (security)
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; // stop page from loading
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Urus Guru Penasihat</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Pendaftaran Guru Penasihat</h1>
            
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <fieldset>
                <legend>Daftar Guru Baharu</legend>
                
                <form action="manage_supervisors.jsp" method="post">
                    <label for="newUsername">Username:</label>
                    <input type="text" id="newUsername" name="newUsername" required>
            
                    <label for="password">Password:</label>
                    <input type="password" id="newPassword" name="newPassword" required>
            
                    <button type="submit">Daftar Guru</button>
                </form>
            
            <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String usernameInput = request.getParameter("newUsername");
                String passwordInput = request.getParameter("newPassword");
                
                Connection conn = null;
                PreparedStatement stmt = null;
            
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    // SUPERVISOR role is hardcoded so that admin doesn't have to type
                    String query = "INSERT INTO Users (username, password, role) VALUES (?, ?, 'SUPERVISOR')";
                
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, usernameInput);
                    stmt.setString(2, passwordInput);
                
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        out.println("<p class='success-text'>Pendaftaran berjaya! Akaun guru sedia untuk digunakan.</p>");
                    }
                } catch (SQLIntegrityConstraintViolationException e) {
                    out.println("<p class='error-text'>Ralat: Username ini telah wujud.</p>");
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat: " + e.getMessage() + "</p>");
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }   
            }
            %>
            </fieldset>
            
            <fieldset style="margin-bottom: 15px; width: 100%;">
                <label for="searchInput"><b>Carian Guru:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Cari username...">
            
                <table id="supervisorTable">
                    <caption>Direktori Pengguna Sistem</caption>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Delete</th>
                    </tr>
                <%
                    // Establish database connection
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver"); // fix retrieve db failed
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                        String query = "SELECT * FROM Users WHERE role = 'SUPERVISOR'";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();
                        // Iterate over the result set and display each record
                        while (rs.next()) {
                %>
                        <tr>
                            <td><%= rs.getInt("user_id") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("role") %></td>
                            <td>
                                <a href="../DeleteSupervisorServlet?id=<%= rs.getInt("user_id") %>"
                                   onclick="return confirm('Are you sure to delete this user?');"
                                   class="btn-danger">
                                   Delete
                                </a>
                            </td>
                        </tr>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("Error retrieving users: " + e.getMessage());
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
                </table>
            </fieldset>
        </main>
            
            <script src="../js/search.js"></script>
    </body>
</html>
