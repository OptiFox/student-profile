<%-- 
    Document   : add_student
    Created on : May 28, 2026, 10:45:55 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.spis.models.Student, com.spis.dao.StudentDAO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String alertMessage = ""; 
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String studentName = request.getParameter("studentName");
        String mykid = request.getParameter("mykid");
        String gender = request.getParameter("gender");
        String race = request.getParameter("race");
        int gradeYear = Integer.parseInt(request.getParameter("year"));
        String className = request.getParameter("class");
        String uniform = request.getParameter("uniform");
        String club = request.getParameter("kelab");
        String sport = request.getParameter("sukan");
        
        try {
            Student student = new Student(0, studentName, mykid, gender, race, gradeYear, className, 
                                          uniform, club, sport, "Ahli Biasa", "Ahli Biasa", "Ahli Biasa");
            
            if (StudentDAO.addStudent(student)) {
                alertMessage = "<p class='success-text'>Rekod pelajar berjaya disimpan!</p>";
            } else {
                alertMessage = "<p class='error-text'>Ralat: MyKid ini telah didaftarkan dalam sistem.</p>";
            }
        } catch (Exception e) {
            alertMessage = "<p class='error-text'>Ralat: " + e.getMessage() + "</p>";
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css" />
        <title>SPIS - Daftar Pelajar Baharu</title>
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
                    <a href="add_student.jsp" class="active">Daftar Pelajar Baharu</a>
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
                        <h2 style="margin: 0; color: #2c3e50;">Pendaftaran Pelajar Baharu</h2>
                    </div>
                    <div>
                        <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>

                    <form action="add_student.jsp" method="post" style="max-width: 800px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        
                        <fieldset style="margin-bottom: 20px;">
                            <legend>Maklumat Peribadi Pelajar</legend>

                            <p>
                                <label for="studentName">Nama Penuh Pelajar:</label>
                                <input type="text" name="studentName" id="studentName" required style="width: 100%;" />
                            </p>

                            <p>
                                <label for="mykid">No. MyKid:</label>
                                <input type="text" name="mykid" id="mykid" placeholder="XXXXXX-XX-XXXX" required style="width: 100%;" />
                            </p>

                            <p style="margin-top: 15px; margin-bottom: 5px; font-weight: bold; color: #34495e;">Jantina:</p>
                            <label for="male" style="font-weight: normal; margin-right: 15px;">
                              <input type="radio" name="gender" id="male" value="Lelaki" required />
                              Lelaki
                            </label>
                            <label for="female" style="font-weight: normal;">
                              <input type="radio" name="gender" id="female" value="Perempuan" required />
                              Perempuan
                            </label>

                            <p style="margin-top: 15px;">
                                <label for="race">Kaum:</label>
                                <select name="race" id="race" style="width: 100%;">
                                  <option value="Melayu">Melayu</option>
                                  <option value="Cina">Cina</option>
                                  <option value="India">India</option>
                                  <option value="Lain-lain">Lain-lain</option>
                                </select>
                            </p>

                            <div style="display: flex; gap: 15px; margin-top: 15px;">
                                <div style="flex: 1;">
                                    <label for="year">Tahun / Darjah:</label>
                                    <select name="year" id="year" style="width: 100%;">
                                      <option value="4">Darjah 4</option>
                                      <option value="5">Darjah 5</option>
                                      <option value="6">Darjah 6</option>
                                    </select>
                                </div>
                                <div style="flex: 1;">
                                    <label for="class">Nama Kelas:</label>
                                    <select name="class" id="class" style="width: 100%;">
                                      <option value="Alamanda">Alamanda</option>
                                      <option value="Bourgenvilla">Bourgenvilla</option>
                                      <option value="Camellia">Camellia</option>
                                      <option value="Dahlia">Dahlia</option>
                                      <option value="Eugenia">Eugenia</option>
                                    </select>
                                </div>
                            </div>
                        </fieldset>

                        <fieldset style="margin-bottom: 20px;">
                            <legend>Penempatan Kokurikulum</legend>

                            <p>
                                <label for="uniform">Unit Beruniform:</label>
                                <select name="uniform" id="uniform" style="width: 100%;">
                                  <option value="Tiada">Tiada</option>
                                  <option value="Pengakap">Pengakap</option>
                                  <option value="TKRS">Tunas Kadet Remaja Sekolah (TKRS)</option>
                                  <option value="BSMM">Bulan Sabit Merah Malaysia (BSMM)</option>
                                  <option value="PPIM">Puteri Islam (PPIM)</option>
                                  <option value="PPT">Pandu Puteri Tunas</option>
                                </select>
                            </p>

                            <p>
                                <label for="kelab">Kelab & Persatuan:</label>
                                <select name="kelab" id="kelab" style="width: 100%;">
                                  <option value="Tiada">Tiada</option>
                                  <option value="Bahasa Melayu">Persatuan Bahasa Melayu</option>
                                  <option value="Bahasa Inggeris">Persatuan Bahasa Inggeris</option>
                                  <option value="Rukun Negara">Kelab Rukun Negara</option>
                                  <option value="STEM">Kelab STEM/Sains</option>
                                  <option value="Komputer">Kelab Komputer</option>
                                  <option value="Agama Islam">Persatuan Agama Islam</option>
                                </select>
                            </p>

                            <p>
                                <label for="sukan">Sukan & Permainan:</label>
                                <select name="sukan" id="sukan" style="width: 100%;">
                                  <option value="Tiada">Tiada</option>
                                  <option value="Bola Sepak">Bola Sepak</option>
                                  <option value="Bola Jaring">Bola Jaring</option>
                                  <option value="Olahraga">Olahraga</option>
                                  <option value="Badminton">Badminton</option>
                                  <option value="Sepak Takraw">Sepak Takraw</option>
                                </select>
                            </p>
                        </fieldset>

                        <button type="submit" class="btn-primary" style="padding: 10px 20px; font-size: 1.05em;">Simpan Rekod Pelajar</button>
                    </form>
                </main>
            </div>
            
        </div>
    </body>
</html>
