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
        <title>Login Reports</title>
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
            .montserrat-boldl {
                font-family: "Montserrat", sans-serif;
                font-weight: 800;
                font-style: normal;
            }
            
            /* Privacy Modal Styles */
            .privacy-modal .modal-dialog {
                max-width: 90vw;
                width: 100%;
                margin: 1rem auto;
            }
            
            @media (min-width: 576px) {
                .privacy-modal .modal-dialog {
                    max-width: 500px;
                }
            }
            
            @media (min-width: 768px) {
                .privacy-modal .modal-dialog {
                    max-width: 600px;
                }
            }
            
            @media (min-width: 992px) {
                .privacy-modal .modal-dialog {
                    max-width: 700px;
                }
            }
            
            .privacy-modal .modal-body {
                max-height: 60vh;
                overflow-y: auto;
                padding: 0;
            }
            
            .privacy-modal .modal-body-content {
                padding: 1.5rem;
            }
            
            @media (max-width: 575.98px) {
                .privacy-modal .modal-dialog {
                    margin: 0.5rem;
                    max-width: calc(100vw - 1rem);
                }
                
                .privacy-modal .modal-body {
                    max-height: 70vh;
                }
                
                .privacy-modal .modal-body-content {
                    padding: 1rem;
                }
                
                .privacy-modal .modal-title {
                    font-size: 1.1rem;
                }
            }
            
            .privacy-modal .modal-body::-webkit-scrollbar {
                width: 8px;
            }
            
            .privacy-modal .modal-body::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }
            
            .privacy-modal .modal-body::-webkit-scrollbar-thumb {
                background: #fbbe15;
                border-radius: 4px;
            }
            
            .privacy-modal .modal-body::-webkit-scrollbar-thumb:hover {
                background: #e6a912;
            }
            
            .modal-backdrop {
                background-color: rgba(0, 0, 0, 0.3) !important; 
            }
            
            .btn-agree:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }
        </style>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <script>
            // Store credential response temporarily
            let pendingCredential = null;
            
            function handleCredentialResponse(response) {
                try {
                    // Store the credential response
                    pendingCredential = response;
                    
                    // Show the privacy policy modal
                    const privacyModal = new bootstrap.Modal(document.getElementById('privacyModal'), {
                        backdrop: true,
                        keyboard: true
                    });
                    privacyModal.show();
                    
                    // Clear credential if modal is closed without agreeing
                    document.getElementById('privacyModal').addEventListener('hidden.bs.modal', function () {
                        if (pendingCredential) {
                            pendingCredential = null;
                            console.log('Login cancelled - modal closed');
                        }
                    });
                    
                } catch (error) {
                    console.error('Error processing response:', error);
                    alert("Error processing login response: " + error.message);
                }
            }
            
            function proceedWithLogin() {
                if (!pendingCredential) {
                    alert("No login credential found. Please try logging in again.");
                    return;
                }
                
                try {
                    const base64Url = pendingCredential.credential.split('.')[1];
                    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
                    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
                        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                    }).join(''));
                    const responsePayload = JSON.parse(jsonPayload);

                    fetch("${pageContext.request.contextPath}/loginServlet?loginPage=reportsClient", {
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
            
            function enableAgreeButton() {
                const checkbox = document.getElementById('privacyCheckbox');
                const agreeBtn = document.getElementById('agreeBtn');
                agreeBtn.disabled = !checkbox.checked;
            }
            
            function cancelLogin() {
                // Clear the pending credential
                pendingCredential = null;
                // Optionally show a message
                console.log('Login cancelled by user');
            }
        </script>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <header class="bg-facilGray p-3 d-flex justify-content-between align-items-center">
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-none d-md-block" style="max-height: 4rem;">
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-md-none" style="max-height: 2rem;">
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
                            <h3 class="text-center p-1 montserrat-bold">Sign in to Give Reports</h3>
                            <p>Help improve our campus facilities! Please log in using your <strong>UST Google Workspace Personal Account</strong> to access the <strong>FACILITAIN Reports Portal</strong>.</p>
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
        
        <!-- Agreement Modal -->
        <div class="modal fade privacy-modal" id="privacyModal" tabindex="-1" aria-labelledby="privacyModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header" style="background-color: #fbbe15;">
                        <h5 class="modal-title montserrat-boldl" id="privacyModalLabel">AGREEMENT REMINDER</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="cancelLogin()"></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-body-content text-center">
                            <img src="resources/images/FACILITAIN_WLOGO4.png" alt="FACILITAIN" class="img-fluid mb-4 d-block mx-auto" style="max-height: 4rem;">
                            <p class="montserrat-regular">
                                Filling up the form abides by the<br/>
                                Data Privacy Act of 2012 where your<br/>
                                personal data is collected but for<br/>
                                record-keeping purposes only
                            </p>
                        </div>
                    </div>
                    <div class="modal-footer flex-column align-items-stretch">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="privacyCheckbox" onchange="enableAgreeButton()">
                            <label class="form-check-label montserrat-regular" for="privacyCheckbox">
                                I have read and agree to the terms above
                            </label>
                        </div>
                        <button 
                            type="button" 
                            id="agreeBtn"
                            class="btn w-100 py-2 btn-agree montserrat-bold" 
                            style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;" 
                            onmouseover="if(!this.disabled) { this.style.backgroundColor='#292927'; this.style.color='#fbbe15'; }" 
                            onmouseout="if(!this.disabled) { this.style.backgroundColor='#fbbe15'; this.style.color='#212529'; }" 
                            onclick="proceedWithLogin()"
                            disabled>
                            Agree and Continue
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>