<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
     
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
 
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
  
    
    <style>
               

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
            
            .card:focus,
            .card:active {
                 outline: none;
            }
            .hover-shadow:hover {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.4) !important;
            }
           .hover-underline-title:hover .card-title {
                 text-decoration: underline;
                     text-decoration-color: white;
                text-underline-offset: 3px; 
                }
                
            /* Responsive adjustments */
            @media (max-width: 767.98px) {
                .header-row {
                    flex-direction: column;
                    align-items: flex-start !important;
                }
                .header-title {
                    margin-bottom: 1rem;
                }
                .header-controls {
                    width: 100%;
                    justify-content: space-between;
                }
                
body, html {
  overflow-x: hidden !important;
}
#searchInput::placeholder {
  padding-left: 0rem; /* Optional: fine-tune if needed */
}


    </style>
    </head>
    <body>
    <div class="container-fluid">
 <nav class="navbar bg-white py-3 mb-4 fixed-top border-bottom border-light-subtle" style="z-index: 1040;">
  <div class="container-fluid">
  <div class="row align-items-center flex-wrap w-100 gx-2">



    <!-- Logo -->
    <div class="col-4 col-md-3 order-md-1 text-start">
      <a href="<%=request.getContextPath()%>/homepage" class="p-0 d-inline-block">
        <img src="resources/images/FACILITAIN_WLOGO4.png"
             alt="Facilitain Home Logo"
             style="max-width: 100%; max-height: 50px;" />
      </a>
    </div>

    



  </div>
</div>


    </div>
  </div>
</nav>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    </body>
</html>