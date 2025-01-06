<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            background: url('your-background-image.jpg') no-repeat center center;
            background-size: cover;
            color: #fff;
        }
        .login-container {
            background-color: rgba(0, 0, 0, 0.6);
            border-radius: 8px;
            padding: 20px;
            max-width: 400px;
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
    </style>
</head>
<body>
    <div class="container text-center">
        <div class="row">
            <div class="col-md-6 text-start">
                <h1 class="display-4 fw-bold">FACILITAIN</h1>
            </div>
            <div class="col-md-6">
                <div class="login-container">
                    <h3 class="mb-4">Sign in</h3>
                    <p>To access MyUSTe Portal, please make sure you meet the following requirements:</p>
                    <ol class="text-start">
                        <li>UST Google Workspace Personal Account</li>
                        <li>Google Authenticator Application</li>
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
                    <a href="#" class="d-block mt-3 text-decoration-none text-light">Need help signing in? <strong>Learn More</strong></a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
