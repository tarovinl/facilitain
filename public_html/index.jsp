<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <!-- Use context path for CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom-fonts.css">
    <!-- Use context path for favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/images/FMO-Logo.ico">
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

                console.log("Processing login for:", responsePayload.email);

                fetch("loginServlet", {
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
                        window.location.href = "homepage";
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
    
    <style>
        body, h1, h2, h3, h4, h5, th, button, input[type="button"], input[type="submit"] {
            font-family: "Montserrat", sans-serif !important;
            font-weight: 700 !important;
        }
        
        a, h6, input, textarea, td, tr, p, label, select, option {
            font-family: "Montserrat", sans-serif !important;
            font-weight: 400 !important;
        }
        
        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000000;
        }
        
        .login-container {
            background-color: white;
            padding: 20px;
            max-width: 600px;
            width: 100%;
        }
        
        .login-container h1 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            color: #FFC107;
        }
        
        .login-container p {
            font-size: 0.9rem;
            color: #ddd;
        }
        
        .g_id_signin {
            width: 100%;
        }
        
        .montserrat-regular {
            font-family: "Montserrat", sans-serif;
            font-weight: 400;
            font-style: normal;
        }
        
        .montserrat-bold {
            font-family: "Montserrat", sans-serif;
            font-weight: 700;
            font-style: normal;
        }
        
        .shared-text {
            font-family: 'Montserrat', sans-serif;
            font-size: 14.4px;
            color: #343a40; 
            text-align: start;
            line-height: 1.5;
        }

        .privacy-link {
            cursor: pointer;
            text-decoration: none;
            color: #000;
        }
        
        .privacy-link:hover {
            text-decoration: underline;
            color: #000;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100" 
     style="background: linear-gradient(rgba(30, 30, 30, 0.85), rgba(30, 30, 30, 0.85)), 
        url('${pageContext.request.contextPath}/resources/images/arch-bg.jpg'); 
       background-size: cover; 
       background-position: center; 
       background-repeat: no-repeat;">

    <div class="container text-center">
        <div class="row">
            <div class="d-flex col-md-6 align-items-center mb-4 mb-md-0">
               <!-- Use context path for logo -->
               <img src="${pageContext.request.contextPath}/resources/images/FACILITAIN_WLOGO3.png" 
                    alt="FACILITAIN" 
                    class="img-fluid mb-4 d-block mx-auto" 
                    style="max-height: 8rem;">
            </div>
            <div class="col-md-6">
                <div class="login-container p-4 p-md-5 rounded-1">
                    <h3 class="mb-4 montserrat-bold text-start">Sign in</h3>
                    
                    <p class="montserrat-regular text-dark text-start shared-text">Track and maintain facilities within the University of Santo Tomas! Please make sure to login with your <strong> UST Google Workspace Personal Account </strong> to access <strong> FACILITAIN. </strong></p>
                    
                    <div id="g_id_onload"
                         data-client_id="103164757802-4v37vphomb6foi27vbhhc4advakt16q3.apps.googleusercontent.com"
                         data-context="signin"
                         data-callback="handleCredentialResponse"
                         data-auto_prompt="false">
                    </div>
                    <div class="d-flex justify-content-center">
                      <div class="g_id_signin montserrat-regular"
                           data-type="standard"
                           data-size="large"
                           data-theme="outline"
                           data-text="signin_with"
                           data-shape="rectangular"
                           data-logo_alignment="left">
                      </div>
                    </div>
                    <hr class="my-3">
                    <a href="#" class="d-block privacy-link montserrat-regular text-start" 
                       style="font-size: 0.80rem;" 
                       data-bs-toggle="modal" 
                       data-bs-target="#privacyModal">
                        FACILITAIN values your privacy. View our <strong>Privacy Policy</strong>.
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Privacy Modal -->
    <jsp:include page="privacyClient.jsp"/>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>