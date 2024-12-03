<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
         <link rel="stylesheet" href="./resources/css/custom-styles.css">
    </head>
    <body>
    <footer class="bg-facilGray sticky-bottom p-3 d-flex justify-content-between align-items-center w-100">
    <img src="./resources/images/FACILITAIN.png" alt="USTLOGO" class="img-fluid d-none d-md-block" style="max-height: 4rem;" />
    <img src="./resources/images/FACILITAIN.png" alt="USTLOGO" class="img-fluid d-md-none" style="max-height: 2rem;" />
    <div >
    <a href="<%=request.getContextPath()%>/termsClient.jsp" class="${page == 'termsClient.jsp' ? 'active' : ''} pr-5">
             Terms and Conditions
        </a>
         <a href="<%=request.getContextPath()%>/privacyClient.jsp" class="${page == 'privacyClient.jsp' ? 'active' : ''}">
             Privacy Policy
        </a>
        </div>
</footer>
</body>
</html>