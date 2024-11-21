package com.sample;

import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "reportimageviewer", urlPatterns = {"/viewImage"})
public class reportimageviewer extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportId = request.getParameter("reportId");
        if (reportId == null || reportId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report ID");
            return;
        }

        try (Connection connection = PooledConnection.getConnection()) {
            String query = "SELECT REPORT_PICTURE FROM C##FMO_ADM.FMO_ITEM_REPORTS WHERE REPORT_ID = ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(reportId));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        byte[] imageBytes = rs.getBytes("REPORT_PICTURE");
                        if (imageBytes != null) {
                            response.setContentType("image/jpeg");
                            response.setContentLength(imageBytes.length);
                            OutputStream os = response.getOutputStream();
                            os.write(imageBytes);
                            os.flush();
                        } else {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image available");
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving image");
        }
    }
}