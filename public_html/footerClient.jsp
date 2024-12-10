<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
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
        </style>
    </head>
    <body>
    <footer class="bg-facilGray p-3 d-flex justify-content-between align-items-center w-auto" style="overflow-x: hidden;">
    <img src="./resources/images/FACILITAIN.png" alt="USTLOGO" class="img-fluid d-none d-md-block px-2" style="max-height: 3rem;" />
    <img src="./resources/images/FACILITAIN.png" alt="USTLOGO" class="img-fluid d-md-none px-2" style="max-height: 1.5rem;" />
    
    <ul class ="nav col-md-4 justify-content-end">
    <li class="nav-item">
    <a href="<%=request.getContextPath()%>/termsClient.jsp" class="${page == 'termsClient.jsp' ? 'active' : ''} montserrat-regular text-light px-2 fs-6 fs-sm-6 fs-md-6">
        Terms
    </a>
</li>
<li class="nav-item">
    <a href="<%=request.getContextPath()%>/privacyClient.jsp" class="${page == 'privacyClient.jsp' ? 'active' : ''} montserrat-regular text-light px-2 fs-6 fs-sm-6 fs-md-6">
        Privacy
    </a>
</li>

    </ul>
</footer>
</body>
</html>