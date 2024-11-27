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

        String locationQuery = "SELECT ITEM_LOC_ID, NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ACTIVE_FLAG != 2";


        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement locationStatement = connection.prepareStatement(locationQuery)) {

            try (ResultSet locationResult = locationStatement.executeQuery()) {
                while (locationResult.next()) {
                    int locationId = locationResult.getInt("ITEM_LOC_ID");
                    String locationName = locationResult.getString("NAME");
                    locationList.add(new AbstractMap.SimpleEntry<>(locationId, locationName));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("locationList", locationList);
        request.getRequestDispatcher("/feedbackClient.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve parameters from the request
        String room = request.getParameter("room");
        int locationId = Integer.parseInt(request.getParameter("location"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String suggestions = request.getParameter("suggestions");

        // Create the Feedback object
        Feedback feedback = new Feedback(locationId, room, rating, suggestions, new java.util.Date());  // Adding current date for REC_INS_DT

        // Query to insert the feedback
        String insertFeedbackQuery = "INSERT INTO C##FMO_ADM.FMO_ITEM_FEEDBACK (FEEDBACK_ID, ITEM_LOC_ID, ROOM, RATING, SUGGESTIONS, REC_INS_DT, REC_INS_BY) " +
                                     "VALUES (?, ?, ?, ?, ?, SYSDATE, USER)"; 

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(insertFeedbackQuery)) {

            
            stmt.setInt(1, feedback.getFeedbackId()); 
            stmt.setInt(2, feedback.getItemLocId());
            stmt.setString(3, feedback.getRoom());
            stmt.setInt(4, feedback.getRating());
            stmt.setString(5, feedback.getSuggestions());

            // Execute the query to insert the data
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect to the feedbackThanksClient.jsp
        response.sendRedirect("feedbackThanksClient.jsp");
    }
    }