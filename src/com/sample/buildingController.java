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


        request.setCharacterEncoding("UTF-8");
        String locId = request.getParameter("locID");
        String locName = request.getParameter("locName");
        String locDescription = request.getParameter("locDescription");
        Part filePart = request.getPart("imageFile"); // Retrieves <input type="file" name="imageFile">

        System.out.println("locId: " + locId);
        System.out.println("locName: " + locName);
        System.out.println("locDescription: " + locDescription);
        System.out.println("File: " + filePart);

    
        // Check for null or empty parameters
        if (isNullOrEmpty(locId) || isNullOrEmpty(locName) || isNullOrEmpty(locDescription)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "UPDATE FMO_ITEM_LOCATIONS SET NAME = ?, DESCRIPTION = ?, IMAGE = ? WHERE ITEM_LOC_ID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, locName);
                stmt.setString(2, locDescription);

                // If an image file is uploaded, set the Blob parameter, else set it to null
                    if (filePart != null && filePart.getSize() > 0) {
                        InputStream inputStream = filePart.getInputStream();
                        stmt.setBinaryStream(3, inputStream, (int) filePart.getSize());
                    } else {
                        stmt.setNull(3, java.sql.Types.BLOB);
                    }


                stmt.setInt(4, Integer.parseInt(locId));

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    response.sendRedirect("buildingDashboard?locID=" + locId);
                    //response.sendRedirect("buildingdisplaycontroller?locID=" + locId);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Location not found");
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
