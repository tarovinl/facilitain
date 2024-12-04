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
        
        <!-- Optional: Add a custom title -->
        <title>Thank you!</title>
    </head>
    <body class="d-flex flex-column min-vh-100">
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
 <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                <div class="card">
                    <div class="card-body ">
            <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4" style="max-height: 4rem;">
               
            <h3 class="text-center ">Report a Problem</h3>
          <p class=" text-center p-5"> 
         Thank you for reporting!<br/>
         We will handle this issue immediately.
          </p>
           
          
       <div class="container mt-3 d-flex justify-content-center"> 
    <button class="btn btn-primary w-100 text-dark" style="background-color: #fbbe15;border: none;" onclick="window.location.href='menuClient.jsp';">Back to Menu</button>
    </div>
     <div class="container mt-3 d-flex justify-content-center"> 
    <button class="btn btn-primary w-100 text-dark" style="background-color: #fbbe15;border: none;" onclick="window.location.href='reportsClient';">Back to Report</button>
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