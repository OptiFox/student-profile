/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 *
 * @author daniel
 */
@WebServlet(name = "DeleteStudentServlet", urlPatterns = {"/DeleteStudentServlet"})
public class DeleteStudentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            String currentUser = (String) session.getAttribute("username");
            String currentRole = (String) session.getAttribute("userRole");
            
            if (currentUser == null || !"ADMIN".equals(currentRole)) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int id = Integer.parseInt(request.getParameter("id"));
            
            Connection conn = null;
            PreparedStatement stmt = null;
            
            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/StudentProfileDB", "app", "app");
                
                // Delete student's achievements
                PreparedStatement achStmt = conn.prepareStatement("DELETE FROM Achievements WHERE student_id = ?");
                achStmt.setInt(1, id);
                achStmt.executeUpdate();
                achStmt.close();
                
                // Delete student's attendance
                PreparedStatement attStmt = conn.prepareStatement("DELETE FROM Attendance WHERE student_id = ?");
                attStmt.setInt(1, id);
                attStmt.executeUpdate();
                attStmt.close();
                
                String query = "DELETE FROM Students WHERE student_id = ?";
                
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, id);
                stmt.executeUpdate();
                
                response.sendRedirect("admin/view_all_students.jsp");
            } catch (Exception e) {
                response.getWriter().println("Error: " + e.getMessage());
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {}
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
