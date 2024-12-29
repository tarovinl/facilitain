<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs</title>
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <style>
        .row-data {
            display: none;
            background-color: #f8f9fa;
        }
        .log-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin: 5px 0;
            box-shadow: inset 0 0 5px rgba(0,0,0,0.1);
        }
        #historyLogsTable tbody tr:not(.row-data):hover {
            cursor: pointer;
            background-color: #e9ecef;
            transition: background-color 0.2s ease;
        }
        .btn-info {
            color: #fff;
            background-color: #0dcaf0;
            border-color: #0dcaf0;
        }
        .btn-info:hover {
            color: #fff;
            background-color: #31d2f2;
            border-color: #25cff2;
        }
        .detail-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .detail-list li {
            padding: 4px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .detail-list li:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="mb-0">History Logs</h1>
                </div>

                <!-- Logs Table -->
                <div class="table-responsive">
                    <table id="historyLogsTable" class="table table-striped table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Log ID</th>
                                <th>Table Name</th>
                                <th>Operation Type</th>
                                <th>Operation Timestamp</th>
                                <th>Username</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty historyLogs}">
                                <tr>
                                    <td colspan="6" class="text-center">No logs found.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="log" items="${historyLogs}">
                                <!-- Main row -->
                                <tr data-log-id="${log.logId}">
                                    <td>${log.logId}</td>
                                    <td>${log.tableName}</td>
                                    <td>
                                        <span class="badge ${log.operationType == 'INSERT' ? 'bg-success' : 
                                                            log.operationType == 'UPDATE' ? 'bg-warning' : 
                                                            log.operationType == 'DELETE' ? 'bg-danger' : 'bg-secondary'}">
                                            ${log.operationType}
                                        </span>
                                    </td>
                                    <td>${log.operationTimestamp}</td>
                                    <td>${log.username}</td>
                                    <td>
                                        <button class="btn btn-info btn-sm" onclick="toggleDetails('${log.logId}')">
                                            <span class="detail-text-${log.logId}">View Detail</span>
                                        </button>
                                    </td>
                                </tr>
                                <!-- Detail row -->
                                <tr class="row-data" id="details-${log.logId}">
                                    <td colspan="6">
                                        <div class="log-details">
                                            <h6 class="mb-3">Row Data Details:</h6>
                                            <ul class="detail-list">
                                                <c:forEach var="pair" items="${fn:split(log.rowData, ',')}">
                                                    <li>
                                                        <strong>${fn:split(pair, '=')[0]}:</strong>
                                                        <span class="ms-2">${fn:split(pair, '=')[1]}</span>
                                                    </li>
                                                </c:forEach>
                                            </ul>
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

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function () {
            // Initialize DataTable
            const table = $('#historyLogsTable').DataTable({
                paging: true,
                searching: true,
                info: true,
                order: [[3, 'desc']], // Default sort by timestamp
                language: {
                    search: "Search logs:",
                    lengthMenu: "Show _MENU_ logs per page",
                    info: "Showing _START_ to _END_ of _TOTAL_ logs",
                    infoEmpty: "No logs available",
                    infoFiltered: "(filtered from _MAX_ total logs)"
                },
                rowGroup: {
                    dataSrc: ""
                },
                // Exclude detail rows from DataTable processing
                rowCallback: function(row, data, index) {
                    if ($(row).hasClass('row-data')) {
                        $(row).css('display', 'none');
                    }
                }
            });

            // Add responsive behavior to table
            $(window).on('resize', function() {
                table.columns.adjust();
            });
        });

        // Toggle row details
        function toggleDetails(logId) {
            const detailRow = document.getElementById('details-' + logId);
            const button = document.querySelector(`button[onclick="toggleDetails('${logId}')"]`);
            const buttonText = document.querySelector(`.detail-text-${logId}`);
            const isVisible = detailRow.style.display === 'table-row';
            
            // Hide all detail rows first
            document.querySelectorAll('.row-data').forEach(row => {
                row.style.display = 'none';
            });
            
            // Reset all button texts
            document.querySelectorAll('[class^="detail-text-"]').forEach(text => {
                text.textContent = 'View Detail';
            });

            // Toggle the clicked row
            if (!isVisible) {
                detailRow.style.display = 'table-row';
                buttonText.textContent = 'Hide Detail';
                button.classList.remove('btn-info');
                button.classList.add('btn-secondary');
            } else {
                button.classList.remove('btn-secondary');
                button.classList.add('btn-info');
            }
        }
    </script>
</body>
</html>