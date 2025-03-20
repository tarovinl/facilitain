<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Maintenance Dashboard</title>
  
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
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 style="font-family: 'NeueHaasMedium', sans-serif; font-size: 4rem; line-height: 1.2;">Maintenance</h1>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'Admin' || sessionScope.role == 'Maintenance'}">
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addMaintenanceModal">
                                    <i class="bi bi-plus-lg"></i> Make a Maintenance
                                </button>
                            </c:when>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Maintenance Dashboard Panels -->
                <div class="row">
                    <!-- Maintenance List Panel -->
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">Maintenance</h5>
                            </div>
                            <div class="card-body">
                                <table id="maintenanceTable" class="table table-hover" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>Equipment</th>
                                            <th>Status</th>
                                            <th>Date Notified</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Static data for demonstration -->
                                        <tr>
                                            <td>Fire Extinguisher</td>
                                            <td>In Progress</td>
                                            <td>02/03/2025</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="1">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Aircon</td>
                                            <td>Needs Maintenance</td>
                                            <td>02/03/2025</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="2">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Elevator</td>
                                            <td>Completed</td>
                                            <td>01/25/2025</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="3">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>HVAC System</td>
                                            <td>Pending Parts</td>
                                            <td>01/15/2025</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="4">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Plumbing System</td>
                                            <td>In Progress</td>
                                            <td>03/02/2025</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-secondary view-details" data-id="5">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Maintain Details Panel -->
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif;">Maintain</h5>
                            </div>
                            <div class="card-body">
                                <!-- Static equipment details -->
                                <div id="equipmentDetails">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Equipment</label>
                                        <div>Fire Extinguisher</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Serial Number</label>
                                        <div>09222222 (serial)</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Brand Model</label>
                                        <div>09222222 (serial)</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Location</label>
                                        <div>Building</div>
                                    </div>
                                    <div class="d-grid gap-2 mt-4">
                                        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                            Update Status
                                        </button>
                                    </div>
                                </div>
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
                        <label for="equipmentId" class="form-label">Equipment</label>
                        <select class="form-select" id="equipmentId" name="equipmentId" required>
                            <option value="" selected disabled>Select Equipment</option>
                            <!-- Static options -->
                            <option value="1">Fire Extinguisher</option>
                            <option value="2">Aircon</option>
                            <option value="3">Elevator</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="maintenanceType" class="form-label">Maintenance Type</label>
                        <select class="form-select" id="maintenanceType" name="maintenanceType" required>
                            <option value="" selected disabled>Select Type</option>
                            <option value="Routine">Routine Maintenance</option>
                            <option value="Repair">Repair</option>
                            <option value="Replacement">Replacement</option>
                            <option value="Inspection">Inspection</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" placeholder="Enter maintenance details"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Submit</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="updatestatuscontroller" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateStatusModalLabel">Update Maintenance Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="updateEquipmentId" name="equipmentId" value="1">
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="" selected disabled>Select Status</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                            <option value="Needs Replacement">Needs Replacement</option>
                            <option value="Pending Parts">Pending Parts</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="notes" class="form-label">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter status notes"></textarea>
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
        $('#maintenanceTable').DataTable({
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
            columnDefs: [
                { targets: -1, orderable: false } // Disable sorting for the actions column
            ]
        });

        // Handle view details button clicks
        $('.view-details').on('click', function() {
            const equipmentId = $(this).data('id');
            // In a real application, you would fetch the details via AJAX
            // For this example, we'll just update the hidden input in the update modal
            $('#updateEquipmentId').val(equipmentId);
            
            // Here you would typically update the equipment details panel
            // with data from the server based on the equipmentId
        });
    });
</script>

</body>
</html>