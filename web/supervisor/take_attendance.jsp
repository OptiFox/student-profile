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
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Guru</h2>
                    <p style="margin-top: 5px; font-size: 0.85em; color: #3498db;"><%= assignedUnit %></p>
                </div>
                <nav class="sidebar-nav">
                    <a href="../supervisor_dashboard.jsp">Papan Pemuka</a>
                    
                    <a href="view_unit_students.jsp">Senarai Pelajar Unit</a>
                    <a href="take_attendance.jsp" class="active">Kemaskini Kehadiran</a>
                    <a href="add_achievement.jsp">Log Pencapaian</a>
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
                        <h2 style="margin: 0; color: #2c3e50;">Modul Kehadiran: <%= assignedUnit %></h2>
                    </div>
                    <div>
                        <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <form action="take_attendance.jsp" method="post">
                        
                        <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 25px;">
                            <h3 style="margin-top: 0; color: #34495e;">Maklumat Perjumpaan</h3>
                            
                            <div style="display: flex; gap: 15px; margin-bottom: 10px;">
                                <div style="flex: 1;">
                                    <label for="meetDate">Tarikh Perjumpaan:</label>
                                    <input type="date" id="meetDate" name="meetDate" required style="width: 100%;">
                                </div>
                                <div style="flex: 2;">
                                    <label for="activityTitle">Tajuk Perjumpaan:</label>
                                    <select id="activityTitle" name="activityTitle" required style="width: 100%;">
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
                                </div>
                            </div>
                            
                            <p>
                                <label for="extraNotes">Catatan Tambahan:</label>
                                <textarea id="extraNotes" name="extraNotes" rows="2" placeholder="Contoh: Latihan kawad kaki persediaan hari sukan..." style="width: 100%;"></textarea>
                            </p>
                        </div>
                        
                        <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eaedf1; padding-bottom: 15px; margin-bottom: 15px;">
                                <h3 style="margin: 0; color: #34495e;">Senarai Pelajar (<%= assignedUnit %>)</h3>
                                <button type="submit" class="btn-primary" style="padding: 10px 20px; font-size: 1.05em;">💾 Simpan Kehadiran</button>
                            </div>

                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <th style="width: 5%;">Bil.</th>
                                    <th style="width: 35%;">Nama Penuh</th>
                                    <th style="width: 15%;">No. MyKid</th>
                                    <th style="width: 10%; text-align: center;">Tahun</th>
                                    <th style="width: 15%; text-align: center;">Kelas</th>
                                    <th style="width: 20%; text-align: center;">Status Kehadiran</th>
                                </tr>
                                
                                <%
                                    if (studentList.isEmpty()) {
                                %>
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">Tiada pelajar dijumpai untuk unit: <%= assignedUnit %></td>
                                        </tr>
                                <%
                                    } else {
                                        int counter = 1;
                                        for (Student s : studentList) {
                                            int studentId = s.getStudentId();
                                %>
                                        <tr>
                                            <td style="text-align: center;"><%= counter++ %></td>
                                            <td><b><%= s.getStudentName() %></b></td>
                                            <td><%= s.getMykid() %></td>
                                            <td style="text-align: center;"><%= s.getGradeYear() %></td>
                                            <td style="text-align: center;"><%= s.getClassName() %></td>
                                            <td style="text-align: center;">
                                                <input type="hidden" name="studentIds" value="<%= studentId %>">
                                                <select name="status_<%= studentId %>" style="width: 90%; margin: 0 auto;">
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
                        </div>
                    </form>
                </main>
            </div>
            
        </div>
    </body>
</html>
