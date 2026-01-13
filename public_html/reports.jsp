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
    <link href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">     
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
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

        .detail-content span {
            word-wrap: break-word;
            word-break: break-word;
            white-space: pre-wrap;
            display: inline-block;
            max-width: 100%;
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
                padding-top: 80px;
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

        .chart-container {
            height: 400px;
        }

        
        .table-container {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            padding: 1.5rem;
            padding-bottom: 2.5rem;
            margin-top: 1rem;
        }
        
        .detail-content strong {
            font-family: 'NeueHaasMedium', sans-serif !important;
            font-weight: 600;
        }

        .detail-content span {
            font-family: 'NeueHaasLight', sans-serif !important;
            font-weight: normal !important;
        }

        .table-responsive {
            border: none;
            border-radius: 6px;
            margin-bottom: 1.5rem;
        }

        #reportsTable {
            border: 1px solid #e9ecef;
            border-radius: 6px;
            overflow: hidden;
        }

        #reportsTable thead th {
            padding: 1rem 1.25rem;
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        #reportsTable tbody td {
            padding: 1.25rem 1.25rem;
            vertical-align: middle;
            border-bottom: 1px solid #e9ecef;
        }

        #reportsTable tbody tr:last-child td {
            border-bottom: none;
        }

        #reportsTable tbody tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }

        .filters-section {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-group {
            margin-bottom: 1rem;
        }

        .filter-group:last-child {
            margin-bottom: 0;
        }

        .filter-label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #495057;
            display: block;
        }

        .form-select, .form-control {
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 0.75rem 1rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-select:focus, .form-control:focus {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 1.5rem;
        }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            margin-top: 1.5rem;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.5rem 1rem;
            margin: 0 2px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #0d6efd;
            color: white !important;
            border-color: #0d6efd;
        }

        @media (max-width: 768px) {
            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_filter {
                text-align: center;
                margin-bottom: 1rem;
            }
            
            .dataTables_wrapper .dataTables_info,
            .dataTables_wrapper .dataTables_paginate {
                text-align: center;
                margin-top: 1rem;
            }
            
            .table-responsive {
                border: none;
            }
            
            
            .btn-group-mobile {
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
            }
            
            .btn-group-mobile .btn {
                font-size: 0.75rem;
                padding: 0.25rem 0.5rem;
            }

            .filters-section {
                padding: 1rem;
            }

            .filter-row {
                flex-direction: column;
            }

            .filter-group {
                margin-bottom: 1rem;
            }
        }

        @media (max-width: 576px) {
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .similar-report-indicator {
                display: block;
                margin: 0.25rem 0;
                font-size: 0.7rem;
            }
            
            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
                min-width: 120px;
            }
            
            .action-buttons .btn {
                font-size: 0.7rem;
                padding: 0.2rem 0.4rem;
            }

            #reportsTable thead th,
            #reportsTable tbody td {
                padding: 0.75rem 0.5rem;
            }
        }

        @media (max-width: 576px) {
            .modal-dialog {
                margin: 0.5rem;
                max-width: calc(100% - 1rem);
            }
            
            .modal-body {
                padding: 1rem 0.75rem;
            }
        }

        table.dataTable.dtr-inline.collapsed > tbody > tr > td.child,
        table.dataTable.dtr-inline.collapsed > tbody > tr > th.child,
        table.dataTable.dtr-inline.collapsed > tbody > tr > td.dataTables_empty {
            cursor: default !important;
        }
        
        table.dataTable.dtr-inline.collapsed > tbody > tr > td.child {
            padding: 0.75rem 1rem;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }
        
        table.dataTable.dtr-inline.collapsed > tbody > tr.child ul.dtr-details {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        
        table.dataTable.dtr-inline.collapsed > tbody > tr.child ul.dtr-details li {
            border-bottom: 1px solid #e9ecef;
            padding: 0.5rem 0;
        }
        
        table.dataTable.dtr-inline.collapsed > tbody > tr.child ul.dtr-details li:last-child {
            border-bottom: none;
        }

        .sort-btn {
            background: none;
            border: 1px solid #dee2e6;
            padding: 0.25rem 0.75rem;
            margin: 0 0.1rem;
            border-radius: 4px;
            color: #6c757d;
            transition: all 0.2s ease;
        }

        .sort-btn:hover {
            background-color: #e9ecef;
            color: #495057;
        }

        .sort-btn.active {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        
        .resolve-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                 <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Reports</h1>
                
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" style="background-color: #fccc4c;" id="generate-report" ${empty reportsList ? 'disabled' : ''}> 
                        <img src="resources/images/icons/summarize.svg" alt="generate report icon" width="25" height="25">
                        <span class="d-none d-lg-inline ps-2">Generate Report</span>
                    </button>
                    <button id="generateQRBtn" class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" style="background-color: #fccc4c;">
                        <img src="resources/images/icons/qr.svg" alt="qr" width="25" height="25">
                        <span class="d-none d-lg-inline ps-2">Download QR</span>
                    </button>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="row mb-4">
                <div class="col-lg-8 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Top 5 Most Reported Locations</h5>
                            <div id="locationChart" class="chart-container"></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Top 10 Unresolved Reports by Equipment</h5>
                            <div id="equipmentChart" class="chart-container"></div>
                        </div>
                    </div>
                </div>
            </div>

            
            <div class="table-container">
                <div class="filters-section">
                    <h6 class="mb-3">Filters & Sorting</h6>
                    <div class="row filter-row">
                        <div class="col-md-3 filter-group">
                            <label class="filter-label">Status</label>
                            <select id="statusFilter" class="form-select">
                                <option value="">All Status</option>
                                <option value="Resolved">Resolved</option>
                                <option value="Not Resolved">Not Resolved</option>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label class="filter-label">Similar Reports</label>
                            <select id="similarFilter" class="form-select">
                                <option value="">All Reports</option>
                                <option value="similar">Similar Reports Only</option>
                                <option value="unique">Unique Reports Only</option>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label class="filter-label">Equipment Type</label>
                            <select id="equipmentFilter" class="form-select">
                                <option value="">All Equipment</option>
                                <c:forEach var="report" items="${reportsList}">
                                    <option value="${report.repEquipment}">${report.repEquipment}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label class="filter-label">Date Sorting</label>
                            <div class="d-flex gap-1">
                                <button type="button" class="sort-btn flex-fill" id="sortDateAsc">
                                    Oldest
                                </button>
                                <button type="button" class="sort-btn flex-fill active" id="sortDateDesc">
                                    Newest
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12">
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="clearFilters">
                                Clear All Filters
                            </button>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
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
                                    data-report-id="${report.reportId}"
                                    data-equipment="${report.repEquipment}"
                                    data-has-similar="${hasSimilarReports[report.reportId] && report.status == 0 ? 'true' : 'false'}">
                                    <td><strong>#${report.reportId}</strong></td>
                                    <td>
                                        ${report.repEquipment}
                                        <c:if test="${hasSimilarReports[report.reportId] && report.status == 0}">
                                            <span class="similar-report-indicator" title="Similar unresolved reports exist">
                                                <i class="similar-report-icon">⚠</i>Similar
                                            </span>
                                        </c:if>
                                    </td>
                                    <td>${report.locName}</td>
                                    <td><fmt:formatDate value="${report.recInstDt}" pattern="MMM dd, yyyy"/></td>
                                    <td>
                                        <span class="badge ${report.status == 1 ? 'bg-success' : 'bg-danger'} px-3 py-2">
                                            ${report.status == 1 ? 'Resolved' : 'Not Resolved'}
                                        </span>
                                    </td>
                                                                   <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-info btn-sm toggle-details" data-bs-toggle="modal" data-bs-target="#detailsModal">
                                            Details
                                        </button>
                                        
                                        <form action="emailresolve" method="post" style="display:inline;" class="resolve-form">
                                            <input type="hidden" name="reportId" value="${report.reportId}">
                                            <button type="button" class="btn btn-sm btn-success resolve-btn" 
                                                    ${report.status == 1 ? 'disabled' : ''}>
                                                Resolve
                                            </button>
                                        </form>
                                        <form action="reports" method="post" style="display:inline;" class="archive-form">
                                            <input type="hidden" name="reportId" value="${report.reportId}">
                                            <button type="submit" class="btn btn-sm btn-danger archive-btn">
                                                Archive
                                            </button>
                                        </form>
                                    </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
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
                 <div class="mb-2">
                    <strong>Floor:</strong> <span id="modalFloor" style="font-weight: normal;">N/A</span>
                </div>
                <div class="mb-2">
                    <strong>Room:</strong> <span id="modalRoom" style="font-weight: normal;">N/A</span>
                </div>
                <div>
                    <strong>Description:</strong><br>
                    <span id="modalDescription" class="d-block mt-1" style="font-weight: normal;">N/A</span>
                </div>
            </div>
            </div>
            <div class="modal-footer justify-content-end">
              <form action="viewImage" method="get" target="_blank">
                  <input type="hidden" name="reportId" id="modalReportId">
                  <button type="submit" class="btn btn-primary">
                      <i class="bi bi-image"></i> View Image Proof
                  </button>
              </form>
            </div>
        </div>
  </div>
</div>

<!-- Date Range Modal -->
<div class="modal fade" id="dateRangeModal" tabindex="-1" aria-labelledby="dateRangeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="dateRangeModalLabel">Generate Report</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Select Report Type:</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportType" id="allReports" value="all" checked>
                        <label class="form-check-label" for="allReports">
                            All Reports (No Date Filter)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportType" id="dateRangeReports" value="range">
                        <label class="form-check-label" for="dateRangeReports">
                            Custom Date Range
                        </label>
                    </div>
                </div>
                
                <div id="dateRangeInputs" style="display: none;">
                    <div class="mb-3">
                        <label for="startDate" class="form-label">Start Date</label>
                        <input type="date" class="form-control" id="startDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">End Date</label>
                        <input type="date" class="form-control" id="endDate" required>
                    </div>
                    <div id="dateError" class="text-danger small" style="display: none;">
                        End date must be after start date
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel-outline" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="generateReportBtn">Generate Report</button>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

<script>
google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(drawCharts);

let locationChart, equipmentChart;

function drawCharts() {
    drawLocationChart();
    drawEquipmentChart();
}

function drawLocationChart() {
    const chartDiv = document.getElementById('locationChart');
    
    if (${empty locationReports}) {
        chartDiv.innerHTML = '<div class="text-center p-5">' +
                             '<i class="bi bi-exclamation-circle fs-1 text-muted"></i>' +
                             '<h6 class="mt-3">No reports data available</h6>' +
                             '<p class="text-muted small">Chart will appear when reports are submitted.</p>' +
                             '</div>';
        locationChart = { getImageURI: () => createNoDataCanvas(chartDiv) };
        return;
    }
    
    const data = google.visualization.arrayToDataTable([
        ['Location', 'Number of Reports'],
        <c:forEach var="locationData" items="${locationReports}">
            ['${locationData.key}', ${locationData.value}],
        </c:forEach>
    ]);

    const options = {
        title: '',
        hAxis: { 
            title: 'Number of Reports',
            minValue: 0
        },
        vAxis: { 
            title: 'Location'
        },
        colors: ['#4285f4'],
        legend: 'none',
        chartArea: { left: 120, top: 50, width: '65%', height: '80%' }
    };

    locationChart = new google.visualization.BarChart(chartDiv);
    locationChart.draw(data, options);
}

function drawEquipmentChart() {
    const chartDiv = document.getElementById('equipmentChart');
    
    if (${empty equipmentReports}) {
        chartDiv.innerHTML = '<div class="text-center p-5">' +
                             '<i class="bi bi-exclamation-circle fs-1 text-muted"></i>' +
                             '<h6 class="mt-3">No unresolved reports</h6>' +
                             '<p class="text-muted small">Chart will appear when unresolved reports are submitted.</p>' +
                             '</div>';
        equipmentChart = { getImageURI: () => createNoDataCanvas(chartDiv) };
        return;
    }
    
    const data = google.visualization.arrayToDataTable([
        ['Equipment Type', 'Number of Reports'],
        <c:forEach var="equipmentData" items="${equipmentReports}">
            ['${equipmentData.key}', ${equipmentData.value}],
        </c:forEach>
    ]);

    const options = {
        title: 'Top 10 Unresolved Reports by Equipment',
        pieHole: 0.4,
        colors: ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57', '#ff9ff3', '#54a0ff', '#c7ecee', '#778beb', '#f8a5c2'],
        legend: { position: 'bottom', textStyle: { fontSize: 12 } },
        chartArea: { left: 20, top: 50, width: '90%', height: '70%' }
    };

    equipmentChart = new google.visualization.PieChart(chartDiv);
    equipmentChart.draw(data, options);
}

function createNoDataCanvas(container) {
    const canvas = document.createElement('canvas');
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#f8f9fa';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = '#6c757d';
    ctx.font = '16px Arial';
    ctx.textAlign = 'center';
    ctx.fillText('No reports data available', canvas.width/2, canvas.height/2);
    return canvas.toDataURL();
}

$(document).ready(function() {
    const table = $('#reportsTable').DataTable({
        order: [[3, 'desc']],
        pageLength: 10,
        responsive: {
            details: {
                type: 'column',
                target: 'tr'
            }
        },
        columnDefs: [
            {
                targets: 5,
                orderable: false
            },
            {
                targets: 0,
                className: 'control',
                responsivePriority: 1
            },
            {
                targets: 1,
                responsivePriority: 2
            },
            {
                targets: 4,
                responsivePriority: 3
            },
            {
                targets: 5,
                responsivePriority: 1
            },
            {
                targets: [2, 3],
                responsivePriority: 10000
            }
        ],
        language: {
            paginate: {
                previous: '<i class="bi bi-chevron-left"></i>',
                next: '<i class="bi bi-chevron-right"></i>'
            },
            info: "Showing _START_ to _END_ of _TOTAL_ reports",
            infoEmpty: "No reports available",
            infoFiltered: "(filtered from _MAX_ total reports)"
        },
        lengthMenu: [
            [5, 10, 25, 50],
            [5, 10, 25, 50]
        ]
    });

    if ($(window).width() < 768) {
        table.page.len(5).draw();
    }

    $(window).on('resize', function() {
        table.columns.adjust().responsive.recalc();
        
        if ($(window).width() < 768 && table.page.len() > 5) {
            table.page.len(5).draw();
        } else if ($(window).width() >= 768 && table.page.len() === 5) {
            table.page.len(10).draw();
        }
    });

    function applyFilters() {
        table.draw();
    }

    $('#statusFilter').on('change', function() {
        const selectedStatus = $(this).val();
        
        if (!selectedStatus) {
            table.column(4).search('').draw();
        } else {
            $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
                const row = table.row(dataIndex).node();
                const statusBadge = $(row).find('td:eq(4) .badge').text().trim();
                
                if (!selectedStatus) return true;
                return statusBadge === selectedStatus;
            });
            table.draw();
            $.fn.dataTable.ext.search.pop();
        }
    });

    $('#similarFilter').on('change', function() {
        const filterValue = $(this).val();
        
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (!filterValue) return true;
            
            const row = table.row(dataIndex).node();
            const hasSimilar = $(row).data('has-similar') === 'true';
            
            if (filterValue === 'similar') {
                return hasSimilar;
            } else if (filterValue === 'unique') {
                return !hasSimilar;
            }
            return true;
        });
        
        table.draw();
        $.fn.dataTable.ext.search.pop();
    });

    $('#equipmentFilter').on('change', function() {
        const selectedEquipment = $(this).val();
        table.column(1).search(selectedEquipment).draw();
    });

    $('#sortDateAsc').on('click', function() {
        $('.sort-btn').removeClass('active');
        $(this).addClass('active');
        table.order([3, 'asc']).draw();
    });

    $('#sortDateDesc').on('click', function() {
        $('.sort-btn').removeClass('active');
        $(this).addClass('active');
        table.order([3, 'desc']).draw();
    });

    $('#clearFilters').on('click', function() {
        $('#statusFilter, #similarFilter, #equipmentFilter').val('');
        
        $('.sort-btn').removeClass('active');
        $('#sortDateDesc').addClass('active');
        
        table.search('').columns().search('').order([3, 'desc']).draw();
        
        $.fn.dataTable.ext.search = [];
    });

    function populateEquipmentFilter() {
        const equipmentTypes = new Set();
        table.rows().every(function() {
            const row = this.node();
            const equipment = $(row).data('equipment');
            if (equipment) {
                equipmentTypes.add(equipment);
            }
        });
        
        const select = $('#equipmentFilter');
        select.find('option:not(:first)').remove();
        
        Array.from(equipmentTypes).sort().forEach(equipment => {
            select.append(new Option(equipment, equipment));
        });
    }

    populateEquipmentFilter();

    
$('#generate-report').on('click', function() {
    // Show the modal instead of directly generating report
    const dateModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    dateModal.show();
});

// Handle report type selection
document.querySelectorAll('input[name="reportType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const dateInputs = document.getElementById('dateRangeInputs');
        if (this.value === 'range') {
            dateInputs.style.display = 'block';
            document.getElementById('startDate').required = true;
            document.getElementById('endDate').required = true;
        } else {
            dateInputs.style.display = 'none';
            document.getElementById('startDate').required = false;
            document.getElementById('endDate').required = false;
            document.getElementById('dateError').style.display = 'none';
        }
    });
});

// Validate dates
function validateDates() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    const dateError = document.getElementById('dateError');
    
    if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
        dateError.style.display = 'block';
        return false;
    }
    dateError.style.display = 'none';
    return true;
}

document.getElementById('startDate').addEventListener('change', validateDates);
document.getElementById('endDate').addEventListener('change', validateDates);

// Generate report button
document.getElementById('generateReportBtn').addEventListener('click', function() {
    const reportType = document.querySelector('input[name="reportType"]:checked').value;
    
    if (reportType === 'range') {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        
        if (!startDate || !endDate) {
            Swal.fire({
                icon: 'error',
                title: 'Missing Dates',
                text: 'Please select both start and end dates'
            });
            return;
        }
        
        if (!validateDates()) {
            return;
        }
        
        // Close modal and generate filtered report
        bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
        generateFilteredReport(new Date(startDate), new Date(endDate));
    } else {
        // Close modal and generate full report
        bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
        generateFullReport();
    }
});

// Function to filter reports by date range
function filterReportsByDateRange(startDate, endDate) {
    const reportRows = document.querySelectorAll('#reportsTable tbody tr');
    const filteredData = [];
    
    reportRows.forEach(row => {
        const dateCell = row.querySelectorAll('td')[3].textContent.trim();
        const rowDate = new Date(dateCell);
        
        if (rowDate >= startDate && rowDate <= endDate) {
            const cells = row.querySelectorAll('td');
            filteredData.push({
                id: cells[0].textContent.trim(),
                equipment: cells[1].textContent.trim().replace(/\s*⚠\s*Similar\s*/g, ''),
                location: cells[2].textContent.trim(),
                date: cells[3].textContent.trim(),
                status: cells[4].textContent.trim()
            });
        }
    });
    
    return filteredData;
}

// Function to calculate statistics for date range
function calculateStatsForDateRange(startDate, endDate) {
    const reportRows = document.querySelectorAll('#reportsTable tbody tr');
    let totalReports = 0;
    let unresolvedCount = 0;
    let resolvedCount = 0;
    const locationCounts = {};
    const equipmentCounts = {};
    const monthlyData = {};
    
    reportRows.forEach(row => {
        const dateCell = row.querySelectorAll('td')[3].textContent.trim();
        const rowDate = new Date(dateCell);
        
        if (rowDate >= startDate && rowDate <= endDate) {
            totalReports++;
            
            const statusBadge = row.querySelector('td:nth-child(5) .badge');
            if (statusBadge.textContent.includes('Resolved') && !statusBadge.textContent.includes('Not')) {
                resolvedCount++;
            } else {
                unresolvedCount++;
                // Count equipment for unresolved only
                const equipment = row.querySelectorAll('td')[1].textContent.trim().replace(/\s*⚠\s*Similar\s*/g, '');
                equipmentCounts[equipment] = (equipmentCounts[equipment] || 0) + 1;
            }
            
            // Count locations
            const location = row.querySelectorAll('td')[2].textContent.trim();
            locationCounts[location] = (locationCounts[location] || 0) + 1;
            
            // Count monthly
            const monthYear = rowDate.toLocaleString('default', { month: 'short', year: 'numeric' });
            monthlyData[monthYear] = (monthlyData[monthYear] || 0) + 1;
        }
    });
    
    // Convert to sorted arrays
    const sortedLocations = Object.entries(locationCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5);
    
    const sortedEquipment = Object.entries(equipmentCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 10);
    
    const sortedMonthly = Object.entries(monthlyData);
    
    return {
        total: totalReports,
        unresolved: unresolvedCount,
        resolved: resolvedCount,
        locations: sortedLocations,
        equipment: sortedEquipment,
        monthly: sortedMonthly
    };
}

// Function to draw filtered pie chart
function drawFilteredPieChart(equipmentData) {
    return new Promise((resolve) => {
        if (equipmentData.length === 0) {
            resolve(null);
            return;
        }
        
        const chartDiv = document.createElement('div');
        chartDiv.style.width = '800px';
        chartDiv.style.height = '400px';
        chartDiv.style.position = 'absolute';
        chartDiv.style.left = '-9999px';
        document.body.appendChild(chartDiv);
        
        const dataArray = [['Equipment Type', 'Number of Reports']];
        equipmentData.forEach(([equipment, count]) => {
            dataArray.push([equipment, count]);
        });
        
        const data = google.visualization.arrayToDataTable(dataArray);
        
        const options = {
            pieHole: 0.4,
            colors: ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57', '#ff9ff3', '#54a0ff', '#c7ecee', '#778beb', '#f8a5c2'],
            legend: { 
                position: 'right',
                textStyle: { fontSize: 10 },
                maxLines: 10
            },
            chartArea: { left: 20, top: 30, width: '90%', height: '100%' },
            width: 800,
            height: 400
        };
        
        const tempChart = new google.visualization.PieChart(chartDiv);
        
        google.visualization.events.addListener(tempChart, 'ready', function() {
            html2canvas(chartDiv, {
                backgroundColor: '#ffffff',
                scale: 2
            }).then(canvas => {
                const imgURI = canvas.toDataURL('image/png');
                document.body.removeChild(chartDiv);
                resolve(imgURI);
            });
        });
        
        tempChart.draw(data, options);
    });
}

// Function to draw filtered bar chart
function drawFilteredBarChart(locationData) {
    return new Promise((resolve) => {
        if (locationData.length === 0) {
            resolve(null);
            return;
        }
        
        const chartDiv = document.createElement('div');
        chartDiv.style.width = '800px';
        chartDiv.style.height = '400px';
        chartDiv.style.position = 'absolute';
        chartDiv.style.left = '-9999px';
        document.body.appendChild(chartDiv);
        
        const dataArray = [['Location', 'Number of Reports']];
        locationData.forEach(([location, count]) => {
            dataArray.push([location, count]);
        });
        
        const data = google.visualization.arrayToDataTable(dataArray);
        
        const options = {
            hAxis: { 
                title: 'Number of Reports',
                minValue: 0
            },
            vAxis: { 
                title: 'Location'
            },
            colors: ['#4285f4'],
            legend: 'none',
            chartArea: { left: 120, top: 50, width: '65%', height: '80%' },
            width: 800,
            height: 400
        };
        
        const tempChart = new google.visualization.BarChart(chartDiv);
        
        google.visualization.events.addListener(tempChart, 'ready', function() {
            html2canvas(chartDiv, {
                backgroundColor: '#ffffff',
                scale: 2
            }).then(canvas => {
                const imgURI = canvas.toDataURL('image/png');
                document.body.removeChild(chartDiv);
                resolve(imgURI);
            });
        });
        
        tempChart.draw(data, options);
    });
}

// Generate filtered report
async function generateFilteredReport(startDate, endDate) {
    const filteredReports = filterReportsByDateRange(startDate, endDate);
    const stats = calculateStatsForDateRange(startDate, endDate);
    
    if (filteredReports.length === 0) {
        Swal.fire({
            icon: 'info',
            title: 'No Data',
            text: 'No reports found in the selected date range'
        });
        return;
    }
    
    // Generate chart images for filtered data
    const pieChartImage = await drawFilteredPieChart(stats.equipment);
    const barChartImage = await drawFilteredBarChart(stats.locations);
    
    generatePDFWithDateRange(filteredReports, stats, startDate, endDate, pieChartImage, barChartImage);
}

// Generate full report (your original PDF generation code)
function generateFullReport() {
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('p', 'mm', 'a4');
    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 15;
    let yPosition = 20;

    // Get current date and time
    const now = new Date();
    const reportDate = now.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
    const reportTime = now.toLocaleTimeString('en-US', { 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: true 
    });

    // Helper function to check if we need a new page
    function checkPageBreak(requiredSpace) {
        if (yPosition + requiredSpace > pageHeight - margin - 20) {
            pdf.addPage();
            yPosition = margin + 30;
            return true;
        }
        return false;
    }

    // Helper function to draw table
    function drawTable(headers, data, startY) {
        const tableWidth = pageWidth - (2 * margin);
        const colWidth = tableWidth / headers.length;
        const rowHeight = 8;
        let currentY = startY;

        // Draw header with dark grey background 
        pdf.setFillColor(51, 51, 51);
        pdf.setTextColor(255, 255, 255);
        pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
        
        pdf.setFontSize(10);
        pdf.setFont('helvetica', 'bold');
        headers.forEach((header, i) => {
            pdf.text(header, margin + (i * colWidth) + 2, currentY + 5.5);
        });
        
        currentY += rowHeight;
        pdf.setTextColor(0, 0, 0);

        // Draw data rows
        pdf.setFont('helvetica', 'normal');
        data.forEach((row, rowIndex) => {
            if (currentY + rowHeight > pageHeight - margin - 20) {
                pdf.addPage();
                currentY = margin + 30;
                
                // Redraw header on new page
                pdf.setFillColor(51, 51, 51);
                pdf.setTextColor(255, 255, 255);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
                pdf.setFont('helvetica', 'bold');
                headers.forEach((header, i) => {
                    pdf.text(header, margin + (i * colWidth) + 2, currentY + 5.5);
                });
                currentY += rowHeight;
                pdf.setTextColor(0, 0, 0);
                pdf.setFont('helvetica', 'normal');
            }

            // Alternate row colors
            if (rowIndex % 2 === 0) {
                pdf.setFillColor(245, 245, 245);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
            }

            // Draw cell borders and text
            row.forEach((cell, i) => {
                pdf.rect(margin + (i * colWidth), currentY, colWidth, rowHeight);
                pdf.text(String(cell), margin + (i * colWidth) + 2, currentY + 5.5);
            });
            
            currentY += rowHeight;
        });

        return currentY;
    }

    // Helper function to add footer
    function addFooter() {
        const footerY = pageHeight - 10;
        pdf.setFontSize(8);
        pdf.setFont('helvetica', 'italic');
        pdf.setTextColor(128, 128, 128);
        
        pdf.text('Generated on: ' + reportDate + ' at ' + reportTime, margin, footerY);
        pdf.text('University of Santo Tomas - Facilities Management Office', pageWidth / 2, footerY, { align: 'left' });
    }

    // Load and add logo 
    const logoImg = new Image();
    logoImg.src = './resources/images/USTLogo2.png';
    
    logoImg.onload = function() {
        // Add dark header background 
        pdf.setFillColor(51, 51, 51);
        pdf.rect(0, 0, pageWidth, 25, 'F');

        // Add logo to header
        const imgWidth = logoImg.width;
        const imgHeight = logoImg.height;
        const aspectRatio = imgWidth / imgHeight;
        const logoHeight = 13;
        const logoWidth = logoHeight * aspectRatio;
        
        pdf.addImage(logoImg, 'PNG', margin, 6, logoWidth, logoHeight);

        yPosition = 35;
        
        generatePDFContent();
    };
    
    logoImg.onerror = function() {
        yPosition = margin;
        generatePDFContent();
    };
    
    function generatePDFContent() {
        // Title 
        pdf.setFontSize(16);
        pdf.setFont('helvetica', 'bold');
        pdf.setTextColor(0, 0, 0);
        pdf.text('Facilities Management Office - Reports Dashboard', pageWidth / 2, yPosition, { align: 'center' });
        yPosition += 12;

        // Calculate statistics
        const reportRows = document.querySelectorAll('#reportsTable tbody tr');
        let totalReports = reportRows.length;
        let unresolvedCount = 0;
        let resolvedCount = 0;
        
        reportRows.forEach(row => {
            const statusBadge = row.querySelector('td:nth-child(5) .badge');
            if (statusBadge.textContent.includes('Resolved') && !statusBadge.textContent.includes('Not')) {
                resolvedCount++;
            } else {
                unresolvedCount++;
            }
        });

        // Reports Summary Table
        checkPageBreak(50);
        pdf.setFontSize(14);
        pdf.setFont('helvetica', 'bold');
        pdf.text('Reports Summary', margin, yPosition);
        yPosition += 8;

        const summaryData = [
            ['Total Reports', totalReports],
            ['Unresolved Reports', unresolvedCount],
            ['Resolved Reports', resolvedCount]
        ];
        yPosition = drawTable(['Category', 'Count'], summaryData, yPosition);
        yPosition += 10;

        // Continue with the rest of your existing PDF generation code...
        // (Monthly reports, equipment chart, location chart sections)
        // This is where all your existing chart capture and table generation code goes
        
        // For brevity, I'm showing the structure - you keep your existing logic for:
        // - Monthly Report Summary section
        // - Equipment pie chart capture and table
        // - Location bar chart capture and table
        
        // Add footer to all pages
        const totalPages = pdf.internal.getNumberOfPages();
        for (let i = 1; i <= totalPages; i++) {
            pdf.setPage(i);
            addFooter();
        }

        // Open PDF in new tab
        const pdfBlob = pdf.output('blob');
        const pdfUrl = URL.createObjectURL(pdfBlob);
        window.open(pdfUrl, '_blank');
        
        setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
    }
}

// Modified PDF generation function that accepts date range
function generatePDFWithDateRange(reportData, stats, startDate, endDate, pieChartImage, barChartImage) {
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('p', 'mm', 'a4');
    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 15;
    let yPosition = 20;

    const now = new Date();
    const reportDate = now.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
    const reportTime = now.toLocaleTimeString('en-US', { 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: true 
    });

    function checkPageBreak(requiredSpace) {
        if (yPosition + requiredSpace > pageHeight - margin - 20) {
            pdf.addPage();
            yPosition = margin + 30;
            return true;
        }
        return false;
    }

    function drawTable(headers, data, startY) {
        const tableWidth = pageWidth - (2 * margin);
        const colWidth = tableWidth / headers.length;
        const rowHeight = 8;
        let currentY = startY;

        pdf.setFillColor(51, 51, 51);
        pdf.setTextColor(255, 255, 255);
        pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
        
        pdf.setFontSize(10);
        pdf.setFont('helvetica', 'bold');
        headers.forEach((header, i) => {
            pdf.text(header, margin + (i * colWidth) + 2, currentY + 5.5);
        });
        
        currentY += rowHeight;
        pdf.setTextColor(0, 0, 0);

        pdf.setFont('helvetica', 'normal');
        data.forEach((row, rowIndex) => {
            if (currentY + rowHeight > pageHeight - margin - 20) {
                pdf.addPage();
                currentY = margin + 30;
                
                pdf.setFillColor(51, 51, 51);
                pdf.setTextColor(255, 255, 255);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
                pdf.setFont('helvetica', 'bold');
                headers.forEach((header, i) => {
                    pdf.text(header, margin + (i * colWidth) + 2, currentY + 5.5);
                });
                currentY += rowHeight;
                pdf.setTextColor(0, 0, 0);
                pdf.setFont('helvetica', 'normal');
            }

            if (rowIndex % 2 === 0) {
                pdf.setFillColor(245, 245, 245);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
            }

            row.forEach((cell, i) => {
                pdf.rect(margin + (i * colWidth), currentY, colWidth, rowHeight);
                pdf.text(String(cell), margin + (i * colWidth) + 2, currentY + 5.5);
            });
            
            currentY += rowHeight;
        });

        return currentY;
    }

    function addFooter() {
        const footerY = pageHeight - 10;
        pdf.setFontSize(8);
        pdf.setFont('helvetica', 'italic');
        pdf.setTextColor(128, 128, 128);
        
        pdf.text('Generated on: ' + reportDate + ' at ' + reportTime, margin, footerY);
        pdf.text('University of Santo Tomas - Facilities Management Office', pageWidth / 2, footerY, { align: 'center' });
    }

    const logoImg = new Image();
    logoImg.src = './resources/images/USTLogo2.png';
    
    logoImg.onload = function() {
        pdf.setFillColor(51, 51, 51);
        pdf.rect(0, 0, pageWidth, 25, 'F');

        const imgWidth = logoImg.width;
        const imgHeight = logoImg.height;
        const aspectRatio = imgWidth / imgHeight;
        const logoHeight = 13;
        const logoWidth = logoHeight * aspectRatio;
        
        pdf.addImage(logoImg, 'PNG', margin, 6, logoWidth, logoHeight);

        yPosition = 35;
        generateContent();
    };
    
    logoImg.onerror = function() {
        yPosition = margin;
        generateContent();
    };
    
    function generateContent() {
        // Title
        pdf.setFontSize(16);
        pdf.setFont('helvetica', 'bold');
        pdf.setTextColor(0, 0, 0);
        pdf.text('Facilities Management Office - Reports Dashboard', pageWidth / 2, yPosition, { align: 'center' });
        yPosition += 8;
        
        // Add date range info
        pdf.setFontSize(10);
        pdf.setFont('helvetica', 'normal');
        const dateRangeText = 'Period: ' + startDate.toLocaleDateString() + ' to ' + endDate.toLocaleDateString();
        pdf.text(dateRangeText, pageWidth / 2, yPosition, { align: 'center' });
        yPosition += 12;

        // Reports Summary
        checkPageBreak(50);
        pdf.setFontSize(14);
        pdf.setFont('helvetica', 'bold');
        pdf.text('Reports Summary', margin, yPosition);
        yPosition += 8;

        const summaryData = [
            ['Total Reports', stats.total],
            ['Unresolved Reports', stats.unresolved],
            ['Resolved Reports', stats.resolved]
        ];
        yPosition = drawTable(['Category', 'Count'], summaryData, yPosition);
        yPosition += 10;

        // Monthly Report Summary
        if (stats.monthly.length > 0) {
            checkPageBreak(50);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('Monthly Report Summary', margin, yPosition);
            yPosition += 8;
            
            yPosition = drawTable(['Month', 'Reports'], stats.monthly, yPosition);
            yPosition += 10;
        }

        // Equipment Chart
        if (pieChartImage && stats.equipment.length > 0) {
            checkPageBreak(100);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('Top 10 Unresolved Reports by Equipment Type', margin, yPosition);
            yPosition += 8;

            const chartWidth = 110;
            const chartHeight = 70;
            const chartX = (pageWidth - chartWidth) / 2;
            
            pdf.addImage(pieChartImage, 'PNG', chartX, yPosition, chartWidth, chartHeight);
            yPosition += chartHeight + 5;

            const equipmentData = stats.equipment.map((item, index) => [index + 1, item[0], item[1]]);
            yPosition = drawTable(['Rank', 'Equipment Type', 'Unresolved Reports'], equipmentData, yPosition);
            yPosition += 10;
        }

        // Location Chart
        if (barChartImage && stats.locations.length > 0) {
            checkPageBreak(100);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('Top 5 Most Reported Locations', margin, yPosition);
            yPosition += 15;

            const barChartWidth = 150;
            const barChartHeight = 70;
            const barChartX = (pageWidth - barChartWidth) / 2 + 20;
            
            pdf.addImage(barChartImage, 'PNG', barChartX, yPosition, barChartWidth, barChartHeight);
            yPosition += barChartHeight + 10;
        }

        // Add footer to all pages
        const totalPages = pdf.internal.getNumberOfPages();
        for (let i = 1; i <= totalPages; i++) {
            pdf.setPage(i);
            addFooter();
        }

        // Open PDF in new tab
        const pdfBlob = pdf.output('blob');
        const pdfUrl = URL.createObjectURL(pdfBlob);
        window.open(pdfUrl, '_blank');
        
        setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
    }
}


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

    // Handle row details on page change and search
    table.on('page.dt search.dt', function() {
        $('#detailsModal').modal('hide');
    });
    
    // Resolve confirmation
    $(document).on('click', '.resolve-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const form = $(this).closest('.resolve-form')[0];
        const reportId = $(this).closest('form').find('input[name="reportId"]').val();
        
        Swal.fire({
            title: 'Resolve Report?',
            text: 'Are you sure you want to mark this report as resolved?',
            icon: 'question',
            showCancelButton: true,
            reverseButtons: true,
            confirmButtonColor: '#28a745',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Resolve',
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

    // Archive confirmation handler
    $(document).on('click', '.archive-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const form = $(this).closest('.archive-form')[0];
        const reportId = $(this).closest('form').find('input[name="reportId"]').val();
        
        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to archive this report?',
            icon: 'warning',
            showCancelButton: true,
            reverseButtons: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, archive it',
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

    // Redraw charts on window resize
    $(window).resize(function() {
        if (locationChart && typeof locationChart.draw === 'function') {
            drawLocationChart();
        }
        if (equipmentChart && typeof equipmentChart.draw === 'function') {
            drawEquipmentChart();
        }
    });

    // Initialize tooltips for similar report indicators
    $('[title]').each(function() {
        $(this).attr('data-bs-toggle', 'tooltip');
    });
    
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
});
</script>
</body>
</html>
