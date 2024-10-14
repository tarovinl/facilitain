package com.sample;

import sample.model.Location;
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

@WebServlet("/addBuilding")
public class addBuilding extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String locName = request.getParameter("locName");
        String locDescription = request.getParameter("locDescription");

        try (Connection conn = PooledConnection.getConnection()) {
            // Insert location into the database, referencing the schema and table explicitly
            String sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_LOCATIONS (NAME, DESCRIPTION) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, locName);
                stmt.setString(2, locDescription);

                stmt.executeUpdate();
            }

            // Redirect to homepage 
            response.sendRedirect("homepage");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding building.");
        }
    }
}
