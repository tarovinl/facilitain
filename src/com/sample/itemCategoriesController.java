package com.sample;

import sample.model.PooledConnection;
import sample.model.ItemCategory;

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

@WebServlet("/itemCategories")
public class itemCategoriesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = PooledConnection.getConnection()) {
            String query = "SELECT ITEM_CAT_ID, NAME, DESCRIPTION, ARCHIVED_FLAG FROM FMO_ADM.FMO_ITEM_CATEGORIES";
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                List<ItemCategory> categoryList = new ArrayList<>();
                while (rs.next()) {
                    ItemCategory category = new ItemCategory();
                    category.setItemCID(rs.getInt("ITEM_CAT_ID"));
                    category.setCategoryName(rs.getString("NAME"));
                    category.setDescription(rs.getString("DESCRIPTION"));
                    category.setArchivedFlag(rs.getInt("ARCHIVED_FLAG"));
                    categoryList.add(category);
                }
                request.setAttribute("categoryList", categoryList);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching item categories.", e);
        }

        request.getRequestDispatcher("itemCategories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemCIDParam = request.getParameter("itemCID");
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String action = request.getParameter("action");
        String editMode = request.getParameter("editMode");
        String redirectParams = "";

        Integer itemCID = (itemCIDParam != null && !itemCIDParam.isEmpty()) ? Integer.parseInt(itemCIDParam) : null;

        try (Connection conn = PooledConnection.getConnection()) {
            if ("archive".equals(action) && itemCID != null) {
                // Check if category is in use before archiving
                if (isCategoryInUse(conn, itemCID)) {
                    redirectParams = "?error=inuse";
                } else {
                    String archiveSql = "UPDATE FMO_ADM.FMO_ITEM_CATEGORIES SET ARCHIVED_FLAG = 2 WHERE ITEM_CAT_ID = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(archiveSql)) {
                        stmt.setInt(1, itemCID);
                        stmt.executeUpdate();
                    }
                    redirectParams = "?action=archived";
                }
            } else if ("true".equals(editMode) && itemCID != null) {
                // Check for duplicate category name (excluding current category)
                if (isDuplicateCategoryName(conn, categoryName, itemCID)) {
                    redirectParams = "?error=duplicate";
                } else {
                    String updateSql = "UPDATE FMO_ADM.FMO_ITEM_CATEGORIES SET NAME = ?, DESCRIPTION = ? WHERE ITEM_CAT_ID = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                        stmt.setString(1, categoryName);
                        stmt.setString(2, description);
                        stmt.setInt(3, itemCID);
                        stmt.executeUpdate();
                    }
                    redirectParams = "?action=updated";
                }
            } else if (itemCID == null) {
                // Check for duplicate category name for new entries
                if (isDuplicateCategoryName(conn, categoryName, null)) {
                    redirectParams = "?error=duplicate";
                } else {
                    String insertSql = "INSERT INTO FMO_ADM.FMO_ITEM_CATEGORIES (ITEM_CAT_ID, NAME, DESCRIPTION) VALUES (FMO_ADM.FMO_ITEM_CAT_ID_SEQ.NEXTVAL, ?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                        stmt.setString(1, categoryName);
                        stmt.setString(2, description);
                        stmt.executeUpdate();
                    }
                    redirectParams = "?action=added";
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
        }

        response.sendRedirect(request.getContextPath() + "/itemCategories" + redirectParams);
    }

    /**
     * Checks if a category is currently being used by any items
     * @param conn Database connection
     * @param itemCID Category ID to check
     * @return true if category is in use, false otherwise
     */
    private boolean isCategoryInUse(Connection conn, Integer itemCID) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEMS WHERE ITEM_TYPE_ID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, itemCID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Checks if a category name already exists for active categories (ARCHIVED_FLAG = 1)
     * @param conn Database connection
     * @param categoryName Name to check
     * @param excludeItemCID ID to exclude from check (for updates), null for new entries
     * @return true if duplicate exists, false otherwise
     */
    private boolean isDuplicateCategoryName(Connection conn, String categoryName, Integer excludeItemCID) throws SQLException {
        String checkSql;
        if (excludeItemCID != null) {
            // For updates: check if name exists in other active categories
            checkSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_CATEGORIES WHERE UPPER(NAME) = UPPER(?) AND ARCHIVED_FLAG = 1 AND ITEM_CAT_ID != ?";
        } else {
            // For new entries: check if name exists in any active category
            checkSql = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_CATEGORIES WHERE UPPER(NAME) = UPPER(?) AND ARCHIVED_FLAG = 1";
        }

        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setString(1, categoryName.trim());
            if (excludeItemCID != null) {
                stmt.setInt(2, excludeItemCID);
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