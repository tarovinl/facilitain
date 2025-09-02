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
        int equipmentMaintId = 0;
        String equipmentEName = request.getParameter("equipmentEName");
        String maintEType = request.getParameter("maintenanceEType");
        String assignedETo = request.getParameter("assignedETo");
        String dateEMaint = request.getParameter("dateEMaint"); 
        ArrayList<Item> listEItem = new ArrayList<>();
        ArrayList<MaintAssign> listEAssign = new ArrayList<>();
        
        String maintDeleteID = request.getParameter("deleteMaintID");
        
//        System.out.println("Maintenance ID: " + maintenanceID);
//        System.out.println("Equipment Name: " + equipmentEName);
//        System.out.println("Maintenance Type: " + maintEType);
//        System.out.println("Assigned To: " + assignedETo);
//        System.out.println("Date of Maintenance: " + dateEMaint);
        
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
                
                listEItem.add(items);
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
                listEAssign.add(mass);
            }
            rsAssign.close();
        
        } catch (SQLException error) {
            error.printStackTrace();
        }
        
        Date sqlDate = null;
        if (dateEMaint != null && !dateEMaint.isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = dateFormat.parse(dateEMaint);
                sqlDate = new Date(parsedDate.getTime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if(maintDeleteID != null && !maintDeleteID.isEmpty()){
                sql = "DELETE FROM FMO_ADM.FMO_MAINTENANCE_ASSIGN WHERE assign_id = ?";
            }else{
                sql = "UPDATE FMO_ADM.FMO_MAINTENANCE_ASSIGN SET item_id = ?, main_type_id = ?, user_id = ?, date_of_maintenance = ? WHERE assign_id = ?";
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if(maintDeleteID != null && !maintDeleteID.isEmpty()){
                    stmt.setInt(1, Integer.parseInt(maintDeleteID));
                    action = "delete";
                }else{
                    stmt.setInt(1, equipmentMaintId);
                    stmt.setInt(2, Integer.parseInt(maintEType));
                    stmt.setInt(3, Integer.parseInt(assignedETo));
                    stmt.setDate(4, sqlDate);
                    stmt.setInt(5, Integer.parseInt(maintenanceID));
                    
                    action = "assign";
                }
                
                stmt.executeUpdate();
            }
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
        }
        
        
//        response.sendRedirect("maintenancePage");
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                          IOException {
    }
}
