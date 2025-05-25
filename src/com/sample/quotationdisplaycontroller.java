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

@WebServlet(name = "quotationdisplaycontroller", urlPatterns = { "/quotationdisplaycontroller", "/quotationImage" })
public class quotationdisplaycontroller extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                          IOException {
        String path = request.getServletPath();

        if (path.equals("/quotationImage")) {
            // Handle the image view request
            serveQuotationImage(request, response);
        } else {
            // Handle the default request to display quotations
            displayQuotations(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                          IOException {
            updateArchiveFlag(request, response);
    }
    
    private void updateArchiveFlag(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationIdParam = request.getParameter("quotationId");
        
        System.out.println("Archive request for quotation ID: " + quotationIdParam);
        String referer = request.getHeader("Referer");

        if (quotationIdParam == null || quotationIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quotation ID is required");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            String updateQuery = "UPDATE C##FMO_ADM.FMO_ITEM_QUOTATIONS SET ARCHIVED_FLAG = 2 WHERE QUOTATION_ID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                pstmt.setInt(1, Integer.parseInt(quotationIdParam));

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("Successfully archived quotation ID: " + quotationIdParam);
                    if (referer != null) {
                        response.sendRedirect(referer);
                    } else {
                        response.setStatus(HttpServletResponse.SC_OK);
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("Quotation not found for ID: " + quotationIdParam);
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Quotation ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }

    private void displayQuotations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemIDParam = request.getParameter("itemID");
        
        if (itemIDParam == null || itemIDParam.isEmpty()) {
            response.getWriter().write("<tr><td colspan='5'>Invalid item ID.</td></tr>");
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
                    htmlContent.append("<td>").append(quotation.getQuotationId()).append("</td>");
                    htmlContent.append("<td>").append(quotation.getDescription()).append("</td>");
                    htmlContent.append("<td>").append(quotation.getDateUploaded()).append("</td>");
                    
                    // Add the "View" button
                    htmlContent.append("<td><a href='quotationImage?quotationId=").append(quotation.getQuotationId())
                              .append("' target='_blank' class='btn btn-primary btn-sm' title='View Quotation Image'>View</a></td>");
                    
                    // Add the "Archive" button inside a form
                    htmlContent.append("<td>");
                    htmlContent.append("<form method='post' id='archiveForm").append(quotation.getQuotationId()).append("' action='quotationdisplaycontroller'>");
                    htmlContent.append("<input type='hidden' name='quotationId' value='").append(quotation.getQuotationId()).append("' />");
                    htmlContent.append("<button type='button' class='btn btn-danger archive-btn' data-quotation-id='")
                        .append(quotation.getQuotationId()).append("' onclick='confirmArchive(")
                        .append(quotation.getQuotationId()).append(")'>Archive</button>");
                    htmlContent.append("</form></td>");
                    htmlContent.append("</tr>");
                }
            } else {
                htmlContent.append("<tr><td colspan='5'>No quotations available for this item.</td></tr>");
            }

            response.setContentType("text/html");
            response.getWriter().write(htmlContent.toString());

        } catch (NumberFormatException e) {
            System.out.println("Invalid itemID format: " + itemIDParam);
            response.getWriter().write("<tr><td colspan='5'>Invalid item ID format.</td></tr>");
        }
    }

    // New method to fetch quotations directly from database
    private ArrayList<Quotation> fetchQuotationsFromDatabase(int itemID) {
        ArrayList<Quotation> quotations = new ArrayList<>();
        String query = "SELECT QUOTATION_ID, ITEM_ID, DESCRIPTION, DATE_UPLOADED, QUOTATION_IMAGE, ARCHIVED_FLAG " +
                      "FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS WHERE ITEM_ID = ? AND (ARCHIVED_FLAG IS NULL OR ARCHIVED_FLAG = 1)";

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
                    quotation.setQuotationImage(rs.getBytes("QUOTATION_IMAGE"));
                    
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

    private void serveQuotationImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationIdParam = request.getParameter("quotationId");

        if (quotationIdParam == null || quotationIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quotation ID is required");
            return;
        }

        try {
            int quotationId = Integer.parseInt(quotationIdParam);
            
            // Fetch the specific quotation image from database
            byte[] imageBytes = fetchQuotationImageFromDatabase(quotationId);
            
            if (imageBytes == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for this quotation");
                return;
            }

            // Set the content type and write the image bytes to the response
            response.setContentType("image/jpeg"); // or determine type dynamically
            response.setContentLength(imageBytes.length);
            OutputStream out = response.getOutputStream();
            out.write(imageBytes);
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Quotation ID format");
        }
    }
    
    // New method to fetch quotation image from database
    private byte[] fetchQuotationImageFromDatabase(int quotationId) {
        String query = "SELECT QUOTATION_IMAGE FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS WHERE QUOTATION_ID = ?";
        
        try (Connection conn = PooledConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, quotationId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBytes("QUOTATION_IMAGE");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error fetching quotation image: " + e.getMessage());
        }
        
        return null;
    }
}