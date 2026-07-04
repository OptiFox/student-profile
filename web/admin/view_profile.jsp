<%-- 
    Document   : view_profile
    Created on : Jun 1, 2026, 12:39:51 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.HashMap, java.util.ArrayList" %>
<%@page import="com.spis.models.Student" %>
<%@page import="com.spis.dto.AchievementLogDTO" %>
<%@page import="com.spis.dao.StudentDAO, com.spis.dao.AttendanceDAO, com.spis.dao.AchievementDAO" %>
<%@page import="com.spis.utils.PAJSKEngine, com.spis.utils.AttendanceCalculator, com.spis.utils.DBConnection" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    // get student id from url
    String studentIdStr = request.getParameter("id");
    if (studentIdStr == null || studentIdStr.isEmpty()) {
        out.println("<p class='error-text'>Ralat: ID Pelajar tidak dijumpai.</p>");
        return;
    }
    
    int studentId = Integer.parseInt(studentIdStr);
    Student s = StudentDAO.getStudentById(studentId);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Profil Lengkap Pelajar</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Paparan Profil Lengkap</h1>
            <div>
                <a href="view_all_students.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <% if (s != null) { %>
                <div class="profile-section">
                    <h3>1. Maklumat Peribadi</h3>
                    <p><b>Nama Penuh:</b> <%= s.getStudentName() %></p>
                    <p><b>No. MyKid:</b> <%= s.getMykid() %></p>
                    <p><b>Kelas:</b> <%= s.getGradeYear() %> <%= s.getClassName() %></p>
                </div>
                        
                <div class="profile-section">
                    <h3>2. Jadual Penempatan Kokurikulum</h3>
                    <table>
                        <tr>
                            <th>Kategori</th>
                            <th>Nama Aktiviti</th>
                            <th>Jawatan</th>
                        </tr>
                        <tr>
                            <td>Unit Beruniform</td>
                            <td><%= "Tiada".equals(s.getUniformUnit()) ? "Tiada" : s.getUniformUnit() %></td>
                            <td><%= s.getUniformRole() %></td>
                        </tr>
                        <tr>
                            <td>Kelab & Persatuan</td>
                            <td><%= "Tiada".equals(s.getClub()) ? "Tiada" : s.getClub() %></td>
                            <td><%= s.getClubRole() %></td>
                        </tr>
                        <tr>
                            <td>Sukan & Permainan</td>
                            <td><%= "Tiada".equals(s.getSport()) ? "Tiada" : s.getSport() %></td>
                            <td><%= s.getSportRole() %></td>
                        </tr>
                    </table>
                </div>
            
                <div class="profile-section">
                    <h3>3. Jadual Rekod Kehadiran</h3>
                    <table>
                        <tr>
                            <th>Kategori</th>
                            <th>Aktiviti</th>
                            <th>Jumlah Perjumpaan</th>
                            <th>Hadir</th>
                            <th>Tidak Hadir</th>
                            <th>Peratus Kehadiran (%)</th>
                        </tr>
                        <%
                            // Fetch all attendance mapped by unit
                            HashMap<String, int[]> attMap = AttendanceDAO.getAttendanceSummary(studentId);
                            AttendanceCalculator calc = new AttendanceCalculator();
                            
                            // Retrieve stats safely (default to zeros if missing)
                            int[] uniStats = attMap.getOrDefault(s.getUniformUnit(), new int[]{0,0,0});
                            int[] clubStats = attMap.getOrDefault(s.getClub(), new int[]{0,0,0});
                            int[] sportStats = attMap.getOrDefault(s.getSport(), new int[]{0,0,0});
                        %>
                        <tr>
                            <td><b>Unit Beruniform</b></td>
                            <td><%= s.getUniformUnit() %></td>
                            <td><%= uniStats[0] %></td>
                            <td><%= uniStats[1] %></td>
                            <td><%= uniStats[2] %></td>
                            <td><%= calc.getPercentage(uniStats[0], uniStats[1]) %></td>
                        </tr>
                        <tr>
                            <td><b>Kelab & Persatuan</b></td>
                            <td><%= s.getClub() %></td>
                            <td><%= clubStats[0] %></td>
                            <td><%= clubStats[1] %></td>
                            <td><%= clubStats[2] %></td>
                            <td><%= calc.getPercentage(clubStats[0], clubStats[1]) %></td>
                        </tr>
                        <tr>
                            <td><b>Sukan & Permainan</b></td>
                            <td><%= s.getSport() %></td>
                            <td><%= sportStats[0] %></td>
                            <td><%= sportStats[1] %></td>
                            <td><%= sportStats[2] %></td>
                            <td><%= calc.getPercentage(sportStats[0], sportStats[1]) %></td>
                        </tr>
                    </table>
                </div>
                                
                <div class="profile-section">
                    <h3>4. Jadual Log Pencapaian</h3>
                    <table>
                        <tr>
                            <th>Tarikh</th>
                            <th>Nama Pertandingan</th>
                            <th>Peringkat</th>
                            <th>Pencapaian</th>
                        </tr>
                        <%
                            ArrayList<AchievementLogDTO> achList = AchievementDAO.getAchievementsByStudent(studentId);
                            if (achList.isEmpty()) {
                                out.println("<tr><td colspan='4' style='text-align: center;'>Tiada rekod pencapaian.</td></tr>");
                            } else {
                                for (AchievementLogDTO row : achList) {
                        %>
                                    <tr>
                                        <td><%= row.getEventDate() %></td>
                                        <td><%= row.getEventName() %></td>
                                        <td><%= row.getCompLevel() %></td>
                                        <td><%= row.getResult() %></td>
                                    </tr>
                        <%      
                                }
                            }
                        %>
                    </table>
                </div>
                           
                <div class="profile-section">
                    <h3>5. Ringkasan Markah PAJSK</h3>
                    <%
                        PAJSKEngine pajsk = new PAJSKEngine();
                        int totalAllMeetings = uniStats[0] + clubStats[0] + sportStats[0];
                        int totalAllAttended = uniStats[1] + clubStats[1] + sportStats[1];
                        
                        int scoreAttendance = pajsk.getAttendanceScore(totalAllMeetings, totalAllAttended);
                        int scoreRole = pajsk.getRoleScore(s.getUniformRole(), s.getClubRole(), s.getSportRole());
                        int scoreInvolvement = pajsk.getInvolvementScore(totalAllAttended);
                        
                        int scoreAchievement = 0;
                        try (Connection conn = DBConnection.getConnection()) {
                            scoreAchievement = pajsk.getAchievementScore(conn, studentId);
                        } catch (Exception e) {
                            out.println("<p class='error-text'>Ralat mengira markah pencapaian.</p>");
                        }
                        
                        int totalScore = scoreAttendance + scoreRole + scoreInvolvement + scoreAchievement;
                        String grade = pajsk.getGrade(totalScore);
                    %>
                    <table>
                        <tr>
                            <th>Elemen Penilaian</th>
                            <th>Markah Terkumpul</th>
                        </tr>
                        <tr>
                            <td>Kehadiran (Max 50)</td>
                            <td><%= scoreAttendance %></td>
                        </tr>
                        <tr>
                            <td>Jawatan (Max 10)</td>
                            <td><%= scoreRole %></td>
                        </tr>
                        <tr>
                            <td>Penglibatan (Max 20)</td>
                            <td><%= scoreInvolvement %></td>
                        </tr>
                        <tr>
                            <td>Pencapaian (Max 20)</td>
                            <td><%= scoreAchievement %></td>
                        </tr>
                        <tr>
                            <th>Jumlah Keseluruhan</th>
                            <th><%= totalScore %> / 100 (Gred <%= grade %>)</th>
                        </tr>
                    </table>
                </div>
            <% } else { %>
                <p class='error-text'>Pelajar tidak dijumpai dalam pangkalan data.</p>
            <% } %>
        </main>
    </body>
</html>
