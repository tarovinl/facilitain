package com.sample;

import sample.model.Employee;
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

@WebServlet("/employee")
public class EmployeeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Employee> employeeList = new ArrayList<>();
        String query = "SELECT FMO_EMP_ID, SURNAME, FIRST_NAME, MIDDLE_NAME, OTHER_NAME, SRVC_AREA_ID, " +
                       "EMP_STATUS, EMP_NUMBER, ACTIVE_FLAG, COMPANY_NAME FROM FMO_EMPLOYEES";

        try (Connection connection = PooledConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Employee employee = new Employee();
                employee.setEmployeeId(resultSet.getInt("FMO_EMP_ID"));
                employee.setSurname(resultSet.getString("SURNAME"));
                employee.setFirstName(resultSet.getString("FIRST_NAME"));
                employee.setMiddleName(resultSet.getString("MIDDLE_NAME"));
                employee.setOtherName(resultSet.getString("OTHER_NAME"));
                employee.setServiceAreaId(resultSet.getInt("SRVC_AREA_ID"));
                employee.setStatus(resultSet.getInt("EMP_STATUS"));
                employee.setEmployeeNumber(resultSet.getInt("EMP_NUMBER"));
                employee.setActiveFlag(resultSet.getInt("ACTIVE_FLAG"));
                employee.setCompanyName(resultSet.getString("COMPANY_NAME"));
                
                employeeList.add(employee);
            }
        } catch (Exception e) {
            throw new ServletException("Error retrieving employee data", e);
        }

        request.setAttribute("employeeList", employeeList);
        request.getRequestDispatcher("employees.jsp").forward(request, response);
    }
}
