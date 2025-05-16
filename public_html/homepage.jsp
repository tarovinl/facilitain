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
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10">
            <div class="container-fluid">
               <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 pt-4 pb-4">
                    <div>
                        <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 3rem; line-height: 1.2;">Homepage</h1>
                    </div>
                    
                    <!-- Search Bar -->
                      <div class="col-12 col-md-4 position-relative">
                        <i class="bi bi-search position-absolute" style="left: 4px; top: 50%; transform: translateY(-50%); z-index: 10; color: #6c757d;"></i>
                        <input type="text" class="form-control ps-4" id="searchInput" 
                            placeholder="Search buildings..." aria-label="Search buildings" 
                            style="font-family: 'NeueHaasLight', sans-serif; padding-left: 45px; border-radius: 4px;">
                    </div>
                    
                    <div class="d-flex gap-2">
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin'}">
                                <button class="topButtons px-3 py-2 rounded-1 hover-outline text-dark" 
                                    style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
                                    data-bs-toggle="modal" data-bs-target="#addBuildingModal">
                                    <i class="bi bi-plus-lg"></i> Add
                                </button>
                            </c:when>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>
                        <a href="./mapView" 
                            class="topButtons px-3 py-2 rounded-1 hover-outline text-dark text-decoration-none" 
                            style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
                            Map View
                        </a>
                    </div>
                </div>

                <!-- Buildings Listing -->
                <div class="row" id="buildingsContainer">
                    <!-- No results message -->
                    <div id="noResultsMessage" class="col-12 text-center py-5" style="display: none;">
                        <h4 style="font-family: 'NeueHaasMedium', sans-serif;">No buildings found</h4>
                        <p style="font-family: 'NeueHaasLight', sans-serif;">Try a different search term</p>
                    </div>
                    
                    <c:forEach var="location" items="${locations}">
                        <c:if test="${location.locArchive == 1}">
                            <div class="col-sm-6 col-md-6 col-lg-4 col-xl-3 building-card">
                                <div class="card mb-4 position-relative border border-1 shadow-sm" >
                                    <a href="buildingDashboard?locID=${location.itemLocId}" class="text-decoration-none" style="border-radius:20px;">
                                        <div class="card-body rounded-2" style="
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

<!-- Client-side search functionality -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    const buildingCards = document.querySelectorAll('.building-card');
    
    // Real-time search filtering
    searchInput.addEventListener('keyup', function() {
        const searchTerm = this.value.toLowerCase();
        
        // Count visible cards
        let visibleCount = 0;
        
        buildingCards.forEach(function(card) {
            const title = card.querySelector('.card-title').textContent.toLowerCase();
            const description = card.querySelector('.card-text').textContent.toLowerCase();
            
            if (title.includes(searchTerm) || description.includes(searchTerm)) {
                card.style.display = '';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });
        
        // If no results, show message (add a no-results div to your page)
        const noResultsEl = document.getElementById('noResultsMessage');
        if (noResultsEl) {
            if (searchTerm && visibleCount === 0) {
                noResultsEl.style.display = 'block';
            } else {
                noResultsEl.style.display = 'none';
            }
        }
    });
    
    // Clear search when the X is clicked (for browsers that support it)
    searchInput.addEventListener('search', function() {
        if (this.value === '') {
            buildingCards.forEach(function(card) {
                card.style.display = '';
            });
            
            // Hide no results message if visible
            const noResultsEl = document.getElementById('noResultsMessage');
            if (noResultsEl) {
                noResultsEl.style.display = 'none';
            }
        }
    });
});
</script>

</body>
</html>