<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login</title>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        function handleCredentialResponse(response) {
            try {
                // Decode the JWT token
                const base64Url = response.credential.split('.')[1];
                const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
                const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));
                const responsePayload = JSON.parse(jsonPayload);

                console.log("Processing login for:", responsePayload.email);
                
                // Send to backend with correct path
                fetch("loginServlet", {  // Using relative path
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
                    console.log("Server response status:", res.status);
                    if (!res.ok) {
                        return res.text().then(text => {
                            throw new Error('Server error: ' + text);
                        });
                    }
                    return res.json();
                })
                .then(data => {
                    console.log("Server response:", data);
                    if (data.success) {
                        window.location.href = "homepage";  // Using relative path
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
<body>
    <h2>Login Page</h2>
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
</body>
</html>