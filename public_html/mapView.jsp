<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Map View Homepage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
     integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
     crossorigin=""/>
      <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
     integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
     crossorigin=""></script>
     
    <style>
    @media (max-width: 800px) {
        
        .map-container, #map {
                 height: 300px !important;
                display: flex !important;
                align-items: center !important;
        }
    }
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
            
            .leaflet-popup-content a {
              color: #1C1C1C;              /* Same as your regular text */
              text-decoration: none;      /* Remove underline */
              font-family: 'NeueHaasMedium', sans-serif;
              font-size:20px;
            }
            
            .leaflet-popup-content a:hover {
              color: #1C1C1C;              /* Prevent blue on hover */
              text-decoration: underline;      /* Prevent underline on hover */
            }
            
            
            .leaflet-popup-content-wrapper {
              background-color: #ffffff;
              border-radius: 12px;
              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
            }
            
            .leaflet-popup-tip {
              background-color: #fff8e1;
            }
            
            .popup-description{
                font-family: 'NeueHaasLight', sans-serif;
                font-size:15px;
            }
            .responsive-padding-top {
              padding-top: 80px;
            }
            
            @media (max-width: 576px) {
              .responsive-padding-top {
                padding-top: 70px; /* or whatever smaller value you want */
              }
    </style>
     
    </head>
    <body>
    <jsp:include page="navbar.jsp"/>
    <jsp:include page="sidebar.jsp"/>
<div class="container-fluid">
    <div class="row min-vh-100 ">
    <div class="col-md-10 mt-4 responsive-padding-top">
        <div class="container-fluid mcontainer  ">
            <div class="d-flex justify-content-between align-items-center  map-header mb-4">
                <div class="col d-flex align-items-center">
                <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Locations</h1>
              </div>
                <a href="./homepage" class="px-3 py-2 rounded-2 hover-outline text-dark text-decoration-none d-flex align-items-center justify-content-center"
                   style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
                  <img src="resources/images/icons/grid.svg"
                       alt="default"
                       class="icon"
                       width="25"
                       height="25"
                       style="vertical-align: middle;">
                  <span class="d-none d-lg-inline ps-2">Default View</span>
                </a>

            </div>
            <div class="row mt-2 mb-2 map-container" style="margin: 0; padding: 0;">
                <div id="map" style="width: 100%; height: 100%; border-radius:5px;"></div>
            </div>               
        </div>
    </div>
    </div>
</div>
    <script>
    function resizeMap() {
        const mapContainer = document.getElementById('map');
        const width = mapContainer.offsetWidth;  // Get the container's width
        mapContainer.style.height = width+'px';  // Set the height to match the width (square)
        map.invalidateSize();  // Update Leaflet map size
    }
    
    var customIcon = L.divIcon({
        className: 'custom-marker',
        html: `
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="50" viewBox="0 0 30 50">
                <path fill="#fccc4c" stroke="#000" stroke-width="2"
                    d="M15 1c-7.5 0-13.5 6-13.5 13.5S15 49 15 49s13.5-21.5 13.5-34C28.5 7 22.5 1 15 1z"/>
                <circle cx="15" cy="14" r="5" fill="#000"/>
            </svg>`,
        iconSize: [30, 50], 
        iconAnchor: [15, 50], 
        popupAnchor: [0, -50] 
    })

    var map = L.map('map').setView([14.610032805621275, 120.99003889129173], 18); // Center the map (latitude, longitude, zoom level)
    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);
    
    
    <c:forEach var="mapItem" items="${FMO_MAP_LIST}">
    L.marker([${mapItem.latitude}, ${mapItem.longitude}], { icon: customIcon }) //csen
        .addTo(map)
        .bindPopup('<div style="position: relative; "><c:forEach var="locStatus" items="${FMO_LOCATION_STATUS_LIST}"><c:if test="${locStatus.location.itemLocId == mapItem.itemLocId}"><c:choose><c:when test="${locStatus.statusRating == 3}"><div style="position: relative; display: block; width: fit-content; background-color: #28a745; color: white; padding: 4px 8px; border-radius: 5px; font-size: 0.9rem; font-weight: bold; z-index: 1;">Optimal</div></c:when><c:when test="${locStatus.statusRating == 2}"><div style="position: relative; display: block; width: fit-content; background-color: #ff9800; color: white; padding: 4px 8px; border-radius: 5px; font-size: 0.9rem; font-weight: bold; z-index: 1;">Moderate</div></c:when><c:when test="${locStatus.statusRating == 1}"><div style="position: relative; display: block; width: fit-content; background-color: #dc3545; color: white; padding: 4px 8px; border-radius: 5px; font-size: 0.9rem; font-weight: bold; z-index: 1;">Danger</div></c:when></c:choose></c:if></c:forEach><a href="./buildingDashboard?locID=${mapItem.itemLocId}" class="popup-link" style="margin-top: 4px; display: inline-block;" ><c:forEach var="locs" items="${locations}"><c:if test="${locs.itemLocId == mapItem.itemLocId}">${locs.locName}</c:if></c:forEach></a><div class="popup-description" style="margin-top: 4px;"><c:forEach var="locs" items="${locations}"><c:if test="${locs.itemLocId == mapItem.itemLocId}">${locs.locDescription}</c:if></c:forEach></div></div>'); // Static link
    </c:forEach>   
        
    window.addEventListener('resize', resizeMap);
    resizeMap();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    </body>
</html>