package com.sample;

import sample.model.HistoryLog;
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

@WebServlet(name = "historyLogsController", urlPatterns = {"/history"})
public class historyLogsController extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get current page number from the request, default is 1
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        // Calculate the range for pagination
        int startRow = (page - 1) * PAGE_SIZE + 1;
        int endRow = page * PAGE_SIZE;

        List<HistoryLog> historyLogs = new ArrayList<>();
        int totalLogs = 0;
        int totalPages = 0;

        // Query to fetch the total number of logs
        String countQuery = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEM_HISTORY_LOGS";
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement countStmt = conn.prepareStatement(countQuery);
             ResultSet rsCount = countStmt.executeQuery()) {
            if (rsCount.next()) {
                totalLogs = rsCount.getInt(1);
                totalPages = (int) Math.ceil((double) totalLogs / PAGE_SIZE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Query to fetch the logs for the current page
        String query = 
            "SELECT LOG_ID, TABLE_NAME, OPERATION_TYPE, OPERATION_TIMESTAMP, USERNAME, ROW_DATA " +
            "FROM (" +
            "   SELECT LOG_ID, TABLE_NAME, OPERATION_TYPE, OPERATION_TIMESTAMP, USERNAME, ROW_DATA, " +
            "          ROW_NUMBER() OVER (ORDER BY OPERATION_TIMESTAMP DESC) AS row_num " +
            "   FROM C##FMO_ADM.FMO_ITEM_HISTORY_LOGS" +
            ") " +
            "WHERE row_num BETWEEN ? AND ?";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, startRow);
            stmt.setInt(2, endRow);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                HistoryLog log = new HistoryLog(
                    rs.getInt("LOG_ID"),
                    rs.getString("TABLE_NAME"),
                    rs.getString("OPERATION_TYPE"),
                    rs.getTimestamp("OPERATION_TIMESTAMP"),
                    rs.getString("USERNAME"),
                    rs.getString("ROW_DATA")
                );
                historyLogs.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set the request attributes
        request.setAttribute("historyLogs", historyLogs);
        request.setAttribute("totalLogs", totalLogs);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", PAGE_SIZE);

        // Forward the request to the JSP page
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}
