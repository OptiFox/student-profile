<%-- 
    Document   : view_all_students
    Created on : May 28, 2026, 11:44:23 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.spis.models.Student, com.spis.dao.StudentDAO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    ArrayList<Student> list = StudentDAO.getAllStudents();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Senarai Keseluruhan Pelajar</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Senarai Keseluruhan Pelajar</h1>
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <fieldset style="margin-bottom: 20px; width: 100%;">
                <legend>Carian & Tapisan Pantas</legend>
                <label for="searchInput"><b>Carian Pelajar:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari Nama atau MyKid...">
            </fieldset>

            <fieldset style="width: 100%;">
                <table id="table">
                    <caption>Pangkalan Data Pelajar Keseluruhan</caption>
                    <tr>
                        <th>Bil.</th>
                        <th>Nama Penuh</th>
                        <th>No. MyKid</th>
                        <th>Tahun</th>
                        <th>Kelas</th>
                        <th>Tindakan</th>
                    </tr>
                    <%  if (list.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="text-align: center;">Tiada rekod pelajar ditemui.</td>
                    </tr>
                    <%  
                        } else { 
                            int counter = 1; // for bil. row numbers
                            for (Student row : list) {
                    %>
                                <tr>
                                    <td><%= counter++ %></td>
                                    <td><%= row.getStudentName() %></td>
                                    <td><%= row.getMykid() %></td>
                                    <td>Tahun <%= row.getGradeYear() %></td> 
                                    <td><%= row.getClassName() %></td>
                                    <td>
                                        <a href="view_profile.jsp?id=<%= row.getStudentId() %>" class="btn-primary">Lihat Profil</a>
                                        <a href="edit_student.jsp?id=<%= row.getStudentId() %>" class="btn-warning">Kemaskini</a>
                                        <a href="../DeleteStudentServlet?id=<%= row.getStudentId() %>"
                                           onclick="return confirm('Amaran: Adakah anda pasti mahu memadam rekod pelajar ini secara kekal? Tindakan ini tidak boleh diundur.');"
                                           class="btn-danger">Padam</a>
                                    </td>
                                </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </fieldset>
        </main>
            
        <script src="../js/search.js"></script>
    </body>
</html>
