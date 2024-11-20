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
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB file size limit
public class quotationcontroller extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        PrintWriter out = response.getWriter();

        // Retrieve form fields and file
        String itemIDStr = request.getParameter("itemID");
        String description = request.getParameter("description");
        String locID = request.getParameter("locID"); // Get the locID from the request
        String floorName = request.getParameter("floorName");
        Part filePart = request.getPart("quotationFile");
        Map<String, String[]> parameterMap = request.getParameterMap();
                  for (String key : parameterMap.keySet()) {
                      System.out.println("Parameter: " + key + " = " + Arrays.toString(parameterMap.get(key)));
                  }
        BigDecimal itemID = (itemIDStr != null && !itemIDStr.isEmpty()) ? new BigDecimal(itemIDStr) : null;
        InputStream fileInputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileInputStream = filePart.getInputStream();
        }

        try (Connection conn = PooledConnection.getConnection()) {
            // Generate the next QUOTATION_ID
            BigDecimal quotationID = generateQuotationID(conn);

            if (itemID != null && description != null) {
                // Check if the file input stream is empty or null
                if (fileInputStream == null || fileInputStream.available() == 0) {
                    fileInputStream = null; // Set it to null if no file was uploaded
                }

                // Insert into the database
                if (insertIntoDatabase(conn, itemID, description, quotationID, fileInputStream)) {
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

    
    private boolean insertIntoDatabase(Connection conn, BigDecimal itemID, String description, BigDecimal quotationID, InputStream fileInputStream) {
        String sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_QUOTATIONS (ITEM_ID, DESCRIPTION, QUOTATION_ID, QUOTATION_IMAGE, DATE_UPLOADED) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, itemID);
            pstmt.setString(2, description);
            pstmt.setBigDecimal(3, quotationID);
            pstmt.setBlob(4, fileInputStream);
            pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    private BigDecimal generateQuotationID(Connection conn) {
        BigDecimal newID = BigDecimal.ONE; // Start with 1 if no records are found
        String query = "SELECT MAX(QUOTATION_ID) FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS";

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
