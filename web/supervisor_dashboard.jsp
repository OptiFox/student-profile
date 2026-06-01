<%-- 
    Document   : supervisor_dashboard
    Created on : May 25, 2026, 10:14:28 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // check for supervisor role
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("login.jsp");
        return; // stop page from loading
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css">
        
        <title>SPIS - Supervisor Dashboard</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Modul Guru Penasihat</h1>
            
            <a href="logout.jsp" class="btn-danger">Log Keluar</a>
        </header>
        
        <main>
            <h2>Selamat Datang, Guru Penasihat (<%= currentUser %>)</h2>
            <p>Sila pilih pengurusan di bawah:</p>
            
            <fieldset>
                <legend><b>Menu Utama</b></legend>
                <ul class="btn">
                    <li>
                        <a href="supervisor/take_attendance.jsp">
                            <button class="btn-primary" style="width: 250px;">Kemaskini Kehadiran</button>
                        </a>
                    </li>
                    <li>
                        <a href="supervisor/add_achievement.jsp">
                            <button class="btn-primary" style="width: 250px;">Log Pencapaian</button>
                        </a>
                    </li>
                </ul>
            </fieldset>
        </main>
    </body>
</html>
