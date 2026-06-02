<%-- 
    Document   : view_unit_students
    Created on : Jun 2, 2026, 7:42:28 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.spis.utils.PAJSKEngine" %>

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
        
        <title>SPIS - Senarai Pelajar Unit</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Senarai Pelajar: <%= assignedUnit != null ? assignedUnit : "" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <fieldset style="margin-bottom: 20px; width: 100%;">
                <label for="searchInput"><b>Carian Pelajar:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari Nama atau Kelas...">
            </fieldset>
            
            <fieldset style="width: 100%;">
                <table id="table">
                    <caption>Senarai Ahli Rasmi - <%= assignedUnit %></caption>
                    
                    <tr>
                        <th>Bil.</th>
                        <th>Nama Penuh</th>
                        <th>Kelas</th>
                        <th>Jawatan</th>
                        <th style="text-align: center;">Markah PAJSK Semasa</th>
                        <th style="text-align: center;">Gred Semasa</th>
                    </tr>
                    
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        int counter = 1;
                        
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                            
                            PAJSKEngine pajsk = new PAJSKEngine();
                            
                            String query = "SELECT * FROM Students WHERE uniform_unit = ? OR club = ? OR sport = ? "
                                    + "ORDER BY grade_year ASC, class_name ASC, student_name ASC";
                            
                            stmt = conn.prepareStatement(query);
                            stmt.setString(1, assignedUnit);
                            stmt.setString(2, assignedUnit);
                            stmt.setString(3, assignedUnit);
                            
                            rs = stmt.executeQuery();
                            boolean hasData = false;
                            
                            while (rs.next()) {
                                hasData = true;
                                
                                int studentId = rs.getInt("student_id");
                                String roleInThisUnit = "Ahli Biasa";
                                
                                if (assignedUnit.equals(rs.getString("uniform_unit"))) roleInThisUnit = rs.getString("uniform_role");
                                else if (assignedUnit.equals(rs.getString("club"))) roleInThisUnit = rs.getString("club_role");
                                else if (assignedUnit.equals(rs.getString("sport"))) roleInThisUnit = rs.getString("sport_role");
                                
                                int totalMeetings = 0, totalAttended = 0;
                                
                                String attQuery = "SELECT COUNT(attendance_id) AS total_meet, "
                                        + "COUNT(CASE WHEN status='Hadir' THEN 1 END) AS total_hadir "
                                        + "FROM Attendance WHERE student_id = ?";
                                
                                PreparedStatement attStmt = conn.prepareStatement(attQuery);
                                attStmt.setInt(1, studentId);
                                
                                ResultSet attRs = attStmt.executeQuery();
                                
                                if (attRs.next()) {
                                    totalMeetings = attRs.getInt("total_meet");
                                    totalAttended = attRs.getInt("total_hadir");
                                }
                                
                                attRs.close();
                                attStmt.close();
                                
                                int scoreAttendance = pajsk.getAttendanceScore(totalMeetings, totalAttended);
                                int scoreRole = pajsk.getRoleScore(rs.getString("uniform_role"), rs.getString("club_role"), rs.getString("sport_role"));
                                int scoreInvolvement = pajsk.getInvolvementScore(totalAttended);
                                int scoreAchievement = pajsk.getAchievementScore(conn, studentId);
                                
                                int totalScore = scoreAttendance + scoreRole + scoreInvolvement + scoreAchievement;
                                
                                String grade = pajsk.getGrade(totalScore);
                    %>
                                <tr>
                                    <td><%= counter++ %></td>
                                    <td><%= rs.getString("student_name") %></td>
                                    <td><%= rs.getInt("grade_year") %> <%= rs.getString("class_name") %></td>
                                    <td><b><%= roleInThisUnit != null ? roleInThisUnit : "Ahli Biasa" %></b></td>
                                    <td style="text-align: center;"><%= totalScore %> / 100</td>
                                    <td style="text-align: center; font-weight: bold; color: <%= grade.equals("A") ? "green" : (grade.equals("E") ? "red" : "black") %>;"><%= grade %></td>
                                </tr>
                    <%
                            }
                            
                            if (!hasData) {
                                out.println("<tr><td colspan='6' style='text-align:center;'>Tiada pelajar didaftarkan dalam unit ini.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</td></tr>");
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
