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
                <button class="btn btn-warning" data-toggle="modal" data-target="#maintenanceModal">
                    <i class="bi bi-plus-lg"></i> Add
                </button>
            </div>

            <!-- Maintenance List -->
            <table class="table table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>ITEM_MS_ID</th>
                        <th>ITEM_TYPE</th>
                        <th>NO_OF_DAYS</th>
                        <th>REMARKS</th>
                        <th>NO_OF_DAYS_WARNING</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="maintenance" items="${maintenanceList}">
                        <tr>
                            <td>${maintenance.itemMsId}</td>
                            <td>${maintenance.itemTypeId}</td>
                            <td>${maintenance.noOfDays}</td>
                            <td>${maintenance.remarks}</td>
                            <td>${maintenance.noOfDaysWarning}</td>
                            <td>
                                <button class="btn btn-sm btn-primary" 
                                    data-toggle="modal" 
                                    data-target="#maintenanceModal" 
                                    data-id="${maintenance.itemMsId}"
                                    data-item-type-id="${maintenance.itemTypeId}"
                                    data-no-of-days="${maintenance.noOfDays}"
                                    data-remarks="${maintenance.remarks}"
                                    data-warning="${maintenance.noOfDaysWarning}">
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
        <form action="maintenanceSave" method="post"> <!-- Form action for saving -->
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="maintenanceModalLabel">Maintenance Schedule</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- No input for itemMsId (Primary Key), auto-incremented in the database -->

                    <!-- Item Type Dropdown -->
                    <div class="form-group">
                        <label for="itemTypeId">Item Type</label>
                        <select class="form-control" id="itemTypeId" name="itemTypeId" required>
                            <option value="" disabled selected>Select Item Type</option>
                            <c:forEach var="itemType" items="${itemTypeList}">
                                <option value="${itemType.itemTypeId}">${itemType.itemTypeName} (${itemType.itemTypeId})</option>
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
    $('#maintenanceModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); 
        var itemMsId = button.data('id');
        var itemTypeId = button.data('item-type-id');
        var noOfDays = button.data('no-of-days');
        var remarks = button.data('remarks');
        var warning = button.data('warning');
        
        var modal = $(this);
        modal.find('.modal-body input#itemMsId').val(itemMsId);
        modal.find('.modal-body select#itemTypeId').val(itemTypeId);
        modal.find('.modal-body input#noOfDays').val(noOfDays);
        modal.find('.modal-body input#remarks').val(remarks);
        modal.find('.modal-body input#noOfDaysWarning').val(warning);
    });
</script>

</body>
</html>
