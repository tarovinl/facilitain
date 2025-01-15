//package com.sample;
//
//import javax.servlet.*;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import java.io.IOException;
//
//public class RespondentFilter implements Filter {
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // Initialization if necessary
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//        HttpSession session = httpRequest.getSession(false);  // Get session, if it exists
//        String uri = httpRequest.getRequestURI();  // Get the current requested URI
//
//        // List of pages respondents can access
//        boolean isAllowedPage = uri.endsWith("/feedbackClient") || 
//                                uri.endsWith("/reportsClient") || 
//                                uri.endsWith("reportsThanksClient.jsp") || 
//                                uri.endsWith("termsClient.jsp") || 
//                                uri.endsWith("feedbackThanksClient.jsp");
//
//        // If the session exists and the user has a role, proceed with role checking
//        if (session != null && session.getAttribute("role") != null) {
//            String role = (String) session.getAttribute("role");
//
//            if (role.equals("Respondent")) {
//                if (isAllowedPage) {
//                    // Allow access to permitted pages
//                    chain.doFilter(request, response);
//                } else {
//                    // If the respondent tries to access an unauthorized page, redirect back to /feedbackClient
//                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/feedbackClient");
//                }
//            } else {
//                // If the user does not have the "Respondent" role, redirect to the login page
//                httpResponse.sendRedirect(httpRequest.getContextPath() + "/loginClient.jsp");
//            }
//        } else {
//            // If there is no session or role, redirect to the login page
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/loginClient.jsp");
//        }
//    }
//
//    @Override
//    public void destroy() {
//        // Cleanup if necessary
//    }
//}
