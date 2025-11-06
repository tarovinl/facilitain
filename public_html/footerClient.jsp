<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="./resources/css/custom-styles.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <style>
            .montserrat-regular {
                font-family: "Montserrat", sans-serif;
                font-weight: 400;
                font-style: normal;
            }
            
            .nav-link-hover:hover {
                text-decoration: underline;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <footer class="bg-facilGray p-3 d-flex justify-content-between align-items-center w-auto" style="overflow-x: hidden;">
            <img src="./resources/images/FACILITAIN_FINAL2.png" alt="USTLOGO" class="img-fluid d-none d-md-block px-2" style="max-height: 3rem;" />
            <img src="./resources/images/FACILITAIN_FINAL2.png" alt="USTLOGO" class="img-fluid d-md-none px-2" style="max-height: 1.5rem;" />
            
            <ul class="nav col-md-4 justify-content-end">
                <li class="nav-item">
                    <a href="#" class="montserrat-regular text-light px-2 fs-6 fs-sm-6 fs-md-6 nav-link-hover" data-bs-toggle="modal" data-bs-target="#termsModal">
                        Terms
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="montserrat-regular text-light px-2 fs-6 fs-sm-6 fs-md-6 nav-link-hover" data-bs-toggle="modal" data-bs-target="#privacyModal">
                        Privacy
                    </a>
                </li>
            </ul>
        </footer>
        
        <!-- Include Terms Modal -->
        <jsp:include page="termsClient.jsp"/>
        <!-- Include Privacy Modal -->
        <jsp:include page="privacyClient.jsp"/>
        
        <!-- Ensure Bootstrap JS is loaded -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>