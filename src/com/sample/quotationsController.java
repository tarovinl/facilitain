package com.sample;

import sample.model.Quotation;
import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/quotations")
@MultipartConfig
public class quotationsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Quotation> quotations = new ArrayList<>();

        try (Connection connection = PooledConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery("SELECT QUOTATION_ID, DESCRIPTION, DATE_UPLOADED, ITEM_ID, QUOTATION_IMAGE FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS")) {

            while (resultSet.next()) {
                int quotationId = resultSet.getInt("QUOTATION_ID");
                String description = resultSet.getString("DESCRIPTION");
                Date dateUploaded = resultSet.getDate("DATE_UPLOADED");
                int itemId = resultSet.getInt("ITEM_ID");
                byte[] quotationImage = resultSet.getBytes("QUOTATION_IMAGE");

                Quotation quotation = new Quotation(quotationId, description, dateUploaded, itemId, quotationImage);
                quotations.add(quotation);
            }

            request.setAttribute("quotations", quotations);
            request.getRequestDispatcher("quotation.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database access error");
        }
    }

    @SuppressWarnings("oracle.jdeveloper.java.nested-assignment")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String description = request.getParameter("description");
        String itemIdStr = request.getParameter("itemId");
        Part filePart = request.getPart("quotationFile");
        byte[] fileContent = null;

        if (filePart != null) {
            try (InputStream inputStream = filePart.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {

                byte[] data = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, bytesRead);
                }

                fileContent = buffer.toByteArray();
            }
        }

        Integer itemId = null;
        if (itemIdStr != null && !itemIdStr.isEmpty()) {
            try {
                itemId = Integer.parseInt(itemIdStr);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid item ID");
                return;
            }
        }

        String insertQuery = "INSERT INTO C##FMO_ADM.FMO_ITEM_QUOTATIONS (QUOTATION_ID, DESCRIPTION, DATE_UPLOADED, ITEM_ID, QUOTATION_IMAGE) " +
                             "VALUES (SEQ_QUOTATION_ID.NEXTVAL, ?, SYSDATE, ?, ?)";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {

            preparedStatement.setString(1, description);
            if (itemId != null) {
                preparedStatement.setInt(2, itemId);
            } else {
                preparedStatement.setNull(2, Types.INTEGER);
            }
            preparedStatement.setBytes(3, fileContent);

            preparedStatement.executeUpdate();

            response.sendRedirect("quotations");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database insertion error");
        }
    }
}
