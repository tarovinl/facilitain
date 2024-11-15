<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Homepage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
</head>
<body>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 style="font-family: 'NeueHaas', sans-serif; font-size: 4rem; line-height: 1.2;">Homepage</h1>

                    <!-- Trigger Modal Button -->
                    <button class="btn btn-warning" data-toggle="modal" data-target="#addBuildingModal">
                        <i class="bi bi-plus-lg"></i> Add
                    </button>
                </div>

                <!-- Buildings Listing -->
                <div class="row">
                    <c:forEach var="location" items="${locations}">
                        <c:if test="${location.locArchive == 1}">
                            <div class="col-md-4">
                                <div class="card mb-4 position-relative" >
                                    <a href="buildingDashboard?locID=${location.itemLocId}" class="text-decoration-none" style="border-radius:20px;">
                                        <div class="card-body rounded-4" style=" background-image: 
                                        linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 100%), 
                                        url('resources/images/samplebuilding.jpg');background-size: cover;background-position: center;
                                        min-height: 250px;display: flex;flex-direction: column;justify-content: flex-end;
                                          overflow:hidden; ">
                                        <h5 class="card-title text-light fs-4">${location.locName}</h5>
                                        <p class="card-text text-light fs-6">${location.locDescription}</p>
                                        </div>

                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>



<!-- Add building modal -->
<div class="modal fade" id="addBuildingModal" tabindex="-1" role="dialog" aria-labelledby="addBuildingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form action="buildingController" method="post"> <!-- Form action to servlet -->
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBuildingModalLabel">Add Building</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Building Name (maps to locName in the model) -->
                    <div class="form-group">
                        <label for="locName">Building Name</label>
                        <input type="text" class="form-control" id="locName" name="locName" placeholder="Enter building name" required>
                    </div>
                    <!-- Building Description (maps to locDescription in the model) -->
                    <div class="form-group">
                        <label for="locDescription">Building Description</label>
                        <input type="text" class="form-control" id="locDescription" name="locDescription" placeholder="Enter building description" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-warning">Add</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>