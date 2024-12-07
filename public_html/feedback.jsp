<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            <jsp:include page="sidebar.jsp" />

            <div class="col-md-10">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1>Feedback</h1>
                    <button class="btn btn-warning" id="download-chart">Generate Report</button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Satisfaction Rate (Monthly)</h5>
                        <div id="chart_div" style="width: 100%; height: 400px"></div>
                    </div>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Rating</th>
                            <th>Room</th>
                            <th>Location</th>
                            <th>Suggestions</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="feedback" items="${feedbackList}">
                            <tr>
                                <td>${feedback.rating}</td>
                                <td>${feedback.room}</td>
                                <td>${feedback.location}</td>
                                <td>${feedback.suggestions}</td>
                                <td><fmt:formatDate value="${feedback.recInsDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                <td>
                                    <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal" onclick="setFeedbackId(${feedback.feedbackId})">
                                        Delete
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmDeleteLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this feedback?
                </div>
                <div class="modal-footer">
                    <form id="deleteForm" action="feedback" method="post">
                        <input type="hidden" name="feedbackId" id="feedbackId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        google.charts.load('current', { packages: ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);

        let chart;

        function drawChart() {
            const generalAverage = ${generalAverage};
            const data = google.visualization.arrayToDataTable([
                ['Month', 'Satisfaction Rate', { role: 'style' }],
                <c:forEach var="rate" items="${satisfactionRates}">
                    ['${rate[0]}', ${rate[1]}, '${rate[1] >= generalAverage ? "green" : "red"}'],
                </c:forEach>
            ]);

            const options = {
                title: 'Monthly Satisfaction Rates',
                hAxis: { title: 'Month' },
                vAxis: { title: 'Average Rating', minValue: 0, maxValue: 5 },
                legend: 'none',
            };

            chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }

        document.getElementById('download-chart').addEventListener('click', function () {
            const chartImage = chart.getImageURI();
            const downloadLink = document.createElement('a');
            downloadLink.href = chartImage;
            downloadLink.download = 'satisfaction_rate_report.png';
            downloadLink.click();
        });

        function setFeedbackId(id) {
            document.getElementById('feedbackId').value = id;
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
