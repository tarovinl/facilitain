<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance Schedule</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
</head>
<body>
   <div class="container-fluid">
    <div class="row vh-100">
        <div class="col-md-3 col-lg-2 p-0">
            <jsp:include page="sidebar.jsp"></jsp:include>
        </div>
        <div class="col-md-9 col-lg-10 p-4">
            <div class="d-flex justify-content-between align-items-center">
                <h1 class="text-primary" style="font-family: 'NeueHaasMedium', sans-serif;">Maintenance Schedule</h1>
                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#maintenanceModal">
                    <i class="bi bi-plus-lg"></i> Add Schedule
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
                                            data-warning="${maintenance.noOfDaysWarning}">
                                        Edit
                                    </button>
                                    <form action="maintenanceSave" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to archive this maintenance schedule?');">
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
                                <h5 class="modal-title" id="maintenanceModalLabel">Add/Edit Maintenance Schedule</h5>
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
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
                const button = event.relatedTarget;
                const itemMsId = button.getAttribute('data-itemmsid');

                if (itemMsId) {
                    // Edit mode
                    document.getElementById('itemMsId').value = itemMsId;
                    document.getElementById('itemTypeId').value = button.getAttribute('data-itemtypeid');
                    document.getElementById('noOfDays').value = button.getAttribute('data-noofdays');
                    document.getElementById('remarks').value = button.getAttribute('data-remarks');
                    document.getElementById('noOfDaysWarning').value = button.getAttribute('data-warning');
                } else {
                    // Add mode - clear the form
                    document.getElementById('itemMsId').value = '';
                    document.getElementById('itemTypeId').value = '';
                    document.getElementById('noOfDays').value = '';
                    document.getElementById('remarks').value = '';
                    document.getElementById('noOfDaysWarning').value = '';
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