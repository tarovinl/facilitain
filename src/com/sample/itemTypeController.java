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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/itemType")
public class ItemTypeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ItemType> itemTypeList = new ArrayList<>();

        // Query to retrieve item types
        String sql = "SELECT ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_TYPES";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ItemType itemType = new ItemType();
                itemType.setItemTypeId(resultSet.getInt("ITEM_TYPE_ID"));
                itemType.setItemCatId(resultSet.getInt("ITEM_CAT_ID"));
                itemType.setName(resultSet.getString("NAME"));
                itemType.setDescription(resultSet.getString("DESCRIPTION"));
                itemType.setActiveFlag(resultSet.getInt("ACTIVE_FLAG"));
                itemTypeList.add(itemType);
            }
        } catch (Exception e) {
            throw new ServletException("Error retrieving item types data", e);
        }

        // Set itemTypeList as a request attribute
        request.setAttribute("itemTypeList", itemTypeList);
        request.getRequestDispatcher("itemType.jsp").forward(request, response);
    }
}
