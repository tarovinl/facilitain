package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.Item;
import sample.model.MaintAssign;
import sample.model.PooledConnection;

@WebServlet(name = "editMaintenanceController", urlPatterns = { "/editmaintenancecontroller" })
public class editMaintenanceController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = "";
        String status = "success";
        String maintenanceID = request.getParameter("maintID");
        String maintEType = request.getParameter("maintenanceEType");
        String assignedETo = request.getParameter("assignedETo");
        String dateEMaint = request.getParameter("dateEMaint"); 
        String maintDeleteID = request.getParameter("deleteMaintID");

        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if (maintDeleteID != null && !maintDeleteID.isEmpty()) {
                // DELETE operation
                sql = "DELETE FROM FMO_ADM.FMO_MAINTENANCE_ASSIGN WHERE assign_id = ?";
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, Integer.parseInt(maintDeleteID));
                    stmt.executeUpdate();
                    action = "delete";
                }
            } else {
                // UPDATE operation - validate date first
                Date sqlDate = null;
                java.util.Date todayOnly = null;
                java.util.Date maintOnly = null;
                
                if (dateEMaint != null && !dateEMaint.isEmpty()) {
                    try {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                        java.util.Date parsedDate = dateFormat.parse(dateEMaint);
                        sqlDate = new Date(parsedDate.getTime());
                        java.util.Date today = new java.util.Date();

                        // Remove time from both dates (so only the date matters)
                        todayOnly = dateFormat.parse(dateFormat.format(today));
                        maintOnly = dateFormat.parse(dateFormat.format(parsedDate));
                        
                        // Validate date is not in the past
                        if (maintOnly.before(todayOnly)) {
                            status = "error";
                            response.sendRedirect("maintenancePage?action=assigndate&status=" + status);
                            return; 
                        }
                    } catch (ParseException e) {
                        e.printStackTrace();
                        status = "error";
                        response.sendRedirect("maintenancePage?action=assign&status=" + status);
                        return;
                    }
                } else {
                    // Date is required for update
                    status = "error";
                    response.sendRedirect("maintenancePage?action=assign&status=" + status);
                    return;
                }
                
                // Perform UPDATE
                sql = "UPDATE FMO_ADM.FMO_MAINTENANCE_ASSIGN " +
                      "SET main_type_id = ?, user_id = ?, date_of_maintenance = ? " +
                      "WHERE assign_id = ?";
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, Integer.parseInt(maintEType));
                    stmt.setInt(2, Integer.parseInt(assignedETo));
                    stmt.setDate(3, sqlDate);
                    stmt.setInt(4, Integer.parseInt(maintenanceID));
                    
                    int rowsUpdated = stmt.executeUpdate();
                    
                    if (rowsUpdated > 0) {
                        action = "assign";
                    } else {
                        status = "error";
                    }
                }
            }
            
            response.sendRedirect("maintenancePage?action=" + action + "&status=" + status);
            
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
            response.sendRedirect("maintenancePage?action=assign&status=" + status);
        } catch (NumberFormatException e) {
            status = "error";
            e.printStackTrace();
            response.sendRedirect("maintenancePage?action=assign&status=" + status);
        }
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}