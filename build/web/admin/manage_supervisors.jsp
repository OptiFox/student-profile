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
        <script src="../js/unit_data.js"></script>
        
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
                    
                    <p>
                        <label for="category">Kategori Kokurikulum:</label>
                        <select id="category" name="category" onchange="updateUnits()" required style="width: 100%; padding: 5px;">
                            <option value="Unit Beruniform">Unit Beruniform</option>
                            <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                            <option value="Sukan & Permainan">Sukan & Permainan</option>
                        </select>
                    </p>
                    <p>
                        <label for="unit">Unit Ditugaskan:</label>
                        <select id="unit" name="unit" required style="width: 100%; padding: 5px;">
                        </select>
                    </p>
            
                    <button type="submit" class="btn-primary">Daftar Guru</button>
                </form>
            
            <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String usernameInput = request.getParameter("newUsername");
                String passwordInput = request.getParameter("newPassword");
                String categoryInput = request.getParameter("category");
                String unitInput = request.getParameter("unit");
                
                Connection conn = null;
                PreparedStatement stmt = null;
            
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    // SUPERVISOR role is hardcoded so that admin doesn't have to type
                    String query = "INSERT INTO Users (username, password, role, assigned_category, assigned_unit) VALUES (?, ?, 'SUPERVISOR', ?, ?)";
                
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, usernameInput);
                    stmt.setString(2, passwordInput);
                    stmt.setString(3, categoryInput);
                    stmt.setString(4, unitInput);
                
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
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 3)" placeholder="Cari username...">
            
                <table id="table">
                    <caption>Direktori Pengguna Sistem</caption>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Kategori</th>
                        <th>Unit Ditugaskan</th>
                        <th>Tindakan</th>
                    </tr>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver"); // fix retrieve db failed
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                        String query = "SELECT * FROM Users WHERE role = 'SUPERVISOR' ORDER BY assigned_category, assigned_unit";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();
                        
                        // Iterate over the result set and display each record
                        while (rs.next()) {
                %>
                        <tr>
                            <td><%= rs.getInt("user_id") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("assigned_category") %></td>
                            <td><%= rs.getString("assigned_unit") %></td>
                            <td>
                                <a href="../DeleteSupervisorServlet?id=<%= rs.getInt("user_id") %>"
                                   onclick="return confirm('Padam pengguna ini?');"
                                   class="btn-danger">
                                   Padam
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
