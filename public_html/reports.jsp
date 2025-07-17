<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
     <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
    
    body, h1, h2, h3, h4, th {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
h5, h6, input, textarea, td, tr, p, label, select, option {
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
    
        .detail-content {
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 4px;
            margin: 0.5rem 0;
        }
        
        .similar-report-indicator {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 3px;
            padding: 2px 6px;
            font-size: 0.75rem;
            color: #856404;
            margin-left: 5px;
            display: inline-block;
        }
        
        .similar-report-icon {
            color: #f39c12;
            margin-right: 3px;
        }

        .qr-button {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .qr-button:hover {
            background-color: #5a6268;
            color: white;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
    <c:set var="page" value="reports" scope="request"/>
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Reports</h1>
                <div class="d-flex gap-2">
                    
                    <select id="statusFilter" class="form-select w-auto">
                        <option value="">All Status</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Not Resolved">Not Resolved</option>
                    </select>
                    <button id="generateQRBtn" class="px-3 py-2 rounded-1 hover-outline d-flex align-items-center" style="background-color: #fccc4c;"><img src="resources/images/icons/qr.svg" class="pe-2" alt="qr" width="25" height="25">Download QR</button>
                </div>
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
                            <td>
                                ${report.repEquipment}
                                <c:if test="${hasSimilarReports[report.reportId] && report.status == 0}">
                                    <span class="similar-report-indicator" title="Similar unresolved reports exist">
                                        <i class="similar-report-icon">⚠</i>Similar
                                    </span>
                                </c:if>
                            </td>
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

    // QR Code download functionality
    $('#generateQRBtn').on('click', function() {
        // Create a temporary anchor element to trigger download
        const link = document.createElement('a');
        // Use relative path instead of absolute path
        link.href = './resources/images/report-qr.png'; 
        link.download = 'report-qr.png';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
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