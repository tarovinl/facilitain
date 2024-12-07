package com.sample;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.AbstractMap;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import sample.model.PooledConnection;

@WebServlet(name="/reportClientController", urlPatterns = {"/reportsClient"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB file size limit
public class reportClientController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map.Entry<Integer, String>> locationList = new ArrayList<>();
        List<Map.Entry<Integer, String>> equipmentList = new ArrayList<>();

        String locationQuery = "SELECT ITEM_LOC_ID, NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG != 2";
        String equipmentQuery = "SELECT ITEM_CAT_ID, NAME FROM C##FMO_ADM.FMO_ITEM_CATEGORIES WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG = 1";

        try (Connection connection = PooledConnection.getConnection()) {

            // Fetch locations
            try (PreparedStatement locationStatement = connection.prepareStatement(locationQuery);
                 ResultSet locationResult = locationStatement.executeQuery()) {
                while (locationResult.next()) {
                    int locationId = locationResult.getInt("ITEM_LOC_ID");
                    String locationName = locationResult.getString("NAME");
                    locationList.add(new AbstractMap.SimpleEntry<>(locationId, locationName));
                }
            }

            // Fetch equipment types
            try (PreparedStatement equipmentStatement = connection.prepareStatement(equipmentQuery);
                 ResultSet equipmentResult = equipmentStatement.executeQuery()) {
                while (equipmentResult.next()) {
                    int itemCatId = equipmentResult.getInt("ITEM_CAT_ID");
                    String itemCatName = equipmentResult.getString("NAME");
                    equipmentList.add(new AbstractMap.SimpleEntry<>(itemCatId, itemCatName));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set attributes for the JSP page
        request.setAttribute("locationList", locationList);
        request.setAttribute("equipmentList", equipmentList);

        // Forward the request to the JSP page
        request.getRequestDispatcher("/reportsClient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Extract form fields from request
        String equipment = request.getParameter("equipment");
        if ("Other".equals(equipment)) {
            equipment = request.getParameter("otherEquipment"); // If 'Other' is selected, take the custom input
        }
        String locationId = request.getParameter("location");
        String floor = request.getParameter("floor");
        String room = request.getParameter("room");
        String issue = request.getParameter("issue");
        Part imagePart = request.getPart("imageUpload");

        String insertedBy = request.getParameter("email");
        if (insertedBy == null || insertedBy.trim().isEmpty()) {
            insertedBy = "No email provided";
        }
        Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());

        InputStream inputStream = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            inputStream = imagePart.getInputStream();
        }

        try (Connection connection = PooledConnection.getConnection()) {
            // Get the max REPORT_ID and increment it by 1
            String getMaxIdQuery = "SELECT COALESCE(MAX(REPORT_ID), 0) + 1 AS NEXT_ID FROM C##FMO_ADM.FMO_ITEM_REPORTS";
            int reportId = 0;
            try (Statement stmt = connection.createStatement();
                 ResultSet rs = stmt.executeQuery(getMaxIdQuery)) {
                if (rs.next()) {
                    reportId = rs.getInt("NEXT_ID");
                }
            }

            // Generate REPORT_CODE (e.g., abbreviation of equipment, floor, and room, plus unique ID)
            String reportCode = generateReportCode(equipment, floor, room, reportId);
            // Insert the new report, including STATUS and REPORT_CODE
            String insertQuery = "INSERT INTO C##FMO_ADM.FMO_ITEM_REPORTS (REPORT_ID, EQUIPMENT_TYPE, ITEM_LOC_ID, REPORT_FLOOR, REPORT_ROOM, REPORT_ISSUE, REPORT_PICTURE, REC_INST_DT, REC_INST_BY, STATUS, REPORT_CODE) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
                pstmt.setInt(1, reportId);
                pstmt.setString(2, equipment);  // This will store the selected equipment, including 'Other'
                pstmt.setInt(3, Integer.parseInt(locationId));
                pstmt.setString(4, floor);
                pstmt.setString(5, room);
                pstmt.setString(6, issue);
                if (inputStream != null) {
                    pstmt.setBlob(7, inputStream);
                } else {
                    pstmt.setNull(7, java.sql.Types.BLOB);
                }
                pstmt.setTimestamp(8, currentTimestamp);
                pstmt.setString(9, insertedBy);
                pstmt.setInt(10, 0); // STATUS: 0 means Not Resolved
                pstmt.setString(11, reportCode);

                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    System.out.println("Report inserted successfully with Report Code: " + reportCode);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                inputStream.close();
            }
        }

        // Redirect to the reportsThanksClient.jsp
        response.sendRedirect("reportsThanksClient.jsp");
    }



    private String generateReportCode(String equipment, String floor, String room, int reportId) {
        String equipmentAbbr = equipment != null ? equipment.substring(0, Math.min(equipment.length(), 3)).toUpperCase() : "EQP";
        String floorAbbr = floor != null ? floor.toUpperCase() : "FLR";
        String roomAbbr = room != null ? room.substring(0, Math.min(room.length(), 3)).toUpperCase() : "RM";

        // Add a unique suffix using the reportId to ensure uniqueness
        return equipmentAbbr + "-" + floorAbbr + "-" + roomAbbr + "-" + reportId;
    }

}