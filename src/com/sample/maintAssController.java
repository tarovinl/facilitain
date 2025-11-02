package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sample.model.Item;
import sample.model.ItemUser;
import sample.model.Location;
import sample.model.Maintenance;
import sample.model.PooledConnection;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 *  Handles ONLY data fetching for maintenance page
 * All POST operations (add, edit, delete, update) remain in their existing controllers:
 */
@WebServlet(name = "maintAssController", urlPatterns = {"/maintenancePage"})
public class maintAssController extends HttpServlet {

    private static final String CONTENT_TYPE = "text/html; charset=UTF-8";

    /**
     * Handles GET requests only - fetching data for display
     * POST requests go to their respective controllers unchanged
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String ajaxAction = request.getParameter("ajax");
        
        // Handle AJAX requests for DataTables server-side processing
            if ("equipmentTable".equals(ajaxAction)) {
                   handleEquipmentTableAjax(request, response);
                   return;
               } else if ("scheduledTable".equals(ajaxAction)) {
                   handleScheduledTableAjax(request, response);
                   return;
               } else if ("equipmentList".equals(ajaxAction)) {  
                   handleEquipmentListAjax(request, response);   
                   return;                                       
               }                                                 

               // Load initial page data (minimal - just dropdowns and constants)
               loadInitialPageData(request, response);
            }

    /**
     * Handles AJAX request for equipment list (for autocomplete)
     */
    private void handleEquipmentListAjax(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        List<String> equipmentList = new ArrayList<>();
        
        try (Connection con = PooledConnection.getConnection()) {
            String sql = "SELECT i.NAME FROM C##FMO_ADM.FMO_ITEMS i " +
                        "WHERE i.ITEM_STAT_ID = 1 " +
                        "AND i.MAINTENANCE_STATUS != 1 " +
                        "AND NOT EXISTS (" +
                        "  SELECT 1 FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                        "  WHERE ma.ITEM_ID = i.ITEM_ID AND ma.IS_COMPLETED = 0" +
                        ") ORDER BY i.NAME";
            
            try (PreparedStatement stmt = con.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    equipmentList.add(rs.getString("NAME"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Return error response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"Database error\", \"equipmentList\": []}");
            return;
        }
        
        // Build JSON response using Gson
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.add("equipmentList", gson.toJsonTree(equipmentList));
        
        // Set response headers BEFORE writing content
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Loads only the data needed for initial page render
     * Tables are loaded via AJAX for better performance
     */
    private void loadInitialPageData(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Location> locations = new ArrayList<>();
        List<Item> itemTypes = new ArrayList<>();
        List<Item> categories = new ArrayList<>();
        List<Item> maintStats = new ArrayList<>();
        List<Maintenance> maintTypes = new ArrayList<>();
        List<ItemUser> users = new ArrayList<>();
        String equipmentListString = "";

        try (Connection con = PooledConnection.getConnection()) {
            
            // Load locations (for dropdowns and location info)
            String locSql = "SELECT ITEM_LOC_ID, NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS ORDER BY UPPER(NAME)";
            try (PreparedStatement stmt = con.prepareStatement(locSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Location loc = new Location();
                    loc.setItemLocId(rs.getInt("ITEM_LOC_ID"));
                    loc.setLocName(rs.getString("NAME"));
                    locations.add(loc);
                }
            }

            // Load item types (for category/type mapping)
            String typesSql = "SELECT ITEM_TYPE_ID, ITEM_CAT_ID, NAME FROM C##FMO_ADM.FMO_ITEM_TYPES ORDER BY NAME";
            try (PreparedStatement stmt = con.prepareStatement(typesSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item type = new Item();
                    type.setItemTID(rs.getInt("ITEM_TYPE_ID"));
                    type.setItemCID(rs.getInt("ITEM_CAT_ID"));
                    type.setItemType(rs.getString("NAME"));
                    itemTypes.add(type);
                }
            }

            // Load categories (for display)
            String catsSql = "SELECT ITEM_CAT_ID, NAME FROM C##FMO_ADM.FMO_ITEM_CATEGORIES ORDER BY NAME";
            try (PreparedStatement stmt = con.prepareStatement(catsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item cat = new Item();
                    cat.setItemCID(rs.getInt("ITEM_CAT_ID"));
                    cat.setItemCat(rs.getString("NAME"));
                    categories.add(cat);
                }
            }

            // Load maintenance statuses (for status dropdown)
            String statsSql = "SELECT STATUS_ID, STATUS_NAME FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_STATUS ORDER BY STATUS_ID";
            try (PreparedStatement stmt = con.prepareStatement(statsSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item stat = new Item();
                    stat.setItemMaintStat(rs.getInt("STATUS_ID"));
                    stat.setMaintStatName(rs.getString("STATUS_NAME"));
                    maintStats.add(stat);
                }
            }

            // Load maintenance types (for maintenance type dropdown)
            String maintTypesSql = "SELECT MAIN_TYPE_ID, NAME FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES";
            try (PreparedStatement stmt = con.prepareStatement(maintTypesSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Maintenance mType = new Maintenance();
                    mType.setItemTypeId(rs.getInt("MAIN_TYPE_ID"));
                    mType.setItemTypeName(rs.getString("NAME"));
                    maintTypes.add(mType);
                }
            }

            // Load users (for assign dropdown - non-Respondents only)
            String usersSql = "SELECT USER_ID, NAME, EMAIL, ROLE FROM C##FMO_ADM.FMO_ITEM_DUSERS WHERE ROLE != 'Respondent' ORDER BY USER_ID";
            try (PreparedStatement stmt = con.prepareStatement(usersSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ItemUser user = new ItemUser();
                    user.setUserId(rs.getInt("USER_ID"));
                    user.setName(rs.getString("NAME"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setRole(rs.getString("ROLE"));
                    users.add(user);
                }
            }

            // Build equipment list string for autocomplete (only unassigned items)
            StringBuilder equipBuilder = new StringBuilder();
            String equipSql = "SELECT i.NAME FROM C##FMO_ADM.FMO_ITEMS i " +
                            "WHERE i.ITEM_STAT_ID = 1 " +
                            "AND i.MAINTENANCE_STATUS != 1 " +
                            "AND NOT EXISTS (" +
                            "  SELECT 1 FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                            "  WHERE ma.ITEM_ID = i.ITEM_ID AND ma.IS_COMPLETED = 0" +
                            ") ORDER BY i.NAME";
            try (PreparedStatement stmt = con.prepareStatement(equipSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    if (equipBuilder.length() > 0) {
                        equipBuilder.append(", ");
                    }
                    equipBuilder.append(rs.getString("NAME"));
                }
            }
            equipmentListString = equipBuilder.toString();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while loading page data", e);
        }

        // Set attributes for JSP
        request.setAttribute("locations", locations);
        request.setAttribute("FMO_TYPES_LIST", itemTypes);
        request.setAttribute("FMO_CATEGORIES_LIST", categories);
        request.setAttribute("FMO_MAINTSTAT_LIST", maintStats);
        request.setAttribute("FMO_MAINTTYPE_LIST", maintTypes);
        request.setAttribute("FMO_USERS", users);
        request.setAttribute("equipmentListString", equipmentListString);

        // Forward to JSP
        request.getRequestDispatcher("/pending.jsp").forward(request, response);
    }

    /**
     * Handles AJAX request for equipment table with server-side pagination
     */
    private void handleEquipmentTableAjax(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        String userEmail = (String) session.getAttribute("email");
        String userName = (String) session.getAttribute("name");

        // DataTables parameters
        int draw = Integer.parseInt(request.getParameter("draw"));
        int start = Integer.parseInt(request.getParameter("start"));
        int length = Integer.parseInt(request.getParameter("length"));
        String searchValue = request.getParameter("search[value]");
        
        List<Map<String, Object>> data = new ArrayList<>();
        int recordsTotal = 0;
        int recordsFiltered = 0;

        try (Connection con = PooledConnection.getConnection()) {
            
            // Count total records 
            String countSql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEMS " +
                              "WHERE ITEM_STAT_ID = 1 AND MAINTENANCE_STATUS != 1";
            try (PreparedStatement stmt = con.prepareStatement(countSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    recordsTotal = rs.getInt(1);
                }
            }

            // Build main query with pagination
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT * FROM (")
            .append("  SELECT i.ITEM_ID, i.NAME, i.BRAND_NAME, i.FLOOR_NO, i.LOCATION_ID, i.MAINTENANCE_STATUS, i.PLANNED_MAINTENANCE_DATE, ")
               .append("    t.NAME AS TYPE_NAME, t.ITEM_CAT_ID, ")
               .append("    c.NAME AS CAT_NAME, ")
               .append("    l.NAME AS LOC_NAME, ")
               .append("    s.STATUS_NAME, ")
               .append("    ROW_NUMBER() OVER (ORDER BY i.PLANNED_MAINTENANCE_DATE DESC NULLS LAST, i.ITEM_ID ASC) AS rn ")
               .append("  FROM C##FMO_ADM.FMO_ITEMS i ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON i.ITEM_TYPE_ID = t.ITEM_TYPE_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES c ON t.ITEM_CAT_ID = c.ITEM_CAT_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON i.LOCATION_ID = l.ITEM_LOC_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_STATUS s ON i.MAINTENANCE_STATUS = s.STATUS_ID ")
               .append("  WHERE i.ITEM_STAT_ID = 1 AND i.MAINTENANCE_STATUS != 1");

            // Add search filter if provided
            if (searchValue != null && !searchValue.isEmpty()) {
                sql.append(" AND (")
                   .append("    UPPER(i.NAME) LIKE ? OR ")
                   .append("    UPPER(t.NAME) LIKE ? OR ")
                   .append("    UPPER(c.NAME) LIKE ? OR ")
                   .append("    UPPER(i.BRAND_NAME) LIKE ? OR ")
                   .append("    UPPER(l.NAME) LIKE ? OR ")
                   .append("    UPPER(s.STATUS_NAME) LIKE ?")
                   .append("  )");
            }

            sql.append(") WHERE rn > ? AND rn <= ?");

            try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                
                // Set search parameters
                if (searchValue != null && !searchValue.isEmpty()) {
                    String searchPattern = "%" + searchValue.toUpperCase() + "%";
                    for (int i = 0; i < 6; i++) {
                        stmt.setString(paramIndex++, searchPattern);
                    }
                }
                
                // Set pagination parameters
                stmt.setInt(paramIndex++, start);
                stmt.setInt(paramIndex, start + length);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        
                        int itemId = rs.getInt("ITEM_ID");
                        String itemName = rs.getString("NAME");
                        String catName = rs.getString("CAT_NAME");
                        String typeName = rs.getString("TYPE_NAME");
                        String brandName = rs.getString("BRAND_NAME");
                        String locName = rs.getString("LOC_NAME");
                        String floorNo = rs.getString("FLOOR_NO");
                        String statName = rs.getString("STATUS_NAME");
                        int statId = rs.getInt("MAINTENANCE_STATUS");
                        int locId = rs.getInt("LOCATION_ID");
                        String plannedDate = rs.getString("PLANNED_MAINTENANCE_DATE");

                        // Check if current user can update this item
                        boolean canUpdate = checkUserCanUpdate(con, itemId, userEmail, userName);

                        row.put("itemID", itemId);
                        row.put("itemName", itemName);
                        row.put("equipment", catName + " - " + typeName);
                        row.put("brand", brandName != null ? brandName : "");
                        row.put("location", locName + ", " + floorNo);
                        row.put("status", statName);
                        row.put("statusId", statId);
                        row.put("locId", locId);
                        row.put("plannedDate", plannedDate != null ? plannedDate : "");
                        row.put("canUpdate", canUpdate);

                        data.add(row);
                    }
                }
            }

            // Count filtered records if search was applied
            if (searchValue != null && !searchValue.isEmpty()) {
                StringBuilder countFilteredSql = new StringBuilder();
                countFilteredSql.append("SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEMS i ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON i.ITEM_TYPE_ID = t.ITEM_TYPE_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES c ON t.ITEM_CAT_ID = c.ITEM_CAT_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON i.LOCATION_ID = l.ITEM_LOC_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_STATUS s ON i.MAINTENANCE_STATUS = s.STATUS_ID ")
                               .append("WHERE i.ITEM_STAT_ID = 1 AND i.MAINTENANCE_STATUS != 1 AND (")
                               .append("  UPPER(i.NAME) LIKE ? OR ")
                               .append("  UPPER(t.NAME) LIKE ? OR ")
                               .append("  UPPER(c.NAME) LIKE ? OR ")
                               .append("  UPPER(i.BRAND_NAME) LIKE ? OR ")
                               .append("  UPPER(l.NAME) LIKE ? OR ")
                               .append("  UPPER(s.STATUS_NAME) LIKE ?")
                               .append(")");

                try (PreparedStatement stmt = con.prepareStatement(countFilteredSql.toString())) {
                    String searchPattern = "%" + searchValue.toUpperCase() + "%";
                    for (int i = 1; i <= 6; i++) {
                        stmt.setString(i, searchPattern);
                    }
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            recordsFiltered = rs.getInt(1);
                        }
                    }
                }
            } else {
                recordsFiltered = recordsTotal;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Build DataTables JSON response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("draw", draw);
        jsonResponse.addProperty("recordsTotal", recordsTotal);
        jsonResponse.addProperty("recordsFiltered", recordsFiltered);
        jsonResponse.add("data", new Gson().toJsonTree(data));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }

    /**
     * Handles AJAX request for scheduled maintenance table with server-side pagination
     */
    private void handleScheduledTableAjax(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        String currentUserEmail = (String) session.getAttribute("email");
        
        int draw = Integer.parseInt(request.getParameter("draw"));
        int start = Integer.parseInt(request.getParameter("start"));
        int length = Integer.parseInt(request.getParameter("length"));
        String searchValue = request.getParameter("search[value]");
        
        List<Map<String, Object>> data = new ArrayList<>();
        int recordsTotal = 0;
        int recordsFiltered = 0;

        try (Connection con = PooledConnection.getConnection()) {
            
            // Count total incomplete assignments
            String countSql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                              "JOIN C##FMO_ADM.FMO_ITEMS i ON ma.ITEM_ID = i.ITEM_ID " +
                              "WHERE i.ITEM_STAT_ID = 1 AND ma.IS_COMPLETED = 0";
            try (PreparedStatement stmt = con.prepareStatement(countSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    recordsTotal = rs.getInt(1);
                }
            }

            // Main query with pagination
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT * FROM (")
            .append("  SELECT ma.ASSIGN_ID, ma.ITEM_ID, ma.USER_ID, ma.MAIN_TYPE_ID, ma.DATE_OF_MAINTENANCE, ")
               .append("    i.NAME AS ITEM_NAME, i.BRAND_NAME, i.FLOOR_NO, i.LOCATION_ID, i.MAINTENANCE_STATUS, ")
               .append("    t.NAME AS TYPE_NAME, t.ITEM_CAT_ID, ")
               .append("    c.NAME AS CAT_NAME, ")
               .append("    l.NAME AS LOC_NAME, ")
               .append("    mt.NAME AS MAINT_TYPE_NAME, ")
               .append("    u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, ")
               .append("    ROW_NUMBER() OVER (ORDER BY ma.DATE_OF_MAINTENANCE DESC NULLS LAST, ma.ASSIGN_ID ASC) AS rn ")
               .append("  FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma ")
               .append("  JOIN C##FMO_ADM.FMO_ITEMS i ON ma.ITEM_ID = i.ITEM_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON i.ITEM_TYPE_ID = t.ITEM_TYPE_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES c ON t.ITEM_CAT_ID = c.ITEM_CAT_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS l ON i.LOCATION_ID = l.ITEM_LOC_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES mt ON ma.MAIN_TYPE_ID = mt.MAIN_TYPE_ID ")
               .append("  JOIN C##FMO_ADM.FMO_ITEM_DUSERS u ON ma.USER_ID = u.USER_ID ")
               .append("  WHERE i.ITEM_STAT_ID = 1 AND ma.IS_COMPLETED = 0");

            if (searchValue != null && !searchValue.isEmpty()) {
                sql.append(" AND (")
                   .append("    UPPER(i.NAME) LIKE ? OR ")
                   .append("    UPPER(t.NAME) LIKE ? OR ")
                   .append("    UPPER(c.NAME) LIKE ? OR ")
                   .append("    UPPER(mt.NAME) LIKE ? OR ")
                   .append("    UPPER(u.NAME) LIKE ?")
                   .append("  )");
            }

            sql.append(") WHERE rn > ? AND rn <= ?");

            try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                
                if (searchValue != null && !searchValue.isEmpty()) {
                    String searchPattern = "%" + searchValue.toUpperCase() + "%";
                    for (int i = 0; i < 5; i++) {
                        stmt.setString(paramIndex++, searchPattern);
                    }
                }
                
                stmt.setInt(paramIndex++, start);
                stmt.setInt(paramIndex, start + length);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        
                        String userEmail = rs.getString("USER_EMAIL");
                        boolean isCurrentUser = currentUserEmail != null && currentUserEmail.equals(userEmail);
                        
                        String catName = rs.getString("CAT_NAME");
                        String typeName = rs.getString("TYPE_NAME");
                        
                        row.put("assignID", rs.getInt("ASSIGN_ID"));
                        row.put("itemID", rs.getInt("ITEM_ID"));
                        row.put("itemName", rs.getString("ITEM_NAME"));
                        row.put("maintTypeName", rs.getString("MAINT_TYPE_NAME"));
                        row.put("maintTypeID", rs.getInt("MAIN_TYPE_ID"));
                        row.put("userName", rs.getString("USER_NAME"));
                        row.put("userID", rs.getInt("USER_ID"));
                        row.put("userEmail", userEmail);
                        row.put("isCurrentUser", isCurrentUser);
                        row.put("dateOfMaint", rs.getString("DATE_OF_MAINTENANCE"));
                        row.put("locId", rs.getInt("LOCATION_ID"));
                        row.put("maintStatus", rs.getInt("MAINTENANCE_STATUS"));
                        
                        row.put("equipment", catName + " - " + typeName);

                        data.add(row);
                    }
                }
            }

            // Count filtered records
            if (searchValue != null && !searchValue.isEmpty()) {
                StringBuilder countFilteredSql = new StringBuilder();
                countFilteredSql.append("SELECT COUNT(*) FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma ")
                               .append("JOIN C##FMO_ADM.FMO_ITEMS i ON ma.ITEM_ID = i.ITEM_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_TYPES t ON i.ITEM_TYPE_ID = t.ITEM_TYPE_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES c ON t.ITEM_CAT_ID = c.ITEM_CAT_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES mt ON ma.MAIN_TYPE_ID = mt.MAIN_TYPE_ID ")
                               .append("JOIN C##FMO_ADM.FMO_ITEM_DUSERS u ON ma.USER_ID = u.USER_ID ")
                               .append("WHERE i.ITEM_STAT_ID = 1 AND ma.IS_COMPLETED = 0 AND (")
                               .append("  UPPER(i.NAME) LIKE ? OR ")
                               .append("  UPPER(t.NAME) LIKE ? OR ")
                               .append("  UPPER(c.NAME) LIKE ? OR ")
                               .append("  UPPER(mt.NAME) LIKE ? OR ")
                               .append("  UPPER(u.NAME) LIKE ?")
                               .append(")");

                try (PreparedStatement stmt = con.prepareStatement(countFilteredSql.toString())) {
                    String searchPattern = "%" + searchValue.toUpperCase() + "%";
                    for (int i = 1; i <= 5; i++) {
                        stmt.setString(i, searchPattern);
                    }
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            recordsFiltered = rs.getInt(1);
                        }
                    }
                }
            } else {
                recordsFiltered = recordsTotal;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("draw", draw);
        jsonResponse.addProperty("recordsTotal", recordsTotal);
        jsonResponse.addProperty("recordsFiltered", recordsFiltered);
        jsonResponse.add("data", new Gson().toJsonTree(data));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }

    /**
     * Checks if the current user is assigned to maintain this item
     */
    private boolean checkUserCanUpdate(Connection con, int itemId, String userEmail, String userName) 
            throws SQLException {
        String sql = "SELECT 1 FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                    "JOIN C##FMO_ADM.FMO_ITEM_DUSERS u ON ma.USER_ID = u.USER_ID " +
                    "WHERE ma.ITEM_ID = ? AND ma.IS_COMPLETED = 0 " +
                    "AND u.EMAIL = ? AND u.NAME = ?";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            stmt.setString(2, userEmail);
            stmt.setString(3, userName);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}