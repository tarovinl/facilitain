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
        <!-- Optional: Add a custom title -->
        <title>FMO Report and Feedback</title>
    </head>
    <body>
   <!-- Respondent Landing Page-->
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
        <div class="w-100 h-100  bg-white d-flex flex-column justify-content-center align-items-center p-3">
        <div class="mw-50 h-75 bg-facilGray text-white p-5">
             <img src="resources/images/FACILITAIN.png" alt="FACILITAIN"
                 style="height: 4rem;"/>
          
            <!-- Example Bootstrap Button -->
             <div class="container mt-3 d-flex justify-content-center"> <!-- Centering with flexbox -->
        <a href="<%=request.getContextPath()%>/feedbackClient">
        <button class="btn btn-primary w-100">Make a Feedback</button>
        </a>
    </div>
    <div class="container mt-3 w-100 d-flex justify-content-center"> <!-- Centering with flexbox -->
    <a href="<%=request.getContextPath()%>/reportsClient">
        <button class="btn btn-primary w-100">Report a Problem</button>
        </a>
    </div>
    <div class="">
    <button class="btn text-white p-2" style="background-color: transparent;">
        <i class="bi bi-arrow-left-short"></i>Back
    </button>
</div>



        <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
         <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
