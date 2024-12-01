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
        String retrieveReportsQuery = "SELECT " +
            "REPORT_ID, EQUIPMENT_TYPE, ITEM_LOC_ID, REPORT_FLOOR, " +
            "REPORT_ROOM, REPORT_ISSUE, REPORT_PICTURE, " +
            "REC_INST_DT, REC_INST_BY, STATUS, REPORT_CODE " +
            "FROM C##FMO_ADM.FMO_ITEM_REPORTS " +
            "ORDER BY REC_INST_DT DESC";

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
                    rs.getString("ITEM_LOC_ID"),
                    rs.getString("REPORT_FLOOR"),
                    rs.getString("REPORT_ROOM"),
                    rs.getString("REPORT_ISSUE"),
                    reportImage,
                    rs.getDate("REC_INST_DT"),
                    rs.getString("REC_INST_BY"),
                    rs.getInt("STATUS"),
                    rs.getString("REPORT_CODE")
                );
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
}