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
                
                .responsive-padding-top {
                                  padding-top: 80px;
                                }
                                
                @media (max-width: 576px) {
                .responsive-padding-top {
                padding-top: 70px; /* or whatever smaller value you want */
                }
                }
                th, td {
              text-align: center;
              vertical-align: middle;
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
                .nav-tabs .nav-link {
                color: #6c757d; /* grey for inactive */
                transition: color 0.2s ease-in-out;
              }
            
              .nav-tabs .nav-link:hover {
                color: #000000; /* grey on hover */
              }
            
              .nav-tabs .nav-link.active {
                color: #000000; /* black for active */
                font-weight: 600;
              }
              .topButtons {
                display: flex;
                justify-content: space-between;
                margin-top: 5px;
                margin-bottom: 20px;
                padding-left: 16px;
            }
</style>
<script>
    $(document).ready(function () {
        var maxChars = 250;
        var $textarea = $('#locDescription');
        var $charCount = $('#charCount');

        // Function to update character count
        function updateCharCount() {
            var currentLength = $textarea.val().length;
            $charCount.text(currentLength + ' / ' + maxChars + ' characters');
        }

        // Initialize the count when tab1 is shown
        $('button[data-bs-target="#tab1"]').on('shown.bs.tab', function () {
            updateCharCount();
        });

        // Also initialize on page load if tab1 is active
        if ($('#tab1').hasClass('show active')) {
            updateCharCount();
        }

        // Update count on input
        $textarea.on('input', function () {
            var text = $(this).val();
            if (text.length > maxChars) {
                $(this).val(text.substring(0, maxChars));
            }
            updateCharCount();
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
<jsp:include page="navbar.jsp"/>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
       
    
    <div class="col-md-10 responsive-padding-top">
        <div class="topButtons"> <!-- top buttons -->
            <div>
                <!-- Link component remains unchanged -->
                
                <a href="./buildingDashboard?locID=${locID}" class="buttonsBack pt-2 d-flex align-items-center gap-2 text-decoration-none text-dark fs-4" 
   style="margin-left: 0px; font-family: NeueHaasLight, sans-serif;">
    <img src="resources/images/icons/angle-left-solid.svg" alt="back icon" width="20" height="20">
    Back
</a>
            </div>
        </div>
        <div class="container">
        <div class="editbuildingName">
            <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Edit Location</h1>
        </div>
        <div class="floorAndButtons">
            <div class="locName">
              <h4 class="form-label h1" style="font-family: NeueHaasMedium, sans-serif !important;">${locName}</h4>
            </div>
            
            <div class="d-flex flex-column flex-lg-row">


    <button class="buttonsBuilding archive-location-btn align-items-center d-flex btn btn-md px-3 py-2 rounded-2 hover-outline text-dark" 
        style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
        href="#" data-bs-toggle="modal" type="button" onclick="">
        <img src="resources/images/icons/archive.svg" alt="add" width="25" height="25">
       <span class="d-none d-lg-inline ps-2"> Archive Location </span>
    </button>
</div>

        </div>

         <!-- Tabs Navigation -->
      <ul class="nav nav-tabs mt-4" id="editTabs" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" id="tab1-tab" data-bs-toggle="tab" data-bs-target="#tab1" type="button" role="tab">Location Details</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="tab2-tab" data-bs-toggle="tab" data-bs-target="#tab2" type="button" role="tab">Floors</button>
        </li>
      </ul>

      <!-- Tab Content -->
      <div class="tab-content" id="editTabsContent">

        <div class="tab-pane fade show active pt-4" id="tab1" role="tabpanel" aria-labelledby="tab1-tab">
        <form action="buildingController" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="locID" value="${locID}"> <!-- Ensure this value is correctly set -->

    <div class="row mt-4">
        <div class="col-12 col-md-6">
            <!-- Location Name Section -->
            <div class="row">
                <div class="col">
                    <label for="locName" class="form-label h4" style="font-family: NeueHaasMedium, sans-serif !important;"> Name</label>
                    <input type="text" class="form-control" id="locName" name="locName" value="${locName}" required>
                    <small class="text-muted">Only letters, numbers, spaces, and periods allowed.</small>
                </div>
            </div>
    
            <!-- Description Section -->
            <div class="row mt-3">
                <div class="col">
                    <label for="locDescription" class="form-label h4" style="font-family: NeueHaasMedium, sans-serif !important;">Description</label>
                    <textarea class="form-control" id="locDescription" name="locDescription" rows="3" maxlength="250">${locDescription}</textarea>
                    <small id="charCount" class="form-text text-muted">0 / 250 characters</small>
                </div>
            </div>
    
            <!-- Image Upload Section -->
            <div class="row mt-3">
                <div class="col">
                    <h4 class="form-label h4" style="font-family: NeueHaasMedium, sans-serif !important;">Card Image</h4>
                    <!-- File Input -->
                    <div class="mb-0">
                        <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 mt-4 mt-md-0">
            <div class="row">
                <div class="col" id="parentMap">
                    <label for="mapCoord" class="form-label h4" style="font-family: NeueHaasMedium, sans-serif !important;">Pin Location on Map:</label>
                    <h6 class="text-secondary fw-normal"  style="font-family: 'NeueHaasLight', sans-serif;">Select a location by clicking on the map. Press Reset to undo your selection.</h6>
                    <input type="hidden" class="form-control" id="mapCoord" name="mapCoord">
                    <div id="map" style="width: 100%; height: 256px; border-radius:5px;"></div>
                </div>           
            </div> 
        </div>
    </div>
    <!-- Save & Reset Buttons Section -->
    <div class="row g-3 mt-4">
  <div class="col-md-6 col-12 text-center">
    <input type="submit" value="Save Changes" class="btn btn-success w-100" style="font-family: NeueHaasMedium, sans-serif !important;">
  </div> 
  <div class="col-md-6 col-12 text-center mb-4 mt-md-0">
    <button type="button" class="btn btn-outline-secondary w-100" style="font-family: NeueHaasMedium, sans-serif !important;" onclick="location.reload()">Reset</button>
  </div> 
</div>
</form>
</div>

 <div class="tab-pane fade pt-4" id="tab2" role="tabpanel" aria-labelledby="tab2-tab">
<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">
    Current Floors
  </h3>
  
  <button class="buttonsBuilding d-flex align-items-center btn btn-md px-3 py-2 rounded-2 hover-outline text-dark" 
          style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" 
          data-bs-toggle="modal" data-bs-target="#addFloor" type="button">
    <img src="resources/images/icons/plus.svg" alt="add"  width="25" height="25">
     <span class="d-none d-lg-inline ps-2">Add Floor</span>
  </button>
</div>


                <div class="row mt-4">
                    <div class="col dropTbl table-responsive">
                        <table id="flrTable" class="table table-striped table-bordered display w-100">
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
                                        </td>
                                        <td>
                                            <!--data-target="#archiveFloor"-->
                                            <input type="image" 
                                                src="resources/images/archiveItem.svg" 
                                                id="archFlrModalButton" 
                                                alt="Open Archive Modal" 
                                                class="archive-floor-btn"
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-aflrid="${floors.itemLocFlrId}"
                                                data-aflrname="${floors.locFloor}"
                                                onclick="populateArchFlrModal(this)">
                                        </td>
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
</div>

<!-- edit floor modal -->
<div class="modal fade" id="editFloor" tabindex="-1" role="dialog" aria-labelledby="editFloor" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="editFloorLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Edit Floor</h5>
              <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
                    <form action="floorcontroller" method="POST">
                        <div class="modal-body">
                            <div class="mb-3">
                                <div class="col">
                                    <label for="flrName" class="fw-bold">Floor Name <span style="color: red;">*</span></label>
                                    <input type="text" name="editFlrName" id="editFlrName" class="form-control mt-3" maxlength="15" required>
                                    <p class="text-muted">Only letters, numbers, spaces, and periods allowed.</p>
                                </div>
                            </div>
                            <input type="hidden" name="editFlrLocID" id="editFlrLocID" class="form-control" value="${locID}">
                            <input type="hidden" name="editFlrID" id="editFlrID" class="form-control">
                            <input type="hidden" name="locID" value="${locID}">
                            <div class="mb-3">
                                <div class="col">
                                    <label for="flrDesc" class="fw-bold">Floor Description</label>
                                    <textarea class="form-control mt-3" maxlength="250" name="editFlrDesc" id="editFlrDesc" rows="2"></textarea>
                                    <small id="editCharCount" class="form-text text-muted">0 / 250 characters</small>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-outline-danger" data-dismiss="modal" style="font-family: 'NeueHaasMedium', sans-serif;">Cancel</button>
                          <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">Save Changes</button>
                        </div>
                    </form>
                
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
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="addFlrName" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Floor Name <span style="color: red;">*</span></label>
            <input type="text" name="addFlrName" id="addFlrName" class="form-control" maxlength="15" style="font-family: 'NeueHaasLight', sans-serif;" required>
            <p class="text-muted">Only letters, numbers, spaces, and periods allowed.</p>
          </div>
          <div class="mb-3">
            <label for="addFlrDesc" class="form-label" style="font-family: 'NeueHaasLight', sans-serif;">Floor Description</label>
            <textarea class="form-control" name="addFlrDesc" id="addFlrDesc" rows="2" style="font-family: 'NeueHaasLight', sans-serif;"></textarea>
            <small id="addCharCount" class="form-text text-muted">0 / 250 characters</small>
          </div>
          <input type="hidden" name="addFlrLocID" id="addFlrLocID" class="form-control" value="${locID}">
          <input type="hidden" name="locID" value="${locID}">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal" style="font-family: 'NeueHaasMedium', sans-serif;">Cancel</button>
          <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">Add</button>
        </div>
      </div>
    </form>
  </div>
</div>


<!-- end of add floor modal -->


<!-- archive floor modal -->
<!--<div class="modal fade" id="archiveFloor" tabindex="-1" role="dialog" aria-labelledby="archiveFloor" aria-hidden="true">
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
</div>-->
<form id="archiveFloor" action="floorcontroller" method="POST" style="display: none;">
    <input type="hidden" name="locID" value="${locID}">
    <input type="hidden" name="archiveFlrLocID" id="archiveFlrLocID" class="form-control" value="${locID}">
    <input type="hidden" name="archiveFlrID" id="archiveFlrID" class="form-control">
    <input type="hidden" name="archiveFlr" id="archiveFlr" class="form-control">
</form>
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
                document.addEventListener("DOMContentLoaded", function () {
                    let flrTable; // Keep reference so we don't re-init multiple times
                
                    // Listen for tab show event
                    document.querySelector('button[data-bs-target="#tab2"]').addEventListener("shown.bs.tab", function () {
                        if (!flrTable) { 
                            flrTable = new DataTable("#flrTable", {
                                paging: true,
                                searching: true,
                                ordering: true,
                                info: true,
                                stateSave: true,
                                scrollX: true,
                                columnDefs: [
                                    { targets: "_all", className: "dt-center" },
                                    { targets: 0, orderable: false },
                                    { targets: 1, orderable: false },
                                    { targets: 4, orderable: false }
                                ]
                            });
                        } else {
                            // If already initialized, just fix sizing
                            flrTable.columns.adjust().draw();
                        }
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
        .bindPopup('<div style="font-family: NeueHaasMedium, sans-serif;">Original Location</div>'); // Static link
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
 document.addEventListener('DOMContentLoaded', function() {
  // Helper function to get query parameter by name
  function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
  }

  // Get action, status, and error parameters from URL
  const action = getQueryParam('action');
  const status = getQueryParam('status');
  const error = getQueryParam('error');
  const errorMsg = getQueryParam('errorMsg');

  // Handle error messages (including duplicate name errors)
  if (error) {
    let alertConfig = {
      confirmButtonText: 'OK',
      allowOutsideClick: false
    };

    if (error === 'duplicate') {
      alertConfig = {
        ...alertConfig,
        title: 'Duplicate Location!',
        text: errorMsg || 'A location with this name already exists. Please choose a different name.',
        icon: 'warning'
      };
    } else if (error === 'true') {
      alertConfig = {
        ...alertConfig,
        title: 'Error!',
        text: errorMsg || 'An error occurred while updating the location.',
        icon: 'error'
      };
    }

    Swal.fire(alertConfig).then(() => {
      // Remove error parameters from URL without refreshing
      const urlParams = new URLSearchParams(window.location.search);
      urlParams.delete('error');
      urlParams.delete('errorMsg');
      const newUrl = window.location.pathname + '?' + urlParams.toString();
      window.history.replaceState({}, document.title, newUrl);
    });
  }
  // Handle success messages
  else if (status === 'success') {
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
});
  
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
        confirmButtonText: 'Yes, archive it',
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
    
    $(document).on('click', '.archive-floor-btn', function(e) {
        e.preventDefault();
    
        Swal.fire({
            title: 'Are you sure?',
            text: "Do you want to archive this floor?",
            icon: 'warning',
            showCancelButton: true,
            reverseButtons: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#ffffff',
            confirmButtonText: 'Yes, archive it',
            cancelButtonText: 'Cancel',
            customClass: {
             cancelButton: 'btn-cancel-outline'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                $('#archiveFloor').submit();
            }
        });
    });
    
    
    document.addEventListener('DOMContentLoaded', function() {
    // Pattern that allows only letters, numbers, spaces, and periods
    const validPattern = /^[a-zA-Z0-9\s.]*$/;
    
  
    const locNameInput = document.getElementById('locName');
    
    if (locNameInput) {
        // Real-time validation - prevent special characters as user types
        locNameInput.addEventListener('input', function(e) {
            if (!validPattern.test(this.value)) {
                // Remove invalid characters
                this.value = this.value.replace(/[^a-zA-Z0-9\s.]/g, '');
            }
        });
        
        // Form submission validation for location details
        const locationForm = locNameInput.closest('form');
        if (locationForm) {
            locationForm.addEventListener('submit', function(e) {
                const locName = locNameInput.value.trim();
                
                if (!validPattern.test(locName)) {
                    e.preventDefault();
                    Swal.fire({
                        title: 'Invalid Characters',
                        text: 'Location name can only contain letters, numbers, spaces, and periods.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    return false;
                }
            });
        }
    }
    
   
    const addFlrNameInput = document.getElementById('addFlrName');
    
    if (addFlrNameInput) {
        // Real-time validation
        addFlrNameInput.addEventListener('input', function(e) {
            if (!validPattern.test(this.value)) {
                this.value = this.value.replace(/[^a-zA-Z0-9\s.]/g, '');
            }
        });
        
        // Form submission validation
        const addFloorForm = addFlrNameInput.closest('form');
        if (addFloorForm) {
            addFloorForm.addEventListener('submit', function(e) {
                const floorName = addFlrNameInput.value.trim();
                
                if (!validPattern.test(floorName)) {
                    e.preventDefault();
                    Swal.fire({
                        title: 'Invalid Characters',
                        text: 'Floor name can only contain letters, numbers, spaces, and periods.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    return false;
                }
            });
        }
    }
    

    const editFlrNameInput = document.getElementById('editFlrName');
    
    if (editFlrNameInput) {
        // Real-time validation
        editFlrNameInput.addEventListener('input', function(e) {
            if (!validPattern.test(this.value)) {
                this.value = this.value.replace(/[^a-zA-Z0-9\s.]/g, '');
            }
        });
        
        // Form submission validation
        const editFloorForm = editFlrNameInput.closest('form');
        if (editFloorForm) {
            editFloorForm.addEventListener('submit', function(e) {
                const floorName = editFlrNameInput.value.trim();
                
                if (!validPattern.test(floorName)) {
                    e.preventDefault();
                    Swal.fire({
                        title: 'Invalid Characters',
                        text: 'Floor name can only contain letters, numbers, spaces, and periods.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    return false;
                }
            });
        }
    }
});

document.addEventListener('DOMContentLoaded', function() {
    const textareaE = document.getElementById('editFlrDesc');
    const counterE = document.getElementById('editCharCount');
    const maxLengthE = 250;

    // Function to update character count safely
    function updateCharCountE() {
        const currentLengthE = textareaE.value.length || 0;
        counterE.textContent = currentLengthE + " / " + maxLengthE + " characters";
    }

    // Update count live while typing
    textareaE.addEventListener('input', updateCharCountE);

    // Recalculate count every time the modal is shown (after populateEditModal fills it)
    $('#editFloor').on('shown.bs.modal', function() {
        updateCharCountE();
    });
});
document.addEventListener('DOMContentLoaded', function() {
    const textareaA = document.getElementById('addFlrDesc');
    const counterA = document.getElementById('addCharCount');
    const maxLengthA = 250;

    if (textareaA && counterA) {
        // Initialize on page load
        const charCountA = textareaA.value.length;
        counterA.textContent = charCountA + " / " + maxLengthA + " characters";

        // Update on every input
        textareaA.addEventListener('input', function() {
            const charCountA = textareaA.value.length;
            console.log("the char count: "+charCountA);
            counterA.textContent = charCountA + " / " + maxLengthA + " characters";
        });
    }
});
</script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>