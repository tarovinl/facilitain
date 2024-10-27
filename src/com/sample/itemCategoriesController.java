package com.sample;

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

import sample.model.ItemCategory;

@WebServlet("/itemCategories")
public class itemCategoriesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = PooledConnection.getConnection()) {
            String query = "SELECT ITEM_CAT_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_CATEGORIES";
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                List<ItemCategory> categoryList = new ArrayList<>();
                while (rs.next()) {
                    ItemCategory category = new ItemCategory();
                    category.setItemCID(rs.getInt("ITEM_CAT_ID"));
                    category.setCategoryName(rs.getString("NAME"));
                    category.setDescription(rs.getString("DESCRIPTION"));
                    category.setActiveFlag(rs.getInt("ACTIVE_FLAG"));
                    categoryList.add(category);
                }
                request.setAttribute("categoryList", categoryList);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching item categories.", e);
        }

        // Forward the request to itemcategories.jsp to display the data
        request.getRequestDispatcher("itemCategories.jsp").forward(request, response);
    }

    
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemCIDParam = request.getParameter("itemCID");
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        int activeFlag = Integer.parseInt(request.getParameter("activeFlag"));
        
        
        Integer itemCID = (itemCIDParam != null && !itemCIDParam.isEmpty()) ? Integer.parseInt(itemCIDParam) : null;

        try (Connection conn = PooledConnection.getConnection()) {
            if (itemCID != null && existsInDatabase(conn, itemCID)) {
                // edit
                String updateSql = "UPDATE C##FMO_ADM.FMO_ITEM_CATEGORIES SET NAME = ?, DESCRIPTION = ?, ACTIVE_FLAG = ? WHERE ITEM_CAT_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setString(1, categoryName);
                    stmt.setString(2, description);
                    stmt.setInt(3, activeFlag);
                    stmt.setInt(4, itemCID);
                    stmt.executeUpdate();
                }
            } else {
                // add
                String insertSql = "INSERT INTO C##FMO_ADM.FMO_ITEM_CATEGORIES (NAME, DESCRIPTION, ACTIVE_FLAG) VALUES (?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setString(1, categoryName);
                    stmt.setString(2, description);
                    stmt.setInt(3, activeFlag);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while processing item categories.", e);
        }

        
        response.sendRedirect(request.getContextPath() + "/itemCategories");
    }

 //CID check
    private boolean existsInDatabase(Connection conn, int itemCID) throws SQLException {
        String checkSql = "SELECT 1 FROM C##FMO_ADM.FMO_ITEM_CATEGORIES WHERE ITEM_CAT_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, itemCID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}
