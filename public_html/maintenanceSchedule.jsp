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
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
       
    
    <div class="col-md-10">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4 mt-5">
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
                            <td>${maintenance.itemTypeId}</td>
                            <td>${maintenance.noOfDays}</td>
                            <td>${maintenance.remarks}</td>
                            <td>${maintenance.noOfDaysWarning}</td>
                            <td>
                                <input type="image" 
                                        src="resources/images/editItem.svg" 
                                        alt="Open Modal" 
                                        width="24" 
                                        height="24" 
                                    data-toggle="modal" 
                                    data-target="#maintenanceModal" 
                                    data-id="${maintenance.itemMsId}"
                                    data-item-type-id="${maintenance.itemTypeId}"
                                    data-no-of-days="${maintenance.noOfDays}"
                                    data-remarks="${maintenance.remarks}"
                                    data-warning="${maintenance.noOfDaysWarning}">
                                   <!--<button> Edit
                                </button>-->
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
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

                    <input type="hidden" id="itemMsId" name="itemMsId">
                    
                    <!-- Item Type Dropdown -->
                    <div class="form-group">
                        <label for="itemTypeId">Item Type</label>
                        <select class="form-control" id="itemTypeId" name="itemTypeId" required>
                            <option value="" disabled selected>Select Item Type</option>
                            <c:forEach var="typez" items="${FMO_TYPES_LIST}">
                                <option value="${typez.itemTID}">${typez.itemType}</option>
                            </c:forEach>
                        </select>
                    </div>
<!-- Number of Days -->
<div class="form-group">
    <label for="noOfDays">Number of Days</label>
    <input 
        type="number" 
        class="form-control" 
        id="noOfDays" 
        name="noOfDays" 
        required 
        oninput="toggleQuarterlyOptions()">
</div>

<!-- Quarterly Options -->
<div id="quarterlyOptionsGroup" style="display: none;">
    <label>Quarterly Schedule</label>
    <div>
        <input type="radio" id="quarterly1" name="quarterlySchedule" value="1">
        <label for="quarterly1">January, April, July, October</label>
    </div>
    <div>
        <input type="radio" id="quarterly2" name="quarterlySchedule" value="2">
        <label for="quarterly2">February, May, August, November</label>
    </div>
    <div>
        <input type="radio" id="quarterly3" name="quarterlySchedule" value="3">
        <label for="quarterly3">March, June, September, December</label>
    </div>
</div>

<!-- Yearly Options -->
<div id="annualOptionsGroup" style="display: none;">
    <label for="month">Yearly Month Schedule</label>
    <select id="month" name="yearlySchedule" class="form-control">
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
                    <button type="submit" class="btn btn-warning fw-bold">Save</button>
                    <button type="button" class="btn btn-dark fw-bold text-warning" data-dismiss="modal">Cancel</button>
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

//     function editSchedule(itemMsId, itemTypeId, noOfDays, remarks, noOfDaysWarning) {
//         document.getElementById("itemMsId").value = itemMsId;
//         document.getElementById("itemTypeId").value = itemTypeId;
//         document.getElementById("noOfDays").value = noOfDays;
//         document.getElementById("remarks").value = remarks;
//         document.getElementById("noOfDaysWarning").value = noOfDaysWarning;
//     }

//     function clearModal() {
//         document.getElementById("itemMsId").value = "";
//         document.getElementById("itemTypeId").value = "";
//         document.getElementById("noOfDays").value = "";
//         document.getElementById("remarks").value = "";
//         document.getElementById("noOfDaysWarning").value = "";
//     }

 function toggleQuarterlyOptions() {
    const value = document.getElementById('noOfDays').value;
    const quarterlyOptionsGroup = document.getElementById('quarterlyOptionsGroup');
    const annualOptionsGroup = document.getElementById('annualOptionsGroup');

    if (value == 90) {
        quarterlyOptionsGroup.style.display = 'block';
        annualOptionsGroup.style.display = 'none';
        document.getElementById('month').value = ""; 
    } else if (value == 365) {
        annualOptionsGroup.style.display = 'block';
        quarterlyOptionsGroup.style.display = 'none';
        document.querySelectorAll('[name="quarterlySchedule"]').forEach(radio => radio.checked = false); // Clear quarterly selection
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
