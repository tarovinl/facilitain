package com.sample;

import sample.model.ItemUser;
import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/itemUser")
public class ItemUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ItemUser> itemUserList = new ArrayList<>();

        // Query for ItemUser data
        String query = "SELECT iu.EMP_NUMBER, iu.USER_TYPE, e.FIRST_NAME, e.SURNAME " +
                       "FROM FMO_ADM.FMO_ITEM_USERS iu " +
                       "LEFT JOIN FMO_ADM.FMO_EMPLOYEES e ON iu.EMP_NUMBER = e.EMP_NUMBER";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ItemUser itemUser = new ItemUser();
                itemUser.setEmpNumber(resultSet.getInt("EMP_NUMBER"));
                itemUser.setUserType(resultSet.getInt("USER_TYPE"));

                String firstName = resultSet.getString("FIRST_NAME");
                String surname = resultSet.getString("SURNAME");
                String fullName = (firstName != null && surname != null) 
                                  ? firstName + " " + surname 
                                  : "N/A";
                itemUser.setFullName(fullName);

                itemUserList.add(itemUser);
            }
        } catch (Exception e) {
            throw new ServletException("Error retrieving item user data", e);
        }

        // Define the userTypeList as a list of key-value pairs for dropdown options
        List<Map.Entry<Integer, String>> userTypeList = new ArrayList<>();
        userTypeList.add(new AbstractMap.SimpleEntry<>(1, "Admin"));
        userTypeList.add(new AbstractMap.SimpleEntry<>(2, "View Only"));

        // Set attributes for the JSP
        request.setAttribute("itemUserList", itemUserList);
        request.setAttribute("userTypeList", userTypeList);

        // Forward to itemUser.jsp
        request.getRequestDispatcher("itemUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from the form
        int empNumber = Integer.parseInt(request.getParameter("empNumber"));
        int userType = Integer.parseInt(request.getParameter("userType"));

        // SQL MERGE statement for insert or update
        String insertOrUpdateQuery = 
            "MERGE INTO FMO_ADM.FMO_ITEM_USERS iu " +
            "USING (SELECT ? AS EMP_NUMBER, ? AS USER_TYPE FROM dual) new_values " +
            "ON (iu.EMP_NUMBER = new_values.EMP_NUMBER) " +
            "WHEN MATCHED THEN UPDATE SET iu.USER_TYPE = new_values.USER_TYPE " +
            "WHEN NOT MATCHED THEN INSERT (EMP_NUMBER, USER_TYPE) VALUES (new_values.EMP_NUMBER, new_values.USER_TYPE)";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(insertOrUpdateQuery)) {

            // Set parameters
            statement.setInt(1, empNumber);
            statement.setInt(2, userType);

            // Execute update or insert
            statement.executeUpdate();
        } catch (Exception e) {
            throw new ServletException("Error saving item user data", e);
        }

        // Redirect to doGet to refresh the page and display the updated list
        response.sendRedirect("itemUser");
    }
}
