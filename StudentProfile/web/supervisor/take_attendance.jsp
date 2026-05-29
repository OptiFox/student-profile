<%-- 
    Document   : take_attendance
    Created on : May 29, 2026, 3:31:28 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit"); 
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
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
                        <th>MyKid</th>
                        <th>Tahun</th>
                        <th>Kelas</th>
                        <th>Status Kehadiran</th>
                    </tr>
                    
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        int counter = 1;
                        
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                            
                            String query = "SELECT * FROM Students WHERE uniform_unit = ? OR sport = ? OR club = ? "
                                    + "ORDER BY grade_year ASC, class_name ASC, student_name ASC";

                            //String query = "SELECT * FROM Students WHERE uniform_unit = 'Pengakap'"; used this for hardcoded test
                            
                            stmt = conn.prepareStatement(query);
                            stmt.setString(1, assignedUnit);
                            stmt.setString(2, assignedUnit);
                            stmt.setString(3, assignedUnit);
                            
                            rs = stmt.executeQuery();
                            
                            boolean foundData = false;
                            
                            while (rs.next()) {
                                foundData = true;
                                int studentId = rs.getInt("student_id");
                    %>
                    
                            <tr>
                                <td><%= counter++ %></td>
                                <td><%= rs.getString("student_name") %></td>
                                <td><%= rs.getString("mykid") %></td>
                                <td><%= rs.getInt("grade_year") %></td>
                                <td><%= rs.getString("class_name") %></td>
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
                            
                            if (!foundData) {
                                out.println("<tr><td colspan='6' class='error-text'>Tiada pelajar dijumpai untuk unit: " + assignedUnit + "</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='error-text'>Ralat: " + e.getMessage() + "</td><tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </table>
                
                <br>
                
                <button type="submit" class="btn-primary">Simpan Kehadiran</button>
            </form>
                
            <%
                // batch processing
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String meetDate = request.getParameter("meetDate");
                    String activityTitle = request.getParameter("activityTitle");
                    String extraNotes = request.getParameter("extraNotes");
                    String[] studentIds = request.getParameterValues("studentIds"); 
                    
                    if (studentIds != null && studentIds.length > 0) {
                        Connection insertConn = null;
                        PreparedStatement insertStmt = null;
                        
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");

                            insertConn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");

                            String insertQuery = "INSERT INTO Attendance (student_id, unit_name, meet_date, activity_title, extra_notes, status) VALUES (?, ?, ?, ?, ?, ?)";
                            insertStmt = insertConn.prepareStatement(insertQuery);
                            
                            for (String idStr : studentIds) {
                                int sId = Integer.parseInt(idStr);
                                String status = request.getParameter("status_" + sId);
                                
                                insertStmt.setInt(1, sId);
                                insertStmt.setString(2, assignedUnit);
                                insertStmt.setDate(3, java.sql.Date.valueOf(meetDate));
                                insertStmt.setString(4, activityTitle);
                                insertStmt.setString(5, extraNotes);
                                insertStmt.setString(6, status);
                                
                                insertStmt.addBatch();
                            }

                            insertStmt.executeBatch();
                            out.println("<p style='color: green; font-weight: bold; margin-top: 15px; text-align: center;'>Rekod kehadiran berjaya disimpan!</p>");
                            
                        } catch (Exception e) {
                            out.println("<p class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</p>");
                        } finally {
                            if (insertStmt != null) insertStmt.close();
                            if (insertConn != null) insertConn.close();
                        }
                    }
                }
            %>
        </main>
    </body>
</html>
