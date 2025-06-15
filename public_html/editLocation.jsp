<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%> 
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Location</title>
        <link rel="stylesheet" href="resources/css/eBuilding.css">
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.css" />
        <!-- DataTables JS -->
        <script src="https://cdn.datatables.net/2.1.8/js/dataTables.js"></script>
        <!-- Bootstrap 5 CSS and JS -->
       <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Bundle JS (includes Popper.js) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.js"></script>
         <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
         integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
         crossorigin=""/>
          <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
         integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
         crossorigin=""></script>
         
         <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
         <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
            <link rel="stylesheet" href="./resources/css/custom-fonts.css">
            <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
   body, h1, h2,h3, h4,h5, th,label   {
        font-family: 'NeueHaasMedium', sans-serif !important;
    }
     h6,input, textarea,td,tr, p {
        font-family: 'NeueHaasLight', sans-serif !important;
    }
    
    .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
                            }

            .hover-outline:hover {
                background-color: 	#1C1C1C !important;
                color: 	#f2f2f2 !important;
                border: 1px solid 	#f2f2f2 !important;
                                }
            .hover-outline img {
                transition: filter 0.3s ease;
                                }

            .hover-outline:hover img {
                filter: invert(1);
                            }

            .buttonsBack:hover {
                text-decoration: underline !important;
                }
                
.btn-cancel-outline {
  color: #8388a4 !important;        /* Text color */
  background-color: white !important; /* White background */
  border: 2px solid #8388a4 !important; /* Outline */
  box-shadow: none !important;       /* Remove default shadow */
}

/* Optional: add hover effect */
.btn-cancel-outline:hover {
  background-color: #f0f2f7 !important; /* Light gray bg on hover */
  border-color: #8388a4 !important;
  color: #8388a4 !important;
}
</style>
<script>
    $(document).ready(function () {
        const maxChars = 250;
        const $textarea = $('#locDescription');
        const $charCount = $('#charCount');

        // Initialize the count
        $charCount.text(`${$textarea.val().length} / ${maxChars} characters`);

        $textarea.on('input', function () {
            let text = $(this).val();
            if (text.length > maxChars) {
                $(this).val(text.substring(0, maxChars));
                text = $(this).val(); // Update the value after trim
            }
            $charCount.text(`${text.length} / ${maxChars} characters`);
        });
    });
</script>

    
    </head>
    

    
    <%
    String fullBuildingID = request.getParameter("locID");
    String locID = fullBuildingID.split("/")[0]; 
    request.setAttribute("locID", locID);
    %>
    
    <c:forEach items="${locations}" var="location">
    <c:if test="${location.itemLocId == locID}">
        <c:set var="locName" value="${location.locName}" />
        <c:set var="locDescription" value="${location.locDescription}" />
    </c:if>
    </c:forEach>
    
<body>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
       
    
    <div class="col-md-10">
        <div class="topButtons"> <!-- top buttons -->
            <div>
                <!-- Link component remains unchanged -->
                
                <a href="./buildingDashboard?locID=${locID}" class="buttonsBack pt-4 d-flex align-items-center gap-2 text-decoration-none text-dark fs-4" 
   style="margin-left: 2px; font-family: NeueHaasLight, sans-serif;">
    <img src="resources/images/icons/angle-left-solid.svg" alt="back icon" width="20" height="20">
    Back
</a>
            </div>
        </div>
        <div class="container">
        <div class="editbuildingName">
            <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 4rem; line-height: 1.2;">Edit Location</h1>
        </div>
        <div class="floorAndButtons">
            <div class="locName">
              <h3 class="fw-bold">${locName}</h3>
            </div>
            
            <div class="d-flex flex-column flex-lg-row gap-2">
    <button class="buttonsBuilding align-items-center d-flex btn btn-md px-3 py-2 rounded-1 hover-outline text-dark" 
        style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
        data-toggle="modal" data-target="#addFloor" type="button">
        Add Floor
    </button>

    <button class="buttonsBuilding archive-location-btn align-items-center d-flex btn btn-md px-3 py-2 rounded-1 hover-outline text-dark" 
        style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
        href="#" data-bs-toggle="modal" type="button" onclick="">
        Archive Location
    </button>
</div>

        </div>

        <form action="buildingController" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="locID" value="${locID}"> <!-- Ensure this value is correctly set -->

    <div class="row mt-4">
        <div class="col-12 col-md-6">
            <!-- Location Name Section -->
            <div class="row">
                <div class="col">
                    <label for="locName" class="form-label fw-bold h4">Location Name</label>
                    <input type="text" class="form-control" id="locName" name="locName" value="${locName}" required>
                </div>
            </div>
    
            <!-- Description Section -->
            <div class="row mt-3">
                <div class="col">
                    <label for="locDescription" class="form-label fw-bold h4">Description</label>
                    <textarea class="form-control" id="locDescription" name="locDescription" rows="3" maxlength="250">${locDescription}</textarea>
                    <small id="charCount" class="form-text text-muted">0 / 250 characters</small>
                </div>
            </div>
    
            <!-- Image Upload Section -->
            <div class="row mt-3">
                <div class="col">
                    <h4 class="fw-bold mt-3">Change Location Image</h4>
                    <!-- File Input -->
                    <div class="mb-3">
                        <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6">
            <div class="row">
                <div class="col" id="parentMap">
                    <label for="mapCoord" class="form-label fw-bold h4">Choose your location:</label>
                    <h6 class="text-secondary fw-normal"  style="font-family: 'NeueHaasLight', sans-serif;">Click on the map to choose the location's area. Click the Reset button to undo.</h6>
                    <input type="hidden" class="form-control" id="mapCoord" name="mapCoord">
                    <div id="map" style="width: 100%; height: 256px; border-radius:5px;"></div>
                </div>           
            </div> 
        </div>
    </div>
    <!-- Save & Reset Buttons Section -->
    <div class="row mt-2" >
        <div class="col text-center">
            <input type="submit" value="Save Changes" class="btn btn-dark text-warning btn-lg mt-4 w-75 fw-bolder" style="font-family: NeueHaasMedium, sans-serif !important;">
        </div> 
        <div class="col text-center">
            <button type="button" class="btn btn-dark text-warning btn-lg mt-4 w-75 fw-bold"  style="font-family: NeueHaasMedium, sans-serif !important;" onclick="location.reload()">Reset</button>
        </div> 
    </div>
</form>

                <div class="row mt-4">
                    <div class="col dropTbl">
                        <table id="flrTable" class="display" style="width:100%;">
                            <thead>
                              <tr>
                                <th>Edit</th>
                                <th>Archive</th>
                                <th>Floor ID</th>
                                <th>Floor Name</th>
                                <th>Description</th>
                              </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="floors" items="${FMO_FLOORS_LIST2}">
                                    <c:if test="${floors.itemLocId == locID}">
                                        <c:if test="${floors.locArchive == 1}">
                                     <tr style="border: solid 1px black;">
                                        <td>
                                            <input type="image" 
                                                src="resources/images/editItem.svg" 
                                                id="editModalButton" 
                                                alt="Open Edit Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-flrid="${floors.itemLocFlrId}"
                                                data-flrname="${floors.locFloor}"
                                                data-flrdesc="${floors.locDescription}"
                                                data-target="#editFloor"
                                                onclick="populateEditModal(this)">
                                        </th>
                                        <td>
                                            <input type="image" 
                                                src="resources/images/archiveItem.svg" 
                                                id="archFlrModalButton" 
                                                alt="Open Archive Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-aflrid="${floors.itemLocFlrId}"
                                                data-aflrname="${floors.locFloor}"
                                                data-target="#archiveFloor"
                                                onclick="populateArchFlrModal(this)">
                                        </th>
                                        <td>${floors.itemLocFlrId}</td>
                                        <td>${floors.locFloor}</td>
                                        <td>${floors.locDescription != null ? floors.locDescription : 'N/A'}</td>
                                     </tr>
                                        </c:if>
                                    </c:if>
                                </c:forEach> 
                              
                              <!--<tr>
                                <th scope="row">Edit button</th>
                                <td>111</td>
                                <td>12F</td>
                              </tr>-->
                            </tbody>
                        </table>
                    </div>
                </div>
</div>
                <!--<div class="row mt-3 mb-4">
                    <div class="col dropTbl mb-4">
                        <div class="floorDLblDiv">
                            <h4 class="fw-bold mt-2 archivedLbl">
                                <button onclick="showArchivedTbl()">Archived Floors</button>
                            </h4>
                        </div>
                        <table class="archivedFloorTbl table table-striped table-bordered border border-dark mb-4">
                            <thead class="table-dark">
                              <tr>
                                <th scope="col"></th>
                                <th scope="col">Floor ID</th>
                                <th scope="col">Floor Name</th>
                                <th scope="col">Description</th>
                                <th scope="col"></th>
                              </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="floors" items="${FMO_FLOORS_LIST2}">
                                    <c:if test="${floors.itemLocId == locID}">
                                    <c:if test="${floors.locArchive == 2}">
                                     <tr>
                                        <th scope="row">
                                            <input type="image" 
                                                src="resources/images/editItem.svg" 
                                                id="editModalButton" 
                                                alt="Open Edit Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-flrid="${floors.itemLocFlrId}"
                                                data-flrname="${floors.locFloor}"
                                                data-flrdesc="${floors.locDescription}"
                                                data-target="#editFloor"
                                                onclick="populateEditModal(this)">
                                        </th>
                                        <td>${floors.itemLocFlrId}</td>
                                        <td>${floors.locFloor}</td>
                                        <td>${floors.locDescription != null ? floors.locDescription : 'N/A'}</td>
                                        <th scope="row">
                                            <input type="image" 
                                                src="resources/images/editItem.svg" 
                                                id="archFlrModalButton" 
                                                alt="Open Edit Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-acflrid="${floors.itemLocFlrId}"
                                                data-acflrname="${floors.locFloor}"
                                                data-target="#activateFloor"
                                                onclick="populateUnarchFlrModal(this)">
                                        </th>
                                     </tr>
                                    </c:if>
                                    </c:if>
                                </c:forEach> 
                              --><!--<tr>
                                <th scope="row">Unarchive button</th>
                                <td>111</td>
                                <td>12F</td>
                              </tr>--><!--
                            </tbody>
                        </table>
                    </div>
                </div>-->
            </div>
        </div>
    </div>
</div>

<!-- edit floor modal -->
<div class="modal fade" id="editFloor" tabindex="-1" role="dialog" aria-labelledby="editFloor" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="floorcontroller" method="POST">
                        <div class="row">
                            <div class="col">
                                <h3 class="fw-bold">Edit Floor</h3>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col">
                                <label for="flrName" class="fw-bold">Floor Name</label>
                                <input type="text" name="editFlrName" id="editFlrName" class="form-control mt-3" maxlength="15" required>
                            </div>
                        </div>
                        <input type="hidden" name="editFlrLocID" id="editFlrLocID" class="form-control" value="${locID}">
                        <input type="hidden" name="editFlrID" id="editFlrID" class="form-control">
                        <input type="hidden" name="locID" value="${locID}">
                        <div class="row mt-3">
                            <div class="col">
                                <label for="flrDesc" class="fw-bold">Floor Description</label>
                                <textarea class="form-control mt-3" name="editFlrDesc" id="editFlrDesc" rows="2"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col text-center">
                                <input type="submit" value="Save" class="btn btn-warning btn-lg mt-4 w-100 fw-bold">
                            </div> 
                            <div class="col text-center">
                                <button type="button" class="btn btn-warning btn-lg mt-4 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                            </div> 
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- end of edit floor modal -->


<!--add floor modal-->
<div class="modal fade" id="addFloor" tabindex="-1" aria-labelledby="addFloorLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form action="floorcontroller" method="POST">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="addFloorLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Add Floor</h5>
          <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="addFlrName" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Floor Name <span style="color: red;">*</span></label>
            <input type="text" name="addFlrName" id="addFlrName" class="form-control" maxlength="15" style="font-family: 'NeueHaasLight', sans-serif;" required>
          </div>
          <div class="mb-3">
            <label for="addFlrDesc" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Floor Description</label>
            <textarea class="form-control" name="addFlrDesc" id="addFlrDesc" rows="2" style="font-family: 'NeueHaasLight', sans-serif;"></textarea>
          </div>
          <input type="hidden" name="addFlrLocID" id="addFlrLocID" class="form-control" value="${locID}">
          <input type="hidden" name="locID" value="${locID}">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-danger" data-dismiss="modal" style="font-family: 'NeueHaasMedium', sans-serif;">Cancel</button>
          <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">Save</button>
        </div>
      </div>
    </form>
  </div>
</div>


<!-- end of add floor modal -->


<!-- archive floor modal -->
<div class="modal fade" id="archiveFloor" tabindex="-1" role="dialog" aria-labelledby="archiveFloor" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="floorcontroller" method="POST">
                        <div class="row">
                            <div class="col text-center">
                                <h2 class="fw-bold" id="archYouSure"></h2>
                            </div>
                        </div>
                        <input type="hidden" name="locID" value="${locID}">
                        <input type="hidden" name="archiveFlrLocID" id="archiveFlrLocID" class="form-control" value="${locID}">
                        <input type="hidden" name="archiveFlrID" id="archiveFlrID" class="form-control">
                        <input type="hidden" name="archiveFlr" id="archiveFlr" class="form-control">
                        <div class="row">
                            <div class="col text-center">
                                <input type="submit" value="Save" class="btn btn-warning btn-lg mt-4 w-100 fw-bold">
                            </div> 
                            <div class="col text-center">
                                <button type="button" class="btn btn-warning btn-lg mt-4 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                            </div> 
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- end of archive floor modal -->

<!-- activate floor modal -->
<div class="modal fade" id="activateFloor" tabindex="-1" role="dialog" aria-labelledby="activateFloor" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="floorcontroller" method="POST">
                        <div class="row">
                            <div class="col text-center">
                                <h2 class="fw-bold" id="actYouSure"></h2>
                            </div>
                        </div>
                        <input type="hidden" name="locID" value="${locID}">
                        <input type="hidden" name="activateFlrLocID" id="archiveFlrLocID" class="form-control" value="${locID}">
                        <input type="hidden" name="activateFlrID" id="archiveFlrID" class="form-control">
                        <input type="hidden" name="activateFlr" id="archiveFlr" class="form-control">
                        <div class="row">
                            <div class="col text-center">
                                <input type="submit" value="Save" class="btn btn-warning btn-lg mt-4 w-100 fw-bold">
                            </div> 
                            <div class="col text-center">
                                <button type="button" class="btn btn-warning btn-lg mt-4 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                            </div> 
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- end of activate floor modal -->


<!-- archive location modal -->
<!--<div class="modal fade" id="archiveLocation" tabindex="-1" role="dialog" aria-labelledby="archiveLocation" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="buildingcontroller" method="POST">
                        <div class="row">
                            <div class="col text-center">
                                <h2 class="fw-bold">Are you sure you want to archive ${locName}?</h2>
                            </div>
                        </div>
                        <input type="hidden" name="locID" value="${locID}">
                        <input type="hidden" name="archiveLocID" id="archiveLocID" class="form-control" value="${locID}">
                        <div class="row">
                            <div class="col text-center">
                                <input type="submit" value="Save" class="btn btn-warning btn-lg mt-4 w-100 fw-bold">
                            </div> 
                            <div class="col text-center">
                                <button type="button" class="btn btn-warning btn-lg mt-4 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                            </div> 
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>-->

<form id="archiveLocForm" action="buildingController" method="POST" style="display: none;" enctype="multipart/form-data">
    <input type="hidden" name="locID" value="${locID}">
    <input type="hidden" name="archiveLocID" id="archiveLocID" class="form-control" value="${locID}">
</form>
<!-- end of archive location modal -->

            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Initialize DataTable for #allItemsTable
                    let flrTable = new DataTable('#flrTable', {
                        paging: true,
                        searching: true,
                        ordering: true,
                        info: true,
                        stateSave: true,
                        scrollX: true,
                        columnDefs: [
                            { targets: "_all", className: "dt-center" }, // Center-align all columns
                            { targets: 0, orderable: false }, 
                            { targets: 1, orderable: false }, 
                            { targets: 4, orderable: false } 
                        ]
                    });
    
                });
            </script>
<script>
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
    var marker;
    
    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);
    
    map.on('click', function (e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
    
        if (marker) {
            map.removeLayer(marker);
        }
        marker = L.marker([lat, lng], { icon: customIcon }).addTo(map);
        document.getElementById('mapCoord').value = lat + ',' + lng;
    });
    <c:forEach var="mapItem" items="${FMO_MAP_LIST}">
    <c:if test="${mapItem.itemLocId == locID}">
    L.marker([${mapItem.latitude}, ${mapItem.longitude}], { icon: customIcon }) //csen
        .addTo(map)
        .bindPopup('Original Location'); // Static link
    </c:if>
    </c:forEach> 
    setTimeout(function () {
        map.invalidateSize();
    }, 100);




    function populateEditModal(button){
//        event.preventDefault();
        console.log(button); // Check if button is correctly passed
        var flrId = button.getAttribute("data-flrid");
        var flrName = button.getAttribute("data-flrname");
        var flrDesc = button.getAttribute("data-flrdesc");

        document.getElementById('editFlrID').value = flrId;
        document.getElementById('editFlrName').value = flrName;
        document.getElementById('editFlrDesc').value = flrDesc;

    }
    
    function populateArchFlrModal(button){
//        event.preventDefault();
//        console.log(button); // Check if button is correctly passed
        var flrId = button.getAttribute("data-aflrid");
        var flrName = button.getAttribute("data-aflrname");

        document.getElementById('archiveFlrID').value = flrId;
        document.getElementById('archiveFlr').value = flrName;
        var modalMessage = document.getElementById("archYouSure");
        modalMessage.innerText = "Are you sure you want to archive " + flrName + "?";
       
    }
    
    function populateUnarchFlrModal(button){
        var flrId = button.getAttribute("data-acflrid");
        var flrName = button.getAttribute("data-acflrname");

        document.getElementById('activateFlrID').value = flrId;
        document.getElementById('activateFlr').value = flrName;
        var modalMessage = document.getElementById("actYouSure");
        modalMessage.innerText = "Are you sure you want to activate " + flrName + "?";
    }

</script>

<script>
  // Helper function to get query parameter by name
  function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
  }

  // Get action and status from URL parameters
  const action = getQueryParam('action');
  const status = getQueryParam('status');

  // Trigger SweetAlert2 Toast based on action and status
  if (status === 'success') {
    let toastMessage = '';
    
    switch (action) {
      case 'floor_add':
        toastMessage = 'The floor was added successfully.';
        break;
      case 'floor_update':
        toastMessage = 'The floor was updated successfully.';
        break;
      case 'floor_archive':
        toastMessage = 'The floor was archived successfully.';
        break;
      case 'building_modify':
        toastMessage = 'The location was updated successfully.';
        break;
      case 'building_archive':
        toastMessage = 'The location was archived successfully.';
        break;
      default:
        toastMessage = 'Operation completed successfully.';
        break;
    }

    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'success',
      title: toastMessage,
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    });
  } else if (status === 'error') {
    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'error',
      title: 'An error occurred while processing your request.',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    });
  }
  
    $(document).on('click', '.archive-location-btn', function(e) {
        e.preventDefault();
    
        Swal.fire({
            title: 'Are you sure?',
        text: "Do you want to archive this location?",
        icon: 'warning',
        showCancelButton: true,
        reverseButtons: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#ffffff',
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        customClass: {
             cancelButton: 'btn-cancel-outline'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                $('#archiveLocForm').submit();
            }
        });
    });
</script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>