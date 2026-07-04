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
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Guru</h2>
                    <p style="margin-top: 5px; font-size: 0.85em; color: #3498db;"><%= assignedUnit %></p>
                </div>
                <nav class="sidebar-nav">
                    <a href="../supervisor_dashboard.jsp">Papan Pemuka</a>
                    
                    <a href="view_unit_students.jsp" class="active">Senarai Pelajar Unit</a>
                    <a href="take_attendance.jsp">Kemaskini Kehadiran</a>
                    <a href="add_achievement.jsp">Log Pencapaian</a>
                    <a href="update_role.jsp">Kemaskini Jawatan Pelajar</a>
                    <a href="manage_records.jsp">Urus & Padam Rekod</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Senarai Ahli: <%= assignedUnit %></h2>
                    </div>
                    <div>
                        <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    
                    <div style="background: white; padding: 20px 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 25px;">
                        <label for="searchInput" style="font-weight: bold; color: #2c3e50; font-size: 1.1em; margin-bottom: 5px;">Carian Pantas Pelajar:</label>
                        <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Sila taip Nama Penuh atau Kelas..." style="width: 100%; max-width: 600px; display: block; margin-top: 5px;">
                    </div>
                    
                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        <table id="table" style="width: 100%; border-collapse: collapse;">
                            <caption style="text-align: left; margin-bottom: 15px; font-size: 1.2em; color: #34495e; font-weight: bold;">Senarai Ahli Rasmi</caption>
                            
                            <tr>
                                <th style="width: 5%;">Bil.</th>
                                <th style="width: 35%;">Nama Penuh</th>
                                <th style="width: 15%;">Kelas</th>
                                <th style="width: 20%;">Jawatan</th>
                                <th style="width: 15%; text-align: center;">Markah Semasa</th>
                                <th style="width: 10%; text-align: center;">Gred</th>
                            </tr>
                            
                            <%
                                if (studentList.isEmpty()) {
                                    out.println("<tr><td colspan='6' style='text-align:center; padding: 30px; color: #7f8c8d;'>Tiada pelajar didaftarkan dalam unit ini.</td></tr>");
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
                                                <td style="text-align: center;"><%= counter++ %></td>
                                                <td><b><%= s.getStudentName() %></b></td>
                                                <td>Tahun <%= s.getGradeYear() %> <%= s.getClassName() %></td>
                                                <td><span style="background-color: #f1f4f8; padding: 4px 8px; border-radius: 4px; font-size: 0.9em;"><%= roleInThisUnit != null ? roleInThisUnit : "Ahli Biasa" %></span></td>
                                                <td style="text-align: center; font-size: 1.1em;"><%= totalScore %> / 100</td>
                                                <td style="text-align: center; font-weight: bold; font-size: 1.1em; color: <%= grade.equals("A") ? "#27ae60" : (grade.equals("E") ? "#c0392b" : "#2c3e50") %>;"><%= grade %></td>
                                            </tr>
                            <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='6' class='error-text'>Ralat Pengiraan PAJSK: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                            %>   
                        </table>
                    </div>
                </main>
            </div>
            
        </div>
        <script src="../js/search.js"></script>
    </body>
</html>