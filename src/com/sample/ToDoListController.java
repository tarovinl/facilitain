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

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
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
        
//        System.out.println("-------------------------------" );
//        System.out.println(fullUrl);

//        // Early check for tdListID validity only if tdAction is not null
//        if (tdAction != null && (tdAction.equals("check") || tdAction.equals("uncheck") || tdAction.equals("delete"))) {
//            if (tdListID == null || tdListID.isEmpty()) {
//                throw new ServletException("LIST_ITEM_ID is missing or invalid for the action: " + tdAction);
//            }
//        }
        
//        System.out.println("-------------------------------" );
//        System.out.println("tdListID: " + tdListID);
//        System.out.println("tdListContent: " + tdListContent);
//        System.out.println("tdListStart: " + tdListStart);
//        System.out.println("tdListEnd: " + tdListEnd);
//        System.out.println("tdListChecked: " + tdListChecked);
//        System.out.println("tdListCreationDate: " + tdListCreationDate);
//        System.out.println("tdAction: " + tdAction);
        
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // For "yyyy-MM-dd'T'HH:mm"
        
        Timestamp sqlStartTimestamp = null;
        Timestamp sqlEndTimestamp = null;
        
        if (tdAction == null) {
            try {
                LocalDateTime startDateTime = LocalDateTime.parse(tdListStart, formatter);
                LocalDateTime endDateTime = LocalDateTime.parse(tdListEnd, formatter);

                sqlStartTimestamp = Timestamp.valueOf(startDateTime);
                sqlEndTimestamp = Timestamp.valueOf(endDateTime);
            } catch (DateTimeParseException e) {
                throw new ServletException("Invalid date format for start or end date.", e);
            }
        }

        
        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if ("delete".equals(tdAction)) {
                sql = "DELETE FROM FMO_ADM.FMO_TO_DO_LIST WHERE LIST_ITEM_ID = ?";
            }else if ("check".equals(tdAction)) {
                sql = "UPDATE FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 1 WHERE LIST_ITEM_ID = ?";
            }else if ("uncheck".equals(tdAction)) {
                sql = "UPDATE FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 0 WHERE LIST_ITEM_ID = ?";
            }else{
                sql = "INSERT INTO FMO_ADM.FMO_TO_DO_LIST (EMP_NUMBER, LIST_CONTENT, START_DATE, END_DATE) VALUES (1234, ?, ?, ?)";
            }
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    if ("delete".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else if ("check".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else if ("uncheck".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else{
                        stmt.setString(1, tdListContent);
                        stmt.setTimestamp(2, sqlStartTimestamp);
                        stmt.setTimestamp(3, sqlEndTimestamp);
                    }
                    
                    stmt.executeUpdate();
                }
            
            // Redirect to homepage after the action is performed
            response.sendRedirect(fullUrl);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding/editing/deleting to do list item.");
        }
        
    }
}
