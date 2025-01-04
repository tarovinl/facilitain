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

            String locationQuery = "SELECT * FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ARCHIVED_FLAG = 1 ORDER BY NAME";
            String typeQuery = "SELECT * FROM C##FMO_ADM.FMO_ITEM_FEEDBACK_TYPE";
            String categoryQuery = "SELECT * FROM C##FMO_ADM.FMO_ITEM_CATEGORIES WHERE ARCHIVED_FLAG = 1 order by NAME";

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
                int itemCatId;
                if ("Other".equals(equipmentId)) {
                    specify = request.getParameter("otherEquipment");
                    itemCatId = -1; // You can assign a placeholder value for "Other" in the database
                } else {
                    itemCatId = Integer.parseInt(equipmentId);
                }

                // Create Feedback object
                Feedback feedback = new Feedback(locationId, room, rating, suggestions, new java.util.Date(), specify, itemCatId);

                // SQL query to insert the feedback
                String insertFeedbackQuery = "INSERT INTO C##FMO_ADM.FMO_ITEM_FEEDBACK " +
                                             "(FEEDBACK_ID, ITEM_LOC_ID, ROOM, RATING, SUGGESTIONS, REC_INS_DT, REC_INS_BY, ITEM_CAT_ID, SPECIFY) " +
                                             "VALUES (?, ?, ?, ?, ?, SYSDATE, USER, ?, ?)";

                try (Connection connection = PooledConnection.getConnection();
                     PreparedStatement stmt = connection.prepareStatement(insertFeedbackQuery)) {

                    stmt.setInt(1, feedback.getFeedbackId()); // Adjust as needed for sequence or auto-generation
                    stmt.setInt(2, feedback.getItemLocId());
                    stmt.setString(3, feedback.getRoom());
                    stmt.setInt(4, feedback.getRating());
                    stmt.setString(5, feedback.getSuggestions());
                    stmt.setObject(6, itemCatId != -1 ? itemCatId : null); // Use null if Other
                    stmt.setString(7, specify);

                    stmt.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect("feedbackThanksClient.jsp");
            
                    }
            }