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
                <h1 >Reports</h1>
            </div>

            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Equipment Type</th>
                        <th scope="col">Location</th>
                        <th scope="col">Date</th>
                        <th scope="col">Status</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${reportsList}">
                        <!-- Main Row -->
                        <tr>
                            <td>${report.reportId}</td>
                            <td>${report.repEquipment}</td>
                            <td>${report.locName}</td>
                            <td><fmt:formatDate value="${report.recInstDt}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${report.status == 1}">
                                        <span class="badge bg-success">Resolved</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Not Resolved</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <!-- Details Button -->
                                <button class="btn btn-sm btn-info toggle-btn" data-target="details-${report.reportId}">
                                    Details
                                </button>
                                
                                <!-- Resolve Form -->
                                <form action="emailresolve" method="post" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-sm btn-success">Resolve</button>
                                </form>

                                <!-- Archive Form -->
                                <form action="reports" method="post" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                    <button type="submit" class="btn btn-sm btn-danger">Archive</button>
                                </form>
                            </td>
                        </tr>

                        <!-- Collapsible Detail Row -->
                        <tr class="detail-row" id="details-${report.reportId}" style="display: none;">
                            <td colspan="6">
                                <div class="p-3">
                                    <strong>Floor:</strong> ${report.repfloor}<br>
                                    <strong>Room:</strong> ${report.reproom}<br>
                                    <strong>Description:</strong> ${report.repissue}<br>
                                    <form action="viewImage" method="get" target="_blank">
                                        <input type="hidden" name="reportId" value="${report.reportId}">
                                        <button type="submit" class="btn btn-link">View Proof</button>
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

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const toggleButtons = document.querySelectorAll('.toggle-btn');
        toggleButtons.forEach(button => {
            button.addEventListener('click', () => {
                const targetId = button.getAttribute('data-target');
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    targetElement.style.display = 
                        targetElement.style.display === 'none' ? 'table-row' : 'none';
                }
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

</body>
</html>
