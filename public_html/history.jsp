<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>History Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
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
                            <th>Row Data</th>
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
                                <td><c:out value="${log.formattedRowData}" escapeXml="false" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
