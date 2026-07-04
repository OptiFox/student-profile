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
    
    String alertMessage = "";

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
                alertMessage = "<p class='success-text' style='text-align:center; margin-bottom:15px;'>Pencapaian berjaya direkodkan!</p>";
            } else {
                alertMessage = "<p class='error-text' style='text-align:center; margin-bottom:15px;'>Ralat: Gagal menyimpan rekod pencapaian.</p>";
            }
        } catch (Exception e) {
            alertMessage = "<p class='error-text' style='text-align:center; margin-bottom:15px;'>Ralat Sistem: " + e.getMessage() + "</p>";
        }
    }

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
        <header class="flex">
            <h1>SPIS - Log Pencapaian: <%= assignedUnit != null ? assignedUnit : "" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <%= alertMessage %>
            
            <fieldset>
                <legend>Borang Log Pencapaian & Pertandingan</legend>
                
                <form action="add_achievement.jsp" method="post">
                    <p>
                        <label for="studentId">Pilih Pelajar:</label>
                        <select name="studentId" id="studentId" required>
                            <option value="">-- Sila Pilih Pelajar --</option>
                            <%
                                if (studentList != null) {
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
                        <select name="eventId" id="eventId" required>
                            <option value="">-- Sila Pilih Acara --</option>
                            <% 
                                if (eventList != null) {
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
                    
                    <p>
                        <label for="compLevel">Peringkat Penglibatan:</label>
                        <select name="compLevel" id="compLevel" required>
                            <option value="Sekolah">Sekolah</option>
                            <option value="Zon">Zon</option>
                            <option value="MSSD">MSSD (Daerah)</option>
                            <option value="Negeri">Negeri</option>
                            <option value="Kebangsaan">Kebangsaan</option>
                            <option value="Antarabangsa">Antarabangsa</option>
                        </select>
                    </p>
                    
                    <p>
                        <label for="result">Pencapaian:</label>
                        <select name="result" id="result" required>
                            <option value="Johan">Johan</option>
                            <option value="Naib Johan">Naib Johan</option>
                            <option value="Ketiga">Tempat Ketiga</option>
                            <option value="Keempat">Tempat Keempat</option>
                            <option value="Penyertaan">Penyertaan</option>
                        </select>
                    </p>
                    
                    <button type="submit" class="btn-primary">Tambah Pencapaian</button>
                </form>
            </fieldset>
        </main>
    </body>
</html>
