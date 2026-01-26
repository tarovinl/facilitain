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
import java.sql.SQLException;

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
        
        // Pagination parameters
        int currentPage = 1;
        int perPage = 10;
        
        try {
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
                if (currentPage < 1) currentPage = 1;
            }
            if (request.getParameter("perPage") != null) {
                perPage = Integer.parseInt(request.getParameter("perPage"));
                if (perPage < 1) perPage = 10;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
            perPage = 10;
        }
        
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
        

        // First, get the total count for pagination
        String countSql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS n " +
                         "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON n.ITEM_LOC_ID = l.ITEM_LOC_ID " +
                         "WHERE (n.TYPE != 'ASSIGN' OR n.ITEM_NAME = ?) " + filterSql;
        
        int totalNotifications = 0;
        try (Connection conn = PooledConnection.getConnection()) {
            setSessionTimezone(conn);
            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                countStmt.setString(1, sessionUserName != null ? sessionUserName : "");
                try (ResultSet countRs = countStmt.executeQuery()) {
                    if (countRs.next()) {
                        totalNotifications = countRs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error counting notifications.");
            return;
        }

        // Calculate pagination values
        int totalPages = (int) Math.ceil((double) totalNotifications / perPage);
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        int offset = (currentPage - 1) * perPage;

        // Base SQL query with user filtering for ASSIGN notifications and pagination
        String baseSql = "SELECT * FROM (" +
                         "SELECT n.NOTIFICATION_ID, n.MESSAGE, n.TYPE, n.IS_READ, " +
                         "TO_CHAR(n.CREATED_AT + INTERVAL '8' HOUR, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_AT, " +
                         "l.NAME AS locName, n.ITEM_LOC_ID, n.ITEM_NAME, " +
                         "ROW_NUMBER() OVER (" + orderBy + ") AS rn " +
                         "FROM C##FMO_ADM.FMO_ITEM_NOTIFICATIONS n " +
                         "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON n.ITEM_LOC_ID = l.ITEM_LOC_ID " +
                         "WHERE (n.TYPE != 'ASSIGN' OR n.ITEM_NAME = ?) " + filterSql + 
                         ") WHERE rn > ? AND rn <= ?";

        try (Connection conn = PooledConnection.getConnection()) {
            setSessionTimezone(conn);
            try (PreparedStatement stmt = conn.prepareStatement(baseSql)) {
                stmt.setString(1, sessionUserName != null ? sessionUserName : "");
                stmt.setInt(2, offset);
                stmt.setInt(3, offset + perPage);
                
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

        // Set attributes for JSP
        request.setAttribute("notifications", notifications);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("filterBy", filterBy);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalNotifications", totalNotifications);
        request.setAttribute("perPage", perPage);
        
        request.getRequestDispatcher("notification.jsp").forward(request, response);
    }
    
    private void setSessionTimezone(Connection con) throws SQLException {
        try (PreparedStatement stmt = con.prepareStatement(
            "ALTER SESSION SET TIME_ZONE = 'Asia/Manila'")) {
            stmt.execute();
        }
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