<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance - Facilitain</title>
    
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.js"></script>
  
    <!-- Bootstrap 5 CSS and JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <!-- DataTables CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css">
    <style>
    

   
        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 15px;
        }
        .dataTables_wrapper .dataTables_length {
            margin-bottom: 15px;
        }
        table.dataTable tbody td {
            vertical-align: middle;
        }
        .equal-height {
            display: flex;
            flex-direction: column;
        }
        .equal-height .card {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .equal-height .card-body {
            flex: 1;
            overflow-y: auto;
        }
        /* Changed class name to avoid conflict with sidebar */
        .dashboard-maintenance-container {
            display: flex;
            min-height: 500px;
        }
        #maintenanceTable_wrapper .row:first-child {
            margin-bottom: 10px;
        }
        #maintenanceTable_wrapper .row:last-child {
            margin-top: 10px;
        }
        #maintenanceTable tbody tr {
            cursor: pointer;
        }
        #maintenanceTable tbody tr:hover {
            background-color: rgba(0,0,0,0.05);
        }
        #maintenanceTable tbody tr.selected {
            background-color: rgba(0,0,0,0.1);
        }
        
         .character-counter {
            font-size: 0.875rem;
            color: #6c757d;
            text-align: right;
            margin-top: 5px;
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .file-upload-container small {
            font-family: 'NeueHaasLight', sans-serif !important;
        } 
        
        .character-counter.warning {
            color: #ffc107;
        }
        .character-counter.danger {
            color: #dc3545;
        }
        .form-control.invalid {
            border-color: #dc3545;
        }

        
          body, h1, h2, h3, h4,h5, h6, th,label,.custom-label {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
 input, textarea, td, tr, p, select, option,id {
    font-family: 'NeueHaasLight', sans-serif !important;
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
             .responsive-padding-top {
                  padding-top: 100px;
                }
                
                @media (max-width: 576px) {
                  .responsive-padding-top {
                    padding-top: 80px; /* or whatever smaller value you want */
                  }
                }
                

#loadingScreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(1px);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
    font-family: 'NeueHaasMedium', sans-serif;
}

.loading-content {
    text-align: center;
    padding: 2rem;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(252, 204, 76, 0.2);
}

.loading-spinner {
    width: 40px;
    height: 40px;
    border: 3px solid #f3f3f3;
    border-top: 3px solid #fccc4c;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto 15px auto;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.loading-text {
    font-size: 1.1rem;
    color: #333;
    margin: 0;
    font-family: 'NeueHaasMedium', sans-serif;
}

@media (max-width: 576px) {
    .loading-content {
        margin: 1rem;
        padding: 1.5rem;
    }
    
    .loading-text {
        font-size: 1rem;
    }
    
    .loading-spinner {
        width: 35px;
        height: 35px;
    }
}

.modal-backdrop {
    background-color: rgba(128, 128, 128, 0.3) !important; 
}
    </style>
</head>


                <c:set var="equipmentListString" value="" />
                <c:forEach items="${FMO_ITEMS_LIST}" var="item" varStatus="status">
                    <c:if test="${item.itemMaintStat != 1}">
                        <c:set var="itemAssigned" value="false" />
                        
                        <c:forEach items="${FMO_MAINT_ASSIGN}" var="maintass">
                            <c:if test="${maintass.isCompleted == 0}">
                            <c:if test="${maintass.itemID == item.itemID}">
                                <c:set var="itemAssigned" value="true" />
                            </c:if>
                            </c:if>
                        </c:forEach>
                
                        <c:if test="${itemAssigned == false}">
                            <c:set var="equipmentListString" value="${equipmentListString}${item.itemName}${status.last ? '' : ', '}" />
                        </c:if>
                    </c:if>
                </c:forEach>
                
<body>

<div id="loadingScreen">
    <div class="loading-content">
        <div class="loading-spinner"></div>
        <p class="loading-text">Fetching data</p>
    </div>
</div>

 <c:set var="page" value="pending" scope="request"/>
    
<jsp:include page="navbar.jsp"/>
<jsp:include page="sidebar.jsp"/>

<div class="main-content">
<div class="container-fluid">
    <div class="row min-vh-100">
   

        <div class="col-md-10 responsive-padding-top ">
            <div class="container-fluid">
               <div class="d-flex justify-content-between align-items-center flex-wrap mb-4 ">
                     
                    <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Maintenance</h1>
                 
                    
                        <%--<c:choose>
                            <c:when test="${sessionScope.role == 'Admin' || sessionScope.role == 'Maintenance'}">--%>
                                <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" data-bs-toggle="modal" data-bs-target="#addMaintenanceModal" 
                                style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
                                    <img src="resources/images/icons/schedule.svg" alt="schedule"  width="25" height="25"> 
                                   <span class="d-none d-lg-inline ps-2"> Schedule Maintenance </span>
                                </button>
                            <%--</c:when>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>--%>
                   
                </div>

               
                <div class="row dashboard-maintenance-container">
                    <!-- Maintenance List Panel -->
                    <div class="col-lg-6 mb-4 equal-height">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">List of Equipment</h5>
                            </div>
                            <div class="card-body">
                                <table id="maintenanceTable" class="table table-striped table-hover" style="width:100%">
                                    <thead class="table-dark">
                                     <tr>
                                    <th>Equipment Name</th>
                                    <th>Status</th>
                                    <th>Date Notified</th>
                                    <th style="display: none;">Equipment Details</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                        <!-- Static data for demonstration -->
                                        <%--<c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                        <c:if test="${type.itemCID == 1}">
                                        
                                            <td >${type.itemType}</td>
                                        </c:if>
                                    </c:forEach>--%>
                                    <%--<c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                                        <c:if test="${item.itemMaintStat != 1}">
                                           --%><!--loop to get cat and type--><%--
                                            <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                            <c:if test="${type.itemTID == item.itemTID}">
                                                <c:set var="itemType" value="${type.itemType}" />
                                                <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                                    <c:if test="${cat.itemCID == type.itemCID}">
                                                        <c:set var="itemCat" value="${cat.itemCat}" />
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                            </c:forEach>
                                            
                                            --%><!--loop to get loc name--><%--
                                            <c:forEach items="${locations}" var="loc" >
                                            <c:if test="${loc.itemLocId == item.itemLID}">
                                                <c:set var="itemLoc" value="${loc.locName}" />
                                            </c:if>
                                            </c:forEach>
                                            --%><!--loop to get stat name--><%--
                                            <c:forEach items="${FMO_MAINTSTAT_LIST}" var="status">
                                                <c:if test="${status.itemMaintStat == item.itemMaintStat}">
                                                    <c:set var="statName" value="${status.maintStatName}" />
                                                </c:if>
                                            </c:forEach>
                                            
                                            <c:set var="canUpdate" value="false" />
                                            <c:forEach var="assign" items="${FMO_MAINT_ASSIGN}">
                                                <c:if test="${assign.isCompleted == 0}">
                                                <c:if test="${assign.itemID == item.itemID}">
                                                    <c:forEach var="user" items="${FMO_USERS}">
                                                        <c:if test="${user.name == sessionScope.name && user.userId == assign.userID}">
                                                            <c:set var="canUpdate" value="true" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                </c:if>
                                            </c:forEach>
                                        <tr data-id="${item.itemID}"
                                        data-equipment="${itemCat} - ${itemType}" data-locid="${item.itemLID}"
                                        data-status="${item.itemMaintStat}" data-serial="${item.itemName}" data-brand="${item.itemBrand}"
                                        data-location="${itemLoc}, ${item.itemFloor}" data-statname="${statName}" 
                                        data-canupdate="${canUpdate}">
                                            <td>${item.itemName}</td>
                                            <td>
                                            <c:forEach items="${FMO_MAINTSTAT_LIST}" var="status">
                                                <c:if test="${status.itemMaintStat == item.itemMaintStat}">
                                                    ${status.maintStatName}
                                                </c:if>
                                            </c:forEach>
                                            </td>
                                            <td>${item.plannedMaintDate}</td>
                                            <td style="display: none;">${itemCat} ${itemType} ${item.itemBrand} ${itemLoc} ${item.itemFloor}</td>
                                        </tr>
                                        </c:if>
                                    </c:forEach>--%>
                                            <!--static table data:-->
                                        <!--<tr data-id="1" data-equipment="Fire Extinguisher" data-status="In Progress" data-serial="09222222" data-brand="XYZ Fire Safety" data-location="Building A, Floor 1">
                                            <td>Fire Extinguisher</td>
                                            <td>In Progress</td>
                                            <td>02/03/2025</td>
                                        </tr>-->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Maintain Details Panel -->
                    <div class="col-lg-6 mb-4 equal-height">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">Details</h5>
                            </div>
                            <div class="card-body">
                                <!-- Static equipment details -->
                                <div id="equipmentDetails">
                                    <div class="mb-3">
                                        <label class="form-label custom-label" style=" font-family: 'NeueHaasMedium', sans-serif;">Equipment Type</label>
                                        <div id="detailEquipment" style=" font-family: 'NeueHaasLight', sans-serif;">Fire Extinguisher</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label custom-label">Status</label>
                                        <div id="detailStatus" style=" font-family: 'NeueHaasLight', sans-serif;">In Progress</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label custom-label">Codename</label>
                                        <div id="detailSerial" style=" font-family: 'NeueHaasLight', sans-serif;">09222222</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label custom-label">Brand Name</label>
                                        <div id="detailBrand" style=" font-family: 'NeueHaasLight', sans-serif;">XYZ Fire Safety</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label custom-label">Location</label>
                                        <div id="detailLocation" style=" font-family: 'NeueHaasLight', sans-serif;">Building A, Floor 1</div>
                                    </div>
                                    <div class="d-grid gap-2 mt-4">
                                        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                        id="updateStatusBtn" style="display: none;">
                                            Update Status
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row dashboard-maintenance-container">
                    <div class="col-lg mb-4 equal-height">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">Assigned Maintenance</h5>
                            </div>
                            <div class="card-body">
                                <table id="scheduledMaintTable" class="table table-striped table-hover" style="width:100%">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Equipment Name</th>
                                            <th>Maintenance Type</th>
                                            <th>Assigned To</th>
                                            <th>Date of Maintenance</th>
                                            <th> </th>
                                            <th>Actions</th>
                                            <th style="display: none;">Equipment Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%--<c:forEach items="${FMO_MAINT_ASSIGN}" var="maintass" >
                                        <c:if test="${maintass.isCompleted == 0}">
                                        <c:set var="maintName" value="" />
                                        <c:set var="maintBLID" value="" />
                                        <c:set var="maintBStat" value="" />
                                        <c:set var="maintEquipmentDetails" value="" />
                                        <tr>
                                            <td>
                                                <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                                                <c:if test="${item.itemID == maintass.itemID}">
                                                    ${item.itemName}
                                                    <c:set var="maintName" value="${item.itemName}" />
                                                    <c:set var="maintBLID" value="${item.itemLID}" />
                                                    <c:set var="maintBStat" value="${item.itemMaintStat}" />
                                                    
                                                    --%><!-- Get equipment details for this item --><%--
                                                    <c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                                    <c:if test="${type.itemTID == item.itemTID}">
                                                        <c:set var="maintItemType" value="${type.itemType}" />
                                                        <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat" >
                                                            <c:if test="${cat.itemCID == type.itemCID}">
                                                                <c:set var="maintItemCat" value="${cat.itemCat}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    </c:forEach>
                                                    
                                                    <c:forEach items="${locations}" var="loc" >
                                                    <c:if test="${loc.itemLocId == item.itemLID}">
                                                        <c:set var="maintItemLoc" value="${loc.locName}" />
                                                    </c:if>
                                                    </c:forEach>
                                                    
                                                    <c:set var="maintEquipmentDetails" value="${maintItemCat} ${maintItemType} ${item.itemBrand} ${maintItemLoc} ${item.itemFloor}" />
                                                </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:forEach items="${FMO_MAINTTYPE_LIST}" var="mtype" >
                                                <c:if test="${mtype.itemTypeId == maintass.maintTID}">
                                                    ${mtype.itemTypeName}
                                                </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:forEach items="${FMO_USERS}" var="user" >
                                                <c:if test="${user.userId == maintass.userID}">
                                                    ${user.name}
                                                </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>${maintass.dateOfMaint}</td>
                                            <td>
                                                <c:forEach items="${FMO_USERS}" var="user" >
                                                <c:if test="${user.userId == maintass.userID}">
                                                    <c:if test="${sessionScope.email == user.email}">
                                                        <button type="button" class="btn btn-warning update-bstatus-btn"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#updateStatusModal"
                                                        data-itembid="${maintass.itemID}"
                                                        data-itemblid="${maintBLID}"
                                                        data-itembstatus="${maintBStat}">Update Status</button>
                                                    </c:if>
                                                </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                              <div class="dropdown">
                                                <button class="btn btn-link p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                  <img src="resources/images/kebabMenu.svg" alt="Actions" width="20" height="20">
                                                </button>
                                                <ul class="dropdown-menu">
                                                  --%><!-- Edit Option --><%--
                                                  <li>
                                                    <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#editMaintenanceModal"
                                                    data-mainteid="${maintass.assignID}"
                                                    data-maintename="${maintName}"
                                                    data-itemeid="${maintass.itemID}"
                                                    data-usereid="${maintass.userID}"
                                                    data-mainttypeeid="${maintass.maintTID}"
                                                    data-datemaint="${maintass.dateOfMaint}"
                                                    onclick="populateEditMaintenance(this)"
                                                    >Edit</a>
                                                  </li>
                                                  --%><!-- Delete Option --><%--
                                                  <li>
                                                    <a class="dropdown-item delete-maintenance-btn" href="#" data-bs-toggle="modal"
                                                    data-maintdid="${maintass.assignID}">Delete</a>
                                                  </li>
                                                </ul>
                                              </div>
                                            </td>
                                            <td style="display: none;">${maintEquipmentDetails}</td>
                                        </tr>
                                        </c:if>
                                        </c:forEach>--%>
                                        <!--<tr data-id="3" data-equipment="Elevator Motor" data-status="Needs Maintenance" data-serial="ELV-33321" 
                                            data-brand="LiftTech" data-location="Building C, Floor 1">
                                            <td>Elevator Motor</td>
                                            <td>Needs Maintenance</td>
                                            <td>In Progress</td>
                                            <td>06/07/2025</td>
                                        </tr>-->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Add Maintenance Modal -->
<div class="modal fade" id="addMaintenanceModal" tabindex="-1" aria-labelledby="addMaintenanceModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="addmaintenancecontroller" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addMaintenanceModalLabel">Schedule Maintenance</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <div>
                            <label for="equipmentName" class="form-label">Equipment Name <span style="color: red;">*</span></label>
                        </div>
                        <div class="w-100">
                            <input class="form-control w-100" id="equipmentName" 
                                   name="equipmentName" maxlength="24" required style="width: 100%;">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="maintenanceType" class="form-label">Maintenance Type <span style="color: red;">*</span></label>
                        <select class="form-select" id="maintenanceType" name="maintenanceType" required>
                            <option value="" selected disabled>Select Type</option>
                            <c:forEach items="${FMO_MAINTTYPE_LIST}" var="mtype" >
                                <option value="${mtype.itemTypeId}">${mtype.itemTypeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="assignedTo" class="form-label">Assign To <span style="color: red;">*</span></label>
                        <select class="form-select" id="assignedTo" name="assignedTo" required>
                            <option value="" selected disabled>Select User</option>
                            <!-- Show current user first if they're not a Respondent -->
                            <c:forEach items="${FMO_USERS}" var="user">
                                <c:if test="${sessionScope.email == user.email && user.role != 'Respondent'}">
                                    <option value="${user.userId}">${user.name}</option>
                                </c:if>
                            </c:forEach>
                            <!-- Show other users who are not Respondents -->
                            <c:forEach items="${FMO_USERS}" var="user">
                                <c:if test="${sessionScope.email != user.email && user.role != 'Respondent'}">
                                    <option value="${user.userId}">${user.name}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="" class="form-label">Date of Maintenance <span style="color: red;">*</span></label>
                        <input type="date" name="dateMaint" id="dateMaint" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">Add</button>
                            </div>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- Edit Maintenance Modal -->
<div class="modal fade" id="editMaintenanceModal" tabindex="-1" aria-labelledby="editMaintenanceModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="editmaintenancecontroller" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editMaintenanceModalLabel">Edit Maintenance Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="maintID" id="maintID">
                    
                   <div class="mb-3">
    <label for="equipmentEName" class="form-label d-block">Equipment Name</label>
    <input class="form-control" id="equipmentEName" 
           name="equipmentENameDisplay" maxlength="24" 
           style="width: 100%; background-color: #e9ecef; cursor: not-allowed;" 
           readonly>
</div>
                    
                    <div class="mb-3">
                        <label for="maintenanceEType" class="form-label">Maintenance Type <span style="color: red;">*</span></label>
                        <select class="form-select" id="maintenanceEType" name="maintenanceEType" required>
                            <c:forEach items="${FMO_MAINTTYPE_LIST}" var="mtype">
                                <option value="${mtype.itemTypeId}">${mtype.itemTypeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="assignedETo" class="form-label">Assign To <span style="color: red;">*</span></label>
                        <select class="form-select" id="assignedETo" name="assignedETo" required>
                            <!-- Show current user first if they're not a Respondent -->
                            <c:forEach items="${FMO_USERS}" var="user">
                                <c:if test="${sessionScope.email == user.email && user.role != 'Respondent'}">
                                    <option value="${user.userId}">${user.name}</option>
                                </c:if>
                            </c:forEach>
                            <c:forEach items="${FMO_USERS}" var="user">
                                <c:if test="${sessionScope.email != user.email && user.role != 'Respondent'}">
                                    <option value="${user.userId}">${user.name}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label for="dateEMaint" class="form-label">Date of Maintenance <span style="color: red;">*</span></label>
                        <input type="date" name="dateEMaint" id="dateEMaint" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button"  class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit"  class="btn btn-success" style="font-family: 'NeueHaasMedium', sans-serif;">Save Changes</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!--Delete Maintenance Modal-->
<form id="deleteMaintenanceForm" action="editmaintenancecontroller" method="post" style="display: none;">
    <input type="hidden" name="deleteMaintID" id="deleteMaintID"/>
</form>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="updatestatuscontroller" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateStatusModalLabel">Update Maintenance Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="updateEquipmentId" name="equipmentId" value="1"/>
                    <input type="hidden" id="updateEquipmentStatus" name="equipmentStatus" value="1"/>
                    <input type="hidden" id="updateEquipmentLID" name="equipmentLID" value="1"/>
                    <div class="d-flex align-items-center mb-3">
                    <!-- Disabled Dropdown -->
                    <div class="me-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status" disabled required>
                            <option value="" disabled>Select Status</option>
                            <c:forEach items="${FMO_MAINTSTAT_LIST}" var="status">
                                <option value="${status.itemMaintStat}">
                                    ${status.maintStatName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Arrow -->
                    <div class="me-3 mt-4">
                        <i class="bi bi-arrow-right fs-4"></i>
                    </div>
                    <!-- New Active Dropdown -->
                    <div>
                        <label for="statusNew" class="form-label">New Status</label>
                        <select class="form-select" id="statusNew" name="statusNew" required>
                            <c:forEach items="${FMO_MAINTSTAT_LIST}" var="status">
                                <option value="${status.itemMaintStat}">
                                    ${status.maintStatName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    </div>

                    <div id="updateForms" class="mb-3">
                        <div id="formInput1">
                            <!--<input type="text" id="input1" name="2to3Input" placeholder="Maintenance Required to In Maintenance input" />-->
                            <!--<input type="text" name="locID" value="${locID}">
                            <input type="text" name="floorName" value="${floorName}">-->
                            
                            <!--<div class="mb-3">
                                <label for="quotationFile" class="form-label">Upload File</label>
                                <input class="form-control" type="file" name="quotationFile" id="quotationFile" accept=".pdf, image/*">
                            </div>
                            <div class="mb-3">
                                <label for="quotationDescription" class="form-label">Quotation Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" id="quotationDescription" rows="3"></textarea>
                            </div>-->
                            <div class="mb-3">
                                <label for="quotationDescription" class="form-label">Quotation Description</label>
                                <textarea class="form-control" name="description" id="quotationDescription" rows="3" maxlength="255" required></textarea>
                                <div class="character-counter" id="characterCounter">0 / 255 characters</div>
                            </div>
                            
                            <!-- File Upload Section -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="file-upload-container" id="fileContainer1">
                                        <label for="quotationFile1" class="form-label">Upload File 1 (Optional)</label>
                                        <input class="form-control" type="file" name="quotationFile1" id="quotationFile1" 
                                               accept=".pdf,.jpg,.jpeg,.png,.gif,.bmp,.tiff">
                                        <small class="text-muted">Max size: 10MB. Supported: PDF, Images</small>
                                        <div id="file1Preview" class="mt-2"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="file-upload-container" id="fileContainer2">
                                        <label for="quotationFile2" class="form-label">Upload File 2 (Optional)</label>
                                        <input class="form-control" type="file" name="quotationFile2" id="quotationFile2" 
                                               accept=".pdf,.jpg,.jpeg,.png,.gif,.bmp,.tiff">
                                        <small class="text-muted">Max size: 10MB. Supported: PDF, Images</small>
                                        <div id="file2Preview" class="mt-2"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="formInput2">
                            <!--<input type="text" id="input2" name="3to1Input" placeholder="In Maintenance to Operational input" />-->
                        </div>                    
                        <div id="formInput3">
                            <input type="hidden" id="input3" name="to4Input" 
                                   placeholder="to Needs Replacement input" />
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Update</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- jQuery, required for DataTables -->
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 

<script>

function hideLoadingScreen() {
    $('#loadingScreen').fadeOut(300);
}

// Hide loading screen when page is fully loaded
$(window).on('load', function() {
    setTimeout(hideLoadingScreen, 200);
});

// Fallback timeout
setTimeout(function() {
    if ($('#loadingScreen').is(':visible')) {
        hideLoadingScreen();
    }
}, 8000);

$(document).ready(function() {
    // Initialize DataTable for maintenance table with server-side processing
    var maintenanceTable = $('#maintenanceTable').DataTable({
        processing: true,
        serverSide: true,
        responsive: true,
        ajax: {
            url: 'maintenancePage',
            type: 'GET',
            data: function(d) {
                d.ajax = 'equipmentTable';
            },
            error: function(xhr, error, thrown) {
                console.error('Equipment DataTables error:', error, thrown);
                console.error('Response:', xhr.responseText);
                hideLoadingScreen();
            }
        },
        columns: [
            { data: 'itemName' },
            { data: 'status' },
            { data: 'plannedDate' },
            { data: 'equipment', visible: false, searchable: true }
        ],
        order: [[2, 'desc']], // Sort by Date Notified in descending order
        pageLength: 5, // Show 5 entries per page to match panel height
        lengthMenu: [5, 10, 25, 50],
        language: {
            processing: "Loading data...",
            search: "Search:",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ entries",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        },
        drawCallback: function() {
            // Hide loading screen after first draw
            hideLoadingScreen();
            // Reattach click handlers after each draw
            attachMaintenanceRowClickHandlers();
            // Recalculate heights
            resetCardHeights();
            equalizeCardHeights();
        }
    });
    
    // Initialize DataTable for scheduled maintenance table with server-side processing
    var scheduledMaintTable = $('#scheduledMaintTable').DataTable({
        processing: true,
        serverSide: true,
        responsive: true,
        ajax: {
            url: 'maintenancePage',
            type: 'GET',
            data: function(d) {
                d.ajax = 'scheduledTable';
            },
            error: function(xhr, error, thrown) {
                console.error('Scheduled DataTables error:', error, thrown);
                console.error('Response:', xhr.responseText);
            }
        },
        columns: [
            { data: 'itemName' },
            { data: 'maintTypeName' },
            { data: 'userName' },
            { data: 'dateOfMaint' },
            { 
                data: null,
                orderable: false,
                render: function(data, type, row) {
                    if (row.isCurrentUser) {
                        return '<button type="button" class="btn btn-warning update-bstatus-btn" ' +
                               'data-bs-toggle="modal" data-bs-target="#updateStatusModal" ' +
                               'data-itembid="' + row.itemID + '" ' +
                               'data-itemblid="' + row.locId + '" ' +
                               'data-itembstatus="' + row.maintStatus + '">Update Status</button>';
                    }
                    return '';
                }
            },
            {
                data: null,
                orderable: false,
                render: function(data, type, row) {
                    return '<div class="dropdown">' +
                           '<button class="btn btn-link p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">' +
                           '<img src="resources/images/kebabMenu.svg" alt="Actions" width="20" height="20">' +
                           '</button>' +
                           '<ul class="dropdown-menu">' +
                           '<li><a class="dropdown-item" href="#" data-bs-toggle="modal" ' +
                           'data-bs-target="#editMaintenanceModal" ' +
                           'data-mainteid="' + row.assignID + '" ' +
                           'data-maintename="' + row.itemName + '" ' +
                           'data-itemeid="' + row.itemID + '" ' +
                           'data-usereid="' + row.userID + '" ' +
                           'data-mainttypeeid="' + row.maintTypeID + '" ' +
                           'data-datemaint="' + row.dateOfMaint + '" ' +
                           'onclick="populateEditMaintenance(this)">Edit</a></li>' +
                           '<li><a class="dropdown-item delete-maintenance-btn" href="#" ' +
                           'data-maintdid="' + row.assignID + '">Delete</a></li>' +
                           '</ul></div>';
                }
            },
            { data: 'equipment', visible: false, searchable: true }
        ],
        order: [[3, 'desc']], // Sort by Date of Maintenance in descending order
        pageLength: 5, // Show 5 entries per page to match panel height
        lengthMenu: [5, 10, 25, 50],
        language: {
            processing: "Loading data...",
            search: "Search:",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ entries",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        },
        drawCallback: function() {
            resetCardHeights();
            equalizeCardHeights();
        }
    });

    // Ensure equal heights of both panels
    function equalizeCardHeights() {
        var windowWidth = $(window).width();
        if (windowWidth >= 992) { // Only on desktop
            // Reset any previous min-height to get natural height
            $('.equal-height .card').css('min-height', '');
            
            setTimeout(function() {
                var leftPanelHeight = $('.equal-height:first-child .card').outerHeight();
                var rightPanelHeight = $('.equal-height:last-child .card').outerHeight();
                
                // Set both panels to the height of the taller one
                var maxHeight = Math.max(leftPanelHeight, rightPanelHeight);
                $('.equal-height .card').css('min-height', maxHeight + 'px');
            }, 100);
        } else {
            $('.equal-height .card').css('min-height', '');
        }
    }

    // Function to reset heights before recalculating
    function resetCardHeights() {
        $('.equal-height .card').css('min-height', '');
    }

    // Run on initial load
    equalizeCardHeights();

    // Run when window is resized
    $(window).resize(function() {
        resetCardHeights();
        equalizeCardHeights();
    });

    // Run when DataTable page length is changed
    maintenanceTable.on('length', function() {
        resetCardHeights();
        setTimeout(equalizeCardHeights, 200); // Slight delay to ensure DOM updates
    });

    // Run when scheduled maintenance table page length is changed
    scheduledMaintTable.on('length', function() {
        resetCardHeights();
        setTimeout(equalizeCardHeights, 200); // Slight delay to ensure DOM updates
    });

    // Function to attach click handlers to maintenance table rows
    function attachMaintenanceRowClickHandlers() {
        $('#maintenanceTable tbody').off('click', 'tr').on('click', 'tr', function() {
            var data = maintenanceTable.row(this).data();
            if (!data) return;

            const equipmentId = data.itemID;
            const equipment = data.equipment;
            const status = data.statusId;
            const status2 = data.statusId;
            const status3 = data.statusId;
            const statname = data.status;
            const serial = data.itemName;
            const brand = data.brand;
            const location = data.location;
            const locid = data.locId;
            
            const canUpdate = data.canUpdate; // Get access info
            
            // Update the hidden input for the update modal
            $('#updateEquipmentId').val(equipmentId);
            $('#updateEquipmentStatus').val(status2);
            $('#updateEquipmentLID').val(locid);
            
            if (canUpdate === true || canUpdate === "true") {
                $('#updateStatusBtn').show(); // Adjust selector to your button
            } else {
                $('#updateStatusBtn').hide();
            }
            
            //modal maint status dropdown select initial value
            const statusDropdown = document.getElementById("status");
            if (statusDropdown) {
                Array.from(statusDropdown.options).forEach(option => {
                    option.selected = (option.value === String(status2));
                });
            }
            //modal maint disable initial status on new dropdown
            const statusDropdownNew = document.getElementById("statusNew"); 
            if (statusDropdownNew) { 
                Array.from(statusDropdownNew.options).forEach(option => {
                    option.disabled = false;
                });
                Array.from(statusDropdownNew.options).forEach(option => { 
                    if (option.value && option.value === String(status3)) {
                        option.disabled = true;
                    }
                    //maintenance reqd to operational bad
                    if (statusDropdown.value === "2" && option.value === "1") {
                        option.disabled = true;
                    }
                });
                
                statusDropdownNew.addEventListener("change", updateInputVisibility);
            }
            
            function updateInputVisibility() {
                const oldVal = statusDropdown.value;
                const newVal = statusDropdownNew.value;
            
                const formInput1 = document.getElementById("formInput1"); // 2 or 4 to 3
                const formInput2 = document.getElementById("formInput2"); // 3 to 1
                const formInput3 = document.getElementById("formInput3"); // 3 to 4
            
                // Hide all form input divs and clear their inner input values
                [formInput1, formInput2, formInput3].forEach(div => {
                    div.style.display = "none";
                    
                    // Clear input fields inside the div
                    const inputs = div.querySelectorAll("input, textarea");
                    inputs.forEach(input => {
                        input.value = "";
                        input.removeAttribute("required");
                    });
                });
            
                // Show relevant form input div and add back requireds
                if ((oldVal === "2" || oldVal === "4") && newVal === "3") {
                    formInput1.style.display = "block";
            
                    // Reapply required only to visible inputs
//                    const fileInput = document.getElementById("quotationFile");
//                    const descriptionInput = document.getElementById("quotationDescription");
//            
//                    if (fileInput) fileInput.setAttribute("required", "required");
//                    if (descriptionInput) descriptionInput.setAttribute("required", "required");
                } else if (oldVal === "3" && newVal === "1") {
                    formInput2.style.display = "block";
                    
                } else if ((oldVal === "2" || oldVal === "3") && newVal === "4") {
                    formInput3.style.display = "block";
                    
                }
            }
            
            //resets new status dropdown to operational every modal open and render disappearing content
            const modal = document.getElementById("updateStatusModal");
            if (modal) {
                modal.addEventListener("show.bs.modal", () => {
                    // Clear and reset visibility on modal open
                    statusDropdownNew.value = "1";
                    updateInputVisibility();
                    console.log()
                });
            }
       
            // Update equipment details in the right panel
            $('#detailEquipment').text(equipment);
            $('#detailStatus').text(statname);
            $('#detailSerial').text(serial);
            $('#detailBrand').text(brand);
            $('#detailLocation').text(location);
            
            // Highlight the selected row
            if (!$(this).hasClass('selected')) {
                maintenanceTable.$('tr.selected').removeClass('selected');
                $(this).addClass('selected');
            }
            
            // Recalculate heights after updating details panel content
            setTimeout(function() {
                resetCardHeights();
                equalizeCardHeights();
            }, 50);
        });
    }

    // Initial attachment of click handlers
    attachMaintenanceRowClickHandlers();
    
    // Select the first row by default after initial data load
    maintenanceTable.on('draw.dt', function() {
        if (maintenanceTable.data().count() > 0) {
            $('#maintenanceTable tbody tr:first').trigger('click');
        }
    });
});

// Character counter functionality
const MAX_DESCRIPTION_LENGTH = 255;

function setupCharacterCounter() {
    var textarea = document.getElementById('quotationDescription');
    var counter = document.getElementById('characterCounter');
    
    if (!textarea || !counter) return;
    
    textarea.addEventListener('input', function() {
        var currentLength = textarea.value.length;
        counter.textContent = currentLength + ' / ' + MAX_DESCRIPTION_LENGTH + ' characters';
        
        counter.classList.remove('warning', 'danger');
        textarea.classList.remove('invalid');
        
        if (currentLength > MAX_DESCRIPTION_LENGTH) {
            counter.classList.add('danger');
            textarea.classList.add('invalid');
        } else if (currentLength > MAX_DESCRIPTION_LENGTH * 0.8) {
            counter.classList.add('warning');
        }
    });
}

// Initialize when modal opens
$('#updateStatusModal').on('shown.bs.modal', function() {
    setupCharacterCounter();
    setupFileInput('quotationFile1', 'file1Preview');
    setupFileInput('quotationFile2', 'file2Preview');
});

// File preview functionality
function setupFileInput(inputId, previewId) {
    const input = document.getElementById(inputId);
    const preview = document.getElementById(previewId);
    
    if (!input || !preview) return;
    
    // Remove any existing event listeners by cloning the element
    const newInput = input.cloneNode(true);
    input.parentNode.replaceChild(newInput, input);
    
    // Now attach the event listener to the new element
    newInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        preview.innerHTML = '';
        
        if (file) {
            // Validate file size (10MB)
            const MAX_FILE_SIZE = 10 * 1024 * 1024;
            if (file.size > MAX_FILE_SIZE) {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger mt-2';
                errorDiv.textContent = 'File size exceeds 10MB limit';
                preview.appendChild(errorDiv);
                newInput.value = '';
                return;
            }
            
            // Show file info
            const fileInfo = document.createElement('div');
            fileInfo.className = 'alert alert-info mt-2';
            fileInfo.innerHTML = '<strong>Selected:</strong> ' + file.name + 
                               '<br><strong>Size:</strong> ' + (file.size / 1024 / 1024).toFixed(2) + ' MB';
            preview.appendChild(fileInfo);
            
            // Show preview for images
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'img-thumbnail mt-2';
                    img.style.maxHeight = '100px';
                    preview.appendChild(img);
                };
                reader.readAsDataURL(file);
            }
        }
    });
}


</script>

<script>
function populateEditMaintenance(button) {
    var assignID = button.getAttribute('data-mainteid');
    var itemName = button.getAttribute('data-maintename');
    var maintTypeID = button.getAttribute('data-mainttypeeid');
    var userID = button.getAttribute('data-usereid');
    var dateMaint = button.getAttribute('data-datemaint');
    
    console.log('Populating edit modal with:', {
        assignID, itemName, maintTypeID, userID, dateMaint
    });
    
    // Set the hidden maintenance ID
    document.getElementById('maintID').value = assignID;
    
    // Set the equipment name (readonly field for display only)
    var equipmentNameField = document.getElementById('equipmentEName');
    if (equipmentNameField) {
        equipmentNameField.value = itemName;
    }
    
    // Set maintenance type dropdown
    var maintTypeDrop = document.getElementById('maintenanceEType');
    if (maintTypeDrop) {
        maintTypeDrop.value = maintTypeID;
    }
    
    // Set assigned to dropdown
    var assignedToDrop = document.getElementById('assignedETo');
    if (assignedToDrop) {
        assignedToDrop.value = userID;
    }
    
    // Set date - handle multiple date formats
    var dateInput = document.getElementById('dateEMaint');
    if (dateInput && dateMaint) {
        var convertedDate = '';
        
        // Remove any time portion if present
        dateMaint = dateMaint.split(' ')[0];
        
        // Check if date is in dd/mm/yyyy format
        if (dateMaint.includes('/')) {
            var parts = dateMaint.split('/');
            if (parts.length === 3) {
                var day = parts[0].padStart(2, '0');
                var month = parts[1].padStart(2, '0');
                var year = parts[2];
                convertedDate = year + '-' + month + '-' + day;
            }
        } 
        // Check if date is in dd-mm-yyyy format
        else if (dateMaint.match(/^\d{2}-\d{2}-\d{4}$/)) {
            var parts = dateMaint.split('-');
            var day = parts[0].padStart(2, '0');
            var month = parts[1].padStart(2, '0');
            var year = parts[2];
            convertedDate = year + '-' + month + '-' + day;
        }
        // Check if already in yyyy-mm-dd format
        else if (dateMaint.match(/^\d{4}-\d{2}-\d{2}$/)) {
            convertedDate = dateMaint;
        }
        
        dateInput.value = convertedDate;
        console.log('Date converted from', dateMaint, 'to', convertedDate);
    }
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
      case 'modify_status':
        toastMessage = 'The equipment status was modified successfully.';
        break;
      case '3to1':
        toastMessage = 'The equipment is now operational.';
        break;
     case 'assign':
        toastMessage = 'Assigned maintenance modified successfully.';
        break;
     case 'delete':
        toastMessage = 'Assigned maintenance deleted successfully.';
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
      let errorMessage = '';
    
      switch (action) {
        case 'assign':
          errorMessage = 'Equipment already assigned for maintenance.';
          break;
        case '2to1':
          errorMessage = 'Equipment must be maintained before changing to operational.';
          break;
        default:
          errorMessage = 'An error occurred while processing your request.';
          break;
      }
    
      Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'error',
        title: errorMessage,
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
      });
    }

$(document).on('click', '.delete-maintenance-btn', function(e) {
    e.preventDefault();
    const maintID = $(this).data('maintdid');

    Swal.fire({
        title: 'Are you sure?',
        text: "Do you want to delete this maintenance assignment?",
        icon: 'warning',
        showCancelButton: true,
        reverseButtons: true,
        cancelButtonColor: '#6c757d',
        confirmButtonColor: '#dc3545',
        cancelButtonText: 'Cancel',
        confirmButtonText: 'Yes, archive it',
        
    }).then((result) => {
        if (result.isConfirmed) {
            $('#deleteMaintID').val(maintID);
            $('#deleteMaintenanceForm').submit();
        }
    });
});

//maint assign table update status button logic (almost the same as logic for equipment details update status)
$(document).on('click', '.update-bstatus-btn', function () {
    const itemBId = $(this).data('itembid');
    const itemBLid = $(this).data('itemblid');
    const Bstatus = $(this).data('itembstatus');

    $('#updateEquipmentId').val(itemBId);
    $('#updateEquipmentLID').val(itemBLid);
    $('#updateEquipmentStatus').val(Bstatus);

    // Set current status dropdown
    const statusDropdown = document.getElementById("status");
    if (statusDropdown) {
        Array.from(statusDropdown.options).forEach(option => {
            option.selected = (option.value === String(Bstatus));
        });
    }

    // Reset new status dropdown visibility and disable logic
    const statusDropdownNew = document.getElementById("statusNew"); 
    if (statusDropdownNew) { 
        Array.from(statusDropdownNew.options).forEach(option => {
            option.disabled = false;
        });

        Array.from(statusDropdownNew.options).forEach(option => { 
            if (option.value && option.value === String(Bstatus)) {
                option.disabled = true;
            }
            if (statusDropdown.value === "2" && option.value === "1") {
                option.disabled = true;
            }
        });

        statusDropdownNew.addEventListener("change", updateInputVisibility);

        // Trigger initial visibility state
        statusDropdownNew.value = "1";
        updateInputVisibility();
    }
});
$(document).ready(function() {
    var equipmentArray = [];
    
    // Function to initialize Awesomplete
    function initializeAwesomplete(inputId, equipmentList) {
        var input = document.getElementById(inputId);
        if (input && equipmentList.length > 0) {
            new Awesomplete(input, {
                list: equipmentList,
                minChars: 1,
                maxItems: 10,
                autoFirst: true,
                filter: function(text, input) {
                    return Awesomplete.FILTER_CONTAINS(text, input);
                }
            });
        }
    }
    
    // Fetch equipment list via AJAX
    function loadEquipmentList() {
        $.ajax({
            url: 'maintenancePage',
            type: 'GET',
            data: { ajax: 'equipmentList' },
            dataType: 'json',
            success: function(response) {
                if (response && response.equipmentList) {
                    equipmentArray = response.equipmentList;
                    
                    // Initialize Awesomplete for both modals
                    initializeAwesomplete('equipmentName', equipmentArray);
                    initializeAwesomplete('equipmentEName', equipmentArray);
                    
                    console.log('Equipment list loaded:', equipmentArray.length, 'items'); // Debug
                }
            },
            error: function(xhr, status, error) {
                console.error('Failed to load equipment list:', error);
            }
        });
    }
    
    // Load equipment list on page load
    loadEquipmentList();
    
    // Optionally, refresh the list when modals are opened
    $('#addMaintenanceModal').on('show.bs.modal', function() {
        loadEquipmentList();
    });
    
    $('#editMaintenanceModal').on('show.bs.modal', function() {
        loadEquipmentList();
    });
});
</script>

<script>
    window.onload = function() {
        var today = new Date().toISOString().split("T")[0");
        document.getElementById("dateMaint").min = today;
        document.getElementById("dateEMaint").min = today;
    };
</script>





</body>
</html>
