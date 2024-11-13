<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%> 
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Building Dashboard</title>
        <link rel="stylesheet" href="resources/css/mBuilding.css">
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
    String floorName = null;
    int floorIndex = fullBuildingID.indexOf("floor=");
    if (floorIndex != -1) {
        floorName = fullBuildingID.substring(floorIndex + 6);  // Extract everything after "floor="
    }
    request.setAttribute("locID", locID);
    request.setAttribute("floorName", floorName);
%>

            <c:set var="locMatchFound" value="false" />
            <c:set var="flrMatchFound" value="false" />
            
            <c:forEach items="${locations}" var="location">
                <c:if test="${location.itemLocId == locID}">
                    <c:set var="locName" value="${location.locName}"/>
                    <c:set var="locMatchFound" value="true" />
                </c:if>
            </c:forEach>    
            
            <c:set var="brandListString" value="" />
                <c:forEach var="brand" items="${FMO_BRANDS_LIST}" varStatus="status">
                    <c:set var="brandListString" value="${brandListString}${brand.itemBrand}${status.last ? '' : ', '}" />
                </c:forEach>


    <body>
<div class="container-fluid d-flex">
    <div class="col-md-3 p-0">
        <jsp:include page="sidebar.jsp"/>
    </div>
    
    <div class="col-md-9">
            <jsp:include page="quotations.jsp" />
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
                    /> <!-- change based on state of building -->
                    Back
                </a>
            </div>
        </div>
        <div class="buildingName">
            <h1>${locName}</h1>
        </div>
        <div class="container">
        <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
            <c:if test="${floors.key == locID}">
                <c:forEach var="floor" items="${floors.value}">
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=${floor}" class="floorLinks">
                        ${floor}
                    </a>
                    <c:if test="${floor == floorName}">
                        <c:set var="flrMatchFound" value="true" />
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>    
       
        </div>
        <div class="floorAndButtons">
            <div class="floorName">
              <h1>${floorName}</h1>
            </div>
            <div>
              <button class="buttonsBuilding" onclick="window.location.href='buildingDashboard?locID=${locID}/edit'"><!--hidden if acc is not admin-->
                Edit Location
              </button>
               
              <button class="buttonsBuilding" data-toggle="modal" data-target="#addEquipment" type="button" onclick="QOLLocSet(); floorRender();">Add Equipment</button>
            </div>
        </div>
        
        <!-- list of room dropdowns  (turn roomDropdown <li> into foreach)-->
        <div class="roomDropsdiv">
            <ul class="roomDropdowns" id="roomDropdowns">
          
          <c:forEach items="${uniqueRooms}" var="room" >
            <c:if test="${room.itemLID == locID}">
                <c:if test="${room.itemFloor == floorName}">  
                <c:if test="${room.itemArchive == 1}">  
                <li class="roomDropdown">
                    <div class="roomDropDiv">
                        <div class="roomDLblDiv">
                            <h3>
                                <button onclick="showTblDiv(this)" >${room.itemRoom != null ? room.itemRoom : 'Non-Room Equipment'}</button>
                            </h3>
                        </div>
                        <div class="roomDTblDiv">
                            <table aria-label="history logs table">
                                <tr style="margin-bottom: 120px;">
                                    <th ></th>
                                    <th >ID</th>
                                    <th >Codename</th>
                                    <th >Category</th>
                                    <th >Type</th>
                                    <th >Brand</th>
                                    <th >Date Installed</th>
                                    <th style="display: flex; justify-content: center; align-items: center;">
                                        Quotation
                                    </th>
                                    <th >Status</th>
                                </tr>
                                
                            <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                                <c:if test="${item.itemLID == locID}">
                                    <c:if test="${item.itemFloor == floorName}">
                                    <c:if test="${item.itemRoom == room.itemRoom}">
                                <tr>
                                
                                <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                    <c:if test="${type.itemTID == item.itemTID}">
                                    <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                        <c:if test="${cat.itemCID == type.itemCID}">
                                        <!-- Store cat.itemCat and type.itemType in scoped variables -->
                                            <c:set var="itemEditCat" value="${cat.itemCID}" />
                                            <c:set var="itemEditType" value="${type.itemTID}" />
                                        </c:if>
                                    </c:forEach>
                                    </c:if>
                                </c:forEach>
                                
                                    <td style="display: flex; justify-content: center; align-items: center; margin-bottom: 8px;">
                                        <input type="image" 
                                        src="resources/images/editItem.svg" 
                                        id="editModalButton" 
                                        alt="Open Edit Modal" 
                                        width="24" 
                                        height="24" 
                                        data-toggle="modal" 
                                        data-target="#editEquipment"
                                        data-itemid="${item.itemID}"
                                        data-itemname="${item.itemName}"
                                        data-itembrand="${item.itemBrand}"
                                        data-dateinst="${item.dateInstalled}"
                                        data-itemexpiry="${item.expiration}"
                                        data-itemcat="${itemEditCat}"
                                        data-itemroom="${item.itemRoom}"
                                        data-itemtype="${itemEditType}"
                                        data-itemloctext="${item.itemLocText}"
                                        data-itemremarks="${item.itemRemarks}"
                                        onclick="populateEditModal(this);setFloorSelection(this);floorERender();">
                                    </td>
                                    <td >${item.itemID}</td>
                                    <td >${item.itemName}</td>
                                    <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                        <c:if test="${type.itemTID == item.itemTID}">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <c:if test="${cat.itemCID == type.itemCID}">
                                            <td >${cat.itemCat}</td>
                                            </c:if>
                                        </c:forEach>
                                            <td >${type.itemType}</td>
                                        </c:if>
                                    </c:forEach>
                                    <td >${item.itemBrand != null ? item.itemBrand : 'N/A'}</td>
                                    <td >${item.dateInstalled}</td>
                                    <td style="display: flex; justify-content: center; align-items: center; margin-top: 8px;">
                                        <input type="image"
                                        src="resources/images/quotationsIcon.svg"
                                        id="quotModalButton"
                                        alt="Open Modal" width="24" height="24"
                                        data-bs-toggle="modal"
                                        data-bs-target="#quotEquipment"
                                        data-itemid="${item.itemID}"
                                        onclick="populateQuotModal(this)">
                                    </td>
                                    <td >
                                      <form action="itemcontroller" method="POST">
                                        <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}"/>
                                        <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}"/>
                                        <input type="hidden" name="maintStatID" value="${item.itemID}" />
                                        <select name="statusDropdown" class="statusDropdown" onchange="this.form.submit()">
                                            <c:forEach items="${FMO_MAINTSTAT_LIST}" var="status">
                                                <option value="${status.itemMaintStat}" 
                                                <c:if test="${status.itemMaintStat == item.itemMaintStat}">selected</c:if>>
                                                ${status.maintStatName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                      </form>
                                    </td>
                                </tr>
                                    </c:if>
                                    </c:if>
                                </c:if>
                            </c:forEach>    
                                
                            </table>
                        </div>
                    </div>
                </li>
                </c:if>
                </c:if>    
            </c:if>            
        </c:forEach>   
           
                <!--<li>room 808</li>-->
            </ul>
            
            <div id="paginationControls"></div>
         </div>
     </div>
    </div> 
    </div>
    <!--add equipment modal-->
    <div class="modal fade" id="addEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentAdd" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
                <div class="centered-div bg-white">
                    <div class="container p-4 mt-4 mb-4">
                        <form action="itemcontroller" method="POST">
                            <div class="row">
                                <div class="col">
                                    <h3 class="fw-bold">Add Equipment</h3>
                                </div>
                            </div>
                            <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
                            <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
                            <div class="row mt-1">
                                <div class="col">
                                    <label for="" class="form-label">Codename</label>
                                    <input type="text" name="itemCode" id="" class="form-control" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Building</label>
                                    <select class="form-select" name="itemBuilding" onchange="floorRender()">
                                        <c:forEach items="${locations}" var="loc" >
                                            <option value="${loc.itemLocId}" selected>${loc.locName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemCat" class="form-label">Category</label>
                                    <select class="form-select" name="itemCat">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemType" class="form-label">Type</label>
                                    <select class="form-select" name="itemType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <option value="${type.itemTID}" selected>${type.itemType}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemBrand" class="form-label">Brand</label>
                                    <input class="form-control awesomplete" id="brandName" data-list="${brandListString}" name="itemBrand">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemAddFloor" class="form-label">Floor</label>
                                    <select class="form-select" name="itemAddFloor" id="itemAddFloor" onchange="roomRender()">
                                      <%--<c:forEach var="floors" items="${FMO_FLOORS_LIST}">
                                        <c:if test="${floors.key == locID}">
                                        <c:forEach var="floor" items="${floors.value}">
                                            <option value="${floor}">${floor}</option>
                                        </c:forEach>
                                        </c:if>
                                      </c:forEach>--%>  
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemAddRoom" class="form-label">Room</label>
                                    <input class="form-control" list="roomOptions" id="itemAddRoom" name="itemAddRoom">
                                    <datalist id="roomOptions"></datalist>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="" class="form-label">Date Installed</label>
                                    <input type="date" name="itemInstalled" id="" class="form-control" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Expiration Date</label>
                                    <input type="date" name="itemExpiration" id="" class="form-control">
                                </div>
                                <div class="col">
                                    <div class="row"><label for="itemSched" class="form-label">Maintenance Cycle: Every...</label></div>
                                    <div class="row">
                                        <div class="col">
                                            <input type="number" name="itemSchedNum" min="1" oninput="validity.valid||(value='');" class="form-control">
                                        </div>
                                        <div class="col">
                                            <select class="form-select" name="itemSched">
                                              <option value="hours" selected>Hour/s</option>
                                              <option value="days" >Day/s</option>
                                              <option value="months" >Month/s</option>
                                              <option value="years" >Year/s</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="locText">Location Text</label>
                                    <textarea class="form-control" id="locText" name="locText" rows="2"></textarea>
                                </div>
                                <div class="col">
                                    <label for="remarks">Remarks</label>
                                    <textarea class="form-control" id="remarks" name="remarks" rows="2"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col text-center">
                                    <input type="submit" value="Save" class="btn btn-warning btn-lg mt-5 w-100 fw-bold">
                                </div> 
                                <div class="col text-center">
                                    <button type="button" class="btn btn-warning btn-lg mt-5 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                                </div> 
                            </div>
                        </form>
                    </div>     
                </div>
            
        </div>
    </div>
</div>
<!--end of add equipment modal-->

    <!--edit equipment modal-->
    <div class="modal fade" id="editEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentEdit" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
                <div class="centered-div bg-white">
                    <div class="container p-4 mt-4 mb-4">
                        <form action="itemcontroller" method="POST">
                            <div class="row">
                                <div class="col">
                                    <h3 class="fw-bold">Edit Equipment</h3>
                                </div>
                            </div>
                            <input type="hidden" name="itemEditID" id="itemIDField" class="form-control">
                            <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
                            <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
                            <div class="row mt-1">
                                <div class="col">
                                    <label for="" class="form-label">Codename</label>
                                    <input type="text" name="itemEditCode" id="" class="form-control">
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Building</label>
                                    <select class="form-select" name="itemEditLoc" onchange="floorERender()">
                                        <c:forEach items="${locations}" var="loc" >
                                            <option value="${loc.itemLocId}" selected>${loc.locName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemEditCat" class="form-label">Category</label>
                                    <select class="form-select" name="itemEditCat">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditType" class="form-label">Type</label>
                                    <select class="form-select" name="itemEditType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <option value="${type.itemTID}" selected>${type.itemType}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditBrand" class="form-label">Brand</label>
                                    <input class="form-control awesomplete" name="itemEditBrand" id="brandName" data-list="${brandListString}">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemEditFloor" class="form-label">Floor</label>
                                    <select class="form-select" name="itemEditFloor" id="itemEditFloor" onchange="roomEditRender()">
                                      <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
                                        <c:if test="${floors.key == locID}">
                                        <c:forEach var="floor" items="${floors.value}">
                                            <option value="${floor}">${floor}</option>
                                        </c:forEach>
                                        </c:if>
                                      </c:forEach>  
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditRoom" class="form-label">Room</label>
                                    <input class="form-control" list="editRoomOptions" id="itemEditRoom" name="itemEditRoom">
                                    <datalist id="editRoomOptions"></datalist>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="" class="form-label">Date Installed</label>
                                    <input type="date" name="itemEditInstalled" id="itemEditInstalled" class="form-control">
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Expiration Date</label>
                                    <input type="date" name="itemEditExpiration" id="" class="form-control">
                                </div>
                                <div class="col">
                                    <div class="row"><label for="itemEditSched" class="form-label">Maintenance Cycle: Every...</label></div>
                                    <div class="row">
                                        <div class="col">
                                            <input type="number" name="itemEditSchedNum" min="1" oninput="validity.valid||(value='');" class="form-control">
                                        </div>
                                        <div class="col">
                                            <select class="form-select" name="itemEditSched">
                                              <option value="hours" selected>Hour/s</option>
                                              <option value="days" >Day/s</option>
                                              <option value="months" >Month/s</option>
                                              <option value="years" >Year/s</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="locText">Location Text</label>
                                    <textarea class="form-control" name="editLocText" id="locText" rows="2"></textarea>
                                </div>
                                <div class="col">
                                    <label for="remarks">Remarks</label>
                                    <textarea class="form-control" id="remarks" name="editRemarks" rows="2"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col text-center">
                                    <input type="submit" value="Save" class="btn btn-warning btn-lg mt-5 w-100 fw-bold">
                                </div> 
                                <div class="col text-center">
                                    <button type="button" class="btn btn-warning btn-lg mt-5 w-100 fw-bold" data-dismiss="modal">Cancel</button>
                                </div> 
                            </div>
                        </form>
                    </div>     
                </div>
            
            </div>
        </div>
    </div>
    <!--end of edit equipment modal-->
    
    
    
    <c:if test="${locMatchFound == false || flrMatchFound == false}">
        <meta http-equiv="refresh" content="0; URL=./homepage" /> 
    </c:if>
    <script>
    
        function showTblDiv(button) {
            var roomDropDiv = button.closest('.roomDropDiv');
            // Find the .roomDTblDiv inside the parent container
            var tblDiv = roomDropDiv.querySelector('.roomDTblDiv');
    
            // Toggle the display property of the specific .roomDTblDiv
            tblDiv.style.display = (tblDiv.style.display === 'none' || tblDiv.style.display === '') ? 'block' : 'none';
            // Store the state in localStorage
            localStorage.setItem('tblDivVisible', tblDiv.style.display === 'block' ? 'true' : 'false');
        }
        window.onload = function() {
            const isTblDivVisible = localStorage.getItem('tblDivVisible');
            const tblDiv = document.querySelector('.roomDTblDiv');
            if (isTblDivVisible === 'true') {
                tblDiv.style.display = 'block';
            }
        };
//        const statusDropdowns = document.querySelectorAll('.statusDropdown');
//
//        function updateDropdownColor(dropdown) {
//            const selectedValue = dropdown.value;
//
//            dropdown.classList.remove('working', 'nwork', 'maintenance');
//
//            if (selectedValue === 'working') {
//                dropdown.classList.add('working');
//            } else if (selectedValue === 'nwork') {
//                dropdown.classList.add('nwork');
//            } else if (selectedValue === 'maintenance') {
//                dropdown.classList.add('maintenance');
//            }
//        }
//        statusDropdowns.forEach(function(dropdown) {
//            updateDropdownColor(dropdown);
//
//            // Add event listener to each dropdown
//            dropdown.addEventListener('change', function() {
//                updateDropdownColor(dropdown);
//            });
//        });



const buildingFloors = {
        <c:forEach var="entry" items="${FMO_FLOORS_LIST}">
            "${entry.key}": [
                <c:forEach var="floor" items="${entry.value}">
                    "${floor}",
                </c:forEach>
            ],
        </c:forEach>
    };

function QOLLocSet(){
    var itemLID = parseInt(${locID}); 
        var selectLoc = document.querySelector('select[name="itemBuilding"]');
        if (selectLoc) {
            var options = selectLoc.options;
            for (var i = 0; i < options.length; i++) {
                if (parseInt(options[i].value) === itemLID) {
                    options[i].selected = true;
                    break;
                }
            }
        }
}

function floorRender() {
    // Get selected building ID
    const selectedBuilding = document.querySelector('[name="itemBuilding"]').value;

    // Get the itemAddFloor dropdown
    const floorDropdown = document.getElementById('itemAddFloor');

    // Clear existing options
    floorDropdown.innerHTML = '';

    // Fetch floors for the selected building from buildingFloors
    const floors = buildingFloors[selectedBuilding] || [];

    // Populate the dropdown with the fetched floors
    floors.forEach(floor => {
        const option = document.createElement('option');
        option.value = floor;
        option.textContent = floor;
        floorDropdown.appendChild(option);
    });

    roomRender();
}

function floorERender() {
    // Get selected building ID
    const selectedBuilding = document.querySelector('[name="itemEditLoc"]').value;

    // Get the itemAddFloor dropdown
    const floorDropdown = document.getElementById('itemEditFloor');

    // Clear existing options
    floorDropdown.innerHTML = '';

    // Fetch floors for the selected building from buildingFloors
    const floors = buildingFloors[selectedBuilding] || [];

    // Populate the dropdown with the fetched floors
    floors.forEach(floor => {
        const option = document.createElement('option');
        option.value = floor;
        option.textContent = floor;
        floorDropdown.appendChild(option);
    });
    roomEditRenderCopy();
}


        const roomsData = [
        <c:forEach items="${uniqueRooms}" var="room">
            {
                floor: '${room.itemFloor}', // Assuming room has an 'itemFloor' property
                lid: '${room.itemLID}',     // Assuming room has an 'itemLID' property
                roomName: '${room.itemRoom != null ? room.itemRoom : "Non-Room Equipment"}'
            },
        </c:forEach>
        ];


function roomRender() {
    
    const selectedBuilding = document.querySelector('[name="itemBuilding"]').value;
    const selectedFloor = document.getElementById('itemAddFloor').value;
    const roomSelect = document.getElementById('roomOptions');

    roomSelect.innerHTML = '';    

    const filteredRooms = roomsData.filter(function(room) {
            return room.floor === selectedFloor && room.lid === selectedBuilding;
        });
    console.log(filteredRooms);

    filteredRooms.forEach(room => {
        const option = document.createElement('option');
        option.value = room.roomName;  
        option.text = room.roomName; 
        roomSelect.appendChild(option); 
    });
            console.log(roomSelect);

    
}
//    same as roomRender but for edit modal pancakes
    function roomEditRender(itemRoom) {
        const selectedBuilding = document.querySelector('[name="itemEditLoc"]').value;
        const selectedFloor = document.getElementById('itemEditFloor').value;
        const roomField = document.getElementById('itemEditRoom')
        const roomSelect = document.getElementById('editRoomOptions');

        roomSelect.innerHTML = '';

        const defaultOption = document.createElement('option');
        defaultOption.value = null; 
        defaultOption.text = "Non-Room Equipment";
        defaultOption.selected = true;
        roomSelect.appendChild(defaultOption);
        
        const filteredRooms = roomsData.filter(function(room) {
            return room.floor === selectedFloor && room.lid === selectedBuilding;
        });
        filteredRooms.forEach(function(room) {
            if(room.roomName !== "Non-Room Equipment"){
            const option = document.createElement('option');
            option.value = room.roomName
            option.text = room.roomName;
            roomSelect.appendChild(option);
            }
        });
        
        for (let i = 0; i < roomSelect.options.length; i++) {
        if (roomSelect.options[i].value === itemRoom) {
//            roomSelect.options[i].selected = true;
            roomField.value = roomSelect.options[i].value
            break;
        }
    }
        
    }
    
    
    function populateEditModal(button) {
        var itemID = button.getAttribute('data-itemid');
        var itemLID = parseInt(${locID});
        var itemName = button.getAttribute('data-itemname');
        var itemBrand = button.getAttribute('data-itembrand');
        var itemDateInst = button.getAttribute('data-dateinst');
        var itemExpiry = button.getAttribute('data-itemexpiry');
        var itemCat = button.getAttribute('data-itemcat');
        var itemType = button.getAttribute('data-itemtype');
        var itemLocText = button.getAttribute('data-itemloctext');
        var itemRemarks = button.getAttribute('data-itemremarks');
        
        document.querySelector('input[name="itemEditID"]').value = itemID;

        document.querySelector('input[name="itemEditCode"]').value = itemName;
        document.querySelector('input[name="itemEditBrand"]').value = itemBrand;
        document.querySelector('input[name="itemEditInstalled"]').value = itemDateInst;
        document.querySelector('input[name="itemEditExpiration"]').value = itemExpiry;
        document.querySelector('textarea[name="editLocText"]').value = itemLocText;
        document.querySelector('textarea[name="editRemarks"]').value = itemRemarks;
        var selectCat = document.querySelector('select[name="itemEditCat"]');
        if (selectCat) {
            var options = selectCat.options;
            for (var i = 0; i < options.length; i++) {
                if (options[i].value === itemCat) {
                    options[i].selected = true;
                    break;
                }
            }
        }
        var selectType = document.querySelector('select[name="itemEditType"]');
        if (selectType) {
            var options = selectType.options;
            for (var i = 0; i < options.length; i++) {
                if (options[i].value === itemType) {
                    options[i].selected = true;
                    break;
                }
            }
        }
        var selectLoc = document.querySelector('select[name="itemEditLoc"]');
        if (selectLoc) {
            var options = selectLoc.options;
            for (var i = 0; i < options.length; i++) {
                if (parseInt(options[i].value) === itemLID) {
                    options[i].selected = true;
                    break;
                }
            }
        }
            
    }
    
    function setFloorSelection(button) {
    var itemRoom = button.getAttribute('data-itemroom');
    console.log(itemRoom);
    const flrName = '${floorName}';
    const itemEditFloor = document.getElementById('itemEditFloor');

    // Loop through options to find and select the one that matches floorName
    for (let i = 0; i < itemEditFloor.options.length; i++) {
        if (itemEditFloor.options[i].value === flrName) {
            itemEditFloor.options[i].selected = true;
            break; 
        }
    }

    roomEditRender(itemRoom);
}

    
    document.addEventListener("DOMContentLoaded", function() {
    const itemsPerPage = 5;  // Set how many items you want per page
    const ul = document.getElementById("roomDropdowns");
    const items = ul.getElementsByClassName("roomDropdown");  // Get all list items
    const totalItems = items.length;
    const paginationControls = document.getElementById("paginationControls");
    
    let currentPage = 1;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    function showPage(page) {
        currentPage = page;
        // Hide all items
        for (let i = 0; i < totalItems; i++) {
            items[i].style.display = "none";
        }
        // Show only the items for the current page
        let start = (page - 1) * itemsPerPage;
        let end = start + itemsPerPage;
        for (let i = start; i < end && i < totalItems; i++) {
            items[i].style.display = "block";
        }
        // Update pagination controls
        updatePaginationControls();
    }

    function updatePaginationControls() {
        paginationControls.innerHTML = "";  // Clear existing controls
        for (let i = 1; i <= totalPages; i++) {
            const button = document.createElement("button");
            button.textContent = i;
            button.classList.add("page-btn");
            if (i === currentPage) {
                button.classList.add("active");
            }
            button.addEventListener("click", function() {
                showPage(i);
            });
            paginationControls.appendChild(button);
        }
    }

    // Initialize the first page
    showPage(1);
});

function populateQuotModal(button) {
    // Get data from the button's data-* attributes
    var itemId = button.getAttribute("data-itemid");

    // Populate the modal fields with the data
    document.getElementById("modalItemId").innerText = itemId;
}

function roomEditRenderCopy() {
    const selectedBuilding = document.querySelector('[name="itemEditLoc"]').value;
    const selectedFloor = document.getElementById('itemEditFloor').value;
    const roomSelect = document.getElementById('editRoomOptions');
    roomSelect.innerHTML = '';    

    const filteredRooms = roomsData.filter(function(room) {
            return room.floor === selectedFloor && room.lid === selectedBuilding;
        });
    filteredRooms.forEach(room => {
        const option = document.createElement('option');
        option.value = room.roomName;  
        option.text = room.roomName; 
        roomSelect.appendChild(option); 
    });
 
}

    </script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>