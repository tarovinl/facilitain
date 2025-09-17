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
            "FROM FMO_ADM.FMO_ITEM_REPORTS R " +
            "JOIN FMO_ADM.FMO_ITEM_LOCATIONS L ON R.ITEM_LOC_ID = L.ITEM_LOC_ID " +
            "LEFT JOIN FMO_ADM.FMO_ITEM_TYPES T ON UPPER(TRIM(R.EQUIPMENT_TYPE)) = UPPER(TRIM(T.NAME)) " +
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
        
        // Prepare data for charts
        Map<String, Integer> locationReports = new HashMap<>();
        Map<String, Integer> equipmentReports = new HashMap<>();
        
        // Count reports by location and equipment
        for (Report report : reportsList) {
            // Count by location
            String location = report.getLocName();
            locationReports.put(location, locationReports.getOrDefault(location, 0) + 1);
            
            // Count by equipment type
            String equipment = report.getRepEquipment();
            equipmentReports.put(equipment, equipmentReports.getOrDefault(equipment, 0) + 1);
        }
        
        // Convert maps to lists for JSP
        List<Map.Entry<String, Integer>> locationData = new ArrayList<>(locationReports.entrySet());
        List<Map.Entry<String, Integer>> equipmentData = new ArrayList<>(equipmentReports.entrySet());
        
        // Sort by count (descending) for better visualization
        locationData.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        equipmentData.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        
        // Set the reports list, similar reports map, and chart data as request attributes
        request.setAttribute("reportsList", reportsList);
        request.setAttribute("hasSimilarReports", hasSimilarReports);
        request.setAttribute("locationReports", locationData);
        request.setAttribute("equipmentReports", equipmentData);
        
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportId = request.getParameter("reportId");
        if (reportId != null) {
            try (Connection connection = PooledConnection.getConnection()) {
                String archiveReportQuery = "UPDATE FMO_ADM.FMO_ITEM_REPORTS SET ARCHIVED_FLAG = 2 WHERE REPORT_ID = ?";
                try (PreparedStatement stmt = connection.prepareStatement(archiveReportQuery)) {
                    stmt.setInt(1, Integer.parseInt(reportId));
                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        System.out.println("Successfully archived report ID: " + reportId);
                        response.sendRedirect("reports?action=archived");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Error archiving report ID " + reportId + ": " + e.getMessage());
                response.sendRedirect("reports?error=true");
                return;
            }
        }
        response.sendRedirect("reports");
    }
}