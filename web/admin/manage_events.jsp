<%-- 
    Document   : manage_events
    Created on : May 28, 2026, 9:12:15 AM
    Author     : daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.Date" %>
<%@page import="com.spis.models.Event" %>
<%@page import="com.spis.dao.EventDAO" %>

<%
    // Checks if the user is admin or not (security)
    String currentUser = (String) session.getAttribute("username");
    String currentRole = (String) session.getAttribute("userRole");
    
    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect("../login.jsp");
        return; // stop page from loading
    }
    
    String alertMessage = "";
    
    // Process Add Request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String eventName = request.getParameter("eventName");
        String eventType = request.getParameter("eventType");
        String eventDateStr = request.getParameter("eventDate");
        String description = request.getParameter("description");
        
        if (eventName != null && eventDateStr != null) {
            Event newEvent = new Event();
            newEvent.setEventName(eventName);
            newEvent.setEventType(eventType);
            newEvent.setEventDate(Date.valueOf(eventDateStr));
            newEvent.setDescription(description);
            
            if (EventDAO.addEvent(newEvent)) {
                alertMessage = "<p class='success-text'>Acara berjaya ditambah!</p>";
            } else {
                alertMessage = "<p class='error-text'>Ralat Pangkalan Data semasa menambah acara.</p>";
            }
        }
    }

    // Fetch all events for the table
    ArrayList<Event> eventList = EventDAO.getAllEvents();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../css/style.css">
        <title>SPIS - Pengurusan Acara</title>
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
                    <a href="manage_events.jsp" class="active">Urus Senarai Acara</a>
                    <a href="add_student.jsp">Daftar Pelajar Baharu</a>
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
                        <h2 style="margin: 0; color: #2c3e50;">Pengurusan Acara & Pertandingan</h2>
                    </div>
                    <div>
                        <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                    </div>
                </header>
                
                <main class="content-body">
                    <%= alertMessage %>
                    
                    <div style="max-width: 800px; background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                        <h3 style="margin-top: 0;">Tambah Acara Baharu</h3>
                        <form action="manage_events.jsp" method="post">
                            <div style="display: flex; gap: 15px;">
                                <div style="flex: 2;">
                                    <label for="eventName">Nama Acara:</label>
                                    <input type="text" id="eventName" name="eventName" required style="width: 100%;">
                                </div>
                                <div style="flex: 1;">
                                    <label for="eventType">Kategori:</label>
                                    <select id="eventType" name="eventType" required style="width: 100%;">
                                        <option value="Unit Beruniform">Unit Beruniform</option>
                                        <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                                        <option value="Sukan & Permainan">Sukan & Permainan</option>
                                    </select>
                                </div>
                            </div>
                            
                            <p>
                                <label for="eventDate">Tarikh:</label>
                                <input type="date" id="eventDate" name="eventDate" required style="width: 100%;">
                            </p>
                            
                            <p>
                                <label for="description">Penerangan ringkas:</label>
                                <textarea id="description" name="description" rows="3" style="width: 100%;"></textarea>
                            </p>
                            
                            <button type="submit" class="btn-primary" style="padding: 10px 20px;">Tambah Acara</button>
                        </form>
                    </div>
                    
                    <div style="background: white; padding: 25px; border-radius: 8px; border: 1px solid #e0e0e0;">
                        <div style="margin-bottom: 20px;">
                            <label for="searchInput"><b>Carian Acara:</b></label>
                            <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari nama acara..." style="width: 100%; max-width: 400px; display: block; margin-top: 5px;">
                        </div>
                        
                        <table id="table" style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <th>ID</th>
                                <th>Nama Acara</th>
                                <th>Kategori</th>
                                <th>Tarikh</th>
                                <th style="text-align: center;">Tindakan</th>
                            </tr>
                            <%
                                if (eventList == null || eventList.isEmpty()) {
                            %>
                                    <tr><td colspan="5" style="text-align: center; padding: 20px;">Tiada acara didaftarkan dalam sistem.</td></tr>
                            <%
                                } else {
                                    for (Event e : eventList) {
                            %>
                                        <tr>
                                            <td style="text-align: center;"><%= e.getEventId() %></td>
                                            <td><%= e.getEventName() %></td>
                                            <td><%= e.getEventType() %></td>
                                            <td><%= e.getEventDate() %></td>
                                            <td style="text-align: center;">
                                                <a href="../DeleteEventServlet?id=<%= e.getEventId() %>"
                                                   onclick="return confirm('Padam acara ini?');"
                                                   class="btn-danger" style="padding: 5px 10px; font-size: 0.9em;">Padam</a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                }
                            %>
                        </table>
                    </div>
                </main>
            </div>
        </div>
        <script src="../js/search.js"></script>
    </body>
</html>
