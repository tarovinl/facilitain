package com.sample;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
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

        // Check if locName is null or empty
        if (locName == null || locName.trim().isEmpty()) {
            String errorMsg = URLEncoder.encode("Location name is required.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
            return;
        }
        
        // Validate character limit for locName (250 characters)
        if (locName.trim().length() > 250) {
            String errorMsg = URLEncoder.encode("Location name must not exceed 250 characters.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
            return;
        }
        
        // Validate character limit for locDescription (250 characters) - if provided
        if (locDescription != null && locDescription.trim().length() > 250) {
            String errorMsg = URLEncoder.encode("Location description must not exceed 250 characters.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
            return;
        }
        
        // Validate file size (10MB = 10 * 1024 * 1024 bytes)
        if (filePart != null && filePart.getSize() > 10 * 1024 * 1024) {
            String errorMsg = URLEncoder.encode("Image file size must not exceed 10MB.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
            return;
        }

        // Save the building data in the database, including the image as a BLOB
        try (Connection conn = PooledConnection.getConnection()) {
            
            // Check for duplicate location name
            if (isDuplicateLocationName(conn, locName.trim())) {
                String errorMsg = URLEncoder.encode("A location with this name already exists. Please choose a different name.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/homepage?error=duplicate&errorMsg=" + errorMsg);
                return;
            }

            // Get the highest ITEM_LOC_ID and increment it
            int newItemLocId = 1; // Default to 1 if there are no entries in the table
            String getMaxIdSql = "SELECT MAX(ITEM_LOC_ID) AS maxId FROM C##FMO_ADM.FMO_ITEM_LOCATIONS";
            try (PreparedStatement getMaxIdStmt = conn.prepareStatement(getMaxIdSql);
                 ResultSet rs = getMaxIdStmt.executeQuery()) {
                if (rs.next() && rs.getInt("maxId") > 0) {
                    newItemLocId = rs.getInt("maxId") + 1;
                }
            }

            // Insert new building
            String insertSql = "INSERT INTO C##FMO_ADM.FMO_ITEM_LOCATIONS (ITEM_LOC_ID, NAME, DESCRIPTION, ARCHIVED_FLAG, IMAGE) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setInt(1, newItemLocId); // Set the new ITEM_LOC_ID
                stmt.setString(2, locName.trim());
                stmt.setString(3, locDescription != null ? locDescription.trim() : "");
                stmt.setInt(4, 1);

                System.out.println("Executing SQL query: " + stmt);
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
                    // Set session attribute for success message
                    HttpSession session = request.getSession();
                    session.setAttribute("addLocationSuccess", true);
                } else {
                    System.out.println("No rows affected, insertion might have failed.");
                    String errorMsg = URLEncoder.encode("Failed to add location. Please try again.", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg;
            // Check if it's a unique constraint violation
            // Oracle error code for unique constraint: 1 (ORA-00001)
            if (e.getErrorCode() == 1) { 
                errorMsg = URLEncoder.encode("A location with this name already exists. Please choose a different name.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/homepage?error=duplicate&errorMsg=" + errorMsg);
            } else {
                errorMsg = URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8");
                response.sendRedirect(request.getContextPath() + "/homepage?error=true&errorMsg=" + errorMsg);
            }
            return;
        }
    
        response.sendRedirect(request.getContextPath() + "/homepage?action=added");
    }
    
    /**
     * Checks if a location name already exists)
     * @param conn Database connection
     * @param locationName Name to check
     * @return true if duplicate exists, false otherwise
     */
    private boolean isDuplicateLocationName(Connection conn, String locationName) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE UPPER(NAME) = UPPER(?) AND ARCHIVED_FLAG = 1";
        
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setString(1, locationName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
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