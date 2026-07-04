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
        
        <style>
            @media print {
                .sidebar, .top-header, .no-print { display: none !important; }
                .main-content { background-color: white !important; margin: 0; padding: 0; }
                .content-body { padding: 0 !important; }
            }
        </style>
        
        <title>SPIS - Penjanaan Laporan</title>
    </head>
    <body>
        <div class="dashboard-layout">
            
            <aside class="sidebar no-print">
                <div class="sidebar-header">
                    <h2>SPIS Admin</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="../admin_dashboard.jsp">Papan Pemuka</a>
                    
                    <a href="manage_supervisors.jsp">Urus Guru Penasihat</a>
                    <a href="manage_events.jsp">Urus Senarai Acara</a>
                    <a href="add_student.jsp">Daftar Pelajar Baharu</a>
                    <a href="view_all_students.jsp">Papar Keseluruhan Pelajar</a>
                    <a href="generate_report.jsp" class="active">Penjanaan Laporan</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header no-print">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Penjanaan Laporan & Analisis</h2>
                    </div>
                    <div>
                        <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    
                    <div class="no-print" style="max-width: 800px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0; color: #34495e;">Konfigurasi Laporan</h3>
                        
                        <form action="generate_report.jsp" method="get">
                            <div style="display: flex; gap: 15px; margin-bottom: 20px;">
                                <div style="flex: 2;">
                                    <label for="reportType">Jenis Laporan:</label>
                                    <select name="reportType" id="reportType" style="width: 100%;">
                                        <option value="pajsk">Laporan Markah PAJSK Keseluruhan</option>
                                    </select>
                                </div>
                                
                                <div style="flex: 1;">
                                    <label for="year">Kumpulan Sasaran:</label>
                                    <select name="year" id="year" required style="width: 100%;">
                                        <option value="4" <%= "4".equals(targetYear) ? "selected" : ""%>>Tahun 4</option>
                                        <option value="5" <%= "5".equals(targetYear) ? "selected" : ""%>>Tahun 5</option>
                                        <option value="6" <%= "6".equals(targetYear) ? "selected" : ""%>>Tahun 6</option>
                                    </select>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn-success" style="padding: 10px 20px; font-size: 1.05em;">Jana Laporan</button>
                        </form>
                    </div>
                                
                    <%
                        if (isReportGenerated) { 
                            ArrayList<Student> studentList = StudentDAO.getStudentsByYear(Integer.parseInt(targetYear));
                    %>
                        <div id="reportArea" style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #34495e; padding-bottom: 15px; margin-bottom: 20px;">
                                <h2 style="margin: 0; color: #2c3e50;">Laporan Markah PAJSK Keseluruhan - Tahun <%= targetYear %> (2026)</h2>
                                <button onclick="window.print()" class="btn-primary no-print" style="padding: 10px 20px;">🖨️ Cetak Laporan (PDF)</button>
                            </div>
                                
                            <table style="width: 100%; border-collapse: collapse;">
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
                                        out.println("<tr><td colspan='9' style='text-align: center; padding: 20px;'>Tiada rekod pelajar untuk Tahun " + targetYear + ".</td></tr>");
                                    } else {
                                        PAJSKEngine pajsk = new PAJSKEngine();
                                        int counter = 1;
                                        
                                        // connection for PAJSK Engine (Preserving your exact backend logic!)
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
                                                    <td style="text-align: center;"><%= counter++ %></td>
                                                    <td><%= s.getStudentName() %></td>
                                                    <td style="text-align: center;"><%= s.getGradeYear() %> <%= s.getClassName() %></td>
                                                    <td style="text-align: center;"><%= scoreAttendance %></td>
                                                    <td style="text-align: center;"><%= scoreRole %></td>
                                                    <td style="text-align: center;"><%= scoreInvolvement %></td>
                                                    <td style="text-align: center;"><%= scoreAchievement %></td>
                                                    <td style="text-align: center; font-size: 1.1em;"><b><%= totalScore %></b></td>
                                                    <td style="text-align: center; font-size: 1.1em; color: <%= grade.equals("A") ? "#27ae60" : (grade.equals("E") ? "#c0392b" : "#2c3e50") %>;"><b><%= grade %></b></td>
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
            </div>
            
        </div>
    </body>
</html>