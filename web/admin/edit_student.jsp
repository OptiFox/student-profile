<%-- 
    Document   : edit_student
    Created on : Jun 2, 2026, 6:30:12 PM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.spis.models.Student, com.spis.dao.StudentDAO" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String studentIdStr = request.getParameter("id");
    
    if (studentIdStr == null || studentIdStr.isEmpty()) {
        response.sendRedirect("view_all_students.jsp");
        return;
    }
    
    int studentId = Integer.parseInt(studentIdStr);
    String alertMessage = "";
    
    // process update
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
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
            
            String updateQuery = "UPDATE Students SET student_name = ?, mykid = ?, gender = ?, race = ?, grade_year = ?, "
                               + "class_name = ?, uniform_unit = ?, club = ?, sport = ? WHERE student_id = ?";
            
            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, studentName);
            stmt.setString(2, mykid);
            stmt.setString(3, gender);
            stmt.setString(4, race);
            stmt.setInt(5, gradeYear);
            stmt.setString(6, className);
            stmt.setString(7, uniform);
            stmt.setString(8, club);
            stmt.setString(9, sport);
            stmt.setInt(10, studentId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("view_profile.jsp?id=" + studentId);
                return;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            alertMessage = "<p class='error-text'>Ralat: MyKid ini telah wujud untuk pelajar lain.</p>";
        } catch (Exception e) {
            alertMessage = "<p class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</p>";
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    // fetch current data
    String dbName = "", dbMykid = "", dbGender = "", dbRace = "", dbClass = "", dbUniform = "", dbClub = "", dbSport = "";
    int dbYear = 0;
    
    Student student = StudentDAO.getStudentById(studentId);
        
    if (student != null) {
        dbName = student.getStudentName();
        dbMykid = student.getMykid();
        dbGender = student.getGender();
        dbRace = student.getRace();
        dbYear = student.getGradeYear();
        dbClass = student.getClassName();
        dbUniform = student.getUniformUnit();
        dbClub = student.getClub();
        dbSport = student.getSport();
    } else {
        response.sendRedirect("view_all_students.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css" />
        
        <title>SPIS - Kemaskini Profil Pelajar</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Kemaskini Profil Pelajar</h1>
            <div>
                <a href="view_all_students.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <form action="edit_student.jsp?id=<%= studentId %>" method="post">
                <h2>Borang Kemaskini Pelajar</h2>
                
                <fieldset>
                    <legend>Maklumat Peribadi Pelajar</legend>
                    
                    <label for="studentName">Nama Penuh Pelajar:</label>
                    <input type="text" name="studentName" id="studentName" value="<%= dbName %>" required />

                    <label for="mykid">No. MyKid:</label>
                    <input type="text" name="mykid" id="mykid" value="<%= dbMykid %>" required />

                    <p>Jantina:</p>
                    <label for="male">
                        <input type="radio" name="gender" id="male" value="Lelaki" <%= "Lelaki".equals(dbGender) ? "checked" : "" %> required /> Lelaki
                    </label>
                    <label for="female">
                        <input type="radio" name="gender" id="female" value="Perempuan" <%= "Perempuan".equals(dbGender) ? "checked" : "" %> required /> Perempuan
                    </label>

                    <label for="race">Kaum:</label>
                    <select name="race" id="race">
                        <option value="Melayu" <%= "Melayu".equals(dbRace) ? "selected" : "" %>>Melayu</option>
                        <option value="Cina" <%= "Cina".equals(dbRace) ? "selected" : "" %>>Cina</option>
                        <option value="India" <%= "India".equals(dbRace) ? "selected" : "" %>>India</option>
                        <option value="Lain-lain" <%= "Lain-lain".equals(dbRace) ? "selected" : "" %>>Lain-lain</option>
                    </select>

                    <label for="year">Tahun / Darjah:</label>
                    <select name="year" id="year">
                        <option value="4" <%= dbYear == 4 ? "selected" : "" %>>Darjah 4</option>
                        <option value="5" <%= dbYear == 5 ? "selected" : "" %>>Darjah 5</option>
                        <option value="6" <%= dbYear == 6 ? "selected" : "" %>>Darjah 6</option>
                    </select>

                    <label for="class">Nama Kelas:</label>
                    <select name="class" id="class">
                        <option value="Alamanda" <%= "Alamanda".equals(dbClass) ? "selected" : "" %>>Alamanda</option>
                        <option value="Bourgenvilla" <%= "Bourgenvilla".equals(dbClass) ? "selected" : "" %>>Bourgenvilla</option>
                        <option value="Camellia" <%= "Camellia".equals(dbClass) ? "selected" : "" %>>Camellia</option>
                        <option value="Dahlia" <%= "Dahlia".equals(dbClass) ? "selected" : "" %>>Dahlia</option>
                        <option value="Eugenia" <%= "Eugenia".equals(dbClass) ? "selected" : "" %>>Eugenia</option>
                    </select>
                </fieldset>
                    
                <fieldset>
                    <legend>Penempatan Kokurikulum</legend>

                    <label for="uniform">Unit Beruniform:</label>
                    <select name="uniform" id="uniform">
                        <option value="Tiada" <%= "Tiada".equals(dbUniform) ? "selected" : "" %>>Tiada</option>
                        <option value="Pengakap" <%= "Pengakap".equals(dbUniform) ? "selected" : "" %>>Pengakap</option>
                        <option value="TKRS" <%= "TKRS".equals(dbUniform) ? "selected" : "" %>>Tunas Kadet Remaja Sekolah (TKRS)</option>
                        <option value="BSMM" <%= "BSMM".equals(dbUniform) ? "selected" : "" %>>Bulan Sabit Merah Malaysia (BSMM)</option>
                        <option value="PPIM" <%= "PPIM".equals(dbUniform) ? "selected" : "" %>>Puteri Islam (PPIM)</option>
                        <option value="PPT" <%= "PPT".equals(dbUniform) ? "selected" : "" %>>Pandu Puteri Tunas</option>
                    </select>

                    <label for="kelab">Kelab & Persatuan:</label>
                    <select name="kelab" id="kelab">
                        <option value="Tiada" <%= "Tiada".equals(dbClub) ? "selected" : "" %>>Tiada</option>
                        <option value="Bahasa Melayu" <%= "Bahasa Melayu".equals(dbClub) ? "selected" : "" %>>Persatuan Bahasa Melayu</option>
                        <option value="Bahasa Inggeris" <%= "Bahasa Inggeris".equals(dbClub) ? "selected" : "" %>>Persatuan Bahasa Inggeris</option>
                        <option value="Rukun Negara" <%= "Rukun Negara".equals(dbClub) ? "selected" : "" %>>Kelab Rukun Negara</option>
                        <option value="STEM" <%= "STEM".equals(dbClub) ? "selected" : "" %>>Kelab STEM/Sains</option>
                        <option value="Komputer" <%= "Komputer".equals(dbClub) ? "selected" : "" %>>Kelab Komputer</option>
                        <option value="Agama Islam" <%= "Agama Islam".equals(dbClub) ? "selected" : "" %>>Persatuan Agama Islam</option>
                    </select>

                    <label for="sukan">Sukan & Permainan:</label>
                    <select name="sukan" id="sukan">
                        <option value="Tiada" <%= "Tiada".equals(dbSport) ? "selected" : "" %>>Tiada</option>
                        <option value="Bola Sepak" <%= "Bola Sepak".equals(dbSport) ? "selected" : "" %>>Bola Sepak</option>
                        <option value="Bola Jaring" <%= "Bola Jaring".equals(dbSport) ? "selected" : "" %>>Bola Jaring</option>
                        <option value="Olahraga" <%= "Olahraga".equals(dbSport) ? "selected" : "" %>>Olahraga</option>
                        <option value="Badminton" <%= "Badminton".equals(dbSport) ? "selected" : "" %>>Badminton</option>
                        <option value="Sepak Takraw" <%= "Sepak Takraw".equals(dbSport) ? "selected" : "" %>>Sepak Takraw</option>
                    </select>
                </fieldset>

                <button type="submit" class="btn-success">Kemaskini Rekod</button>
                
                <%= alertMessage %>
            </form>
        </main>
    </body>
</html>
