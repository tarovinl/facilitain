package com.sample;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.format.DateTimeParseException;
import java.sql.ResultSet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.PooledConnection;

@WebServlet(name = "ToDoListController", urlPatterns = { "/todolistcontroller" })
public class ToDoListController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        String empNum = request.getParameter("empNum");

        if (empNum == null || empNum.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing empNum parameter\"}");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "SELECT LIST_ITEM_ID, LIST_CONTENT, START_DATE, END_DATE, IS_CHECKED " +
                         "FROM C##FMO_ADM.FMO_TO_DO_LIST WHERE EMP_NUMBER = ? ORDER BY CREATION_DATE DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(empNum));
            ResultSet rs = stmt.executeQuery();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                json.append("{")
                    .append("\"id\":").append(rs.getInt("LIST_ITEM_ID")).append(",")
                    .append("\"content\":\"").append(rs.getString("LIST_CONTENT").replace("\"", "\\\"")).append("\",")
                    .append("\"startDate\":\"").append(rs.getTimestamp("START_DATE")).append("\",")
                    .append("\"endDate\":\"").append(rs.getTimestamp("END_DATE")).append("\",")
                    .append("\"isChecked\":").append(rs.getInt("IS_CHECKED"))
                    .append("}");
            }

            json.append("]");
            response.getWriter().write(json.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error\"}");
        }
    }


    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
        String userNum = request.getParameter("userNum");
        String fullUrl = request.getParameter("originalUrl");
        if (fullUrl != null) {
            // Remove "?null" if it exists
            if (fullUrl.contains("?null")) {
                fullUrl = fullUrl.replace("?null", "");
            }
            // Remove ".jsp" from anywhere in the URL
            fullUrl = fullUrl.replace(".jsp", "");
            // Replace "manageBuilding" with "buildingDashboard"
            fullUrl = fullUrl.replace("manageBuilding", "buildingDashboard");
            fullUrl = fullUrl.replace("editLocation", "buildingDashboard");
        }
        
        String tdListID = request.getParameter("tdListId");
        String tdListContent = request.getParameter("tdListContent");
        String tdListStart = request.getParameter("tdListStart");
        String tdListEnd = request.getParameter("tdListEnd");
        String tdListChecked = request.getParameter("tdListChecked");
        String tdListCreationDate = request.getParameter("tdListCreationDate");
        String tdAction = request.getParameter("tdAction");
        
        // Enhanced debugging
        System.out.println("=== ToDoListController Debug Info ===");
        System.out.println("userNum: " + userNum);
        System.out.println("tdListID: " + tdListID);
        System.out.println("tdListContent: " + tdListContent);
        System.out.println("tdListStart: " + tdListStart);
        System.out.println("tdListEnd: " + tdListEnd);
        System.out.println("tdAction: " + tdAction);
        System.out.println("fullUrl: " + fullUrl);
        
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        Timestamp sqlStartTimestamp = null;
        Timestamp sqlEndTimestamp = null;
        
        // Validate required parameters
        if (tdAction == null) {
            // Adding new item - validate required fields
            if (userNum == null || userNum.trim().isEmpty()) {
                throw new ServletException("User number is required for adding to-do item");
            }
            if (tdListContent == null || tdListContent.trim().isEmpty()) {
                throw new ServletException("Content is required for adding to-do item");
            }
            if (tdListStart == null || tdListStart.trim().isEmpty()) {
                throw new ServletException("Start date is required for adding to-do item");
            }
            if (tdListEnd == null || tdListEnd.trim().isEmpty()) {
                throw new ServletException("End date is required for adding to-do item");
            }
            
            try {
                LocalDateTime startDateTime = LocalDateTime.parse(tdListStart, formatter);
                LocalDateTime endDateTime = LocalDateTime.parse(tdListEnd, formatter);
                sqlStartTimestamp = Timestamp.valueOf(startDateTime);
                sqlEndTimestamp = Timestamp.valueOf(endDateTime);
                
                System.out.println("Parsed timestamps:");
                System.out.println("Start: " + sqlStartTimestamp);
                System.out.println("End: " + sqlEndTimestamp);
            } catch (DateTimeParseException e) {
                System.err.println("Date parsing error: " + e.getMessage());
                throw new ServletException("Invalid date format for start or end date: " + e.getMessage(), e);
            }
        } else {
            // For update/delete operations, validate tdListID
            if (tdListID == null || tdListID.trim().isEmpty()) {
                throw new ServletException("LIST_ITEM_ID is required for action: " + tdAction);
            }
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = PooledConnection.getConnection();
            if (conn == null) {
                throw new ServletException("Failed to get database connection");
            }
            
            String sql;
            
            if ("delete".equals(tdAction)) {
                sql = "DELETE FROM C##FMO_ADM.FMO_TO_DO_LIST WHERE LIST_ITEM_ID = ?";
                System.out.println("Executing DELETE with ID: " + tdListID);
            } else if ("check".equals(tdAction)) {
                sql = "UPDATE C##FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 1 WHERE LIST_ITEM_ID = ?";
                System.out.println("Executing CHECK with ID: " + tdListID);
            } else if ("uncheck".equals(tdAction)) {
                sql = "UPDATE C##FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 0 WHERE LIST_ITEM_ID = ?";
                System.out.println("Executing UNCHECK with ID: " + tdListID);
            } else {
                sql = "INSERT INTO C##FMO_ADM.FMO_TO_DO_LIST (EMP_NUMBER, LIST_CONTENT, START_DATE, END_DATE) VALUES (?, ?, ?, ?)";
                System.out.println("Executing INSERT");
            }
            
            System.out.println("SQL: " + sql);
            
            stmt = conn.prepareStatement(sql);
            
            if ("delete".equals(tdAction) || "check".equals(tdAction) || "uncheck".equals(tdAction)) {
                try {
                    int listId = Integer.parseInt(tdListID);
                    stmt.setInt(1, listId);
                    System.out.println("Set parameter 1 (LIST_ITEM_ID): " + listId);
                } catch (NumberFormatException e) {
                    throw new ServletException("Invalid LIST_ITEM_ID format: " + tdListID, e);
                }
            } else {
                // INSERT operation
                try {
                    int empNumber = Integer.parseInt(userNum);
                    stmt.setInt(1, empNumber);
                    stmt.setString(2, tdListContent);
                    stmt.setTimestamp(3, sqlStartTimestamp);
                    stmt.setTimestamp(4, sqlEndTimestamp);
                    
                    System.out.println("Set parameters for INSERT:");
                    System.out.println("1 (EMP_NUMBER): " + empNumber);
                    System.out.println("2 (LIST_CONTENT): " + tdListContent);
                    System.out.println("3 (START_DATE): " + sqlStartTimestamp);
                    System.out.println("4 (END_DATE): " + sqlEndTimestamp);
                } catch (NumberFormatException e) {
                    throw new ServletException("Invalid user number format: " + userNum, e);
                }
            }
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected == 0) {
                System.out.println("Warning: No rows were affected by the operation");
            }
            if (tdAction == null) {
                // Store a one-time success flag in session
                    HttpSession session = request.getSession();
                    session.setAttribute("todoSuccess", true);
                    
                // Redirect to homepage after the action is performed
                System.out.println("Redirecting to: " + fullUrl);
                response.sendRedirect(fullUrl);
            }else{
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
    
                if (rowsAffected > 0) {
                    out.print("{\"success\": true, \"message\": \"Action completed successfully\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"No rows affected\"}");
                }
                out.flush();
            }
            
        } catch (SQLException e) {
            System.err.println("=== SQL Exception Details ===");
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            
            // More specific error messages based on common Oracle error codes
            String errorMessage = "Database error while processing to-do list item: ";
            if (e.getErrorCode() == 1) {
                errorMessage += "Duplicate entry - this item may already exist.";
            } else if (e.getErrorCode() == 1400) {
                errorMessage += "Required field is missing or null.";
            } else if (e.getErrorCode() == 2291) {
                errorMessage += "Invalid foreign key - user number may not exist.";
            } else if (e.getErrorCode() == 12899) {
                errorMessage += "Data too long for field.";
            } else {
                errorMessage += e.getMessage();
            }
            
            throw new ServletException(errorMessage, e);
        } catch (Exception e) {
            System.err.println("=== General Exception ===");
            e.printStackTrace();
            throw new ServletException("Unexpected error while processing to-do list item: " + e.getMessage(), e);
        } finally {
            // Clean up resources
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    System.err.println("Error closing statement: " + e.getMessage());
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
}
