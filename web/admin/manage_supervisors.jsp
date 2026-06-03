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
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Pendaftaran Guru Penasihat</h1>
            
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <fieldset>
                <legend>Daftar Guru Baharu</legend>
                
                <form action="manage_supervisors.jsp" method="post">
                    <label for="newUsername">Nama Pengguna:</label>
                    <input type="text" id="newUsername" name="newUsername" required>
            
                    <label for="password">Kata Laluan:</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                    
                    <p>
                        <label for="category">Kategori Kokurikulum:</label>
                        <select id="category" name="category" onchange="updateUnits()" required style="width: 100%; padding: 5px;">
                            <option value="Unit Beruniform">Unit Beruniform</option>
                            <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                            <option value="Sukan & Permainan">Sukan & Permainan</option>
                        </select>
                    </p>
                    <p>
                        <label for="unit">Unit Ditugaskan:</label>
                        <select id="unit" name="unit" required style="width: 100%; padding: 5px;">
                        </select>
                    </p>
            
                    <button type="submit" class="btn-primary">Daftar Guru</button>
                </form>
            
            <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String usernameInput = request.getParameter("newUsername");
                String passwordInput = request.getParameter("newPassword");
                String categoryInput = request.getParameter("category");
                String unitInput = request.getParameter("unit");
            
                try {
                    String hashedPassword = SecurityUtils.hashPassword(passwordInput);
                    
                    // SUPERVISOR role in hardcoded
                    User newUser = new User(0, usernameInput, hashedPassword, "SUPERVISOR", categoryInput, unitInput);
                    
                    if (UserDAO.addUser(newUser)) {
                        out.println("<p class='success-text'>Pendaftaran berjaya! Akaun guru sedia untuk digunakan.</p>");
                    } else {
                        out.println("<p class='error-text'>Ralat: Nama pengguna ini telah wujud.</p>");
                    } 
                } catch (Exception e) {
                    out.println("<p class='error-text'>Ralat: " + e.getMessage() + "</p>");
                } 
            }
            %>
            </fieldset>
            
            <fieldset style="margin-bottom: 15px; width: 100%;">
                <label for="searchInput"><b>Carian Guru:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 3)" placeholder="Cari username...">
            </fieldset>
                
            <fieldset style="width: 100%;">
                <table id="table">
                    <caption>Direktori Pengguna Sistem</caption>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Kategori</th>
                        <th>Unit Ditugaskan</th>
                        <th>Tindakan</th>
                    </tr>
                <%
                    ArrayList<User> supervisorList = UserDAO.getAllSupervisors();
                    
                    for (User spv : supervisorList) {
                %>
                        <tr>
                            <td><%= spv.getUserId() %></td>
                            <td><%= spv.getUsername() %></td>
                            <td><%= spv.getAssignedCategory() %></td>
                            <td><%= spv.getAssignedUnit() %></td>
                            <td>
                                <a href="../DeleteSupervisorServlet?id=<%= spv.getUserId() %>"
                                   onclick="return confirm('Padam pengguna ini?');"
                                   class="btn-danger">
                                   Padam
                                </a>
                            </td>
                        </tr>
                <%
                    }
                %>
                </table>
            </fieldset>
        </main>
            
        <script src="../js/search.js"></script>
    </body>
</html>
