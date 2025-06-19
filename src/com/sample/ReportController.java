package com.sample;
import sample.model.Report;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name="reportController", urlPatterns = {"/reports"})
public class ReportController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Report> reportsList = new ArrayList<>();
        
        // Query to get equipment name from FMO_ITEM_TYPES table
        String retrieveReportsQuery = "SELECT R.REPORT_ID, COALESCE(T.NAME, R.EQUIPMENT_TYPE) AS EQUIPMENT_TYPE, " +
            "L.NAME AS LOC_NAME, R.REPORT_FLOOR, R.REPORT_ROOM, R.REPORT_ISSUE, R.REPORT_PICTURE, " +
            "R.REC_INST_DT, R.REC_INST_BY, R.STATUS, R.REPORT_CODE, R.ARCHIVED_FLAG " +
            "FROM FMO_ITEM_REPORTS R " +
            "JOIN FMO_ITEM_LOCATIONS L ON R.ITEM_LOC_ID = L.ITEM_LOC_ID " +
            "LEFT JOIN FMO_ITEM_TYPES T ON UPPER(TRIM(R.EQUIPMENT_TYPE)) = UPPER(TRIM(T.NAME)) " +
            "WHERE R.ARCHIVED_FLAG = 1 " +
            "ORDER BY R.REC_INST_DT DESC";
        
        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(retrieveReportsQuery);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                byte[] reportImage = null;
                if (rs.getBlob("REPORT_PICTURE") != null) {
                    reportImage = rs.getBlob("REPORT_PICTURE").getBytes(1, (int) rs.getBlob("REPORT_PICTURE").length());
                }
                Report report = new Report(
                    rs.getInt("REPORT_ID"),
                    rs.getString("EQUIPMENT_TYPE"),
                    rs.getString("LOC_NAME"),
                    rs.getString("REPORT_FLOOR"),
                    rs.getString("REPORT_ROOM"),
                    rs.getString("REPORT_ISSUE"),
                    reportImage,
                    rs.getDate("REC_INST_DT"),
                    rs.getString("REC_INST_BY"),
                    rs.getInt("STATUS"),
                    rs.getString("REPORT_CODE")
                );
                report.setArchivedFlag(rs.getInt("ARCHIVED_FLAG"));  
                reportsList.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Database error in ReportController.doGet(): " + e.getMessage());
        }
        
        // Create a map to count similar unresolved reports
        Map<String, List<Integer>> similarReportsMap = new HashMap<>();
        Map<Integer, Boolean> hasSimilarReports = new HashMap<>();
        
        // Group reports by equipment type, location, floor, and room
        for (Report report : reportsList) {
            if (report.getStatus() == 0) { // Only unresolved reports
                String key = report.getRepEquipment() + "|" + report.getLocName() + "|" + 
                           report.getRepfloor() + "|" + report.getReproom();
                
                similarReportsMap.computeIfAbsent(key, k -> new ArrayList<>()).add(report.getReportId());
            }
        }
        
        // Mark reports that have similar unresolved reports
        for (Map.Entry<String, List<Integer>> entry : similarReportsMap.entrySet()) {
            if (entry.getValue().size() > 1) { 
                for (Integer reportId : entry.getValue()) {
                    hasSimilarReports.put(reportId, true);
                }
            }
        }
        
        // Set the reports list and similar reports map as request attributes
        request.setAttribute("reportsList", reportsList);
        request.setAttribute("hasSimilarReports", hasSimilarReports);
        
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportId = request.getParameter("reportId");
        if (reportId != null) {
            try (Connection connection = PooledConnection.getConnection()) {
                String archiveReportQuery = "UPDATE FMO_ITEM_REPORTS SET ARCHIVED_FLAG = 2 WHERE REPORT_ID = ?";
                try (PreparedStatement stmt = connection.prepareStatement(archiveReportQuery)) {
                    stmt.setInt(1, Integer.parseInt(reportId));
                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        System.out.println("Successfully archived report ID: " + reportId);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Error archiving report ID " + reportId + ": " + e.getMessage());
            }
        }
        response.sendRedirect("reports");
    }
}
