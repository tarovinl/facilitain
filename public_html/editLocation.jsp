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
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- DataTables JS -->
        <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
        <!-- Bootstrap 5 CSS and JS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.js"></script>
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
    <div class="col-md-9 col-lg-10">
    <div class="topButtons"> <!-- top buttons -->
            <div>
                <!-- Link component remains unchanged -->
                <a href="./buildingDashboard?locID=${locID}" class="buttonsBack" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;">
                <img
                        src="resources/images/backIcon.svg" 
                        alt="next icon"
                        width="16"
                        height="16"
                        style="transform: rotateY(180deg); margin-right: 8px;"
                    /> 
                    Back
                </a>
            </div>
        </div>
        <div class="editbuildingName container">
            <h1>Edit Location</h1>
        </div>
        <div class="floorAndButtons container">
            <div class="locName">
              <h3 class="fw-bold">${locName}</h3>
            </div>
            <div>
                <button class="buttonsBuilding" data-toggle="modal" data-target="#archiveFloor" type="button" onclick="">Archive Floor</button>
                <button class="buttonsBuilding" data-toggle="modal" data-target="#archiveLocation" type="button" onclick="">Archive Location</button>
            </div>
        </div>
            <div class="container mt-1 ms-2 me-2">
                <form action="buildingcontroller" method="POST">    
                <input type="hidden" name="locID" value="${locID}">
                <div class="row mt-4">
                    <div class="col">
                        <label for="locName" class="form-label fw-bold h4">Location Name</label>
                        <input type="text" class="form-control" id="locName" name="locName" value="${locName}">
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col">
                        <label for="" class="form-label fw-bold h4">Description</label>
                        <textarea class="form-control" id="locDescription" name="locDescription" rows="3">${locDescription}</textarea>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col text-center">
                        <input type="submit" value="Save Name and Description" class="btn btn-dark text-warning btn-lg mt-4 w-75 fw-bold">
                    </div> 
                    <div class="col text-center">
                        <button type="button" class="btn btn-dark text-warning btn-lg mt-4 w-75 fw-bold" onclick="location.reload()">Cancel</button>
                    </div> 
                </div>
                </form>
                <div class="row mt-4">
                    <div class="col dropTbl">
                        <div class="floorDLblDiv">
                            <h4 class="fw-bold mt-2">
                                <button onclick="showActiveTbl()">Active Floors</button>
                            </h4>
                        </div>
                        <table class="activeFloorTbl table table-striped table-bordered border border-dark">
                            <thead class="table-dark">
                              <tr>
                                <th scope="col"></th>
                                <th scope="col">Floor ID</th>
                                <th scope="col">Floor Name</th>
                              </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="floors" items="${FMO_FLOORS_LIST2}">
                                    <c:if test="${floors.itemLocId == locID}">
                                     <tr>
                                        <th scope="row">
                                        <!--  -->
                                            <input type="image" 
                                                src="resources/images/editItem.svg" 
                                                id="editModalButton" 
                                                alt="Open Edit Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-flrid="${floors.itemLocFlrId}"
                                                data-flrname="${floors.locFloor}"
                                                data-target="#editFloor"
                                                onclick="populateEditModal()">
                                        </th>
                                        <td>${floors.itemLocFlrId}</td>
                                        <td>${floors.locFloor}</td>
                                     </tr>
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

                <div class="row mt-3 mb-4">
                    <div class="col dropTbl mb-4">
                        <div class="floorDLblDiv">
                            <h4 class="fw-bold mt-2 archivedLbl">
                                <button onclick="showArchivedTbl()">Archived Floors</button>
                            </h4>
                        </div>
                        <table class="archivedFloorTbl table table-striped table-bordered border border-dark mb-4">
                            <thead class="table-dark">
                              <tr>
                                <th scope="col">

                                </th>
                                <th scope="col">Floor ID</th>
                                <th scope="col">Floor Name</th>
                              </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="floors" items="${FMO_FLOORS_LIST2}">
                                    <c:if test="${floors.itemLocId == locID}">
                                     <tr>
                                        <th scope="row">
                                        <!--  -->
                                            <input type="image" 
                                                src="resources/images/editItem.svg" 
                                                id="editModalButton" 
                                                alt="Open Edit Modal" 
                                                width="24" 
                                                height="24" 
                                                data-toggle="modal"
                                                data-flrid="${floors.itemLocFlrId}"
                                                data-flrname="${floors.locFloor}"
                                                data-target="#editFloor"
                                                onclick="populateEditModal()">
                                        </th>
                                        <td>${floors.itemLocFlrId}</td>
                                        <td>${floors.locFloor}</td>
                                     </tr>
                                    </c:if>
                                </c:forEach> 
                              <!--<tr>
                                <th scope="row">Unarchive button</th>
                                <td>111</td>
                                <td>12F</td>
                              </tr>-->
                            </tbody>
                        </table>
                    </div>
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
                    <form action="buildingcontroller" method="POST">
                        <div class="row">
                            <div class="col">
                                <h3 class="fw-bold">Edit Floor</h3>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col">
                                <label for="flrName" class="fw-bold">Floor Name</label>
                                <input type="text" name="editFlrName" id="" class="form-control mt-3" required>
                            </div>
                        </div>
                        <input type="hidden" name="editFlrLocID" id="locIDField" class="form-control" value="${locID}">
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


<!-- archive floor modal -->
<div class="modal fade" id="archiveFloor" tabindex="-1" role="dialog" aria-labelledby="archiveFloor" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="buildingcontroller" method="POST">
                        <div class="row">
                            <div class="col">
                                <h3 class="fw-bold">Archive Floor</h3>
                            </div>
                        </div>
                        <input type="hidden" name="archiveFlrlocID" id="locIDField" class="form-control" value="${locID}">
                        <div class="row mt-3">
                            <div class="col">
                                <label for="archiveFlr" class="fw-bold">Please choose which floor to archive:</label>
                                <select class="form-select mt-3" id="archiveFlr" name="archiveFlr" onchange="">
                                     <c:forEach var="floors" items="${FMO_FLOORS_LIST2}">
                                        <c:if test="${floors.itemLocId == locID}">
                                            <option value="${floors.itemLocFlrId}">${floors.locFloor}</option>
                                        </c:if>
                                    </c:forEach> 
                                    <!--<option value="1">1F</option>
                                    <option value="2">2F</option>-->
                                </select>
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
<!-- end of archive floor modal -->


<!-- archive location modal -->
<div class="modal fade" id="archiveLocation" tabindex="-1" role="dialog" aria-labelledby="archiveLocation" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="" method="">
                        <div class="row">
                            <div class="col text-center">
                                <h2 class="fw-bold">Are you sure you want to archive ${locName}?</h2>
                            </div>
                        </div>
                        <input type="hidden" name="archiveLocID" id="locIDField" class="form-control" value="${locID}">
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
<!-- end of archive location modal -->


<script>

    function showActiveTbl() {
        //event.preventDefault();
        const table = document.querySelector('.activeFloorTbl');
        if (table.style.display === 'none' || table.style.display === '') {
            table.style.display = 'table';
        } else {
            table.style.display = 'none';
        }
    }
    function showArchivedTbl() {
        //event.preventDefault();
        const table = document.querySelector('.archivedFloorTbl');
        if (table.style.display === 'none' || table.style.display === '') {
            table.style.display = 'table';
        } else {
            table.style.display = 'none';
        }
    }

    function populateEditModal(){
        event.preventDefault();
        // Get data from the button's data-* attributes
        var flrId = button.getAttribute("data-flrid");
        var flrName = button.getAttribute("data-flrname");

        // Populate the modal fields with the data
        document.querySelector('input[name="editFlrLocID"]').value = flrId;
        document.querySelector('input[name="editFlrName"]').value = flrName;
    }

</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
