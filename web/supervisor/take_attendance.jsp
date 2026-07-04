<%-- 
    Document   : take_attendance
    Created on : May 29, 2026, 3:31:28 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.Date" %>
<%@page import="com.spis.models.Student, com.spis.models.Attendance" %>
<%@page import="com.spis.dao.StudentDAO, com.spis.dao.AttendanceDAO" %>

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
        String meetDateStr = request.getParameter("meetDate");
        String activityTitle = request.getParameter("activityTitle");
        String extraNotes = request.getParameter("extraNotes");
        String[] studentIds = request.getParameterValues("studentIds");

        if (studentIds != null && studentIds.length > 0) {
            ArrayList<Attendance> records = new ArrayList<>();
            Date meetDate = Date.valueOf(meetDateStr);

            for (String idStr : studentIds) {
                int sId = Integer.parseInt(idStr);
                String status = request.getParameter("status_" + sId);

                Attendance record = new Attendance();
                record.setStudentId(sId);
                record.setUnitName(assignedUnit);
                record.setMeetDate(meetDate);
                record.setActivityTitle(activityTitle);
                record.setExtraNotes(extraNotes);
                record.setStatus(status);

                records.add(record);
            }

            try {
                if (AttendanceDAO.saveAttendanceBatch(records)) {
                    alertMessage = "<p class='success-text' style='text-align: center; margin-bottom: 15px;'>Rekod kehadiran berjaya disimpan!</p>";
                }
            } catch (Exception e) {
                alertMessage = "<p class='error-text' style='text-align: center; margin-bottom: 15px;'>Ralat Pangkalan Data: " + e.getMessage() + "</p>";
            }
        }
    }
    
    ArrayList<Student> studentList = StudentDAO.getStudentsByUnit(assignedUnit);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Kehadiran Mingguan</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Modul Kehadiran: <%= assignedUnit != null ? assignedUnit : "Unit Tidak Ditetapkan" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <form action="take_attendance.jsp" method="post">
                <fieldset>
                    <legend>Maklumat Perjumpaan</legend>
                    <p>
                        <label for="meetDate">Tarikh Perjumpaan:</label>
                        <input type="date" id="meetDate" name="meetDate" required>
                    </p>
                    
                    <p>
                        <label for="activityTitle">Tajuk Perjumpaan:</label>
                        <select id="activityTitle" name="activityTitle" required>
                            <option value="Perjumpaan Mingguan 1">Perjumpaan Mingguan 1</option>
                            <option value="Perjumpaan Mingguan 2">Perjumpaan Mingguan 2</option>
                            <option value="Perjumpaan Mingguan 3">Perjumpaan Mingguan 3</option>
                            <option value="Perjumpaan Mingguan 4">Perjumpaan Mingguan 4</option>
                            <option value="Perjumpaan Mingguan 5">Perjumpaan Mingguan 5</option>
                            <option value="Perjumpaan Mingguan 6">Perjumpaan Mingguan 6</option>
                            <option value="Perjumpaan Mingguan 7">Perjumpaan Mingguan 7</option>
                            <option value="Perjumpaan Mingguan 8">Perjumpaan Mingguan 8</option>
                            <option value="Perjumpaan Mingguan 9">Perjumpaan Mingguan 9</option>
                            <option value="Perjumpaan Mingguan 10">Perjumpaan Mingguan 10</option>
                            <option value="Perjumpaan Mingguan 11">Perjumpaan Mingguan 11</option>
                            <option value="Perjumpaan Mingguan 12">Perjumpaan Mingguan 12</option>
                        </select>
                    </p>
                    
                    <p>
                        <label for="extraNotes">Catatan Tambahan / Aktiviti (Pilihan):</label>
                        <textarea id="extraNotes" name="extraNotes" rows="3" placeholder="Contoh: Latihan kawad kaki persediaan hari sukan..."></textarea>
                    </p>
                </fieldset>
                
                <table>
                    <caption>Senarai Pelajar (<%= assignedUnit %>)</caption>
                    
                    <tr>
                        <th>Bil.</th>
                        <th>Nama Penuh</th>
                        <th>No. MyKid</th>
                        <th>Tahun</th>
                        <th>Kelas</th>
                        <th>Status Kehadiran</th>
                    </tr>
                    
                    <%
                        if (studentList.isEmpty()) {
                    %>
                            <tr>
                                <td colspan="6" class="error-text" style="text-align: center;">Tiada pelajar dijumpai untuk unit: <%= assignedUnit %></td>
                            </tr>
                    <%
                        } else {
                            int counter = 1;
                            for (Student s : studentList) {
                                int studentId = s.getStudentId();
                    %>
                    
                            <tr>
                                <td><%= counter++ %></td>
                                <td><%= s.getStudentName() %></td>
                                <td><%= s.getMykid() %></td>
                                <td><%= s.getGradeYear() %></td>
                                <td><%= s.getClassName() %></td>
                                <td>
                                    <!-- This is used to store student ids in an array -->
                                    <input type="hidden" name="studentIds" value="<%= studentId %>">
                                    <select name="status_<%= studentId %>">
                                        <option value="Hadir">Hadir</option>
                                        <option value="Tidak Hadir">Tidak Hadir</option>
                                        <option value="Bersebab">Bersebab</option>
                                    </select>
                                </td>
                            </tr>
                    
                    <%
                            }
                        }
                    %>
                </table>
                
                <br>
                
                <button type="submit" class="btn-primary">Simpan Kehadiran</button>
            </form>
        </main>
    </body>
</html>
