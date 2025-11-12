package com.sample;

import java.io.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Arrays;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import sample.model.PooledConnection;

@WebServlet(name = "quotationcontroller", urlPatterns = { "/quotationcontroller" })
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10 MB file size limit
public class quotationcontroller extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Retrieve form fields and files
        String itemIDStr = request.getParameter("itemID");
        String description = request.getParameter("description");
        String locID = request.getParameter("locID");
        String floorName = request.getParameter("floorName");
        
        // Handle two file uploads
        Part filePart1 = request.getPart("quotationFile1");
        Part filePart2 = request.getPart("quotationFile2");
        
        System.out.println("Received quotation upload request for itemID: " + itemIDStr);
        System.out.println("Description: " + description);
        System.out.println("locID: " + locID);
        System.out.println("floorName: " + floorName);
        
        BigDecimal itemID = (itemIDStr != null && !itemIDStr.isEmpty()) ? new BigDecimal(itemIDStr) : null;
        
        // Validate required fields
        if (itemID == null) {
            System.out.println("ERROR: Item ID is null or empty");
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=Item ID is required&itemID=" + itemIDStr);
            return;
        }
        
        if (description == null || description.trim().isEmpty()) {
            System.out.println("ERROR: Description is null or empty");
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=Description is required&itemID=" + itemIDStr);
            return;
        }
        
        // Prepare file data for both files
        FileData file1Data = null;
        FileData file2Data = null;
        
        try {
            file1Data = extractFileData(filePart1);
            file2Data = extractFileData(filePart2);
        } catch (IOException e) {
            System.out.println("ERROR: File extraction failed - " + e.getMessage());
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=" + e.getMessage() + "&itemID=" + itemIDStr);
            return;
        }

        // At least one file must be uploaded
        if (file1Data.inputStream == null && file2Data.inputStream == null) {
            System.out.println("ERROR: No files uploaded");
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=At least one file must be uploaded&itemID=" + itemIDStr);
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            // Generate the next QUOTATION_ID
            BigDecimal quotationID = generateQuotationID(conn);
            
            System.out.println("Generated quotation ID: " + quotationID);

            // Insert into the database
            if (insertIntoDatabase(conn, itemID, description, quotationID, file1Data, file2Data)) {
                System.out.println("Successfully inserted quotation for item ID: " + itemID);
                // Redirect with success message
                response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                    "&uploadResult=success&uploadMessage=Quotation uploaded successfully&itemID=" + itemIDStr);
            } else {
                System.out.println("Failed to insert quotation for item ID: " + itemID);
                response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                    "&uploadResult=error&uploadMessage=Failed to save quotation to database&itemID=" + itemIDStr);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Database error while inserting quotation: " + e.getMessage());
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=Database error occurred&itemID=" + itemIDStr);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Unexpected error while processing quotation: " + e.getMessage());
            response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName + 
                                "&uploadResult=error&uploadMessage=An unexpected error occurred&itemID=" + itemIDStr);
        }
    }

    // Helper class to hold file data
    private static class FileData {
        InputStream inputStream;
        String fileName;
        String contentType;
        
        FileData(InputStream inputStream, String fileName, String contentType) {
            this.inputStream = inputStream;
            this.fileName = fileName;
            this.contentType = contentType;
        }
    }
    
    // Extract file data from Part
    private FileData extractFileData(Part filePart) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            // Validate file size (10MB limit)
            if (filePart.getSize() > 10 * 1024 * 1024) {
                throw new IOException("File size exceeds 10MB limit");
            }
            
            InputStream inputStream = filePart.getInputStream();
            String fileName = getFileName(filePart);
            String contentType = filePart.getContentType();
            
            // Validate file type
            if (!isValidFileType(contentType, fileName)) {
                throw new IOException("Invalid file type. Only PDF, JPG, and PNG files are allowed");
            }
            
            System.out.println("Extracted file: " + fileName + " (" + contentType + ") - Size: " + filePart.getSize() + " bytes");
            
            return new FileData(inputStream, fileName, contentType);
        }
        return new FileData(null, null, null);
    }
    
    // Validate file type
    private boolean isValidFileType(String contentType, String fileName) {
        if (contentType == null) return false;
        
        String[] allowedTypes = {"application/pdf", "image/jpeg", "image/jpg", "image/png", "image/gif", "image/bmp", "image/tiff"};
        for (String type : allowedTypes) {
            if (contentType.toLowerCase().contains(type.toLowerCase())) {
                return true;
            }
        }
        
        // Also check file extension as backup
        if (fileName != null) {
            String ext = fileName.toLowerCase();
            return ext.endsWith(".pdf") || ext.endsWith(".jpg") || ext.endsWith(".jpeg") || 
                   ext.endsWith(".png") || ext.endsWith(".gif") || ext.endsWith(".bmp") || ext.endsWith(".tiff");
        }
        
        return false;
    }
    
    // Get original filename from Part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "unknown";
    }
    
    private boolean insertIntoDatabase(Connection conn, BigDecimal itemID, String description, 
                                     BigDecimal quotationID, FileData file1Data, FileData file2Data) {
        String sql = "INSERT INTO FMO_ADM.FMO_ITEM_QUOTATIONS " +
                    "(ITEM_ID, DESCRIPTION, QUOTATION_ID, QUOTATION_FILE1, QUOTATION_FILE2, " +
                    "FILE1_NAME, FILE2_NAME, FILE1_TYPE, FILE2_TYPE, DATE_UPLOADED, ARCHIVED_FLAG) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, itemID);
            pstmt.setString(2, description.trim());
            pstmt.setBigDecimal(3, quotationID);
            
            // Set file 1 data
            if (file1Data.inputStream != null) {
                pstmt.setBlob(4, file1Data.inputStream);
                pstmt.setString(6, file1Data.fileName);
                pstmt.setString(8, file1Data.contentType);
                System.out.println("File 1 set: " + file1Data.fileName);
            } else {
                pstmt.setNull(4, Types.BLOB);
                pstmt.setNull(6, Types.VARCHAR);
                pstmt.setNull(8, Types.VARCHAR);
                System.out.println("File 1: NULL");
            }
            
            // Set file 2 data
            if (file2Data.inputStream != null) {
                pstmt.setBlob(5, file2Data.inputStream);
                pstmt.setString(7, file2Data.fileName);
                pstmt.setString(9, file2Data.contentType);
                System.out.println("File 2 set: " + file2Data.fileName);
            } else {
                pstmt.setNull(5, Types.BLOB);
                pstmt.setNull(7, Types.VARCHAR);
                pstmt.setNull(9, Types.VARCHAR);
                System.out.println("File 2: NULL");
            }
            
            pstmt.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(11, 1); // Set ARCHIVED_FLAG to 1 (active)

            int rowsInserted = pstmt.executeUpdate();
            System.out.println("Rows inserted: " + rowsInserted);
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error inserting quotation: " + e.getMessage());
            return false;
        }
    }

    private BigDecimal generateQuotationID(Connection conn) {
        BigDecimal newID = BigDecimal.ONE; // Start with 1 if no records are found
        String query = "SELECT MAX(QUOTATION_ID) FROM FMO_ADM.FMO_ITEM_QUOTATIONS";

        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                BigDecimal maxID = rs.getBigDecimal(1);
                if (maxID != null) {
                    newID = maxID.add(BigDecimal.ONE);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error generating quotation ID: " + e.getMessage());
        }
        return newID;
    }
}