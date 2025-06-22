<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Automated Scheduling</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
   body, h1, h2, h3, h4, th,h5 {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
 h6, input, textarea, td, tr, p, label, select, option {
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
</head>
<body>
   <div class="container-fluid">
    <div class="row vh-100">
            <jsp:include page="sidebar.jsp"></jsp:include>
        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="text-dark" style="font-family: 'NeueHaasMedium', sans-serif;">Automated Scheduling</h1>
                <button class="buttonsBuilding d-flex align-items-center px-3 py-2 rounded-1 hover-outline " style="background-color: #fccc4c;" data-bs-toggle="modal" data-bs-target="#maintenanceModal">
                     <img src="resources/images/icons/autorenew.svg" alt="schedule" class="icon pe-2" style=" vertical-align: middle;" width="25" height="25"> Manage
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
                                <td>${maintenance.remarks}</td>
                                <td>${maintenance.noOfDaysWarning}</td>
                                <td>
                                <button class="btn btn-primary btn-sm" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#maintenanceModal"
                                        data-itemmsid="${maintenance.itemMsId}"
                                        data-itemtypeid="${maintenance.itemTypeId}"
                                        data-noofdays="${maintenance.noOfDays}"
                                        data-remarks="${maintenance.remarks}"
                                        data-qschedno="${maintenance.quarterlySchedNo}"
                                        data-yschedno="${maintenance.yearlySchedNo}"
                                        data-warning="${maintenance.noOfDaysWarning}">
                                    Edit
                                </button>
                                    <form action="maintenanceSave" method="POST" class="d-inline" >
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

            <!-- Maintenance Modal -->
            <div class="modal fade" id="maintenanceModal" tabindex="-1" aria-labelledby="maintenanceModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="maintenanceSave" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="maintenanceModalLabel">Manage Automated Scheduling</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="itemMsId" name="itemMsId">
                                
                                <!-- Item Type Dropdown -->
                                <div class="mb-3">
                                    <label for="itemTypeId" class="form-label">Item Type</label>
                                    <select class="form-select" id="itemTypeId" name="itemTypeId" required>
                                        <option value="" disabled selected>Select Item Type</option>
                                        <c:forEach var="typez" items="${FMO_TYPES_LIST}">
                                            <option value="${typez.itemTID}">${typez.itemType}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Number of Days -->
                                <div class="mb-3">
                                    <label for="noOfDays" class="form-label">Number of Days</label>
                                    <input 
                                        type="number" 
                                        class="form-control" 
                                        id="noOfDays" 
                                        name="noOfDays" 
                                        required 
                                        oninput="toggleQuarterlyOptions()">
                                </div>

                                <!-- Quarterly Options -->
                                <div id="quarterlyOptionsGroup" class="mb-3" style="display: none;">
                                    <label class="form-label">Quarterly Schedule</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" id="quarterly1" name="quarterlySchedule" value="1">
                                        <label class="form-check-label" for="quarterly1">January, April, July, October</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" id="quarterly2" name="quarterlySchedule" value="2">
                                        <label class="form-check-label" for="quarterly2">February, May, August, November</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" id="quarterly3" name="quarterlySchedule" value="3">
                                        <label class="form-check-label" for="quarterly3">March, June, September, December</label>
                                    </div>
                                </div>

                                <!-- Yearly Options -->
                                <div id="annualOptionsGroup" class="mb-3" style="display: none;">
                                    <label for="month" class="form-label">Month Schedule</label>
                                    <select id="month" name="yearlySchedule" class="form-select">
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
                                    <label for="remarks" class="form-label">Remarks</label>
                                    <input type="text" class="form-control" id="remarks" name="remarks">
                                </div>

                                <!-- Number of Days Warning -->
                                <div class="mb-3">
                                    <label for="noOfDaysWarning" class="form-label">Warning Days</label>
                                    <input type="number" class="form-control" id="noOfDaysWarning" name="noOfDaysWarning" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Close</button>
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

    // Prefill Modal with selected maintenance data
    const maintenanceModal = document.getElementById('maintenanceModal');
    maintenanceModal.addEventListener('show.bs.modal', event => {
        toggleQuarterlyOptions();
        const button = event.relatedTarget;
        const itemMsId = button.getAttribute('data-itemmsid');
        

        if (itemMsId) {
            // Edit mode
            document.getElementById('itemMsId').value = itemMsId;
            document.getElementById('itemTypeId').value = button.getAttribute('data-itemtypeid');
            document.getElementById('noOfDays').value = button.getAttribute('data-noofdays');
            const valueNOD = button.getAttribute('data-noofdays');
            document.getElementById('remarks').value = button.getAttribute('data-remarks');
            document.getElementById('noOfDaysWarning').value = button.getAttribute('data-warning');
            
            if (valueNOD == 90) {
                const qschedno = button.getAttribute('data-qschedno');
                document.querySelectorAll('[name="quarterlySchedule"]').forEach(radio => {
                    radio.checked = radio.value === qschedno;
                });
            } else if (valueNOD == 365 || valueNOD == 180) {
                const yschedno = button.getAttribute('data-yschedno');
                console.log("yschedno: "+yschedno);
                document.getElementById('month').value = yschedno;
            } else {
                console.log("when the days are varied lmaoooo");
            }
            toggleQuarterlyOptions(); // Ensure correct options are shown
        } else {
            // Add mode - clear the form
            document.getElementById('itemMsId').value = '';
            document.getElementById('itemTypeId').value = '';
            document.getElementById('noOfDays').value = '';
            document.getElementById('remarks').value = '';
            document.getElementById('noOfDaysWarning').value = '';
        }
    });

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

    // Handle archive confirmation with SweetAlert2
    $('form').on('submit', function(e) {
        if ($(this).find('input[name="action"][value="archive"]').length) {
            e.preventDefault();
            const form = this;
            
            Swal.fire({
                title: 'Are you sure?',
                text: "You want to archive this maintenance schedule?",
                icon: 'warning',
                showCancelButton: true,
            reverseButtons: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#ffffff', // keep white bg from SweetAlert defaults
            confirmButtonText: 'Confirm',
            cancelButtonText: 'Cancel',
            customClass: {
             cancelButton: 'btn-cancel-outline'
            }
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        }
    });
});

    function toggleQuarterlyOptions() {
        const value = document.getElementById('noOfDays').value;
        const quarterlyOptionsGroup = document.getElementById('quarterlyOptionsGroup');
        const annualOptionsGroup = document.getElementById('annualOptionsGroup');
    
        if (value == 90) {
            quarterlyOptionsGroup.style.display = 'block';
            annualOptionsGroup.style.display = 'none';
            document.getElementById('month').value = ""; 
        } else if (value == 365 || value == 180) {
            annualOptionsGroup.style.display = 'block';
            quarterlyOptionsGroup.style.display = 'none';
            document.querySelectorAll('[name="quarterlySchedule"]').forEach(radio => radio.checked = false);
        } else {
            quarterlyOptionsGroup.style.display = 'none';
            annualOptionsGroup.style.display = 'none';
            document.querySelectorAll('[name="quarterlySchedule"]').forEach(radio => radio.checked = false);
            document.getElementById('month').value = "";
        }
    }
    </script>
</body>
</html>