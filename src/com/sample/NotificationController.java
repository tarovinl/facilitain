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
        List<Notification> notifications = new ArrayList<>();

        // Get the sorting and filtering parameters from request
        String sortBy = request.getParameter("sortBy");  // Possible values: "date", "read", "unread"
        String filterBy = request.getParameter("filterBy");  // Possible values: "report", "quotation", "maintenance", "read", "unread"
        
        String orderBy = "ORDER BY n.IS_READ ASC, n.CREATED_AT DESC";  // Default sorting

        if ("date".equals(sortBy)) {
            orderBy = "ORDER BY n.CREATED_AT DESC";
        } else if ("read".equals(sortBy)) {
            orderBy = "ORDER BY n.IS_READ DESC, n.CREATED_AT DESC";
        } else if ("unread".equals(sortBy)) {
            orderBy = "ORDER BY n.IS_READ ASC, n.CREATED_AT DESC";
        }

        // Define filter criteria for the different notification types
        String filterSql = "";
        if ("report".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'REPORT'";
        } else if ("quotation".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'QUOTATION'";
        } else if ("maintenance".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'MAINTENANCE'";
        }else if ("warning".equals(filterBy)) { 
                filterSql = "AND n.TYPE = 'WARNING'";
        } else if ("read".equals(filterBy)) {
            filterSql = "AND n.IS_READ = 1";
        } else if ("unread".equals(filterBy)) {
            filterSql = "AND n.IS_READ = 0";
        }

        // Base SQL query for all notification types
        String baseSql = "SELECT n.NOTIFICATION_ID, n.MESSAGE, n.TYPE, n.IS_READ, n.CREATED_AT, " +
                         "l.NAME AS locName, n.ITEM_LOC_ID " +
                         "FROM FMO_ADM.FMO_ITEM_NOTIFICATIONS n " +
                         "JOIN FMO_ADM.FMO_ITEM_LOCATIONS l ON n.ITEM_LOC_ID = l.ITEM_LOC_ID " +
                         "WHERE 1=1 " + filterSql + " " + orderBy;

        try (Connection conn = PooledConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(baseSql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        notifications.add(new Notification(
                            rs.getInt("NOTIFICATION_ID"),
                            rs.getString("MESSAGE"),
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
        request.setAttribute("notifications", notifications);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("filterBy", filterBy);
        request.getRequestDispatcher("notification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        
        // Handle notification actions: Delete or Mark as Read
        if ("delete".equals(action)) {
            deleteNotification(notificationId, response, request);
        } else {
            markAsRead(notificationId, request, response);
        }
    }

    private void deleteNotification(int notificationId, HttpServletResponse response, HttpServletRequest request) throws IOException {
        String sql = "DELETE FROM FMO_ADM.FMO_ITEM_NOTIFICATIONS WHERE NOTIFICATION_ID = ?";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected == 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Notification not found or already deleted.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting notification.");
            return;
        }

        // Redirect back to the notifications page after deletion
        response.sendRedirect(request.getContextPath() + "/notification");
    }

    private void markAsRead(int notificationId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = request.getParameter("redirectUrl");

        // Ensure redirectUrl is safe and does not contain CRLF characters
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            redirectUrl = redirectUrl.trim();  // Remove leading/trailing spaces
            if (redirectUrl.contains("\r") || redirectUrl.contains("\n")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid URL");
                return;
            }

            // Mark as read in the database
            String sql = "UPDATE FMO_ADM.FMO_ITEM_NOTIFICATIONS SET IS_READ = 1 WHERE NOTIFICATION_ID = ?";
            try (Connection conn = PooledConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, notificationId);
                stmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating notification.");
                return;
            }

            // Redirect to the specified URL
            response.sendRedirect(redirectUrl);
        } else {
            // Fallback if no redirect URL is found
            response.sendRedirect(request.getContextPath() + "/notification");
        }
    }
}
