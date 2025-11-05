<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
 <%
    // Prevent caching of header
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Determine current page for logout source
    String currentPage = request.getRequestURI();
    String logoutSource = "";
    if (currentPage.contains("feedback")) {
        logoutSource = "?source=feedback";
    } else if (currentPage.contains("reports")) {
        logoutSource = "?source=reports";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" 
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="resources/css/custom-styles.css"/>
        <style>
            .montserrat-regular {
                font-family: "Montserrat", sans-serif;
                font-weight: 400;
                font-style: normal;
            }
        </style>
    </head>
    <body>
        <header class="bg-facilGray p-3 d-flex justify-content-between align-items-center" 
        style="overflow-x: auto; white-space: nowrap;">
    
            <!-- For large devices -->
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-none d-md-block" style="max-height: 4rem;">
            <!-- For small devices -->
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-md-none" style="max-height: 2rem;">
            
            <% 
                boolean isLoggedIn = session != null && session.getAttribute("email") != null;
                if (isLoggedIn) { 
            %>
                <!-- Logout Button for logged-in users -->
                <a href="<%=request.getContextPath()%>/LogoutController<%=logoutSource%>" class="montserrat-regular btn btn-danger d-none d-md-block">
                     <img src="resources/images/icons/logout.svg" alt="logout" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Logout
                </a>
                <a href="<%=request.getContextPath()%>/LogoutController<%=logoutSource%>" class="montserrat-regular btn btn-danger d-md-none">
                     <img src="resources/images/icons/logout.svg" alt="logout" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Logout
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