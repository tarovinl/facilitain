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

        Integer itemCID = (itemCIDParam != null && !itemCIDParam.isEmpty()) ? Integer.parseInt(itemCIDParam) : null;

        try (Connection conn = PooledConnection.getConnection()) {
            if ("archive".equals(action) && itemCID != null) {
                String archiveSql = "UPDATE FMO_ADM.FMO_ITEM_CATEGORIES SET ARCHIVED_FLAG = 2 WHERE ITEM_CAT_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(archiveSql)) {
                    stmt.setInt(1, itemCID);
                    stmt.executeUpdate();
                }
            } else if (itemCID != null && existsInDatabase(conn, itemCID)) {
                String updateSql = "UPDATE FMO_ADM.FMO_ITEM_CATEGORIES SET NAME = ?, DESCRIPTION = ? WHERE ITEM_CAT_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setString(1, categoryName);
                    stmt.setString(2, description);
                    stmt.setInt(3, itemCID);
                    stmt.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO FMO_ADM.FMO_ITEM_CATEGORIES (NAME, DESCRIPTION) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setString(1, categoryName);
                    stmt.setString(2, description);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while processing item categories.", e);
        }

        response.sendRedirect(request.getContextPath() + "/itemCategories");
    }

    private boolean existsInDatabase(Connection conn, int itemCID) throws SQLException {
        String checkSql = "SELECT 1 FROM FMO_ADM.FMO_ITEM_CATEGORIES WHERE ITEM_CAT_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, itemCID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}
