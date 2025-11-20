<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms and Conditions Modal</title>
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
        .terms-modal .modal-dialog {
            max-width: 90vw;
            width: 100%;
            margin: 1rem auto;
        }
        
        .terms-modal .modal-header {
        background-color: #ffffff !important;
        border-bottom: 1px solid #d2d2d2;
        }
        
        /* Responsive breakpoints */
        @media (min-width: 576px) {
            .terms-modal .modal-dialog {
                max-width: 500px;
            }
        }
        
        @media (min-width: 768px) {
            .terms-modal .modal-dialog {
                max-width: 600px;
            }
        }
        
        @media (min-width: 992px) {
            .terms-modal .modal-dialog {
                max-width: 700px;
            }
        }
        
        /* Set fixed height for scrollable content */
        .terms-modal .modal-body {
            max-height: 60vh;
            overflow-y: auto;
            padding: 0;
        }
        
        /* Ensure content has proper padding */
        .terms-modal .modal-body-content {
            padding: 1.5rem;
        }
        
        /* Mobile optimizations */
        @media (max-width: 575.98px) {
            .terms-modal .modal-dialog {
                margin: 0.5rem;
                max-width: calc(100vw - 1rem);
            }
            
            .terms-modal .modal-body {
                max-height: 70vh;
            }
            
            .terms-modal .modal-body-content {
                padding: 1rem;
            }
            
            .terms-modal .modal-title {
                font-size: 1.1rem;
            }
        }
        
        /* Custom scrollbar styling */
        .terms-modal .modal-body::-webkit-scrollbar {
            width: 8px;
        }
        
        .terms-modal .modal-body::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        
        .terms-modal .modal-body::-webkit-scrollbar-thumb {
            background: #fbbe15;
            border-radius: 4px;
        }
        
        .terms-modal .modal-body::-webkit-scrollbar-thumb:hover {
            background: #e6a912;
        }
        
        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.3) !important; 
        }
    </style>
</head>
<body>
    <!-- Terms and Conditions Modal -->
    <div class="modal fade terms-modal" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #ffffff; border-bottom: 1px solid #d2d2d2;">
                    <h5 class="modal-title montserrat-bold" id="termsModalLabel">Terms and Conditions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="modal-body-content">
                        <h6 class="montserrat-bold">Effective October 2024</h6>
                        <p class="montserrat-regular">
                            Welcome to FACILITAIN, the Academic Facility Maintenance Tracker for the Facilities Management Office of the University of Santo Tomas ("UST", "we", "our", or "us"). By accessing or using our website, you agree to comply with and be bound by the following terms and conditions ("Terms"). If you do not agree to these Terms, please do not use our website.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">1. Acceptance of Terms</h6>
                        <p class="montserrat-regular">
                            By accessing and using FACILITAIN, you acknowledge that you have read, understood, and agree to be bound by these Terms, as well as any additional guidelines, rules, and policies referenced herein.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">2. Changes to Terms</h6>
                        <p class="montserrat-regular">
                            We reserve the right to modify these Terms at any time. Any changes will be effective immediately upon posting on our website. Your continued use of the website following the posting of changes constitutes your acceptance of those changes.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">3. User Responsibilities</h6>
                        <p class="montserrat-regular">
                            As a user of FACILITAIN, you agree to:<br/>
                            &bull; Provide accurate, current, and complete information as prompted by the website's registration forms.<br/>
                            &bull; Maintain the confidentiality of your account credentials and restrict access to your account.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">4. Intellectual Property</h6>
                        <p class="montserrat-regular">
                            All content on this website, including but not limited to text, graphics, logos, and software, is the property of UST or its content suppliers and is protected by applicable intellectual property laws.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">5. Limitation of Liability</h6>
                        <p class="montserrat-regular">
                            To the fullest extent permitted by law, UST shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the website.
                        </p>
                        
                        <h6 class="montserrat-bold mt-4">6. Contact Us</h6>
                        <p class="montserrat-regular">
                            If you have any questions about these Terms, please contact us at the Facilities Management Office of the University of Santo Tomas.
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button 
                        type="button" 
                        class="btn w-100 py-2" 
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