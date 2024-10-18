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
import sample.model.PooledConnection;
import sample.model.ItemType;

@WebServlet(name = "MaintenanceController", urlPatterns = { "/maintenanceSchedule", "/maintenanceSave" })
public class MaintenanceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Maintenance> maintenanceList = new ArrayList<>();
        List<ItemType> itemTypeList = new ArrayList<>();

        try (Connection con = PooledConnection.getConnection()) {
            System.out.println("Connection established successfully!");

            // Fetch maintenance data
            PreparedStatement psMaintenance = con.prepareStatement(
                "SELECT ITEM_MS_ID, ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED");
            ResultSet rsMaintenance = psMaintenance.executeQuery();
            System.out.println("Maintenance query executed successfully!");

            while (rsMaintenance.next()) {
                Maintenance maintenance = new Maintenance();
                maintenance.setItemMsId(rsMaintenance.getInt("ITEM_MS_ID"));
                maintenance.setItemTypeId(rsMaintenance.getInt("ITEM_TYPE_ID"));
                maintenance.setNoOfDays(rsMaintenance.getInt("NO_OF_DAYS"));
                maintenance.setRemarks(rsMaintenance.getString("REMARKS"));
                maintenance.setNoOfDaysWarning(rsMaintenance.getInt("NO_OF_DAYS_WARNING"));
                maintenanceList.add(maintenance);
            }

            // Fetch item type data for dropdown
            PreparedStatement psItemTypes = con.prepareStatement(
                "SELECT ITEM_TYPE_ID, ITEM_TYPE_NAME FROM C##FMO_ADM.FMO_ITEM_TYPE");
            ResultSet rsItemTypes = psItemTypes.executeQuery();
            System.out.println("Item types query executed successfully!");

            while (rsItemTypes.next()) {
                ItemType itemType = new ItemType();
                itemType.setItemTypeId(rsItemTypes.getInt("ITEM_TYPE_ID"));
                itemType.setItemTypeName(rsItemTypes.getString("ITEM_TYPE_NAME"));
                itemTypeList.add(itemType);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set both lists in the request scope
        request.setAttribute("maintenanceList", maintenanceList);
        request.setAttribute("itemTypeList", itemTypeList);
        request.getRequestDispatcher("/maintenanceSchedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemMsIdStr = request.getParameter("itemMsId");
        int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
        int noOfDays = Integer.parseInt(request.getParameter("noOfDays"));
        String remarks = request.getParameter("remarks");
        int noOfDaysWarning = Integer.parseInt(request.getParameter("noOfDaysWarning"));

        try (Connection con = PooledConnection.getConnection()) {
            if (itemMsIdStr == null || itemMsIdStr.isEmpty()) {
                // Add new maintenance schedule
                String sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED (ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING) VALUES (?, ?, ?, ?)";
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
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("maintenanceSchedule");
    }
}
