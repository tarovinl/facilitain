<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <meta charset="utf-8">
         <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <!-- Bootstrap CSS -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <!-- Optional: Add a custom title -->
        <title>Terms and Conditions</title>
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
    </head>
    <body class="d-flex flex-column min-vh-100" >
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
        <div class="w-100 h-100  bg-white d-flex flex-column  p-3">
        
           
            <h1 class="text-center pt-3 fw-bold montserrat-bold">Terms and Conditions</h1>
          <h2 class="text-left p-5 montserrat-bold"> 
         Effective October 2024
          </h2>
          
          <p class="pl-5 pr-5 montserrat-regular">
          Welcome to FACILITAIN, the Academic Facility Maintenance Tracker for the Facilities Management Office of the
          University of Santo Tomas ("UST", "we", "our", or "us"). By accessing or using our website, you agree to comply 
          with and be bound by the following terms and conditions ("Terms"). If you do not agree to these Terms, please do not use our website.<br/> <br/>
          
          1. Acceptance of Terms <br/>
By accessing and using FACILITAIN, you acknowledge that you have read, understood, and agree to be bound by these Terms, as well as any additional guidelines, rules, and policies referenced herein. <br/><br/>

         2. Changes to Terms <br/> 
We reserve the right to modify these Terms at any time. Any changes will be effective immediately upon posting on our website. Your continued use of the website following the posting of changes constitutes your acceptance of those changes. <br/> <br/>

         3. User Responsibilities <br/>
            As a user of FACILITAIN, you agree to:<br/>
            • Provide accurate, current, and complete information as prompted by the website’s registration forms.<br/>
            • Maintain the confidentiality of your account credentials and restrict access to your account.
          </p>
            <!-- Example Bootstrap Button -->
             <div>
                <button type="button" onclick="window.location.href='menuClient.jsp';" class="btn w-100 py-3 fs-5" 
                                style="background-color: #fbbe15; border: none;">
                    <i class="bi bi-arrow-left-short"></i>Back
                </button>
            </div>
    
            
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
         <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
