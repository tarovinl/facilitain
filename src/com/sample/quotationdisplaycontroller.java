package com.sample;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.Quotation;

@WebServlet(name = "quotationdisplaycontroller", urlPatterns = { "/quotationdisplaycontroller", "/quotationImage" })
public class quotationdisplaycontroller extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/quotationImage")) {
            // Handle the image view request
            serveQuotationImage(request, response);
        } else {
            // Handle the default request to display quotations
            displayQuotations(request, response);
        }
    }

    private void displayQuotations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemIDParam = request.getParameter("itemID");
        System.out.println("Item ID parameter received: " + itemIDParam);

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
                        filteredQuotations.add(quotation);
                    }
                }

                System.out.println("Filtered Quotations Count: " + filteredQuotations.size());

            } catch (NumberFormatException e) {
                System.out.println("Invalid itemID format: " + itemIDParam);
            }
        }

        // Generate the HTML content for the filtered quotations
        StringBuilder htmlContent = new StringBuilder();
        if (!filteredQuotations.isEmpty()) {
            for (Quotation quotation : filteredQuotations) {
                htmlContent.append("<tr>");
                htmlContent.append("<td>").append(quotation.getQuotationId()).append("</td>");
                htmlContent.append("<td>").append(quotation.getDescription()).append("</td>");
                htmlContent.append("<td>").append(quotation.getDateUploaded()).append("</td>");
                htmlContent.append("<td><a href='quotationImage?quotationId=").append(quotation.getQuotationId())
                          .append("' target='_blank' class='btn btn-primary btn-sm'>View</a></td>");
                htmlContent.append("</tr>");
            }
        } else {
            htmlContent.append("<tr><td colspan='4'>No quotations available for this item.</td></tr>");
        }

        response.setContentType("text/html");
        response.getWriter().write(htmlContent.toString());
    }

    private void serveQuotationImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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