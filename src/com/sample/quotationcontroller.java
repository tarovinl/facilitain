package com.sample;

import java.io.*;
import java.math.BigDecimal;
import java.sql.*;

import java.util.Arrays;
import java.util.Map;
import java.util.Random;
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

        PrintWriter out = response.getWriter();

        // Retrieve form fields and files
        String itemIDStr = request.getParameter("itemID");
        String description = request.getParameter("description");
        String locID = request.getParameter("locID");
        String floorName = request.getParameter("floorName");
        
        // Handle two file uploads
        Part filePart1 = request.getPart("quotationFile1");
        Part filePart2 = request.getPart("quotationFile2");
        
        Map<String, String[]> parameterMap = request.getParameterMap();
        for (String key : parameterMap.keySet()) {
            System.out.println("Parameter: " + key + " = " + Arrays.toString(parameterMap.get(key)));
        }
        
        BigDecimal itemID = (itemIDStr != null && !itemIDStr.isEmpty()) ? new BigDecimal(itemIDStr) : null;
        
        // Prepare file data for both files
        FileData file1Data = extractFileData(filePart1);
        FileData file2Data = extractFileData(filePart2);

        try (Connection conn = PooledConnection.getConnection()) {
            // Generate the next QUOTATION_ID
            BigDecimal quotationID = generateQuotationID(conn);

            if (itemID != null && description != null) {
                // At least one file must be uploaded
                if (file1Data.inputStream == null && file2Data.inputStream == null) {
                    out.println("Error: At least one file must be uploaded.");
                    return;
                }

                // Insert into the database
                if (insertIntoDatabase(conn, itemID, description, quotationID, file1Data, file2Data)) {
                    // Redirect to manageBuilding.jsp with the locID
                    response.sendRedirect("buildingDashboard?locID=" + locID + "/manage?floor=" + floorName);
                    return;
                } else {
                    out.println("Error inserting data into the database.");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Database connection error.");
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
            InputStream inputStream = filePart.getInputStream();
            String fileName = getFileName(filePart);
            String contentType = filePart.getContentType();
            return new FileData(inputStream, fileName, contentType);
        }
        return new FileData(null, null, null);
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
        return null;
    }
    
    private boolean insertIntoDatabase(Connection conn, BigDecimal itemID, String description, 
                                     BigDecimal quotationID, FileData file1Data, FileData file2Data) {
        String sql = "INSERT INTO FMO_ITEM_QUOTATIONS " +
                    "(ITEM_ID, DESCRIPTION, QUOTATION_ID, QUOTATION_FILE1, QUOTATION_FILE2, " +
                    "FILE1_NAME, FILE2_NAME, FILE1_TYPE, FILE2_TYPE, DATE_UPLOADED) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, itemID);
            pstmt.setString(2, description);
            pstmt.setBigDecimal(3, quotationID);
            
            // Set file 1 data
            if (file1Data.inputStream != null) {
                pstmt.setBlob(4, file1Data.inputStream);
                pstmt.setString(6, file1Data.fileName);
                pstmt.setString(8, file1Data.contentType);
            } else {
                pstmt.setNull(4, Types.BLOB);
                pstmt.setNull(6, Types.VARCHAR);
                pstmt.setNull(8, Types.VARCHAR);
            }
            
            // Set file 2 data
            if (file2Data.inputStream != null) {
                pstmt.setBlob(5, file2Data.inputStream);
                pstmt.setString(7, file2Data.fileName);
                pstmt.setString(9, file2Data.contentType);
            } else {
                pstmt.setNull(5, Types.BLOB);
                pstmt.setNull(7, Types.VARCHAR);
                pstmt.setNull(9, Types.VARCHAR);
            }
            
            pstmt.setTimestamp(10, new Timestamp(System.currentTimeMillis()));

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private BigDecimal generateQuotationID(Connection conn) {
        BigDecimal newID = BigDecimal.ONE; // Start with 1 if no records are found
        String query = "SELECT MAX(QUOTATION_ID) FROM FMO_ITEM_QUOTATIONS";

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
        }
        return newID;
    }
}