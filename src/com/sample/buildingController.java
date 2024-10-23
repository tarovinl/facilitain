package com.sample;

import sample.model.PooledConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/buildingController")
public class buildingController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String locID = request.getParameter("locID"); // locID is used for editing
        String locName = request.getParameter("locName");
        String locDescription = request.getParameter("locDescription");

        try (Connection conn = PooledConnection.getConnection()) {
            String sql;

            if (locID == null || locID.isEmpty()) {
                //  add new building if locID is not provided
                sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_LOCATIONS (NAME, DESCRIPTION) VALUES (?, ?)";
            } else {
                // Update existing building if locID is provided
                sql = "UPDATE C##FMO_ADM.FMO_ITEM_LOCATIONS SET NAME = ?, DESCRIPTION = ? WHERE ITEM_LOC_ID = ?";
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, locName);
                stmt.setString(2, locDescription);

                if (locID != null && !locID.isEmpty()) {
                    stmt.setInt(3, Integer.parseInt(locID)); // Set locID for the update
                }

                stmt.executeUpdate();
            }

            // Redirect to building dashboard after saving changes
            response.sendRedirect("buildingDashboard?locID=" + locID);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding/editing building.");
        }
    }
}
