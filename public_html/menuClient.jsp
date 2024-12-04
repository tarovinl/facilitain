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
        </style>

    </head>

 <body class="d-flex flex-column min-vh-100">
    <!-- Header -->
    <jsp:include page="headerClient.jsp" />

    <!-- Main Content -->
    <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                <div class="card">
                    <div class="card-body   text-center ">
                        <!-- Logo -->
                        <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4" style="max-height: 4rem;">
                    <p> Welcome to Facilitain! </p>
                        <!-- Feedback Button -->
                        <div class="mt-3 d-flex justify-content-center px-0">
                            <a href="<%=request.getContextPath()%>/feedbackClient" class="w-100 ">
                                <button class="btn w-100" 
                                style="background-color: #fbbe15; border: none;">Make a Feedback</button>

                            </a>
                        </div>

                        <!-- Report Button -->
                        <div class="mt-3 d-flex justify-content-center px-0">
                            <a href="<%=request.getContextPath()%>/reportsClient" class="w-100">
                                <button class="btn w-100" 
                                style="background-color: #fbbe15; border: none;">Report a Problem</button>
                            </a>
                        </div>

                        <!-- Back Button -->
                        <div class="d-flex justify-content-center mt-3">
                             <button class="btn w-100" 
                                style="background-color: #fbbe15; border: none;">
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
