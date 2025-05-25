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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
     integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
     crossorigin=""/>
      <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
     integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
     crossorigin=""></script>
     
    <style>
    @media (max-width: 800px) {
        .map-header h1, .map-header button {
            display: none !important; /* Overrides conflicting styles */
        }
        .map-container, #map {
            height: 90vh !important; /* Set the map to take the full viewport height */
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
    </style>
     
    </head>
    <body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>
    <div class="col-md-10">
        <div class="container-fluid mcontainer">
            <div class="d-flex justify-content-between align-items-center pt-4 pb-4 map-header">
                <div>
                     <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 3rem; line-height: 1.2;">Homepage</h1>
                </div>
                <a href="./homepage" class="align-items-center d-flex px-3 py-2 rounded-1 hover-outline text-dark text-decoration-none" style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
                     <img src="resources/images/icons/grid.svg" alt="default" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                    Default View
                </a>
            </div>
            <div class="row mt-2 mb-2 map-container">
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
        .bindPopup('<a href="./buildingDashboard?locID=${mapItem.itemLocId}" target="_blank"><c:forEach var="locs" items="${locations}"><c:if test="${locs.itemLocId == mapItem.itemLocId}">${locs.locName}</c:if></c:forEach></a>'); // Static link
    </c:forEach>   
        
    window.addEventListener('resize', resizeMap);
    resizeMap();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    </body>
</html>