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

        // Allow access to all login and logout pages without requiring a session
        if (uri.contains("login") || uri.contains("logout") || uri.endsWith("index.jsp") || 
            uri.startsWith(httpRequest.getContextPath() + "/static/")) {
            chain.doFilter(request, response);
            return;
        }

        // For all other pages, require a session
        if (session == null || session.getAttribute("email") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if necessary
    }
}