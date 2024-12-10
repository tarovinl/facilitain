<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%> 
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Location</title>
        <link rel="stylesheet" href="resources/css/mBuilding.css">
        <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
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
<div class="container-fluid">
  <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>
    
    
    <div class="col-md-10">
            <jsp:include page="quotations.jsp"><jsp:param name="locID" value="${locID}" /></jsp:include>
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
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=all" class="floorLinks">
                        All Items
                    </a>
                    <c:if test="${floorName == 'all'}">
                        <c:set var="flrMatchFound" value="true" />
                    </c:if>
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
              <h1>${floorName == 'all' ? 'All Items' : floorName}</h1>
            </div>
            <div>
              <button class="buttonsBuilding" onclick="window.location.href='buildingDashboard?locID=${locID}/edit'"><!--hidden if acc is not admin-->
                Edit Location
              </button>
               
              <button class="buttonsBuilding" data-toggle="modal" data-target="#addEquipment" type="button" onclick="QOLLocSet(); floorRender(); toggleAirconDiv(); filterTypes();">Add Equipment</button>
            </div>
        </div>
        <c:if test="${floorName == 'all'}">
        <div class="roomDropsdiv">
            <div style="overflow-x: auto; overflow-y: hidden; white-space: nowrap;">
            <table aria-label="history logs table" style="border: 1px solid black;">
                                <tr style="margin-bottom: 120px; background-color: black; color: white;">
                                    <!--<th ></th>-->
                                    <th ></th>
                                    <th ></th>
                                    <th >ID</th>
                                    <th >Codename</th>
                                    <th >Category</th>
                                    <th >Type</th>
                                    <th >Brand</th>
                                    <th >Date Installed</th>
                                    <th>
                                        Quotation
                                    </th>
                                    <th >Status</th>
                                </tr>
                                
                            <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                            <c:if test="${item.itemArchive == 1}">
                                <c:if test="${item.itemLID == locID}">
                                <tr style="border: solid 1px black;">
                                
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
                                
                                    <!--<td style="margin-left: 4px; margin-right: 4px; text-align:center;">
                                        <input type="image" 
                                        src="resources/images/itemInfo.svg" 
                                        width="24" 
                                        height="24"/>
                                    </td>-->
                                    <td style="margin-left: 4px; margin-right: 4px; text-align:center;">
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
                                        data-itemfloor="${item.itemFloor}"
                                        data-itemroom="${item.itemRoom}"
                                        data-itemtype="${itemEditType}"
                                        data-itemloctext="${item.itemLocText}"
                                        data-itemremarks="${item.itemRemarks}"

                                        data-itempcc="${item.itemPCC}"
                                        data-accu="${item.acACCU}"
                                        data-fcu="${item.acFCU}"
                                        data-inverter="${item.acINVERTER}"
                                        data-itemcapacity="${item.itemCapacity}"
                                        data-itemmeasure="${item.itemUnitMeasure}"
                                        data-itemev="${item.itemEV}"
                                        data-itemeph="${item.itemEPH}"
                                        data-itemehz="${item.itemEHZ}"
                                        onclick="populateEditModal(this);floorERender();setFloorSelection(this);toggleEAirconDiv(${itemEditCat});"/> 
                                    </td>
                                    <td style="margin-left: 4px; margin-right: 4px; text-align:center;">
                                        <input type="image" 
                                        src="resources/images/archiveItem.svg" 
                                        id="archiveModalButton" 
                                        alt="Open Archive Modal" 
                                        width="24" 
                                        height="24"
                                        data-toggle="modal"
                                        data-itemaid="${item.itemID}"
                                        data-itemaname="${item.itemName}"
                                        data-target="#archiveEquipment"
                                        onclick="populateArchModal(this)"/>
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
                                    <!-- Quotation Icon Button in manageBuilding.jsp -->
                                    <td style="display: flex; justify-content: center; align-items: center; margin-top: 8px;">
                                        <form id="quotForm" method="GET" action="quotations.jsp" style="display: none;">
                                            <input type="hidden" name="displayQuotItemID" id="hiddenItemID">
                                        </form>
                                        <input type="image"
                                            src="resources/images/quotationsIcon.svg"
                                            id="quotModalButton"
                                            alt="Open Quotation Modal"
                                            width="24"
                                            height="24"
                                            data-itemid="${item.itemID}"
                                            data-bs-toggle="modal"
                                            data-bs-target="#quotEquipmentModal"
                                            onclick="openQuotModal(this)">
                                    </td>
                                    <td >
                                      <form action="itemcontroller" method="POST">
                                        <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}"/>
                                        <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}"/>
                                        <input type="hidden" name="maintStatID" value="${item.itemID}" />
                                        <input type="hidden" name="oldMaintStat" value="${item.itemMaintStat}" />
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
                            </c:forEach>    
                                
            </table>
            </div>
        </div>
        </c:if>
        
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
                                    <!--<th ></th>-->
                                    <th ></th>
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
                            <c:if test="${item.itemArchive == 1}">
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
                                
                                    <!--<td style="margin-left: 4px; margin-right: 4px; text-align:center;">
                                        <input type="image" 
                                        src="resources/images/itemInfo.svg" 
                                        width="24" 
                                        height="24"/>
                                    </td>-->
                                    <td style="margin-left: 4px; margin-right: 4px; text-align:center;">
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
                                        data-itemfloor="${item.itemFloor}"
                                        data-itemroom="${item.itemRoom}"
                                        data-itemtype="${itemEditType}"
                                        data-itemloctext="${item.itemLocText}"
                                        data-itemremarks="${item.itemRemarks}"

                                        data-itempcc="${item.itemPCC}"
                                        data-accu="${item.acACCU}"
                                        data-fcu="${item.acFCU}"
                                        data-inverter="${item.acINVERTER}"
                                        data-itemcapacity="${item.itemCapacity}"
                                        data-itemmeasure="${item.itemUnitMeasure}"
                                        data-itemev="${item.itemEV}"
                                        data-itemeph="${item.itemEPH}"
                                        data-itemehz="${item.itemEHZ}"
                                        onclick="populateEditModal(this);floorERender();setFloorSelection(this);toggleEAirconDiv(${itemEditCat});filterETypes();"/> 
                                    </td>
                                    <td style="margin-left: 4px; margin-right: 4px; text-align:center;">
                                        <input type="image" 
                                        src="resources/images/archiveItem.svg" 
                                        id="archiveModalButton" 
                                        alt="Open Archive Modal" 
                                        width="24" 
                                        height="24"
                                        data-toggle="modal"
                                        data-itemaid="${item.itemID}"
                                        data-itemaname="${item.itemName}"
                                        data-target="#archiveEquipment"
                                        onclick="populateArchModal(this)"/>
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
                                  <!-- Quotation Icon Button in manageBuilding.jsp -->
<!-- Quotation Icon Button in manageBuilding.jsp -->
<td style="display: flex; justify-content: center; align-items: center; margin-top: 8px;">
    <form id="quotForm" method="GET" action="quotations.jsp" style="display: none;">
        <input type="hidden" name="displayQuotItemID" id="hiddenItemID">
    </form>
    <input type="image"
        src="resources/images/quotationsIcon.svg"
        id="quotModalButton"
        alt="Open Quotation Modal"
        width="24"
        height="24"
        data-itemid="${item.itemID}"
        data-bs-toggle="modal"
        data-bs-target="#quotEquipmentModal"
        onclick="openQuotModal(this)">
</td>


                                    <td >
                                      <form action="itemcontroller" method="POST">
                                        <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}"/>
                                        <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}"/>
                                        <input type="hidden" name="maintStatID" value="${item.itemID}" />
                                        <input type="hidden" name="oldMaintStat" value="${item.itemMaintStat}" />
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
                                    <input type="text" name="itemCode" id="" class="form-control" maxlength="20" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Building</label>
                                    <select class="form-select" name="itemBuilding" onchange="floorRender()">
                                        <c:forEach items="${locations}" var="loc" >
                                            <option value="${loc.itemLocId}" selected>${loc.locName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemPCC" class="form-label">PC Code</label>
                                    <input class="form-control" id="itemPCC" type="number" name="itemPCC" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==10) return false;">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemCat" class="form-label">Category</label>
                                    <select class="form-select" name="itemCat" id="itemCat" onchange="toggleAirconDiv();filterTypes();">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemType" class="form-label">Type</label>
                                    <select class="form-select" name="itemType" id="itemType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <option value="${type.itemTID}" data-item-cid="${type.itemCID}" selected>${type.itemType}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemBrand" class="form-label">Brand</label>
                                    <input class="form-control awesomplete" id="brandName" data-list="${brandListString}" name="itemBrand" maxlength="55">
                                </div>
                            </div>
                            <div class="row mt-2 onlyAir">
                                <div class="col-12">
                                    <div class="form-row d-flex justify-content-center">
                                    <label for="itemACType" class="form-label">Airconditioner Type</label>
                                    </div>
                                    <div class="form-row d-flex justify-content-between">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="1" name="itemACCU">
                                        <label class="form-check-label" for="inlineCheckbox1">ACCU</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="1" name="itemFCU">
                                        <label class="form-check-label" for="inlineCheckbox2">FCU</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox3" value="1" name="itemACINVERTER">
                                        <label class="form-check-label" for="inlineCheckbox3">INVERTER</label>
                                    </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemCapacity" class="form-label">Capacity</label>
                                    <input class="form-control" id="itemCapacity" type="number" name="itemCapacity" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==5) return false;">
                                </div>
                                <div class="col">
                                    <label for="itemUnitMeasure" class="form-label">Unit of Measure</label>
                                    <input class="form-control" id="itemUnitMeasure" name="itemUnitMeasure" type="text" maxlength="10">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemElecV" class="form-label">Electrical V</label>
                                    <input class="form-control" id="itemElecV" name="itemElecV" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==5) return false;">
                                </div>
                                <div class="col">
                                    <label for="itemElecPH" class="form-label">Electrical PH</label>
                                    <input class="form-control" id="itemElecPH" name="itemElecPH" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==2) return false;">
                                </div>
                                <div class="col">
                                    <label for="itemElecHZ" class="form-label">Electrical HZ</label>
                                    <input class="form-control" id="itemElecHZ" name="itemElecHZ" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==3) return false;">
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
                                    <input class="form-control awesomplete" list="roomOptions" id="itemAddRoom" name="itemAddRoom" maxlength="50">
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
                                <!--<div class="col">
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
                                    
                                </div>-->
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="locText">Location Text</label>
                                    <textarea class="form-control" id="locText" name="locText" rows="2" maxlength="200"></textarea>
                                </div>
                                <div class="col">
                                    <label for="remarks">Remarks</label>
                                    <textarea class="form-control" id="remarks" name="remarks" rows="2" maxlength="200"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col text-center">
                                    <input type="submit" value="Save" class="btn btn-warning btn-lg mt-3 w-100 fw-bold">
                                </div> 
                                <div class="col text-center">
                                    <button type="button" class="btn btn-warning btn-lg mt-3 w-100 fw-bold" data-dismiss="modal">Cancel</button>
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
                                    <input type="text" name="itemEditCode" id="" class="form-control" maxlength="20" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Building</label>
                                    <select class="form-select" name="itemEditLoc" onchange="floorERender()">
                                        <c:forEach items="${locations}" var="loc" >
                                            <option value="${loc.itemLocId}" selected>${loc.locName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditPCC" class="form-label">PC Code</label>
                                    <input class="form-control" id="itemEditPCC" type="number" name="itemEditPCC" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==10) return false;">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemEditCat" class="form-label">Category</label>
                                    <select class="form-select" name="itemEditCat" id="itemECat" onchange="toggleEAirconDiv();filterETypes();">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditType" class="form-label">Type</label>
                                    <select class="form-select" name="itemEditType" id="itemEType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <option value="${type.itemTID}" data-item-cid="${type.itemCID}" selected>${type.itemType}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditBrand" class="form-label">Brand</label>
                                    <input class="form-control awesomplete" name="itemEditBrand" id="brandName" data-list="${brandListString}" maxlength="55">
                                </div>
                            </div>
                            <div class="row mt-2 onlyEditAir">
                                <div class="col-12">
                                    <div class="form-row d-flex justify-content-center">
                                    <label for="itemEditACType" class="form-label">Airconditioner Type</label>
                                    </div>
                                    <div class="form-row d-flex justify-content-between">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="1" name="itemEditACCU">
                                        <label class="form-check-label" for="inlineCheckbox1">ACCU</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="1" name="itemEditFCU">
                                        <label class="form-check-label" for="inlineCheckbox2">FCU</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox3" value="1" name="itemEditACINVERTER">
                                        <label class="form-check-label" for="inlineCheckbox3">INVERTER</label>
                                    </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemECapacity" class="form-label">Capacity</label>
                                    <input class="form-control" id="itemECapacity" type="number" name="itemECapacity" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==5) return false;">
                                </div>
                                <div class="col">
                                    <label for="itemEUnitMeasure" class="form-label">Unit of Measure</label>
                                    <input class="form-control" id="itemEUnitMeasure" name="itemEUnitMeasure"type="text" maxlength="10">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="" class="form-label">Electrical V</label>
                                    <input class="form-control" id="itemElecV" name="itemEditElecV" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==5) return false;">
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Electrical PH</label>
                                    <input class="form-control" id="itemElecPH" name="itemEditElecPH" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==2) return false;">
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Electrical HZ</label>
                                    <input class="form-control" id="itemElecHZ" name="itemEditElecHZ" type="number" pattern="/^-?\d+\.?\d*$/" onKeyPress="if(this.value.length==3) return false;">
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
                                    <input class="form-control" list="editRoomOptions" id="itemEditRoom" name="itemEditRoom" maxlength="50">
                                    <datalist id="editRoomOptions"></datalist>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="" class="form-label">Date Installed</label>
                                    <input type="date" name="itemEditInstalled" id="itemEditInstalled" class="form-control" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Expiration Date</label>
                                    <input type="date" name="itemEditExpiration" id="" class="form-control">
                                </div>
                                <!--<div class="col">
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
                                    
                                </div>-->
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="locText">Location Text</label>
                                    <textarea class="form-control" name="editLocText" id="locText" rows="2" maxlength="200"></textarea>
                                </div>
                                <div class="col">
                                    <label for="remarks">Remarks</label>
                                    <textarea class="form-control" id="remarks" name="editRemarks" rows="2" maxlength="200"></textarea>
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
    
    <!--archive equipment modal-->
<div class="modal fade" id="archiveEquipment" tabindex="-1" role="dialog" aria-labelledby="archiveEquipment" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                    <form action="itemcontroller" method="POST">
                        <div class="row">
                            <div class="col text-center">
                                <h2 class="fw-bold" id="archYouSure"></h2>
                            </div>
                        </div>
                        <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
                        <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
                        <input type="hidden" name="itemArchiveID" id="itemArchiveID" class="form-control">
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
    <!--end of archive equipment modal-->
    
    <jsp:include page="quotations.jsp" />
    
    <c:if test="${locMatchFound == false || flrMatchFound == false}">
        <meta http-equiv="refresh" content="0; URL=./homepage" /> 
    </c:if>
    <script>
   package com.sample;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;

import java.time.format.DateTimeParseException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.PooledConnection;

@WebServlet(name = "ToDoListController", urlPatterns = { "/todolistcontroller" })
public class ToDoListController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
        String fullUrl = request.getParameter("originalUrl");
        if (fullUrl != null) {
            // Remove "?null" if it exists
            if (fullUrl.contains("?null")) {
                fullUrl = fullUrl.replace("?null", "");
            }

            // Remove ".jsp" from anywhere in the URL
            fullUrl = fullUrl.replace(".jsp", "");

            // Replace "manageBuilding" with "buildingDashboard"
            fullUrl = fullUrl.replace("manageBuilding", "buildingDashboard");
            fullUrl = fullUrl.replace("editLocation", "buildingDashboard");
        }
        
        String tdListID = request.getParameter("tdListId");
        
        String tdListContent = request.getParameter("tdListContent");
        String tdListStart = request.getParameter("tdListStart");
        String tdListEnd = request.getParameter("tdListEnd");
        String tdListChecked = request.getParameter("tdListChecked");
        String tdListCreationDate = request.getParameter("tdListCreationDate");
        
        String tdAction = request.getParameter("tdAction");
        
        System.out.println("-------------------------------" );
        System.out.println(fullUrl);

//        // Early check for tdListID validity only if tdAction is not null
//        if (tdAction != null && (tdAction.equals("check") || tdAction.equals("uncheck") || tdAction.equals("delete"))) {
//            if (tdListID == null || tdListID.isEmpty()) {
//                throw new ServletException("LIST_ITEM_ID is missing or invalid for the action: " + tdAction);
//            }
//        }
        
//        System.out.println("-------------------------------" );
//        System.out.println("tdListID: " + tdListID);
//        System.out.println("tdListContent: " + tdListContent);
//        System.out.println("tdListStart: " + tdListStart);
//        System.out.println("tdListEnd: " + tdListEnd);
//        System.out.println("tdListChecked: " + tdListChecked);
//        System.out.println("tdListCreationDate: " + tdListCreationDate);
//        System.out.println("tdAction: " + tdAction);
        
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // For "yyyy-MM-dd'T'HH:mm"
        
        Timestamp sqlStartTimestamp = null;
        Timestamp sqlEndTimestamp = null;
        
        if (tdAction == null) {
            try {
                LocalDateTime startDateTime = LocalDateTime.parse(tdListStart, formatter);
                LocalDateTime endDateTime = LocalDateTime.parse(tdListEnd, formatter);

                sqlStartTimestamp = Timestamp.valueOf(startDateTime);
                sqlEndTimestamp = Timestamp.valueOf(endDateTime);
            } catch (DateTimeParseException e) {
                throw new ServletException("Invalid date format for start or end date.", e);
            }
        }

        
        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if ("delete".equals(tdAction)) {
                sql = "DELETE FROM FMO_ADM.FMO_TO_DO_LIST WHERE LIST_ITEM_ID = ?";
            }else if ("check".equals(tdAction)) {
                sql = "UPDATE FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 1 WHERE LIST_ITEM_ID = ?";
            }else if ("uncheck".equals(tdAction)) {
                sql = "UPDATE FMO_ADM.FMO_TO_DO_LIST SET IS_CHECKED = 0 WHERE LIST_ITEM_ID = ?";
            }else{
                sql = "INSERT INTO FMO_ADM.FMO_TO_DO_LIST (EMP_NUMBER, LIST_CONTENT, START_DATE, END_DATE) VALUES (1234, ?, ?, ?)";
            }
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    if ("delete".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else if ("check".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else if ("uncheck".equals(tdAction)) {
                        stmt.setInt(1, Integer.parseInt(tdListID));
                    }else{
                        stmt.setString(1, tdListContent);
                        stmt.setTimestamp(2, sqlStartTimestamp);
                        stmt.setTimestamp(3, sqlEndTimestamp);
                    }
                    
                    stmt.executeUpdate();
                }
            
            // Redirect to homepage after the action is performed
            response.sendRedirect(fullUrl);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding/editing/deleting to do list item.");
        }
        
    }
}

    </script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>