<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        .pagination a {
            margin: 0 5px;
        }
        .pagination .active a {
            background-color: #007bff;
            color: white;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
        .row-data {
            display: none;
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
                <h1>History Logs</h1>

                <!-- Display Table -->
                <table class="table table-striped">
                    <thead>
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
                        <c:forEach var="log" items="${historyLogs}">
                            <tr>
                                <td>${log.logId}</td>
                                <td>${log.tableName}</td>
                                <td>${log.operationType}</td>
                                <td>${log.operationTimestamp}</td>
                                <td>${log.username}</td>
                                <td>
                                    <button class="btn btn-info btn-sm" onclick="toggleDetails('${log.logId}')">View Detail</button>
                                </td>
                            </tr>
                            <tr class="row-data" id="details-${log.logId}">
                                <td colspan="6">${log.formattedRowData}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination Controls -->
                <div class="pagination">
                    <!-- Previous Button -->
                    <c:if test="${page > 1}">
                        <a href="?page=${page - 1}" class="btn btn-secondary">Previous</a>
                    </c:if>

                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <c:choose>
                            <c:when test="${pageNum == page}">
                                <span class="btn btn-primary active">${pageNum}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${pageNum}" class="btn btn-outline-primary">${pageNum}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- Next Button -->
                    <c:if test="${page < totalPages}">
                        <a href="?page=${page + 1}" class="btn btn-secondary">Next</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to toggle the visibility of row data
        function toggleDetails(logId) {
            const rowData = document.getElementById('details-' + logId);
            if (rowData.style.display === '' || rowData.style.display === 'none') {
                rowData.style.display = 'table-row';
            } else {
                rowData.style.display = 'none';
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
