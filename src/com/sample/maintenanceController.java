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
        String itemMsIdStr = request.getParameter("itemMsId");
        int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
        int noOfDays = Integer.parseInt(request.getParameter("noOfDays"));
        String remarks = request.getParameter("remarks");
        int noOfDaysWarning = Integer.parseInt(request.getParameter("noOfDaysWarning"));

        try (Connection con = PooledConnection.getConnection()) {
            if (itemMsIdStr == null || itemMsIdStr.isEmpty()) {
                // Add new maintenance schedule
                String sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED (ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, ACTIVE_FLAG, NO_OF_DAYS_WARNING) VALUES (?, ?, ?, 1, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, itemTypeId);
                    ps.setInt(2, noOfDays);
                    ps.setString(3, remarks);
                    ps.setInt(4, noOfDaysWarning);
                    ps.executeUpdate();
                }
            } else {
                // Edit existing maintenance schedule
                int itemMsId = Integer.parseInt(itemMsIdStr);
                String sql = "UPDATE C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED SET ITEM_TYPE_ID = ?, NO_OF_DAYS = ?, REMARKS = ?, NO_OF_DAYS_WARNING = ? WHERE ITEM_MS_ID = ?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, itemTypeId);
                    ps.setInt(2, noOfDays);
                    ps.setString(3, remarks);
                    ps.setInt(4, noOfDaysWarning);
                    ps.setInt(5, itemMsId);
                    ps.executeUpdate();
                }
            }
            
            response.sendRedirect("maintenanceSchedule");
        } catch (Exception e) {
            e.printStackTrace();
        }

        
    }
}
