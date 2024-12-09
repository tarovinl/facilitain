package com.sample;

import java.io.IOException;
import java.io.OutputStream;

import java.sql.Connection;

import java.util.ArrayList;

import javax.servlet.annotation.WebServlet;

import java.sql.PreparedStatement;

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
        
        System.out.println("HI " + quotationIdParam);
        // Get the referring URL from the "Referer" header
            String referer = request.getHeader("Referer");

            if (referer != null) {
                System.out.println("Referring URL: " + referer);
            } else {
                System.out.println("No referring URL available.");
            }

        if (quotationIdParam == null || quotationIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quotation ID is required");
            return;
        }

        try (Connection conn = PooledConnection.getConnection()) {
            // SQL query to update the archiveFlag
            String updateQuery = "UPDATE FMO_ADM.FMO_ITEM_QUOTATIONS SET ARCHIVED_FLAG = 2 WHERE QUOTATION_ID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                pstmt.setInt(1, Integer.parseInt(quotationIdParam));

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    System.out.println("CHANGED TO 2 !!!! the quot id " + quotationIdParam);
                    response.sendRedirect(referer);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("Quotation not found for ID: " + quotationIdParam);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while updating the archive flag.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Quotation ID format");
        }
    }
    

    private void displayQuotations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          String itemIDParam = request.getParameter("itemID");

          // Retrieve quotations list from servlet context
          ArrayList<Quotation> allQuotations = (ArrayList<Quotation>) getServletContext().getAttribute("quotations");
          if (allQuotations == null) {
              System.out.println("No quotations found in the servlet context.");
              allQuotations = new ArrayList<>(); // Initialize an empty list to prevent NullPointerException
          } else {
              System.out.println("Total quotations retrieved from context: " + allQuotations.size());
          }

          ArrayList<Quotation> filteredQuotations = new ArrayList<>();
          if (itemIDParam != null && !itemIDParam.isEmpty()) {
              try {
                  int itemID = Integer.parseInt(itemIDParam);
                  System.out.println("Filtering quotations for item ID: " + itemID);

                  // Filter the quotations based on item ID
                  for (Quotation quotation : allQuotations) {
                      if (quotation.getItemId() == itemID) {
                          if(quotation.getArchiveFlag() == 1){
                          filteredQuotations.add(quotation);
                          }
                      }
                  }

                  System.out.println("Filtered Quotations Count: " + filteredQuotations.size());

              } catch (NumberFormatException e) {
                  System.out.println("Invalid itemID format: " + itemIDParam);
              }
          }

          // Generate the HTML content for the filtered quotations
          // Generate the HTML content for the filtered quotations
          StringBuilder htmlContent = new StringBuilder();
          if (!filteredQuotations.isEmpty()) {
              for (Quotation quotation : filteredQuotations) {
                  if (quotation.getArchiveFlag() != 1) {
                      continue; // Skip this row if archiveFlag is not 1
                  }

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
                  htmlContent.append("</form> </td>");




                  htmlContent.append("</tr>");
              }
          } else {
              htmlContent.append("<tr><td colspan='5'>No quotations available for this item.</td></tr>");
          }

          response.setContentType("text/html");
          response.getWriter().write(htmlContent.toString());
      }

    private void serveQuotationImage(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                                      IOException {
        String quotationIdParam = request.getParameter("quotationId");

        if (quotationIdParam == null || quotationIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quotation ID is required");
            return;
        }

        try {
            int quotationId = Integer.parseInt(quotationIdParam);
            ArrayList<Quotation> allQuotations = (ArrayList<Quotation>) getServletContext().getAttribute("quotations");
            if (allQuotations == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No quotations found");
                return;
            }

            // Find the quotation by ID
            Quotation selectedQuotation = null;
            for (Quotation quotation : allQuotations) {
                if (quotation.getQuotationId() == quotationId) {
                    selectedQuotation = quotation;
                    break;
                }
            }

            if (selectedQuotation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quotation not found");
                return;
            }

            byte[] imageBytes = selectedQuotation.getQuotationImage();
            if (imageBytes == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for this quotation");
                return;
            }

            // Set the content type and write the image bytes to the response
            response.setContentType("image/jpeg"); // or "image/png" depending on the image type
            response.setContentLength(imageBytes.length);
            OutputStream out = response.getOutputStream();
            out.write(imageBytes);
            out.flush();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Quotation ID format");
        }
    }
}