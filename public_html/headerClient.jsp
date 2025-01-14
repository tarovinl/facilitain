<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession(false);
    boolean isLoggedIn = session != null && session.getAttribute("email") != null;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" 
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="resources/css/custom-styles.css"/>
    </head>
    <body>
        <header class="bg-facilGray p-3 d-flex justify-content-between align-items-center" 
        style="overflow-x: auto; white-space: nowrap;">
    
            <!-- For large devices -->
            <img src="resources/images/USTLogo.png" alt="UST Logo" class="img-fluid d-none d-md-block" style="max-height: 6rem;">

            <!-- For small devices -->
            <img src="resources/images/USTLogo.png" alt="UST Logo" class="img-fluid d-md-none" style="max-height: 3rem;">
            
            <% if (isLoggedIn) { %>
                <!-- Logout Button for logged-in users -->
                <a href="<%=request.getContextPath()%>/logoutServlet" class="btn btn-danger d-none d-md-block">
                    <i class="bi bi-box-arrow-left pe-2"></i>Logout
                </a>
                <a href="<%=request.getContextPath()%>/logoutServlet" class="btn btn-danger d-md-none">
                    <i class="bi bi-box-arrow-left pe-2"></i>Logout
                </a>
            <% } %>
        </header>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" 
                integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" 
                integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>
