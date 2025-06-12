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
        HttpSession session = httpRequest.getSession(false); // Get session if it exists
        String uri = httpRequest.getRequestURI(); // Get the requested URI
        
        // Allow access to login, logout, and public static resources
        if (uri.contains("login") || uri.contains("logout") || uri.endsWith("index.jsp") ||
                uri.startsWith(httpRequest.getContextPath() + "/static/") ||
                uri.contains("resources/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Require session and email for all other pages
        if (session == null || session.getAttribute("email") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
            return;
        }
        
        // Check the user's role
        String role = (String) session.getAttribute("role");
        if (role == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
            return;
        }
        
        // Define Admin-only pages
        boolean isAdminOnlyPage = uri.endsWith("/maintenancePage") || 
                                 uri.endsWith("/itemUser") ||
                                 uri.endsWith("/itemType") || 
                                 uri.endsWith("/itemCategories") || 
                                 uri.endsWith("/maintenanceSchedule");
        
        switch (role) {
            case "Admin":
                // Admin has access to all pages
                chain.doFilter(request, response);
                break;
                
            case "Support":
                // Support role - restrict access to Admin-only pages
                if (isAdminOnlyPage) {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
                } else {
                    chain.doFilter(request, response);
                }
                break;
                
            case "Respondent":
                // Restrict access to specific paths for Respondent role
                boolean isAllowedPage = uri.endsWith("/feedbackClient") || 
                                        uri.endsWith("/reportsClient") || 
                                        uri.endsWith("reportsThanksClient.jsp") || 
                                        uri.endsWith("termsClient.jsp") || 
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