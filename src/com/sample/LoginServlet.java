package com.sample;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import com.google.gson.Gson;
import sample.model.PooledConnection;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Get the page identifier from the request
        String loginPage = request.getParameter("loginPage");

        StringBuilder buffer = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
        }

        LoginRequest loginRequest = gson.fromJson(buffer.toString(), LoginRequest.class);
        String name = loginRequest.getName();
        String email = loginRequest.getEmail();

        if (email == null || email.trim().isEmpty()) {
            sendErrorResponse(response, "Email is required");
            return;
        }

        try {
            String role = getUserRoleFromDatabase(email);
            if (role != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("name", name);
                session.setAttribute("role", role);

                // Determine redirection URL
                String redirectUrl = "homepage";
                if ("Respondent".equals(role)) {
                    if ("reportsClient".equals(loginPage)) {
                        redirectUrl = "reportsClient";  // for reportClient page
                    } else {
                        redirectUrl = "feedbackClient";  // for feedbackClient page
                    }
                } else if ("ReportClient".equals(role)) {
                    redirectUrl = "reportsClient";
                }

                sendSuccessResponse(response, redirectUrl);
            } else {
                sendErrorResponse(response, "Unauthorized user");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Database error occurred");
        }
    }

    private String getUserRoleFromDatabase(String email) throws SQLException {
        String role = null;
        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "SELECT role FROM C##FMO_ADM.FMO_ITEM_DUSERS WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        role = rs.getString("role");
                    }
                }
            }
        }
        return role;
    }

    private void sendSuccessResponse(HttpServletResponse response, String redirectUrl) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true, \"redirectUrl\": \"" + redirectUrl + "\"}");
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": false, \"message\": \"" + message + "\"}");
    }

    private static class LoginRequest {
        private String name;
        private String email;

        public String getName() { return name; }
        public String getEmail() { return email; }
    }
}