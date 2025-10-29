package com.sample;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.PooledConnection;

@WebServlet(name = "RecentActServlet", urlPatterns = { "/recentactservlet" })
public class RecentActServlet extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");  
        response.setCharacterEncoding("UTF-8");

            String locID = request.getParameter("locID");
            if (locID == null || locID.isEmpty()) {
                response.getWriter().write("<div>No location ID provided.</div>");
                return;
            }
        StringBuilder html = new StringBuilder();
        String query = 
            "SELECT " +
            " i.item_id, " +
            " i.name, " +
            " i.room_no, " +
            " i.last_maintenance_date, " +
            " i.planned_maintenance_date, " +
            " m.no_of_days, " +
            " m.no_of_days_warning, " +
            " t.name as TYPE_NAME, " +
            " c.name as CAT_NAME " +
            "FROM C##FMO_ADM.FMO_ITEMS i " +
            "JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON i.item_type_id = t.item_type_id " +
            "JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES c ON t.item_cat_id = c.item_cat_id " +
            "JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED m ON i.item_type_id = m.item_type_id " +
            "WHERE i.location_id = ? " +
            "  AND i.item_stat_id = 1 " +
            "  AND m.archived_flag = 1 " +
            "ORDER BY i.planned_maintenance_date ASC";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
        
            ps.setInt(1, Integer.parseInt(locID));
        
            try (ResultSet rs = ps.executeQuery()) {
                boolean hasResults = false;
                
                java.util.Date currentDate = new java.util.Date();

                while (rs.next()) {
                    java.sql.Date plannedDate = rs.getDate("planned_maintenance_date");
                    java.sql.Date lastDate = rs.getDate("last_maintenance_date");
                    int noOfDays = rs.getInt("no_of_days");
                    int noOfDaysWarning = rs.getInt("no_of_days_warning");
                    
                    if (plannedDate == null) {
                        continue;
                    }
                    
                    long diffInMillis = 0;
                    if (lastDate != null) {
                        diffInMillis = currentDate.getTime() - lastDate.getTime();
                        long daysSinceLastMaint = diffInMillis / (1000 * 60 * 60 * 24);
                        
                        if (daysSinceLastMaint >= 0 && daysSinceLastMaint <= 30) {
                            hasResults = true;
                            String itemRoom = rs.getString("room_no");
                            String safeRoom = escapeHtml(itemRoom != null && !itemRoom.isEmpty() ? itemRoom : "");
                        
                            html.append(
                                    "<div class='d-flex align-items-center border-bottom p-3 actItem' " +
                                        "style='border-color: #dee0e1 !important;'>" +
                                        "<div class='me-3'>" +
                                            "<img src='resources/images/greenDot.png' alt='activity status indicator' width='28' height='28'>" +
                                        "</div>" +
                                    
                                        "<div>" +
                                            "<h4 class='mb-1 fs-5 fw-semibold activity-text'>" +
                                                "Maintenance for " + escapeHtml(rs.getString("name")) + " " + safeRoom + " in " +
                                                "<span class='remaining-days'>" + daysSinceLastMaint + "</span> days." +
                                            "</h4>" +
                                            "<h6 class='mb-0 text-muted'>" +
                                                escapeHtml(rs.getString("cat_name")) + " - " + escapeHtml(rs.getString("type_name")) +
                                            "</h6>" +
                                        "</div>" +
                                    
                                
                                    "</div>"
                                );
                        }
                        }
                    }
                if (!hasResults) {
                    html.append("<div class='d-flex justify-content-center align-items-center text-muted' style='min-height:100%;'>")
                    .append("No recent activities")
                    .append("</div>");
                }
                
            }
        
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        response.getWriter().write(html.toString());
        
    }
        private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
           .replace("<", "&lt;")
           .replace(">", "&gt;")
           .replace("\"", "&quot;")
           .replace("'", "&#x27;");
        }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }
}
