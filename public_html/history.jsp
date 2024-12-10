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
    <style>
        .row-data {
            display: none;
        }
        .log-details {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
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
                <h1 class="mb-4 font-medium">History Logs</h1>

                <!-- Search Bar -->
                <form action="${pageContext.request.contextPath}/history" method="get" class="mb-4">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control font-light" placeholder="Search logs by any field" value="${searchKeyword != null ? searchKeyword : ''}">
                        <button type="submit" class="btn btn-primary font-medium">Search</button>
                    </div>
                </form>

                <!-- Page Indicator -->
                <div class="d-flex justify-content-between align-items-center mb-3 font-light">
                    <div class="text-muted">
                        Page ${currentPage} of ${totalPages}
                    </div>
                </div>

                <!-- Display Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-light font-medium">
                            <tr>
                                <th>Log ID</th>
                                <th>Table Name</th>
                                <th>Operation Type</th>
                                <th>Operation Timestamp</th>
                                <th>Username</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody class="font-light">
                            <c:if test="${empty historyLogs}">
                                <tr>
                                    <td colspan="6" class="text-center">No logs found matching your search criteria.</td>
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

                <!-- Pagination Controls -->
                <nav aria-label="History Logs Pagination">
                    <ul class="pagination justify-content-center mt-3 font-light">
                        <!-- Previous Button -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/history?page=1&search=${searchKeyword}" aria-label="First">
                                        <span aria-hidden="true">&laquo;&laquo;</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/history?page=${currentPage - 1}&search=${searchKeyword}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled">
                                    <span class="page-link">&laquo;&laquo;</span>
                                </li>
                                <li class="page-item disabled">
                                    <span class="page-link">&laquo;</span>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/history?page=${pageNum}&search=${searchKeyword}">${pageNum}</a>
                            </li>
                        </c:forEach>

                        <!-- Next Button -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/history?page=${currentPage + 1}&search=${searchKeyword}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/history?page=${totalPages}&search=${searchKeyword}" aria-label="Last">
                                        <span aria-hidden="true">&raquo;&raquo;</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled">
                                    <span class="page-link">&raquo;</span>
                                </li>
                                <li class="page-item disabled">
                                    <span class="page-link">&raquo;&raquo;</span>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <script>
        // Toggle row data visibility
        function toggleDetails(logId) {
            const row = document.getElementById('details-' + logId);
            row.style.display = (row.style.display === 'none' || row.style.display === '') ? 'table-row' : 'none';
        }
    </script>
</body>
</html>
