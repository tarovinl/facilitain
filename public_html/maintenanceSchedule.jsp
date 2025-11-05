<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance Schedule - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body, h1, h2, h3, h4, th, h5 {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h6, input, textarea, td, tr, p, label, select, option {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        .hover-outline {
            transition: all 0.3s ease;
            border: 1px solid transparent;
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
        .buttonsBack:hover {
            text-decoration: underline !important;
        }
        .buildingManage:hover {
            text-decoration: underline !important;
        }
        .btn-cancel-outline {
            color: #8388a4 !important;
            background-color: white !important;
            border: 2px solid #8388a4 !important;
            box-shadow: none !important;
        }
        .btn-cancel-outline:hover {
            background-color: #f0f2f7 !important;
            border-color: #8388a4 !important;
            color: #8388a4 !important;
        }
        .responsive-padding-top {
            padding-top: 100px;
        }
        @media (max-width: 576px) {
            .responsive-padding-top {
                padding-top: 80px;
            }
        }
        
        .remarks-cell {
            max-width: 250px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .remarks-text {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            flex: 1;
        }
               .remarks-btn {
            border: none;
            background-color: transparent;
            color: #6c757d;
            padding: 0;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;  
        }
        
        .remarks-btn:hover {
            color: #495057;  
            transform: scale(1.1); 
        }
        
        .remarks-btn:active {
            transform: scale(0.95);  
        }
        @media (max-width: 768px) {
            .remarks-cell {
                max-width: 150px;
            }
            .remarks-text {
                max-width: 100px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="container-fluid">
    <div class="row vh-100">
        <c:set var="page" value="maintenanceSchedule" scope="request"/>
        <jsp:include page="sidebar.jsp"></jsp:include>
        <div class="col-md-10 responsive-padding-top">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Maintenance Schedule</h1>
                <button class="buttonsBuilding d-flex align-items-center px-3 py-2 rounded-2 hover-outline" style="background-color: #fccc4c;" data-bs-toggle="modal" data-bs-target="#addMaintenanceModal">
                    <img src="resources/images/icons/plus.svg" alt="add" width="25" height="25"> 
                    <span class="d-none d-lg-inline ps-2">Add</span>
                </button>
            </div>

            <!-- Maintenance List Table -->
            <table id="maintenanceTable" class="table table-striped table-bordered mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Item Type</th>
                        <th>Number of Days</th>
                        <th>Remarks</th>
                        <th>Warning Days</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody class="table-light">
                    <c:forEach var="maintenance" items="${maintenanceList}">
                        <c:if test="${maintenance.archiveFlag == 1}">
                            <tr>
                                <td>${maintenance.itemMsId}</td>
                                <td>
                                    <c:forEach items="${FMO_TYPES_LIST}" var="type">
                                        <c:if test="${type.itemTID == maintenance.itemTypeId}">
                                            <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat">
                                                <c:if test="${cat.itemCID == type.itemCID}">
                                                    ${cat.itemCat.toUpperCase()}
                                                </c:if>
                                            </c:forEach>
                                            ${type.itemType.toUpperCase()}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>${maintenance.noOfDays}</td>
                                   <td>
                                    <div class="remarks-cell">
                                        <span class="remarks-text" title="${maintenance.remarks}">${maintenance.remarks}</span>
                                        <c:if test="${not empty maintenance.remarks}">
                                            <button class="btn btn-sm remarks-btn" 
                                                type="button" 
                                                data-bs-toggle="popover" 
                                                data-bs-placement="left"
                                                data-bs-trigger="click"
                                                data-bs-content="${maintenance.remarks}"
                                                title="Full Remark">
                                            ...
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                                <td>${maintenance.noOfDaysWarning}</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editMaintenanceModal"
                                            data-itemmsid="${maintenance.itemMsId}"
                                            data-itemtypeid="${maintenance.itemTypeId}"
                                            data-noofdays="${maintenance.noOfDays}"
                                            data-remarks="${maintenance.remarks}"
                                            data-warning="${maintenance.noOfDaysWarning}"
                                            data-quarterly="${maintenance.quarterlySchedNo != null ? maintenance.quarterlySchedNo : ''}"
                                            data-yearly="${maintenance.yearlySchedNo != null ? maintenance.yearlySchedNo : ''}">
                                        Edit
                                    </button>
                                    <form action="maintenanceSave" method="POST" class="d-inline">
                                        <input type="hidden" name="itemMsId" value="${maintenance.itemMsId}">
                                        <input type="hidden" name="action" value="archive">
                                        <button type="submit" class="btn btn-danger btn-sm">Archive</button>
                                    </form>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Add Maintenance Modal -->
            <div class="modal fade" id="addMaintenanceModal" tabindex="-1" aria-labelledby="addMaintenanceModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="maintenanceSave" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addMaintenanceModalLabel">Add Maintenance Schedule</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Item Type Dropdown -->
                                <div class="mb-3">
                                    <label for="addItemTypeId" class="form-label">Item Type</label>
                                    <select class="form-select" id="addItemTypeId" name="itemTypeId" required>
                                        <option value="" disabled selected>Select Item Type</option>
                                         <c:forEach var="typez" items="${FMO_TYPES_LIST}">
                                    <c:if test="${typez.itemArchive == 1}">
                                        <option value="${typez.itemTID}">${typez.itemType}</option>
                                    </c:if>
                                </c:forEach>
                                    </select>
                                </div>

                                <!-- Number of Days -->
                                <div class="mb-3">
                                    <label for="addNoOfDays" class="form-label">Number of Days</label>
                                    <input type="number" class="form-control" id="addNoOfDays" name="noOfDays" required oninput="toggleAddQuarterlyOptions()">
                                </div>

                                <!-- Quarterly Options -->
                                <div id="addQuarterlyOptionsGroup" class="mb-3" style="display: none;">
                                    <label for="addQuarterlySchedule" class="form-label">Quarterly Schedule</label>
                                    <select id="addQuarterlySchedule" name="quarterlySchedule" class="form-select">
                                        <option value="" disabled selected>-- Select Quarterly Schedule --</option>
                                        <option value="1">January, April, July, October</option>
                                        <option value="2">February, May, August, November</option>
                                        <option value="3">March, June, September, December</option>
                                    </select>
                                </div>

                                <!-- Yearly Options -->
                                <div id="addAnnualOptionsGroup" class="mb-3" style="display: none;">
                                    <label for="addMonth" class="form-label">Month Schedule</label>
                                    <select id="addMonth" name="yearlySchedule" class="form-select">
                                        <option value="" disabled selected>-- Select Month --</option>
                                        <option value="1">January</option>
                                        <option value="2">February</option>
                                        <option value="3">March</option>
                                        <option value="4">April</option>
                                        <option value="5">May</option>
                                        <option value="6">June</option>
                                        <option value="7">July</option>
                                        <option value="8">August</option>
                                        <option value="9">September</option>
                                        <option value="10">October</option>
                                        <option value="11">November</option>
                                        <option value="12">December</option>
                                    </select>
                                </div>

                                <!-- Remarks -->
                                <div class="mb-3">
                                    <label for="addRemarks" class="form-label">Remarks</label>
                                    <input type="text" class="form-control" id="addRemarks" name="remarks">
                                </div>

                                <!-- Number of Days Warning -->
                                <div class="mb-3">
                                    <label for="addNoOfDaysWarning" class="form-label">Warning Days</label>
                                    <input type="number" class="form-control" id="addNoOfDaysWarning" name="noOfDaysWarning" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success">Add</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Maintenance Modal -->
            <div class="modal fade" id="editMaintenanceModal" tabindex="-1" aria-labelledby="editMaintenanceModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="maintenanceSave" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editMaintenanceModalLabel">Edit Maintenance Schedule</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="editItemMsId" name="itemMsId">
                                
                                <!-- Item Type Dropdown -->
                                <div class="mb-3">
                                    <label for="editItemTypeId" class="form-label">Item Type</label> <span class="text-danger">*</span>
                                    <select class="form-select" id="editItemTypeId" name="itemTypeId" required>
                                        <option value="" disabled>Select Item Type</option>
                                <c:forEach var="typez" items="${FMO_TYPES_LIST}">
                                    <c:if test="${typez.itemArchive == 1}">
                                        <option value="${typez.itemTID}">${typez.itemType}</option>
                                    </c:if>
                                </c:forEach>
                                    </select>
                                </div>

                                <!-- Number of Days -->
                                <div class="mb-3">
                                    <label for="editNoOfDays" class="form-label">Number of Days</label> <span class="text-danger">*</span>
                                    <input type="number" class="form-control" id="editNoOfDays" name="noOfDays" required oninput="toggleEditQuarterlyOptions()">
                                </div>

                                <!-- Quarterly Options -->
                                <div id="editQuarterlyOptionsGroup" class="mb-3" style="display: none;">
                                    <label for="editQuarterlySchedule" class="form-label">Quarterly Schedule</label>
                                    <select id="editQuarterlySchedule" name="quarterlySchedule" class="form-select">
                                        <option value="" disabled>-- Select Quarterly Schedule --</option>
                                        <option value="1">January, April, July, October</option>
                                        <option value="2">February, May, August, November</option>
                                        <option value="3">March, June, September, December</option>
                                    </select>
                                </div>

                                <!-- Yearly Options -->
                                <div id="editAnnualOptionsGroup" class="mb-3" style="display: none;">
                                    <label for="editMonth" class="form-label">Month Schedule</label>
                                    <select id="editMonth" name="yearlySchedule" class="form-select">
                                        <option value="" disabled selected>-- Select Month --</option>
                                        <option value="1">January</option>
                                        <option value="2">February</option>
                                        <option value="3">March</option>
                                        <option value="4">April</option>
                                        <option value="5">May</option>
                                        <option value="6">June</option>
                                        <option value="7">July</option>
                                        <option value="8">August</option>
                                        <option value="9">September</option>
                                        <option value="10">October</option>
                                        <option value="11">November</option>
                                        <option value="12">December</option>
                                    </select>
                                </div>

                                <!-- Remarks -->
                                <div class="mb-3">
                                    <label for="editRemarks" class="form-label">Remarks</label>
                                    <input type="text" class="form-control" id="editRemarks" name="remarks">
                                </div>

                                <!-- Number of Days Warning -->
                                <div class="mb-3">
                                    <label for="editNoOfDaysWarning" class="form-label">Warning Days</label> <span class="text-danger">*</span>
                                    <input type="number" class="form-control" id="editNoOfDaysWarning" name="noOfDaysWarning" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    // Initialize DataTable
    $('#maintenanceTable').DataTable({
        "paging": true,
        "searching": true,
        "ordering": true,
        "info": true,
        "language": {
            "search": "Filter records:",
            "lengthMenu": "Show _MENU_ entries per page"
        }
    });

    // Handle Add Modal
    const addMaintenanceModal = document.getElementById('addMaintenanceModal');
    if (addMaintenanceModal) {
        addMaintenanceModal.addEventListener('show.bs.modal', event => {
            // Clear the add form
            document.getElementById('addItemTypeId').value = '';
            document.getElementById('addNoOfDays').value = '';
            document.getElementById('addRemarks').value = '';
            document.getElementById('addNoOfDaysWarning').value = '';
            document.getElementById('addQuarterlySchedule').value = '';
            document.getElementById('addMonth').value = '';
            document.getElementById('addQuarterlyOptionsGroup').style.display = 'none';
            document.getElementById('addAnnualOptionsGroup').style.display = 'none';
        });
    }

    // Handle Edit Modal with proper persistence
    const editMaintenanceModal = document.getElementById('editMaintenanceModal');
    if (editMaintenanceModal) {
        editMaintenanceModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            
            // Populate form fields
            document.getElementById('editItemMsId').value = button.getAttribute('data-itemmsid');
            document.getElementById('editItemTypeId').value = button.getAttribute('data-itemtypeid');
            document.getElementById('editNoOfDays').value = button.getAttribute('data-noofdays');
            document.getElementById('editRemarks').value = button.getAttribute('data-remarks');
            document.getElementById('editNoOfDaysWarning').value = button.getAttribute('data-warning');
            
            // Get schedule values
            const quarterlyValue = button.getAttribute('data-quarterly');
            const yearlyValue = button.getAttribute('data-yearly');
            
            // Show appropriate options based on number of days
            toggleEditQuarterlyOptions();
            
            if (quarterlyValue && quarterlyValue !== '') {
                document.getElementById('editQuarterlySchedule').value = quarterlyValue;
            }
            
            // Set yearly schedule if exists
            if (yearlyValue && yearlyValue !== '') {
                document.getElementById('editMonth').value = yearlyValue;
            }
        });
    }

    // Handle SweetAlert2 notifications
    const urlParams = new URLSearchParams(window.location.search);
    const action = urlParams.get('action');
    const error = urlParams.get('error');

    if (action || error) {
        let alertConfig = {
            confirmButtonText: 'OK',
            allowOutsideClick: false
        };

        if (error) {
            alertConfig = {
                ...alertConfig,
                title: 'Error!',
                text: 'An error occurred while processing your request.',
                icon: 'error'
            };
        } else {
            switch(action) {
                case 'archived':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Archived!',
                        text: 'The maintenance schedule has been successfully archived.',
                        icon: 'success'
                    };
                    break;
                case 'updated':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Updated!',
                        text: 'The maintenance schedule has been successfully updated.',
                        icon: 'success'
                    };
                    break;
                case 'added':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Added!',
                        text: 'The new maintenance schedule has been successfully added.',
                        icon: 'success'
                    };
                    break;
            }
        }

        Swal.fire(alertConfig).then(() => {
            // Remove the parameters from the URL without refreshing
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        });
    }

    // Archive confirmation handler 
    $(document).on('click', '.btn-danger', function(e) {
        // Check if this button is within a form with archive action
        const form = $(this).closest('form');
        const archiveInput = form.find('input[name="action"][value="archive"]');
        
        if (archiveInput.length > 0) {
            e.preventDefault();
            e.stopPropagation();
            
            const formElement = form[0];
            
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to archive this maintenance schedule?',
                icon: 'warning',
                showCancelButton: true,
                reverseButtons: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, Archive it',
                cancelButtonText: 'Cancel',
                customClass: {
                    cancelButton: 'btn-cancel-outline'
                },
                allowOutsideClick: false,
                allowEscapeKey: false
            }).then((result) => {
                if (result.isConfirmed) {
                    // Submit the form directly
                    formElement.submit();
                }
            });
            
            return false;
        }
    });
});

function toggleAddQuarterlyOptions() {
    const value = document.getElementById('addNoOfDays').value;
    const quarterlyOptionsGroup = document.getElementById('addQuarterlyOptionsGroup');
    const annualOptionsGroup = document.getElementById('addAnnualOptionsGroup');

    if (value == 90) {
        quarterlyOptionsGroup.style.display = 'block';
        annualOptionsGroup.style.display = 'none';
        document.getElementById('addMonth').value = ""; 
    } else if (value == 365 || value == 180) {
        annualOptionsGroup.style.display = 'block';
        quarterlyOptionsGroup.style.display = 'none';
        document.getElementById('addQuarterlySchedule').value = '';
    } else {
        quarterlyOptionsGroup.style.display = 'none';
        annualOptionsGroup.style.display = 'none';
        document.getElementById('addQuarterlySchedule').value = '';
        document.getElementById('addMonth').value = "";
    }
}

function toggleEditQuarterlyOptions() {
    const value = document.getElementById('editNoOfDays').value;
    const quarterlyOptionsGroup = document.getElementById('editQuarterlyOptionsGroup');
    const annualOptionsGroup = document.getElementById('editAnnualOptionsGroup');

    if (value == 90) {
        quarterlyOptionsGroup.style.display = 'block';
        annualOptionsGroup.style.display = 'none';
        document.getElementById('editMonth').value = ""; 
    } else if (value == 365 || value == 180) {
        annualOptionsGroup.style.display = 'block';
        quarterlyOptionsGroup.style.display = 'none';
        document.getElementById('editQuarterlySchedule').value = '';
    } else {
        quarterlyOptionsGroup.style.display = 'none';
        annualOptionsGroup.style.display = 'none';
        document.getElementById('editQuarterlySchedule').value = '';
        document.getElementById('editMonth').value = "";
    }
}

 const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    const popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl, {
            trigger: 'click',
            html: true,
            customClass: 'remarks-popover'
        });
    });
    // Close popover when clicking outside
    document.addEventListener('click', function(event) {
        popoverTriggerList.forEach(function(trigger) {
            if (!trigger.contains(event.target) && !document.querySelector('.popover')?.contains(event.target)) {
                bootstrap.Popover.getInstance(trigger)?.hide();
            }
        });
    });
    
    // Show ellipsis button only if text is truncated
document.addEventListener('DOMContentLoaded', function() {
    const remarksTexts = document.querySelectorAll('.remarks-text');
    remarksTexts.forEach(function(textEl) {
        const button = textEl.nextElementSibling;
        if (button && button.classList.contains('remarks-btn')) {
            // Check if text is truncated
            if (textEl.scrollWidth > textEl.clientWidth) {
                button.style.display = 'inline-block';
            } else {
                button.style.display = 'none';
            }
        }
    });
});
</script>
</body>
</html>