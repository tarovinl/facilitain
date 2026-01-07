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
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "feedbackController", urlPatterns = {"/feedback"})
public class FeedbackController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Feedback> feedbackList = new ArrayList<>();
        List<Object[]> satisfactionRates = new ArrayList<>();
        double generalAverage = 0.0;
        
        // Modified query to retrieve ALL feedbacks
        String feedbackQuery = 
            "SELECT F.FEEDBACK_ID, L.NAME AS LOCATION, F.ROOM, F.RATING, F.SUGGESTIONS, F.REC_INS_DT, " +
            "       COALESCE(IC.NAME, F.SPECIFY) AS ITEM_CAT_NAME " +
            "FROM C##FMO_ADM.FMO_ITEM_FEEDBACK F " +
            "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS L ON F.ITEM_LOC_ID = L.ITEM_LOC_ID " +
            "LEFT JOIN C##FMO_ADM.FMO_ITEM_CATEGORIES IC ON F.ITEM_CAT_ID = IC.ITEM_CAT_ID " +
            "ORDER BY F.REC_INS_DT DESC";
        
        // FIXED: Include year in the grouping and ordering
        String satisfactionQuery =
            "SELECT TO_CHAR(REC_INS_DT, 'Mon YYYY') AS MONTH_YEAR, AVG(RATING) AS AVERAGE_RATING " +
            "FROM C##FMO_ADM.FMO_ITEM_FEEDBACK " +
            "GROUP BY TO_CHAR(REC_INS_DT, 'Mon YYYY'), TO_CHAR(REC_INS_DT, 'YYYY-MM') " +
            "ORDER BY TO_DATE(TO_CHAR(REC_INS_DT, 'YYYY-MM'), 'YYYY-MM')";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement feedbackStmt = conn.prepareStatement(feedbackQuery);
             PreparedStatement satisfactionStmt = conn.prepareStatement(satisfactionQuery);
             ResultSet feedbackRs = feedbackStmt.executeQuery();
             ResultSet satisfactionRs = satisfactionStmt.executeQuery()) {
            
            // Retrieve feedback list
            while (feedbackRs.next()) {
                Feedback feedback = new Feedback(
                    feedbackRs.getInt("FEEDBACK_ID"),
                    feedbackRs.getString("LOCATION"),
                    feedbackRs.getString("ROOM"),
                    feedbackRs.getInt("RATING"),
                    feedbackRs.getString("SUGGESTIONS"),
                    feedbackRs.getDate("REC_INS_DT"),
                    feedbackRs.getString("ITEM_CAT_NAME")
                );
                feedbackList.add(feedback);
            }
            
            // Retrieve satisfaction rates with year
            while (satisfactionRs.next()) {
                String monthYear = satisfactionRs.getString("MONTH_YEAR");
                double avgRating = satisfactionRs.getDouble("AVERAGE_RATING");
                satisfactionRates.add(new Object[]{monthYear, avgRating});
                generalAverage += avgRating;
            }
            
            generalAverage = satisfactionRates.isEmpty() ? 0.0 : generalAverage / satisfactionRates.size();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        request.setAttribute("generatedDate", sdf.format(new Date()));
        
        // Set attributes for JSP
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("satisfactionRates", satisfactionRates);
        request.setAttribute("generalAverage", generalAverage);
        
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to GET method
        response.sendRedirect("feedback");
    }
}