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
        <title>Agreement - Facilitain</title>
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
    
    </style>
    </head>
    <body class="d-flex flex-column min-vh-100" >
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
        <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
                <div class="card">
                    <div class="card-body ">
            <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4 d-block mx-auto" style="max-height: 4rem;">
            <h3 class="text-center p-2 montserrat-boldl ">AGREEMENT REMINDER:</h3>
          <p class=" text-center p-2"> 
          Filling up the form abides by the <br/>
          Data Privacy Act of 2012 where your <br/>
          personal data is collected but for <br/>
          record-keeping purposes only
          </p>
            <!-- Example Bootstrap Button -->
             <div class="mt-3 d-flex justify-content-center px-0">
                <button type ="button" onclick="window.location.href='feedbackClient.jsp';" class="montserrat-bold btn w-100 py-3 fs-5"  style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
        onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
        onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';">
                Agree
                </button>
            </div>
            <div class="mt-3 d-flex justify-content-center px-0">
                 <button type ="button" onclick="window.location.href='loginFeedbackClient.jsp';" class="montserrat-bold btn w-100 py-3 fs-5"  style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
        onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
        onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';">
                Disagree
                </button>
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
