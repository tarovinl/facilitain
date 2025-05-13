<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
      <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
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
         font-weight: 600;
         font-style: normal;
                            }
        .shared-text {
    font-family: 'Montserrat', sans-serif;
    font-size: 14.4px;
    color: #343a40; 
    text-align: start;
    line-height: 1.5; 
}

        
    </style>
</head>
<body class="d-flex flex-column min-vh-100" 
      style="background: linear-gradient(rgba(128, 128, 128, 0.8), rgba(128, 128, 128, 0.8)), 
             url('resources/images/arch-bg.jpg'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">

    <div class="container text-center">
        <div class="row">
            <div class="d-flex col-md-6 align-items-center">
               <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4 d-block mx-auto" style="max-height: 4rem;">
            </div>
            <div class="col-md-6">
                <div class="login-container">
                    <h3 class="mb-4 montserrat-bold text-start ">Sign in</h3>
                    <p class="montserrat-regular text-dark text-start shared-text">To access MyUSTe Portal, please make sure you meet the following requirements:</p>
                    <ol class="text-start montserrat-regular ">
                        <li class="shared-text">UST Google Workspace Personal Account</li>
                        <li class="shared-text">Google Authenticator Application</li>
                    </ol>
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
                    <a href="#" class="d-block mt-3 text-decoration-none text-dark montserrat-regular text-center">Need help signing in? <strong>Learn More</strong></a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
