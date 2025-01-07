
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

    <div>
       
        <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 4rem; line-height: 1.2;">Homepage</h1>
    </div>
    <c:choose>
        <c:when test="${sessionScope.role == 'Admin'}">
            <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addBuildingModal">
                <i class="bi bi-plus-lg"></i> Add
            </button>
        </c:when>
        <c:otherwise>
        </c:otherwise>
    </c:choose>
</div>


                <!-- Buildings Listing -->
                <div class="row">
                    <c:forEach var="location" items="${locations}">
                        <c:if test="${location.locArchive == 1}">
                            <div class="col-md-4">
                                <div class="card mb-4 position-relative" style="border:none;">
                                    <a href="buildingDashboard?locID=${location.itemLocId}" class="text-decoration-none" style="border-radius:20px;">
                                        <div class="card-body rounded-4" style="
                                            background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 100%),
                                            <c:choose>
                                                <c:when test="${location.hasImage}">
                                                    url('buildingdisplaycontroller?locID=${location.itemLocId}')
                                                </c:when>
                                                <c:otherwise>
                                                    url('resources/images/samplebuilding.jpg')
                                                </c:otherwise>
                                            </c:choose>;
                                            background-size: cover;
                                            background-position: center;
                                            min-height: 250px;
                                            display: flex;
                                            flex-direction: column;
                                            justify-content: flex-end;
                                            overflow: hidden;
                                            outline: none;">
                                            <h5 class="card-title text-light fs-4" style="font-family: 'NeueHaasMedium', sans-serif;">${location.locName}</h5>
                                            <p class="card-text text-light fs-6" style="font-family: 'NeueHaasLight', sans-serif;">${location.locDescription}</p>
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
<!-- Add Modal with Images -->
<div class="modal fade" id="addBuildingModal" tabindex="-1" aria-labelledby="addBuildingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="addbuildingcontroller" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBuildingModalLabel">Add Building</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="locName" class="form-label">Building Name</label>
                        <input type="text" class="form-control" id="locName" name="locName" placeholder="Enter building name" required>
                    </div>
                    <div class="mb-3">
                        <label for="locDescription" class="form-label">Building Description</label>
                        <input type="text" class="form-control" id="locDescription" name="locDescription" placeholder="Enter building description" required>
                    </div>
                    <div class="mb-3">
                        <label for="buildingImage" class="form-label">Building Image</label>
                        <input type="file" class="form-control" id="buildingImage" name="buildingImage" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Add</button>
                </div>
            </div>
        </form>
    </div>
</div>


<!-- Notification Popup -->
<div class="modal fade" id="notificationPopup" tabindex="-1" aria-labelledby="notificationPopupLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="notificationPopupLabel">Unread Notifications</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="notificationMessage"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
    <a href="<%=request.getContextPath()%>/notification" class="btn btn-primary">View Notifications</a>
            
                
            </div>
        </div>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<script>
window.onload = function() {
    fetch('/FMOCapstone/homepage/checkNotifications')
        .then(response => response.json())
        .then(data => {
            console.log("Fetched data:", data); // Ensure the data is logged correctly
            const unreadCount = data.unreadCount;
            if (unreadCount > 0) {
                // Show popup with the number of unread notifications
                document.getElementById('notificationMessage').textContent = "You have " + unreadCount + " unread notifications!";
                $('#notificationPopup').modal('show');
            } else {
                console.log("No unread notifications.");
            }
        })
        .catch(error => {
            console.error('Error checking notifications:', error);
        });
};

</script>
</body>
</html>
