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
    String assignedUnit = (String) session.getAttribute("assignedUnit");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("login.jsp");
        return; // stop page from loading
    }
    
    // Fallback just in case
    if (assignedUnit == null) assignedUnit = "Unit Kokurikulum";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/style.css">
        <title>SPIS - Supervisor Dashboard</title>
    </head>
    <body>
        <div class="dashboard-layout">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>SPIS Guru</h2>
                    <p style="margin-top: 5px; font-size: 0.85em; color: #3498db;"><%= assignedUnit %></p>
                </div>
                <nav class="sidebar-nav">
                    <a href="supervisor_dashboard.jsp" class="active">Papan Pemuka</a>
                    
                    <a href="supervisor/view_unit_students.jsp">Senarai Pelajar Unit</a>
                    <a href="supervisor/take_attendance.jsp">Kemaskini Kehadiran</a>
                    <a href="supervisor/add_achievement.jsp">Log Pencapaian</a>
                    <a href="supervisor/update_role.jsp">Kemaskini Jawatan Pelajar</a>
                    <a href="supervisor/manage_records.jsp">Urus & Padam Rekod</a>
                </nav>
                <div class="sidebar-footer">
                    <a href="logout.jsp" class="btn-danger">Log Keluar</a>
                </div>
            </aside>
            
            <div class="main-content">
                <header class="top-header">
                    <div>
                        <h2 style="margin: 0; color: #2c3e50;">Selamat Datang, <%= currentUser %>!</h2>
                    </div>
                    <div>
                        </div>
                </header>
                
                <main class="content-body">
                    <fieldset style="background-color: white; border-radius: 8px; border: 1px solid #e0e0e0; padding: 25px;">
                        <legend style="background-color: #34495e; color: white; padding: 5px 15px; border-radius: 4px;">Ringkasan Modul</legend>
                        <h3 style="color: #2c3e50; margin-top: 0;">Pengurusan: <%= assignedUnit %></h3>
                        <p style="color: #555; line-height: 1.6;">
                            Selamat datang ke Modul Guru Penasihat. Sila gunakan menu navigasi di sebelah kiri untuk melaksanakan tugas-tugas berikut:
                        </p>
                        <ul style="color: #555; line-height: 1.8; margin-bottom: 20px;">
                            <li>Menyemak senarai penuh pelajar di bawah seliaan anda.</li>
                            <li>Merekod kehadiran perjumpaan mingguan kokurikulum.</li>
                            <li>Mendaftar log pencapaian pelajar dalam acara dan pertandingan.</li>
                            <li>Mengemaskini jawatan (AJK, Setiausaha, dll.) bagi setiap pelajar.</li>
                            <li>Mengurus dan membetulkan kesilapan rekod terdahulu.</li>
                        </ul>
                        
                        <div style="display: flex; gap: 15px; margin-top: 20px;">
                            <a href="supervisor/take_attendance.jsp" class="btn-primary" style="text-decoration: none; padding: 10px 20px;">
                                📝 Ambil Kehadiran
                            </a>
                            <a href="supervisor/add_achievement.jsp" class="btn-success" style="text-decoration: none; padding: 10px 20px;">
                                🏆 Tambah Pencapaian
                            </a>
                        </div>
                    </fieldset>
                </main>
            </div>
            
        </div>
    </body>
</html>