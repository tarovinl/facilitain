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
        
        <title>Thank you!</title>
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
   <body class="d-flex flex-column min-vh-100" style="background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url('resources/images/ust-bg.jpg'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">
     <jsp:include page="headerClient.jsp"/>
        
    <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                <div class="card">
                    <div class="card-body   text-center ">
             <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4" style="max-height: 4rem;">
            <h3 class="text-center ">Feedback Form</h3>
          <p class=" text-center p-5"> 
         Thank you for your feedback! <br/>
         We greatly appreciate you taking the time to complete the form. Your input helps us improve our services.
          </p>
            
             <div class="container mt-3 d-flex justify-content-center"> <!-- Centering with flexbox -->
         <button class="btn  w-100 " style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
                     onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                    onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';" onclick="window.location.href='menuClient.jsp';">Back to Menu</button>
            </div>
            <div class="container mt-3 d-flex justify-content-center">
         <button class="btn  w-100"  style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
                     onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                    onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';" onclick="window.location.href='feedbackClient';">Back to Feedback</button>
            </div>
    
         </div>
        </div>
        </div>
        </div>
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
         <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
