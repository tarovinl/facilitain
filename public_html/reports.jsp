<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <style>
        .detail-content {
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 4px;
            margin: 0.5rem 0;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Reports</h1>
                <select id="statusFilter" class="form-select w-auto">
                    <option value="">All Status</option>
                    <option value="Resolved">Resolved</option>
                    <option value="Not Resolved">Not Resolved</option>
                </select>
            </div>

            <table id="reportsTable" class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Equipment Type</th>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${reportsList}">
                        <tr class="report-row" 
                            data-repfloor="${report.repfloor}"
                            data-reproom="${report.reproom}"
                            data-repissue="${report.repissue}"
                            data-report-id="${report.reportId}">
                            <td>${report.reportId}</td>
                            <td>${report.repEquipment}</td>
                            <td>${report.locName}</td>
                            <td><fmt:formatDate value="${report.recInstDt}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <span class="badge ${report.status == 1 ? 'bg-success' : 'bg-danger'}">
                                    ${report.status == 1 ? 'Resolved' : 'Not Resolved'}
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm toggle-details" data-bs-toggle="modal" data-bs-target="#detailsModal">Details</button>
                                <form action="emailresolve" method="post" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-sm btn-success">Resolve</button>
                                </form>
                                <form action="reports" method="post" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-sm btn-danger">Archive</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailsModalLabel">Report Details</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="detail-content">
            <strong>Floor:</strong> <span id="modalFloor">N/A</span><br>
            <strong>Room:</strong> <span id="modalRoom">N/A</span><br>
            <strong>Description:</strong> <span id="modalDescription">N/A</span><br>
            <form action="viewImage" method="get" target="_blank" class="mt-2">
                <input type="hidden" name="reportId" id="modalReportId">
                <button type="submit" class="btn btn-link p-0">View Proof</button>
            </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
$(document).ready(function() {
    // Initialize DataTable
    const table = $('#reportsTable').DataTable({
        order: [[3, 'desc']], // Sort by date
        pageLength: 10,
        columnDefs: [{
            targets: 5,
            orderable: false
        }]
    });

    // Function to format the details content and open the modal
    function openModal(row) {
        const floor = $(row).data('repfloor');
        const room = $(row).data('reproom');
        const description = $(row).data('repissue');
        const reportId = $(row).data('report-id');

        console.log('Details Data:', { floor, room, description, reportId });

        // Set modal content
        $('#modalFloor').text(floor || 'N/A');
        $('#modalRoom').text(room || 'N/A');
        $('#modalDescription').text(description || 'N/A');
        $('#modalReportId').val(reportId);
    }

    // Handle details button click
    $('#reportsTable tbody').on('click', '.toggle-details', function() {
        const tr = $(this).closest('tr');  // Get the clicked row
        openModal(tr);
    });

    // Custom status filter
    $('#statusFilter').on('change', function() {
        const selectedStatus = $(this).val();
        
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (!selectedStatus) return true;
            const status = $(table.row(dataIndex).node()).find('td:eq(4)').text().trim();
            return status === selectedStatus;
        });
        
        table.draw();
        $.fn.dataTable.ext.search.pop();
    });

    // Handle row details on page change and search
    table.on('page.dt search.dt', function() {
        // Hide modal if it's visible during table redraw
        $('#detailsModal').modal('hide');
    });
});
</script>

</body>
</html>
