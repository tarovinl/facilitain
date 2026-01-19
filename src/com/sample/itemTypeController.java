package com.sample;

import sample.model.ItemType;
import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.AbstractMap;

@WebServlet("/itemType")
public class itemTypeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ItemType> itemTypeList = new ArrayList<>();
        List<Map.Entry<Integer, String>> categoryList = new ArrayList<>();

        String itemTypeQuery = "SELECT ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION, ARCHIVED_FLAG FROM FMO_ADM.FMO_ITEM_TYPES";
        String categoryQuery = "SELECT ITEM_CAT_ID, NAME FROM FMO_ADM.FMO_ITEM_CATEGORIES WHERE ARCHIVED_FLAG = 1";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement itemTypeStatement = connection.prepareStatement(itemTypeQuery);
             PreparedStatement categoryStatement = connection.prepareStatement(categoryQuery)) {

            // Fetch item types
            try (ResultSet itemTypeResult = itemTypeStatement.executeQuery()) {
                while (itemTypeResult.next()) {
                    ItemType itemType = new ItemType();
                    itemType.setItemTypeId(itemTypeResult.getInt("ITEM_TYPE_ID"));
                    itemType.setItemCatId(itemTypeResult.getInt("ITEM_CAT_ID"));
                    itemType.setName(itemTypeResult.getString("NAME"));
                    itemType.setDescription(itemTypeResult.getString("DESCRIPTION"));
                    itemType.setArchivedFlag(itemTypeResult.getInt("ARCHIVED_FLAG"));
                    itemTypeList.add(itemType);
                }
            }

            // Fetch categories
            try (ResultSet categoryResult = categoryStatement.executeQuery()) {
                while (categoryResult.next()) {
                    int itemCatId = categoryResult.getInt("ITEM_CAT_ID");
                    String name = categoryResult.getString("NAME");
                    categoryList.add(new AbstractMap.SimpleEntry<>(itemCatId, name));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("itemTypeList", itemTypeList);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/itemType.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String redirectParams = "";

        try (Connection connection = PooledConnection.getConnection()) {
            if ("archive".equals(action)) {
                int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
                
                // Check if item type is in use before archiving
                if (isItemTypeInUse(connection, itemTypeId)) {
                    redirectParams = "?error=inuse";
                } else {
                    String query = "UPDATE C##FMO_ADM.FMO_ITEM_TYPES SET ARCHIVED_FLAG = 2 WHERE ITEM_TYPE_ID = ?";
                    try (PreparedStatement statement = connection.prepareStatement(query)) {
                        statement.setInt(1, itemTypeId);
                        statement.executeUpdate();
                    }
                    redirectParams = "?action=archived";
                }
            } else {
                // Handle add/edit logic
                String editMode = request.getParameter("editMode");
                int itemCatId = Integer.parseInt(request.getParameter("itemCatId"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");

                if ("true".equals(editMode)) {
                    int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
                    
                    // Check for duplicate item type name (excluding current item type)
                    if (isDuplicateItemTypeName(connection, itemCatId, name, itemTypeId)) {
                        redirectParams = "?error=duplicate";
                    } else {
                        String updateQuery = "UPDATE FMO_ADM.FMO_ITEM_TYPES SET ITEM_CAT_ID = ?, NAME = ?, DESCRIPTION = ? WHERE ITEM_TYPE_ID = ?";
                        try (PreparedStatement statement = connection.prepareStatement(updateQuery)) {
                            statement.setInt(1, itemCatId);
                            statement.setString(2, name);
                            statement.setString(3, description);
                            statement.setInt(4, itemTypeId);
                            statement.executeUpdate();
                        }
                        redirectParams = "?action=updated";
                    }
                } else {
                    // Check for duplicate item type name for new entries
                    if (isDuplicateItemTypeName(connection, itemCatId, name, null)) {
                        redirectParams = "?error=duplicate";
                    } else {
                        String insertQuery = "INSERT INTO FMO_ADM.FMO_ITEM_TYPES (ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION) VALUES (FMO_ADM.FMO_ITEM_TYP_ID_SEQ.NEXTVAL, ?, ?, ?)";
                        try (PreparedStatement statement = connection.prepareStatement(insertQuery)) {
                            statement.setInt(1, itemCatId);
                            statement.setString(2, name);
                            statement.setString(3, description);
                            statement.executeUpdate();
                        }
                        redirectParams = "?action=added";
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Check if it's a unique constraint violation
            // Oracle error code for unique constraint: 1 (ORA-00001)
            if (e.getErrorCode() == 1) {
                redirectParams = "?error=duplicate";
            } else {
                redirectParams = "?error=true";
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectParams = "?error=true";
        }

        response.sendRedirect("itemType" + redirectParams);
    }

    /**
     * Checks if an item type is currently being used by any items
     * @param conn Database connection
     * @param itemTypeId Item Type ID to check
     * @return true if item type is in use, false otherwise
     */
    private boolean isItemTypeInUse(Connection conn, Integer itemTypeId) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEMS WHERE ITEM_TYPE_ID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, itemTypeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Checks if an item type name already exists within the same category for active item types (ARCHIVED_FLAG = 1)
     * @param conn Database connection
     * @param itemCatId Category ID to check within
     * @param name Name to check
     * @param excludeItemTypeId ID to exclude from check (for updates), null for new entries
     * @return true if duplicate exists, false otherwise
     */
    private boolean isDuplicateItemTypeName(Connection conn, int itemCatId, String name, Integer excludeItemTypeId) throws SQLException {
        String checkSql;
        if (excludeItemTypeId != null) {
            // For updates: check if name exists in other active item types within the same category
            checkSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_TYPES WHERE UPPER(NAME) = UPPER(?) AND ITEM_CAT_ID = ? AND ARCHIVED_FLAG = 1 AND ITEM_TYPE_ID != ?";
        } else {
            // For new entries: check if name exists in any active item type within the same category
            checkSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_TYPES WHERE UPPER(NAME) = UPPER(?) AND ITEM_CAT_ID = ? AND ARCHIVED_FLAG = 1";
        }

        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setString(1, name.trim());
            stmt.setInt(2, itemCatId);
            if (excludeItemTypeId != null) {
                stmt.setInt(3, excludeItemTypeId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}