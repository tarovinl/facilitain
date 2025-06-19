package com.sample;

import sample.model.Feedback;
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

@WebServlet(name = "FeedbackClientController", urlPatterns = { "/feedbackClient" })
public class FeedbackClientController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map.Entry<Integer, String>> locationList = new ArrayList<>();
        List<Map.Entry<Integer, String>> typeList = new ArrayList<>();
        List<Map.Entry<Integer, String>> catList = new ArrayList<>();

        String locationQuery = "SELECT * FROM FMO_ITEM_LOCATIONS WHERE ARCHIVED_FLAG = 1 ORDER BY NAME";
        String typeQuery = "SELECT * FROM FMO_ITEM_FEEDBACK_TYPE";
        String categoryQuery = "SELECT * FROM FMO_ITEM_CATEGORIES WHERE ARCHIVED_FLAG = 1 ORDER BY NAME";

        try (
            Connection connection = PooledConnection.getConnection();
            PreparedStatement locationStatement = connection.prepareStatement(locationQuery);
            PreparedStatement typeStatement = connection.prepareStatement(typeQuery);
            PreparedStatement categoryStatement = connection.prepareStatement(categoryQuery)
        ) {
            try (ResultSet locationResult = locationStatement.executeQuery()) {
                while (locationResult.next()) {
                    int locationId = locationResult.getInt("ITEM_LOC_ID");
                    String locationName = locationResult.getString("NAME");
                    locationList.add(new AbstractMap.SimpleEntry<>(locationId, locationName));
                }
            }

            try (ResultSet typeResult = typeStatement.executeQuery()) {
                while (typeResult.next()) {
                    int typeId = typeResult.getInt("FEEDBACK_TYPE_ID");
                    String typeName = typeResult.getString("NAME");
                    typeList.add(new AbstractMap.SimpleEntry<>(typeId, typeName));
                }
            }

            try (ResultSet categoryResult = categoryStatement.executeQuery()) {
                while (categoryResult.next()) {
                    int categoryId = categoryResult.getInt("ITEM_CAT_ID");
                    String categoryName = categoryResult.getString("NAME").toUpperCase();
                    catList.add(new AbstractMap.SimpleEntry<>(categoryId, categoryName));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("locationList", locationList);
        request.setAttribute("typeList", typeList);
        request.setAttribute("catList", catList);
        request.getRequestDispatcher("/feedbackClient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String room = request.getParameter("room");
        int locationId = Integer.parseInt(request.getParameter("location"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String suggestions = request.getParameter("suggestions");
        String equipmentId = request.getParameter("equipment");
        String specify = null;

        // Handle "Other" equipment type
        Integer itemCatId = null;
        if ("Other".equals(equipmentId)) {
            specify = request.getParameter("otherEquipment");
            itemCatId = null; // Set to null instead of -1 for "Other"
        } else {
            itemCatId = Integer.parseInt(equipmentId);
            specify = null; // Make sure specify is null when a category is selected
        }

        // Create Feedback object
        Feedback feedback = new Feedback(locationId, room, rating, suggestions, new java.util.Date(), specify, itemCatId);

        // First check if the columns exist in the table
        boolean hasItemCatId = false;
        boolean hasSpecify = false;
        
        try (Connection connection = PooledConnection.getConnection()) {
            // Check table structure
            try (ResultSet rs = connection.getMetaData().getColumns(null, "C##FMO_ADM", "FMO_ITEM_FEEDBACK", "ITEM_CAT_ID")) {
                hasItemCatId = rs.next();
            }
            
            try (ResultSet rs = connection.getMetaData().getColumns(null, "C##FMO_ADM", "FMO_ITEM_FEEDBACK", "SPECIFY")) {
                hasSpecify = rs.next();
            }
            
            // SQL query to insert the feedback - adjust based on available columns
            StringBuilder insertQuery = new StringBuilder("INSERT INTO FMO_ITEM_FEEDBACK ");
            StringBuilder columns = new StringBuilder("(FEEDBACK_ID, ITEM_LOC_ID, ROOM, RATING, SUGGESTIONS, REC_INS_DT, REC_INS_BY");
            StringBuilder values = new StringBuilder("VALUES (?, ?, ?, ?, ?, SYSDATE, USER");
            
            if (hasItemCatId) {
                columns.append(", ITEM_CAT_ID");
                values.append(", ?");
            }
            
            if (hasSpecify) {
                columns.append(", SPECIFY");
                values.append(", ?");
            }
            
            columns.append(")");
            values.append(")");
            
            insertQuery.append(columns).append(" ").append(values);
            
            try (PreparedStatement stmt = connection.prepareStatement(insertQuery.toString())) {
                int paramIndex = 1;
                
                stmt.setInt(paramIndex++, feedback.getFeedbackId());
                stmt.setInt(paramIndex++, feedback.getItemLocId());
                stmt.setString(paramIndex++, feedback.getRoom());
                stmt.setInt(paramIndex++, feedback.getRating());
                stmt.setString(paramIndex++, feedback.getSuggestions());
                
                if (hasItemCatId) {
                    if (itemCatId != null) {
                        stmt.setInt(paramIndex++, itemCatId);
                    } else {
                        stmt.setNull(paramIndex++, java.sql.Types.INTEGER);
                    }
                }
                
                if (hasSpecify) {
                    stmt.setString(paramIndex++, specify);
                }
                
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("feedbackThanksClient.jsp");
    }
}