<%-- 
    Document   : admin_dashboard
    Created on : May 25, 2026, 10:14:15 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Checks if the user is admin or not (security)
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("login.jsp");
        return; // stop page from loading
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css">
        
        <title>SPIS - Admin Dashboard</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Modul Pentadbir</h1>
            
            <a href="logout.jsp" class="btn-danger">Log Keluar</a>
        </header>
        
        <main>
            <h2>Selamat Datang, PK Kokurikulum</h2>
        
            <p>Sila pilih pengurusan di bawah:</p>
        
            <fieldset>
                <legend><b>Menu Utama</b></legend>
                <ul class="btn">
                    <li style="margin-bottom: 10px;">
                        <a href="admin/manage_supervisors.jsp">
                            <button class="btn-primary" style="width: 250px;">Urus Guru Penasihat</button>
                        </a>
                    </li>
                    <li style="margin-bottom: 10px;">
                        <a href="admin/manage_events.jsp">
                            <button class="btn-primary" style="width: 250px;">Urus Senarai Acara / Pertandingan</button>
                        </a>
                    </li>
                    <li style="margin-bottom: 10px;">
                        <button class="btn-secondary" style="width: 250px;">Papar Keseluruhan Pelajar</button>
                    </li>
                </ul>
            </fieldset>
        </main>
        
    </body>
</html>
