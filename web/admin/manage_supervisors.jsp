<%-- 
    Document   : manage_supervisors
    Created on : May 26, 2026, 10:29:39 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.spis.models.User, com.spis.dao.UserDAO, com.spis.utils.SecurityUtils, java.util.ArrayList" %>

<%
    // Checks if the user is admin or not (security)
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; // stop page from loading
    }
    
    String alertMessage = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String usernameInput = request.getParameter("newUsername");
        String passwordInput = request.getParameter("newPassword");
        String categoryInput = request.getParameter("category");
        String unitInput = request.getParameter("unit");
    
        try {
            String hashedPassword = SecurityUtils.hashPassword(passwordInput);
            
            // SUPERVISOR role is hardcoded
            User newUser = new User(0, usernameInput, hashedPassword, "SUPERVISOR", categoryInput, unitInput);
            
            if (UserDAO.addUser(newUser)) {
                alertMessage = "<p class='success-text' style='margin-bottom: 15px;'>Pendaftaran berjaya! Akaun guru sedia untuk digunakan.</p>";
            } else {
                alertMessage = "<p class='error-text' style='margin-bottom: 15px;'>Ralat: Nama pengguna ini telah wujud.</p>";
            } 
        } catch (Exception e) {
            alertMessage = "<p class='error-text' style='margin-bottom: 15px;'>Ralat: " + e.getMessage() + "</p>";
        } 
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        <script src="../js/unit_data.js"></script>
        <title>SPIS - Urus Guru Penasihat</title>
    </head>
    <body>
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Admin</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="../admin_dashboard.jsp">Papan Pemuka</a>
                    
                    <a href="manage_supervisors.jsp" class="active">Urus Guru Penasihat</a>
                    <a href="manage_events.jsp">Urus Senarai Acara</a>
                    <a href="add_student.jsp">Daftar Pelajar Baharu</a>
                    <a href="view_all_students.jsp">Papar Keseluruhan Pelajar</a>
                    <a href="generate_report.jsp">Penjanaan Laporan</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Pendaftaran Guru Penasihat</h2>
                    </div>
                    <div>
                        <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <div style="max-width: 800px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0;">Daftar Guru Baharu</h3>
                        
                        <form action="manage_supervisors.jsp" method="post">
                            <div style="display: flex; gap: 15px; margin-bottom: 15px;">
                                <div style="flex: 1;">
                                    <label for="newUsername">Nama Pengguna (Username):</label>
                                    <input type="text" id="newUsername" name="newUsername" required style="width: 100%;">
                                </div>
                                <div style="flex: 1;">
                                    <label for="password">Kata Laluan (Password):</label>
                                    <input type="password" id="newPassword" name="newPassword" required style="width: 100%;">
                                </div>
                            </div>
                            
                            <div style="display: flex; gap: 15px; margin-bottom: 15px;">
                                <div style="flex: 1;">
                                    <label for="category">Kategori Kokurikulum:</label>
                                    <select id="category" name="category" onchange="updateUnits()" required style="width: 100%; padding: 8px;">
                                        <option value="Unit Beruniform">Unit Beruniform</option>
                                        <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                                        <option value="Sukan & Permainan">Sukan & Permainan</option>
                                    </select>
                                </div>
                                <div style="flex: 1;">
                                    <label for="unit">Unit Ditugaskan:</label>
                                    <select id="unit" name="unit" required style="width: 100%; padding: 8px;">
                                        </select>
                                </div>
                            </div>
                    
                            <button type="submit" class="btn-primary" style="padding: 10px 20px;">Daftar Guru</button>
                        </form>
                    </div>
                    
                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        <div style="margin-bottom: 20px;">
                            <label for="searchInput"><b>Carian Guru:</b></label>
                            <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 3)" placeholder="Cari username atau unit..." style="width: 100%; max-width: 400px; display: block; margin-top: 5px;">
                        </div>
                            
                        <table id="table" style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Kategori</th>
                                <th>Unit Ditugaskan</th>
                                <th style="text-align: center;">Tindakan</th>
                            </tr>
                            <%
                                ArrayList<User> supervisorList = UserDAO.getAllSupervisors();
                                
                                if(supervisorList == null || supervisorList.isEmpty()) {
                            %>
                                <tr><td colspan="5" style="text-align: center; padding: 20px;">Tiada guru penasihat didaftarkan dalam sistem.</td></tr>
                            <%  } else {
                                    for (User spv : supervisorList) {
                            %>
                                    <tr>
                                        <td style="text-align: center;"><%= spv.getUserId() %></td>
                                        <td><b><%= spv.getUsername() %></b></td>
                                        <td><%= spv.getAssignedCategory() %></td>
                                        <td><%= spv.getAssignedUnit() %></td>
                                        <td style="text-align: center;">
                                            <a href="../DeleteSupervisorServlet?id=<%= spv.getUserId() %>"
                                               onclick="return confirm('Padam pengguna ini?');"
                                               class="btn-danger" style="padding: 5px 10px; font-size: 0.9em;">Padam</a>
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