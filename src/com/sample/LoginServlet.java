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
            UserInfo userInfo = getUserInfoFromDatabase(email);
                if (userInfo != null && userInfo.getRole() != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("name", name);
                    session.setAttribute("role", userInfo.getRole());
                    session.setAttribute("userID", userInfo.getUserId());

                // Determine redirection URL based on loginPage parameter and role
                String redirectUrl;
                
                if ("feedbackClient".equals(loginPage)) {
                    redirectUrl = "feedbackClient";
                } else if ("reportsClient".equals(loginPage)) {
                    redirectUrl = "reportsClient";
                } else {
                    // Default behavior for different roles when no specific loginPage is provided
                    switch (userInfo.getRole()) {
                        case "Admin":
                        case "Support":
                            redirectUrl = "homepage";
                            break;
                        case "Respondent":
                            // let the filter redirect them to unauthorized.jsp if needed
                            redirectUrl = "homepage";
                            break;
                        case "ReportClient":
                            redirectUrl = "reportsClient";
                            break;
                        default:
                            redirectUrl = "homepage";
                            break;
                    }
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

    private UserInfo getUserInfoFromDatabase(String email) throws SQLException {
        UserInfo userInfo = null;
        try (Connection conn = PooledConnection.getConnection()) {
            String sql = "SELECT user_id, role FROM FMO_ADM.FMO_ITEM_DUSERS WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        userInfo = new UserInfo(
                            rs.getInt("user_id"),
                            rs.getString("role")
                        );
                    }
                }
            }
        }
        return userInfo;
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
    private static class UserInfo {
            private int userId;
            private String role;

            public UserInfo(int userId, String role) {
                this.userId = userId;
                this.role = role;
            }

            public int getUserId() { return userId; }
            public String getRole() { return role; }
        }
}
