<%-- 
    Document   : add_achievement
    Created on : Jun 1, 2026, 10:08:51 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit"); 
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Log Pencapaian</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Log Pencapaian: <%= assignedUnit != null ? assignedUnit : "" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <fieldset>
                <legend>Borang Log Pencapaian & Pertandingan</legend>
                
                <form action="add_achievement.jsp" method="post">
                    <p>
                        <label for="studentId">Pilih Pelajar:</label>
                        <select name="studentId" id="studentId" required>
                            <option value="">-- Sila Pilih Pelajar --</option>
                            <%
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                PreparedStatement eventStmt = null;
                                ResultSet rs = null;
                                ResultSet eventRs = null;
                                
                                try {
                                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                                    
                                    String query = "SELECT student_id, student_name, class_name FROM Students "
                                            + "WHERE uniform_unit = ? OR club = ? OR sport = ? ORDER BY student_name ASC";
                                    
                                    stmt = conn.prepareStatement(query);
                                    stmt.setString(1, assignedUnit);
                                    stmt.setString(2, assignedUnit);
                                    stmt.setString(3, assignedUnit);
                                    
                                    rs = stmt.executeQuery();
                                    
                                    while (rs.next()) {
                            %>
                                        <option value="<%= rs.getInt("student_id") %>">
                                            <%= rs.getString("student_name") %> (<%= rs.getString("class_name") %>)
                                        </option>
                            <%
                                    }
                            %>
                        </select>
                    </p>
                    
                    <p>
                        <label for="eventId">Pilih Acara / Pertandingan:</label>
                        <select name="eventId" id="eventId" required>
                            <option value="">-- Sila Pilih Acara --</option>
                            <%
                                    // fetch events from Admin's table
                                    String eventQuery = "SELECT event_id, event_name, event_date FROM Events ORDER BY event_date DESC";

                                    eventStmt = conn.prepareStatement(eventQuery);
                                    eventRs = eventStmt.executeQuery();

                                    while (eventRs.next()) {
                            %>
                                        <option value="<%= eventRs.getInt("event_id") %>">
                                            <%= eventRs.getString("event_name") %> (<%= eventRs.getDate("event_date") %>)
                                        </option>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<option value=''>Ralat Pangkalan Data: " + e.getMessage() + "</option>");
                                } finally {
                                    if (rs != null) rs.close();
                                    if (eventRs != null) eventRs.close();
                                    if (stmt != null) stmt.close();
                                    if (eventStmt != null) eventStmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </select>
                    </p>
                    
                    <p>
                        <label for="compLevel">Peringkat Penglibatan:</label>
                        <select name="compLevel" id="compLevel" required>
                            <option value="Sekolah">Sekolah</option>
                            <option value="Zon">Zon</option>
                            <option value="MSSD">MSSD (Daerah)</option>
                            <option value="Negeri">Negeri</option>
                            <option value="Kebangsaan">Kebangsaan</option>
                            <option value="Antarabangsa">Antarabangsa</option>
                        </select>
                    </p>
                    
                    <p>
                        <label for="result">Pencapaian:</label>
                        <select name="result" id="result" required>
                            <option value="Johan">Johan</option>
                            <option value="Naib Johan">Naib Johan</option>
                            <option value="Ketiga">Tempat Ketiga</option>
                            <option value="Keempat">Tempat Keempat</option>
                            <option value="Penyertaan">Penyertaan</option>
                        </select>
                    </p>
                    
                    <button type="submit" class="btn-primary">Tambah Pencapaian</button>
                </form>
                        
                <%
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String studentIdStr = request.getParameter("studentId");
                        String eventIdStr = request.getParameter("eventId");
                        String compLevel = request.getParameter("compLevel");
                        String result = request.getParameter("result");
                        
                        Connection insertConn = null;
                        PreparedStatement insertStmt = null;
                        
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            insertConn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                            
                            String insertQuery = "INSERT INTO Achievements (student_id, event_id, comp_level, result, recorded_by) "
                                    + "VALUES (?, ?, ?, ?, ?)";
                            
                            insertStmt = insertConn.prepareStatement(insertQuery);
                            insertStmt.setInt(1, Integer.parseInt(studentIdStr));
                            insertStmt.setInt(2, Integer.parseInt(eventIdStr));
                            insertStmt.setString(3, compLevel);
                            insertStmt.setString(4, result);
                            insertStmt.setString(5, currentUser);
                            
                            int rowsAffected = insertStmt.executeUpdate();
                            if (rowsAffected > 0) {
                                out.println("<p class='success-text'>Pencapaian berjaya direkodkan!</p>");
                            }
                        } catch (Exception e) {
                            out.println("<p class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</p>");
                        } finally {
                            if (insertStmt != null) insertStmt.close();
                            if (insertConn != null) insertConn.close();
                        }
                    }
                %>
            </fieldset>
        </main>
    </body>
</html>
