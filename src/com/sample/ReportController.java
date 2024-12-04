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
import java.util.List;

@WebServlet(name="reportController", urlPatterns = {"/reports"})
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Report> reportsList = new ArrayList<>();

        // SQL query to retrieve all reports
        String retrieveReportsQuery = "SELECT R.REPORT_ID, R.EQUIPMENT_TYPE, L.NAME AS LOC_NAME, R.REPORT_FLOOR, " +
            "R.REPORT_ROOM, R.REPORT_ISSUE, R.REPORT_PICTURE, R.REC_INST_DT, R.REC_INST_BY, R.STATUS, R.REPORT_CODE, R.ARCHIVED_FLAG " +
            "FROM C##FMO_ADM.FMO_ITEM_REPORTS R " +
            "JOIN C##FMO_ADM.FMO_ITEM_LOCATIONS L ON R.ITEM_LOC_ID = L.ITEM_LOC_ID " +
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
        }

        // Set the reports list as a request attribute
        request.setAttribute("reportsList", reportsList);

        // Forward to the JSP page
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
        
        
    }
    @Override
       protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
           String reportId = request.getParameter("reportId");
           if (reportId != null) {
               try (Connection connection = PooledConnection.getConnection()) {
                   String archiveReportQuery = "UPDATE C##FMO_ADM.FMO_ITEM_REPORTS SET ARCHIVED_FLAG = 2 WHERE REPORT_ID = ?";
                   try (PreparedStatement stmt = connection.prepareStatement(archiveReportQuery)) {
                       stmt.setInt(1, Integer.parseInt(reportId));
                       stmt.executeUpdate();
                   }
               } catch (Exception e) {
                   e.printStackTrace();
               }
           }
           response.sendRedirect("reports");
}
    }