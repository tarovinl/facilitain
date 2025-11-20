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
     

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.css" />
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.js"></script>
    <!-- Bootstrap 5 CSS and JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.js"></script>
        
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
    
thead{
    background-color: black !important;
    color: white !important;
    
}


.floorContainer {
    
    display: flex;
}


.floorAndButtons {
    display: flex;
    justify-content: space-between;
    align-items: center;
   
    margin-top: 8px;
}

.floorName {
    display: flex;
    vertical-align: middle;
}
.floorName h1 {
    font-size: 44px;
    font-weight: bold;
}


.roomDropsdiv {
    margin-top: 20px;
    
}

.roomDropdowns {
    list-style-type: none;
}
#paginationControls {
    text-align: center;
    margin-top: 15px;
}
.page-btn {
    margin: 0 5px;
    
    border: 1px solid black; /* Border color */
    background-color: #fccc4c;   /* Background color */
    color: black;            /* Text color */
    cursor: pointer;
    border-radius: 5px;
    font-size: 14px;
    font-weight: bold;
    transition: background-color 0.3s, color 0.3s; /* Add a smooth hover effect */
}
.page-btn:hover {
    background-color: #ffcc00; /* Blue background on hover */
    color: black;              /* White text on hover */
}
.page-btn.active {
    background-color: black; /* Active button background */
    color: #fccc4c;              /* Active button text color */
    border-color: black;     /* Border color for the active button */
}


.roomDropdown {
}

.roomDropdiv {
}

/*thead{
    background-color: black !important;
    color: white !important;
}
table.dataTable>thead>tr:hover td,
table.dataTable>thead>tr:hover th {
  background-color: #fccc4c !important;
  color: black !important;
  border: solid 1px black !important;
}
table.dataTable thead>tr>th.dt-orderable-asc span:hover,
table.dataTable thead>tr>th.dt-orderable-desc span:hover,
table.dataTable thead>tr>th.dt-ordering-asc span:hover,
table.dataTable thead>tr>th.dt-ordering-desc span:hover,
table.dataTable thead>tr>td.dt-orderable-asc span:hover,
table.dataTable thead>tr>td.dt-orderable-desc span:hover,
table.dataTable thead>tr>td.dt-ordering-asc span:hover,
table.dataTable thead>tr>td.dt-ordering-desc span:hover {
    color: black;*/ /* Change this to your hover color */
/*}*/
div.dt-container .dt-paging .dt-paging-button.current, div.dt-container .dt-paging .dt-paging-button.current:hover {
  border: 1px solid black !important;
  background-color: #fccc4c !important;
}


.roomDLblDiv {
    background-color: #fccc4c;
    
    display: flex;
    align-items: center;
    justify-content: space-between;
    border: solid 1px black;
}
.roomDLblDiv button:hover {
    background-color: #ffcc00; /* Change button color on hover */
}
.roomDLblDiv:has(button:hover) {
    background-color: #ffcc00; /* Change div color when button is hovered */
}
.roomDLblDiv button {
    background-color: #fccc4c;
    font-weight: bold;
    margin-top: 8px;
    
    border: none;
}

.roomDTblDiv {
    overflow-x: auto;
    overflow-y: hidden;
    white-space: nowrap;
}
.roomDTblDiv table {
    width: 100%; /* Ensure the table takes up the full width of the div */
    font-weight: bold;
}
/*.roomDTblDiv th {
    background-color: black;
    color: white;
    border: solid 1px black;
}
.roomDTblDiv tr {
    border: solid 1px black;
}*/

.statusDropdown {
    font-size: 16px;
    
    width: 160px;
}

.roomDTblDiv2 table {
    width: 100%; /* Ensure the table takes up the full width of the div */
    font-weight: bold;
}
/*.roomDTblDiv2 th {
    background-color: black;
    color: white;
    border: solid 1px black;
}
.roomDTblDiv2 tr {
    border: solid 1px black;
}*/

/*.working {
    background-color: green;
    color: white;
    font-weight: bold;
}
.nwork {
    background-color: red;
    color: white;
    font-weight: bold;
}
.maintenance {
    background-color: orange;
    color: white;
    font-weight: bold;
}*/

/*table {
        border-collapse: collapse;*/ /* Collapse borders to avoid double borders */
        /*width: 100%;*/ /* Optional: Set table width */
        /*margin: 0;*/ /* Reset margin */
            /*padding: 0;*/ /* Reset padding */
    /*}

    table th {
    border-left: 1px solid #ccc;*/ /* More specific selector */
    /*border-right: 1px solid #ccc;*/ /* More specific selector */
/*}*/


    /* Optional: Change the border color on hover */
    /*tr:hover {
        background-color: #f9f9f9;*/ /* Light gray background on row hover */
    /*}*/
    

.onlyAir {
    display: none;
}
.onlyEditAir{
    display:none;
}

@media (max-width: 800px) {
    .roomDTblDiv tr {
        margin-bottom: 10px;
    }
    .buttonsBuilding{
        
        font-size: 16px;
    }
    .buttonsBuilding {
        
        font-size: 16px;
    }
  
}

    
    body, h1, h2, h3, h4, th {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
h5, h6, input, textarea, td, tr, p, label, select, option {
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
            .buildingManage:hover {
                text-decoration: underline !important;
                }
            table.dataTable thead th {
            font-family: NeueHaasMedium, sans-serif !important;
            }
            
            .floorLinks {
            text-decoration: none;
            font-weight: bold;
            font-size: 18px;
            color: black;
                        }
            .floorLinks:visited {
            text-decoration: underline !important;
                                }
            .floorLinks:hover {
                color: #fccc4c;
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

                .responsive-padding-top {
                  padding-top: 70px;
                }
                
                @media (max-width: 576px) {
                  .responsive-padding-top {
                    padding-top: 60px; /* or whatever smaller value you want */
                  }
                }

</style>
    
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
    <jsp:include page="navbar.jsp"/>
    <jsp:include page="sidebar.jsp"/>
<div class="container-fluid p-4 ">
  <div class="row min-vh-100">

    
    
    <div class="col-md-10 responsive-padding-top">
            <jsp:include page="quotations.jsp"><jsp:param name="locID" value="${locID}" /></jsp:include>
        <div class="topButtons"> <!-- top buttons -->
            <div>
                <!-- Link component remains unchanged -->
                <a href="./buildingDashboard?locID=${locID}" class=" buttonsBack d-flex align-items-center gap-2 text-decoration-none text-dark fs-4" style="text-decoration: none;color: black;  display: flex; align-items: center; font-family: NeueHaasLight, sans-serif;">
               
    <img src="resources/images/icons/angle-left-solid.svg" alt="back icon" width="20" height="20">
    Back
                </a>
            </div>
        </div>
        <div class=" border-bottom pt-2">
        
    <div class=" d-flex justify-content-between align-items-center">
        <h1 class="display-5 display-md-5 display-lg-4" style="font-family: NeueHaasMedium, sans-serif;">${locName}</h1>
    <div class="mb-2">
        <c:choose>
            <c:when test="${sessionScope.role == 'Admin'}">
            <div class="row">
                <div class="col-12 col-sm-auto d-flex justify-content-end align-items-center gap-2 flex-wrap">
                    <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center"
                            style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;"
                            onclick="window.location.href='buildingDashboard?locID=${locID}/edit'">
                        <img src="resources/images/icons/edit.svg"  alt="edit icon" width="25" height="25">
                         <span class="d-none d-lg-inline ps-2">Edit Location</span>
                    </button>
                    <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center"
                            style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;"
                            data-toggle="modal" data-target="#addEquipment" type="button"
                            onclick="QOLLocSet(); floorRender(); toggleAirconDiv(); filterTypes();">
                        <img src="resources/images/icons/plus.svg" alt="add"  width="25" height="25">
                         <span class="d-none d-lg-inline ps-2">Add Equipment</span>
                    </button>
                </div>
                </div>
            </c:when>
        </c:choose>
    </div>
    </div>
    
</div>

<div class=" container-fluid p-0 d-flex border-bottom justify-content-between align-items-center flex-wrap">
    <!-- Left side: Floor name -->
    <div class="d-flex align-items-center" style="height: 60px;">
  <h1 class="display-5 display-md-5 display-lg-4 m-0" style="font-family: NeueHaasMedium, sans-serif; color: #212529;">
    ${floorName == 'all' ? 'All Items' : floorName}
  </h1>
</div>

    <!-- Right side: Floor selection links -->
    <div class="d-flex flex-wrap gap-3" style="font-family: NeueHaasLight, sans-serif;">
        <a href="./buildingDashboard?locID=${locID}/manage?floor=all" class="floorLinks fs-5">
            All Items
        </a>
        <c:if test="${floorName == 'all'}">
            <c:set var="flrMatchFound" value="true" />
        </c:if>
        <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
            <c:if test="${floors.key == locID}">
                <c:forEach var="floor" items="${floors.value}">
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=${floor}" class="floorLinks fs-5">
                        ${floor}
                    </a>
                    <c:if test="${floor == floorName}">
                        <c:set var="flrMatchFound" value="true" />
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>
    </div>
</div>


         
        
        <c:if test="${floorName == 'all'}">
        <div class="roomDropsdiv ">
            <div class="table-responsive">
            <table id="allItemsTable" class="display dataTable" style="width:100%;">
                <thead>
                    <tr>
                        <th> </th>
                        <th>ID</th>
                        <th>Codename</th>
                        <th>Floor</th>
                        <th>Room</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Brand</th>
                        <th>Date Installed</th>
                        <th>Capacity</th>
                        <th>Status</th>
                            <th>Actions</th>
                    </tr>
                </thead>
            </table>
            </div>
        </div>
        </c:if>
        
       <!-- confirm status change-->
        <!--<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="centered-div bg-white">
                        <div class="container p-4 mt-4 mb-4">
                            <p class="text-center fs-5">Are you sure you want to change the status?</p>
                            <div class="row">
                                <div class="col text-center">
                                    <button id="confirmBtn" class="btn btn-warning btn-lg mt-3 w-100 fw-bold">Yes</button>
                                </div>
                                <div class="col text-center">
                                    <button type="button" class="btn btn-warning btn-lg mt-3 w-100 fw-bold" data-bs-dismiss="modal" onclick="location.reload();">Cancel</button>
                                </div> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="specialConfirmModal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="specialConfirmModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                <input type="hidden" id="modalItemMaintType" value="3" />
                  <p class="text-center fs-5 specialModalText">Are you sure you want to reset the status back to "Operational"?</p>
                  <div class="row">
                    <div class="col text-center">
                      <button id="specialConfirmBtn" class="btn btn-warning btn-lg mt-3 w-100 fw-bold">Yes</button>
                    </div>
                    <div class="col text-center">
                      <button type="button" class="btn btn-warning btn-lg mt-3 w-100 fw-bold" data-bs-dismiss="modal" onclick="location.reload();">Cancel</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>-->
        <!--<div class="modal fade" id="quotConfirmModal" tabindex="-1" role="dialog" data-bs-backdrop="static" aria-labelledby="quotConfirmModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="centered-div bg-white">
                <div class="container p-4 mt-4 mb-4">
                  <div class="row">
                    <p class="text-center fs-5 specialModalText fw-bold">Are you sure you want to change the status from Maintenance Required to In Maintenance?</p>
                  </div>
                  <div class="row">
                            <div class="mb-3">
                                <label for="quotationFile" class="form-label">Upload File</label>
                                <input class="form-control" type="file" name="quotationFile" id="quotationFile" accept=".pdf, image/*">
                            </div>
                            <div class="mb-3">
                                <label for="quotationDescription" class="form-label">Quotation Description</label>
                                <textarea class="form-control" name="description" id="quotationDescription" rows="3"></textarea>
                            </div>
                  </div>
                  <div class="row">
                    <div class="col text-center">
                      <button id="quotConfirmBtn" class="btn btn-danger btn-lg mt-3 w-100 fw-bold">Yes</button>
                    </div>
                    <div class="col text-center">
                      <button type="button" class="btn btn-danger btn-lg mt-3 w-100 fw-bold" data-bs-dismiss="modal" onclick="location.reload();">Cancel</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>-->
        
        <!-- list of room dropdowns  (turn roomDropdown <li> into foreach)-->
        <c:if test="${floorName != 'all'}">
        <div class="roomDropsdiv">
            <div class="table-responsive">
            <table id="itemsTable" class="display dataTable" style="width:100%;">
                <thead>
                    <tr>
                        <th> </th>
                        <th>ID</th>
                        <th>Codename</th>
                        <th>Room</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Brand</th>
                        <th>Date Installed</th>
                        <th>Capacity</th>
                        <th>Status</th>
                            <th>Actions</th>
                    </tr>
                </thead>
            </table>
            </div>
        </div>    
        </c:if>
     </div>
   </div>
</div>
    <!--add equipment modal-->
    <div class="modal fade" id="addEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentAdd" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
                
                        <form action="itemcontroller" method="POST">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addEquipmentModalLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Add Equipment</h5>
                                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                            
                            <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
                            <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
                            <div class="row mt-1">
                                <div class="col">
                                    <label for="" class="form-label">Codename <span style="color: red;">*</span></label>
                                    <input type="text" name="itemCode" id="" class="form-control" maxlength="20" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Location <span style="color: red;">*</span></label>
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
                                    <label for="itemCat" class="form-label">Category <span style="color: red;">*</span></label>
                                    <select class="form-select" name="itemCat" id="itemCat" onchange="toggleAirconDiv();filterTypes();">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemType" class="form-label">Type <span style="color: red;">*</span></label>
                                    <select class="form-select" name="itemType" id="itemType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <c:if test="${type.itemArchive == 1}">
                                            <option value="${type.itemTID}" data-item-cid="${type.itemCID}" selected>${type.itemType}</option>
                                            </c:if>
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
                                    <label for="itemAddFloor" class="form-label">Floor <span style="color: red;">*</span></label>
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
                                    <label for="" class="form-label">Date Installed <span style="color: red;">*</span></label>
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
                            </div>
                            <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-danger" data-dismiss="modal">Cancel</button>
                                    <input type="submit" value="Add" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif !important;">

                            </div>
                        </form>
                    
            
        </div>
    </div>
</div>
<!--end of add equipment modal-->

    <!--edit equipment modal-->
    <div class="modal fade" id="editEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentEdit" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
        
                        <form action="itemcontroller" method="POST">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editEquipmentModalLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Edit Equipment</h5>
                                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                            <input type="hidden" name="itemEditID" id="itemIDField" class="form-control">
                            <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
                            <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
                            <div class="row mt-1">
                                <div class="col">
                                    <label for="" class="form-label">Codename <span style="color: red;">*</span></label>
                                    <input type="text" name="itemEditCode" id="itemEditCode" class="form-control" maxlength="20" required>
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Location <span style="color: red;">*</span></label>
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
                                    <label for="itemEditCat" class="form-label">Category <span style="color: red;">*</span></label>
                                    <select class="form-select" name="itemEditCat" id="itemECat" onchange="toggleEAirconDiv();filterETypes();">
                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                            <option value="${cat.itemCID}" selected>${cat.itemCat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemEditType" class="form-label">Type <span style="color: red;">*</span></label>
                                    <select class="form-select" name="itemEditType" id="itemEType">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <c:if test="${type.itemArchive == 1}">
                                            <option value="${type.itemTID}" data-item-cid="${type.itemCID}" selected>${type.itemType}</option>
                                            </c:if>
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
                                    <label for="itemEditFloor" class="form-label">Floor <span style="color: red;">*</span></label>
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
                                    <label for="" class="form-label">Date Installed <span style="color: red;">*</span></label>
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
                            </div>
                            <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-danger" data-dismiss="modal">Cancel</button>
                                    <input type="submit" value="Save" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif !important;">
                            </div>
                        </form>
            
            </div>
        </div>
    </div>
    <!--end of edit equipment modal-->
    
    <!--info equipment modal-->
    <div class="modal fade" id="infoEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentInfo" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" style="font-family: 'NeueHaasMedium', sans-serif;">Equipment Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Basic Information</h6>
                        <div class="row mt-1">
                            <div class="col">
                                <label class="form-label fw-bold">Equipment ID</label>
                                <h5 id="itemInfoID" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Equipment Codename</label>
                                <h5 id="itemInfoCode" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Location</label>
                                <h5 name="itemInfoLoc" id="itemInfoLoc" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Category & Type</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Category</label>
                                <h5 name="itemInfoCat" id="itemInfoCat" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Type</label>
                                <h5 name="itemInfoType" id="itemInfoType" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Brand</label>
                                <h5 name="itemInfoBrand" id="itemInfoBrand" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-2 onlyInfoAir mb-4">
                        <div class="col-12">
                            <h6 class="mb-3 border-bottom pb-2">Air Conditioner Type</h6>
                            <div class="d-flex justify-content-start gap-3">
                                <div class="form-check-display">
                                    <label class="form-label fw-bold">ACCU:</label>
                                    <h5 name="itemInfoACCU" id="itemInfoACCU" class="text-dark d-inline ms-2"></h5>
                                </div>
                                <div class="form-check-display">
                                    <label class="form-label fw-bold">FCU:</label>
                                    <h5 name="itemInfoFCU" id="itemInfoFCU" class="text-dark d-inline ms-2"></h5>
                                </div>
                                <div class="form-check-display">
                                    <label class="form-label fw-bold">INVERTER:</label>
                                    <h5 name="itemInfoACINVERTER" id="itemInfoACINVERTER" class="text-dark d-inline ms-2"></h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Capacity & Specifications</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Capacity</label>
                                <h5 name="itemInfoCapacity" id="itemInfoCapacity" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Unit of Measure</label>
                                <h5 name="itemInfoUnitMeasure" id="itemInfoUnitMeasure" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">PC Code</label>
                                <h5 name="itemInfoPCC" id="itemInfoPCC" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Electrical Specifications</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Electrical V</label>
                                <h5 name="itemInfoElecV" id="itemInfoElecV" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Electrical PH</label>
                                <h5 name="itemInfoElecPH" id="itemInfoElecPH" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Electrical HZ</label>
                                <h5 name="itemInfoElecHZ" id="itemInfoElecHZ" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Location Details</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Floor</label>
                                <h5 name="itemInfoFloor" id="itemInfoFloor" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Room</label>
                                <h5 name="itemInfoRoom" id="itemInfoRoom" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Installation & Dates</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Date Installed</label>
                                <h5 name="itemInfoInstalled" id="itemInfoInstalled" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Expiration Date</label>
                                <h5 name="itemInfoExpiration" id="itemInfoExpiration" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="mb-3 border-bottom pb-2">Additional Information</h6>
                        <div class="row mt-2">
                            <div class="col">
                                <label class="form-label fw-bold">Location Text</label>
                                <h5 name="itemInfoLocText" id="itemInfoLocText" class="text-dark"></h5>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold">Remarks</label>
                                <h5 name="itemInfoRemarks" id="itemInfoRemarks" class="text-dark"></h5>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    
    <!--equipment maintenance history modal-->
    <div class="modal fade" tabindex="-1" id="historyEquipment">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Maintenance History</h5>
            <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body table-responsive">
            <table id="historyTable" class="table">
                <thead>
                    <tr>
                        <th>Assign ID</th>
                        <th>Maintenance Type</th>
                        <th>Assigned User</th>
                        <th>Date of Maintenance</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Data will be inserted here dynamically -->
                </tbody>
            </table>
          </div>
          <div class="modal-footer">
            
          </div>
        </div>
      </div>
    </div>

    
    <!--archive equipment modal-->
<!--<div class="modal fade" id="archiveEquipment" tabindex="-1" role="dialog" aria-labelledby="archiveEquipment" aria-hidden="true">
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
</div>-->
    <!--end of archive equipment modal-->
    
    <!--Archive Maintenance Modal but real-->
<form id="archiveMaintenanceForm" action="itemcontroller" method="post" style="display: none;">
    <input type="hidden" name="itemLID" id="itemLID" class="form-control" value="${locID}">
    <input type="hidden" name="itemFlr" id="itemFlr" class="form-control" value="${floorName}">
    <input type="hidden" name="itemArchiveID" id="itemArchiveID" class="form-control">
</form>

    
    <jsp:include page="quotations.jsp" />
    
    <c:if test="${locMatchFound == false || flrMatchFound == false}">
        <meta http-equiv="refresh" content="0; URL=./errorPage.jsp" /> 
    </c:if>
    
    <c:choose>
        <c:when test="${sessionScope.role == 'Admin'}">
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Initialize DataTable for #allItemsTable
//                    let allItemsTable = new DataTable('#allItemsTable', {
//                        paging: true,
//                        searching: true,
//                        ordering: true,
//                        info: true,
//                        stateSave: true,
//                        scrollX: true,
//                        columnDefs: [
//                            { targets: "_all", className: "dt-center" }, // Center-align all columns
//                            { targets: 6, orderable: false },
//                            { targets: 7, orderable: false }, 
//                            { targets: 8, orderable: false } 
//                        ]
//                    });
    
                    // Initialize DataTable for #itemsTable
//                    let itemsTable = new DataTable('#itemsTable', {
//                        paging: true,
//                        searching: true,
//                        ordering: true,
//                        info: true,
//                        stateSave: true,
//                        scrollX: true,
//                        columnDefs: [
//                            { targets: "_all", className: "dt-center" }, // Center-align all columns
//                            { targets: 7, orderable: false },
//                            { targets: 8, orderable: false },
//                            { targets: 9, orderable: false }
//                        ]
//                    });
                });
            </script>
        </c:when>
        <c:otherwise>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Initialize DataTable for #allItemsTable
//                    let allItemsTable = new DataTable('#allItemsTable', {
//                        paging: true,
//                        searching: true,
//                        ordering: true,
//                        info: true,
//                        stateSave: true,
//                        scrollX: true,
//                        columnDefs: [
//                            { targets: "_all", className: "dt-center" }, // Center-align all columns
//                            { targets: 6, orderable: false }, 
//                            { targets: 7, orderable: false } 
//                        ]
//                    });
    
                    // Initialize DataTable for #itemsTable
//                    let itemsTable = new DataTable('#itemsTable', {
//                        paging: true,
//                        searching: true,
//                        ordering: true,
//                        info: true,
//                        stateSave: true,
//                        scrollX: true,
//                        columnDefs: [
//                            { targets: "_all", className: "dt-center" }, // Center-align all columns
//                            { targets: 7, orderable: false },
//                            { targets: 8, orderable: false }
//                        ]
//                    });
                });
            </script>
        </c:otherwise>
    </c:choose>
<script>
$(document).ready(function(){
    $('#itemsTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: 'mainbdatacontroller',
            type: 'POST',
            data: function (d) {
                // Pass locID and floorName from JSP to servlet
                d.locID = "${locID}";
                d.floorName = "${floorName}";
                d.userRole = "${sessionScope.role}";
                d.userEmail = "${sessionScope.email}";
                d.sessionName = "${sessionScope.name}";
            }
        },
        columns: [
            { data: 'itemInfo', orderable: false, searchable: false },
            { data: 'itemID' },
            { data: 'itemName' },
            { data: 'itemRoom' },
            { data: 'category' },
            { data: 'type' },
            { data: 'itemBrand' },
            { data: 'dateInstalled' },
//            { data: 'quotation', orderable: false, searchable: false },
            { data: 'capacity' },
            { data: 'status', orderable: false },
            // Actions column only if Admin
            { data: 'actions', orderable: false, searchable: false }
            
        ]
    });
    $('#allItemsTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: 'mainadatacontroller',
            type: 'POST',
            data: function (d) {
                // Pass locID and floorName from JSP to servlet
                d.locID = "${locID}";
                d.floorName = "${floorName}";
                d.userRole = "${sessionScope.role}";
                d.userEmail = "${sessionScope.email}";
                d.sessionName = "${sessionScope.name}";
            }
        },
        columns: [
            { data: 'itemInfo', orderable: false, searchable: false },
            { data: 'itemID' },
            { data: 'itemName' },
            { data: 'itemFloor' },
            { data: 'itemRoom' },
            { data: 'category' },
            { data: 'type' },
            { data: 'itemBrand' },
            { data: 'dateInstalled' },
            { data: 'capacity' },
            { data: 'status', orderable: false },
            // Actions column only if Admin
            { data: 'actions', orderable: false, searchable: false }
        ]
    });
});
</script>
    
    <script>
    const locID1 = "<%= locID %>"; // Embed locID from JSP
    const floorName1 = "<%= floorName %>";
    document.addEventListener("DOMContentLoaded", function () {
        let selectedDropdown = null;
        let previousValue = null;
    
        const allItemsTable = document.getElementById("allItemsTable");
        const itemsTable = document.getElementById("itemsTable");
    
        function handleDropdownChange(event) {
            const target = event.target;
            if (target && target.classList.contains("statusDropdown")) {
                selectedDropdown = target;
                previousValue = target.getAttribute("data-prev-value") || target.value;
                const newValue = target.value;
    
                if (previousValue === "3" && newValue === "1") {
                    showSpecialConfirm();
                } else {
                    showRegularConfirm();
                }
            }
        }
    
        function showRegularConfirm() {
            Swal.fire({
                title: 'Confirm Status Change',
                text: 'Are you sure you want to change the status?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#ffffff',
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                reverseButtons: true,
                customClass: {
                 cancelButton: 'btn-cancel-outline'
                }
            }).then((result) => {
                if (result.isConfirmed && selectedDropdown) {
                    const form = selectedDropdown.closest("form");
                    const itemMaintTypeInput = form.querySelector("input[name='itemMaintType']");
                    if (itemMaintTypeInput) {
                        itemMaintTypeInput.disabled = true;
                    }
                    form.submit();
                } else {
                    location.reload();
                }
            });
        }
    
        function showSpecialConfirm() {
            Swal.fire({
                title: 'Reset to Operational?',
                text: 'Are you sure you want to reset the status back to "Operational"?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#ffffff',
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                reverseButtons: true,
                customClass: {
                 cancelButton: 'btn-cancel-outline'
                }
            }).then((result) => {
                if (result.isConfirmed && selectedDropdown) {
                    const form = selectedDropdown.closest("form");
                    const itemMaintTypeInput = form.querySelector("input[name='itemMaintType']");
                    const modalItemMaintTypeValue = "3";
                    if (itemMaintTypeInput) {
                        itemMaintTypeInput.value = modalItemMaintTypeValue;
                        itemMaintTypeInput.disabled = false;
                    }
                    form.submit();
                } else {
                    location.reload();
                }
            });
        }
    
        if (allItemsTable) {
            allItemsTable.addEventListener("change", handleDropdownChange);
        }
        if (itemsTable) {
            itemsTable.addEventListener("change", handleDropdownChange);
        }
    
        document.querySelectorAll(".statusDropdown").forEach(dropdown => {
            dropdown.setAttribute("data-prev-value", dropdown.value);
        });
    });



    
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
                roomName: '${fn:replace(fn:replace(room.itemRoom != null ? room.itemRoom : "Non-Room Equipment", "'", "\\'"), '"', '\\"')}'
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
        
        if (itemPCCode && itemPCCode !== "0") {
            document.querySelector('input[name="itemEditPCC"]').value = itemPCCode;
        } else {
            document.querySelector('input[name="itemEditPCC"]').value = "";
        }
        // Capacity (number)
        if (itemCapacity && itemCapacity !== "0") {
            document.querySelector('input[name="itemECapacity"]').value = itemCapacity;
        } else {
            document.querySelector('input[name="itemECapacity"]').value = "";
        }
        // Unit Measure (string)
        if (itemMeasure && itemMeasure.trim() !== "" && itemMeasure !== "null") {
            document.querySelector('input[name="itemEUnitMeasure"]').value = itemMeasure;
        } else {
            document.querySelector('input[name="itemEUnitMeasure"]').value = "";
        }
        // Electric Voltage (number)
        if (itemEV && itemEV !== "0") {
            document.querySelector('input[name="itemEditElecV"]').value = itemEV;
        } else {
            document.querySelector('input[name="itemEditElecV"]').value = "";
        }
        // Electric Phase (number)
        if (itemEPH && itemEPH !== "0") {
            document.querySelector('input[name="itemEditElecPH"]').value = itemEPH;
        } else {
            document.querySelector('input[name="itemEditElecPH"]').value = "";
        }
        // Electric Frequency (number)
        if (itemEHZ && itemEHZ !== "0") {
            document.querySelector('input[name="itemEditElecHZ"]').value = itemEHZ;
        } else {
            document.querySelector('input[name="itemEditElecHZ"]').value = "";
        }
        
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
    
        function populateInfoModal(button) {
        var itemName = button.getAttribute('data-iteminame');
        var itemLName = button.getAttribute('data-itemilname');
        var itemID = button.getAttribute('data-itemiid');
        var itemLID = parseInt(${locID});
        var itemBrand = button.getAttribute('data-itemibrand');
        var itemFloor = button.getAttribute('data-itemifloor');
        var itemRoom = button.getAttribute('data-itemiroom');
        var itemDateInst = button.getAttribute('data-dateiinst');
        var itemExpiry = button.getAttribute('data-itemiexpiry');
        var itemCat = button.getAttribute('data-itemicat');
        var itemType = button.getAttribute('data-itemitype');
        var itemLocText = button.getAttribute('data-itemiloctext');
        var itemRemarks = button.getAttribute('data-itemiremarks');
        
        var itemPCCode = button.getAttribute('data-itemipcc');
        var itemACaccu = button.getAttribute('data-iaccu');
        var itemACfcu = button.getAttribute('data-ifcu');
        var itemACinverter = button.getAttribute('data-iinverter');
        var itemCapacity = button.getAttribute('data-itemicapacity');
        var itemMeasure = button.getAttribute('data-itemimeasure');
        var itemEV = button.getAttribute('data-itemiev');
        var itemEPH = button.getAttribute('data-itemieph');
        var itemEHZ = button.getAttribute('data-itemiehz');
        
        console.log("itemPCCode:", itemPCCode);
        console.log("itemACaccu:", itemACaccu);
        console.log("itemACfcu:", itemACfcu);
        console.log("itemACinverter:", itemACinverter);
        console.log("itemCapacity:", itemCapacity);
        console.log("itemMeasure:", itemMeasure);
        console.log("itemEV:", itemEV);
        console.log("itemEPH:", itemEPH);
        console.log("itemEHZ:", itemEHZ);
        console.log("Expiration Date:", itemExpiry);
        console.log("Room:", itemRoom);
        console.log("Remarks:", itemRemarks);
        
        document.getElementById('itemInfoCode').textContent = itemName;
        document.getElementById('itemInfoID').textContent = itemID;
        document.getElementById('itemInfoLoc').textContent = itemLName;
        document.getElementById('itemInfoBrand').textContent = itemBrand;
        document.getElementById('itemInfoFloor').textContent = itemFloor;
        document.getElementById('itemInfoRoom').textContent = itemRoom;
        document.getElementById('itemInfoInstalled').textContent = itemDateInst;
        document.getElementById('itemInfoExpiration').textContent = itemExpiry && itemExpiry !== "null" && itemExpiry.trim()
        !== "" ? itemExpiry : "N/A";
        document.getElementById('itemInfoCat').textContent = itemCat;
        document.getElementById('itemInfoType').textContent = itemType;
        document.getElementById('itemInfoLocText').textContent = itemLocText && itemLocText.trim() !== "" ? itemLocText : "N/A";
        document.getElementById('itemInfoRemarks').textContent = itemRemarks && itemRemarks.trim() !== "" ? itemRemarks : "N/A";
        
        document.getElementById('itemInfoPCC').textContent = itemPCCode && itemPCCode !== "0" ? itemPCCode : "N/A";
        document.getElementById('itemInfoCapacity').textContent = itemCapacity && itemCapacity !== "0" ? itemCapacity : "N/A";
        document.getElementById('itemInfoUnitMeasure').textContent = itemMeasure && itemMeasure.trim() !== "null" && itemMeasure.trim()
        !== "" ? itemMeasure : "N/A";
        document.getElementById('itemInfoElecV').textContent = itemEV && itemEV !== "0" ? itemEV : "N/A";
        document.getElementById('itemInfoElecPH').textContent = itemEPH && itemEPH !== "0" ? itemEPH : "N/A";
        document.getElementById('itemInfoElecHZ').textContent = itemEHZ && itemEHZ !== "0" ? itemEHZ : "N/A";
        
        document.getElementById('itemInfoACCU').textContent = itemACaccu;
        document.getElementById('itemInfoFCU').textContent = itemACfcu;
        document.getElementById('itemInfoACINVERTER').textContent = itemACinverter;
        
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
      case 'add':
        toastMessage = 'The equipment was added successfully.';
        break;
      case 'edit':
        toastMessage = 'The equipment was updated successfully.';
        break;
      case 'archive':
        toastMessage = 'The equipment was archived successfully.';
        break;
      case 'modify_status':
        toastMessage = 'The equipment status was modified successfully.';
        break;
      case '3to1':
        toastMessage = 'The equipment is now operational.';
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
  } else if (status === 'error_assign') {
    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'error',
      title: 'Equipment is not assigned to user.',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    });
  } else if (status === 'error_2to3') {
    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'error',
      title: 'Maintenance Required to In Maintenance can only be changed in the Maintenance Page.',
      showConfirmButton: false,
      timer: 5000,
      timerProgressBar: true
    });
  } else if (status === 'error_4to3') {
    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'error',
      title: 'Needs Replacement to In Maintenance can only be changed in the Maintenance Page.',
      showConfirmButton: false,
      timer: 5000,
      timerProgressBar: true
    });
  } else if (status === 'error_dup') {
    Swal.fire({
      toast: true,
      position: 'top-end',
      icon: 'error',
      title: 'That equipment name is already taken. Try a different name.',
      showConfirmButton: false,
      timer: 5000,
      timerProgressBar: true
    });
  }
  
  $(document).on('click', '.archive-maintenance-btn', function(e) {
    e.preventDefault();
    const maintArchiveID = $(this).data('itemaid');

    Swal.fire({
        title: 'Are you sure?',
        text: "Do you want to archive this equipment?",
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
            $('#itemArchiveID').val(maintArchiveID);
            $('#archiveMaintenanceForm').submit();
        }
    });
});
</script>
<script>
const LID = "<%= locID %>"; // Embed JSP variable
const flrN = "<%= floorName %>";

$(document).ready(function() {
    $(document).on('click', '.history-btn', function() {
        var itemHID = $(this).data('itemhid');
        let historyTable = $('#historyTable tbody'); 
        historyTable.empty();
        historyTable.append(`
            <tr>
                <td colspan="4" class="text-center text-muted">Loading...</td>
            </tr>
        `);
        $('#historyEquipment').modal('show'); 
        
        $.ajax({
            url: `buildingDashboard?locID=${LID}/manage?floor=${flrN}`,
            type: 'GET',
            data: { itemHID: itemHID },
            dataType: "json",
            success: function(response) {
                historyTable.empty();

                if (Array.isArray(response) && response.length > 0) {
                    response.forEach(entry => {
                        historyTable.append(`
                        <tr>
                            <td>`+entry.assignID+`</td>
                            <td>`+entry.maintTID+`</td>
                            <td>`+entry.userName+`</td> 
                            <td>`+entry.dateOfMaint+`</td>
                        </tr>
                        `);
                    });
                } else {
                    historyTable.append(`
                        <tr>
                            <td colspan="4" class="text-center text-muted">
                                No maintenance history data.
                            </td>
                        </tr>
                    `);
                }
            },
            error: function() {
                historyTable.empty();
                historyTable.append(`
                    <tr>
                        <td colspan="4" class="text-center text-danger">
                            Failed to load history data.
                        </td>
                    </tr>
                `);
            }
        });
    });
});
</script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
