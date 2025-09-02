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
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet(name = "historyLogsController", urlPatterns = {"/history"})
public class historyLogsController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if this is a DataTables AJAX request
        String draw = request.getParameter("draw");
        if (draw != null) {
            handleDataTablesRequest(request, response);
            return;
        }
        
        // Regular page load - just forward to JSP
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
    
    private void handleDataTablesRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // DataTables parameters
            int draw = Integer.parseInt(request.getParameter("draw"));
            int start = Integer.parseInt(request.getParameter("start"));
            int length = Integer.parseInt(request.getParameter("length"));
            String searchValue = request.getParameter("search[value]");
            
            // Get sorting parameters
            String sortColumnIndex = request.getParameter("order[0][column]");
            String sortDirection = request.getParameter("order[0][dir]");
            String sortColumn = getSortColumn(sortColumnIndex);
            
       
            int totalRecords = getTotalRecords();
            
           
            List<HistoryLog> historyLogs = getFilteredRecords(start, length, searchValue, sortColumn, sortDirection);
            int filteredRecords = getFilteredRecordsCount(searchValue);
            
            // Build JSON response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("draw", draw);
            jsonResponse.addProperty("recordsTotal", totalRecords);
            jsonResponse.addProperty("recordsFiltered", filteredRecords);
            
            // Convert data to JSON array
            Gson gson = new Gson();
            jsonResponse.add("data", gson.toJsonTree(convertToDataTablesFormat(historyLogs)));
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private String getSortColumn(String columnIndex) {
        if (columnIndex == null) return "OPERATION_TIMESTAMP";
        
        switch (columnIndex) {
            case "0": return "LOG_ID";
            case "1": return "TABLE_NAME";
            case "2": return "OPERATION_TYPE";
            case "3": return "OPERATION_TIMESTAMP";
            default: return "OPERATION_TIMESTAMP";
        }
    }
    
    private int getTotalRecords() throws Exception {
        String query = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_HISTORY_LOGS";
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getFilteredRecordsCount(String searchValue) throws Exception {
        String query = "SELECT COUNT(*) FROM FMO_ADM.FMO_ITEM_HISTORY_LOGS";
        
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            query += " WHERE UPPER(CAST(LOG_ID AS VARCHAR2(50))) LIKE ? " +
                    "OR UPPER(TABLE_NAME) LIKE ? " +
                    "OR UPPER(OPERATION_TYPE) LIKE ? " +
                    "OR UPPER(TO_CHAR(OPERATION_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')) LIKE ? " +
                    "OR UPPER(ROW_DATA) LIKE ?";
        }
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                String searchPattern = "%" + searchValue.toUpperCase() + "%";
                for (int i = 1; i <= 5; i++) {
                    stmt.setString(i, searchPattern);
                }
            }
            
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private List<HistoryLog> getFilteredRecords(int start, int length, String searchValue, String sortColumn, String sortDirection) throws Exception {
        List<HistoryLog> historyLogs = new ArrayList<>();
        
        String baseQuery = "SELECT LOG_ID, TABLE_NAME, OPERATION_TYPE, OPERATION_TIMESTAMP, ROW_DATA " +
                          "FROM FMO_ADM.FMO_ITEM_HISTORY_LOGS";
        
        String whereClause = "";
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            whereClause = " WHERE UPPER(CAST(LOG_ID AS VARCHAR2(50))) LIKE ? " +
                         "OR UPPER(TABLE_NAME) LIKE ? " +
                         "OR UPPER(OPERATION_TYPE) LIKE ? " +
                         "OR UPPER(TO_CHAR(OPERATION_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')) LIKE ? " +
                         "OR UPPER(ROW_DATA) LIKE ?";
        }
        
        // Validate sort direction
        if (!"asc".equalsIgnoreCase(sortDirection) && !"desc".equalsIgnoreCase(sortDirection)) {
            sortDirection = "desc";
        }
        
        String orderClause = " ORDER BY " + sortColumn + " " + sortDirection.toUpperCase();
        
        // Oracle pagination with ROWNUM
        String query = "SELECT * FROM (" +
                      "SELECT ROWNUM as rn, t.* FROM (" +
                      baseQuery + whereClause + orderClause +
                      ") t WHERE ROWNUM <= ?" +
                      ") WHERE rn > ?";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            int paramIndex = 1;
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                String searchPattern = "%" + searchValue.toUpperCase() + "%";
                for (int i = 0; i < 5; i++) {
                    stmt.setString(paramIndex++, searchPattern);
                }
            }
            
            stmt.setInt(paramIndex++, start + length);
            stmt.setInt(paramIndex, start);
            
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
        }
        
        return historyLogs;
    }
    
    private List<String[]> convertToDataTablesFormat(List<HistoryLog> logs) {
        List<String[]> data = new ArrayList<>();
        for (HistoryLog log : logs) {
            String operationType = log.getOperationType();
            String displayType = operationType;
            String badgeClass = "bg-secondary";
            
            switch (operationType) {
                case "INSERT":
                    displayType = "Added";
                    badgeClass = "bg-success";
                    break;
                case "UPDATE":
                    displayType = "Edited";
                    badgeClass = "bg-warning text-dark";
                    break;
                case "DELETE":
                    displayType = "Archived";
                    badgeClass = "bg-danger";
                    break;
            }
            
            String rowData = log.getRowData();
            if (rowData != null) {
                // Escape quotes and handle special characters for HTML attributes
                rowData = rowData.replace("'", "&#39;")
                                .replace("\"", "&quot;")
                                .replace("\n", "&#10;")
                                .replace("\r", "&#13;");
            } else {
                rowData = "";
            }
            
            String[] row = {
                String.valueOf(log.getLogId()),
                log.getTableName(),
                "<span class='badge fs-6 " + badgeClass + "'>" + displayType + "</span>",
                new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(log.getOperationTimestamp()),
                "<button class='btn btn-outline-info btn-sm btn-details' data-row-data='" + rowData + 
                "'><i class='fas fa-eye me-1'></i>View</button>"
            };
            data.add(row);
        }
        return data;
    }
}