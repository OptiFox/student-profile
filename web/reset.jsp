<%-- 
    Document   : reset
    Created on : Jun 3, 2026, 8:23:04 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.spis.utils.DBConnection, com.spis.utils.SecurityUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>System Reset</title>
    </head>
    <body style="font-family: Arial, sans-serif; padding: 20px;">
        <h2>Alat Pemulihan Kata Laluan (Admin)</h2>
        <%
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("UPDATE Users SET password = ? WHERE username = 'admin'")) {

                String pureHash = SecurityUtils.hashPassword("password");

                stmt.setString(1, pureHash);
                int rows = stmt.executeUpdate();
                
                out.println("<p style='color: green;'><b>Berjaya!</b> Akaun admin telah dikemas kini.</p>");
                out.println("<p><b>Hash Dijana:</b> " + pureHash + "</p>");
                
            } catch(Exception e) {
                out.println("<p style='color: red;'><b>Ralat:</b> " + e.getMessage() + "</p>");
            }
        %>
        <br>
        <a href="login.jsp" style="padding: 10px; background: #007bff; color: white; text-decoration: none; border-radius: 5px;">Kembali ke Log Masuk</a>
    </body>
</html>
