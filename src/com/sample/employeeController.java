package com.sample;

import sample.model.PooledConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import sample.model.Employee;

@WebServlet("/employees")
public class employeeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch and display all employees
        List<Employee> employeeList = new ArrayList<>();
        try (Connection conn = PooledConnection.getConnection()) {
            String query = "SELECT FMO_EMP_ID, SURNAME, FIRST_NAME, MIDDLE_NAME, OTHER_NAME, SRVC_AREA_ID, " +
                           "EMP_STATUS, EMP_NUMBER, ACTIVE_FLAG, COMPANY_NAME FROM C##FMO_ADM.FMO_EMPLOYEES";
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("FMO_EMP_ID"));
                    employee.setSurname(rs.getString("SURNAME"));
                    employee.setFirstName(rs.getString("FIRST_NAME"));
                    employee.setMiddleName(rs.getString("MIDDLE_NAME"));
                    employee.setOtherName(rs.getString("OTHER_NAME"));
                    employee.setServiceAreaId(rs.getInt("SRVC_AREA_ID"));
                    employee.setStatus(rs.getInt("EMP_STATUS"));
                    employee.setEmployeeNumber(rs.getInt("EMP_NUMBER"));
                    employee.setActiveFlag(rs.getInt("ACTIVE_FLAG"));
                    employee.setCompanyName(rs.getString("COMPANY_NAME"));
                    employeeList.add(employee);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching employees.", e);
        }

        // Forward employee list to JSP
        request.setAttribute("employeeList", employeeList);
        request.getRequestDispatcher("employees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String empIdParam = request.getParameter("employeeId");
        String surname = request.getParameter("surname");
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String otherName = request.getParameter("otherName");
        int serviceAreaId = Integer.parseInt(request.getParameter("serviceAreaId"));
        int status = Integer.parseInt(request.getParameter("status"));
        String companyName = request.getParameter("companyName");

        Integer empId = (empIdParam != null && !empIdParam.isEmpty()) ? Integer.parseInt(empIdParam) : null;

        try (Connection conn = PooledConnection.getConnection()) {
            if (empId != null && existsInDatabase(conn, empId)) {
                // Update existing employee record
                String updateSql = "UPDATE C##FMO_ADM.FMO_EMPLOYEES SET SURNAME = ?, FIRST_NAME = ?, MIDDLE_NAME = ?, " +
                        "OTHER_NAME = ?, SRVC_AREA_ID = ?, EMP_STATUS = ?, COMPANY_NAME = ? " +
                        "WHERE FMO_EMP_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setString(1, surname);
                    stmt.setString(2, firstName);
                    stmt.setString(3, middleName);
                    stmt.setString(4, otherName);
                    stmt.setInt(5, serviceAreaId);
                    stmt.setInt(6, status); // Status should be passed, trigger will handle change prevention
                    stmt.setString(7, companyName);
                    stmt.setInt(8, empId);
                    stmt.executeUpdate();
                }
            } else {
                // Insert new employee record
                String insertSql = "INSERT INTO C##FMO_ADM.FMO_EMPLOYEES (SURNAME, FIRST_NAME, MIDDLE_NAME, OTHER_NAME, " +
                        "SRVC_AREA_ID, EMP_STATUS, COMPANY_NAME) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setString(1, surname);
                    stmt.setString(2, firstName);
                    stmt.setString(3, middleName);
                    stmt.setString(4, otherName);
                    stmt.setInt(5, serviceAreaId);
                    stmt.setInt(6, status); // ACTIVE_FLAG and EMP_NUMBER will be set by triggers
                    stmt.setString(7, companyName);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while processing employees.", e);
        }

        response.sendRedirect(request.getContextPath() + "/employees.jsp");


    }

    private boolean existsInDatabase(Connection conn, int empId) throws SQLException {
        String checkSql = "SELECT 1 FROM C##FMO_ADM.FMO_EMPLOYEES WHERE FMO_EMP_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, empId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}
