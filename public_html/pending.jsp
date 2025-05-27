<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance Dashboard</title>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.7/awesomplete.min.js"></script>
  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
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
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <div class="container-fluid">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4">
                    <div>
                        <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 3rem; line-height: 1.2;">Maintenance</h1>
                    </div>
                    <div class="mt-3 mt-md-0">
                        <%--<c:choose>
                            <c:when test="${sessionScope.role == 'Admin' || sessionScope.role == 'Maintenance'}">--%>
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addMaintenanceModal">
                                    <i class="bi bi-plus-lg"></i> Make a Maintenance
                                </button>
                            <%--</c:when>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>--%>
                    </div>
                </div>

                <!-- Maintenance Dashboard Panels -->
                <!-- Changed class name from maintenance-container to dashboard-maintenance-container -->
                <div class="row dashboard-maintenance-container">
                    <!-- Maintenance List Panel -->
                    <div class="col-lg-6 mb-4 equal-height">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">List of Equipment</h5>
                            </div>
                            <div class="card-body">
                                <table id="maintenanceTable" class="table table-hover" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>Equipment Name</th>
                                            <th>Status</th>
                                            <th>Date Notified</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Static data for demonstration -->
                                        <%--<c:forEach items="${FMO_TYPES_LIST}" var="type" >
                                        <c:if test="${type.itemCID == 1}">
                                        
                                            <td >${type.itemType}</td>
                                        </c:if>
                                    </c:forEach>--%>
                                    <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                                        <c:if test="${item.itemMaintStat != 1}">
                                           <!--loop to get cat and type-->
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
                                            
                                            <!--loop to get loc name-->
                                            <c:forEach items="${locations}" var="loc" >
                                            <c:if test="${loc.itemLocId == item.itemLID}">
                                                <c:set var="itemLoc" value="${loc.locName}" />
                                            </c:if>
                                            </c:forEach>
                                            <!--loop to get stat name-->
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
                                        data-equipment="${itemCat} - ${itemType}" 
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
                                        </tr>
                                        </c:if>
                                    </c:forEach>
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
                                        <label class="form-label fw-bold">Equipment Type</label>
                                        <div id="detailEquipment">Fire Extinguisher</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Status</label>
                                        <div id="detailStatus">In Progress</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Codename</label>
                                        <div id="detailSerial">09222222</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Brand Name</label>
                                        <div id="detailBrand">XYZ Fire Safety</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Location</label>
                                        <div id="detailLocation">Building A, Floor 1</div>
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
                                <table id="scheduledMaintTable" class="table table-hover" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>Equipment Name</th>
                                            <th>Maintenance Type</th>
                                            <th>Assigned To</th>
                                            <th>Date of Maintenance</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${FMO_MAINT_ASSIGN}" var="maintass" >
                                        <c:if test="${maintass.isCompleted == 0}">
                                        <tr>
                                            <td>
                                                <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                                                <c:if test="${item.itemID == maintass.itemID}">
                                                    ${item.itemName}
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
                                        </tr>
                                        </c:if>
                                        </c:forEach>
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
                    <h5 class="modal-title" id="addMaintenanceModalLabel">Add Maintenance Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <div>
                        <label for="equipmentName" class="form-label">Equipment Name <span style="color: red;">*</span></label>
                        </div>
                        <div class="w-100">
                        <input class="form-control awesomplete w-100" id="equipmentName" data-list="${equipmentListString}" 
                               name="equipmentName" maxlength="24" required style="width: 100%;" onchange="updateEquipmentId()" >
                        <!--<input type="text" id="equipmentMaintId" name="equipmentMaintId">-->
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
                            <c:forEach items="${FMO_USERS}" var="user" >
                                <c:if test="${sessionScope.email == user.email}">
                                <option value="${user.userId}">${user.name}</option>
                                </c:if>
                            </c:forEach>
                            <c:forEach items="${FMO_USERS}" var="user" >
                                <c:if test="${sessionScope.email != user.email}">
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Add</button>
                </div>
            </div>
        </form>
    </div>
</div>

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
                            
                            <div class="mb-3">
                                <label for="quotationFile" class="form-label">Upload File</label>
                                <input class="form-control" type="file" name="quotationFile" id="quotationFile" accept=".pdf, image/*">
                            </div>
                            <div class="mb-3">
                                <label for="quotationDescription" class="form-label">Quotation Description</label>
                                <textarea class="form-control" name="description" id="quotationDescription" rows="3"></textarea>
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


<script>
    $(document).ready(function() {
        // Initialize DataTable
        var maintenanceTable = $('#maintenanceTable').DataTable({
            responsive: true,
            order: [[2, 'desc']], // Sort by Date Notified in descending order
            language: {
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
            pageLength: 5, // Show 5 entries per page to match panel height
            lengthMenu: [5, 10, 25, 50]
        });
        
        var scheduledMaintTable = $('#scheduledMaintTable').DataTable({
            responsive: true,
            order: [[2, 'desc']], // Sort by Date Notified in descending order
            language: {
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
            pageLength: 5, // Show 5 entries per page to match panel height
            lengthMenu: [5, 10, 25, 50]
        });

        // Ensure equal heights of both panels
        function equalizeCardHeights() {
            var windowWidth = $(window).width();
            if (windowWidth >= 992) { // Only on desktop
                setTimeout(function() {
                    var leftPanelHeight = $('.equal-height:first-child .card').outerHeight();
                    $('.equal-height:last-child .card').css('min-height', leftPanelHeight + 'px');
                }, 100);
            } else {
                $('.equal-height:last-child .card').css('min-height', '');
            }
        }

        // Run on initial load
        equalizeCardHeights();

        // Run when window is resized or DataTable page is changed
        $(window).resize(equalizeCardHeights);
        maintenanceTable.on('draw', equalizeCardHeights);

        // Handle row clicks to show details
        $('#maintenanceTable tbody').on('click', 'tr', function() {
            const equipmentId = $(this).data('id');
            const equipment = $(this).data('equipment');
            const status = $(this).data('status');
            const status2 = $(this).data('status');
            const status3 = $(this).data('status');
            const statname = $(this).data('statname');
            const serial = $(this).data('serial');
            const brand = $(this).data('brand');
            const location = $(this).data('location');
            
            const canUpdate = $(this).data('canupdate'); // Get access info
            
            // Update the hidden input for the update modal
            $('#updateEquipmentId').val(equipmentId);
            $('#updateEquipmentStatus').val(status2);
            
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
            
        });
        
        // Select the first row by default
        $('#maintenanceTable tbody tr:first').trigger('click');
        $('#scheduledMaintTable tbody tr:first').trigger('click');
    });
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
</script>

<script>
    window.onload = function() {
        var today = new Date().toISOString().split("T")[0];
        document.getElementById("dateMaint").min = today;
    };
</script>


</body>
</html>