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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/itemUser")
public class ItemUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ItemUser> itemUserList = new ArrayList<>();

        // Query for ItemUser data
        String query = "SELECT USER_ID, NAME, EMAIL, ROLE FROM FMO_ADM.FMO_ITEM_DUSERS";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ItemUser itemUser = new ItemUser();
                itemUser.setUserId(resultSet.getInt("USER_ID"));
                itemUser.setName(resultSet.getString("NAME"));
                itemUser.setEmail(resultSet.getString("EMAIL"));
                itemUser.setRole(resultSet.getString("ROLE"));

                itemUserList.add(itemUser);
            }
        } catch (Exception e) {
            throw new ServletException("Error retrieving item user data", e);
        }

        // Set attributes for the JSP
        request.setAttribute("itemUserList", itemUserList);

        // Forward to itemUser.jsp
        request.getRequestDispatcher("itemUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String role = request.getParameter("role");

        String updateQuery = "UPDATE FMO_ADM.FMO_ITEM_DUSERS SET ROLE = ? WHERE USER_ID = ?";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {
            statement.setString(1, role);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (Exception e) {
            throw new ServletException("Error updating item user data", e);
        }

        // Redirect with a success flag
        response.sendRedirect("itemUser?success=true");
    }
}
