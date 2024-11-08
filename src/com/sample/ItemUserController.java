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
        String query = "SELECT EMP_NUMBER, USER_TYPE FROM C##FMO_ADM.FMO_ITEM_USERS";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ItemUser itemUser = new ItemUser();
                itemUser.setEmpNumber(resultSet.getInt("EMP_NUMBER"));
                itemUser.setUserType(resultSet.getInt("USER_TYPE"));
                
                itemUserList.add(itemUser);
            }
        } catch (Exception e) {
            throw new ServletException("Error retrieving item user data", e);
        }

        request.setAttribute("itemUserList", itemUserList);
        request.getRequestDispatcher("itemUser.jsp").forward(request, response);
        System.out.println("Retrieved item users: " + itemUserList.size());

    }
}
