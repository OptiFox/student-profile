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
        <div class="dashboard-layout">
            
            <aside class="sidebar">
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
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Senarai Keseluruhan Pelajar</h2>
                    </div>
                    <div>
                        <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    
                    <div style="background: white; padding: 20px 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 25px;">
                        <label for="searchInput" style="font-weight: bold; color: #2c3e50; font-size: 1.1em;">Carian Pantas Pelajar:</label>
                        <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Sila taip Nama Penuh atau No. MyKid..." style="width: 100%; max-width: 600px; display: block; margin-top: 10px; padding: 12px; font-size: 1em;">
                    </div>

                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        <table id="table" style="width: 100%; border-collapse: collapse;">
                            <caption style="text-align: left; margin-bottom: 15px; font-size: 1.2em; color: #34495e; font-weight: bold;">Pangkalan Data Pelajar Keseluruhan</caption>
                            <tr>
                                <th style="width: 5%;">Bil.</th>
                                <th style="width: 30%;">Nama Penuh</th>
                                <th style="width: 15%;">No. MyKid</th>
                                <th style="width: 10%;">Tahun</th>
                                <th style="width: 15%;">Kelas</th>
                                <th style="width: 25%; text-align: center;">Tindakan</th>
                            </tr>
                            <%  if (list.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">Tiada rekod pelajar ditemui. Sila daftar pelajar baharu.</td>
                            </tr>
                            <%  
                                } else { 
                                    int counter = 1; 
                                    for (Student row : list) {
                            %>
                                    <tr>
                                        <td style="text-align: center;"><%= counter++ %></td>
                                        <td><b><%= row.getStudentName() %></b></td>
                                        <td><%= row.getMykid() %></td>
                                        <td style="text-align: center;">Tahun <%= row.getGradeYear() %></td> 
                                        <td style="text-align: center;"><%= row.getClassName() %></td>
                                        <td style="text-align: center; display: flex; justify-content: center; gap: 5px;">
                                            <a href="view_profile.jsp?id=<%= row.getStudentId() %>" class="btn-primary" style="padding: 6px 12px; font-size: 0.9em; text-decoration: none;">Profil</a>
                                            <a href="edit_student.jsp?id=<%= row.getStudentId() %>" class="btn-warning" style="padding: 6px 12px; font-size: 0.9em; text-decoration: none;">Kemaskini</a>
                                            <a href="../DeleteStudentServlet?id=<%= row.getStudentId() %>"
                                               onclick="return confirm('Amaran: Adakah anda pasti mahu memadam rekod pelajar ini secara kekal? Tindakan ini tidak boleh diundur.');"
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
        <script src="../js/search.js"></script>
    </body>
</html>