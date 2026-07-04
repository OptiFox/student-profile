<%-- 
    Document   : add_achievement
    Created on : Jun 1, 2026, 10:08:51 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.spis.models.Student, com.spis.models.Event, com.spis.models.Achievement" %>
<%@page import="com.spis.dao.StudentDAO, com.spis.dao.EventDAO, com.spis.dao.AchievementDAO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit"); 
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    if (assignedUnit == null) assignedUnit = "Unit Kokurikulum";
    String alertMessage = "";

    // Process Form Logic
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            String compLevel = request.getParameter("compLevel");
            String result = request.getParameter("result");
            
            Achievement achievement = new Achievement();
            achievement.setStudentId(studentId);
            achievement.setEventId(eventId);
            achievement.setCompLevel(compLevel);
            achievement.setResult(result);
            achievement.setRecordedBy(currentUser);
            
            if (AchievementDAO.addAchievement(achievement)) {
                alertMessage = "<p class='success-text' style='margin-bottom: 20px;'>Pencapaian berjaya direkodkan!</p>";
            } else {
                alertMessage = "<p class='error-text' style='margin-bottom: 20px;'>Ralat: Gagal menyimpan rekod pencapaian.</p>";
            }
        } catch (Exception e) {
            alertMessage = "<p class='error-text' style='margin-bottom: 20px;'>Ralat Sistem: " + e.getMessage() + "</p>";
        }
    }

    // Fetch necessary data for dropdowns
    ArrayList<Student> studentList = StudentDAO.getStudentsByUnit(assignedUnit);
    ArrayList<Event> eventList = EventDAO.getAllEvents();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        <title>SPIS - Log Pencapaian</title>
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
                    <a href="add_achievement.jsp" class="active">Log Pencapaian</a>
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
                        <h2 style="margin: 0; color: #2c3e50;">Log Pencapaian: <%= assignedUnit %></h2>
                    </div>
                    <div>
                        <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <div style="max-width: 800px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0; color: #34495e;">Borang Log Pencapaian & Pertandingan</h3>
                        
                        <form action="add_achievement.jsp" method="post">
                            <p>
                                <label for="studentId">Pilih Pelajar:</label>
                                <select name="studentId" id="studentId" required style="width: 100%;">
                                    <option value="">-- Sila Pilih Pelajar --</option>
                                    <%
                                        if (studentList != null && !studentList.isEmpty()) {
                                            for (Student s : studentList) {
                                    %>
                                                <option value="<%= s.getStudentId() %>">
                                                    <%= s.getStudentName() %> (<%= s.getGradeYear() %> <%= s.getClassName() %>)
                                                </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </p>
                            
                            <p>
                                <label for="eventId">Pilih Acara / Pertandingan:</label>
                                <select name="eventId" id="eventId" required style="width: 100%;">
                                    <option value="">-- Sila Pilih Acara --</option>
                                    <% 
                                        if (eventList != null && !eventList.isEmpty()) {
                                            for (Event e : eventList) { 
                                    %>
                                                <option value="<%= e.getEventId() %>">
                                                    <%= e.getEventName() %> (<%= e.getEventDate() %>)
                                                </option>
                                    <% 
                                            }
                                        }
                                    %>
                                </select>
                            </p>
                            
                            <div style="display: flex; gap: 15px; margin-bottom: 15px;">
                                <div style="flex: 1;">
                                    <label for="compLevel">Peringkat Penglibatan:</label>
                                    <select name="compLevel" id="compLevel" required style="width: 100%;">
                                        <option value="Sekolah">Sekolah</option>
                                        <option value="Zon">Zon</option>
                                        <option value="MSSD">MSSD (Daerah)</option>
                                        <option value="Negeri">Negeri</option>
                                        <option value="Kebangsaan">Kebangsaan</option>
                                        <option value="Antarabangsa">Antarabangsa</option>
                                    </select>
                                </div>
                                <div style="flex: 1;">
                                    <label for="result">Pencapaian:</label>
                                    <select name="result" id="result" required style="width: 100%;">
                                        <option value="Johan">Johan</option>
                                        <option value="Naib Johan">Naib Johan</option>
                                        <option value="Ketiga">Tempat Ketiga</option>
                                        <option value="Keempat">Tempat Keempat</option>
                                        <option value="Penyertaan">Penyertaan</option>
                                    </select>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn-primary" style="padding: 10px 20px; font-size: 1.05em; margin-top: 10px;">Tambah Pencapaian</button>
                        </form>
                    </div>
                </main>
            </div>
            
        </div>
    </body>
</html>