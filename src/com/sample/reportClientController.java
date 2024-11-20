package com.sample;

import sample.model.Location;
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
import java.util.Map;
import java.util.AbstractMap;

@WebServlet(name="/reportClientController", urlPatterns = {"/reportsClient"})
public class reportClientController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map.Entry<Integer, String>> locationList = new ArrayList<>();

        String locationQuery = "SELECT ITEM_LOC_ID, NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG != 2";

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
        request.getRequestDispatcher("/reportsClient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve parameters from the request
        String equipment = request.getParameter("equipment"); // Equipment type
        String locationId = request.getParameter("location"); // ITEM_LOC_ID (passed directly)
        String floor = request.getParameter("floor");
        String room = request.getParameter("room");
        String issue = request.getParameter("issue");

        // Create the Report object (excluding the file upload)
        Report report = new Report(equipment, locationId, floor, room, issue, null); // No file upload

        // SQL query to insert the report
        String insertReportQuery = "INSERT INTO C##FMO_ADM.FMO_ITEM_REPORTS " +
                "(EQUIPMENT_TYPE, ITEM_LOC_ID, REPORT_FLOOR, REPORT_ROOM, REPORT_ISSUE, REPORT_PICTURE, REC_INST_DT, REC_INST_BY) " +
                "VALUES (?, ?, ?, ?, ?, NULL, SYSDATE, 'USER')"; // Setting REPORT_PICTURE as NULL

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(insertReportQuery)) {

            // Set parameters for the query
            stmt.setString(1, report.getRepEquipment());
            stmt.setInt(2, Integer.parseInt(report.getLocName())); // ITEM_LOC_ID is an integer
            stmt.setString(3, report.getRepfloor());
            stmt.setString(4, report.getReproom());
            stmt.setString(5, report.getRepissue());
            // REPORT_PICTURE is set to NULL since we are excluding file upload for now

            // Execute the query to insert the data
            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("Report inserted successfully.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Optionally, redirect to an error page or log the error
        }

        // Redirect to the reportsThanksClient.jsp
        response.sendRedirect("reportsThanksClient.jsp");
    }
}
