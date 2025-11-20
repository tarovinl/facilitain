package com.sample;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import sample.model.Quotation;
import sample.model.PooledConnection;

@WebServlet(name = "quotationdisplaycontroller", urlPatterns = { "/quotationdisplaycontroller", "/quotationFile" })
public class quotationdisplaycontroller extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=UTF-8";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/quotationFile")) {
            // Handle the file view request
            serveQuotationFile(request, response);
        } else {
            // Handle the default request to display quotations
            displayQuotations(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        updateArchiveFlag(request, response);
    }
    
    private void updateArchiveFlag(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationIdParam = request.getParameter("quotationId");
        
        System.out.println("Archive request for quotation ID: " + quotationIdParam);

        if (quotationIdParam == null || quotationIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Quotation ID is required");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            String updateQuery = "UPDATE C##FMO_ADM.FMO_ITEM_QUOTATIONS SET ARCHIVED_FLAG = 2 WHERE QUOTATION_ID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                pstmt.setInt(1, Integer.parseInt(quotationIdParam));

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("Successfully archived quotation ID: " + quotationIdParam);
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Success");
                } else {
                    System.out.println("No quotation found with ID: " + quotationIdParam);
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("Quotation not found");
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid quotation ID format: " + quotationIdParam);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid Quotation ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Database error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error occurred");
        }
    }

    private void displayQuotations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemIDParam = request.getParameter("itemID");
        
        if (itemIDParam == null || itemIDParam.isEmpty()) {
            response.setContentType(CONTENT_TYPE);
            response.getWriter().write("<tr><td colspan='5' class='text-center'>Invalid item ID.</td></tr>");
            return;
        }

        try {
            int itemID = Integer.parseInt(itemIDParam);
            System.out.println("Fetching quotations for item ID: " + itemID);

            // Fetch quotations directly from database
            ArrayList<Quotation> quotations = fetchQuotationsFromDatabase(itemID);
            System.out.println("Found " + quotations.size() + " quotations for item ID: " + itemID);

            // Generate HTML content
            StringBuilder htmlContent = new StringBuilder();
            if (!quotations.isEmpty()) {
                for (Quotation quotation : quotations) {
                    htmlContent.append("<tr>");
                    htmlContent.append("<td>").append(escapeHtml(String.valueOf(quotation.getQuotationId()))).append("</td>");
                    
                    // Description with popover
                    htmlContent.append("<td>");
                    htmlContent.append("<div class='description-cell'>");
                    htmlContent.append("<span class='description-text' title='").append(escapeHtml(quotation.getDescription())).append("'>");
                    htmlContent.append(escapeHtml(quotation.getDescription())).append("</span>");
                    if (quotation.getDescription() != null && !quotation.getDescription().isEmpty()) {
                        htmlContent.append("<button class='btn btn-sm description-btn' ");
                        htmlContent.append("type='button' ");
                        htmlContent.append("data-bs-toggle='popover' ");
                        htmlContent.append("data-bs-placement='left' ");
                        htmlContent.append("data-bs-trigger='click' ");
                        htmlContent.append("data-bs-content='").append(escapeHtml(quotation.getDescription())).append("' ");
                        htmlContent.append("title='Full Description'>");
                        htmlContent.append("...");
                        htmlContent.append("</button>");
                    }
                    htmlContent.append("</div>");
                    htmlContent.append("</td>");
                    
                    htmlContent.append("<td>").append(quotation.getDateUploaded()).append("</td>");
                    
                    // Add file view buttons
                    htmlContent.append("<td>");
                    if (quotation.getQuotationFile1() != null) {
                        String file1Name = quotation.getFile1Name() != null ? escapeHtml(quotation.getFile1Name()) : "File 1";
                        htmlContent.append("<a href='quotationFile?quotationId=").append(quotation.getQuotationId())
                                  .append("&fileNum=1' target='_blank' class='btn btn-primary btn-sm me-1' title='View File 1'>")
                                  .append(file1Name)
                                  .append("</a>");
                    }
                    if (quotation.getQuotationFile2() != null) {
                        String file2Name = quotation.getFile2Name() != null ? escapeHtml(quotation.getFile2Name()) : "File 2";
                        htmlContent.append("<a href='quotationFile?quotationId=").append(quotation.getQuotationId())
                                  .append("&fileNum=2' target='_blank' class='btn btn-info btn-sm' title='View File 2'>")
                                  .append(file2Name)
                                  .append("</a>");
                    }
                    if (quotation.getQuotationFile1() == null && quotation.getQuotationFile2() == null) {
                        htmlContent.append("<span class='text-muted'>No files</span>");
                    }
                    htmlContent.append("</td>");
                    
                    // Add the "Archive" button inside a form with yellow background
                    htmlContent.append("<td>");
                    htmlContent.append("<button type='button' style='background-color: #ffc107;' ");
                    htmlContent.append("class='buttonsBuilding px-3 py-2 rounded-1 hover-outline d-flex align-items-center archive-btn' ");
                    htmlContent.append("onclick='confirmArchive(").append(quotation.getQuotationId()).append(")'>");
                    htmlContent.append("<img src='resources/images/icons/archive.svg' class='pe-2' alt='archive icon' width='20' height='20'>");
                    htmlContent.append("Archive</button>");
                    htmlContent.append("</td>");
                }
            } else {
                htmlContent.append("<tr><td colspan='5' class='text-center text-muted'>No quotations available for this item.</td></tr>");
            }

            response.setContentType(CONTENT_TYPE);
            response.getWriter().write(htmlContent.toString());

        } catch (NumberFormatException e) {
            System.out.println("Invalid itemID format: " + itemIDParam);
            response.setContentType(CONTENT_TYPE);
            response.getWriter().write("<tr><td colspan='5' class='text-center text-danger'>Invalid item ID format.</td></tr>");
        }
    }

    // Updated method to fetch quotations with file information
    private ArrayList<Quotation> fetchQuotationsFromDatabase(int itemID) {
        ArrayList<Quotation> quotations = new ArrayList<>();
        String query = "SELECT QUOTATION_ID, ITEM_ID, DESCRIPTION, DATE_UPLOADED, " +
                      "QUOTATION_FILE1, QUOTATION_FILE2, FILE1_NAME, FILE2_NAME, " +
                      "FILE1_TYPE, FILE2_TYPE, ARCHIVED_FLAG " +
                      "FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS WHERE ITEM_ID = ? AND (ARCHIVED_FLAG IS NULL OR ARCHIVED_FLAG = 1) " +
                      "ORDER BY DATE_UPLOADED DESC";

        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, itemID);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Quotation quotation = new Quotation();
                    quotation.setQuotationId(rs.getInt("QUOTATION_ID"));
                    quotation.setItemId(rs.getInt("ITEM_ID"));
                    quotation.setDescription(rs.getString("DESCRIPTION"));
                    quotation.setDateUploaded(rs.getTimestamp("DATE_UPLOADED"));
                    
                    // Set file data
                    quotation.setQuotationFile1(rs.getBytes("QUOTATION_FILE1"));
                    quotation.setQuotationFile2(rs.getBytes("QUOTATION_FILE2"));
                    quotation.setFile1Name(rs.getString("FILE1_NAME"));
                    quotation.setFile2Name(rs.getString("FILE2_NAME"));
                    quotation.setFile1Type(rs.getString("FILE1_TYPE"));
                    quotation.setFile2Type(rs.getString("FILE2_TYPE"));
                    
                    // Handle ARCHIVED_FLAG (might be null)
                    int archiveFlag = rs.getInt("ARCHIVED_FLAG");
                    if (rs.wasNull()) {
                        archiveFlag = 1; // Default to active if null
                    }
                    quotation.setArchiveFlag(archiveFlag);
                    
                    quotations.add(quotation);
                    System.out.println("Loaded quotation: ID=" + quotation.getQuotationId() + 
                                     ", ItemID=" + quotation.getItemId() + 
                                     ", ArchiveFlag=" + quotation.getArchiveFlag());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error fetching quotations from database: " + e.getMessage());
        }
        
        return quotations;
    }

    private void serveQuotationFile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationIdParam = request.getParameter("quotationId");
        String fileNumParam = request.getParameter("fileNum");

        if (quotationIdParam == null || quotationIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quotation ID is required");
            return;
        }
        
        if (fileNumParam == null || fileNumParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File number is required");
            return;
        }

        try {
            int quotationId = Integer.parseInt(quotationIdParam);
            int fileNum = Integer.parseInt(fileNumParam);
            
            if (fileNum != 1 && fileNum != 2) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File number must be 1 or 2");
                return;
            }
            
            // Fetch the specific quotation file from database
            FileInfo fileInfo = fetchQuotationFileFromDatabase(quotationId, fileNum);
            
            if (fileInfo == null || fileInfo.fileData == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No file found for this quotation");
                return;
            }

            // Set the content type based on the stored file type
            String contentType = fileInfo.contentType;
            if (contentType == null || contentType.isEmpty()) {
                // Default content type based on file extension if not stored
                if (fileInfo.fileName != null) {
                    if (fileInfo.fileName.toLowerCase().endsWith(".pdf")) {
                        contentType = "application/pdf";
                    } else if (fileInfo.fileName.toLowerCase().endsWith(".png")) {
                        contentType = "image/png";
                    } else if (fileInfo.fileName.toLowerCase().endsWith(".gif")) {
                        contentType = "image/gif";
                    } else {
                        contentType = "image/jpeg"; // Default for images
                    }
                } else {
                    contentType = "application/octet-stream";
                }
            }
            
            response.setContentType(contentType);
            response.setContentLength(fileInfo.fileData.length);
            
            // Set filename for download/inline display
            if (fileInfo.fileName != null) {
                // Use inline for PDF and images so they display in browser
                String disposition = contentType.contains("pdf") || contentType.contains("image") ? "inline" : "attachment";
                response.setHeader("Content-Disposition", disposition + "; filename=\"" + fileInfo.fileName + "\"");
            }
            
            OutputStream out = response.getOutputStream();
            out.write(fileInfo.fileData);
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Quotation ID or File Number format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving file");
        }
    }
    
    // Helper class to hold file information
    private static class FileInfo {
        byte[] fileData;
        String fileName;
        String contentType;
        
        FileInfo(byte[] fileData, String fileName, String contentType) {
            this.fileData = fileData;
            this.fileName = fileName;
            this.contentType = contentType;
        }
    }
    
    // Updated method to fetch quotation file from database
    private FileInfo fetchQuotationFileFromDatabase(int quotationId, int fileNum) {
        String columnName = (fileNum == 1) ? "QUOTATION_FILE1" : "QUOTATION_FILE2";
        String nameColumn = (fileNum == 1) ? "FILE1_NAME" : "FILE2_NAME";
        String typeColumn = (fileNum == 1) ? "FILE1_TYPE" : "FILE2_TYPE";
        
        String query = "SELECT " + columnName + ", " + nameColumn + ", " + typeColumn + 
                      " FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS WHERE QUOTATION_ID = ?";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, quotationId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    byte[] fileData = rs.getBytes(columnName);
                    String fileName = rs.getString(nameColumn);
                    String contentType = rs.getString(typeColumn);
                    return new FileInfo(fileData, fileName, contentType);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error fetching quotation file: " + e.getMessage());
        }
        
        return null;
    }
    
    // Helper method to escape HTML to prevent XSS
    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
}