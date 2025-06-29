package com.sample;

import java.io.InputStream;
import java.io.IOException;
import java.io.PrintWriter;
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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import com.google.gson.Gson;

import sample.model.PooledConnection;

@WebServlet(name="/reportClientController", urlPatterns = {"/reportsClient"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB file size limit
public class reportClientController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Handle AJAX requests for dynamic dropdowns
        if ("getFloors".equals(action)) {
            getFloorsByLocation(request, response);
            return;
        } else if ("getRooms".equals(action)) {
            getRoomsByLocationAndFloor(request, response);
            return;
        }
        
        // Regular page load - get locations and equipment
        List<Map.Entry<Integer, String>> locationList = new ArrayList<>();
        List<Map.Entry<String, String>> equipmentList = new ArrayList<>(); 

        String locationQuery = "SELECT ITEM_LOC_ID, NAME FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG != 2 ORDER BY NAME";
        String equipmentQuery = "SELECT * FROM C##FMO_ADM.FMO_ITEM_CATEGORIES WHERE ARCHIVED_FLAG = 1 ORDER BY NAME";

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
                    String itemCatName = equipmentResult.getString("NAME").toUpperCase();
                    // Store name as both key and value so the form sends the name
                    equipmentList.add(new AbstractMap.SimpleEntry<>(itemCatName, itemCatName));
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
    
    private void getFloorsByLocation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String locationId = request.getParameter("locationId");
        List<String> floors = new ArrayList<>();
        
        if (locationId != null && !locationId.isEmpty()) {
            String floorQuery = "SELECT DISTINCT NAME FROM C##FMO_ADM.FMO_ITEM_LOC_FLOORS WHERE ITEM_LOC_ID = ? AND ACTIVE_FLAG = 1 AND ARCHIVED_FLAG != 2 ORDER BY NAME";
            
            try (Connection connection = PooledConnection.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(floorQuery)) {
                
                stmt.setInt(1, Integer.parseInt(locationId));
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        floors.add(rs.getString("NAME"));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(floors));
        out.flush();
    }
    
    private void getRoomsByLocationAndFloor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String locationId = request.getParameter("locationId");
        String floorNo = request.getParameter("floorNo");
        List<String> rooms = new ArrayList<>();
        
        if (locationId != null && !locationId.isEmpty() && floorNo != null && !floorNo.isEmpty()) {
            String roomQuery = "SELECT DISTINCT ROOM_NO FROM C##FMO_ADM.FMO_ITEMS WHERE LOCATION_ID = ? AND FLOOR_NO = ? AND ROOM_NO IS NOT NULL AND ITEM_STAT_ID != 2 ORDER BY ROOM_NO";
            
            try (Connection connection = PooledConnection.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(roomQuery)) {
                
                stmt.setInt(1, Integer.parseInt(locationId));
                stmt.setString(2, floorNo);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String roomNo = rs.getString("ROOM_NO");
                        if (roomNo != null && !roomNo.trim().isEmpty()) {
                            rooms.add(roomNo);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(rooms));
        out.flush();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get session for user email
        HttpSession session = request.getSession(false);
        String insertedBy = null;
        
        // Get email from session if available
        if (session != null && session.getAttribute("email") != null) {
            insertedBy = (String) session.getAttribute("email");
        }
        
        // If no email found in session, use a default message
        if (insertedBy == null || insertedBy.trim().isEmpty()) {
            insertedBy = "No email provided";
        }

        // Regular form submission logic
        String equipment = request.getParameter("equipment");
        if ("Other".equals(equipment)) {
            equipment = request.getParameter("otherEquipment"); // If 'Other' is selected, take the custom input
        }
        // Now equipment contains the NAME, not the ID
        
        String locationId = request.getParameter("location");
        String floor = request.getParameter("floor");
        String room = request.getParameter("room");
        String issue = request.getParameter("issue");
        Part imagePart = request.getPart("imageUpload");

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
                pstmt.setString(2, equipment); 
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
                    System.out.println("Equipment stored as: " + equipment); // Log the equipment name
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
