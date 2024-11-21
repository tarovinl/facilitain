package com.sample;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.PooledConnection;

@WebServlet(name = "addBuildingController", urlPatterns = { "/addbuildingcontroller" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class addBuildingController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure correct content type is set
        response.setContentType(CONTENT_TYPE);

        // Get parameters from request
        String locName = request.getParameter("locName");
        String locDescription = request.getParameter("locDescription");
        Part filePart = request.getPart("buildingImage"); // Get the image part from the form

        // Debugging output
        System.out.println("Received Parameters:");
        System.out.println("locName: " + locName);
        System.out.println("locDescription: " + locDescription);
        if (filePart != null) {
            System.out.println("File Name: " + filePart.getSubmittedFileName());
            System.out.println("File Size: " + filePart.getSize());
        } else {
            System.out.println("No file received for buildingImage.");
        }

        // Check if locName and locDescription are null
        if (locName == null || locDescription == null || locName.trim().isEmpty() || locDescription.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Building Name and Description are required fields.");
            request.getRequestDispatcher("/homepage.jsp").forward(request, response);
            return;
        }

        // Save the building data in the database, including the image as a BLOB
        try (Connection conn = PooledConnection.getConnection()) {

            // Get the highest ITEM_LOC_ID and increment it
            int newItemLocId = 1; // Default to 1 if there are no entries in the table
            String getMaxIdSql = "SELECT MAX(ITEM_LOC_ID) AS maxId FROM FMO_ITEM_LOCATIONS";
            try (PreparedStatement getMaxIdStmt = conn.prepareStatement(getMaxIdSql);
                 ResultSet rs = getMaxIdStmt.executeQuery()) {
                if (rs.next() && rs.getInt("maxId") > 0) {
                    newItemLocId = rs.getInt("maxId") + 1;
                }
            }

            // Insert new building
            String insertSql = "INSERT INTO FMO_ITEM_LOCATIONS (ITEM_LOC_ID, NAME, DESCRIPTION, ARCHIVED_FLAG, IMAGE) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setInt(1, newItemLocId); // Set the new ITEM_LOC_ID
                stmt.setString(2, locName);
                stmt.setString(3, locDescription);
                stmt.setInt(4, 1); // Assuming 1 means active (not archived)

                // Handle file upload if there's an image provided
                if (filePart != null && filePart.getSize() > 0) {
                    stmt.setBinaryStream(5, filePart.getInputStream(), filePart.getSize());
                } else {
                    stmt.setNull(5, java.sql.Types.BLOB);
                }

                // Execute the update
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    System.out.println("Building added successfully with ITEM_LOC_ID: " + newItemLocId);
                } else {
                    System.out.println("No rows affected, insertion might have failed.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding building: " + e.getMessage());
            request.getRequestDispatcher("/homepage.jsp").forward(request, response);
            return;
        }

        // Redirect to the homepage after successful addition
        response.sendRedirect(request.getContextPath() + "/homepage");
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>addBuildingController</title></head>");
        out.println("<body>");
        out.println("<p>The servlet has received a GET. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
