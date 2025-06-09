package com.sample;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.EmailSender;
import sample.model.PooledConnection;

@WebServlet(name = "emailResolve", urlPatterns = { "/emailresolve" })
public class emailResolve extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        String reportId = request.getParameter("reportId");
        String reportCode = null;
        String recipientEmail = null;
        int locID;
        String reportFloor = null;
        String reportRoom = null;
        String reportIssue = null;
        Date reportDate = new Date();
        String reportEqmtType = null;
        String locationName = null;
        
        
        final String username = "ustfmo.reportresolver@gmail.com";
        final String password = "uhuqmvsvnvrpgime";
        
        if (reportId == null || reportId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report ID");
            return;
        }

        try (Connection connection = PooledConnection.getConnection()) {
            // Retrieve REPORT_CODE for the given reportId
            String selectQuery = "SELECT * FROM C##FMO_ADM.FMO_ITEM_REPORTS WHERE REPORT_ID = ?";
            

            try (PreparedStatement selectStmt = connection.prepareStatement(selectQuery)) {
                selectStmt.setInt(1, Integer.parseInt(reportId));
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        reportCode = rs.getString("REPORT_CODE");
                        recipientEmail = rs.getString("REC_INST_BY");
                        locID = rs.getInt("ITEM_LOC_ID");
                        reportFloor = rs.getString("REPORT_FLOOR");
                        reportRoom = rs.getString("REPORT_ROOM");
                        reportIssue = rs.getString("REPORT_ISSUE");
                        reportDate = rs.getDate("REC_INST_DT");
                        reportEqmtType = rs.getString("EQUIPMENT_TYPE");
                        
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found");
                        return;
                    }
                }
                
              
            }
            String locationQuery = "SELECT NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ITEM_LOC_ID = ?";
               try (PreparedStatement locationStmt = connection.prepareStatement(locationQuery)) {
                   locationStmt.setInt(1, locID);
                   try (ResultSet locRs = locationStmt.executeQuery()) {
                       if (locRs.next()) {
                           locationName = locRs.getString("NAME");
                       } else {
                           response.sendError(HttpServletResponse.SC_NOT_FOUND, "Location not found");
                           return;
                       }
                   }
               }


            // Update STATUS to 1 for the given reportId
            String updateQuery = "UPDATE C##FMO_ADM.FMO_ITEM_REPORTS SET STATUS = 1 WHERE REPORT_ID = ?";
            try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                updateStmt.setInt(1, Integer.parseInt(reportId));
                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    PrintWriter out = response.getWriter();
                    out.println("Report status updated successfully to RESOLVED.");
                    out.println("REPORT_CODE: " + reportCode);
                    
                    // Only send email if recipient email is valid
                    if (recipientEmail != null && !recipientEmail.equals("No email provided") && recipientEmail.contains("@")) {
                        EmailSender.sendEmail(recipientEmail, username, password, reportCode, locationName, reportFloor, reportEqmtType, reportIssue, reportDate);
                    }
                    
                    response.sendRedirect("reports");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update report status");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }
        
    public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}