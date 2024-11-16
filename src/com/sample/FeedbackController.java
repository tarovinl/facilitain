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

@WebServlet("/FeedbackController")
public class FeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Feedback> feedbackList = new ArrayList<>();
        
        // Properly formatted query
        String query = 
            "SELECT " +
            "    F.FEEDBACK_ID, " +
            "    L.NAME AS LOCATION, " +
            "    F.ROOM, " +
            "    F.RATING, " +
            "    F.SUGGESTIONS, " +
            "    F.REC_INS_DT " +
            "FROM " +
            "    C##FMO_ADM.FMO_ITEM_FEEDBACK F " +
            "JOIN " +
            "    C##FMO_ADM.FMO_ITEM_LOCATIONS L " +
            "ON " +
            "    F.ITEM_LOC_ID = L.ITEM_LOC_ID " +
            "ORDER BY " +
            "    F.REC_INS_DT DESC";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                // Updated constructor with `location` parameter
                Feedback feedback = new Feedback(
                        rs.getInt("FEEDBACK_ID"),
                        rs.getString("LOCATION"),
                        rs.getString("ROOM"),
                        rs.getInt("RATING"),
                        rs.getString("SUGGESTIONS"),
                        rs.getDate("REC_INS_DT")
                );
                feedbackList.add(feedback);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass feedbackList to the JSP
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }
}
