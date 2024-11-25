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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "NotificationController", urlPatterns = {"/notification"})
public class NotificationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Notification> reportNotifications = new ArrayList<>();
        List<Notification> quotationNotifications = new ArrayList<>();

        String sql = "SELECT n.NOTIFICATION_ID, n.MESSAGE, n.TYPE, n.IS_READ, n.CREATED_AT, " +
                     "l.NAME AS locName, n.ITEM_LOC_ID " +
                     "FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS n " +
                     "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON n.ITEM_LOC_ID = l.ITEM_LOC_ID " +
                     "WHERE n.TYPE = ? " +
                     "ORDER BY n.IS_READ ASC, n.CREATED_AT DESC";

        try (Connection conn = PooledConnection.getConnection()) {
            // Fetch report notifications
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "REPORT");
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        reportNotifications.add(new Notification(
                            rs.getInt("NOTIFICATION_ID"),
                            rs.getString("MESSAGE") + " (Location: " + rs.getString("locName") + ")",
                            rs.getString("TYPE"),
                            rs.getInt("IS_READ") == 1,
                            rs.getTimestamp("CREATED_AT"),
                            rs.getString("locName"),
                            rs.getInt("ITEM_LOC_ID")
                        ));
                    }
                }
            }

            // Fetch quotation notifications
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "QUOTATION");
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        quotationNotifications.add(new Notification(
                            rs.getInt("NOTIFICATION_ID"),
                            rs.getString("MESSAGE") + " (Location: " + rs.getString("locName") + ")",
                            rs.getString("TYPE"),
                            rs.getInt("IS_READ") == 1,
                            rs.getTimestamp("CREATED_AT"),
                            rs.getString("locName"),
                            rs.getInt("ITEM_LOC_ID")
                        ));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching notifications.");
            return;
        }

        // Pass notifications to JSP
        request.setAttribute("reportNotifications", reportNotifications);
        request.setAttribute("quotationNotifications", quotationNotifications);
        request.getRequestDispatcher("notification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("id"));
        String redirectUrl = request.getParameter("redirectUrl");

        // SQL query to mark the notification as read
        String sql = "UPDATE C##FMO_ADM.FMO_ITEM_NOTIFICATIONS SET IS_READ = 1 WHERE NOTIFICATION_ID = ?";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating notification.");
            return;
        }

        // Redirect to the target page
        response.sendRedirect(redirectUrl);
    }
}
