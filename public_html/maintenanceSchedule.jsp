<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Schedule</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">Maintenance Schedule</h1>
        <table class="table table-striped mt-4">
            <thead class="thead-dark">
                <tr>
                    <th>ITEM_MS_ID</th>
                    <th>ITEM_TYPE_ID</th>
                    <th>NO_OF_DAYS</th>
                    <th>REMARKS</th>
                    <th>NO_OF_DAYS_WARNING</th>
                </tr>
            </thead>
            <tbody>
                <!-- Loop through the maintenance list and display -->
                <c:forEach var="maintenance" items="${maintenanceList}">
                    <tr>
                        <td>${maintenance.itemMsId}</td>
                        <td>${maintenance.itemTypeId}</td>
                        <td>${maintenance.noOfDays}</td>
                        <td>${maintenance.remarks}</td>
                        <td>${maintenance.noOfDaysWarning}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
