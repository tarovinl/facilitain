package com.sample;

import java.io.IOException;
import java.io.PrintWriter;

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

@WebServlet(name = "addMaintenanceController", urlPatterns = { "/addmaintenancecontroller" })
public class addMaintenanceController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        String action = "";
        String status = "success";
        String equipmentName = request.getParameter("equipmentName");
        int equipmentMaintId = 0;
        String maintenanceType = request.getParameter("maintenanceType");
        String assignedTo = request.getParameter("assignedTo");
        String dateMaint = request.getParameter("dateMaint"); 
        ArrayList<Item> listItem = new ArrayList<>();
        ArrayList<MaintAssign> listAssign = new ArrayList<>();
        
        //item list maker to check equipmentName
        try (
            Connection con = PooledConnection.getConnection();
            PreparedStatement stmntItems = con.prepareCall("SELECT * FROM FMO_ADM.FMO_ITEMS ORDER BY LOCATION_ID, CASE WHEN REGEXP_LIKE(FLOOR_NO, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(FLOOR_NO, '^[0-9]+')) ELSE 9999 END, ROOM_NO, ITEM_ID");
            PreparedStatement stmntAssign = con.prepareCall("SELECT * FROM FMO_ADM.FMO_MAINTENANCE_ASSIGN ORDER BY DATE_OF_MAINTENANCE");
        ){
            ResultSet rsItem = stmntItems.executeQuery();
            while (rsItem.next()) {
                Item items = new Item();
                items.setItemID(rsItem.getInt("ITEM_ID"));
                items.setItemLID(rsItem.getInt("LOCATION_ID"));
                items.setItemTID(rsItem.getInt("ITEM_TYPE_ID"));
                items.setItemName(rsItem.getString("NAME"));
                items.setItemMaintStat(rsItem.getInt("MAINTENANCE_STATUS"));
                items.setLastMaintDate(rsItem.getDate("LAST_MAINTENANCE_DATE"));
                items.setPlannedMaintDate(rsItem.getDate("PLANNED_MAINTENANCE_DATE"));
                
                listItem.add(items);
            }
            rsItem.close();
            
            ResultSet rsAssign = stmntAssign.executeQuery();
            while (rsAssign.next()) {
                MaintAssign mass = new MaintAssign();
                mass.setAssignID(rsAssign.getInt("ASSIGN_ID"));
                mass.setItemID(rsAssign.getInt("ITEM_ID"));
                mass.setUserID(rsAssign.getInt("USER_ID"));
                mass.setMaintTID(rsAssign.getInt("MAIN_TYPE_ID"));
                mass.setDateOfMaint(rsAssign.getDate("DATE_OF_MAINTENANCE"));
                mass.setIsCompleted(rsAssign.getInt("IS_COMPLETED"));
                listAssign.add(mass);
            }
            rsAssign.close();
        
        } catch (SQLException error) {
            error.printStackTrace();
        }
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date sqlDate = null;
        try {
            java.util.Date parsedDate = dateFormat.parse(dateMaint);
            sqlDate = new Date(parsedDate.getTime()); 
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        for (Item itemz : listItem) {
            if (equipmentName.equals(itemz.getItemName())) { 
                equipmentMaintId = itemz.getItemID(); 
                break; // Exit loop once a match is found
            }
        }
        // Check if equipmentMaintId is still 0 (meaning no match was found)
        if (equipmentMaintId == 0) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assign" + "&status=" + status);
            return; // Stop execution to prevent invalid database insert
        }

        
        boolean isAlreadyAssigned = false;
        for (MaintAssign assignz : listAssign) {
            if (assignz.getItemID() == equipmentMaintId && assignz.getIsCompleted() == 0) { 
                isAlreadyAssigned = true;
                break; // Exit loop once a match is found
            }
        }
        // If the equipment is already assigned, handle the error
        if (isAlreadyAssigned) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assign" + "&status=" + status);
            return; // Stop execution
        }

        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            sql = "INSERT INTO FMO_ADM.FMO_MAINTENANCE_ASSIGN (item_id, main_type_id, user_id, date_of_maintenance) VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, equipmentMaintId);
                stmt.setInt(2, Integer.parseInt(maintenanceType));
                stmt.setInt(3, Integer.parseInt(assignedTo));
                stmt.setDate(4, sqlDate);

                stmt.executeUpdate();
            }
            
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
        }
        
    }
}
