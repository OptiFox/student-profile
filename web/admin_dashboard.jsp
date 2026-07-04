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
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Admin</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="admin_dashboard.jsp" class="active">Papan Pemuka</a>
                    
                    <a href="admin/manage_supervisors.jsp">Urus Guru Penasihat</a>
                    <a href="admin/manage_events.jsp">Urus Senarai Acara</a>
                    <a href="admin/add_student.jsp">Daftar Pelajar Baharu</a>
                    <a href="admin/view_all_students.jsp">Papar Keseluruhan Pelajar</a>
                    <a href="admin/generate_report.jsp">Penjanaan Laporan</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Selamat Datang, PK Kokurikulum!</h2>
                    </div>
                    <div>
                        </div>
                </header>
                
                <main class="content-body">
                    <fieldset style="background-color: white; border-radius: 8px; border: 1px solid #e0e0e0; padding: 25px;">
                        <legend style="background-color: #34495e; color: white; padding: 5px 15px; border-radius: 4px;">Ringkasan Sistem</legend>
                        <h3 style="color: #2c3e50; margin-top: 0;">Sistem Profil Pelajar (SPIS) - Modul Pentadbir</h3>
                        <p style="color: #555; line-height: 1.6;">
                            Selamat datang ke Modul Pentadbir. Sila gunakan menu navigasi di sebelah kiri untuk:
                        </p>
                        <ul style="color: #555; line-height: 1.8; margin-bottom: 20px;">
                            <li>Mengurus akaun guru penasihat dan penempatan unit.</li>
                            <li>Mendaftarkan acara dan pertandingan rasmi kokurikulum.</li>
                            <li>Menguruskan rekod dan profil peribadi pelajar.</li>
                            <li>Menjana dan mencetak laporan markah PAJSK keseluruhan pelajar mengikut tahun.</li>
                        </ul>
                        
                        <div style="margin-top: 20px;">
                            <a href="admin/add_student.jsp" class="btn-primary" style="text-decoration: none; padding: 10px 20px; display: inline-block;">
                                + Daftar Pelajar Baharu
                            </a>
                        </div>
                    </fieldset>
                </main>
            </div>
            
        </div>
    </body>
</html>