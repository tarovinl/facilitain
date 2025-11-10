package com.sample;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutFilter implements Filter {
    
    // Session timeout in minutes (bare minimum security)
    private static final int SESSION_TIMEOUT_MINUTES = 10;
    
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
        String contextPath = httpRequest.getContextPath();

        //  prevents page caching)
        addSecurityHeaders(httpResponse);

        String requestPath = uri.substring(contextPath.length());
        if (requestPath.isEmpty()) {
            requestPath = "/";
        }

        // Using better path matching that accounts for query strings and context paths
        if (isPublicPage(requestPath)) {
            chain.doFilter(request, response);
            return;
        }

        // Require session and email for all other pages
        if (session == null || session.getAttribute("email") == null) {
            // Redirect to appropriate login page based on requested page
            String redirectUrl = getLoginPageForRequest(contextPath, requestPath);
            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        // Allow unauthorized.jsp for all authenticated users
        if (requestPath.equals("/unauthorized.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Check the user's role 
        String role = (String) session.getAttribute("role");
        if (role == null) {
            String redirectUrl = getLoginPageForRequest(contextPath, requestPath);
            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        boolean hasAccess = checkRoleAccess(role, requestPath);
        
        if (hasAccess) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(contextPath + "/unauthorized.jsp");
        }
    }

    private boolean isPublicPage(String requestPath) {
        return requestPath.equals("/") ||
               requestPath.equals("/index.jsp") ||
               requestPath.contains("login") ||
               requestPath.contains("logout") ||
               requestPath.contains("Logout") ||
               requestPath.equals("/termsClient.jsp") ||
               requestPath.equals("/privacyClient.jsp") ||
               requestPath.equals("/loginFeedbackClient.jsp") ||
               requestPath.equals("/loginReportClient.jsp") ||
               requestPath.startsWith("/static/") ||
               requestPath.startsWith("/resources/");
    }

    private boolean checkRoleAccess(String role, String requestPath) {
        switch (role) {
            case "Admin":
                // Admin has access to all pages
                return true;
                
            case "Support":
                // Restrict access to specific paths for Support role
                return !requestPath.equals("/settings") && 
                       !requestPath.equals("/itemCategories") &&
                       !requestPath.equals("/itemType") && 
                       !requestPath.equals("/maintenance");
                
            case "Respondent":
                // Allow access only to specific paths for Respondent role
                return requestPath.endsWith("/feedbackClient") ||
                       requestPath.endsWith("/reportsClient") ||
                       requestPath.equals("/reportsThanksClient.jsp") ||
                       requestPath.equals("/feedbackThanksClient.jsp");
                
            default:
                // Unknown role, deny access
                return false;
        }
    }

    private void addSecurityHeaders(HttpServletResponse response) {
        // Prevent page caching - this stops back button from showing cached pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
    
    private String getLoginPageForRequest(String contextPath, String requestPath) {
        // Check for feedback CLIENT pages (not admin feedback page)
        if (requestPath.contains("feedbackClient") || 
            requestPath.equals("/feedbackThanksClient.jsp") ||
            requestPath.equals("/loginFeedbackClient.jsp")) {
            return contextPath + "/loginFeedbackClient.jsp";
        } 
        // Check for reports CLIENT pages (not admin reports page)
        else if (requestPath.contains("reportsClient") || 
                 requestPath.contains("ReportsClient") ||
                 requestPath.equals("/reportsThanksClient.jsp") ||
                 requestPath.equals("/loginReportClient.jsp")) {
            return contextPath + "/loginReportClient.jsp";
        } 
        // Everything else goes to admin login (including /feedback and /reports admin pages)
        else {
            return contextPath + "/index.jsp";
        }
    }

    @Override
    public void destroy() {
        // Cleanup if necessary
    }
}
