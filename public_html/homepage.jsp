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
            
            /* Search input styling */
            .search-container {
                position: relative;
                width: 100%;
                max-width: 500px;
            }
            
            .search-input {
                border: 1px solid #dee2e6;
                border-radius: 0.25rem;
                font-family: 'NeueHaasLight', sans-serif;
                padding: 0.5rem 0.75rem 0.5rem 4rem; 
                transition: all 0.3s ease;
                width: 100%;
                 text-indent: 1rem;
            }
            
            .search-input:focus {
                box-shadow: 0 0 0 0.25rem rgba(252, 204, 76, 0.25);
                border-color: #fccc4c;
            }
            
            .search-input::placeholder {
                padding-left: 2rem; 
            }
            
            .search-icon {
                position: absolute;
                left: 0.5rem; 
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                z-index: 2;
                pointer-events: none;
                font-size: 1rem; /* Control icon size */
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
                text-underline-offset: 3px; /* optional: makes it look cleaner */
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
                .search-container {
                    margin: 1rem 0;
                    max-width: 100%;
                }
            }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10">
            <div class="container-fluid">
                <!-- Header Section with Search Bar in Middle -->
                <div class="row header-row align-items-center py-4">
                    <div class="col-md-3 header-title">
                        <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 3rem; line-height: 1.2;">Homepage</h1>
                    </div>
                    
                    <!-- Search Bar (Middle) -->
                    <div class="col-md-6 d-flex justify-content-center">
                        <div class="search-container">
                            <form id="searchForm" action="searchBuildings" method="get">
                                <div class="position-relative">
                                    <span class="search-icon">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input type="text" class="form-control search-input" id="searchInput" name="query" 
                                        placeholder="Search buildings..." aria-label="Search buildings">
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Action Buttons (Right) -->
                    <div class="col-md-3 d-flex justify-content-end header-controls gap-2">
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin'}">
                                <button class="align-items-center d-flex btn btn-md topButtons px-3 py-2 rounded-1 hover-outline text-dark" 
                                    style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
                                    data-bs-toggle="modal" data-bs-target="#addBuildingModal">
                                    <img src="resources/images/icons/plus.svg" alt="add" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> 
                                    Add
                                </button>
                            </c:when>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>
                        <a href="./mapView" 
                            class="align-items-center d-flex btn btn-md topButtons px-3 py-1 rounded-2 hover-outline text-dark text-decoration-none" 
                            style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
                             <img src="resources/images/icons/map.svg" alt="map" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                            Map View
                        </a>
                    </div>
                </div>

                <!-- Buildings Listing -->
                <div class="row mt-4" id="buildingsContainer">
                    <c:forEach var="location" items="${locations}">
                        <c:if test="${location.locArchive == 1}">
                            <div class="col-sm-6 col-md-6 col-lg-4 col-xl-3 building-card">
                                <div class="card mb-4 position-relative shadow-sm hover-shadow hover-underline-title" >
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
                                            <h5 class="card-title text-light fs-4 " style="font-family: 'NeueHaasMedium', sans-serif;">${location.locName}</h5>
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
                    <h5 class="modal-title" id="addBuildingModalLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Add Building</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="locName" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Building Name</label>
                        <input type="text" class="form-control" id="locName" name="locName" placeholder="Enter building name" style="font-family: 'NeueHaasLight', sans-serif;" required>
                    </div>
                    <div class="mb-3">
                        <label for="locDescription" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Building Description</label>
                        <input type="text" class="form-control" id="locDescription" name="locDescription" placeholder="Enter building description" style="font-family: 'NeueHaasLight', sans-serif;" required>
                    </div>
                    <div class="mb-3">
                        <label for="buildingImage" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Building Image</label>
                        <input type="file" class="form-control" id="buildingImage" name="buildingImage" accept="image/*" style="font-family: 'NeueHaasLight', sans-serif;">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal" style="font-family: 'NeueHaasLight', sans-serif;">
                    Cancel
                    </button>
                   <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasLight', sans-serif;">
                    Add
                    </button>

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
                <h5 class="modal-title" id="notificationPopupLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Unread Notifications</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"  style="font-family: 'NeueHaasLight', sans-serif;"></button>
            </div>
            <div class="modal-body">
                <p id="notificationMessage"  style="font-family: 'NeueHaasLight', sans-serif;"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"  style="font-family: 'NeueHaasLight', sans-serif;">Close</button>
                <a href="<%=request.getContextPath()%>/notification" class="btn btn-primary"  style="font-family: 'NeueHaasLight', sans-serif;">View Notifications</a>
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
        
        buildingCards.forEach(function(card) {
            const title = card.querySelector('.card-title').textContent.toLowerCase();
            const description = card.querySelector('.card-text').textContent.toLowerCase();
            
            if (title.includes(searchTerm) || description.includes(searchTerm)) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    });
    
    
    searchInput.addEventListener('search', function() {
        if (this.value === '') {
            buildingCards.forEach(function(card) {
                card.style.display = '';
            });
        }
    });
});
</script>

</body>
</html>