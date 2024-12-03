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
        <title>Agreement</title>
    </head>
    <body>
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
        <div class="w-100 h-100 bg-white d-flex flex-column justify-content-center align-items-center p-3">
    <div class="mw-50 h-auto bg-facilGray text-white p-3 p-md-5 rounded">
        <!-- Responsive Logo -->
        <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4" style="max-height: 4rem;">
        
        <!-- Feedback Button -->
        <div class="container mt-3 d-flex justify-content-center px-0">
            <a href="<%=request.getContextPath()%>/feedbackClient" class="w-100">
                <button class="btn btn-primary w-100">Make a Feedback</button>
            </a>
        </div>

        <!-- Report Button -->
        <div class="container mt-3 d-flex justify-content-center px-0">
            <a href="<%=request.getContextPath()%>/reportsClient" class="w-100">
                <button class="btn btn-primary w-100">Report a Problem</button>
            </a>
        </div>

        <!-- Back Button -->
        <div class="d-flex justify-content-center mt-3">
            <button class="btn text-white p-2" style="background-color: transparent;">
                <i class="bi bi-arrow-left-short"></i>Back
            </button>
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
