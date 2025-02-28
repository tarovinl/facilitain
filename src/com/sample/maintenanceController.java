package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sample.model.Maintenance;
import sample.model.ItemType;

import sample.model.PooledConnection;

@WebServlet("/maintenanceSave")
public class maintenanceController extends HttpServlet {


//     @Override
//     protected void doGet(HttpServletRequest request, HttpServletResponse response)
//             throws ServletException, IOException {
//         List<Maintenance> maintenanceList = new ArrayList<>();
//         List<ItemType> itemTypeList = new ArrayList<>();

//         try (Connection con = PooledConnection.getConnection()) {
//             // Fetch maintenance schedule data
//             PreparedStatement ps = con.prepareStatement(
//                 "SELECT m.ITEM_MS_ID, m.ITEM_TYPE_ID, m.NO_OF_DAYS, m.REMARKS, m.NO_OF_DAYS_WARNING, t.NAME AS ITEM_TYPE_NAME " +
//                 "FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED m " +
//                 "LEFT JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON m.ITEM_TYPE_ID = t.ITEM_TYPE_ID");
//             ResultSet rs = ps.executeQuery();

//             while (rs.next()) {
//                 Maintenance maintenance = new Maintenance();
//                 maintenance.setItemMsId(rs.getInt("ITEM_MS_ID"));
//                 maintenance.setItemTypeId(rs.getInt("ITEM_TYPE_ID"));
//                 maintenance.setItemTypeName(rs.getString("ITEM_TYPE_NAME"));
//                 maintenance.setNoOfDays(rs.getInt("NO_OF_DAYS"));
//                 maintenance.setRemarks(rs.getString("REMARKS"));
//                 maintenance.setNoOfDaysWarning(rs.getInt("NO_OF_DAYS_WARNING"));
//                 maintenanceList.add(maintenance);
//             }

//             // Fetch item type data for dropdown
//             ps = con.prepareStatement("SELECT ITEM_TYPE_ID, NAME FROM C##FMO_ADM.FMO_ITEM_TYPES WHERE ACTIVE_FLAG = 1");
//             rs = ps.executeQuery();

//             while (rs.next()) {
//                 ItemType itemType = new ItemType();
//                 itemType.setItemTypeId(rs.getInt("ITEM_TYPE_ID"));
//                 itemType.setName(rs.getString("NAME"));
//                 itemTypeList.add(itemType);
//             }

//         } catch (Exception e) {
//             e.printStackTrace();
//         }

//         request.setAttribute("maintenanceList", maintenanceList);
//         request.setAttribute("itemTypeList", itemTypeList);
//         request.getRequestDispatcher("/maintenanceSchedule.jsp").forward(request, response);
//     }

      @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");
    String redirectParams = "";

    try (Connection con = PooledConnection.getConnection()) {
        if ("archive".equals(action)) {
            int itemMsId = Integer.parseInt(request.getParameter("itemMsId"));
            String updateSql = "UPDATE C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED SET ARCHIVED_FLAG = 2 WHERE ITEM_MS_ID = ?";
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setInt(1, itemMsId);
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    redirectParams = "?action=archived";
                } else {
                    redirectParams = "?error=true";
                }
            }
        } else {
            // Get all parameters
            int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
            int noOfDays = Integer.parseInt(request.getParameter("noOfDays"));
            String remarks = request.getParameter("remarks");
            int noOfDaysWarning = Integer.parseInt(request.getParameter("noOfDaysWarning"));
            String quarterlySchedule = request.getParameter("quarterlySchedule");
            String yearlySchedule = request.getParameter("yearlySchedule");
            String itemMsIdStr = request.getParameter("itemMsId");

            // Check if this is an edit operation
            boolean isEdit = itemMsIdStr != null && !itemMsIdStr.trim().isEmpty();
            String sql;
            
            if (isEdit) {
                // Update existing record
                sql = "UPDATE C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED " +
                      "SET ITEM_TYPE_ID = ?, " +
                      "NO_OF_DAYS = ?, " +
                      "REMARKS = ?, " +
                      "NO_OF_DAYS_WARNING = ?, " +
                      "QUARTERLY_SCHED_NO = ?, " +
                      "YEARLY_SCHED_NO = ? " +
                      "WHERE ITEM_MS_ID = ?";
            } else {
                // Insert new record
                sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED " +
                      "(ITEM_MS_ID, ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING, QUARTERLY_SCHED_NO, YEARLY_SCHED_NO, ARCHIVED_FLAG) " +
                      "VALUES (C##FMO_ADM.ITEM_MS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, 1)";
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                // Set common parameters
                ps.setInt(1, itemTypeId);
                ps.setInt(2, noOfDays);
                ps.setString(3, remarks);
                ps.setInt(4, noOfDaysWarning);

                // Handle quarterly and yearly schedule
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

                // Set the ID parameter for UPDATE operations
                if (isEdit) {
                    ps.setInt(7, Integer.parseInt(itemMsIdStr));
                }

                int result = ps.executeUpdate();
                if (result > 0) {
                    redirectParams = isEdit ? "?action=updated" : "?action=added";
                } else {
                    redirectParams = "?error=true";
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        redirectParams = "?error=true";
    }

    response.sendRedirect("maintenanceSchedule" + redirectParams);
}
   }