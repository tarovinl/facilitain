<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <style>
        .row-data {
            display: none;
        }
        .log-details {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            <div class="col-md-9 col-lg-10 p-4">
                <h1 class="mb-4">History Logs</h1>

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
                                <tr>
                                    <td>${log.logId}</td>
                                    <td>${log.tableName}</td>
                                    <td>${log.operationType}</td>
                                    <td>${log.operationTimestamp}</td>
                                    <td>${log.username}</td>
                                    <td>
                                        <button class="btn btn-info btn-sm" onclick="toggleDetails('${log.logId}')">
                                            View Detail
                                        </button>
                                    </td>
                                </tr>
                                <tr class="row-data" id="details-${log.logId}">
                                    <td colspan="6">
                                        <div class="log-details">
                                            <strong>Row Data:</strong>
                                            <ul>
                                                <c:forEach var="pair" items="${fn:split(log.rowData, ',')}">
                                                    <li><strong>${fn:split(pair, '=')[0]}:</strong> ${fn:split(pair, '=')[1]}</li>
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
            $('#historyLogsTable').DataTable({
                paging: true,
                searching: true,
                info: true,
                order: [[3, 'desc']] // Default sort by timestamp
            });
        });

        // Toggle row data visibility
        function toggleDetails(logId) {
            const row = document.getElementById('details-' + logId);
            row.style.display = (row.style.display === 'none' || row.style.display === '') ? 'table-row' : 'none';
        }
    </script>
</body>
</html>
