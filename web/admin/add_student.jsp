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
        
        <title>SPIS - Daftar Pelajar</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Modul Guru Penasihat</h1>
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <div class="flex-center">
                <%= alertMessage %>

                <form action="add_student.jsp" method="post">
                  <h2>Pendaftaran & Penempatan</h2>
                  <fieldset>
                    <legend>Maklumat Peribadi Pelajar</legend>

                    <label for="studentName">Nama Penuh Pelajar:</label>
                    <input type="text" name="studentName" id="studentName" required />

                    <label for="mykid">No. MyKid:</label>
                    <input type="text" name="mykid" id="mykid" placeholder="XXXXXX-XX-XXXX" required />

                    <p>Jantina:</p>
                    <label for="male">
                      <input type="radio" name="gender" id="male" value="Lelaki" required />
                      Lelaki
                    </label>
                    <label for="female">
                      <input type="radio" name="gender" id="female" value="Perempuan" required />
                      Perempuan
                    </label>

                    <label for="race">Kaum:</label>
                    <select name="race" id="race">
                      <option value="Melayu">Melayu</option>
                      <option value="Cina">Cina</option>
                      <option value="India">India</option>
                      <option value="Lain-lain">Lain-lain</option>
                    </select>

                    <label for="year">Tahun / Darjah:</label>
                    <select name="year" id="year">
                      <option value="4">Darjah 4</option>
                      <option value="5">Darjah 5</option>
                      <option value="6">Darjah 6</option>
                    </select>

                    <label for="class">Nama Kelas:</label>
                    <select name="class" id="class">
                      <option value="Alamanda">Alamanda</option>
                      <option value="Bourgenvilla">Bourgenvilla</option>
                      <option value="Camellia">Camellia</option>
                      <option value="Dahlia">Dahlia</option>
                      <option value="Eugenia">Eugenia</option>
                    </select>
                  </fieldset>

                  <fieldset>
                    <legend>Penempatan Kokurikulum</legend>

                    <label for="uniform">Unit Beruniform:</label>
                    <select name="uniform" id="uniform">
                      <option value="Tiada">Tiada</option>
                      <option value="Pengakap">Pengakap</option>
                      <option value="TKRS">Tunas Kadet Remaja Sekolah (TKRS)</option>
                      <option value="BSMM">Bulan Sabit Merah Malaysia (BSMM)</option>
                      <option value="PPIM">Puteri Islam (PPIM)</option>
                      <option value="PPT">Pandu Puteri Tunas</option>
                    </select>

                    <label for="kelab">Kelab & Persatuan:</label>
                    <select name="kelab" id="kelab">
                      <option value="Tiada">Tiada</option>
                      <option value="Bahasa Melayu">Persatuan Bahasa Melayu</option>
                      <option value="Bahasa Inggeris">Persatuan Bahasa Inggeris</option>
                      <option value="Rukun Negara">Kelab Rukun Negara</option>
                      <option value="STEM">Kelab STEM/Sains</option>
                      <option value="Komputer">Kelab Komputer</option>
                      <option value="Agama Islam">Persatuan Agama Islam</option>
                    </select>

                    <label for="sukan">Sukan & Permainan:</label>
                    <select name="sukan" id="sukan">
                      <option value="Tiada">Tiada</option>
                      <option value="Bola Sepak">Bola Sepak</option>
                      <option value="Bola Jaring">Bola Jaring</option>
                      <option value="Olahraga">Olahraga</option>
                      <option value="Badminton">Badminton</option>
                      <option value="Sepak Takraw">Sepak Takraw</option>
                    </select>
                  </fieldset>

                  <button type="submit" class="btn-primary">Simpan Rekod Pelajar</button>
                </form>
            </div>
        </main>
    </body>
</html>
