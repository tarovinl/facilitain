package com.sample;

import sample.model.Notification;
import sample.model.PooledConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "NotificationPopupController", urlPatterns = {"/facilitain/homepage/checkNotifications"})
public class NotificationPopupController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response type first
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        int unreadCount = 0;
        
        // SQL query to count unread notifications
        String sql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_NOTIFICATIONS WHERE IS_READ = 0";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                unreadCount = rs.getInt(1); // Get the unread notification count
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Send JSON error response instead of HTML error page
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error fetching notification count\", \"unreadCount\": 0}");
            return;
        }
        
        // Send the unread notification count as JSON response
        response.getWriter().write("{\"unreadCount\": " + unreadCount + "}");
    }
}