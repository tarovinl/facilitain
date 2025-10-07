package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import sample.model.PooledConnection;

@WebServlet({"/maintenanceSave"})
public class maintenanceController extends HttpServlet {
    
    // Main dispatcher method
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String redirectParams = "";
        
        try {
            // Determine which operation to perform
            if ("archive".equals(action)) {
                redirectParams = handleArchive(request);
            } else {
                // For both add and update operations
                redirectParams = handleAddOrUpdate(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Check for unique constraint violation
            
            if (e.getErrorCode() == 1 || e.getMessage().contains("FMO_ITEM_MS_ACTIVE_UK")) {
                redirectParams = "?error=duplicate";
            } else {
                redirectParams = "?error=true";
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectParams = "?error=true";
        }
        
        // Redirect back to the maintenance schedule page
        response.sendRedirect("maintenanceSchedule" + redirectParams);
    }
    
    // Handle archive operation
    private String handleArchive(HttpServletRequest request) throws SQLException {
        int itemMsId = Integer.parseInt(request.getParameter("itemMsId"));
        
        try (Connection con = PooledConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED SET ARCHIVED_FLAG = 2 WHERE ITEM_MS_ID = ?")) {
            
            ps.setInt(1, itemMsId);
            int rowsUpdated = ps.executeUpdate();
            
            if (rowsUpdated > 0) {
                return "?action=archived";
            } else {
                return "?error=archive_failed";
            }
        }
    }
    
    // Handle add or update operations
    private String handleAddOrUpdate(HttpServletRequest request) throws SQLException {
        // Extract parameters
        int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
        int noOfDays = Integer.parseInt(request.getParameter("noOfDays"));
        String remarks = request.getParameter("remarks");
        int noOfDaysWarning = Integer.parseInt(request.getParameter("noOfDaysWarning"));
        String quarterlySchedule = request.getParameter("quarterlySchedule");
        String yearlySchedule = request.getParameter("yearlySchedule");
        String itemMsIdStr = request.getParameter("itemMsId");
        
        // Log parameters for debugging
        logParameters(itemTypeId, noOfDays, remarks, noOfDaysWarning, 
                     quarterlySchedule, yearlySchedule, itemMsIdStr);
        
        // Determine if this is an edit operation
        boolean isEdit = itemMsIdStr != null && !itemMsIdStr.trim().isEmpty();
        
        // Choose appropriate SQL based on operation
        String sql = isEdit ? getUpdateSql() : getInsertSql();
        
        try (Connection con = PooledConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            // Set common parameters
            setCommonParameters(ps, itemTypeId, noOfDays, remarks, noOfDaysWarning, 
                              quarterlySchedule, yearlySchedule);
            
            // Set the ID parameter for update operations
            if (isEdit) {
                ps.setInt(7, Integer.parseInt(itemMsIdStr));
            }
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                return isEdit ? "?action=updated" : "?action=added";
            } else {
                return isEdit ? "?error=update_failed" : "?error=add_failed";
            }
        }
    }
    
    // Helper method to set common parameters for both add and update operations
    private void setCommonParameters(PreparedStatement ps, int itemTypeId, int noOfDays, 
                                   String remarks, int noOfDaysWarning, 
                                   String quarterlySchedule, String yearlySchedule) 
                                   throws SQLException {
        ps.setInt(1, itemTypeId);
        ps.setInt(2, noOfDays);
        ps.setString(3, remarks);
        ps.setInt(4, noOfDaysWarning);
        
        // Handle quarterly and yearly schedule parameters
        if (noOfDays == 90 && quarterlySchedule != null && !quarterlySchedule.isEmpty()) {
            ps.setInt(5, Integer.parseInt(quarterlySchedule));
            ps.setNull(6, java.sql.Types.INTEGER);
        } else if ((noOfDays == 365 || noOfDays == 180) && yearlySchedule != null && !yearlySchedule.isEmpty()) {
            ps.setNull(5, java.sql.Types.INTEGER);
            ps.setInt(6, Integer.parseInt(yearlySchedule));
        } else {
            ps.setNull(5, java.sql.Types.INTEGER);
            ps.setNull(6, java.sql.Types.INTEGER);
        }
    }
    
    // Helper method to get SQL for update operation
    private String getUpdateSql() {
        return "UPDATE FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED " +
               "SET ITEM_TYPE_ID = ?, NO_OF_DAYS = ?, REMARKS = ?, " +
               "NO_OF_DAYS_WARNING = ?, QUARTERLY_SCHED_NO = ?, YEARLY_SCHED_NO = ? " +
               "WHERE ITEM_MS_ID = ?";
    }
    
    // Helper method to get SQL for insert operation
    private String getInsertSql() {
        return "INSERT INTO FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED " +
               "(ITEM_MS_ID, ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING, " +
               "QUARTERLY_SCHED_NO, YEARLY_SCHED_NO, ARCHIVED_FLAG, MAIN_TYPE_ID) " +
               "VALUES (FMO_ADM.FMO_ITEM_MAINT_SCHED_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, 1, 1)";
    }
    
    // Helper method to log parameters for debugging
    private void logParameters(int itemTypeId, int noOfDays, String remarks, 
                             int noOfDaysWarning, String quarterlySchedule, 
                             String yearlySchedule, String itemMsIdStr) {
        System.out.println("itemTypeId: " + itemTypeId);
        System.out.println("noOfDays: " + noOfDays);
        System.out.println("remarks: " + remarks);
        System.out.println("noOfDaysWarning: " + noOfDaysWarning);
        System.out.println("quarterlySchedule: " + quarterlySchedule);
        System.out.println("yearlySchedule: " + yearlySchedule);
        System.out.println("itemMsIdStr: " + itemMsIdStr);
    }
}