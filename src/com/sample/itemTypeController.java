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
import java.util.Map;
import java.util.AbstractMap;

@WebServlet("/itemType")
public class itemTypeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ItemType> itemTypeList = new ArrayList<>();
        List<Map.Entry<Integer, String>> categoryList = new ArrayList<>();

        String itemTypeQuery = "SELECT ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION, ARCHIVED_FLAG FROM FMO_ITEM_TYPES";
        String categoryQuery = "SELECT ITEM_CAT_ID, NAME FROM FMO_ITEM_CATEGORIES WHERE ARCHIVED_FLAG = 1";

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
                   String query = "UPDATE FMO_ITEM_TYPES SET ARCHIVED_FLAG = 2 WHERE ITEM_TYPE_ID = ?";
                   try (PreparedStatement statement = connection.prepareStatement(query)) {
                       statement.setInt(1, itemTypeId);
                       statement.executeUpdate();
                   }
                   redirectParams = "?action=archived";
               } else {
                   // Handle add/edit logic
                   String editMode = request.getParameter("editMode");
                   int itemCatId = Integer.parseInt(request.getParameter("itemCatId"));
                   String name = request.getParameter("name");
                   String description = request.getParameter("description");

                   if ("true".equals(editMode)) {
                       int itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
                       String updateQuery = "UPDATE FMO_ITEM_TYPES SET ITEM_CAT_ID = ?, NAME = ?, DESCRIPTION = ? WHERE ITEM_TYPE_ID = ?";
                       try (PreparedStatement statement = connection.prepareStatement(updateQuery)) {
                           statement.setInt(1, itemCatId);
                           statement.setString(2, name);
                           statement.setString(3, description);
                           statement.setInt(4, itemTypeId);
                           statement.executeUpdate();
                       }
                       redirectParams = "?action=updated";
                   } else {
                       String insertQuery = "INSERT INTO FMO_ITEM_TYPES (ITEM_TYPE_ID, ITEM_CAT_ID, NAME, DESCRIPTION) VALUES (FMO_ITEM_TYP_ID_SEQ.NEXTVAL, ?, ?, ?)";
                       try (PreparedStatement statement = connection.prepareStatement(insertQuery)) {
                           statement.setInt(1, itemCatId);
                           statement.setString(2, name);
                           statement.setString(3, description);
                           statement.executeUpdate();
                       }
                       redirectParams = "?action=added";
                   }
               }
           } catch (Exception e) {
               e.printStackTrace();
               redirectParams = "?error=true";
           }

           response.sendRedirect("itemType" + redirectParams);
       }
    }
