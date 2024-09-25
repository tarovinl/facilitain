<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        <title>Homepage</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="&lt;%=request.getContextPath()%>/css/sidebar.css" rel="stylesheet"/>
    </head>
    <body>
        <div class="d-flex vh-100">
            <!-- Sidebar Component -->
            <jsp:include page="sidebar.jsp"/><!-- Main Content -->
            <div class="flex-grow-1 p-4">
                <div class="container">
                    <h1 class="my-4">Homepage</h1><!-- Mock Data for Buildings -->
                    <div class="row">
                        <!-- Building 1 -->
                        <div class="col-md-4">
                            <a href="&lt;%=request.getContextPath()%>/buildingDashboard.jsp"
                               class="text-decoration-none">
                                <div class="card mb-4">
                                    <img src="&lt;%=request.getContextPath()%>/images/albertus-magnus.jpg"
                                         class="card-img-top" alt="Albertus Magnus"/>
                                    <div class="card-body">
                                        <h5 class="card-title">Albertus Magnus</h5>
                                        <p class="card-text">
                                            <span class="badge bg-success">Operational</span>
                                        </p>
                                    </div>
                                </div></a>
                        </div>
                        <!-- Building 2 -->
                        <div class="col-md-4">
                            <a href="&lt;%=request.getContextPath()%>/buildingDashboard.jsp"
                               class="text-decoration-none">
                                <div class="card mb-4">
                                    <img src="&lt;%=request.getContextPath()%>/images/beato-angelico.jpg"
                                         class="card-img-top" alt="Beato Angelico"/>
                                    <div class="card-body">
                                        <h5 class="card-title">Beato Angelico</h5>
                                        <p class="card-text">
                                            <span class="badge bg-warning">Maintenance Required</span>
                                        </p>
                                    </div>
                                </div></a>
                        </div>
                        <!-- Building 3 -->
                        <div class="col-md-4">
                            <a href="&lt;%=request.getContextPath()%>/buildingDashboard.jsp"
                               class="text-decoration-none">
                                <div class="card mb-4">
                                    <img src="&lt;%=request.getContextPath()%>/images/benavides.jpg"
                                         class="card-img-top" alt="Benavides"/>
                                    <div class="card-body">
                                        <h5 class="card-title">Benavides</h5>
                                        <p class="card-text">
                                            <span class="badge bg-warning">Under Maintenance</span>
                                        </p>
                                    </div>
                                </div></a>
                        </div>
                    </div>
                    <!-- Bootstrap JS -->
                    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
                </div>
            </div>
        </div>
    </body>
</html>