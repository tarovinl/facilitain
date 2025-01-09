package com.sample;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Define the filter for URLs except login and logout-related ones
@WebFilter("/*")
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

        // Get the current session without creating a new one
        HttpSession session = httpRequest.getSession(false);

        // Get the requested URI
        String uri = httpRequest.getRequestURI();

        // Check if the user is trying to access a protected resource
        boolean isLoginPage = uri.endsWith("index.jsp") || uri.endsWith("loginServlet");
        boolean isLogoutPage = uri.endsWith("logoutServlet");
        boolean isStaticResource = uri.startsWith(httpRequest.getContextPath() + "/static/");

        if (isLoginPage || isLogoutPage || isStaticResource) {
            // Allow access to login/logout/static resources
            chain.doFilter(request, response);
        } else if (session == null || session.getAttribute("email") == null) {
            // Redirect to login page if session is missing or user is not logged in
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        } else {
            // Continue to the requested resource if logged in
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if necessary
    }
}
