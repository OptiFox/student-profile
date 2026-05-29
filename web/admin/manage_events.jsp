<%-- 
    Document   : manage_events
    Created on : May 28, 2026, 9:12:15 AM
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
        
        <title>SPIS - Urus Senarai Acara & Pertandingan</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Pengurusan Acara & Pertandingan</h1>
            
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <fieldset>
                <legend>Tambah Acara Baharu</legend>
                
                <form action="manage_events.jsp" method="post">
                    <p>
                        <label for="eventName">Nama Acara:</label>
                        <input type="text" id="eventName" name="eventName" required>
                    </p>
            
                    <p>
                        <label for="eventType">Kategori:</label>
                        <select id="eventType" name="eventType" required>
                            <option value="Unit Beruniform">Unit Beruniform</option>
                            <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                            <option value="Sukan & Permainan">Sukan & Permainan</option>
                        </select>
                    </p>
                    
                    <p>
                        <label for="eventDate">Tarikh:</label>
                        <input type="date" id="eventDate" name="eventDate" required>
                    </p>
                    
                    <p>
                        <label for="description">Penerangan ringkas:</label>
                        <textarea id="description" name="description" rows="3" style="width: 100%;"></textarea>
                    </p>
            
                    <button type="submit" class="btn-primary">Tambah Acara</button>
                </form>
            
            <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String eventName = request.getParameter("eventName");
                String eventType = request.getParameter("eventType");
                String eventDate = request.getParameter("eventDate");
                String description = request.getParameter("description");
                
                Connection conn = null;
                PreparedStatement stmt = null;
            
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    // SUPERVISOR role is hardcoded so that admin doesn't have to type
                    String query = "INSERT INTO Events (event_name, event_type, event_date, description) VALUES (?, ?, ?, ?)";
                
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, eventName);
                    stmt.setString(2, eventType);
                    stmt.setDate(3, java.sql.Date.valueOf(eventDate));
                    stmt.setString(4, description);
                
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        out.println("<p class='success-text'>Acara berjaya ditambah!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat: " + e.getMessage() + "</p>");
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }   
            }
            %>
            </fieldset>
            
            <br>
            <fieldset style="margin-bottom: 15px; width: 100%;">
                <label for="searchInput"><b>Carian Acara:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari nama acara...">
            
                <table id="table">
                    <caption>Senarai Keseluruhan Acara & Pertandingan</caption>
                    <tr>
                        <th>ID</th>
                        <th>Nama Acara</th>
                        <th>Kategori</th>
                        <th>Tarikh</th>
                        <th>Tindakan</th>
                    </tr>
                <%
                    // Establish database connection
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver"); // fix retrieve db failed
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                        String query = "SELECT * FROM Events ORDER BY event_date DESC";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();
                        
                        // Iterate over the result set and display each record
                        while (rs.next()) {
                %>
                        <tr>
                            <td><%= rs.getInt("event_id") %></td>
                            <td><%= rs.getString("event_name") %></td>
                            <td><%= rs.getString("event_type") %></td>
                            <td><%= rs.getDate("event_date") %></td>
                            <td>
                                <a href="../DeleteEventServlet?id=<%= rs.getInt("event_id") %>"
                                   onclick="return confirm('Padam acara ini?');"
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
