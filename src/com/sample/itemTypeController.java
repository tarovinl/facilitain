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

import sample.model.Item;

@WebServlet("/itemTypes")
public class itemTypeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Item> itemList = new ArrayList<>();

        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "SELECT ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_TYPES";
            try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    
                    item.setItemTID(rs.getInt("ITEM_TYPE_ID"));  // Type ID
                    item.setItemCID(rs.getInt("ITEM_CAT_ID"));   // Category ID
                    item.setItemName(rs.getString("NAME"));      // Name
                    item.setItemCat(rs.getString("DESCRIPTION")); // Description as Category
                    item.setActiveFlag(rs.getInt("ACTIVE_FLAG")); // Active flag
                    itemList.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while retrieving items.", e);
        }

        // Set the itemList attribute to pass to the JSP
        request.setAttribute("itemList", itemList);

        // Forward to the JSP page
        request.getRequestDispatcher("itemTypes.jsp").forward(request, response);
    }
}
