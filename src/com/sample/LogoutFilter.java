package com.sample;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if necessary
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();

        // Allow access to login, logout, public pages, and static resources without session
        if (uri.contains("login") || uri.contains("logout") || uri.endsWith("index.jsp") ||
                uri.endsWith("termsClient.jsp") || uri.endsWith("privacyClient.jsp") ||
                uri.endsWith("loginFeedbackClient.jsp") || uri.endsWith("loginReportsClient.jsp") ||
                uri.startsWith(httpRequest.getContextPath() + "/static/") ||
                uri.startsWith(httpRequest.getContextPath() + "/resources/")) {
            chain.doFilter(request, response);
            return;
        }

        // Require session and email for all other pages
        if (session == null || session.getAttribute("email") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
            return;
        }

        // Allow unauthorized.jsp for all authenticated users
        if (uri.endsWith("unauthorized.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Check the user's role
        String role = (String) session.getAttribute("role");
        if (role == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
            return;
        }

        switch (role) {
            case "Admin":
                // Admin has access to all pages
                chain.doFilter(request, response);
                break;

            case "Support":
                // Restrict access to specific paths for Support role
                if (uri.endsWith("/settings") || uri.endsWith("/itemCategories") ||
                        uri.endsWith("/itemType") || uri.endsWith("/maintenance")) {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
                } else {
                    chain.doFilter(request, response);
                }
                break;

            case "Respondent":
                // Allow access only to specific paths for Respondent role
                boolean isAllowedPage = uri.endsWith("/feedbackClient") || 
                                        uri.endsWith("/reportsClient") || 
                                        uri.endsWith("reportsThanksClient.jsp") || 
                                        uri.endsWith("feedbackThanksClient.jsp");
                if (isAllowedPage) {
                    chain.doFilter(request, response);
                } else {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
                }
                break;

            default:
                // Unknown role, redirect to login
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if necessary
    }
}
