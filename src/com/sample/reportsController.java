package com.sample;

import sample.model.PooledConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/reportsController")
@MultipartConfig // Allows file uploads
public class reportsController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Collect form data
        String equipmentType = request.getParameter("equipmentType");
        String building = request.getParameter("building");
        String floor = request.getParameter("floor");
        String room = request.getParameter("room");
        String description = request.getParameter("suggestions");
        LocalDate reportDate = LocalDate.now();
        Part filePart = request.getPart("filename");

        String sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_REPORTS (EQUIPMENT_TYPE, BUILDING, FLOOR, ROOM, DESCRIPTION, REPORT_DATE, IMAGE) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            // Set parameters for the SQL query
            statement.setString(1, equipmentType);
            statement.setString(2, building);
            statement.setString(3, floor);
            statement.setString(4, room);
            statement.setString(5, description);
            statement.setDate(6, java.sql.Date.valueOf(reportDate));
            
            // Handle file upload
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream inputStream = filePart.getInputStream()) {
                    statement.setBlob(7, inputStream); // Insert the file as a blob
                }
            } else {
                statement.setNull(7, java.sql.Types.BLOB); // Handle case where no file is uploaded
            }

            // Execute update
            statement.executeUpdate();
            response.sendRedirect("reportsThanksClient.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while submitting the report.", e);
        }
    }
}
