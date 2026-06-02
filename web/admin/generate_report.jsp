<%-- 
    Document   : generate_report
    Created on : Jun 2, 2026, 6:11:19 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.spis.utils.PAJSKEngine" %>

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
                            
            <% if (isReportGenerated) { %>
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
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            int counter = 1;
                            
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                                
                                PAJSKEngine pajsk = new PAJSKEngine();
                                
                                String query = "SELECT * FROM Students WHERE grade_year = ? ORDER BY class_name ASC, student_name ASC";
                                
                                stmt = conn.prepareStatement(query);
                                stmt.setInt(1, Integer.parseInt(targetYear));
                                
                                rs = stmt.executeQuery();
                                
                                boolean hasData = false;
                                
                                while (rs.next()) {
                                    hasData = true;
                                    int studentId = rs.getInt("student_id");
                                    
                                    int totalMeetings = 0;
                                    int totalAttended = 0;
                                    
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
                                    
                                    String grade = "E";
                                    if (totalScore >= 80) grade = "A";
                                    else if (totalScore >= 60) grade = "B";
                                    else if (totalScore >= 40) grade = "C";
                                    else if (totalScore >= 20) grade = "D";
                        %>
                                    <tr>
                                        <td><%= counter++ %></td>
                                        <td><%= rs.getString("student_name") %></td>
                                        <td><%= rs.getInt("grade_year") %> <%= rs.getString("class_name") %></td>
                                        <td><%= scoreAttendance %></td>
                                        <td><%= scoreRole %></td>
                                        <td><%= scoreInvolvement %></td>
                                        <td><%= scoreAchievement %></td>
                                        <td><b><%= totalScore %></b></td>
                                        <td><b><%= grade %></b></td>
                                    </tr>
                        <%
                                }
                                
                                if (!hasData) {
                                    out.println("<tr><td colspan='9'>Tiada rekod pelajar untuk Tahun " + targetYear + ".</td></tr>");
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='9' class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            }
                        %>
                    </table>
                </div>
            <% } %>
        </main>
    </body>
</html>
