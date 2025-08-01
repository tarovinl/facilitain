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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body, h1, h2, h3, h4, th {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h5, h6, input, textarea, td, tr, p, label, select, option {
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

        .responsive-padding-top {
                                  padding-top: 100px;
                                }
                                
                @media (max-width: 576px) {
                .responsive-padding-top {
                padding-top: 80px; /* or whatever smaller value you want */
                }
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

    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="container-fluid">
    <div class="row min-vh-100">
    <c:set var="page" value="reports" scope="request"/>
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 responsive-padding-top">
            <div class="d-flex justify-content-between align-items-center mb-3">
                 <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Reports</h1>
                
                    
                  
                    <button id="generateQRBtn" class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" style="background-color: #fccc4c;"><img src="resources/images/icons/qr.svg" alt="qr" width="25" height="25"><span class="d-none d-lg-inline ps-2">Download QR</span></button>
               
            </div>
            <select id="statusFilter" class="form-select w-auto mb-2">

                        <option value="">All Status</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Not Resolved">Not Resolved</option>
                    </select>

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
                                <form action="reports" method="post" style="display:inline;" class="archive-form">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-sm btn-danger archive-btn">Archive</button>
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
        const link = document.createElement('a');
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
        const tr = $(this).closest('tr');
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
        $('#detailsModal').modal('hide');
    });

    // Archive confirmation handler
    $(document).on('click', '.archive-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const form = $(this).closest('.archive-form')[0];
        const reportId = $(this).closest('form').find('input[name="reportId"]').val();
        
        Swal.fire({
            title: 'Are you sure?',
            text: `You want to archive report?`,
            icon: 'warning',
            showCancelButton: true,
            reverseButtons: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Confirm',
            cancelButtonText: 'Cancel',
            customClass: {
                cancelButton: 'btn-cancel-outline'
            },
            allowOutsideClick: false,
            allowEscapeKey: false
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        
        return false;
    });

    // Handle SweetAlert2 notifications for success/error messages
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
                        text: 'The report has been successfully archived.',
                        icon: 'success'
                    };
                    break;
                case 'resolved':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Resolved!',
                        text: 'The report has been successfully resolved.',
                        icon: 'success'
                    };
                    break;
            }
        }
        
        Swal.fire(alertConfig).then(() => {
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        });
    }
});
</script>
</body>
</html>