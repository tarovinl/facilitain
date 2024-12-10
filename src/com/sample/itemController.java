package com.sample;

import com.oracle.wls.shaded.org.apache.xalan.lib.Redirect;

import java.io.PrintWriter;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.PooledConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.sql.Date;
import java.sql.ResultSet;

@WebServlet(name = "itemController", urlPatterns = { "/itemcontroller" })
public class itemController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
            // Access form parameters
        
        String loc = request.getParameter("itemLID");
        String flr = request.getParameter("itemFlr");
            
        String itemName = request.getParameter("itemCode");
        String itemBuilding = request.getParameter("itemBuilding");
        String itemCat = request.getParameter("itemCat");
        String itemType = request.getParameter("itemType");
        String itemBrand = request.getParameter("itemBrand");
        String itemFloor = request.getParameter("itemAddFloor");
        String itemRoom = request.getParameter("itemAddRoom");
        String itemDateInst = request.getParameter("itemInstalled");
        String itemExpiry = request.getParameter("itemExpiration");
//        String itemSchedNum = request.getParameter("itemSchedNum");
//        String itemSched = request.getParameter("itemSched");
        String locText = request.getParameter("locText");
        String remarks = request.getParameter("remarks");
        String itemPCC = request.getParameter("itemPCC");
        String itemACCU = request.getParameter("itemACCU");
        String itemFCU = request.getParameter("itemFCU");
        String itemACINVERTER = request.getParameter("itemACINVERTER");
        String itemCapacity = request.getParameter("itemCapacity");
        String itemUnitMeasure = request.getParameter("itemUnitMeasure");
        String itemEV = request.getParameter("itemElecV");
        String itemEPH = request.getParameter("itemElecPH");
        String itemEHZ = request.getParameter("itemElecHZ");
        
        
        
        String itemEID = request.getParameter("itemEditID");
        String itemEditName = request.getParameter("itemEditCode");
        String itemEditLoc = request.getParameter("itemEditLoc");
        String itemEditCat = request.getParameter("itemEditCat");
        String itemEditType = request.getParameter("itemEditType");
        String itemEditBrand = request.getParameter("itemEditBrand");
        String itemEditFloor = request.getParameter("itemEditFloor");
        String itemEditRoom = request.getParameter("itemEditRoom");
        String itemEditDateInst = request.getParameter("itemEditInstalled");
        String itemEditExpiry = request.getParameter("itemEditExpiration");
//        String itemEditSchedNum = request.getParameter("itemEditSchedNum");
//        String itemEditSched = request.getParameter("itemEditSched");
        String editLocText = request.getParameter("editLocText");
        String editRemarks = request.getParameter("editRemarks");
        String itemEditPCC = request.getParameter("itemEditPCC");
        String itemEditACCU = request.getParameter("itemEditACCU");
        String itemEditFCU = request.getParameter("itemEditFCU");
        String itemEditACINVERTER = request.getParameter("itemEditACINVERTER");
        String itemEditCapacity = request.getParameter("itemECapacity");
        String itemEditUnitMeasure = request.getParameter("itemEUnitMeasure");
        String itemEditEV = request.getParameter("itemEditElecV");
        String itemEditEPH = request.getParameter("itemEditElecPH");
        String itemEditEHZ = request.getParameter("itemEditElecHZ");
        
        String maintStatID = request.getParameter("maintStatID");
        String maintStatus = request.getParameter("statusDropdown");
        String oldMaintStat = request.getParameter("oldMaintStat");

        String itemAID = request.getParameter("itemArchiveID");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date sqlDate = null;
        Date sqlEditDate = null;
        Date sqlExpire = null;
        Date sqlEditExpire = null;
        
        try {
            if (itemEID != null && !itemEID.isEmpty()) {
                java.util.Date parsedEDate = dateFormat.parse(itemEditDateInst);
                sqlEditDate = new Date(parsedEDate.getTime());

                if (itemEditExpiry != null && !itemEditExpiry.isEmpty()) {
                                    java.util.Date parsedEditExpireDate = dateFormat.parse(itemEditExpiry);
                                    sqlEditExpire = new Date(parsedEditExpireDate.getTime());
                                }
            } else if(maintStatID != null && !maintStatID.isEmpty()){
                
            } else if(itemAID != null && !itemAID.isEmpty()){
                    
            } else {
                java.util.Date parsedDate = dateFormat.parse(itemDateInst);
                sqlDate = new Date(parsedDate.getTime()); 

                java.util.Date parsedExpireDate = dateFormat.parse(itemExpiry);
                sqlExpire = new Date(parsedExpireDate.getTime());
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
//        System.out.println(itemName);
//        System.out.println(itemBuilding);
//        System.out.println(itemCat);
//        System.out.println(itemType);
//        System.out.println(itemBrand);
//        System.out.println(itemFloor);
//        System.out.println(itemRoom);
//        System.out.println(itemDateInst);
//        System.out.println(sqlDate);
//        System.out.println(itemSchedNum + " - " + itemSched);
//        System.out.println(locText);
//        System.out.println(remarks);
        
//        System.out.println(sqlDate);
        
        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if(itemEID != null && !itemEID.isEmpty()){
                sql = "UPDATE FMO_ADM.FMO_ITEMS SET ITEM_TYPE_ID = ?, NAME = ?, LOCATION_ID = ?, LOCATION_TEXT = ?, FLOOR_NO = ?, ROOM_NO = ?, DATE_INSTALLED = ?, BRAND_NAME = ?, EXPIRY_DATE = ?, REMARKS = ?, PC_CODE = ?, AC_ACCU = ?, AC_FCU = ?, AC_INVERTER = ?, CAPACITY = ?, UNIT_OF_MEASURE = ?, ELECTRICAL_V = ?, ELECTRICAL_PH = ?, ELECTRICAL_HZ = ?  WHERE ITEM_ID = ?";
                //System.out.println("edit this " + itemEditName);
                
            }else if(maintStatID != null && !maintStatID.isEmpty()){
                sql = "UPDATE FMO_ADM.FMO_ITEMS SET MAINTENANCE_STATUS = ? WHERE ITEM_ID = ?";
                //System.out.println("maint this " + maintStatus + " "+oldMaintStat+" "+loc);
                
            } else if(itemAID != null && !itemAID.isEmpty()){
                sql = "UPDATE FMO_ADM.FMO_ITEMS SET ITEM_STAT_ID = 2 WHERE ITEM_ID = ?";
                //System.out.println("archive this " + itemAID);
            }else{
                sql = "INSERT INTO FMO_ADM.FMO_ITEMS (ITEM_TYPE_ID,NAME,LOCATION_ID,LOCATION_TEXT,FLOOR_NO,ROOM_NO,DATE_INSTALLED,BRAND_NAME,EXPIRY_DATE,REMARKS,PC_CODE,AC_ACCU,AC_FCU,AC_INVERTER,CAPACITY,UNIT_OF_MEASURE,ELECTRICAL_V,ELECTRICAL_PH,ELECTRICAL_HZ,MAINTENANCE_STATUS,ITEM_STAT_ID,QUANTITY) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,1,1)";
                //System.out.println("add this " + itemName);
            }
            
            

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if(itemEID != null && !itemEID.isEmpty()){
                    stmt.setInt(1, Integer.parseInt(itemEditType));
                    stmt.setString(2, itemEditName);
                    stmt.setInt(3, Integer.parseInt(itemEditLoc));
                    stmt.setString(4, editLocText);
                    stmt.setString(5, itemEditFloor);
                    if ("Non-Room Equipment".equals(itemEditRoom)) {
                        stmt.setNull(6, java.sql.Types.VARCHAR); // Set the parameter to null if the condition is met
                    } else {
                        stmt.setString(6, itemEditRoom); // Set the value as is if the condition is not met
                    }
                    stmt.setDate(7, sqlEditDate);
                    stmt.setString(8, itemEditBrand);
                    stmt.setDate(9, sqlEditExpire);
                    stmt.setString(10, editRemarks);
                        if (itemEditPCC != null && !itemEditPCC.isEmpty()) {
                            stmt.setInt(11, Integer.parseInt(itemEditPCC));
                        } else {
                            stmt.setNull(11, java.sql.Types.INTEGER);
                        }
                        
                            if ("1".equals(itemEditCat)) {  // Check if itemEditCat is "1"
                                if (itemEditACCU != null && !itemEditACCU.isEmpty()) {
                                    stmt.setInt(12, Integer.parseInt(itemEditACCU));
                                } else {
                                    stmt.setNull(12, java.sql.Types.INTEGER);
                                }
                                if (itemEditFCU != null && !itemEditFCU.isEmpty()) {
                                    stmt.setInt(13, Integer.parseInt(itemEditFCU));
                                } else {
                                    stmt.setNull(13, java.sql.Types.INTEGER);
                                }
                                if (itemEditACINVERTER != null && !itemEditACINVERTER.isEmpty()) {
                                    stmt.setInt(14, Integer.parseInt(itemEditACINVERTER));
                                } else {
                                    stmt.setNull(14, java.sql.Types.INTEGER);
                                }
                            } else {
                                // Set all values to NULL if itemEditCat is not "1"
                                stmt.setNull(12, java.sql.Types.INTEGER);
                                stmt.setNull(13, java.sql.Types.INTEGER);
                                stmt.setNull(14, java.sql.Types.INTEGER);
                            }

                        if (itemEditCapacity != null && !itemEditCapacity.isEmpty()) {
                            stmt.setInt(15, Integer.parseInt(itemEditCapacity));
                        } else {
                            stmt.setNull(15, java.sql.Types.INTEGER);
                        }
                        stmt.setString(16, itemEditUnitMeasure);
                        if (itemEditEV != null && !itemEditEV.isEmpty()) {
                            stmt.setInt(17, Integer.parseInt(itemEditEV));
                        } else {
                            stmt.setNull(17, java.sql.Types.INTEGER);
                        }
                        if (itemEditEPH != null && !itemEditEPH.isEmpty()) {
                            stmt.setInt(18, Integer.parseInt(itemEditEPH));
                        } else {
                            stmt.setNull(18, java.sql.Types.INTEGER);
                        }
                        if (itemEditEHZ != null && !itemEditEHZ.isEmpty()) {
                            stmt.setInt(19, Integer.parseInt(itemEditEHZ));
                        } else {
                            stmt.setNull(19, java.sql.Types.INTEGER);
                        }

                    
                    stmt.setInt(20, Integer.parseInt(itemEID));
                }else if(maintStatID != null && !maintStatID.isEmpty()){
                    stmt.setInt(1, Integer.parseInt(maintStatus));
                    stmt.setInt(2, Integer.parseInt(maintStatID));
                } else if(itemAID != null && !itemAID.isEmpty()){
                    stmt.setInt(1, Integer.parseInt(itemAID));
                }else{
                    stmt.setInt(1, Integer.parseInt(itemType));
                    stmt.setString(2, itemName);
                    stmt.setInt(3, Integer.parseInt(itemBuilding));
                    stmt.setString(4, locText);
                    stmt.setString(5, itemFloor);
                    if ("Non-Room Equipment".equals(itemRoom)) {
                        stmt.setNull(6, java.sql.Types.VARCHAR);
                    } else {
                        stmt.setString(6, itemRoom);
                    }
                    stmt.setDate(7, sqlDate);
                    stmt.setString(8, itemBrand);
                    stmt.setDate(9, sqlExpire);
                    stmt.setString(10, remarks);
                        if (itemPCC != null && !itemPCC.isEmpty()) {
                            stmt.setInt(11, Integer.parseInt(itemPCC));
                        } else {
                            stmt.setNull(11, java.sql.Types.INTEGER);
                        }
                        if (itemACCU != null && !itemACCU.isEmpty()) {
                            stmt.setInt(12, Integer.parseInt(itemACCU));
                        } else {
                            stmt.setNull(12, java.sql.Types.INTEGER);
                        }
                        if (itemFCU != null && !itemFCU.isEmpty()) {
                            stmt.setInt(13, Integer.parseInt(itemFCU));
                        } else {
                            stmt.setNull(13, java.sql.Types.INTEGER);
                        }
                        if (itemACINVERTER != null && !itemACINVERTER.isEmpty()) {
                            stmt.setInt(14, Integer.parseInt(itemACINVERTER));
                        } else {
                            stmt.setNull(14, java.sql.Types.INTEGER);
                        }
                        if (itemCapacity != null && !itemCapacity.isEmpty()) {
                            stmt.setInt(15, Integer.parseInt(itemCapacity));
                        } else {
                            stmt.setNull(15, java.sql.Types.INTEGER);
                        }
                        stmt.setString(16, itemUnitMeasure);
                        if (itemEV != null && !itemEV.isEmpty()) {
                            stmt.setInt(17, Integer.parseInt(itemEV));
                        } else {
                            stmt.setNull(17, java.sql.Types.INTEGER);
                        }
                        if (itemEPH != null && !itemEPH.isEmpty()) {
                            stmt.setInt(18, Integer.parseInt(itemEPH));
                        } else {
                            stmt.setNull(18, java.sql.Types.INTEGER);
                        }
                        if (itemEHZ != null && !itemEHZ.isEmpty()) {
                            stmt.setInt(19, Integer.parseInt(itemEHZ));
                        } else {
                            stmt.setNull(19, java.sql.Types.INTEGER);
                        }

                }

                
                stmt.executeUpdate();
            }
            
            // Check conditions for FMO_ITEM_REPAIRS
                if ("3".equals(oldMaintStat) && "1".equals(maintStatus)) {
                    String currentMonth = String.valueOf(java.time.LocalDate.now().getMonthValue());
                    String currentYear = String.valueOf(java.time.LocalDate.now().getYear());

                    // Check if an entry for the current month and year exists
                    String selectRepairsSql = "SELECT NUM_OF_REPAIRS FROM FMO_ADM.FMO_ITEM_REPAIRS WHERE REPAIR_MONTH = ? AND REPAIR_YEAR = ? AND ITEM_LOC_ID = ?";
                    try (PreparedStatement selectStmt = conn.prepareStatement(selectRepairsSql)) {
                        selectStmt.setInt(1, Integer.parseInt(currentMonth));
                        selectStmt.setInt(2, Integer.parseInt(currentYear));
                        selectStmt.setInt(3, Integer.parseInt(loc));
                        try (ResultSet rs = selectStmt.executeQuery()) {
                            if (rs.next()) {
                                // Update NUM_OF_REPAIRS if entry exists
                                int repairCount = rs.getInt("NUM_OF_REPAIRS");
                                String updateRepairsSql = "UPDATE FMO_ADM.FMO_ITEM_REPAIRS SET NUM_OF_REPAIRS = ? WHERE REPAIR_MONTH = ? AND REPAIR_YEAR = ? AND ITEM_LOC_ID = ?";
                                try (PreparedStatement updateStmt = conn.prepareStatement(updateRepairsSql)) {
                                    updateStmt.setInt(1, repairCount + 1);
                                    updateStmt.setInt(2, Integer.parseInt(currentMonth));
                                    updateStmt.setInt(3, Integer.parseInt(currentYear));
                                    updateStmt.setInt(4, Integer.parseInt(loc));
                                    updateStmt.executeUpdate();
                                }
                            } else {
                                // Insert a new row if no entry exists
                                String insertRepairsSql = "INSERT INTO FMO_ADM.FMO_ITEM_REPAIRS (REPAIR_MONTH, REPAIR_YEAR, NUM_OF_REPAIRS, ITEM_LOC_ID) VALUES (?, ?, ?, ?)";
                                try (PreparedStatement insertStmt = conn.prepareStatement(insertRepairsSql)) {
                                    insertStmt.setInt(1, Integer.parseInt(currentMonth));
                                    insertStmt.setInt(2, Integer.parseInt(currentYear));
                                    insertStmt.setInt(3, 1);
                                    insertStmt.setInt(4, Integer.parseInt(loc));
                                    insertStmt.executeUpdate();
                                }
                            }
                        }
                    }
                }

            // Redirect to homepage after processing
            response.sendRedirect("buildingDashboard?locID=" + loc + "/manage?floor=" + flr);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding/editing/archiving item.");
        }

            
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                          IOException {
    }
}
