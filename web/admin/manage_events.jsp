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
        
        <title>SPIS - Urus Senarai Acara & Pertandingan</title>
    </head>
    <body>
        <header class="flex">
            <h1>Sistem Profil Pelajar (SPIS) - Pengurusan Acara & Pertandingan</h1>
            
            <div>
                <a href="../admin_dashboard.jsp" class="btn-secondary">Kembali</a>
                <a href="../logout.jsp" class="btn-danger">Log Keluar</a>
            </div>
        </header>
        
        <main>
            <%= alertMessage %>
            <fieldset>
                <legend>Tambah Acara Baharu</legend>
                
                <form action="manage_events.jsp" method="post">
                    <p>
                        <label for="eventName">Nama Acara:</label>
                        <input type="text" id="eventName" name="eventName" required>
                    </p>
            
                    <p>
                        <label for="eventType">Kategori:</label>
                        <select id="eventType" name="eventType" required>
                            <option value="Unit Beruniform">Unit Beruniform</option>
                            <option value="Kelab & Persatuan">Kelab & Persatuan</option>
                            <option value="Sukan & Permainan">Sukan & Permainan</option>
                        </select>
                    </p>
                    
                    <p>
                        <label for="eventDate">Tarikh:</label>
                        <input type="date" id="eventDate" name="eventDate" required>
                    </p>
                    
                    <p>
                        <label for="description">Penerangan ringkas:</label>
                        <textarea id="description" name="description" rows="3" style="width: 100%;"></textarea>
                    </p>
            
                    <button type="submit" class="btn-primary">Tambah Acara</button>
                </form>
            </fieldset>
            
            <br>
            <fieldset style="margin-bottom: 15px; width: 100%;">
                <label for="searchInput"><b>Carian Acara:</b></label>
                <input type="text" id="searchInput" onkeyup="filterTable('searchInput', 'table', 1, 2)" placeholder="Cari nama acara...">
            </fieldset>
                
            <fieldset style="width: 100%;">
                <table id="table">
                    <caption>Senarai Keseluruhan Acara & Pertandingan</caption>
                    <tr>
                        <th>ID</th>
                        <th>Nama Acara</th>
                        <th>Kategori</th>
                        <th>Tarikh</th>
                        <th>Tindakan</th>
                    </tr>
                <%
                    if (eventList == null || eventList.isEmpty()) {
                %>
                        <tr>
                            <td colspan="5" style="text-align: center;">Tiada acara didaftarkan dalam sistem.</td>
                        </tr>
                <%
                    } else {
                        for (Event e : eventList) {
                %>
                        <tr>
                            <td><%= e.getEventId() %></td>
                            <td><%= e.getEventName() %></td>
                            <td><%= e.getEventType() %></td>
                            <td><%= e.getEventDate() %></td>
                            <td>
                                <a href="../DeleteEventServlet?id=<%= e.getEventId() %>"
                                   onclick="return confirm('Padam acara ini?');"
                                   class="btn-danger">
                                   Padam
                                </a>
                            </td>
                        </tr>
                <%
                        }
                    }
                %>
                </table>
            </fieldset>
        </main>
                
        <script src="../js/search.js"></script>
    </body>
</html>
