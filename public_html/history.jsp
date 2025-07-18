<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs - Facilitain</title>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
        body, h1, h2, h3, h4, th {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h5, h6, input, textarea, td, tr, p, label, select, option {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .details-control {
            cursor: pointer;
            text-align: center;
        }
        
        .details-control:hover {
            background-color: #f8f9fa;
        }
        
        .log-details {
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            margin: 10px 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .log-details h5 {
            color: #495057;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .data-table {
            background: white;
            border-radius: 6px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .data-table th {
            background-color: #6c757d;
            color: white;
            font-weight: 600;
            padding: 12px;
            border: none;
        }
        
        .data-table td {
            padding: 10px 12px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: top;
        }
        
        .data-table tr:last-child td {
            border-bottom: none;
        }
        
        .data-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .field-name {
            font-weight: 600;
            color: #495057;
            min-width: 150px;
        }
        
        .field-value {
            color: #6c757d;
            word-break: break-word;
        }
        
        .btn-details {
            transition: all 0.2s ease;
            font-size: 0.875rem;
            padding: 4px 8px;
        }
        
        .btn-details:hover {
            transform: translateY(-1px);
        }
        
        .main-content {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 20px;
        }
        
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                width: 100%;
            }
        }
        
        .expand-icon {
            transition: transform 0.3s ease;
        }
        
        .expand-icon.rotated {
            transform: rotate(180deg);
        }
        
        .btn-details {
            white-space: nowrap;
        }

        .responsive-padding-top {
                                  padding-top: 100px;
                                }
                                
                @media (max-width: 576px) {
                .responsive-padding-top {
                padding-top: 80px; /* or whatever smaller value you want */
                }
                }

        
        /* DataTables custom styling to match your theme */
        .dataTables_wrapper .dataTables_length select,
        .dataTables_wrapper .dataTables_filter input {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_processing {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        /* Custom search styling */
        .search-info {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        
        .search-info i {
            color: #2196f3;
            margin-right: 8px;
        }
        
        .dataTables_filter {
            margin-bottom: 15px;
        }
        
        .dataTables_filter input {
            border: 2px solid #dee2e6;
            border-radius: 6px;
            padding: 8px 12px;
            width: 300px !important;
        }
        
        .dataTables_filter input:focus {
            border-color: #2196f3;
            box-shadow: 0 0 0 0.2rem rgba(33, 150, 243, 0.25);
        }

    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
    <div class="d-flex">
    <c:set var="page" value="history" scope="request"/>
        <jsp:include page="sidebar.jsp"/>
        

        <div class="main-content flex-grow-1 responsive-padding-top">
            <h1 class="mb-2" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">History Logs</h1>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                </div>
            </c:if>
         
            
            <div class="table-responsive">
                <table id="historyTable" class="table table-striped table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Log ID</th>
                            <th>Table Name</th>
                            <th>Operation Type</th>
                            <th>Operation Timestamp</th>
                            <th style="width: 100px;">Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- DataTables will populate this via AJAX -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        function formatDetails(rowData) {
            console.log('Row data received:', rowData);
            
            if (!rowData || rowData.trim() === '' || rowData === 'null') {
                return '<div class="log-details"><h5><i class="fas fa-info-circle"></i> Row Data Details</h5><p class="text-muted">No data available</p></div>';
            }
            
            let html = '<div class="log-details">';
            html += '<h5><i class="fas fa-table"></i> Row Data Details</h5>';
            html += '<table class="table data-table">';
            html += '<thead><tr><th>Field Name</th><th>Field Value</th></tr></thead>';
            html += '<tbody>';
            
            try {
                // Split by comma and process each field
                const fields = rowData.split(',');
                
                if (fields.length === 0) {
                    html += '<tr><td colspan="2" class="text-muted text-center">No fields found</td></tr>';
                } else {
                    fields.forEach(field => {
                        const trimmedField = field.trim();
                        if (trimmedField) {
                            const equalIndex = trimmedField.indexOf('=');
                            if (equalIndex > 0) {
                                const key = trimmedField.substring(0, equalIndex).trim();
                                const value = trimmedField.substring(equalIndex + 1).trim();
                                html += '<tr>';
                                html += '<td class="field-name">' + escapeHtml(key) + '</td>';
                                html += '<td class="field-value">' + (value ? escapeHtml(value) : '<em class="text-muted">Empty</em>') + '</td>';
                                html += '</tr>';
                            } else {
                                // Handle case where there's no '=' sign
                                html += '<tr>';
                                html += '<td class="field-name">Raw Data</td>';
                                html += '<td class="field-value">' + escapeHtml(trimmedField) + '</td>';
                                html += '</tr>';
                            }
                        }
                    });
                }
            } catch (error) {
                console.error('Error parsing row data:', error);
                html += '<tr><td colspan="2" class="text-danger">Error parsing data</td></tr>';
            }
            
            html += '</tbody></table></div>';
            return html;
        }
        
        function escapeHtml(text) {
            if (!text) return '';
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
        }
        
        $(document).ready(function() {
            // Initialize DataTable 
            const table = $('#historyTable').DataTable({
                processing: true,
                serverSide: true,
                ajax: {
                    url: 'history',
                    type: 'GET',
                    error: function(xhr, error, code) {
                        console.log('DataTables AJAX error:', error);
                        console.log('Status:', xhr.status);
                        console.log('Response:', xhr.responseText);
                    }
                },
                order: [[3, 'desc']], // Sort by Operation Timestamp
                pageLength: 25,
                lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                columns: [
                    { data: 0, title: 'Log ID' },
                    { data: 1, title: 'Table Name' },
                    { data: 2, title: 'Operation Type', orderable: false },
                    { data: 3, title: 'Operation Timestamp' },
                    { data: 4, title: 'Details', orderable: false, searchable: false }
                ],
                language: {
                    search: "Search all records:",
                    processing: "Searching records...",
                    lengthMenu: "Show _MENU_ entries per page",
                    info: "Showing _START_ to _END_ of _TOTAL_ entries",
                    infoFiltered: "(filtered from _MAX_ total entries)",
                    paginate: {
                        first: "First",
                        last: "Last",
                        next: "Next",
                        previous: "Previous"
                    },
                    emptyTable: "No history logs found",
                    zeroRecords: "No matching records found"
                },
                searchDelay: 500, // Add delay to prevent too many requests while typing
                
            });

            // Handle details button click
            $('#historyTable tbody').on('click', '.btn-details', function() {
                const button = $(this);
                const tr = button.closest('tr');
                const row = table.row(tr);
                
                console.log('Details button clicked');
                
                if (row.child.isShown()) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                    button.removeClass('btn-info').addClass('btn-outline-info');
                    button.html('<i class="fas fa-eye me-1"></i>View');
                    console.log('Row closed');
                } else {
                    // Close any other open rows first
                    table.rows().every(function() {
                        if (this.child.isShown()) {
                            this.child.hide();
                            $(this.node()).removeClass('shown');
                            $(this.node()).find('.btn-details')
                                .removeClass('btn-info').addClass('btn-outline-info')
                                .html('<i class="fas fa-eye me-1"></i>View');
                        }
                    });
                    
                    // Open this row
                    const rowData = button.attr('data-row-data');
                    console.log('Opening row with data:', rowData);
                    
                    const detailsHtml = formatDetails(rowData);
                    console.log('Generated HTML length:', detailsHtml.length);
                    
                    row.child(detailsHtml).show();
                    tr.addClass('shown');
                    button.removeClass('btn-outline-info').addClass('btn-info');
                    button.html('<i class="fas fa-eye-slash me-1"></i>Hide');
                    console.log('Row opened');
                }
            });
            
            // Optional: Add custom search functionality
            $('#historyTable_filter input').attr('placeholder', 'Search by ID, table name, operation type, timestamp, or row data...');
        });
    </script>
</body>
</html>