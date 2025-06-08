package com.sample;

import sample.model.Notification;
import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "NotificationController", urlPatterns = {"/notification"})
public class NotificationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Notification> notifications = new ArrayList<>();
        HttpSession session = request.getSession();
        String sessionUserName = (String) session.getAttribute("name");

        // Get the sorting and filtering parameters from request
        String sortBy = request.getParameter("sortBy");
        String filterBy = request.getParameter("filterBy");
        
        String orderBy = "ORDER BY n.IS_READ ASC, n.CREATED_AT DESC";

        if ("date".equals(sortBy)) {
            orderBy = "ORDER BY n.CREATED_AT DESC";
        } else if ("read".equals(sortBy)) {
            orderBy = "ORDER BY n.IS_READ DESC, n.CREATED_AT DESC";
        } else if ("unread".equals(sortBy)) {
            orderBy = "ORDER BY n.IS_READ ASC, n.CREATED_AT DESC";
        }

        String filterSql = "";
        if ("report".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'REPORT'";
        } else if ("quotation".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'QUOTATION'";
        } else if ("maintenance".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'MAINTENANCE'";
        } else if ("assign".equals(filterBy)) {
            filterSql = "AND n.TYPE = 'ASSIGN'";
        } else if ("warning".equals(filterBy)) { 
            filterSql = "AND n.TYPE = 'WARNING'";
        } else if ("read".equals(filterBy)) {
            filterSql = "AND n.IS_READ = 1";
        } else if ("unread".equals(filterBy)) {
            filterSql = "AND n.IS_READ = 0";
        }

        // Base SQL query with user filtering for ASSIGN notifications
        String baseSql = "SELECT n.NOTIFICATION_ID, n.MESSAGE, n.TYPE, n.IS_READ, n.CREATED_AT, " +
                         "l.NAME AS locName, n.ITEM_LOC_ID, n.ITEM_NAME " +
                         "FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS n " +
                         "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON n.ITEM_LOC_ID = l.ITEM_LOC_ID " +
                         "WHERE (n.TYPE != 'ASSIGN' OR n.ITEM_NAME = ?) " + filterSql + " " + orderBy;

        try (Connection conn = PooledConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(baseSql)) {
                stmt.setString(1, sessionUserName != null ? sessionUserName : "");
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Notification notification = new Notification(
                            rs.getInt("NOTIFICATION_ID"),
                            rs.getString("MESSAGE"),
                            rs.getString("TYPE"),
                            rs.getInt("IS_READ") == 1,
                            rs.getTimestamp("CREATED_AT"),
                            rs.getString("locName"),
                            rs.getInt("ITEM_LOC_ID")
                        );
                        
                        // Parse grouped maintenance items
                        if ("MAINTENANCE".equals(notification.getType()) && 
                            notification.getMessage().startsWith("Multiple items require maintenance:")) {
                            String itemsString = notification.getMessage().substring("Multiple items require maintenance: ".length());
                            List<String> items = Arrays.asList(itemsString.split("\\|"));
                            notification.setMaintenanceItems(items);
                        }
                        
                        // Set assigned user name for ASSIGN notifications
                        if ("ASSIGN".equals(notification.getType())) {
                            notification.setAssignedUserName(rs.getString("ITEM_NAME"));
                        }
                        
                        notifications.add(notification);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching notifications.");
            return;
        }

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
        
        if ("delete".equals(action)) {
            deleteNotification(notificationId, response, request);
        } else {
            markAsRead(notificationId, request, response);
        }
    }

    private void deleteNotification(int notificationId, HttpServletResponse response, HttpServletRequest request) throws IOException {
        String sql = "DELETE FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS WHERE NOTIFICATION_ID = ?";
        
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

        response.sendRedirect(request.getContextPath() + "/notification");
    }

    private void markAsRead(int notificationId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = request.getParameter("redirectUrl");

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            redirectUrl = redirectUrl.trim();
            if (redirectUrl.contains("\r") || redirectUrl.contains("\n")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid URL");
                return;
            }

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

            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/notification");
        }
    }
}
