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

import sample.model.EmailSender;
import sample.model.Item;
import sample.model.MaintAssign;
import sample.model.PooledConnection;

@WebServlet(name = "addMaintenanceController", urlPatterns = { "/addmaintenancecontroller" })
public class addMaintenanceController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";
    
    // Email credentials - same as in emailResolve
    private static final String EMAIL_USERNAME = "ustfmo.reportresolver@gmail.com";
    private static final String EMAIL_PASSWORD = "uhuqmvsvnvrpgime";

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
        
        // Variables for email
        String assignedUserEmail = null;
        String assignedUserName = null;
        String maintenanceTypeName = null;
        String equipmentTypeName = null;
        String locationName = null;
        String floorNo = null;
        String roomNo = null;
        
        boolean itemFoundOpeStatus = false;
        
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
                items.setItemFloor(rsItem.getString("FLOOR_NO"));
                items.setItemRoom(rsItem.getString("ROOM_NO"));
                
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
        java.util.Date todayOnly = null;
        java.util.Date maintOnly = null;
        try {
            java.util.Date parsedDate = dateFormat.parse(dateMaint);
            sqlDate = new Date(parsedDate.getTime()); 
            java.util.Date today = new java.util.Date();

                // Remove time from both dates (so only the date matters)
            todayOnly = dateFormat.parse(dateFormat.format(today));
            maintOnly = dateFormat.parse(dateFormat.format(parsedDate));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // Find equipment and store additional details for email
        // AI was used for equalsIgnoreCase
        // Tool: ChatGPT, Prompt: "how do I make the code above ignore character case [code above is generally the same but w/o equalsIgnoreCase]"
        for (Item itemz : listItem) {
            if (equipmentName.equalsIgnoreCase(itemz.getItemName())) { 
                if(itemz.getItemMaintStat() == 2){
                    equipmentMaintId = itemz.getItemID();
                    floorNo = itemz.getItemFloor();
                    roomNo = itemz.getItemRoom();
                    break;
                } else{
                    itemFoundOpeStatus = true;
                    break;
                }
                
            }
        }
        if (itemFoundOpeStatus) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assignop" + "&status=" + status);
            return;
        }
        
        // Check if equipmentMaintId is still 0 (meaning no match was found)
        if (equipmentMaintId == 0) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assign" + "&status=" + status);
            return;
        }

        if (maintOnly.before(todayOnly)) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assigndate&status=" + status);
            return; 
        }
        
        
        
        boolean isAlreadyAssigned = false;
        for (MaintAssign assignz : listAssign) {
            if (assignz.getItemID() == equipmentMaintId && assignz.getIsCompleted() == 0) { 
                isAlreadyAssigned = true;
                break;
            }
        }
        
        if (isAlreadyAssigned) {
            status = "error";
            response.sendRedirect("maintenancePage?action=assign" + "&status=" + status);
            return;
        }

        
        try (Connection conn = PooledConnection.getConnection()) {
            
            // Fetch assigned user email and name
            String userSql = "SELECT NAME, EMAIL FROM FMO_ADM.FMO_ITEM_DUSERS WHERE USER_ID = ?";
            try (PreparedStatement userStmt = conn.prepareStatement(userSql)) {
                userStmt.setInt(1, Integer.parseInt(assignedTo));
                try (ResultSet userRs = userStmt.executeQuery()) {
                    if (userRs.next()) {
                        assignedUserName = userRs.getString("NAME");
                        assignedUserEmail = userRs.getString("EMAIL");
                    }
                }
            }
            
            // Fetch maintenance type name
            String maintTypeSql = "SELECT NAME FROM FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES WHERE MAIN_TYPE_ID = ?";
            try (PreparedStatement maintTypeStmt = conn.prepareStatement(maintTypeSql)) {
                maintTypeStmt.setInt(1, Integer.parseInt(maintenanceType));
                try (ResultSet maintTypeRs = maintTypeStmt.executeQuery()) {
                    if (maintTypeRs.next()) {
                        maintenanceTypeName = maintTypeRs.getString("NAME");
                    }
                }
            }
            
            // Fetch equipment type and location details
            String equipDetailSql = "SELECT t.NAME AS TYPE_NAME, c.NAME AS CAT_NAME, l.NAME AS LOC_NAME " +
                                   "FROM FMO_ADM.FMO_ITEMS i " +
                                   "JOIN FMO_ADM.FMO_ITEM_TYPES t ON i.ITEM_TYPE_ID = t.ITEM_TYPE_ID " +
                                   "JOIN FMO_ADM.FMO_ITEM_CATEGORIES c ON t.ITEM_CAT_ID = c.ITEM_CAT_ID " +
                                   "JOIN FMO_ADM.FMO_ITEM_LOCATIONS l ON i.LOCATION_ID = l.ITEM_LOC_ID " +
                                   "WHERE i.ITEM_ID = ?";
            try (PreparedStatement equipStmt = conn.prepareStatement(equipDetailSql)) {
                equipStmt.setInt(1, equipmentMaintId);
                try (ResultSet equipRs = equipStmt.executeQuery()) {
                    if (equipRs.next()) {
                        String categoryName = equipRs.getString("CAT_NAME");
                        String typeName = equipRs.getString("TYPE_NAME");
                        equipmentTypeName = categoryName + " - " + typeName;
                        locationName = equipRs.getString("LOC_NAME");
                    }
                }
            }
            
            // Insert maintenance assignment
            String sql = "INSERT INTO FMO_ADM.FMO_MAINTENANCE_ASSIGN (item_id, main_type_id, user_id, date_of_maintenance) VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, equipmentMaintId);
                stmt.setInt(2, Integer.parseInt(maintenanceType));
                stmt.setInt(3, Integer.parseInt(assignedTo));
                stmt.setDate(4, sqlDate);

                stmt.executeUpdate();
                
                // Send email notification if we have valid email
                if (assignedUserEmail != null && !assignedUserEmail.isEmpty() && 
                    assignedUserEmail.contains("@") && !assignedUserEmail.equals("No email provided")) {
                    
                    try {
                        EmailSender.sendMaintenanceAssignmentEmail(
                            assignedUserEmail,
                            EMAIL_USERNAME,
                            EMAIL_PASSWORD,
                            equipmentName,
                            locationName != null ? locationName : "N/A",
                            floorNo != null ? floorNo : "N/A",
                            roomNo != null ? roomNo : "N/A",
                            equipmentTypeName != null ? equipmentTypeName : "N/A",
                            maintenanceTypeName != null ? maintenanceTypeName : "N/A",
                            sqlDate
                        );
                        System.out.println("Email notification sent to " + assignedUserName + " (" + assignedUserEmail + ")");
                    } catch (Exception emailEx) {
                        // Log error but don't fail the entire operation
                        System.err.println("Failed to send email notification: " + emailEx.getMessage());
                        emailEx.printStackTrace();
                    }
                }
            }
            
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
            response.sendRedirect("maintenancePage?action=assign" + "&status=" + status);
        }
        
    }
}