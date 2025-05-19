<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Feedback</title>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <!-- Include DataTables CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            <jsp:include page="sidebar.jsp" />

            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1 style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Feedback</h1>
                    <button class="btn btn-warning" id="download-chart" ${empty feedbackList ? 'disabled' : ''}>Generate Report</button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Satisfaction Rate (Monthly)</h5>
                        <div id="chart_div" style="width: 100%; height: 400px"></div>
                    </div>
                </div>

                <!-- Feedback Table with clarification about displaying 15 most recent feedbacks -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Recent Feedbacks</h5>
                        <p class="text-muted">Showing the 15 most recent feedbacks</p>
                        
                        <c:choose>
                            <c:when test="${empty feedbackList}">
                                <div class="text-center p-5">
                                    <i class="bi bi-clipboard-x fs-1 text-muted"></i>
                                    <h4 class="mt-3">No Feedback Data Available</h4>
                                    <p class="text-muted">Feedback will appear here when users submit their responses.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table id="feedbackTable" class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Rating</th>
                                            <th>Room</th>
                                            <th>Location</th>
                                            <th>Suggestions</th>
                                            <th>Equipment Type</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="feedback" items="${feedbackList}">
                                            <tr>
                                                <td>${feedback.rating}</td>
                                                <td>${feedback.room}</td>
                                                <td>${feedback.location}</td>
                                                <td>${feedback.suggestions}</td>
                                                <td>${feedback.itemCatName}</td>
                                                <td><fmt:formatDate value="${feedback.recInsDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        google.charts.load('current', { packages: ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);

        let chart;

        function drawChart() {
            const chartDiv = document.getElementById('chart_div');
            
            // Check if there's data to display
            if (${empty satisfactionRates}) {
                // No data available - display a message
                chartDiv.innerHTML = '<div class="text-center p-5">' +
                                     '<i class="bi bi-exclamation-circle fs-1 text-muted"></i>' +
                                     '<h4 class="mt-3">No feedback data available</h4>' +
                                     '<p class="text-muted">The chart will appear when feedback is submitted.</p>' +
                                     '</div>';
                // Create empty chart for report generation
                chart = {
                    getImageURI: function() {
                        // Create a canvas with "No Data" message
                        const canvas = document.createElement('canvas');
                        canvas.width = chartDiv.offsetWidth;
                        canvas.height = chartDiv.offsetHeight;
                        const ctx = canvas.getContext('2d');
                        ctx.fillStyle = '#f8f9fa';
                        ctx.fillRect(0, 0, canvas.width, canvas.height);
                        ctx.fillStyle = '#6c757d';
                        ctx.font = '20px Arial';
                        ctx.textAlign = 'center';
                        ctx.fillText('No feedback data available', canvas.width/2, canvas.height/2);
                        return canvas.toDataURL();
                    }
                };
                return;
            }
            
            // Data is available, create the chart
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

            chart = new google.visualization.ColumnChart(chartDiv);
            chart.draw(data, options);
        }

        const generatedDate = '${generatedDate}';
        document.getElementById('download-chart').addEventListener('click', function () {
            // Create a full report container
            const reportContainer = document.createElement('div');
            reportContainer.style.fontFamily = 'Arial, sans-serif';
            reportContainer.style.maxWidth = '1200px';
            reportContainer.style.margin = '0 auto';
            reportContainer.style.padding = '20px';

            // Add the header with inline styles for gray background
            const header = document.createElement('header');
            header.style.backgroundColor = '#333333'; //very gray
            header.style.padding = '1rem 3rem';
            header.style.display = 'flex';
            header.style.justifyContent = 'space-between';
            header.style.alignItems = 'center';
            header.style.overflowX = 'auto';
            header.style.whiteSpace = 'nowrap';

            // For large devices
            const largeImg = document.createElement('img');
            largeImg.src = 'resources/images/USTLogo.png';
            largeImg.alt = 'UST Logo';
            largeImg.classList.add('img-fluid', 'd-none', 'd-md-block');
            largeImg.style.maxHeight = '6rem';

            // For small devices
            const smallImg = document.createElement('img');
            smallImg.src = 'resources/images/USTLogo.png';
            smallImg.alt = 'UST Logo';
            smallImg.classList.add('img-fluid', 'd-md-none');
            smallImg.style.maxHeight = '3rem';

            header.appendChild(largeImg);
            header.appendChild(smallImg);
            reportContainer.appendChild(header);

            // Add title
            const titleEl = document.createElement('h1');
            titleEl.textContent = 'Feedback Report';
            titleEl.style.textAlign = 'center';
            reportContainer.appendChild(titleEl);

            // Add chart
            const chartImage = chart.getImageURI();
            const chartImgElement = document.createElement('img');
            chartImgElement.src = chartImage;
            chartImgElement.style.width = '100%';
            chartImgElement.style.maxHeight = '400px';
            chartImgElement.style.objectFit = 'contain';
            reportContainer.appendChild(chartImgElement);

            // Recreate table with data
            const tableEl = document.createElement('table');
            tableEl.style.width = '100%';
            tableEl.style.borderCollapse = 'collapse';
            tableEl.style.marginTop = '20px';

            // Create table header
            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');
            ['Rating', 'Room', 'Location', 'Suggestions', 'Date'].forEach(header => {
                const th = document.createElement('th');
                th.textContent = header;
                th.style.border = '1px solid #ddd';
                th.style.padding = '8px';
                th.style.backgroundColor = '#f2f2f2';
                headerRow.appendChild(th);
            });
            thead.appendChild(headerRow);
            tableEl.appendChild(thead);

            // Create table body
            const tbody = document.createElement('tbody');

            // Get all feedback rows from the page
            const feedbackRows = document.querySelectorAll('.table tbody tr');
            
            if (feedbackRows.length === 0) {
                // No feedback data available
                const noDataRow = document.createElement('tr');
                const noDataCell = document.createElement('td');
                noDataCell.colSpan = 5;
                noDataCell.style.textAlign = 'center';
                noDataCell.style.padding = '20px';
                noDataCell.textContent = 'No feedback data available';
                noDataRow.appendChild(noDataCell);
                tbody.appendChild(noDataRow);
            } else {
                // Process feedback rows
                feedbackRows.forEach(row => {
                    const tr = document.createElement('tr');
                    
                    // Extract data from existing table rows
                    const cells = row.querySelectorAll('td');
                    for (let i = 0; i < 5; i++) {
                        const td = document.createElement('td');
                        td.textContent = cells[i].textContent;
                        td.style.border = '1px solid #ddd';
                        td.style.padding = '8px';
                        tr.appendChild(td);
                    }
                    
                    tbody.appendChild(tr);
                });
            }

            tableEl.appendChild(tbody);
            reportContainer.appendChild(tableEl);

            // Add generation date from server
            const dateEl = document.createElement('p');
            dateEl.textContent = `Generated on: ${generatedDate}`;
            dateEl.style.textAlign = 'center';
            reportContainer.appendChild(dateEl);

            // Add to body temporarily
            reportContainer.style.position = 'absolute';
            reportContainer.style.left = '-9999px';
            document.body.appendChild(reportContainer);

            // Convert to image
            html2canvas(reportContainer, {
                scale: 2,
                backgroundColor: 'white',
                useCORS: true,
                logging: true
            }).then(canvas => {
                // Remove the temporary container
                document.body.removeChild(reportContainer);

                // Create download link
                const link = document.createElement('a');
                link.download = 'feedback_report.png';
                link.href = canvas.toDataURL('image/png');
                link.click();
            }).catch(error => {
                // Remove the temporary container
                if (document.body.contains(reportContainer)) {
                    document.body.removeChild(reportContainer);
                }

                console.error('Error converting report to image:', error);

                // Fallback: download just the chart
                const link = document.createElement('a');
                link.download = 'feedback_report.png';
                link.href = chartImage;
                link.click();
            });
        });

        // Initialize DataTable with reduced pagination options and clear actions column
        $(document).ready(function () {
            if ($('#feedbackTable').length) {
                $('#feedbackTable').DataTable({
                    paging: true,
                    searching: true,
                    ordering: true,
                    pageLength: 5,
                    lengthMenu: [5, 10, 15],
                    language: {
                        emptyTable: "No feedback data available"
                    }
                });
            }
        });
    </script>

    <!-- Include jQuery and DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>