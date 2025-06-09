package com.sample;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import java.math.BigDecimal;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.PooledConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

import javax.servlet.annotation.MultipartConfig;

import sample.model.MaintAssign;

@WebServlet(name = "updateStatusController", urlPatterns = { "/updatestatuscontroller" })
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB file size limit
public class updateStatusController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        request.setCharacterEncoding("UTF-8");
        String action = "";
        String status = "success";
        
        String updateEquipmentID = request.getParameter("equipmentId");
        String oldEquipmentStatus = request.getParameter("equipmentStatus");
        String newEquipmentStatus = request.getParameter("statusNew");
        String updateEquipmentLID = request.getParameter("equipmentLID");

        int equipmentIDToUpdate = Integer.parseInt(updateEquipmentID);
        boolean isRepaired = false;
        ArrayList<MaintAssign> listAssign2 = new ArrayList<>();
        
        String description = request.getParameter("description");
        Part filePart = request.getPart("quotationFile");
        Map<String, String[]> parameterMap = request.getParameterMap();
            for (String key : parameterMap.keySet()) {
              System.out.println("Parameter: " + key + " = " + Arrays.toString(parameterMap.get(key)));
            }
        BigDecimal itemID = (updateEquipmentID != null && !updateEquipmentID.isEmpty()) ? new BigDecimal(updateEquipmentID) : null;
        InputStream fileInputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileInputStream = filePart.getInputStream();
        }

        
//        System.out.println("equip ID: " + updateEquipmentID);
//        System.out.println("old equip status: " + oldEquipmentStatus);
//        System.out.println("new equip status: " + newEquipmentStatus);
        if (newEquipmentStatus == null || newEquipmentStatus.isEmpty()) {
            status = "error";
            response.sendRedirect("maintenancePage?action=" + action + "&status=" + status);
            return;
        }
        //maintenance required to operational mistake checker
        if (oldEquipmentStatus.equals("2") && newEquipmentStatus.equals("1")) {
            status = "error";
            action = "2to1";
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
            return;
        }
        

        try (
             Connection con = PooledConnection.getConnection();
             PreparedStatement stmntAssign = con.prepareCall("SELECT * FROM FMO_ADM.FMO_MAINTENANCE_ASSIGN ORDER BY DATE_OF_MAINTENANCE");
             ){
            ResultSet rsAssign = stmntAssign.executeQuery();
            while (rsAssign.next()) {
                MaintAssign mass = new MaintAssign();
                mass.setAssignID(rsAssign.getInt("ASSIGN_ID"));
                mass.setItemID(rsAssign.getInt("ITEM_ID"));
                mass.setUserID(rsAssign.getInt("USER_ID"));
                mass.setMaintTID(rsAssign.getInt("MAIN_TYPE_ID"));
                mass.setDateOfMaint(rsAssign.getDate("DATE_OF_MAINTENANCE"));
                mass.setIsCompleted(rsAssign.getInt("IS_COMPLETED"));
                listAssign2.add(mass);
            }
            rsAssign.close();
        } catch (SQLException error) {
            error.printStackTrace();
        }


        for (MaintAssign assign : listAssign2) {
            if (assign.getItemID() == equipmentIDToUpdate &&
                assign.getMaintTID() == 3 &&
                assign.getIsCompleted() == 0) {
                isRepaired = true;
                break; // Optional: break if only one match matters
            }
        }

        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            sql = "UPDATE FMO_ADM.FMO_ITEMS SET MAINTENANCE_STATUS = ? WHERE ITEM_ID = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(newEquipmentStatus));
                stmt.setInt(2, Integer.parseInt(updateEquipmentID));

                stmt.executeUpdate();
            }
            
            // Insert Quotation Only If File Exists and Required Fields Are Filled
            if ((oldEquipmentStatus.equals("2") && newEquipmentStatus.equals("3")) &&
                description != null && filePart != null && filePart.getSize() > 0) {
                BigDecimal quotationID = generateQuotationID(conn);


                String insertSQL = "INSERT INTO FMO_ADM.FMO_ITEM_QUOTATIONS (ITEM_ID, DESCRIPTION, QUOTATION_ID, QUOTATION_IMAGE, DATE_UPLOADED) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
                    pstmt.setBigDecimal(1, itemID);
                    pstmt.setString(2, description);
                    pstmt.setBigDecimal(3, quotationID);
                    pstmt.setBlob(4, fileInputStream);
                    pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                    pstmt.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                action = "modify_status";
            }
            
            //in maintenance to operational turn maint_assign entry is_completed to 1
            if (oldEquipmentStatus.equals("3") && newEquipmentStatus.equals("1")) {
                String assSQL = "UPDATE FMO_ADM.FMO_MAINTENANCE_ASSIGN SET IS_COMPLETED = 1 WHERE ITEM_ID = ?";
                try (PreparedStatement astmt = conn.prepareStatement(assSQL)) {
                    astmt.setInt(1, Integer.parseInt(updateEquipmentID));
                    astmt.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                if(isRepaired){
                                        String currentMonth = String.valueOf(java.time.LocalDate.now().getMonthValue());
                                        String currentYear = String.valueOf(java.time.LocalDate.now().getYear());
                    
                                        // Check if an entry for the current month and year exists
                                        String selectRepairsSql = "SELECT NUM_OF_REPAIRS FROM FMO_ADM.FMO_ITEM_REPAIRS WHERE REPAIR_MONTH = ? AND REPAIR_YEAR = ? AND ITEM_LOC_ID = ?";
                                        try (PreparedStatement selectStmt = conn.prepareStatement(selectRepairsSql)) {
                                            selectStmt.setInt(1, Integer.parseInt(currentMonth));
                                            selectStmt.setInt(2, Integer.parseInt(currentYear));
                                            selectStmt.setInt(3, Integer.parseInt(updateEquipmentLID));
                                            try (ResultSet rs = selectStmt.executeQuery()) {
                                                if (rs.next()) {
                                                    // Update NUM_OF_REPAIRS if entry exists
                                                    int repairCount = rs.getInt("NUM_OF_REPAIRS");
                                                    String updateRepairsSql = "UPDATE FMO_ADM.FMO_ITEM_REPAIRS SET NUM_OF_REPAIRS = ? WHERE REPAIR_MONTH = ? AND REPAIR_YEAR = ? AND ITEM_LOC_ID = ?";
                                                    try (PreparedStatement updateStmt = conn.prepareStatement(updateRepairsSql)) {
                                                        updateStmt.setInt(1, repairCount + 1);
                                                        updateStmt.setInt(2, Integer.parseInt(currentMonth));
                                                        updateStmt.setInt(3, Integer.parseInt(currentYear));
                                                        updateStmt.setInt(4, Integer.parseInt(updateEquipmentLID));
                                                        updateStmt.executeUpdate();
                                                    }
                                                } else {
                                                    // Insert a new row if no entry exists
                                                    String insertRepairsSql = "INSERT INTO FMO_ADM.FMO_ITEM_REPAIRS (REPAIR_MONTH, REPAIR_YEAR, NUM_OF_REPAIRS, ITEM_LOC_ID) VALUES (?, ?, ?, ?)";
                                                    try (PreparedStatement insertStmt = conn.prepareStatement(insertRepairsSql)) {
                                                        insertStmt.setInt(1, Integer.parseInt(currentMonth));
                                                        insertStmt.setInt(2, Integer.parseInt(currentYear));
                                                        insertStmt.setInt(3, 1);
                                                        insertStmt.setInt(4, Integer.parseInt(updateEquipmentLID));
                                                        insertStmt.executeUpdate();
                                                    }
                                                }
                                            }
                                        }
                }
                
                action = "3to1";
            }
            
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
        }
    }
    
    private BigDecimal generateQuotationID(Connection conn) {
        BigDecimal newID = BigDecimal.ONE;
        String query = "SELECT MAX(QUOTATION_ID) FROM FMO_ADM.FMO_ITEM_QUOTATIONS";
        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                BigDecimal maxID = rs.getBigDecimal(1);
                if (maxID != null) {
                    newID = maxID.add(BigDecimal.ONE);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newID;
    }

}
