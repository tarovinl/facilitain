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
    <!-- Added DataTables responsive extension CSS -->
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

        /* Chart container styling  */
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

        /* Enhanced filter section - inside table container */
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

        /* DataTables customization */
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

        /*  mobile responsive styles for DataTables */
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

        /* Enhanced responsive table styling */
        @media (max-width: 576px) {
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .similar-report-indicator {
                display: block;
                margin: 0.25rem 0;
                font-size: 0.7rem;
            }
            
            /* Stack action buttons vertically on very small screens */
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

        /* Responsive modal improvements */
        @media (max-width: 576px) {
            .modal-dialog {
                margin: 0.5rem;
                max-width: calc(100% - 1rem);
            }
            
            .modal-body {
                padding: 1rem 0.75rem;
            }
        }

        /* DataTables responsive child row styling */
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

        /* Sort indicator enhancement */
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
                            <h5 class="card-title">Reports by Location</h5>
                            <div id="locationChart" class="chart-container"></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Reports by Equipment Type</h5>
                            <div id="equipmentChart" class="chart-container"></div>
                        </div>
                    </div>
                </div>
            </div>

            
            <div class="table-container">
                <!-- Enhanced Filters Section -->
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
                                        <!-- Improved mobile action buttons layout -->
                                        <div class="action-buttons">
                                            <button class="btn btn-info btn-sm toggle-details" data-bs-toggle="modal" data-bs-target="#detailsModal">
                                                Details
                                            </button>
                                            <form action="emailresolve" method="post" style="display:inline;">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <button type="submit" class="btn btn-sm btn-success">
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
<!-- Added DataTables responsive extension JavaScript -->
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
    
    // Check if there's data to display
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
        title: 'Reports by Location',
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
    
    // Check if there's data to display
    if (${empty equipmentReports}) {
        chartDiv.innerHTML = '<div class="text-center p-5">' +
                             '<i class="bi bi-exclamation-circle fs-1 text-muted"></i>' +
                             '<h6 class="mt-3">No reports data available</h6>' +
                             '<p class="text-muted small">Chart will appear when reports are submitted.</p>' +
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
        title: 'Reports by Equipment Type',
        pieHole: 0.4,
        colors: ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57', '#ff9ff3', '#54a0ff'],
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
        order: [[3, 'desc']], // Sort by date (newest first)
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
                targets: 0, // ID column
                className: 'control',
                responsivePriority: 1
            },
            {
                targets: 1, // Equipment Type
                responsivePriority: 2
            },
            {
                targets: 4, // Status
                responsivePriority: 3
            },
            {
                targets: 5, // Actions
                responsivePriority: 1
            },
            {
                targets: [2, 3], // Location and Date - can be hidden on small screens
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
        
        // Adjust page length based on screen size
        if ($(window).width() < 768 && table.page.len() > 5) {
            table.page.len(5).draw();
        } else if ($(window).width() >= 768 && table.page.len() === 5) {
            table.page.len(10).draw();
        }
    });

    // Custom filter functions
    function applyFilters() {
        table.draw();
    }

    // Status filter
    $('#statusFilter').on('change', function() {
        const selectedStatus = $(this).val();
        table.column(4).search(selectedStatus).draw();
    });

    // Similar reports filter
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

    // Equipment filter
    $('#equipmentFilter').on('change', function() {
        const selectedEquipment = $(this).val();
        table.column(1).search(selectedEquipment).draw();
    });

    // Date sorting buttons
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

    // Clear all filters
    $('#clearFilters').on('click', function() {
        // Reset all select filters
        $('#statusFilter, #similarFilter, #equipmentFilter').val('');
        
        // Reset sorting to default (newest first)
        $('.sort-btn').removeClass('active');
        $('#sortDateDesc').addClass('active');
        
        // Clear DataTable searches and reset order
        table.search('').columns().search('').order([3, 'desc']).draw();
        
        // Clear any custom search functions
        $.fn.dataTable.ext.search = [];
    });

    // Populate equipment filter with unique values
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

    // Initialize equipment filter
    populateEquipmentFilter();

    // Generate Report functionality
    $('#generate-report').on('click', function() {
        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF('p', 'mm', 'a4');
        
        let yPosition = 20;

        // Add header
        pdf.setFontSize(20);
        pdf.setFont(undefined, 'bold');
        pdf.text('University of Santo Tomas', 105, yPosition, { align: 'center' });
        yPosition += 10;
        
        pdf.setFontSize(16);
        pdf.text('Reports Dashboard', 105, yPosition, { align: 'center' });
        yPosition += 20;

        // Add location chart
        const locationImage = locationChart.getImageURI();
        if (locationImage) {
            try {
                pdf.addImage(locationImage, 'PNG', 10, yPosition, 90, 60);
            } catch (error) {
                console.warn('Location chart could not be added:', error);
            }
        }

        // Add equipment chart
        const equipmentImage = equipmentChart.getImageURI();
        if (equipmentImage) {
            try {
                pdf.addImage(equipmentImage, 'PNG', 110, yPosition, 80, 60);
            } catch (error) {
                console.warn('Equipment chart could not be added:', error);
            }
        }

        yPosition += 70;

        // Add reports summary table
        pdf.setFontSize(14);
        pdf.setFont(undefined, 'bold');
        pdf.text('Reports Summary', 20, yPosition);
        yPosition += 10;

        const reportRows = document.querySelectorAll('#reportsTable tbody tr');
        
        if (reportRows.length === 0) {
            pdf.setFontSize(12);
            pdf.setFont(undefined, 'normal');
            pdf.text('No reports data available', 20, yPosition);
        } else {
            // Table headers
            pdf.setFontSize(10);
            pdf.setFont(undefined, 'bold');
            const headers = ['ID', 'Equipment', 'Location', 'Date', 'Status'];
            const columnWidths = [15, 40, 40, 30, 25];
            let xPosition = 20;
            
            headers.forEach((header, index) => {
                pdf.text(header, xPosition, yPosition);
                xPosition += columnWidths[index];
            });
            yPosition += 8;

            // Table data (limit to first 20 rows to fit in page)
            pdf.setFont(undefined, 'normal');
            const maxRows = Math.min(reportRows.length, 20);
            for (let i = 0; i < maxRows; i++) {
                if (yPosition > 270) {
                    pdf.addPage();
                    yPosition = 20;
                }

                const cells = reportRows[i].querySelectorAll('td');
                xPosition = 20;
                
                for (let j = 0; j < Math.min(cells.length, 5); j++) {
                    let text = cells[j].textContent.trim();
                    
                    // Clean up status text
                    if (j === 4) {
                        text = text.includes('Resolved') ? 'Resolved' : 'Not Resolved';
                    }
                    
                    // Truncate long text
                    if (text.length > 15 && j !== 1) {
                        text = text.substring(0, 12) + '...';
                    } else if (j === 1 && text.length > 20) {
                        text = text.substring(0, 17) + '...';
                    }
                    
                    pdf.text(text, xPosition, yPosition);
                    xPosition += columnWidths[j];
                }
                yPosition += 6;
            }

            if (reportRows.length > 20) {
                yPosition += 5;
                pdf.setFont(undefined, 'italic');
                pdf.text(`... and ${reportRows.length - 20} more reports`, 20, yPosition);
            }
        }

        // Add generation date
        yPosition += 15;
        if (yPosition > 270) {
            pdf.addPage();
            yPosition = 20;
        }
        
        pdf.setFontSize(10);
        pdf.setFont(undefined, 'italic');
        const currentDate = new Date().toLocaleDateString();
        pdf.text(`Generated on: ${currentDate}`, 105, yPosition, { align: 'center' });

        pdf.save('reports_dashboard.pdf');
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
            text: `You want to archive this report?`,
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