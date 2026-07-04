<%-- 
    Document   : view_unit_students
    Created on : Jun 2, 2026, 7:42:28 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.*" %>
<%@page import="com.spis.models.Student" %>
<%@page import="com.spis.dao.StudentDAO, com.spis.dao.AttendanceDAO" %>
<%@page import="com.spis.utils.PAJSKEngine, com.spis.utils.DBConnection" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    ArrayList<Student> studentList = StudentDAO.getStudentsByUnit(assignedUnit);
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
                        if (studentList.isEmpty()) {
                            out.println("<tr><td colspan='6' style='text-align:center;'>Tiada pelajar didaftarkan dalam unit ini.</td></tr>");
                        } else {
                            PAJSKEngine pajsk = new PAJSKEngine();
                            int counter = 1;
                            
                            try (Connection conn = DBConnection.getConnection()) {
                                
                                for (Student s : studentList) {
                                    // Figure out their role in this specific unit
                                    String roleInThisUnit = "Ahli Biasa";
                                    if (assignedUnit.equals(s.getUniformUnit())) roleInThisUnit = s.getUniformRole();
                                    else if (assignedUnit.equals(s.getClub())) roleInThisUnit = s.getClubRole();
                                    else if (assignedUnit.equals(s.getSport())) roleInThisUnit = s.getSportRole();
                                    
                                    // Fetch Attendance Stats via DAO
                                    int[] attStats = AttendanceDAO.getAttendanceStats(s.getStudentId());
                                    int totalMeetings = attStats[0];
                                    int totalAttended = attStats[1];
                                    
                                    // Calculate Scores
                                    int scoreAttendance = pajsk.getAttendanceScore(totalMeetings, totalAttended);
                                    int scoreRole = pajsk.getRoleScore(s.getUniformRole(), s.getClubRole(), s.getSportRole());
                                    int scoreInvolvement = pajsk.getInvolvementScore(totalAttended);
                                    int scoreAchievement = pajsk.getAchievementScore(conn, s.getStudentId()); // Needs raw conn for now
                                    
                                    int totalScore = scoreAttendance + scoreRole + scoreInvolvement + scoreAchievement;
                                    String grade = pajsk.getGrade(totalScore);
                    %>
                                <tr>
                                    <td><%= counter++ %></td>
                                    <td><%= s.getStudentName() %></td>
                                    <td><%= s.getGradeYear() %> <%= s.getClassName() %></td>
                                    <td><b><%= roleInThisUnit != null ? roleInThisUnit : "Ahli Biasa" %></b></td>
                                    <td style="text-align: center;"><%= totalScore %> / 100</td>
                                    <td style="text-align: center; font-weight: bold; color: <%= grade.equals("A") ? "green" : (grade.equals("E") ? "red" : "black") %>;"><%= grade %></td>
                                </tr>
                    <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='6' class='error-text'>Ralat Pengiraan PAJSK: " + e.getMessage() + "</td></tr>");
                            }
                        }
                    %>   
                </table>
            </fieldset>
        </main>
            
        <script src="../js/search.js"></script>
    </body>
</html>
