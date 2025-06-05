package com.sample;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import sample.model.PooledConnection;

@WebServlet("/buildingController")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Limit to 5MB
public class buildingController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        
        String action = "";
        String status = "success";

        request.setCharacterEncoding("UTF-8");
        String locId = request.getParameter("locID");
        String locName = request.getParameter("locName");
        String locDescription = request.getParameter("locDescription");
        String mapCoord = request.getParameter("mapCoord");
        Part filePart = request.getPart("imageFile"); // Retrieves <input type="file" name="imageFile">

        System.out.println("locId: " + locId);
        System.out.println("locName: " + locName);
        System.out.println("locDescription: " + locDescription);
        System.out.println("File: " + filePart);

        try (Connection conn = PooledConnection.getConnection()) {
            // Update C##FMO_ADM.FMO_ITEM_LOCATIONS table
            String sql;
            
            // Check if a new image is being uploaded
            boolean hasNewImage = (filePart != null && filePart.getSize() > 0);
            
            if (hasNewImage) {
                // Update with new image
                sql = "UPDATE C##FMO_ADM.FMO_ITEM_LOCATIONS SET NAME = ?, DESCRIPTION = ?, IMAGE = ? WHERE ITEM_LOC_ID = ?";
            } else {
                // Update without changing the image
                sql = "UPDATE C##FMO_ADM.FMO_ITEM_LOCATIONS SET NAME = ?, DESCRIPTION = ? WHERE ITEM_LOC_ID = ?";
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, locName);
                stmt.setString(2, locDescription);
                
                if (hasNewImage) {
                    InputStream inputStream = filePart.getInputStream();
                    stmt.setBinaryStream(3, inputStream, (int) filePart.getSize());
                    stmt.setInt(4, Integer.parseInt(locId));
                } else {
                    stmt.setInt(3, Integer.parseInt(locId));
                }

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("Updated FMO_ITEM_LOCATIONS successfully");

                    // Now update or insert into C##FMO_ADM.FMO_ITEM_LOC_MAP table
                    if (!isNullOrEmpty(mapCoord)) {
                        String[] coords = mapCoord.split(",");
                        if (coords.length == 2) {
                            String latitude = coords[0].trim();
                            String longitude = coords[1].trim();

                            String sqlMapUpdate = "UPDATE C##FMO_ADM.FMO_ITEM_LOC_MAP SET LATITUDE = ?, LONGITUDE = ? WHERE ITEM_LOC_ID = ?";
                            try (PreparedStatement stmtMapUpdate = conn.prepareStatement(sqlMapUpdate)) {
                                stmtMapUpdate.setString(1, latitude);
                                stmtMapUpdate.setString(2, longitude);
                                stmtMapUpdate.setInt(3, Integer.parseInt(locId));

                                int mapRowsUpdated = stmtMapUpdate.executeUpdate();
                                if (mapRowsUpdated == 0) {
                                    // If no rows updated, insert a new record
                                    String sqlMapInsert = "INSERT INTO C##FMO_ADM.FMO_ITEM_LOC_MAP (ITEM_LOC_ID, LATITUDE, LONGITUDE) VALUES (?, ?, ?)";
                                    try (PreparedStatement stmtMapInsert = conn.prepareStatement(sqlMapInsert)) {
                                        stmtMapInsert.setInt(1, Integer.parseInt(locId));
                                        stmtMapInsert.setString(2, latitude);
                                        stmtMapInsert.setString(3, longitude);

                                        stmtMapInsert.executeUpdate();
                                        System.out.println("Inserted new record into FMO_ITEM_LOC_MAP successfully");
                                    }
                                } else {
                                    System.out.println("Updated FMO_ITEM_LOC_MAP successfully");
                                }
                            }
                        }
                    }
                    
                    action = "building_modify";

                    response.sendRedirect("buildingDashboard?locID=" + locId + "/edit&action=" + action + "&status=" + status);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Location not found in FMO_ITEM_LOCATIONS");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving data");
        }
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}