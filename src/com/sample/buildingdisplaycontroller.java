package com.sample;

import java.io.IOException;
import java.io.OutputStream;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sample.model.PooledConnection;

@WebServlet(name = "BuildingDisplayController", urlPatterns = { "/buildingdisplaycontroller" })
public class buildingdisplaycontroller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String locId = request.getParameter("locID");
        if (locId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing location ID");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "SELECT IMAGE FROM FMO_ITEM_LOCATIONS WHERE ITEM_LOC_ID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(locId));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Blob imageBlob = rs.getBlob("IMAGE");
                        if (imageBlob != null && imageBlob.length() > 0) {
                            byte[] imgData = imageBlob.getBytes(1, (int) imageBlob.length());
                            response.setContentType("image/jpeg");
                            response.setContentLength(imgData.length);
                            if (imageBlob != null && imageBlob.length() > 0) {
                                System.out.println("Blob size: " + imageBlob.length());
                            } else {
                                System.out.println("Blob is null or empty");
                            }
                            // Write the image to the response output stream
                            try (OutputStream out = response.getOutputStream()) {
                                out.write(imgData);
                            }
                        } else {
                            servePlaceholderImage(response);
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "No record found");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving image");
        }
    }

    // Method to serve the placeholder image
    private void servePlaceholderImage(HttpServletResponse response) throws IOException {
        Path placeholderPath = Paths.get(getServletContext().getRealPath("/resources/images/samplebuilding.jpg"));
        if (Files.exists(placeholderPath)) {
            response.setContentType("image/jpeg");
            response.setContentLength((int) Files.size(placeholderPath));

            // Write the placeholder image to the response output stream
            try (OutputStream out = response.getOutputStream()) {
                Files.copy(placeholderPath, out);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Placeholder image not found");
        }
    }
}