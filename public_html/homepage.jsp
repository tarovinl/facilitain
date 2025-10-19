<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Home - Facilitain</title>
   <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                font-size: 1rem; 
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
                .search-container {
                    max-width: 250px !important; /* or adjust as needed */
                     height: 2.5rem; /* reduce height */
                        font-size: 0.8rem; /* slightly smaller font */
                        padding-left: 2rem; /* slightly less padding if needed */
                  }
                  
            }
           .custom-search {
                  background-color: #f2f2f2 !important;
                  transition: background-color 0.3s ease, box-shadow 0.3s ease;
                  height: 2.75rem; /* or adjust as needed */
                  font-size: 0.9rem;
                  border-radius: 0.5rem;
                  padding-left: 2.5rem; /* space for the icon */
                  padding-right: 1rem;
                  border: 1px solid #ced4da;
                }
                
                /* When focused */
                .custom-search:focus {
                  background-color: #ffffff !important;
                  box-shadow: 0 0 0 0.15rem rgba(0, 123, 255, 0.25); /* optional glow */
                  outline: none;
                }
                body, html {
                  overflow-x: hidden !important;
                }
                #searchInput::placeholder {
                  padding-left: 0rem; /* Optional: fine-tune if needed */
                }
                
                .responsive-padding-top {
                  padding-top: 80px;
                }
                
                @media (max-width: 576px) {
                  .responsive-padding-top {
                    padding-top: 70px; /* or whatever smaller value you want */
                  }
                }
            
            #notificationBadge {
                top: -0.1em;
              right: -0.6em;
              position: absolute;
              display: inline-flex;
              align-items: center;
              justify-content: center;
              
              height: 1.6em;
              min-width: 1.6em;
              padding: 0;
              
              font-size: 0.75rem;
              font-weight: 700;
              color: white;
              background-color: red;
              
              border-radius: 50%;
              line-height: 1;
              text-align: center;
              white-space: nowrap;
              box-sizing: border-box;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
              padding-top: 0.2em;  
                }

                
                 .circle-hover {
                    width: 45px;
                    height: 45px;
                    border-radius: 50%;
                    display: inline-flex !important;
                    justify-content: center;
                    align-items: center;
                    transition: background-color 0.2s ease-in-out;
                  }
                
                  .circle-hover:hover {
                    background-color: #dbe4e9 !important;
                  }
                
                  .circle-hover img {
                    pointer-events: none; /* ensures hover is on the circle, not just the image */
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
                .icon-btn {
                width: 22px;
                height: 22px;
              }
               .circle-hover {
                    width: 35px;
                    height: 35px;
                   
                  }
            }
                .tooltip {
          font-family: 'NeueHaasLight', sans-serif !important;
          font-size: 0.75rem; /* Optional: adjust size if needed */
        }
            .custom-dropdown {
              position: absolute;
              top: 110%; /* appear below icon */
              right: 0;
              background-color: white;
              min-width: 200px;
              z-index: 1000;
              font-family: 'NeueHaasLight', sans-serif !important;
            }
            
            .dropdown-wrapper {
              position: relative;
            }
        #userButton {
          cursor: pointer;
        }
            .logout-btn {
              transition: color 0.3s ease, background-color 0.3s ease;
            }
            
            .logout-icon {
              filter: brightness(0) saturate(100%) invert(27%) sepia(95%) saturate(4900%) hue-rotate(352deg) brightness(90%) contrast(120%);
              transition: filter 0.3s ease;
            }
            
            .logout-btn:hover {
              color: white; /* Makes text white */
              background-color: #dc3545; /* Bootstrap danger red background */
            }
            
            .logout-btn:hover .logout-icon {
              filter: brightness(0) invert(1); /* Makes icon white */
            }
    </style>
</head>
<body>
<div class="container-fluid">
 <nav class="navbar bg-white py-3 mb-4 fixed-top border-bottom border-light-subtle" style="z-index: 1040;">
  <div class="container-fluid">
  <div class="row d-flex justify-content-center align-items-center flex-wrap w-100 gx-2">



    <!-- Logo -->
    <div class="col-4 col-md-3 order-md-1 text-start">
      <a href="<%=request.getContextPath()%>/homepage" class="p-0 d-inline-block">
        <img src="resources/images/FACILITAIN_WLOGO4.png"
             alt="Facilitain Home Logo"
             style="max-width: 100%; max-height: 50px;" />
      </a>
    </div>

    <!-- Search Bar  -->
   <div class="col-4 col-md-6 order-md-2 d-flex justify-content-center">
  <div class="search-container rounded-3">
    <form id="searchForm" action="searchBuildings" method="get">
      <div class="position-relative">
        <span class="search-icon"
              style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); z-index: 2;">
          <i class="bi bi-search"></i>
        </span>
        <input type="text"
               class="form-control ps-3 search-input custom-search"
               id="searchInput"
               name="query"
               placeholder="Search locations..."
               aria-label="Search buildings"
               style="width: 100%;">
      </div>
    </form>
  </div>
</div>

<div class="col-4 col-md-3 ms-auto order-md-3 text-end">
        <div class="d-flex justify-content-end align-items-center gap-1">

          <!-- Reports Icon -->
         <a href="reports" 
           class="circle-hover text-dark position-relative" 
           data-bs-toggle="tooltip" 
           data-bs-placement="bottom" 
           title="Reports">
          <img src="resources/images/icons/reportsb.svg" class="icon-btn" alt="Reports" width="28" height="28">
        </a>
        
       <a href="notification" 
           class="circle-hover text-dark position-relative" 
           data-bs-toggle="tooltip" 
           data-bs-placement="bottom" 
           title="Notifications">
          <img src="resources/images/icons/notifb.svg" class="icon-btn" alt="Notifications" width="28" height="28">
          <span id="notificationBadge" class="badge position-absolute">3</span>
        </a>

        
        <div class="dropdown-wrapper position-relative">
  <a id="userButton"
   class="circle-hover text-dark d-flex align-items-center gap-1"
   data-bs-toggle="tooltip"
   data-bs-placement="bottom"
   title="User"
   style="cursor: pointer;">
  <img src="resources/images/icons/person.svg" class="icon-btn" alt="User" width="28" height="28">
</a>


  <div id="userDropdown" class="custom-dropdown shadow p-3 rounded" style="display: none;">
    <div class="d-flex align-items-center gap-2 mb-2">
      
      <div class="d-flex flex-column text-start">
            <div class="fw-bold mb-0">${sessionScope.name}</div>
          <div class="text-muted" style="font-size: 0.85rem; margin-left: 0;">
    <c:choose>
        <c:when test="${sessionScope.role == 'Admin'}">
            Admin
        </c:when>
        <c:when test="${sessionScope.role == 'Support'}">
            Staff
        </c:when>
        <c:otherwise>
            User
        </c:otherwise>
    </c:choose>
</div>
        </div>

    </div>
    <a href="<%=request.getContextPath()%>/LogoutController"
   class="btn btn-sm btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 logout-btn">
  <img src="resources/images/icons/logout.svg" alt="Logout" class="logout-icon"
       style="width: 1.2em; height: 1.2em;">
  Log Out
</a>

  </div>
</div>



        </div>
      </div>

  </div>
</div>


    </div>
  </div>
</nav>

    <div class="row min-vh-100">
    <c:set var="page" value="homepage" scope="request"/>
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 mt-4 responsive-padding-top">
            <div class="container-fluid location-list">
                
                 <!-- 🔻 Action Buttons moved here -->
    <div class="row align-items-center mb-4">
  <!-- Left: Locations heading -->
  <div class="col d-flex align-items-center">
    <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Locations</h1>
  </div>

  <!-- Right: Action Buttons -->
  <div class="col-auto d-flex justify-content-end align-items-center gap-2 flex-wrap">
    <c:if test="${sessionScope.role == 'Admin'}">
      <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center"
              style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;"
              data-bs-toggle="modal" data-bs-target="#addBuildingModal">
        <img src="resources/images/icons/plus.svg" alt="add" class="icon" width="25" height="25">
        <span class="d-none d-lg-inline ps-2">Add Location</span>
      </button>
    </c:if>

    <a href="./mapView"
       class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark text-decoration-none d-flex align-items-center justify-content-center"
       style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
      <img src="resources/images/icons/map.svg" alt="map" class="icon" width="25" height="25">
      <span class="d-none d-lg-inline ps-2">Map View</span>
    </a>
  </div>
</div>

                
                <!-- Buildings Listing -->
                <div class="row mt-0" id="buildingsContainer">
                    <c:forEach var="location" items="${locations}">
                        <c:if test="${location.locArchive == 1}">
                            <div class="col-sm-6 col-md-6 col-lg-4 col-xl-3 building-card">
                                <div class="card mb-4 position-relative shadow-sm hover-shadow hover-underline-title rounded-2" >
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
                                            outline: none;
                                            position: relative;">
                                            <c:forEach var="locStatus" items="${FMO_LOCATION_STATUS_LIST}">
                                                <c:if test="${locStatus.location.itemLocId == location.itemLocId}">
                                                        <c:choose>
                                                            <c:when test="${locStatus.statusRating == 3}">
                                                                <div style="
                                                                    position: absolute;
                                                                    top: 10px;
                                                                    right: 10px;
                                                                   background-color: #28a745;
                                                                    color: white;
                                                                    padding: 4px 8px;
                                                                    border-radius: 5px;
                                                                    font-size: 0.9rem;
                                                                    font-weight: bold;
                                                                    z-index: 2;
                                                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
                                                                    Optimal
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${locStatus.statusRating == 2}">
                                                                <div style="
                                                                    position: absolute;
                                                                    top: 10px;
                                                                    right: 10px;
                                                                    background-color: #ff9800;
                                                                    color: white;
                                                                    padding: 4px 8px;
                                                                    border-radius: 5px;
                                                                    font-size: 0.9rem;
                                                                    font-weight: bold;
                                                                    z-index: 2;
                                                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
                                                                    Moderate
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${locStatus.statusRating == 1}">
                                                                <div style="
                                                                    position: absolute;
                                                                    top: 10px;
                                                                    right: 10px;
                                                                    background-color: #dc3545;
                                                                    color: white;
                                                                    padding: 4px 8px;
                                                                    border-radius: 5px;
                                                                    font-size: 0.9rem;
                                                                    font-weight: bold;
                                                                    z-index: 2;
                                                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
                                                                    Danger
                                                                </div>
                                                            </c:when>
                                                        </c:choose>
                                                </c:if>
                                            </c:forEach>
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
       <form id="addBuildingForm" action="addbuildingcontroller" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBuildingModalLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Add Location</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="locName" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Location Name</label>
                        
                        <input type="text" class="form-control" id="locName" name="locName" placeholder="Enter location name" style="font-family: 'NeueHaasLight', sans-serif;" maxlength="250" required>
                        <small class="text-muted" style="font-family: 'NeueHaasLight', sans-serif;">
                            <span id="nameCharCount">0</span>/250 characters
                        </small>
                    </div>
                    <div class="mb-3">
                        <label for="locDescription" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Location Description</label>
                        <!-- <CHANGE> Added maxlength and character counter -->
                        <input type="text" class="form-control" id="locDescription" name="locDescription" placeholder="Enter location description" style="font-family: 'NeueHaasLight', sans-serif;" maxlength="250" required>
                        <small class="text-muted" style="font-family: 'NeueHaasLight', sans-serif;">
                            <span id="descCharCount">0</span>/250 characters
                        </small>
                    </div>
                    <div class="mb-3">
                        <label for="buildingImage" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Location Image</label>
                        <input type="file" class="form-control" id="buildingImage" name="buildingImage" accept="image/*" style="font-family: 'NeueHaasLight', sans-serif;">
                        <small class="text-muted" style="font-family: 'NeueHaasLight', sans-serif;">
                            Maximum file size: 10MB
                        </small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal" style="font-family: 'NeueHaasMedium', sans-serif;">
                    Cancel
                    </button>
                   <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">
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

<script>
document.addEventListener('DOMContentLoaded', function() {
    const locNameInput = document.getElementById('locName');
    const locDescInput = document.getElementById('locDescription');
    const nameCharCount = document.getElementById('nameCharCount');
    const descCharCount = document.getElementById('descCharCount');
    
    // Update character count for name
    locNameInput.addEventListener('input', function() {
        nameCharCount.textContent = this.value.length;
    });
    
    // Update character count for description
    locDescInput.addEventListener('input', function() {
        descCharCount.textContent = this.value.length;
    });
});
</script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const addBuildingForm = document.getElementById('addBuildingForm');
    const buildingImageInput = document.getElementById('buildingImage');
    
    // Form submission validation
    addBuildingForm.addEventListener('submit', function(e) {
        const locName = document.getElementById('locName').value.trim();
        const locDescription = document.getElementById('locDescription').value.trim();
        const imageFile = buildingImageInput.files[0];
        
        // Validate name length
        if (locName.length > 250) {
            e.preventDefault();
            Swal.fire({
                title: 'Validation Error',
                text: 'Location name must not exceed 250 characters.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return false;
        }
        
        // Validate description length
        if (locDescription.length > 250) {
            e.preventDefault();
            Swal.fire({
                title: 'Validation Error',
                text: 'Location description must not exceed 250 characters.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return false;
        }
        
        // Validate file size (5MB = 5 * 1024 * 1024 bytes)
        if (imageFile && imageFile.size > 5 * 1024 * 1024) {
            e.preventDefault();
            Swal.fire({
                title: 'File Too Large',
                text: 'Image file size must not exceed 5MB. Please choose a smaller file.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return false;
        }
    });
    
    // Handle SweetAlert2 notifications for success/error messages
    const urlParams = new URLSearchParams(window.location.search);
    const action = urlParams.get('action');
    const error = urlParams.get('error');
    const errorMsg = urlParams.get('errorMsg');

    if (action || error) {
        let alertConfig = {
            confirmButtonText: 'OK',
            allowOutsideClick: false
        };

        if (error) {
            alertConfig = {
                ...alertConfig,
                title: 'Error!',
                text: errorMsg || 'An error occurred while adding the location.',
                icon: 'error'
            };
        } else if (action === 'added') {
            alertConfig = {
                ...alertConfig,
                title: 'Success!',
                text: 'The new location has been successfully added.',
                icon: 'success'
            };
        }

        Swal.fire(alertConfig).then(() => {
            // Remove the parameters from the URL without refreshing
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        });
    }
});
</script>


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
<script>
  // Initialize all tooltips on the page
  document.addEventListener('DOMContentLoaded', function () {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });
  });
</script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const userButton = document.getElementById('userButton');
    const dropdown = document.getElementById('userDropdown');

    userButton.addEventListener('click', function (e) {
      e.stopPropagation();
      dropdown.style.display = dropdown.style.display === 'none' || dropdown.style.display === '' ? 'block' : 'none';
    });

    document.addEventListener('click', function (e) {
      if (!dropdown.contains(e.target)) {
        dropdown.style.display = 'none';
      }
    });
  });
</script>
</body>
</html>