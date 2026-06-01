<%-- 
    Document   : update_role.jsp
    Created on : Jun 1, 2026, 11:14:10 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    String assignedUnit = (String) session.getAttribute("assignedUnit");
    String assignedCategory = (String) session.getAttribute("assignedCategory");
    
    if (currentUser == null || !"SUPERVISOR".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; 
    }
    
    // Logic is on top so that roles.js detects the changes for the student role safeguard
    String alertMessage = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String studentIdStr = request.getParameter("studentId");
        String newRole = request.getParameter("newRole");
        
        if (assignedCategory == null) {
            alertMessage = "<p class='error-text'>Ralat Sistem: Kategori tidak dijumpai.</p>";
        } else {
            String columnToUpdate = "";
            if ("Unit Beruniform".equals(assignedCategory)) {
                columnToUpdate = "uniform_role";
            } else if ("Kelab & Persatuan".equals(assignedCategory)) {
                columnToUpdate = "club_role";
            } else if ("Sukan & Permainan".equals(assignedCategory)) {
                columnToUpdate = "sport_role";
            }
            
            if (!columnToUpdate.isEmpty()) {
                Connection updateConn = null;
                PreparedStatement updateStmt = null;
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    updateConn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                    
                    String updateQuery = "UPDATE Students SET " + columnToUpdate + " = ? WHERE student_id = ?";
                    updateStmt = updateConn.prepareStatement(updateQuery);
                    updateStmt.setString(1, newRole);
                    updateStmt.setInt(2, Integer.parseInt(studentIdStr));
                    
                    int rowsAffected = updateStmt.executeUpdate();
                    if (rowsAffected > 0) {
                        alertMessage = "<p class='success-text'>Jawatan pelajar berjaya dikemaskini!</p>";
                    }
                } catch (Exception e) {
                    alertMessage = "<p class='error-text'>Ralat Pangkalan Data: " + e.getMessage() + "</p>";
                } finally {
                    if (updateStmt != null) updateStmt.close();
                    if (updateConn != null) updateConn.close();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        
        <title>SPIS - Kemaskini Jawatan</title>
    </head>
    <body>
        <header class="flex">
            <h1>SPIS - Pengurusan Jawatan: <%= assignedUnit != null ? assignedUnit : "" %></h1>
            <div>
                <a href="../supervisor_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
            
        <main>
            <fieldset>
                <legend>Lantik / Kemaskini Jawatan Pelajar</legend>
                
                <form action="update_role.jsp" method="post">
                    <p>
                        <label for="studentId">Pilih Pelajar:</label>
                        <select name="studentId" id="studentId" required>
                            <option value="">-- Sila Pilih Pelajar --</option>
                            <%
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;
                                
                                try {
                                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                                    
                                    String roleColumn = "uniform_role"; // Default fallback
                                    if ("Kelab & Persatuan".equals(assignedCategory)) {
                                        roleColumn = "club_role";
                                    } else if ("Sukan & Permainan".equals(assignedCategory)) {
                                        roleColumn = "sport_role";
                                    }
                                    
                                    String query = "SELECT student_id, student_name, class_name, grade_year, " 
                                            + roleColumn + " AS student_role FROM Students "
                                            + "WHERE uniform_unit = ? OR club = ? OR sport = ? ORDER BY student_name ASC";
                                    
                                    stmt = conn.prepareStatement(query);
                                    stmt.setString(1, assignedUnit);
                                    stmt.setString(2, assignedUnit);
                                    stmt.setString(3, assignedUnit);
                                    
                                    rs = stmt.executeQuery();
                                    
                                    while(rs.next()) {
                            %>
                                        <option value="<%= rs.getInt("student_id") %>" data-role="<%= rs.getString("student_role") %>">
                                            <%= rs.getString("student_name") %> (<%= rs.getInt("grade_year") %> <%= rs.getString("class_name") %>)
                                        </option>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<option value=''>Ralat Pangkalan Data: " + e.getMessage() + "</option>");
                                } finally {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </select>
                    </p>
                    
                    <p>
                        <label for="newRole">Jawatan Baharu:</label>
                        <select name="newRole" id="newRole" required>
                            <option value="Ahli Biasa">Ahli Biasa</option>
                            <option value="Pengerusi">Pengerusi</option>
                            <option value="Naib Pengerusi">Naib Pengerusi</option>
                            <option value="Setiausaha">Setiausaha</option>
                            <option value="Penolong Setiausaha">Penolong Setiausaha</option>
                            <option value="Bendahari">Bendahari</option>
                            <option value="Penolong Bendahari">Penolong Bendahari</option>
                            <option value="Ahli Jawatankuasa (AJK)">Ahli Jawatankuasa (AJK)</option>
                        </select>
                    </p>
                    
                    <button type="submit" class="btn-primary">Kemaskini Jawatan</button>
                </form>
                        
                <%= alertMessage %>
            </fieldset>
        </main>
            
        <script src="../js/roles.js"></script>
    </body>
</html>
