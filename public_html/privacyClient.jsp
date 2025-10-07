<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy Modal</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
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
        
        /* Custom modal sizing for better responsiveness */
        .privacy-modal .modal-dialog {
            max-width: 90vw;
            width: 100%;
            margin: 1rem auto;
        }
        
        /* Responsive breakpoints */
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
        
        /* Set fixed height for scrollable content */
        .privacy-modal .modal-body {
            max-height: 60vh;
            overflow-y: auto;
            padding: 0;
        }
        
        /* Ensure content has proper padding */
        .privacy-modal .modal-body-content {
            padding: 1.5rem;
        }
        
        /* Mobile optimizations */
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
        
        /* Custom scrollbar styling */
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
        
        /* Hover effect for close button */
        .privacy-modal .btn-close-custom:hover {
            background-color: #292927 !important;
            color: #fbbe15 !important;
        }
        
        .modal-backdrop {
    background-color: rgba(0, 0, 0, 0.3) !important; 
}

    </style>
</head>
<body>
   

    <!-- Privacy Policy Modal -->
    <div class="modal fade privacy-modal" id="privacyModal" tabindex="-1" aria-labelledby="privacyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #fbbe15;">
                    <h5 class="modal-title montserrat-bold" id="privacyModalLabel">Privacy Policy</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <h6 class="montserrat-bold">Effective October 2024</h6>
                        <p class="montserrat-regular">
                            Welcome to FACILITAIN, the Academic Facility Maintenance Tracker for the Facilities Management Office of the University of Santo Tomas ("UST", "we", "our", or "us"). We are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. This Privacy Policy outlines how we collect, use, and protect your information when you use our website.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">1. Information We Collect</h6>
                        <p class="montserrat-regular">
                            We collect the following types of information:<br/>
                            <strong>Personal Information:</strong> When you login on our website, we may collect personal information such as your name and email address.<br/>
                            <strong>Technical Information:</strong> We automatically collect certain technical information when you visit our website, including your IP address, browser type, operating system, referring URLs, and other information about your use of our website.<br/>
                            <strong>Cookies and Similar Technologies:</strong> We use cookies and similar technologies to collect information about your browsing activities over time and across different websites following your use of our website.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">2. How We Use Your Information</h6>
                        <p class="montserrat-regular">
                            We use the information we collect for various purposes, including to provide and maintain our service, notify you about changes to our service, provide customer support, and monitor the usage of our service.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">3. Information Sharing</h6>
                        <p class="montserrat-regular">
                            We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this Privacy Policy.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">4. Data Security</h6>
                        <p class="montserrat-regular">
                            We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">5. Your Rights</h6>
                        <p class="montserrat-regular">
                            You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">6. Contact Us</h6>
                        <p class="montserrat-regular">
                            If you have any questions about this Privacy Policy, please contact us at the Facilities Management Office of the University of Santo Tomas.
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button 
                        type="button" 
                        class="btn w-100 py-2 btn-close-custom" 
                        style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;" 
                        onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                        onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';" 
                        data-bs-dismiss="modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>