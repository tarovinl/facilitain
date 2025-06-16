<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error Page</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="./resources/css/custom-fonts.css">
        <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
        <style>
        body, h1, h2, h3, h4,h5, h6, th,label,.custom-label {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
 input, textarea, td, tr, p, select, option,id {
    font-family: 'NeueHaasLight', sans-serif !important;
}
 .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
            }

            .hover-outline:hover {
                background-color: #1C1C1C !important;
                color: #f2f2f2 !important;
                border: 1px solid #f2f2f2 !important;
            }
            .hover-outline img {
                transition: filter 0.3s ease;
            }

            .hover-outline:hover img {
                filter: invert(1);
            }
        </style>
    </head>
    <body class="bg-light d-flex justify-content-center align-items-center vh-100">
    <div class="container text-center">
        <div class="">
            <div class="card-body p-5">
                <h1 class="text-danger fw-bold" style="font-size: 8rem;">404</h1>

                <p class="h3 mb-4">Oops! Something went wrong with this section of the system. <br/> We're working to get things back on track. </p>
                <a href="./index" class="btn btn-lg hover-outline" style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">Return to Homepage</a>
            </div>
        </div>
    </div>
    
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>