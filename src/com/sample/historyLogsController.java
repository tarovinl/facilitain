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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<HistoryLog> historyLogs = new ArrayList<>();

        String query = 
            "SELECT LOG_ID, TABLE_NAME, OPERATION_TYPE, OPERATION_TIMESTAMP, ROW_DATA " +
            "FROM FMO_ADM.FMO_ITEM_HISTORY_LOGS " +
            "ORDER BY OPERATION_TIMESTAMP DESC";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                HistoryLog log = new HistoryLog(
                    rs.getInt("LOG_ID"),
                    rs.getString("TABLE_NAME"),
                    rs.getString("OPERATION_TYPE"),
                    rs.getTimestamp("OPERATION_TIMESTAMP"),
                    rs.getString("ROW_DATA")
                );
                historyLogs.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Add error handling
            request.setAttribute("error", "Failed to load history logs: " + e.getMessage());
        }

        request.setAttribute("historyLogs", historyLogs);
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}