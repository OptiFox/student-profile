<%-- 
    Document   : view_all_students
    Created on : May 28, 2026, 11:44:23 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
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
            <fieldset style="margin-bottom: 15px; width: 100%;">
                <label for="searchInput"><b>Carian Pelajar:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari Nama atau MyKid...">

                <table id="table">
                    <caption>Pangkalan Data Pelajar Keseluruhan</caption>
                    <tr>
                        <th>ID</th>
                        <th>Nama Penuh</th>
                        <th>MyKid</th>
                        <th>Jantina</th>
                        <th>Kaum</th>
                        <th>Tahun</th>
                        <th>Kelas</th>
                        <th>Unit Beruniform</th>
                        <th>Kelab & Persatuan</th>
                        <th>Sukan & Permainan</th>
                    </tr>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                            
                            String query = "SELECT * FROM Students ORDER BY grade_year ASC, class_name ASC, student_name ASC"; 
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();
                            
                            while (rs.next()) {
                    %>
                                <tr>
                                    <td><%= rs.getInt("student_id") %></td>
                                    <td><%= rs.getString("student_name") %></td>
                                    <td><%= rs.getString("mykid") %></td>
                                    <td><%= rs.getString("gender") %></td>
                                    <td><%= rs.getString("race") %></td>
                                    <td>Tahun <%= rs.getInt("grade_year") %></td> <td><%= rs.getString("class_name") %></td>
                                    <td><%= rs.getString("uniform_unit") %></td>
                                    <td><%= rs.getString("club") %></td>
                                    <td><%= rs.getString("sport") %></td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='10' class='error-text'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </table>
            </fieldset>
        </main>
            
        <script src="../js/search.js"></script>
    </body>
</html>
