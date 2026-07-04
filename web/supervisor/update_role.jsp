<%-- 
    Document   : update_role.jsp
    Created on : Jun 1, 2026, 11:14:10 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.spis.models.Student, com.spis.dao.StudentDAO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit");
    String assignedCategory = (String) session.getAttribute("assignedCategory");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    // Logic is on top so that roles.js detects the changes for the student role
    String alertMessage = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String newRole = request.getParameter("newRole");

        if (assignedCategory == null) {
            alertMessage = "<p class='error-text'>Ralat Sistem: Kategori tidak dijumpai.</p>";
        } else {
            if (StudentDAO.updateStudentRole(studentId, assignedCategory, newRole)) {
                alertMessage = "<p class='success-text'>Jawatan pelajar berjaya dikemaskini!</p>";
            } else {
                alertMessage = "<p class='error-text'>Ralat Pangkalan Data semasa kemaskini.</p>";
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
        <title>SPIS - Kemaskini Jawatan</title>
    </head>
    <body>
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Guru</h2>
                    <p style="margin-top: 5px; font-size: 0.85em; color: #3498db;"><%= assignedUnit != null ? assignedUnit : "Unit Tidak Ditetapkan" %></p>
                </div>
                <nav class="sidebar-nav">
                    <a href="../supervisor_dashboard.jsp">Papan Pemuka</a>
                    
                    <a href="view_unit_students.jsp">Senarai Pelajar Unit</a>
                    <a href="take_attendance.jsp">Kemaskini Kehadiran</a>
                    <a href="add_achievement.jsp">Log Pencapaian</a>
                    <a href="update_role.jsp" class="active">Kemaskini Jawatan Pelajar</a>
                    <a href="manage_records.jsp">Urus & Padam Rekod</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Pengurusan Jawatan: <%= assignedUnit != null ? assignedUnit : "" %></h2>
                    </div>
                    <div>
                        <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <div style="max-width: 600px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0; color: #34495e;">Lantik / Kemaskini Jawatan Pelajar</h3>
                        
                        <form action="update_role.jsp" method="post">
                            <p>
                                <label for="studentId">Pilih Pelajar:</label>
                                <select name="studentId" id="studentId" required style="width: 100%;">
                                    <option value="">-- Sila Pilih Pelajar --</option>
                                    <%
                                        if (studentList != null) {
                                            for (Student s : studentList) {
                                                String currentStudentRole = "Ahli Biasa";
                                                if ("Kelab & Persatuan".equals(assignedCategory)) currentStudentRole = s.getClubRole();
                                                else if ("Sukan & Permainan".equals(assignedCategory)) currentStudentRole = s.getSportRole();
                                                else currentStudentRole = s.getUniformRole();
                                    %>
                                                <option value="<%= s.getStudentId() %>" data-role="<%= currentStudentRole %>">
                                                    <%= s.getStudentName() %> (<%= s.getGradeYear() %> <%= s.getClassName() %>)
                                                </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </p>
                            
                            <p>
                                <label for="newRole">Jawatan Baharu:</label>
                                <select name="newRole" id="newRole" required style="width: 100%;">
                                    <option value="Ahli Biasa">Ahli Biasa</option>
                                    <option value="Pengerusi">Pengerusi</option>
                                    <option value="Naib Pengerusi">Naib Pengerusi</option>
                                    <option value="Setiausaha">Setiausaha</option>
                                    <option value="Penolong Setiausaha">Penolong Setiausaha</option>
                                    <option value="Bendahari">Bendahari</option>
                                    <option value="Penolong Bendahari">Penolong Bendahari</option>
                                    <option value="Ahli Jawatankuasa (AJK)">Ahli Jawatankuasa (AJK)</option>
                                </select>
                            </p>
                            
                            <button type="submit" class="btn-primary" style="padding: 10px 20px; font-size: 1.05em; margin-top: 15px;">Kemaskini Jawatan</button>
                        </form>
                    </div>
                </main>
            </div>
            
        </div>
            
        <script src="../js/roles.js"></script>
    </body>
</html>