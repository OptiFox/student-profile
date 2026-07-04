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
    
    // Logic is on top so that roles.js detects the changes for the student role safeguard
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
        <header class="flex">
            <h1>SPIS - Pengurusan Jawatan: <%= assignedUnit != null ? assignedUnit : "" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <fieldset>
                <legend>Lantik / Kemaskini Jawatan Pelajar</legend>
                
                <form action="update_role.jsp" method="post">
                    <p>
                        <label for="studentId">Pilih Pelajar:</label>
                        <select name="studentId" id="studentId" required>
                            <option value="">-- Sila Pilih Pelajar --</option>
                            <%
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
                            %>
                        </select>
                    </p>
                    
                    <p>
                        <label for="newRole">Jawatan Baharu:</label>
                        <select name="newRole" id="newRole" required>
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
                    
                    <button type="submit" class="btn-primary">Kemaskini Jawatan</button>
                </form>
                        
                <%= alertMessage %>
            </fieldset>
        </main>
            
        <script src="../js/roles.js"></script>
    </body>
</html>
