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
                <a href="./buildingDashboard?locID=${locID}" class="buttonsBack font-light" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;">
                <img
                        src="resources/images/icons/angle-left-solid.svg" 
                        alt="back icon"
                        width="20"
                        height="20"
                    /> <!-- change based on state of building -->
                    Back
                </a>
            </div>
        </div>
        <div class="buildingName font-medium">
            <h1>${locName}</h1>
        </div>
        <div class="container font-medium">
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=all" class="floorLinks">
                        All Items
                    </a>
                    <c:if test="${floorName == 'all'}">
                        <c:set var="flrMatchFound" value="true" />
                    </c:if>
        <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
            <c:if test="${floors.key == locID}">
                <c:forEach var="floor" items="${floors.value}">
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=${floor}" class="floorLinks font-medium">
                        ${floor}
                    </a>
                    <c:if test="${floor == floorName}">
                        <c:set var="flrMatchFound" value="true" />
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>    
        </div>
        <div class="floorAndButtons font-medium">
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
        <div class="roomDropsdiv ">
            <div style="overflow-x: auto; overflow-y: hidden; white-space: nowrap;">
            <table aria-label="history logs table" style="border: 1px solid black;">
                                <tr class="font-medium" style="margin-bottom: 120px; background-color: black; color: white;">
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
                    <div class="roomDropDiv font-medium">
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
            
            <div class="font-medium" id="paginationControls"></div>
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
    
        function showTblDiv(button) {
            var roomDropDiv = button.closest('.roomDropDiv');
            // Find the .roomDTblDiv inside the parent container
            var tblDiv = roomDropDiv.querySelector('.roomDTblDiv');
    
            // Toggle the display property of the specific .roomDTblDiv
            tblDiv.style.display = (tblDiv.style.display === 'none' || tblDiv.style.display === '') ? 'block' : 'none';
            // Store the state in localStorage
            //localStorage.setItem('tblDivVisible', tblDiv.style.display === 'block' ? 'true' : 'false');
        }
//        window.onload = function() {
//            const isTblDivVisible = localStorage.getItem('tblDivVisible');
//            const tblDiv = document.querySelector('.roomDTblDiv');
//            if (isTblDivVisible === 'true') {
//                tblDiv.style.display = 'block';
//            }
//        };
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

function filterTypes() {
    // Get the selected category's itemCID
    const selectedCategoryId = document.getElementById('itemCat').value;

    // Get all itemType options
    const typeOptions = document.querySelectorAll('#itemType option');

    // Loop through all type options
    typeOptions.forEach(option => {
        // Check if the option's data-item-cid matches the selected category ID
        if (option.getAttribute('data-item-cid') === selectedCategoryId) {
            option.style.display = 'block'; // Show the option
        } else {
            option.style.display = 'none'; // Hide the option
        }
    });

    // Reset the selected option to the first visible option
    const typeDropdown = document.getElementById('itemType');
    const firstVisibleOption = Array.from(typeOptions).find(option => option.style.display === 'block');
    if (firstVisibleOption) {
        typeDropdown.value = firstVisibleOption.value;
    } else {
        typeDropdown.value = ''; // No valid options available
    }
}
function filterETypes() {
    // Get the selected category's itemCID
    const selectedCategoryId = document.getElementById('itemECat').value;

    // Get all itemType options
    const typeOptions = document.querySelectorAll('#itemEType option');

    // Loop through all type options
    typeOptions.forEach(option => {
        // Check if the option's data-item-cid matches the selected category ID
        if (option.getAttribute('data-item-cid') === selectedCategoryId) {
            option.style.display = 'block'; // Show the option
        } else {
            option.style.display = 'none'; // Hide the option
        }
    });

    // Reset the selected option to the first visible option
    const typeDropdown = document.getElementById('itemEType');
    const firstVisibleOption = Array.from(typeOptions).find(option => option.style.display === 'block');
    if (firstVisibleOption) {
        typeDropdown.value = firstVisibleOption.value;
    } else {
        typeDropdown.value = ''; // No valid options available
    }
}

function toggleAirconDiv() {
        const selectedCat = document.querySelector('[name="itemCat"]').value;
        const onlyAirDiv = document.querySelector('.onlyAir');
        
        if (selectedCat === "1") {
            onlyAirDiv.style.removeProperty('display'); // Removes "display: none"
        } else {
            onlyAirDiv.style.display = "none";
            
          // Clear checkbox values
            document.querySelectorAll('.onlyAir .form-check-input').forEach(function(checkbox) {
                checkbox.checked = false;
            });  
        }
    }
function toggleEAirconDiv(editVal) {
        const selectedECat = document.querySelector('[name="itemEditCat"]').value;
        const onlyEAirDiv = document.querySelector('.onlyEditAir');
        
        if (selectedECat === "1" || editVal === 1) {
            onlyEAirDiv.style.removeProperty('display'); // Removes "display: none"
        } else {
            onlyEAirDiv.style.display = "none";
        }
    }

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

const inputAddR = document.querySelector("#itemAddRoom");
    const awesompleteAddR = new Awesomplete(inputAddR, {
        list: "#roomOptions"
    });

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

    const roomNames = filteredRooms.map(room => room.roomName); // Extract room names as strings
    awesompleteAddR.list = roomNames;
}
//    same as roomRender but for edit modal pancakes
const inputER = document.querySelector("#itemEditRoom");
    const awesompleteER = new Awesomplete(inputER, {
        list: "#editRoomOptions"
    });
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
        
        if (itemRoom) {
        for (let i = 0; i < roomSelect.options.length; i++) {
            if (roomSelect.options[i].value === itemRoom) {
                roomSelect.options[i].selected = true;
                roomField.value = roomSelect.options[i].value;
                break;
            }
        }
    } else {
        // Set "Non-Room Equipment" as the default value
        roomSelect.value = null; // Ensure default option is selected
        roomField.value = "Non-Room Equipment";
    }

    // Populate autocomplete list
    const roomENames = filteredRooms.map(room => room.roomName); // Extract room names as strings
    awesompleteER.list = roomENames;
}
    
    
    function populateEditModal(button) {
        var itemID = button.getAttribute('data-itemid');
        var itemLID = parseInt(${locID});
        var itemName = button.getAttribute('data-itemname');
        var itemBrand = button.getAttribute('data-itembrand');
        var itemFloor = button.getAttribute('data-itemfloor');
        var itemDateInst = button.getAttribute('data-dateinst');
        var itemExpiry = button.getAttribute('data-itemexpiry');
        var itemCat = button.getAttribute('data-itemcat');
        var itemType = button.getAttribute('data-itemtype');
        var itemLocText = button.getAttribute('data-itemloctext');
        var itemRemarks = button.getAttribute('data-itemremarks');
        
        var itemPCCode = button.getAttribute('data-itempcc');
        var itemACaccu = button.getAttribute('data-accu');
        var itemACfcu = button.getAttribute('data-fcu');
        var itemACinverter = button.getAttribute('data-inverter');
        var itemCapacity = button.getAttribute('data-itemcapacity');
        var itemMeasure = button.getAttribute('data-itemmeasure');
        var itemEV = button.getAttribute('data-itemev');
        var itemEPH = button.getAttribute('data-itemeph');
        var itemEHZ = button.getAttribute('data-itemehz');
        
        document.querySelector('input[name="itemEditID"]').value = itemID;

        document.querySelector('input[name="itemEditCode"]').value = itemName;
        document.querySelector('input[name="itemEditBrand"]').value = itemBrand;
        document.querySelector('input[name="itemEditInstalled"]').value = itemDateInst;
        document.querySelector('input[name="itemEditExpiration"]').value = itemExpiry;
        document.querySelector('textarea[name="editLocText"]').value = itemLocText;
        document.querySelector('textarea[name="editRemarks"]').value = itemRemarks;
        
        document.querySelector('input[name="itemEditPCC"]').value = itemPCCode;
        document.querySelector('input[name="itemECapacity"]').value = itemCapacity;
        document.querySelector('input[name="itemEUnitMeasure"]').value = itemMeasure;
        document.querySelector('input[name="itemEditElecV"]').value = itemEV;
        document.querySelector('input[name="itemEditElecPH"]').value = itemEPH;
        document.querySelector('input[name="itemEditElecHZ"]').value = itemEHZ;
        
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
        
        if (itemACaccu === '1') {
            document.querySelector('[name="itemEditACCU"]').checked = true;
        } else {
            document.querySelector('[name="itemEditACCU"]').checked = false;
        }
        if (itemACfcu === '1') {
            document.querySelector('[name="itemEditFCU"]').checked = true;
        } else {
            document.querySelector('[name="itemEditFCU"]').checked = false;
        }
        if (itemACinverter === '1') {
            document.querySelector('[name="itemEditACINVERTER"]').checked = true;
        } else {
            document.querySelector('[name="itemEditACINVERTER"]').checked = false;
        }
            
    }
    
    function setFloorSelection(button) {
    var itemRoom = button.getAttribute('data-itemroom');
    console.log(itemRoom);
    const flrName = '${floorName}';
    console.log(flrName);
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

    function populateArchModal(button){
        var itemAID = button.getAttribute('data-itemaid');
        var itemAName = button.getAttribute('data-itemaname');
        
        document.getElementById('itemArchiveID').value = itemAID;
        var modalMessage = document.getElementById("archYouSure");
        modalMessage.innerText = "Are you sure you want to archive " + itemAName + "?";
        
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
    // Retrieve the itemID from the clicked button
    const itemId = button.getAttribute("data-itemid");

    // Set the item ID in a hidden field within the modal or display it as needed
    document.querySelector('#hiddenItemId').value = itemId;
    document.getElementById('modalItemIdDisplay').innerText = "Quotations for Item ID: " + itemId;

    // Show the modal
    const modalElement = new bootstrap.Modal(document.getElementById('quotEquipmentModal'));
    modalElement.show();
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
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>