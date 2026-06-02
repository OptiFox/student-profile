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
        <header class="flex">
            <h1>SPIS - Sejarah Log & Padam Kesilapan</h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <%= alertMessage %>
            
            <fieldset style="width: 100%; margin-bottom: 30px;">
                <legend><b>1. Log Kehadiran Mingguan Unit (<%= assignedUnit %>)</b></legend>
                
                <table>
                    <tr>
                        <th>Tarikh</th>
                        <th>Perjumpaan</th>
                        <th>Nama Pelajar</th>
                        <th>Kelas</th>
                        <th>Status</th>
                        <th>Tindakan</th>
                    </tr>
                    
                    <%  if (attList.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="text-align: center;">Tiada rekod log kehadiran ditemui.</td>
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
                                    <td><%= row.getStatus() %></td>
                                    <td>
                                        <a href="manage_records.jsp?action=delete_att&id=<%= row.getAttendanceId() %>" 
                                           onclick="return confirm('Padam log pencapaian ini?');" class="btn-danger">Padam</a>
                                    </td>
                                </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </fieldset>
                
            <fieldset style="width: 100%;">
                <legend><b>2. Log Pencapaian Murid Direkodkan Oleh <%= currentUser %></b></legend>
                
                <table>
                    <tr>
                        <th>Tarikh Acara</th>
                        <th>Nama Pertandingan</th>
                        <th>Nama Pelajar</th>
                        <th>Peringkat</th>
                        <th>Keputusan</th>
                        <th>Tindakan</th>
                    </tr>
                    
                    <% if (achList.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align: center;">Tiada log pencapaian direkodkan oleh anda.</td>
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
                                    <td><%= row.getResult() %></td>
                                    <td>
                                        <a href="manage_records.jsp?action=delete_ach&id=<%= row.getAchievementId() %>" 
                                           onclick="return confirm('Padam log pencapaian ini?');" class="btn-danger">Padam</a>
                                    </td>
                                </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </fieldset>
        </main>
    </body>
</html>
