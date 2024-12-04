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

@WebServlet(name = "NotificationPopupController", urlPatterns = {"homepage/checkNotifications"})
public class NotificationPopupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int unreadCount = 0;

        // SQL query to count unread notifications
        String sql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS WHERE IS_READ = 0";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                unreadCount = rs.getInt(1); // Get the unread notification count
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching notification count.");
            return;
        }

        // Send the unread notification count as the response
        response.setContentType("application/json");
        response.getWriter().write("{\"unreadCount\": " + unreadCount + "}");
    }
}
