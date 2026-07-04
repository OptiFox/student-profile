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
        <style>
            .card-header {
                margin-top: 0; 
                color: #2c3e50; 
                border-bottom: 2px solid #eaedf1; 
                padding-bottom: 10px; 
                margin-bottom: 20px;
                font-size: 1.2em;
            }
            .info-grid {
                display: grid;
                grid-template-columns: 150px 1fr;
                gap: 10px;
                margin-bottom: 10px;
                font-size: 1.05em;
            }
            .info-grid span.label {
                font-weight: bold;
                color: #7f8c8d;
            }
            .info-grid span.value {
                color: #2c3e50;
                font-weight: 500;
            }
            @media print {
                .sidebar, .top-header, .no-print { display: none !important; }
                .main-content { background-color: white !important; margin: 0; padding: 0; }
                .content-body { padding: 0 !important; }
                .profile-card { border: none !important; box-shadow: none !important; padding: 0 0 20px 0 !important; margin-bottom: 20px !important; break-inside: avoid; }
            }
        </style>
        <title>SPIS - Profil Lengkap Pelajar</title>
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
                    <a href="view_all_students.jsp" class="active">Papar Keseluruhan Pelajar</a>
                    <a href="generate_report.jsp">Penjanaan Laporan</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header no-print">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Profil Lengkap Pelajar</h2>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <button onclick="window.print()" class="btn-primary" style="padding: 8px 15px;">🖨️ Cetak Profil</button>
                        <a href="view_all_students.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <% if (s != null) { %>
                        
                        <div style="display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 20px;">
                            <div class="profile-card" style="flex: 1; min-width: 300px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                                <h3 class="card-header">1. Maklumat Peribadi</h3>
                                <div class="info-grid">
                                    <span class="label">Nama Penuh:</span> <span class="value"><%= s.getStudentName() %></span>
                                    <span class="label">No. MyKid:</span> <span class="value"><%= s.getMykid() %></span>
                                    <span class="label">Kelas:</span> <span class="value"><%= s.getGradeYear() %> <%= s.getClassName() %></span>
                                </div>
                            </div>
                            
                            <div class="profile-card" style="flex: 2; min-width: 400px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                                <h3 class="card-header">2. Jadual Penempatan Kokurikulum</h3>
                                <table>
                                    <tr>
                                        <th>Kategori</th>
                                        <th>Nama Aktiviti</th>
                                        <th>Jawatan</th>
                                    </tr>
                                    <tr>
                                        <td><b>Unit Beruniform</b></td>
                                        <td><%= "Tiada".equals(s.getUniformUnit()) ? "Tiada" : s.getUniformUnit() %></td>
                                        <td><%= s.getUniformRole() %></td>
                                    </tr>
                                    <tr>
                                        <td><b>Kelab & Persatuan</b></td>
                                        <td><%= "Tiada".equals(s.getClub()) ? "Tiada" : s.getClub() %></td>
                                        <td><%= s.getClubRole() %></td>
                                    </tr>
                                    <tr>
                                        <td><b>Sukan & Permainan</b></td>
                                        <td><%= "Tiada".equals(s.getSport()) ? "Tiada" : s.getSport() %></td>
                                        <td><%= s.getSportRole() %></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <div class="profile-card" style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 20px;">
                            <h3 class="card-header">3. Jadual Rekod Kehadiran</h3>
                            <table>
                                <tr>
                                    <th>Kategori</th>
                                    <th>Aktiviti</th>
                                    <th style="text-align: center;">Jumlah Perjumpaan</th>
                                    <th style="text-align: center;">Hadir</th>
                                    <th style="text-align: center;">Tidak Hadir</th>
                                    <th style="text-align: center;">Peratus (%)</th>
                                </tr>
                                <%
                                    // Java Logic exactly preserved
                                    HashMap<String, int[]> attMap = AttendanceDAO.getAttendanceSummary(studentId);
                                    AttendanceCalculator calc = new AttendanceCalculator();
                                    
                                    int[] uniStats = attMap.getOrDefault(s.getUniformUnit(), new int[]{0,0,0});
                                    int[] clubStats = attMap.getOrDefault(s.getClub(), new int[]{0,0,0});
                                    int[] sportStats = attMap.getOrDefault(s.getSport(), new int[]{0,0,0});
                                %>
                                <tr>
                                    <td><b>Unit Beruniform</b></td>
                                    <td><%= s.getUniformUnit() %></td>
                                    <td style="text-align: center;"><%= uniStats[0] %></td>
                                    <td style="text-align: center;"><%= uniStats[1] %></td>
                                    <td style="text-align: center;"><%= uniStats[2] %></td>
                                    <td style="text-align: center; font-weight: bold;"><%= calc.getPercentage(uniStats[0], uniStats[1]) %></td>
                                </tr>
                                <tr>
                                    <td><b>Kelab & Persatuan</b></td>
                                    <td><%= s.getClub() %></td>
                                    <td style="text-align: center;"><%= clubStats[0] %></td>
                                    <td style="text-align: center;"><%= clubStats[1] %></td>
                                    <td style="text-align: center;"><%= clubStats[2] %></td>
                                    <td style="text-align: center; font-weight: bold;"><%= calc.getPercentage(clubStats[0], clubStats[1]) %></td>
                                </tr>
                                <tr>
                                    <td><b>Sukan & Permainan</b></td>
                                    <td><%= s.getSport() %></td>
                                    <td style="text-align: center;"><%= sportStats[0] %></td>
                                    <td style="text-align: center;"><%= sportStats[1] %></td>
                                    <td style="text-align: center;"><%= sportStats[2] %></td>
                                    <td style="text-align: center; font-weight: bold;"><%= calc.getPercentage(sportStats[0], sportStats[1]) %></td>
                                </tr>
                            </table>
                        </div>
                        
                        <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                            <div class="profile-card" style="flex: 3; min-width: 400px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                                <h3 class="card-header">4. Jadual Log Pencapaian</h3>
                                <table>
                                    <tr>
                                        <th>Tarikh</th>
                                        <th>Nama Pertandingan</th>
                                        <th>Peringkat</th>
                                        <th>Pencapaian</th>
                                    </tr>
                                    <%
                                        // Java Logic exactly preserved
                                        ArrayList<AchievementLogDTO> achList = AchievementDAO.getAchievementsByStudent(studentId);
                                        if (achList.isEmpty()) {
                                            out.println("<tr><td colspan='4' style='text-align: center; padding: 20px; color: #7f8c8d;'>Tiada rekod pencapaian.</td></tr>");
                                        } else {
                                            for (AchievementLogDTO row : achList) {
                                    %>
                                                <tr>
                                                    <td><%= row.getEventDate() %></td>
                                                    <td><%= row.getEventName() %></td>
                                                    <td><%= row.getCompLevel() %></td>
                                                    <td><b><%= row.getResult() %></b></td>
                                                </tr>
                                    <%      
                                            }
                                        }
                                    %>
                                </table>
                            </div>
                            
                            <div class="profile-card" style="flex: 2; min-width: 300px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                                <h3 class="card-header">5. Ringkasan Markah PAJSK</h3>
                                <%
                                    // Java Logic exactly preserved (with database connection)
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
                                        <th style="text-align: center;">Markah Terkumpul</th>
                                    </tr>
                                    <tr>
                                        <td>Kehadiran (Max 50)</td>
                                        <td style="text-align: center; font-size: 1.1em;"><%= scoreAttendance %></td>
                                    </tr>
                                    <tr>
                                        <td>Jawatan (Max 10)</td>
                                        <td style="text-align: center; font-size: 1.1em;"><%= scoreRole %></td>
                                    </tr>
                                    <tr>
                                        <td>Penglibatan (Max 20)</td>
                                        <td style="text-align: center; font-size: 1.1em;"><%= scoreInvolvement %></td>
                                    </tr>
                                    <tr>
                                        <td>Pencapaian (Max 20)</td>
                                        <td style="text-align: center; font-size: 1.1em;"><%= scoreAchievement %></td>
                                    </tr>
                                    <tr>
                                        <td style="text-transform: uppercase; font-weight: bold; color: #2c3e50;">Jumlah Keseluruhan</td>
                                        <td style="text-align: center; font-size: 1.2em; color: #2980b9;">
                                            <b><%= totalScore %> / 100</b> <br>
                                            <span style="font-size: 0.85em; color: <%= grade.equals("A") ? "#27ae60" : (grade.equals("E") ? "#c0392b" : "#2c3e50") %>;">(Gred <%= grade %>)</span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                    <% } else { %>
                        <div style="background: white; padding: 40px; border-radius: 8px; border: 1px solid #e0e0e0; text-align: center;">
                            <p class='error-text' style="font-size: 1.2em;">Pelajar tidak dijumpai dalam pangkalan data.</p>
                        </div>
                    <% } %>
                </main>
            </div>
            
        </div>
    </body>
</html>