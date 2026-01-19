<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String currentDate = sdf.format(new java.util.Date());
%>

<%
    request.setAttribute("locID", request.getParameter("locID"));
%>
<c:set var="matchFound" value="false" />

<c:forEach items="${locations}" var="location">
    <c:if test="${location.itemLocId == locID}">
        <c:set var="matchFound" value="true" />
        <c:set var="locID2" value="${location.itemLocId}" />
    </c:if>
</c:forEach>
<c:set var="currentYear" value="${currentYear}" />
<c:set var="currentMonth" value="${currentMonth}" />
<%--<c:if test="${matchFound == false}">
    <script>
        window.location.href = './homepage'; 
    </script>
</c:if>--%>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>All Equipments Dashboard</title>
        <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
        <link rel="stylesheet" href="./resources/css/bDash.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="./resources/css/custom-fonts.css">
        <script src="https://www.gstatic.com/charts/loader.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
        <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
        <style>
        body, h1, h2, h3, h4,h5, h6, th,label,.custom-label {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
 input, textarea, td, tr, p, select, option,id {
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
            .responsive-padding-top {
              padding-top: 80px;
            }
            
            @media (max-width: 576px) {
              .responsive-padding-top {
                padding-top: 70px; /* or whatever smaller value you want */
              }
            }

</style>
        <script>
        var locIDajax = 'allEquip';

        google.charts.load('current', {packages: ['corechart']});
        google.charts.setOnLoadCallback(drawCharts);
        // AI was used to understand how to draw the pie chart and have multiple charts in one page
        // Tool: ChatGPT, Prompts: "How to use Google Charts API to draw a Pie Chart?", "How do I render both a pie chart and a column chart on the same page?"
        function drawCharts() {
        drawPieChart();
        drawColumnChart();
        }
        
        function drawPieChart() {
                fetch('<%= request.getContextPath() %>/PendingMaintServlet?locID=' + locIDajax)
                .then(response => response.json())
                .then(dataList => {
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'Item Category');
                    data.addColumn('number', 'MaintenanceNo');
    
                    dataList.forEach(row => {
                        data.addRow([row.category, row.count]);
                    });
    
                    var options = {
                        chartArea: {
                            left: 20,
                            width: '80%',
                            height: '80%'
                        }
                    };
    
                    var chart = new google.visualization.PieChart(
                        document.getElementById('pendingMainChart')
                    );
                    chart.draw(data, options);
                })
                .catch(err => console.error('Error loading chart data:', err));
        }
        
        function drawColumnChart() {
        // Create the data table for the column chart.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Month');
        data.addColumn('number', 'No. of Repairs');
        data.addRows([
            <c:forEach var="month" items="${monthsList}" varStatus="status">
                <c:set var="repairCount" value="0" />
                <c:set var="monthNumber" value="${status.index + 1}" />
                <c:forEach var="repair" items="${ALL_REPAIRS_PER_MONTH}">
                    <c:if test="${repair.repairMonth == monthNumber}">
                        <c:set var="repairCount" value="${repair.repairCount}" />
                    </c:if>
                </c:forEach>
                ['${month}', ${repairCount}],
            </c:forEach>
        ]);
        // Set options for the column chart
        var options = {
            hAxis: { title: '${currentYear}' },
            vAxis: { title: 'Repairs' },
            colors: ['#fccc4c'],
            legend: { position: 'none' }
        };
        // Instantiate and draw the column chart
        var chart = new google.visualization.ColumnChart(document.getElementById('repairNoChart'));
        console.log("Column Chart Data:", data.toJSON());
        chart.draw(data, options);
        }



// Show modal when Generate Report button is clicked
function generateReport() {
    const reportModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    reportModal.show();
}

// Initialize all event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Radio button change handler
    document.querySelectorAll('input[name="reportType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const dateInputs = document.getElementById('dateRangeInputs');
            if (this.value === 'range') {
                dateInputs.style.display = 'block';
                document.getElementById('startDate').required = true;
                document.getElementById('endDate').required = true;
            } else {
                dateInputs.style.display = 'none';
                document.getElementById('startDate').required = false;
                document.getElementById('endDate').required = false;
                document.getElementById('dateError').style.display = 'none';
            }
        });
    });

    // Date validation function
    function validateDates() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        const dateError = document.getElementById('dateError');
        
        if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
            dateError.style.display = 'block';
            return false;
        }
        dateError.style.display = 'none';
        return true;
    }

    // Date change listeners
    document.getElementById('startDate').addEventListener('change', validateDates);
    document.getElementById('endDate').addEventListener('change', validateDates);

    // Generate report button handler
    document.getElementById('generateReportBtn').addEventListener('click', function() {
        const reportType = document.querySelector('input[name="reportType"]:checked').value;
        
        if (reportType === 'range') {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (!startDate || !endDate) {
                alert('Please select both start and end dates');
                return;
            }
            
            if (!validateDates()) {
                return;
            }
            
            // Close modal and generate filtered report
            bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
            generateFilteredReport(new Date(startDate), new Date(endDate));
        } else {
            // Close modal and generate full report
            bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
            generateFullReport();
        }
    });

    // Load activities
    fetch('upcomingactservlet?locID=' + locIDajax)
        .then(res => res.text())
        .then(html => document.getElementById('upcoming-activities').innerHTML = html)
        .catch(err => console.error('Error loading upcoming activities:', err));

    fetch('recentactservlet?locID=' + locIDajax)
        .then(res => res.text())
        .then(html => document.getElementById('recent-activities').innerHTML = html)
        .catch(err => console.error('Error loading recent activities:', err));
});

// Get repairs data filtered by date range
function getRepairsDataForRange(startDate, endDate) {
    const repairsData = [];

    const compareStart = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
    const compareEnd = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);

    <c:forEach var="month" items="${monthsList}" varStatus="status">
    {
        let monthDate = new Date(${currentYear}, ${status.index}, 15);

        if (monthDate >= compareStart && monthDate <= compareEnd) {
            repairsData.push(['${month}', ${repairCount}]);
        }
    }
    </c:forEach>

    return repairsData;
}

// Draw filtered column chart for PDF
function drawFilteredColumnChart(startDate, endDate) {
    return new Promise((resolve) => {
        const chartDiv = document.createElement('div');
        chartDiv.style.width = '800px';
        chartDiv.style.height = '400px';
        chartDiv.style.position = 'absolute';
        chartDiv.style.left = '-9999px';
        document.body.appendChild(chartDiv);
        
        const repairsData = getRepairsDataForRange(startDate, endDate);
        
        if (repairsData.length === 0) {
            document.body.removeChild(chartDiv);
            resolve(null);
            return;
        }
        
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Month');
        data.addColumn('number', 'No. of Repairs');
        data.addRows(repairsData);
        
        var options = {
            hAxis: { title: 'Period' },
            vAxis: { title: 'Repairs/Replacements' },
            colors: ['#fccc4c'],
            legend: { position: 'none' },
            width: 800,
            height: 400
        };
        
        var tempChart = new google.visualization.ColumnChart(chartDiv);
        
        google.visualization.events.addListener(tempChart, 'ready', function() {
            const imgURI = tempChart.getImageURI();
            document.body.removeChild(chartDiv);
            resolve(imgURI);
        });
        
        tempChart.draw(data, options);
    });
}

// Generate full report (all data)
function generateFullReport() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4'
    });

    const locName = '${locName}';
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

    doc.setFillColor(51, 51, 51);
    doc.rect(0, 0, 210, 25, 'F');

    const logoImg = new Image();
    logoImg.src = 'resources/images/USTLogo.png';
    
    logoImg.onload = function() {
        doc.addImage(logoImg, 'PNG', 15, 5, 65, 13);

        const contentStartY = 30;
        const pageHeight = doc.internal.pageSize.getHeight();

        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.setTextColor(0, 0, 0);
        doc.text(locName, 105, contentStartY + 10, {align: 'center'});

        doc.setFontSize(14);
        doc.setFont(undefined, 'bold');
        doc.text("Pending Maintenance", 105, contentStartY + 25, {align: 'center'});
        doc.setFont(undefined, 'normal');

        const pieChartDiv = document.getElementById('pendingMainChart');
        html2canvas(pieChartDiv, {
            backgroundColor: '#ffffff',
            scale: 2
        }).then(canvas => {
            const pieImgData = canvas.toDataURL('image/png');
            const pieChartY = contentStartY + 30;
            const pieChartHeight = 65;
            const pieChartWidth = 175;
            const pieChartX = (210 - pieChartWidth) / 2;
            
            doc.addImage(pieImgData, 'PNG', pieChartX, pieChartY, pieChartWidth, pieChartHeight);

            fetch('reportpieservlet?locID=' + locIDajax)
                .then(response => response.json())
                .then(dataList => {
                    const tableStartY = pieChartY + pieChartHeight + 5;

                    if (!Array.isArray(dataList) || dataList.length === 0) {
                        doc.setFontSize(12);
                        doc.setTextColor(100, 100, 100);
                        doc.text("No pending maintenance data available.", 105, tableStartY + 5, {align: 'center'});
                    } else {
                        const bodyData = dataList.map(item => [
                            item.category,
                            item.count
                        ]);

                        doc.autoTable({
                            startY: tableStartY,
                            margin: { left: 20, right: 20 },
                            head: [["Category", "Number of Equipment Pending Maintenance"]],
                            body: bodyData,
                            theme: 'grid',
                            headStyles: {
                                fillColor: [51, 51, 51],
                                textColor: [255, 255, 255],
                                fontStyle: 'bold'
                            },
                            styles: {
                                cellPadding: 5,
                                fontSize: 11,
                                valign: 'middle'
                            },
                            columnStyles: {
                                0: { halign: 'left', cellWidth: 'auto' },
                                1: { halign: 'center', cellWidth: 'auto' }
                            }
                        });
                    }

                    let afterPendingY = tableStartY + 60;
                    if (doc.lastAutoTable && doc.lastAutoTable.finalY) {
                        afterPendingY = doc.lastAutoTable.finalY + 20;
                    }

                    doc.setTextColor(0, 0, 0);
                    doc.setFontSize(14);
                    doc.setFont(undefined, 'bold');
                    doc.text("Repairs and Replacements per Month", 105, afterPendingY, {align: 'center'});
                    doc.setFont(undefined, 'normal');

                    const columnChartDiv = document.getElementById('repairNoChart');
                    html2canvas(columnChartDiv, {
                        backgroundColor: '#ffffff',
                        scale: 2
                    }).then(columnCanvas => {
                        const columnImgData = columnCanvas.toDataURL('image/png');
                        const columnChartY = afterPendingY + 5;
                        const columnChartHeight = 60;
                        const columnChartWidth = 120;
                        const columnChartX = (210 - columnChartWidth) / 2;
                        
                        doc.addImage(columnImgData, 'PNG', columnChartX, columnChartY, columnChartWidth, columnChartHeight);

                        const repairsData = [];
                        <c:forEach var="month" items="${monthsList}" varStatus="status">
                            <c:set var="repairCount2" value="0" />
                            <c:set var="monthNumber2" value="${status.index + 1}" />
                            <c:forEach var="repair" items="${REPAIRS_PER_MONTH}">
                                <c:if test="${repair.repairLocID == locID2}">
                                    <c:if test="${repair.repairYear == currentYear}">
                                        <c:if test="${repair.repairMonth == monthNumber2}">
                                            <c:set var="repairCount2" value="${repair.repairCount}" />
                                        </c:if>
                                    </c:if>
                                </c:if>
                            </c:forEach>
                            repairsData.push(['${month}', '${repairCount2}']);
                        </c:forEach>

                        const repairsTableY = columnChartY + columnChartHeight + 5;

                        doc.autoTable({
                            startY: repairsTableY,
                            margin: {left: 20, right: 20, bottom: 25},
                            head: [["Month", "Number of Repairs"]],
                            body: repairsData,
                            theme: 'grid',
                            headStyles: {
                                fillColor: [51, 51, 51],
                                textColor: [255, 255, 255],
                                fontStyle: 'bold'
                            },
                            styles: {
                                cellPadding: 5,
                                fontSize: 11,
                                valign: 'middle'
                            },
                            columnStyles: {
                                0: { halign: 'left', cellWidth: 'auto' },
                                1: { halign: 'center', cellWidth: 'auto' }
                            }
                        });

                        const footerY = pageHeight - 10;
                        doc.setFontSize(8);
                        doc.setFont('helvetica', 'italic');
                        doc.setTextColor(128, 128, 128);
                        
                        doc.text('Generated on: ' + reportDate + ' at ' + reportTime, 15, footerY);
                        doc.text('University of Santo Tomas - Facilities Management Office', 105, footerY, { align: 'left' });

                        const pdfBlob = doc.output('blob');
                        const pdfUrl = URL.createObjectURL(pdfBlob);
                        const newWindow = window.open(pdfUrl, '_blank');
                        
                        if (newWindow) {
                            newWindow.document.title = locName + '_Maintenance_Report.pdf';
                        }
                        
                        setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
                    });
                })
                .catch(error => {
                    console.error('Error generating PDF:', error);
                    alert('Error generating PDF. Please check console for details.');
                });
        });
    };
}

// Generate filtered report (date range)
async function generateFilteredReport(startDate, endDate) {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4'
    });

    const locName = '${locName}';
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

    doc.setFillColor(51, 51, 51);
    doc.rect(0, 0, 210, 25, 'F');

    const logoImg = new Image();
    logoImg.src = 'resources/images/USTLogo.png';
    
    logoImg.onload = async function() {
        doc.addImage(logoImg, 'PNG', 15, 5, 65, 13);

        const contentStartY = 30;
        const pageHeight = doc.internal.pageSize.getHeight();

        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.setTextColor(0, 0, 0);
        doc.text(locName, 105, contentStartY + 10, {align: 'center'});
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        const dateRangeText = 'Period: ' + startDate.toLocaleDateString() + ' to ' + endDate.toLocaleDateString();
        doc.text(dateRangeText, 105, contentStartY + 18, {align: 'center'});

        doc.setFontSize(14);
        doc.setFont(undefined, 'bold');
        doc.text("Pending Maintenance", 105, contentStartY + 30, {align: 'center'});
        doc.setFont(undefined, 'normal');

        const pieChartDiv = document.getElementById('pendingMainChart');
        const pieCanvas = await html2canvas(pieChartDiv, {
            backgroundColor: '#ffffff',
            scale: 2
        });
        
        const pieImgData = pieCanvas.toDataURL('image/png');
        const pieChartY = contentStartY + 35;
        const pieChartHeight = 65;
        const pieChartWidth = 175;
        const pieChartX = (210 - pieChartWidth) / 2;
        
        doc.addImage(pieImgData, 'PNG', pieChartX, pieChartY, pieChartWidth, pieChartHeight);

        const dataList = await fetch('reportpieservlet?locID=' + locIDajax).then(r => r.json());
        
        const tableStartY = pieChartY + pieChartHeight + 5;

        if (!Array.isArray(dataList) || dataList.length === 0) {
            doc.setFontSize(12);
            doc.setTextColor(100, 100, 100);
            doc.text("No pending maintenance data available.", 105, tableStartY + 5, {align: 'center'});
        } else {
            const bodyData = dataList.map(item => [item.category, item.count]);

            doc.autoTable({
                startY: tableStartY,
                margin: { left: 20, right: 20 },
                head: [["Category", "Number of Equipment Pending Maintenance"]],
                body: bodyData,
                theme: 'grid',
                headStyles: {
                    fillColor: [51, 51, 51],
                    textColor: [255, 255, 255],
                    fontStyle: 'bold'
                },
                styles: {
                    cellPadding: 5,
                    fontSize: 11,
                    valign: 'middle'
                },
                columnStyles: {
                    0: { halign: 'left', cellWidth: 'auto' },
                    1: { halign: 'center', cellWidth: 'auto' }
                }
            });
        }

        let afterPendingY = tableStartY + 60;
        if (doc.lastAutoTable && doc.lastAutoTable.finalY) {
            afterPendingY = doc.lastAutoTable.finalY + 20;
        }

        doc.setTextColor(0, 0, 0);
        doc.setFontSize(14);
        doc.setFont(undefined, 'bold');
        doc.text("Repairs and Replacements (Filtered Period)", 105, afterPendingY, {align: 'center'});
        doc.setFont(undefined, 'normal');

        const columnImgData = await drawFilteredColumnChart(startDate, endDate);
        
        if (columnImgData) {
            const columnChartY = afterPendingY + 5;
            const columnChartHeight = 60;
            const columnChartWidth = 120;
            const columnChartX = (210 - columnChartWidth) / 2;
            
            doc.addImage(columnImgData, 'PNG', columnChartX, columnChartY, columnChartWidth, columnChartHeight);

            const filteredRepairsData = getRepairsDataForRange(startDate, endDate);
            const repairsTableY = columnChartY + columnChartHeight + 5;

            doc.autoTable({
                startY: repairsTableY,
                margin: {left: 20, right: 20, bottom: 25},
                head: [["Month", "Number of Repairs"]],
                body: filteredRepairsData,
                theme: 'grid',
                headStyles: {
                    fillColor: [51, 51, 51],
                    textColor: [255, 255, 255],
                    fontStyle: 'bold'
                },
                styles: {
                    cellPadding: 5,
                    fontSize: 11,
                    valign: 'middle'
                },
                columnStyles: {
                    0: { halign: 'left', cellWidth: 'auto' },
                    1: { halign: 'center', cellWidth: 'auto' }
                }
            });
        } else {
            doc.setFontSize(12);
            doc.setTextColor(100, 100, 100);
            doc.text("No repairs data available for selected period.", 105, afterPendingY + 10, {align: 'center'});
        }

        const footerY = pageHeight - 10;
        doc.setFontSize(8);
        doc.setFont('helvetica', 'italic');
        doc.setTextColor(128, 128, 128);
        
        doc.text('Generated on: ' + reportDate + ' at ' + reportTime, 15, footerY);
        doc.text('University of Santo Tomas - Facilities Management Office', 105, footerY, { align: 'left' });

        const pdfBlob = doc.output('blob');
        const pdfUrl = URL.createObjectURL(pdfBlob);
        const newWindow = window.open(pdfUrl, '_blank');
        
        if (newWindow) {
            newWindow.document.title = locName + '_Maintenance_Report.pdf';
        }
        
        setTimeout(() => URL.revokeObjectURL(pdfUrl), 100);
    };
}


document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('.buttonsBuilding:nth-child(2)').addEventListener('click', generateReport);
});
        </script>
    </head>
    <body style="background-color: #efefef;">
    <jsp:include page="navbar.jsp"/>
    <jsp:include page="sidebar.jsp"/>
<div class="container-fluid">
      <div class="row min-vh-100">
    <div class="col-md-10  responsive-padding-top">
         <div class="row align-items-center d-flex mb-4">
  <!-- Left: Back Button -->
  <div class="col d-flex align-items-center">
    <a href="./homepage"
       class="buttonsBack d-flex align-items-center text-decoration-none text-dark fs-4"
       style="font-family: NeueHaasLight, sans-serif;">
      <img src="resources/images/icons/angle-left-solid.svg" alt="back icon" width="20" height="20">
      <span class="d-none d-sm-inline ps-2">Back</span>
    </a>
  </div>

  <!-- Right: Edit and Generate Buttons -->
  <div class="col-auto d-flex justify-content-end align-items-center gap-2 flex-wrap">

    <button onclick="generateReport()"
        class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center"
        style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;">
  <img src="resources/images/icons/summarize.svg" alt="generate report icon" width="25" height="25">
  <span class="d-none d-lg-inline ps-2">Generate Report</span>
</button>

  </div>
</div>

          
<div class="container-fluid d-flex flex-column" style="min-height: 80vh;">
  <div class="row flex-grow-1" style="min-height: 40vh;">
    <div class="col-12 col-lg-8 vh-25 align-items-stretch mb-4">
        <div class="buildingBanner rounded-4" style="margin-top: 14px; background-image: 
                                    linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 100%), 
                                    url('resources/images/samplebuilding.jpg'); background-size: cover; background-position: center; height: 80%; display: flex; flex-direction:column;justify-content: flex-end;">
            <!--<div class="statusDiv">
                <img src="resources/images/greenDot.png" alt="building status indicator" width="56" height="56">
            </div>-->
            <div class="buildingName text-light" style="font-family: NeueHaasMedium, sans-serif;">
                <h1>All Equipment</h1>
            </div>
            <div>
                                <a href="allDashboard/manage" 
                                class="buildingManage d-flex align-items-center text-decoration-none text-white fs-3" 
                                style="font-family: NeueHaasLight, sans-serif;">
                                Manage
                                <img src="resources/images/icons/angle-right-solid.svg" alt="next icon" width="25" height="25">
                                </a>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-4 vh-25 align-items-stretch mb-4" style="margin-top: 14px;">
      	    <div class="diagram" style="height: 83%;">
              <div class="diagramTitle">
                <h4 style=" font-family: NeueHaasMedium, sans-serif !important;">Repairs per Month</h4>
              </div>
              <div style="background: white; height: 240px; border-radius:15px;">
                <div id="repairNoChart" style="height: 100%; width: 100%; overflow: hidden; border-radius:15px;"></div>
              </div>
            </div>
    </div>
  </div>
  <div class="row flex-grow-1" style="min-height: 40vh;">
    <div class="col-12 col-lg-4 mb-3 vh-25 align-items-stretch ">
      <div class="diagram" style="height: 80%;">
              <div class="diagramTitle">
                <h4 style=" font-family: NeueHaasMedium, sans-serif !important;">Upcoming Activities</h4>
              </div>
              <div class="actContainer" id="upcoming-activities">
                
              </div>
            </div>
    </div>
    <div class="col-12 col-lg-4 mb-3 vh-25 align-items-stretch">
      <div class="diagram" style="height: 80%;">
              <div class="diagramTitle">
                <h4 style=" font-family: NeueHaasMedium, sans-serif !important;">Recent Activities</h4>
              </div>
              <div class="actContainer" id="recent-activities">
                
              </div>
            </div>
    </div>
    <div class="col-12 col-lg-4 mb-3 vh-25 align-items-stretch" style="border-radius:15px;">
      <div class="diagram" style="height: 80%;">
              <div class="diagramTitle">
                <h4 style=" font-family: NeueHaasMedium, sans-serif !important;">Pending Maintenance</h4>
              </div>
              <div style="background: white; height: 200px;border-radius:15px;">
                  <div id="pendingMainChart" style="height: 101%; width: 100%;border-radius:15px; overflow: hidden;"></div>
              </div>
            </div>
    </div>
  </div>
</div>

        </div>
      </div>
    </div>

    <!-- Modal for Editing Building -->
    <!--<div class="modal fade" id="editBuildingModal" tabindex="-1" aria-labelledby="editBuildingModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editBuildingModalLabel">Edit Building</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="buildingController" method="POST">
            <div class="modal-body">
              <div class="mb-3">
                <label for="locName" class="form-label">Building Name</label>
                <input type="text" class="form-control" id="locName" name="locName" value="${locName}" required>
              </div>
              <div class="mb-3">
                <label for="locDescription" class="form-label">Building Description</label>
                <textarea class="form-control" id="locDescription" name="locDescription" rows="3" required>${locDescription}</textarea>
              </div>
              --><!-- Hidden input to store locID --><!--
              <input type="hidden" name="locID" value="${locID}">
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-primary">Save changes</button>
            </div>
          </form>
        </div>
      </div>
    </div>-->

<div class="modal fade" id="dateRangeModal" tabindex="-1" aria-labelledby="dateRangeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="dateRangeModalLabel">Generate Report</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Select Report Type:</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportType" id="allReports" value="all" checked>
                        <label class="form-check-label" for="allReports">
                            All Reports (No Date Filter)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportType" id="dateRangeReports" value="range">
                        <label class="form-check-label" for="dateRangeReports">
                            Custom Date Range (Repairs Only)
                        </label>
                    </div>
                </div>
                
                <div id="dateRangeInputs" style="display: none;">
                    <div class="mb-3">
                        <label for="startDate" class="form-label">Start Date</label>
                        <input type="date" class="form-control" id="startDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">End Date</label>
                        <input type="date" class="form-control" id="endDate" required>
                    </div>
                    <div id="dateError" class="text-danger small" style="display: none;">
                        End date must be after start date
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="generateReportBtn">Generate Report</button>
            </div>
        </div>
    </div>
</div>
    
<script>
// AI was used to convert the script code of Upcoming Activities to server-side rather than client-side
// Tool: ChatGPT, Prompt: "Could you convert the code above to fit the server-side rendering? [code above is initial client-side code of the program]"
document.addEventListener('DOMContentLoaded', function() {
  const locIDajax = 'allEquip';
  fetch('upcomingactservlet?locID=' + locIDajax)
    .then(res => res.text())
    .then(html => document.getElementById('upcoming-activities').innerHTML = html)
    .catch(err => console.error('Error loading upcoming activities:', err));

  fetch('recentactservlet?locID=' + locIDajax)
    .then(res => res.text())
    .then(html => document.getElementById('recent-activities').innerHTML = html)
    .catch(err => console.error('Error loading recent activities:', err));
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>