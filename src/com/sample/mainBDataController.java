package com.sample;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson;
import java.sql.*;
import java.util.*;

import java.util.Date;
import sample.model.PooledConnection;

@WebServlet(name = "mainBDataController", urlPatterns = { "/mainbdatacontroller" })
public class mainBDataController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);

    }

    @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            int start = Integer.parseInt(request.getParameter("start"));
            int length = Integer.parseInt(request.getParameter("length"));
            String searchValue = request.getParameter("search[value]");
            String draw = request.getParameter("draw");

            String locID = request.getParameter("locID");
            String floorName = request.getParameter("floorName");
            String userRole = request.getParameter("userRole");
            String userEmail = request.getParameter("userEmail");
            String sessionName = request.getParameter("sessionName");
//            System.out.println("Location ID: " + locID);
//            System.out.println("Floor Name: " + floorName);
//            System.out.println("User Role: " + userRole);
//            System.out.println("Session Name: " + sessionName);

            List<Map<String, Object>> data = new ArrayList<>();
            int recordsTotal = 0;
            int recordsFiltered = 0;

            try (Connection conn = PooledConnection.getConnection()) {
                // Count total
                String countSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEMS WHERE item_stat_id = 1 AND location_id = ? AND floor_no = ?";
                try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                    ps.setString(1, locID);
                    ps.setString(2, floorName);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        recordsTotal = rs.getInt(1);
                    }
                }
                System.out.println("Records Total: " + recordsTotal);
                
                // Build base query
                StringBuilder query = new StringBuilder();
                query.append("SELECT ")
                     .append("i.item_id, ")
                     .append("i.item_type_id, ")
                     .append("i.location_text, ")
                     .append("i.floor_no, ")
                     .append("i.quantity, ")
                     .append("i.capacity, ")
                     .append("i.name AS item_name, ")
                     .append("NVL(i.room_no, 'N/A') AS room_no, ")
                     .append("c.name AS category_name, ")
                     .append("c.item_cat_id, ")
                     .append("t.name AS type_name, ")
                     .append("NVL(i.brand_name, 'N/A') AS brand_name, ")
                     .append("i.date_installed, ")
                     .append("i.unit_of_measure, ")
                     .append("i.electrical_v, ")
                     .append("i.electrical_ph, ")
                     .append("i.electrical_hz, ")
                     .append("i.maintenance_status, ")
                     .append("i.ac_fcu, ")
                     .append("i.ac_accu, ")
                     .append("i.ac_inverter, ")
                     .append("i.expiry_date, ")
                     .append("i.parent_item_id, ")
                     .append("i.remarks, ")
                     .append("i.pc_code, ")
                     .append("i.planned_maintenance_date, ")
                     .append("i.last_maintenance_date, ")
                     .append("l.name AS location_name ")
                     .append("FROM FMO_ADM.FMO_ITEMS i ")
                     .append("JOIN FMO_ADM.FMO_ITEM_TYPES t ON t.item_type_id = i.item_type_id ")
                     .append("JOIN FMO_ADM.FMO_ITEM_CATEGORIES c ON c.item_cat_id = t.item_cat_id ")
                     .append("JOIN FMO_ADM.FMO_ITEM_LOCATIONS l ON l.item_loc_id = i.location_id ")
                     .append("WHERE i.item_stat_id = 1 ")
                     .append("AND i.location_id = ? ")
                     .append("AND i.floor_no = ? ");

                if (searchValue != null && !searchValue.isEmpty()) {
                    query.append("AND (LOWER(i.name) LIKE ? OR LOWER(c.name) LIKE ? OR LOWER(t.name) LIKE ?)");
                }
//                System.out.println("Query: " + query);
                // Pagination (Oracle)
                String paginatedQuery = "SELECT * FROM (SELECT a.*, ROWNUM rnum FROM (" +
                        query.toString() + " ORDER BY i.name) a WHERE ROWNUM <= ?) WHERE rnum > ?";

                try (PreparedStatement ps = conn.prepareStatement(paginatedQuery)) {
                    int paramIndex = 1;
                    ps.setString(paramIndex++, locID);
                    ps.setString(paramIndex++, floorName);
                    if (searchValue != null && !searchValue.isEmpty()) {
                        ps.setString(paramIndex++, "%" + searchValue.toLowerCase() + "%");
                        ps.setString(paramIndex++, "%" + searchValue.toLowerCase() + "%");
                        ps.setString(paramIndex++, "%" + searchValue.toLowerCase() + "%");
                    }
                    ps.setInt(paramIndex++, start + length);
                    ps.setInt(paramIndex, start);
//                                System.out.println("Start: " + start);
//                                System.out.println("Length: " + length);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        int itemId = rs.getInt("item_id");
                        String itemName = rs.getString("item_name");
                        String locText = rs.getString("location_text");
                        String locName = rs.getString("location_name");
                        int quantity = rs.getInt("quantity");
                        String itemFloor = rs.getString("floor_no");
                        String itemRoom = rs.getString("room_no");
                        int capacity = rs.getInt("capacity");
                        String category = rs.getString("category_name");
                        int catID = rs.getInt("item_cat_id");
                        String type = rs.getString("type_name");
                        int typeID = rs.getInt("item_type_id");
                        String itemBrand = rs.getString("brand_name");
                        Date dateInstalled = rs.getDate("date_installed");
                        Date dateExpiry = rs.getDate("expiry_date");
                        String remarks = rs.getString("remarks");
                        remarks = (remarks == null) ? "" : remarks;
                        int statusId = rs.getInt("maintenance_status");
                        int pcCode = rs.getInt("pc_code");
                        int acFCU = rs.getInt("ac_fcu");
                        int acACCU = rs.getInt("ac_accu");
                        int acInv = rs.getInt("ac_inverter");
                        String uoMeasure = rs.getString("unit_of_measure");
                        int elecV = rs.getInt("electrical_v");
                        int elecPH = rs.getInt("electrical_ph");
                        int elecHZ = rs.getInt("electrical_hz");
                        
                        System.out.println("Item ID: " + itemId);
                        System.out.println("Location ID: " + locID);
                        System.out.println("Item Name: " + itemName);
                        System.out.println("Item Room: " + itemRoom);
                        System.out.println("Category: " + category);
                        System.out.println("Type: " + type);
                        System.out.println("Item Brand: " + itemBrand);
                        System.out.println("Date Installed: " + dateInstalled);
                        System.out.println("Status ID: " + statusId);
                        System.out.println("----------------------------");

                        row.put("itemInfo", buildInfoModal(
                                                    itemId,
                                                    statusId,
                                                    locID,
                                                    floorName,
                                                    itemName,
                                                    locText,
                                                    quantity,
                                                    itemFloor,
                                                    itemRoom,
                                                    capacity,
                                                    category,
                                                    catID,
                                                    type,
                                                    typeID,
                                                    itemBrand,
                                                    dateInstalled,
                                                    dateExpiry,
                                                    remarks,
                                                    pcCode,
                                                    acFCU,
                                                    acACCU,
                                                    acInv,
                                                    uoMeasure,
                                                    elecV,
                                                    elecPH,
                                                    elecHZ,
                                                    locName
                                                   ));
                        row.put("itemID", itemId);
                        row.put("itemName", itemName);
                        row.put("itemRoom", itemRoom);
                        row.put("category", category);
                        row.put("type", type);
                        row.put("itemBrand", itemBrand);
                        row.put("dateInstalled", dateInstalled != null ? dateInstalled.toString() : "N/A");

                        // Quotation button
                        String quotationHtml = "<form id='quotForm' method='GET' action='quotations.jsp' style='display: none;'>" +
                                                    "<input type='hidden' name='displayQuotItemID' id='hiddenItemID'>" +
                                                "</form>" +
                                                "<input type='image' " +
                                                    "src='resources/images/quotationsIcon.svg' " +
                                                    "id='quotModalButton' " +
                                                    "alt='Open Quotation Modal' " +
                                                    "width='24' " +
                                                    "height='24' " +
                                                    "data-itemid='" + itemId + "' " +
                                                    "data-bs-toggle='modal' " +
                                                    "data-bs-target='#quotEquipmentModal' " +
                                                    "onclick='openQuotModal(this)'>";
                        row.put("quotation", quotationHtml);

                        // Status dropdown
                        row.put("status", buildStatusDropdown(
                            conn,
                            itemId,
                            statusId,
                            locID,
                            floorName
                        ));


                        // Actions dropdown (only for admin)
                        if ("Admin".equals(userRole)) {
                            row.put("actions", buildActionsDropdown(
                                                    itemId,
                                                    statusId,
                                                    locID,
                                                    floorName,
                                                    itemName,
                                                    locText,
                                                    quantity,
                                                    itemFloor,
                                                    itemRoom,
                                                    capacity,
                                                    category,
                                                    catID,
                                                    type,
                                                    typeID,
                                                    itemBrand,
                                                    dateInstalled,
                                                    dateExpiry,
                                                    remarks,
                                                    pcCode,
                                                    acFCU,
                                                    acACCU,
                                                    acInv,
                                                    uoMeasure,
                                                    elecV,
                                                    elecPH,
                                                    elecHZ
                                                   ));
                        }

                        data.add(row);
                    }
                }

                // Filtered count
                String countFilteredSql = "SELECT COUNT(*) FROM FMO_ITEMS i " +
                        "JOIN FMO_ITEM_TYPES t ON t.item_type_id = i.item_type_id " +
                        "JOIN FMO_ITEM_CATEGORIES c ON c.item_cat_id = t.item_cat_id " +
                        "WHERE i.item_stat_id = 1 AND i.location_id = ? AND i.floor_no = ?";
                try (PreparedStatement ps = conn.prepareStatement(countFilteredSql)) {
                    ps.setString(1, locID);
                    ps.setString(2, floorName);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        recordsFiltered = rs.getInt(1);
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }

            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("draw", draw);
            jsonResponse.put("recordsTotal", recordsTotal);
            jsonResponse.put("recordsFiltered", recordsFiltered);
            jsonResponse.put("data", data);

            String json = new Gson().toJson(jsonResponse);
            response.setContentType("application/json");
            response.getWriter().write(json);
        }

        private String buildStatusDropdown(
            Connection conn,
            int itemId,
            int selectedStatus,
            String locID,
            String floorName
        ) {
            StringBuilder sb = new StringBuilder();
            String sql = "SELECT status_id, status_name FROM FMO_ADM.fmo_item_maintenance_status ORDER BY status_id";
    
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
    
//                sb.append("<form action='itemcontroller' method='POST'>")
//                  .append("<input type='hidden' name='itemLID' value='").append(locID).append("'/>")
//                  .append("<input type='hidden' name='itemFlr' value='").append(floorName).append("'/>")
//                  .append("<input type='hidden' name='maintStatID' value='").append(itemId).append("'/>")
//                  .append("<select name='statusDropdown' class='statusDropdown' onchange='this.form.submit()'>");
                
                sb.append("<form action='itemcontroller' method='POST'>")
                      // always include locID and floorName
                      .append("<input type='hidden' name='itemLID' value='").append(locID).append("'/>")
                      .append("<input type='hidden' name='itemFlr' value='").append(floorName).append("'/>")
                      // current item ID
                      .append("<input type='hidden' name='maintStatID' value='").append(itemId).append("'/>")
                      // old maintenance status
                      .append("<input type='hidden' name='oldMaintStat' value='").append(selectedStatus).append("'/>")
                      // extra hidden field for type (if needed for submission)
                      .append("<input type='hidden' name='itemMaintType' value=''/>")
                      // dropdown
                      .append("<select name='statusDropdown' class='statusDropdown'>"); // removed onchange for now

                while (rs.next()) {
                    int statusId = rs.getInt("status_id");
                    String statusName = rs.getString("status_name");
    
                    sb.append("<option value='").append(statusId).append("'");

                        // mark selected
                        if (selectedStatus == statusId) {
                            sb.append(" selected");
                        }

                        // disable option 3 if selected status is 1
                        if (selectedStatus == 1 && statusId == 3) {
                            sb.append(" disabled");
                        }

                        sb.append(">")
                          .append(statusName)
                          .append("</option>");
                }
    
                sb.append("</select></form>");
    
            } catch (SQLException e) {
                e.printStackTrace(); // replace with proper logging
            }
    
            return sb.toString();
        }

        private String buildActionsDropdown(
            int itemId,
            int selectedStatus,
            String locID,
            String floorName,
            String itemName,
            String locText,
            int quantity,
            String itemFloor,
            String itemRoom,
            int capacity,
            String category,
            int catID,
            String type,
            int typeID,
            String itemBrand,
            Date dateInstalled,
            Date dateExpiry,
            String remarks,
            int pcCode,
            int acFCU,
            int acACCU,
            int acInv,
            String uoMeasure,
            int elecV,
            int elecPH,
            int elecHZ
        ) {
            return "<div class='dropdown'>" +
                   "<button class='btn btn-link p-0' type='button' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>" +
                   "<img src='resources/images/kebabMenu.svg' alt='Actions' width='20' height='20'>" +
                   "</button>" +
                   "<div class='dropdown-menu'>" +
                     "<a class='dropdown-item' href='#' " +
                         "data-toggle='modal' " +
                         "data-target='#editEquipment' " +
                         "data-itemid='" + itemId + "' " +
                         "data-itemname='" + itemName + "' " +
                         "data-itembrand='" + itemBrand + "' " +
                         "data-dateinst='" + dateInstalled + "' " +
                         "data-itemexpiry='" + dateExpiry + "' " +
                         "data-itemcat='" + catID + "' " +
                         "data-itemfloor='" + itemFloor + "' " +
                         "data-itemroom='" + itemRoom + "' " +
                         "data-itemtype='" + typeID + "' " +
                         "data-itemloctext='" + locText + "' " +
                         "data-itemremarks='" + remarks + "' " +
                         "data-itempcc='" + pcCode + "' " +
                         "data-accu='" + acACCU + "' " +
                         "data-fcu='" + acFCU + "' " +
                         "data-inverter='" + acInv + "' " +
                         "data-itemcapacity='" + capacity + "' " +
                         "data-itemmeasure='" + uoMeasure + "' " +
                         "data-itemev='" + elecV + "' " +
                         "data-itemeph='" + elecPH + "' " +
                         "data-itemehz='" + elecHZ + "' " +
                         "onclick='populateEditModal(this); floorERender(); setFloorSelection(this); toggleEAirconDiv(" + catID + ");'>" +
                         "Edit" +
                     "</a>" +
                     "<a class='dropdown-item history-btn' href='#' " +
                         "data-toggle='modal' " +
                         "data-target='#historyEquipment' " +
                         "data-itemhid='" + itemId + "'>" +
                         "History" +
                     "</a>" +
                     "<a class='dropdown-item archive-maintenance-btn' href='#' " +
                         "data-toggle='modal' " +
                         "data-itemaid='" + itemId + "' " +
                         "data-itemaname='" + itemName + "'>" +
                         "Archive" +
                     "</a>" +
                   "</div>" +
                 "</div>";

        }
        
        private String buildInfoModal(
            int itemId,
            int selectedStatus,
            String locID,
            String floorName,
            String itemName,
            String locText,
            int quantity,
            String itemFloor,
            String itemRoom,
            int capacity,
            String category,
            int catID,
            String type,
            int typeID,
            String itemBrand,
            Date dateInstalled,
            Date dateExpiry,
            String remarks,
            int pcCode,
            int acFCU,
            int acACCU,
            int acInv,
            String uoMeasure,
            int elecV,
            int elecPH,
            int elecHZ,
            String locName
        ) {
            return "<input type='image' " +
                                            "src='resources/images/itemInfo.svg' " +
                                            "id='infoModalButton' " +
                                            "alt='Open Info Modal' " +
                                            "width='24' height='24' " +
                                            "data-itemiid='" + itemId + "' " +
                         		    "data-iteminame='" + itemName + "' " +
                                            "data-itemilname='" + locName + "' " +
                         		    "data-itemibrand='" + itemBrand + "' " +
                         		    "data-dateiinst='" + dateInstalled + "' " +
                         		    "data-itemiexpiry='" + dateExpiry + "' " +
                         		    "data-itemicat='" + category + "' " +
                         		    "data-itemifloor='" + itemFloor + "' " +
                         		    "data-itemiroom='" + itemRoom + "' " +
                         		    "data-itemitype='" + type + "' " +
                         		    "data-itemiloctext='" + locText + "' " +
                         		    "data-itemiremarks='" + remarks + "' " +
                         		    "data-itemipcc='" + pcCode + "' " +
                         		    "data-iaccu='" + acACCU + "' " +
                         		    "data-ifcu='" + acFCU + "' " +
                         		    "data-iinverter='" + acInv + "' " +
                         		    "data-itemicapacity='" + capacity + "' " +
                         		    "data-itemimeasure='" + uoMeasure + "' " +
                         		    "data-itemiev='" + elecV + "' " +
                         		    "data-itemieph='" + elecPH + "' " +
                         		    "data-itemiehz='" + elecHZ + "' " +
                                            "data-bs-toggle='modal' " +
                                            "data-bs-target='#infoEquipment' " +
                                            "onclick='populateInfoModal(this)'> ";
    
        }
}