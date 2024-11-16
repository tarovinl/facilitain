<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance Schedule</title>

    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="d-flex vh-100">
    <!-- Sidebar Component -->
    <jsp:include page="sidebar.jsp"/>

    <!-- Main Content -->
    <div class="flex-grow-1 p-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1>Maintenance Schedule</h1>
                <!-- Trigger Modal Button -->
                <button class="btn btn-warning" data-toggle="modal" data-target="#maintenanceModal" onclick="clearModal()">
                    <i class="bi bi-plus-lg"></i> Add Schedule
                </button>
            </div>

            <!-- Maintenance List Table -->
            <table class="table table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Item Type</th>
                        <th>Number of Days</th>
                        <th>Remarks</th>
                        <th>Warning Days</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="maintenance" items="${maintenanceList}">
                        <tr>
                            <td>${maintenance.itemMsId}</td>
                            <td>${maintenance.itemTypeName}</td> <!-- Display name instead of ID -->
                            <td>${maintenance.noOfDays}</td>
                            <td>${maintenance.remarks}</td>
                            <td>${maintenance.noOfDaysWarning}</td>
                            <td>
                                <button class="btn btn-sm btn-primary" data-toggle="modal" 
                                        data-target="#maintenanceModal"
                                        onclick="editSchedule('${maintenance.itemMsId}', '${maintenance.itemTypeId}', '${maintenance.noOfDays}', '${maintenance.remarks}', '${maintenance.noOfDaysWarning}')">
                                    Edit
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Maintenance Modal -->
<div class="modal fade" id="maintenanceModal" tabindex="-1" role="dialog" aria-labelledby="maintenanceModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form action="maintenanceSave" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="maintenanceModalLabel">Add/Edit Maintenance Schedule</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Hidden field for itemMsId to determine add or edit -->
                    <input type="hidden" id="itemMsId" name="itemMsId">
                    
                    <!-- Item Type Dropdown -->
                    <div class="form-group">
                        <label for="itemTypeId">Item Type</label>
                        <select class="form-control" id="itemTypeId" name="itemTypeId" required>
                            <option value="" disabled>Select Item Type</option>
                            <c:forEach var="itemType" items="${itemTypeList}">
                                <option value="${itemType.itemTypeId}">${itemType.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Number of Days -->
                    <div class="form-group">
                        <label for="noOfDays">Number of Days</label>
                        <input type="number" class="form-control" id="noOfDays" name="noOfDays" required>
                    </div>

                    <!-- Remarks -->
                    <div class="form-group">
                        <label for="remarks">Remarks</label>
                        <input type="text" class="form-control" id="remarks" name="remarks" required>
                    </div>

                    <!-- Number of Days Warning -->
                    <div class="form-group">
                        <label for="noOfDaysWarning">Warning Days</label>
                        <input type="number" class="form-control" id="noOfDaysWarning" name="noOfDaysWarning" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>

<script>
    function editSchedule(itemMsId, itemTypeId, noOfDays, remarks, noOfDaysWarning) {
        document.getElementById("itemMsId").value = itemMsId;
        document.getElementById("itemTypeId").value = itemTypeId;
        document.getElementById("noOfDays").value = noOfDays;
        document.getElementById("remarks").value = remarks;
        document.getElementById("noOfDaysWarning").value = noOfDaysWarning;
    }

    function clearModal() {
        document.getElementById("itemMsId").value = "";
        document.getElementById("itemTypeId").value = "";
        document.getElementById("noOfDays").value = "";
        document.getElementById("remarks").value = "";
        document.getElementById("noOfDaysWarning").value = "";
    }
</script>

</body>
</html>
