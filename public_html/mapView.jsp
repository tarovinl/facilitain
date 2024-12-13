<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Map View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
     integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
     crossorigin=""/>
      <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
     integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
     crossorigin=""></script>
    </head>
    <body>
<div class="row min-vh-100">
  <jsp:include page="sidebar.jsp"/>
  <div class="col-md-10">
    <div class="container-fluid h-100 d-flex flex-column">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 4rem; line-height: 1.2;">Homepage</h1>
        </div>
        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addBuildingModal">
          <i class="bi bi-plus-lg"></i> Add
        </button>
      </div>
      <!-- Map container that dynamically adjusts height -->
      <div class="map-container" id="map" style="width: 100%; border-radius:5px;"></div>
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
      
    var map = L.map('map').setView([14.610032805621275, 120.99003889129173], 18); // Center the map (latitude, longitude, zoom level)
    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    
    <c:forEach var="mapItem" items="${FMO_MAP_LIST}">
    L.marker([${mapItem.latitude}, ${mapItem.longitude}]) //csen
        .addTo(map)
        .bindPopup('<a href="./buildingDashboard?locID=${mapItem.itemLocId}" target="_blank"><c:forEach var="locs" items="${locations}"><c:if test="${locs.itemLocId == mapItem.itemLocId}">${locs.locName}</c:if></c:forEach></a>'); // Static link
    </c:forEach>   
        
    window.addEventListener('resize', resizeMap);
    resizeMap();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    </body>
</html>