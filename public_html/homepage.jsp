<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        <title>Homepage</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body>
        <div class="d-flex vh-100">
            <!-- Sidebar Component -->
            
            <jsp:include page="sidebar.jsp"/>
            <!-- Main Content -->
           
            <div class="flex-grow-1 p-4">
                <div class="container">
                    <h1 class="my-4">Homepage</h1>

                    <div class="row">
                       
                        <c:forEach var="location" items="${locations}">
                            <div class="col-md-4">
                                <a href="buildingDashboard?buildingID=${itemLocId}" class="text-decoration-none"> 
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <h5 class="card-title">${location.locName}</h5>
                                            <p class="card-text">${location.locDescription}</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Bootstrap JS -->
                    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
                </div>
            </div>
        </div>
    </body>
</html>
