<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1>Reports</h1>
            </div>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Equipment Type</th>
                        <th scope="col">Location</th>
                        <th scope="col">Floor</th>
                        <th scope="col">Room</th>
                        <th scope="col">Describe the Issue</th>
                        <th scope="col">Proof</th>
                        <th scope="col">Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${reportsList}">
                        <tr>
                            <td>${report.reportId}</td>
                            <td>${report.repEquipment}</td>
                            <td>${report.locName}</td>
                            <td>${report.repfloor}</td>
                            <td>${report.reproom}</td>
                            <td>${report.repissue}</td>
                            <td>
                                <form action="viewImage" method="get" target="_blank">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-link">View</button>
                                </form>
                            </td>
                            <td><fmt:formatDate value="${report.recInstDt}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
