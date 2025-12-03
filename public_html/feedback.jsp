<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Feedback - Facilitain</title>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
   body, h1, h2, h3, h4,h5 th {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
    h6, input, textarea, td, tr, p, label, select, option {
    font-family: 'NeueHaasLight', sans-serif !important;
}
   .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent;
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
            .responsive-padding-top {
                  padding-top: 100px;
                }
                
                @media (max-width: 576px) {
                  .responsive-padding-top {
                    padding-top: 80px;
                  }
                }
            
            
            .btn-cancel-outline {
                color: #8388a4 !important;
                background-color: white !important;
                border: 2px solid #8388a4 !important;
                box-shadow: none !important;
            }
            
            .btn-cancel-outline:hover {
                background-color: #f0f2f7 !important; 
                border-color: #8388a4 !important;
                color: #8388a4 !important;
            }

            .dataTables_filter {
                margin-bottom: 20px; 
            }

            .dataTables_length select {
                min-width: 80px !important;
                width: auto !important;
                padding: 5px 30px 5px 10px !important;
                margin: 0 8px !important;
                display: inline-block !important;
            }

            .dataTables_length {
                margin-bottom: 15px;
            }
            
            .dataTables_length label {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
          .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.5rem 1rem;
            margin: 0 2px;
            border: 1px solid #dee2e6 !important;
            border-radius: 4px;
            background: white !important;
            color: #0d6efd !important;
            box-shadow: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #e9ecef !important;
            border-color: #dee2e6 !important;
            color: #0d6efd !important;
            box-shadow: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background: #0d6efd !important;
            color: white !important;
            border-color: #0d6efd !important;
            box-shadow: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover {
            opacity: 0.5;
            cursor: not-allowed;
            background: white !important;
            border-color: #dee2e6 !important;
        }
        
        /* Remove outer box from pagination */
        .dataTables_wrapper .dataTables_paginate {
            border: none !important;
            background: none !important;
            padding: 0 !important;
            box-shadow: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate span {
            border: none !important;
            background: none !important;
            padding: 0 !important;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
    <div class="container-fluid">
        <div class="row min-vh-100">
        <c:set var="page" value="feedback" scope="request"/>
            <jsp:include page="sidebar.jsp" />

            <div class="col-md-10 responsive-padding-top">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2">
                    <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Feedback</h1>
                    <div class="d-flex align-items-center gap-2">
                        <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" style="background-color: #fccc4c;" id="download-chart" ${empty feedbackList ? 'disabled' : ''}> <img src="resources/images/icons/summarize.svg"  alt="generate report icon" width="25" height="25"><span class="d-none d-lg-inline ps-2">Generate Report</span></button>
                        <button id="generateQRBtn" class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center" style="background-color: #fccc4c;"><img src="resources/images/icons/qr.svg"  alt="qr" width="25" height="25"><span class="d-none d-lg-inline ps-2">Download QR</span></button>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Satisfaction Rate (Monthly)</h5>
                        <div id="chart_div" style="width: 100%; height: 400px"></div>
                    </div>
                </div>

                <!-- Feedback Table -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">All Feedback</h5>
                        
                        <c:choose>
                            <c:when test="${empty feedbackList}">
                                <div class="text-center p-5">
                                    <i class="bi bi-clipboard-x fs-1 text-muted"></i>
                                    <h4 class="mt-3">No Feedback Data Available</h4>
                                    <p class="text-muted">Feedback will appear here when users submit their responses.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table id="feedbackTable" class="table table-striped table-bordered">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Rating</th>
                                            <th>Room</th>
                                            <th>Location</th>
                                            <th style="width: 35%;">Suggestions</th>
                                            <th>Equipment Type</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-light">
                                        <c:forEach var="feedback" items="${feedbackList}">
                                            <tr>
                                                <td><fmt:formatNumber value="${feedback.rating}" maxFractionDigits="2" minFractionDigits="0" /></td>
                                                <td>${feedback.room}</td>
                                                <td>${feedback.location}</td>
                                                <td style="white-space: normal; word-wrap: break-word; max-width: 400px;">${feedback.suggestions}</td>
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
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('p', 'mm', 'a4');
    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 15;
    let yPosition = 20;

    // Get current date and time
    const now = new Date();
    const reportDate = now.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
    const reportTime = now.toLocaleTimeString('en-US', { 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: true 
    });

    // Helper function to check if we need a new page
    function checkPageBreak(requiredSpace) {
        if (yPosition + requiredSpace > pageHeight - margin - 20) {
            pdf.addPage();
            yPosition = margin + 30;
            return true;
        }
        return false;
    }

    function drawTable(headers, data, startY, columnWidths = null) {
        const tableWidth = pageWidth - (2 * margin);
        
        if (!columnWidths) {
            const colWidth = tableWidth / headers.length;
            columnWidths = Array(headers.length).fill(colWidth);
        }
        
        const rowHeight = 8;
        let currentY = startY;

        // Draw header with dark grey background 
        pdf.setFillColor(51, 51, 51);
        pdf.setTextColor(255, 255, 255);
        pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
        
        pdf.setFontSize(9);
        pdf.setFont('helvetica', 'bold');
        let xPos = margin;
        headers.forEach((header, i) => {
            pdf.text(header, xPos + 2, currentY + 5.5);
            xPos += columnWidths[i];
        });
        
        currentY += rowHeight;
        pdf.setTextColor(0, 0, 0);

        // Draw data rows
        pdf.setFontSize(8);
        pdf.setFont('helvetica', 'normal');
        data.forEach((row, rowIndex) => {
            if (currentY + rowHeight > pageHeight - margin - 20) {
                pdf.addPage();
                currentY = margin + 30;
                
                // Redraw header on new page
                pdf.setFillColor(51, 51, 51);
                pdf.setTextColor(255, 255, 255);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
                pdf.setFontSize(9);
                pdf.setFont('helvetica', 'bold');
                xPos = margin;
                headers.forEach((header, i) => {
                    pdf.text(header, xPos + 2, currentY + 5.5);
                    xPos += columnWidths[i];
                });
                currentY += rowHeight;
                pdf.setTextColor(0, 0, 0);
                pdf.setFontSize(8);
                pdf.setFont('helvetica', 'normal');
            }

            // Alternate row colors
            if (rowIndex % 2 === 0) {
                pdf.setFillColor(245, 245, 245);
                pdf.rect(margin, currentY, tableWidth, rowHeight, 'F');
            }

            // Draw cell borders and text
            xPos = margin;
            row.forEach((cell, i) => {
                pdf.rect(xPos, currentY, columnWidths[i], rowHeight);
                
                let cellText = String(cell);
                const colWidth = columnWidths[i];
                
                const maxChars = Math.floor(colWidth / 1.5);
                if (cellText.length > maxChars) {
                    cellText = cellText.substring(0, maxChars - 3) + '...';
                }
                
                pdf.text(cellText, xPos + 2, currentY + 5.5, { maxWidth: colWidth - 4 });
                xPos += columnWidths[i];
            });
            
            currentY += rowHeight;
        });

        return currentY;
    }

    // Helper function to add footer
    function addFooter() {
        const footerY = pageHeight - 10;
        
        pdf.setFillColor(255, 255, 255);
        pdf.rect(0, footerY - 5, pageWidth, 15, 'F');
        
        pdf.setFontSize(8);
        pdf.setFont('helvetica', 'italic');
        pdf.setTextColor(128, 128, 128);
        
        pdf.text('Generated on: ' + reportDate + ' at ' + reportTime, margin, footerY);
        pdf.text('University of Santo Tomas - Facilities Management Office', pageWidth / 2, footerY, { align: 'center' });
    }

    // Load and add logo 
    const logoImg = new Image();
    logoImg.src = './resources/images/USTLogo2.png';
    
    logoImg.onload = function() {
        // Add dark header background 
        pdf.setFillColor(51, 51, 51);
        pdf.rect(0, 0, pageWidth, 25, 'F');

        // Add logo to header
        const imgWidth = logoImg.width;
        const imgHeight = logoImg.height;
        const aspectRatio = imgWidth / imgHeight;
        const logoHeight = 13;
        const logoWidth = logoHeight * aspectRatio;
        
        pdf.addImage(logoImg, 'PNG', margin, 6, logoWidth, logoHeight);

        yPosition = 35;
        
        generatePDFContent();
    };
    
    logoImg.onerror = function() {
        yPosition = margin;
        generatePDFContent();
    };
    
    function generatePDFContent() {
        // Title 
        pdf.setFontSize(16);
        pdf.setFont('helvetica', 'bold');
        pdf.setTextColor(0, 0, 0);
        pdf.text('Facilities Management Office - Feedback Report', pageWidth / 2, yPosition, { align: 'center' });
        yPosition += 12;

        // SECTION 1: Monthly Satisfaction Rates (with CHART)
        checkPageBreak(100);
        pdf.setFontSize(14);
        pdf.setFont('helvetica', 'bold');
        pdf.text('Monthly Satisfaction Rates (Current Year)', margin, yPosition);
        yPosition += 15;

        const satisfactionData = ${not empty satisfactionRates ? 'true' : 'false'};
        if (satisfactionData) {
            // Capture bar chart as image
            const chartDiv = document.getElementById('chart_div');
            html2canvas(chartDiv, {
                backgroundColor: '#ffffff',
                scale: 2
            }).then(canvas => {
                const chartImgData = canvas.toDataURL('image/png');
                const chartY = yPosition;
                const chartHeight = 70;
                const chartWidth = 180;
                const chartX = (pageWidth - chartWidth) / 2 + 6;
                
                pdf.addImage(chartImgData, 'PNG', chartX, chartY, chartWidth, chartHeight);

                yPosition = chartY + chartHeight + 5;

                // Add satisfaction rates table below chart
                const monthlyData = [];
                <c:forEach var="rate" items="${satisfactionRates}">
                monthlyData.push(['${rate[0]}', '${rate[1]}']);
                </c:forEach>
                
                const tableWidth = pageWidth - (2 * margin);
                yPosition = drawTable(['Month', 'Satisfaction Rate'], monthlyData, yPosition, [tableWidth/2, tableWidth/2]);

                yPosition += 10;

                // SECTION 2: Last 10 Recent Feedbacks
                checkPageBreak(50);
                pdf.setFontSize(14);
                pdf.setFont('helvetica', 'bold');
                pdf.text('Recent Feedback (Last 10)', margin, yPosition);
                yPosition += 8;

                const feedbackRows = document.querySelectorAll('#feedbackTable tbody tr');
                
                if (feedbackRows.length === 0) {
                    pdf.setFontSize(10);
                    pdf.setFont('helvetica', 'normal');
                    pdf.text('No feedback data available', margin + 5, yPosition);
                    yPosition += 6;
                } else {
                    const feedbackData = [];
                    const maxRows = Math.min(10, feedbackRows.length);
                    
                    for (let i = 0; i < maxRows; i++) {
                        const cells = feedbackRows[i].querySelectorAll('td');
                        const rating = cells[0].textContent.trim();
                        const room = cells[1].textContent.trim();
                        const location = cells[2].textContent.trim();
                        const suggestions = cells[3].textContent.trim();
                        const equipment = cells[4].textContent.trim();
                        const date = cells[5].textContent.trim();
                        
                        feedbackData.push([rating, room, location, suggestions, equipment, date]);
                    }
                    
                    const feedbackWidths = [18, 28, 32, 40, 32, 30];
                    yPosition = drawTable(
                        ['Rating', 'Room', 'Location', 'Suggestions', 'Equipment', 'Date'], 
                        feedbackData, 
                        yPosition,
                        feedbackWidths
                    );
                }

                // Add footer to all pages
                const totalPages = pdf.internal.getNumberOfPages();
                for (let i = 1; i <= totalPages; i++) {
                    pdf.setPage(i);
                    addFooter();
                }

                // Open PDF in new tab
                const pdfBlob = pdf.output('blob');
                const pdfUrl = URL.createObjectURL(pdfBlob);
                const newWindow = window.open(pdfUrl, '_blank');
                
                setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
            });
        } else {
            pdf.setFontSize(10);
            pdf.setFont('helvetica', 'normal');
            pdf.text('No satisfaction data available', margin + 5, yPosition);
            yPosition += 6;

            yPosition += 10;

            // SECTION 2: Last 10 Recent Feedbacks
            checkPageBreak(50);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('Recent Feedback (Last 10)', margin, yPosition);
            yPosition += 8;

            const feedbackRows = document.querySelectorAll('#feedbackTable tbody tr');
            
            if (feedbackRows.length === 0) {
                pdf.setFontSize(10);
                pdf.setFont('helvetica', 'normal');
                pdf.text('No feedback data available', margin + 5, yPosition);
                yPosition += 6;
            } else {
                const feedbackData = [];
                const maxRows = Math.min(10, feedbackRows.length);
                
                for (let i = 0; i < maxRows; i++) {
                    const cells = feedbackRows[i].querySelectorAll('td');
                    const rating = cells[0].textContent.trim();
                    const room = cells[1].textContent.trim();
                    const location = cells[2].textContent.trim();
                    const suggestions = cells[3].textContent.trim();
                    const equipment = cells[4].textContent.trim();
                    const date = cells[5].textContent.trim();
                    
                    feedbackData.push([rating, room, location, suggestions, equipment, date]);
                }
                
                const feedbackWidths = [18, 28, 32, 40, 32, 30];
                yPosition = drawTable(
                    ['Rating', 'Room', 'Location', 'Suggestions', 'Equipment', 'Date'], 
                    feedbackData, 
                    yPosition,
                    feedbackWidths
                );
            }

            // Add footer to all pages
            const totalPages = pdf.internal.getNumberOfPages();
            for (let i = 1; i <= totalPages; i++) {
                pdf.setPage(i);
                addFooter();
            }

            // Open PDF in new tab
            const pdfBlob = pdf.output('blob');
            const pdfUrl = URL.createObjectURL(pdfBlob);
            const newWindow = window.open(pdfUrl, '_blank');
            
            setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
        }
    }
});
        
        // QR Code download functionality
        document.getElementById('generateQRBtn').addEventListener('click', function() {
            const link = document.createElement('a');
            link.href = './resources/images/feedback-qr.png'; 
            link.download = 'feedback-qr.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });

    </script>

    <!-- Include jQuery and DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    $(document).ready(function() {
        // Initialize DataTable with default ordering by date (column 5) descending
        $('#feedbackTable').DataTable({
            order: [[5, 'desc']] // Sort by Date column (index 5) in descending order
        });

        // Handle SweetAlert2 notifications for success/error messages
        const urlParams = new URLSearchParams(window.location.search);
        const action = urlParams.get('action');
        const error = urlParams.get('error');

        if (action || error) {
            let alertConfig = {
                confirmButtonText: 'OK',
                allowOutsideClick: false
            };

            if (error) {
                alertConfig = {
                    ...alertConfig,
                    title: 'Error!',
                    text: 'An error occurred while processing your request.',
                    icon: 'error'
                };
            } else {
                switch(action) {
                    case 'deleted':
                        alertConfig = {
                            ...alertConfig,
                            title: 'Deleted!',
                            text: 'The feedback has been successfully deleted.',
                            icon: 'success'
                        };
                        break;
                }
            }

            Swal.fire(alertConfig).then(() => {
                // Remove the parameters from the URL without refreshing
                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            });
        }

        // Delete confirmation handler
        $(document).on('submit', '.delete-form', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const formElement = this;
            
            Swal.fire({
                title: 'Are you sure?',
                text: 'You want to delete this feedback?',
                icon: 'warning',
                showCancelButton: true,
                reverseButtons: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it',
                cancelButtonText: 'Cancel',
                customClass: {
                    cancelButton: 'btn-cancel-outline'
                },
                allowOutsideClick: false,
                allowEscapeKey: false
            }).then((result) => {
                if (result.isConfirmed) {
                    formElement.submit();
                }
            });
            
            return false;
        });
    });
    </script>
</body>
</html>