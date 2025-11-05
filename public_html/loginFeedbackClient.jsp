<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%
    // Prevent caching - CRITICAL for security
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
%>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
        <title>Login Feedback</title>
        <style>
            .montserrat-regular {
                font-family: "Montserrat", sans-serif;
                font-weight: 400;
                font-style: normal;
            }
            .montserrat-bold {
                font-family: "Montserrat", sans-serif;
                font-weight: 600;
                font-style: normal;
            }
        </style>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <script>
           function handleCredentialResponse(response) {
    try {
        const base64Url = response.credential.split('.')[1];
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
        const responsePayload = JSON.parse(jsonPayload);

        fetch("${pageContext.request.contextPath}/loginServlet?loginPage=feedbackClient", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                name: responsePayload.name,
                email: responsePayload.email
            })
        })
        .then(res => {
            if (!res.ok) {
                return res.text().then(text => {
                    throw new Error('Server error: ' + text);
                });
            }
            return res.json();
        })
        .then(data => {
            if (data.success) {
                window.location.href = data.redirectUrl;
            } else {
                alert("Login failed: " + (data.message || "Unauthorized user"));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("Login failed: " + error.message);
        });
    } catch (error) {
        console.error('Error processing response:', error);
        alert("Error processing login response: " + error.message);
    }
}
        </script>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header class="bg-facilGray p-3 d-flex justify-content-between align-items-center">
    <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-none d-md-block" style="max-height: 4rem;">
    <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-md-none" style="max-height: 2rem;">
    <!-- No logout button here -->
</header>
        <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
            <div class="row justify-content-center align-items-center">
                <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
                    <div class="card">
                        <div class="card-body">
                            <img src="resources/images/FACILITAIN_WLOGO2.png" 
                             alt="FACILITAIN" 
                             class="img-fluid mb-4 d-block mx-auto" 
                             style="max-height: 5rem;">
                            <h3 class="text-center p-1 montserrat-bold">Sign in to Give Feedback</h3>
                            <p>Help improve our campus facilities! Please log in using your <strong>UST Google Workspace Personal Account</strong> to access the <strong>FACILITAIN Feedback Portal</strong>.</p>
                            <div class="mt-3 d-flex justify-content-center px-0">
                                <div id="g_id_onload"
                                     data-client_id="103164757802-4v37vphomb6foi27vbhhc4advakt16q3.apps.googleusercontent.com"
                                     data-context="signin"
                                     data-callback="handleCredentialResponse"
                                     data-auto_prompt="false">
                                </div>
                                <div class="g_id_signin"
                                     data-type="standard"
                                     data-size="large"
                                     data-theme="outline"
                                     data-text="signin_with"
                                     data-shape="rectangular"
                                     data-logo_alignment="left">
                                </div>
                            </div>
                            <hr class="my-3">
                            <div class="text-center">
                               <a href="#" class="d-block text-decoration-none text-dark montserrat-regular text-center" style="font-size: 1rem;">Need help signing in? <strong>Learn More</strong></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>