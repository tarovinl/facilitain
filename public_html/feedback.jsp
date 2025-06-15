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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
   body, h1, h2, h3, h4,h5 th {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
    h6, input, textarea, td, tr, p, label, select, option {
    font-family: 'NeueHaasLight', sans-serif !important;
}
   .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
                            }

            .hover-outline:hover {
                background-color: 	#1C1C1C !important;
                color: 	#f2f2f2 !important;
                border: 1px solid 	#f2f2f2 !important;
                                }
            .hover-outline img {
                transition: filter 0.3s ease;
                                }

            .hover-outline:hover img {
                filter: invert(1);
                            }

            .buttonsBack:hover {
                text-decoration: underline !important;
                }
            .buildingManage:hover {
                text-decoration: underline !important;
                }

            .qr-button {
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                margin-left: 10px;
            }

            .qr-button:hover {
                background-color: #5a6268;
                color: white;
            }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            <jsp:include page="sidebar.jsp" />

            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1 style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Feedback</h1>
                    <div class="d-flex align-items-center gap-2">
                        <button class=" px-3 py-2 rounded-1 hover-outline d-flex align-items-center" style="background-color: #fccc4c;" id="download-chart" ${empty feedbackList ? 'disabled' : ''}><img src="resources/images/icons/summarize.svg" class="pe-2" alt="generate report icon" width="25" height="25">Generate Report</button>
                        <button id="generateQRBtn" class=" px-3 py-2 rounded-1 hover-outline d-flex align-items-center" style="background-color: #fccc4c;"><img src="resources/images/icons/qr.svg" class="pe-2" alt="qr" width="25" height="25">Generate QR</button>
                    </div>
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
            // Initialize jsPDF
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4'); // Portrait, millimeters, A4
            
            let yPosition = 20;

          
            try {
                // Note:  need to convert your logo to base64 or use a different approach
              
                pdf.setFontSize(20);
                pdf.setFont(undefined, 'bold');
                pdf.text('University of Santo Tomas', 105, yPosition, { align: 'center' });
                yPosition += 10;
                
                pdf.setFontSize(16);
                pdf.text('Feedback Report', 105, yPosition, { align: 'center' });
                yPosition += 20;
            } catch (error) {
                console.warn('Logo could not be added to PDF:', error);
            }

            // Add chart to PDF
            const chartImage = chart.getImageURI();
            if (chartImage) {
                try {
                    pdf.addImage(chartImage, 'PNG', 20, yPosition, 170, 80);
                    yPosition += 90;
                } catch (error) {
                    console.warn('Chart could not be added to PDF:', error);
                    pdf.setFontSize(12);
                    pdf.text('Chart could not be generated', 20, yPosition);
                    yPosition += 10;
                }
            }

            // Add feedback table
            pdf.setFontSize(14);
            pdf.setFont(undefined, 'bold');
            pdf.text('Recent Feedbacks', 20, yPosition);
            yPosition += 10;

            // Get feedback data from the table
            const feedbackRows = document.querySelectorAll('#feedbackTable tbody tr');
            
            if (feedbackRows.length === 0) {
                pdf.setFontSize(12);
                pdf.setFont(undefined, 'normal');
                pdf.text('No feedback data available', 20, yPosition);
                yPosition += 10;
            } else {
                // Table headers
                pdf.setFontSize(10);
                pdf.setFont(undefined, 'bold');
                const headers = ['Rating', 'Room', 'Location', 'Suggestions', 'Equipment', 'Date'];
                const columnWidths = [20, 25, 25, 60, 25, 35];
                let xPosition = 20;
                
                headers.forEach((header, index) => {
                    pdf.text(header, xPosition, yPosition);
                    xPosition += columnWidths[index];
                });
                yPosition += 8;

                // Table data
                pdf.setFont(undefined, 'normal');
                feedbackRows.forEach((row, rowIndex) => {
                    if (yPosition > 270) { // Check if we need a new page
                        pdf.addPage();
                        yPosition = 20;
                    }

                    const cells = row.querySelectorAll('td');
                    xPosition = 20;
                    
                    cells.forEach((cell, cellIndex) => {
                        if (cellIndex < 6) { // Only process first 6 columns
                            let text = cell.textContent.trim();
                            
                            // Truncate long text to fit in column
                            if (cellIndex === 3 && text.length > 30) { // Suggestions column
                                text = text.substring(0, 27) + '...';
                            } else if (text.length > 15 && cellIndex !== 3) {
                                text = text.substring(0, 12) + '...';
                            }
                            
                            pdf.text(text, xPosition, yPosition);
                            xPosition += columnWidths[cellIndex];
                        }
                    });
                    yPosition += 6;
                });
            }

            // Add generation date
            yPosition += 10;
            if (yPosition > 270) {
                pdf.addPage();
                yPosition = 20;
            }
            
            pdf.setFontSize(10);
            pdf.setFont(undefined, 'italic');
            pdf.text(`Generated on: ${generatedDate}`, 105, yPosition, { align: 'center' });

            // Save the PDF
            pdf.save('feedback_report.pdf');
        });

        // QR Code download functionality
        document.getElementById('generateQRBtn').addEventListener('click', function() {
            // Create a temporary anchor element to trigger download
            const link = document.createElement('a');
            // Use relative path instead of absolute path
            link.href = './resources/images/feedback-qr.png'; 
            link.download = 'feedback-qr.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
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