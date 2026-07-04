<%-- 
    Document   : manage_records
    Created on : Jun 3, 2026, 2:56:38 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.spis.dao.AchievementDAO, com.spis.dao.AttendanceDAO" %>
<%@page import="com.spis.dto.AchievementLogDTO, com.spis.dto.AttendanceLogDTO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String alertMessage = "";
    
    // undo process
    String action = request.getParameter("action");
    String recordIdStr = request.getParameter("id");
    
    if (action != null && recordIdStr != null) {
        int recordId = Integer.parseInt(recordIdStr);
        
        if ("delete_att".equals(action)) {
            if (AttendanceDAO.deleteAttendance(recordId)) {
                alertMessage = "<p class='success-text'>Rekod kehadiran berjaya dipadam!</p>";
            }
        } else if ("delete_ach".equals(action)) {
            if (AchievementDAO.deleteAchievement(recordId)) {
                alertMessage = "<p class='success-text'>Rekod pencapaian berjaya dipadam!</p>";
            }
        }
    }
    
    // fetch data arrays via DAO
    ArrayList<AttendanceLogDTO> attList = AttendanceDAO.getRecentAttendance(assignedUnit);
    ArrayList<AchievementLogDTO> achList = AchievementDAO.getAchievementsByRecorder(currentUser);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        <title>SPIS - Urus & Padam Rekod</title>
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
                    
                    <a href="view_unit_students.jsp">Senarai Pelajar Unit</a>
                    <a href="take_attendance.jsp">Kemaskini Kehadiran</a>
                    <a href="add_achievement.jsp">Log Pencapaian</a>
                    <a href="update_role.jsp">Kemaskini Jawatan Pelajar</a>
                    <a href="manage_records.jsp" class="active">Urus & Padam Rekod</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Sejarah Log & Padam Kesilapan</h2>
                    </div>
                    <div>
                        <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0; margin-bottom: 15px; color: #34495e;">1. Log Kehadiran Mingguan: <%= assignedUnit %></h3>
                        
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <th style="width: 15%;">Tarikh</th>
                                <th style="width: 25%;">Perjumpaan</th>
                                <th style="width: 25%;">Nama Pelajar</th>
                                <th style="width: 10%;">Kelas</th>
                                <th style="width: 15%;">Status</th>
                                <th style="width: 10%; text-align: center;">Tindakan</th>
                            </tr>
                            
                            <%  if (attList.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 20px; color: #7f8c8d;">Tiada rekod log kehadiran ditemui.</td>
                            </tr>
                            <%  
                                } else { 
                                    for (AttendanceLogDTO row : attList) {
                            %>
                                    <tr>
                                        <td><%= row.getMeetDate() %></td>
                                        <td><%= row.getActivityTitle() %></td>
                                        <td><%= row.getStudentName() %></td>
                                        <td><%= row.getClassInfo() %></td>
                                        <td>
                                            <span style="font-weight: bold; color: <%= row.getStatus().equals("Hadir") ? "#27ae60" : (row.getStatus().equals("Tidak Hadir") ? "#c0392b" : "#e67e22") %>;">
                                                <%= row.getStatus() %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <a href="manage_records.jsp?action=delete_att&id=<%= row.getAttendanceId() %>" 
                                               onclick="return confirm('Amaran: Adakah anda pasti mahu memadam log kehadiran ini?');" 
                                               class="btn-danger" style="padding: 6px 12px; font-size: 0.9em; text-decoration: none;">Padam</a>
                                        </td>
                                    </tr>
                            <%
                                    }
                                }
                            %>
                        </table>
                    </div>
                        
                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        <h3 style="margin-top: 0; margin-bottom: 15px; color: #34495e;">2. Log Pencapaian Murid Direkodkan Oleh <%= currentUser %></h3>
                        
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <th style="width: 15%;">Tarikh Acara</th>
                                <th style="width: 25%;">Nama Pertandingan</th>
                                <th style="width: 25%;">Nama Pelajar</th>
                                <th style="width: 15%;">Peringkat</th>
                                <th style="width: 10%;">Keputusan</th>
                                <th style="width: 10%; text-align: center;">Tindakan</th>
                            </tr>
                            
                            <% if (achList.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 20px; color: #7f8c8d;">Tiada log pencapaian direkodkan oleh anda.</td>
                                </tr>
                            <%
                                } else {
                                    for (AchievementLogDTO row : achList) {
                            %>
                                    <tr>
                                        <td><%= row.getEventDate() %></td>
                                        <td><%= row.getEventName() %></td>
                                        <td><%= row.getStudentName() %></td>
                                        <td><%= row.getCompLevel() %></td>
                                        <td><b><%= row.getResult() %></b></td>
                                        <td style="text-align: center;">
                                            <a href="manage_records.jsp?action=delete_ach&id=<%= row.getAchievementId() %>" 
                                               onclick="return confirm('Amaran: Adakah anda pasti mahu memadam log pencapaian ini?');" 
                                               class="btn-danger" style="padding: 6px 12px; font-size: 0.9em; text-decoration: none;">Padam</a>
                                        </td>
                                    </tr>
                            <%
                                    }
                                }
                            %>
                        </table>
                    </div>
                </main>
            </div>
            
        </div>
    </body>
</html>