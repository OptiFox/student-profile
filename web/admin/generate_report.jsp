<%-- 
    Document   : generate_report
    Created on : Jun 2, 2026, 6:11:19 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.ArrayList" %>
<%@page import="com.spis.models.Student" %>
<%@page import="com.spis.dao.StudentDAO, com.spis.dao.AttendanceDAO" %>
<%@page import="com.spis.utils.PAJSKEngine, com.spis.utils.DBConnection" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    String targetYear = request.getParameter("year");
    boolean isReportGenerated = (targetYear != null && !targetYear.isEmpty());
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css" />
        
        <title>SPIS - Penjanaan Laporan</title>
    </head>
    <body>
        <header class="flex no-print">
            <h1>Sistem Profil Pelajar (SPIS) - Laporan & Analisis</h1>
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <div class="no-print">
                <h2>Penjanaan Laporan & Analisis</h2>
                
                <form action="generate_report.jsp" action="get">
                    <fieldset style="margin-bottom: 20px">
                        <legend>Konfigurasi Laporan</legend>
                        
                        <p>
                            <label for="reportType">Jenis Laporan:</label>
                            <select name="reportType" id="reportType">
                                <option value="pajsk">Laporan Markah PAJSK Keseluruhan</option>
                            </select>
                        </p>
                        
                        <p>
                            <label for="year">Kumpulan Sasaran (Tahun/Darjah):</label>
                            <select name="year" id="year" required>
                                <option value="4" <%= "4".equals(targetYear) ? "selected" : ""%>>Tahun 4</option>
                                <option value="5" <%= "5".equals(targetYear) ? "selected" : ""%>>Tahun 5</option>
                                <option value="6" <%= "6".equals(targetYear) ? "selected" : ""%>>Tahun 6</option>
                            </select>
                        </p>
                        
                        <button type="submit" class="btn-success">Jana Laporan</button>
                    </fieldset>
                </form>
            </div>
                            
            <%
                if (isReportGenerated) { 
                    ArrayList<Student> studentList = StudentDAO.getStudentsByYear(Integer.parseInt(targetYear));
            %>
                <div id="reportArea">
                    <div class="flex">
                        <h2>Laporan Markah PAJSK Keseluruhan - Tahun <%= targetYear %> (2026)</h2>
                        <button onclick="window.print()" class="btn-secondary no-print">Cetak Laporan (PDF)</button>
                    </div>
                        
                    <table>
                        <tr>
                            <th>Bil.</th>
                            <th>Nama Pelajar</th>
                            <th>Kelas</th>
                            <th>Kehadiran (50)</th>
                            <th>Jawatan (10)</th>
                            <th>Penglibatan (20)</th>
                            <th>Pencapaian (20)</th>
                            <th>Jumlah Markah</th>
                            <th>Gred</th>
                        </tr>
                        
                        <%
                            if (studentList.isEmpty()) {
                                out.println("<tr><td colspan='9' style='text-align: center;'>Tiada rekod pelajar untuk Tahun " + targetYear + ".</td></tr>");
                            } else {
                                PAJSKEngine pajsk = new PAJSKEngine();
                                int counter = 1;
                                
                                // connection for PAJSK Engine
                                try (Connection conn = DBConnection.getConnection()) {
                                    for (Student s : studentList) {
                                        int studentId = s.getStudentId();
                                        
                                        int[] attStats = AttendanceDAO.getAttendanceStats(studentId);
                                        int totalMeetings = attStats[0];
                                        int totalAttended = attStats[1];
                                        
                                        // Calculate PAJSK
                                        int scoreAttendance = pajsk.getAttendanceScore(totalMeetings, totalAttended);
                                        int scoreRole = pajsk.getRoleScore(s.getUniformRole(), s.getClubRole(), s.getSportRole());
                                        int scoreInvolvement = pajsk.getInvolvementScore(totalAttended);
                                        int scoreAchievement = pajsk.getAchievementScore(conn, studentId); 
                                        
                                        int totalScore = scoreAttendance + scoreRole + scoreInvolvement + scoreAchievement;
                                        String grade = pajsk.getGrade(totalScore);
                        %>
                                        <tr>
                                            <td><%= counter++ %></td>
                                            <td><%= s.getStudentName() %></td>
                                            <td><%= s.getGradeYear() %> <%= s.getClassName() %></td>
                                            <td><%= scoreAttendance %></td>
                                            <td><%= scoreRole %></td>
                                            <td><%= scoreInvolvement %></td>
                                            <td><%= scoreAchievement %></td>
                                            <td><b><%= totalScore %></b></td>
                                            <td><b><%= grade %></b></td>
                                        </tr>
                        <%
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='9' class='error-text'>Ralat Pengiraan: " + e.getMessage() + "</td></tr>");
                                }
                            }
                        %>
                    </table>
                </div>
            <% } %>
        </main>
    </body>
</html>
