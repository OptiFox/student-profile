<%-- 
    Document   : view_profile
    Created on : Jun 1, 2026, 12:39:51 PM
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
    
    // get student id from url
    String studentIdStr = request.getParameter("id");
    if (studentIdStr == null || studentIdStr.isEmpty()) {
        out.println("<p class='error-text'>Ralat: ID Pelajar tidak dijumpai.</p>");
        return;
    }
    
    int studentId = Integer.parseInt(studentIdStr);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Profil Lengkap Pelajar</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Paparan Profil Lengkap</h1>
            <div>
                <a href="view_all_students.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <%
                Connection conn = null;
                PreparedStatement profileStmt = null;
                ResultSet profileRs = null;
                
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    String profileQuery = "SELECT * FROM Students WHERE student_id = ?";
                    
                    profileStmt = conn.prepareStatement(profileQuery);
                    profileStmt.setInt(1, studentId);
                    
                    profileRs = profileStmt.executeQuery();
                    
                    if (profileRs.next()) {
            %>
                        <div class="profile-section">
                            <h3>1. Maklumat Peribadi</h3>
                            <p><b>Nama Penuh:</b> <%= profileRs.getString("student_name") %></p>
                            <p><b>No. MyKid:</b> <%= profileRs.getString("mykid") %></p>
                            <p><b>Kelas:</b> <%= profileRs.getInt("grade_year") %> <%= profileRs.getString("class_name") %></p>
                        </div>
                        
                        <div class="profile-section">
                            <h3>2. Jadual Penempatan Kokurikulum</h3>
                            <table>
                                <tr>
                                    <th>Kategori</th>
                                    <th>Nama Aktiviti</th>
                                    <th>Jawatan</th>
                                </tr>
                                <tr>
                                    <td>Unit Beruniform</td>
                                    <td><%= profileRs.getString("uniform_unit") != null ? profileRs.getString("uniform_unit") : "Tiada" %></td>
                                    <td><%= profileRs.getString("uniform_role") != null ? profileRs.getString("uniform_role") : "Ahli Biasa" %></td>
                                </tr>
                                <tr>
                                    <td>Kelab & Persatuan</td>
                                    <td><%= profileRs.getString("club") != null ? profileRs.getString("club") : "Tiada" %></td>
                                    <td><%= profileRs.getString("club_role") != null ? profileRs.getString("club_role") : "Ahli Biasa" %></td>
                                </tr>
                                <tr>
                                    <td>Sukan & Permainan</td>
                                    <td><%= profileRs.getString("sport") != null ? profileRs.getString("sport") : "Tiada" %></td>
                                    <td><%= profileRs.getString("sport_role") != null ? profileRs.getString("sport_role") : "Ahli Biasa" %></td>
                                </tr>
                            </table>
                        </div>
                                
                        <div class="profile-section">
                            <h3>3. Jadual Rekod Kehadiran</h3>
                            <p><i>(Sistem pengiraan kehadiran akan diletakkan di sini)</i></p>
                        </div>
                                
                        <div class="profile-section">
                            <h3>4. Jadual Log Pencapaian</h3>
                            
                            <table>
                                <tr>
                                    <th>Tarikh</th>
                                    <th>Nama Pertandingan</th>
                                    <th>Peringkat</th>
                                    <th>Pencapaian</th>
                                </tr>
                                <%
                                    // fetch achievements
                                    PreparedStatement achStmt = null;
                                    ResultSet achRs = null;
                                    
                                    try {
                                        String achQuery = "SELECT e.event_date, e.event_name, a.comp_level, a.result "
                                                + "FROM Achievements a, Events e "
                                                + "WHERE a.event_id = e.event_id "
                                                + "AND a.student_id = ? ORDER BY e.event_date DESC";
                                        
                                        achStmt = conn.prepareStatement(achQuery);
                                        achStmt.setInt(1, studentId);
                                        achRs = achStmt.executeQuery();
                                        
                                        boolean hasAchievements = false;
                                        
                                        while (achRs.next()) {
                                            hasAchievements = true;
                                %>
                                            <tr>
                                                <td><%= achRs.getDate("event_date") %></td>
                                                <td><%= achRs.getString("event_name") %></td>
                                                <td><%= achRs.getString("comp_level") %></td>
                                                <td><%= achRs.getString("result") %></td>
                                            </tr>
                                <%      
                                        }
                                        
                                        if (!hasAchievements) {
                                            out.println("<tr><td colspan='4' style='text-align: center;'>Tiada rekod pencapaian.</td></tr>");
                                        }
                                    } finally {
                                        if (achRs != null) achRs.close();
                                        if (achStmt != null) achStmt.close();
                                    }
                                %>
                            </table>
                        </div>
                            
                        <div class="profile-section">
                            <h3>5. Ringkasan Markah PAJSK</h3>
                            <p><i>(Enjin pengiraan markah PAJSK akan diletakkan di sini)</i></p>
                        </div>
            <%
                    } else {
                        out.println("<p class='error-text'>Pelajar tidak dijumpai dalam pangkalan data.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat Sistem: " + e.getMessage() + "</p>");
                } finally {
                    if (profileRs != null) profileRs.close();
                    if (profileStmt != null) profileStmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </main>
    </body>
</html>
