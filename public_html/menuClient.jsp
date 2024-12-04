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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <!-- Optional: Add a custom title -->

        <title>Menu</title>
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
                            
       .btn {
        background-image: linear-gradient(to bottom, #fbbe15, #f39c12);
        border: none;
        transition: all 0.7s ease; /* Smooth transition for all properties */
        }

        .btn:hover {
        background-image: linear-gradient(to bottom, #f39c12, #fbbe15);
        color: #212529;
        }

       


        </style>
        

    </head>

 <body class="d-flex flex-column min-vh-100" style="background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url('resources/images/ust-bg.jpg'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">
    <!-- Header -->
    <jsp:include page="headerClient.jsp" />

    <!-- Main Content -->
    <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-12 col-md-10 col-lg-6 col-xl-6">
                <div class="card">
                    <div class="card-body  ">
                        <!-- Logo -->
                        <img src="resources/images/FMO-Logo.png" alt="FMO Logo" class="img-fluid  d-block mx-auto" style="max-height: 10rem;">
                        <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4 d-block mx-auto" style="max-height: 4rem;">
                    <p class="fs-5 montserrat-bold text-center"> Welcome to Facilitain! </p>
                        
                       <!-- Button Container with Flexbox -->

  <div class="d-flex justify-content-between">
    <!-- Feedback Button -->
    <div class="col-6 col-md-6 col-lg-6 pr-2 pl-2 ">
        <a href="<%=request.getContextPath()%>/feedbackClient" class="w-100 text-dark text-decoration-none">
            <button class="btn w-100 py-5 fs-6 d-flex flex-column align-items-center rounded-4 shadow-none focus:outline-none active:outline-none" 
            style="border: none;">
                <!-- Image on top of the text -->
                <img src="resources/images/icons/message-solid.svg" alt="Feedback Icon" class="mb-5" style="max-height: 5rem;">
                <span class=" montserrat-bold text-wrap">Make a Feedback</span>
            </button>

        </a>
        
    </div>

    <!-- Report Button -->
    <div class="col-6 col-md-6 col-lg-6 pr-2 pl-2">
        <a href="<%=request.getContextPath()%>/reportsClient" class="w-100 text-dark text-decoration-none">
            <button class="btn w-100 py-5 fs-6 d-flex flex-column align-items-center rounded-4 shadow-none focus:outline-none active:outline-none" 
            style=" border: none;">
            <!-- Image on top of the text -->
                <img src="resources/images/icons/triangle-exclamation-solid.svg" alt="Report Icon" class="mb-5" style="max-height: 5rem;">
               <span class=" montserrat-bold text-wrap"> Report a Problem</span>
            </button>
        </a>
    </div>
    

</div>


                        <!-- Back Button -->
                        <div class="d-flex  mt-3">
                             <button type ="button" onclick="window.location.href='agreementClient.jsp';" class="bbtn p-2" 
                                style="background-color: transparent; border: none;">
                                <i class="bi bi-arrow-left-short"></i>Back
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



<jsp:include page="footerClient.jsp"/>


        <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
         <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        
    </body>
</html>
