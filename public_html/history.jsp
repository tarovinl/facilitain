<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs</title>
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <style>
        td.details-control {
            cursor: pointer;
        }
        .log-details {
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            
                <jsp:include page="sidebar.jsp"/>
         
            <div class=" col-lg-10 p-4">
                <h1 class="mb-4" style="color: black; font-family: 'NeueHaasMedium', sans-serif;">History Logs</h1>

                <!-- Display Table -->
                <div class="table-responsive">
                    <table id="historyTable" class="table table-striped table-hover">
                        <thead class="table-light">
                            <tr>
                                <th></th>
                                <th>Log ID</th>
                                <th>Table Name</th>
                                <th>Operation Type</th>
                                <th>Operation Timestamp</th>
                                <th>Username</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${historyLogs}">
                                <tr data-row-data="${log.rowData}">
                                    <td class="details-control"></td>
                                    <td>${log.logId}</td>
                                    <td>${log.tableName}</td>
                                    <td>${log.operationType}</td>
                                    <td>${log.operationTimestamp}</td>
                                    <td>${log.username}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        function formatDetails(rowData) {
            const data = rowData.split(',');
            let html = '<div class="log-details"><strong>Row Data:</strong><ul>';
            
            data.forEach(pair => {
                const [key, value] = pair.split('=');
                html += `<li><strong>${key}:</strong> ${value}</li>`;
            });
            
            html += '</ul></div>';
            return html;
        }

        $(document).ready(function() {
            const table = $('#historyTable').DataTable({
                order: [[4, 'desc']], // Sort by Operation Timestamp by default
                pageLength: 12,
                language: {
                    search: "Search logs:"
                },
                columnDefs: [{
                    targets: 0,
                    orderable: false,
                    defaultContent: '<button class="btn btn-info btn-sm">View</button>'
                }]
            });

            // Add event listener for opening and closing details
            $('#historyTable tbody').on('click', 'td.details-control', function() {
                const tr = $(this).closest('tr');
                const row = table.row(tr);

                if (row.child.isShown()) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                } else {
                    // Open this row
                    const rowData = tr.data('row-data');
                    row.child(formatDetails(rowData)).show();
                    tr.addClass('shown');
                }
            });
        });
    </script>
</body>
</html>