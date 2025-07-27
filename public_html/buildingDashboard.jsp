
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
        <c:set var="locName" value="${location.locName}" />
        <c:set var="locDescription" value="${location.locDescription}" />
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
        <title>Location Dashboard</title>
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
        google.charts.load('current', {packages: ['corechart']});
        google.charts.setOnLoadCallback(drawCharts);
        
        function drawCharts() {
        drawPieChart();
        drawColumnChart();
        }
        
        function drawPieChart() {
        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Item Category');
        data.addColumn('number', 'MaintenanceNo');
    

// loop that lists the category and how many items are in maintenance per category. change itemMaintStat to 2 when final
        data.addRows([
        <c:forEach var="category" items="${FMO_CATEGORIES_LIST}">
            <c:set var="itemCount" value="0" />
            <c:forEach var="itemz" items="${FMO_ITEMS_LIST}">
                <c:if test="${itemz.itemLID == locID2}">

                <c:set var="itemCID" value="" />

                <c:forEach var="type" items="${FMO_TYPES_LIST}">
                <c:if test="${type.itemTID == itemz.itemTID}">
                    <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                    <c:if test="${cat.itemCID == type.itemCID}">
                        <c:set var="itemCID" value="${cat.itemCID}" />            
                    </c:if>
                    </c:forEach>
                </c:if>
                </c:forEach>
            
                <c:if test="${category.itemCID == itemCID}">
                    <c:if test="${itemz.itemArchive == 1}">
                    <c:if test="${itemz.itemMaintStat == 2}">
                        <c:set var="itemCount" value="${itemCount + 1}" />
                    </c:if>
                    </c:if>
                </c:if>
                </c:if>
            </c:forEach>

            ['${category.itemCat}', ${itemCount}],
        </c:forEach>

        ]);
       
        // Set chart options
        var options = {chartArea: { 
            left: 20, // Adjust margins to center the pie
            width: '80%',  // Width of the pie chart area
            height: '80%'  // Height of the pie chart area
        }};
        // Instantiate and draw the chart.
        var chart = new google.visualization.PieChart(document.getElementById('pendingMainChart'));
        chart.draw(data, options);
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
                <c:forEach var="repair" items="${REPAIRS_PER_MONTH}">
                <c:if test="${repair.repairLocID == locID2}">
                    <c:if test="${repair.repairYear == currentYear}">
                    <c:if test="${repair.repairMonth == monthNumber}">
                        <c:set var="repairCount" value="${repair.repairCount}" />
                    </c:if>
                    </c:if>
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
function generateReport() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4'
    });

    // Get current date from JSP (not even working)
    const reportDate = '<%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %>';
    
  
    doc.setFillColor(51, 51, 51);
    doc.rect(0, 0, 210, 20, 'F');
    
   
    const logoImg = new Image();
    logoImg.src = 'resources/images/USTLogo.png';
    logoImg.onload = function() {
        // Left-aligned logo (15mm from left, 50mm width)
        doc.addImage(logoImg, 'PNG', 15, 2, 50, 15);
        
        // Main content starts below header
        const contentStartY = 25;
        
        // Building name (centered)
        doc.setFontSize(16);
        doc.setTextColor(0, 0, 0);
        doc.text(`${locName}`, 105, contentStartY + 10, {align: 'center'});
        
        // Add "Pending Maintenance" label above pie chart
        doc.setFontSize(14);
        doc.setFont(undefined, 'bold');
        doc.text("Pending Maintenance", 105, contentStartY + 25, {align: 'center'});
        doc.setFont(undefined, 'normal');
        
        // Capture and add pie chart with proper margins
        const pieChartDiv = document.getElementById('pendingMainChart');
        
        // Set temporary dimensions for capture
        const originalStyles = {
            width: pieChartDiv.style.width,
            height: pieChartDiv.style.height,
            overflow: pieChartDiv.style.overflow
        };
        pieChartDiv.style.width = '300px';
        pieChartDiv.style.height = '300px';
        pieChartDiv.style.overflow = 'visible';
        
        html2canvas(pieChartDiv, {
            scale: 3, 
            logging: false,
            useCORS: true,
            width: 300,
            height: 300,
            backgroundColor: null,
            windowWidth: 300,
            windowHeight: 300
        }).then(canvas => {
           
            pieChartDiv.style.width = originalStyles.width;
            pieChartDiv.style.height = originalStyles.height;
            pieChartDiv.style.overflow = originalStyles.overflow;
            
            // Create canvas with extra padding
            const padding = 50; // Extra padding to prevent cutoff
            const paddedCanvas = document.createElement('canvas');
            paddedCanvas.width = canvas.width + padding * 2;
            paddedCanvas.height = canvas.height + padding * 2;
            const ctx = paddedCanvas.getContext('2d');
            
           
            ctx.fillStyle = '#FFFFFF';
            ctx.fillRect(0, 0, paddedCanvas.width, paddedCanvas.height);
            
            // Draw centered pie chart with padding
            ctx.drawImage(
                canvas,
                0,
                0,
                canvas.width,
                canvas.height,
                padding,
                padding,
                canvas.width,
                canvas.height
            );
            
            const pieChartImg = paddedCanvas.toDataURL('image/png');
            
       
            doc.addImage(pieChartImg, 'PNG', 20, contentStartY + 30, 80, 80);
            
       
            const legendStartX = 110;
            let legendStartY = contentStartY + 40;
            const legendItemHeight = 6;
            
           
            const colors = [
                {r: 66, g: 133, b: 244},   // Blue
                {r: 234, g: 67, b: 53},     // Red
                {r: 251, g: 188, b: 5},     // Yellow
                {r: 52, g: 168, b: 83},     // Green
                {r: 168, g: 50, b: 150},     // Purple
                {r: 235, g: 122, b: 40}      // Orange
            ];
            
            // Get the pie chart data to create the legend
            <c:forEach var="category" items="${FMO_CATEGORIES_LIST}" varStatus="status">
                <c:set var="itemCount2" value="0" />
                <c:forEach var="itemz" items="${FMO_ITEMS_LIST}">
                    <c:if test="${itemz.itemLID == locID2}">
                        <c:set var="itemCID2" value="" />
                        <c:forEach var="type" items="${FMO_TYPES_LIST}">
                            <c:if test="${type.itemTID == itemz.itemTID}">
                                <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                                    <c:if test="${cat.itemCID == type.itemCID}">
                                        <c:set var="itemCID2" value="${cat.itemCID}" />            
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                        <c:if test="${category.itemCID == itemCID}">
                            <c:if test="${itemz.itemArchive == 1}">
                                <c:if test="${itemz.itemMaintStat == 2}">
                                    <c:set var="itemCount2" value="${itemCount2 + 1}" />
                                </c:if>
                            </c:if>
                        </c:if>
                    </c:if>
                </c:forEach>
                
                <c:if test="${itemCount2 > 0}">
                    // Draw color box
                    const colorIndex = ${status.index} % colors.length;
                    doc.setFillColor(
                        colors[colorIndex].r,
                        colors[colorIndex].g,
                        colors[colorIndex].b
                    );
                    doc.rect(legendStartX, legendStartY, 4, 4, 'F');
                    
                    // Add category name and count
                    doc.setFontSize(10);
                    doc.setTextColor(0, 0, 0); // Black text
                    doc.text(`${category.itemCat} (${itemCount2})`, legendStartX + 6, legendStartY + 3);
                    
                    // Move to next line
                    legendStartY += legendItemHeight;
                </c:if>
            </c:forEach>
            
            
            const tableStartY = contentStartY + 120;
            doc.setFontSize(14);
            doc.setFont(undefined, 'bold');
            doc.text("Repairs per Month", 105, tableStartY - 5, {align: 'center'});
            doc.setFont(undefined, 'normal');
            
            // Create and add full-width table
            doc.autoTable({
                startY: tableStartY,
                margin: {left: 20, right: 20},
                head: [["Month", "Number of Repairs"]],
                body: [
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
                        ['${month}', '${repairCount}'],
                    </c:forEach>
                ],
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
            
            // Save the PDF
            doc.save('${locName}_Maintenance_Report.pdf');
        }).catch(error => {
            console.error('Error generating PDF:', error);
            alert('Error generating PDF. Please check console for details.');
        });
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
    <c:if test="${sessionScope.role == 'Admin'}">
      <button class="btn btn-md topButtons px-3 py-2 rounded-2 hover-outline text-dark d-flex align-items-center justify-content-center"
              style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;"
              onclick="window.location.href='buildingDashboard?locID=${locID}/edit'">
        <img src="resources/images/icons/edit.svg" alt="edit icon" width="25" height="25">
        <span class="d-none d-lg-inline ps-2">Edit</span>
      </button>
    </c:if>

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
                                    url('./buildingdisplaycontroller?locID=${locID}'); background-size: cover; background-position: center; height: 80%; display: flex; flex-direction:column;justify-content: flex-end;">
            <!--<div class="statusDiv">
                <img src="resources/images/greenDot.png" alt="building status indicator" width="56" height="56">
            </div>-->
            <div class="buildingName text-light" style="font-family: NeueHaasMedium, sans-serif;">
                <h1>${locName}</h1>
            </div>
            <div>
                <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
                    <c:if test="${floors.key == locID}">
                        <c:forEach var="floor" items="${floors.value}" varStatus="status">
                            <c:if test="${status.first}">
                                <a href="buildingDashboard?locID=${locID}/manage?floor=${floor}" 
                                class="buildingManage d-flex align-items-center text-decoration-none text-white fs-3" 
                                style="font-family: NeueHaasLight, sans-serif;">
                                Manage
                                <img src="resources/images/icons/angle-right-solid.svg" alt="next icon" width="25" height="25">
                                </a>

                            </c:if>
                        </c:forEach>
                    </c:if>
                </c:forEach>
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
                <c:forEach items="${FMO_ITEMS_LIST}" var="item">
                <c:if test="${item.itemLID == locID}">
                    <c:forEach items="${maintenanceList}" var="maint">
                    <c:if test="${maint.archiveFlag == 1}">
                        <c:if test="${item.itemTID == maint.itemTypeId}">
                            <%-- Pass data to HTML elements using data-* attributes --%>
                            <div class="d-flex align-items-center border-bottom p-3 actItem" 
                                 style="border-color: #dee0e1 !important;"
                                 data-item-name="${item.itemName}" 
                                 data-item-room="${item.itemRoom}" 
                                 data-last-maintenance-date="${item.lastMaintDate}" 
                                 data-planned-maintenance-date="${item.plannedMaintDate}" 
                                 data-no-of-days="${maint.noOfDays}" 
                                 data-no-of-days-warning="${maint.noOfDaysWarning}">
                            
                              <!-- Dot -->
                              <div class="me-3">
                                <img src="resources/images/yellowDot.png" alt="activity status indicator" width="28" height="28">
                              </div>
                            
                              <!-- Text -->
                              <div>
                                <h4 class="mb-1 fs-5 fw-semibold">
                                  Maintenance for ${item.itemName} ${not empty item.itemRoom ? item.itemRoom : ''} in 
                                  <span class="remaining-days">calculating...</span> days.
                                </h4>
                                <h6 class="mb-0 text-muted activity-text">
                                  <c:forEach items="${FMO_TYPES_LIST}" var="type">
                                    <c:if test="${type.itemTID == item.itemTID}">
                                      <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat">
                                        <c:if test="${type.itemCID == cat.itemCID}">
                                          ${cat.itemCat}
                                        </c:if>
                                      </c:forEach>
                                      - ${type.itemType}
                                    </c:if>
                                  </c:forEach>
                                </h6>
                              </div>
                            
                            </div>

            
                        </c:if>
                    </c:if>
                    </c:forEach>
                </c:if>
                </c:forEach>
              </div>
            </div>
    </div>
    <div class="col-12 col-lg-4 mb-3 vh-25 align-items-stretch">
      <div class="diagram" style="height: 80%;">
              <div class="diagramTitle">
                <h4 style=" font-family: NeueHaasMedium, sans-serif !important;">Recent Activities</h4>
              </div>
              <div class="actContainer" id="recent-activities">
                <c:forEach items="${FMO_ITEMS_LIST}" var="item">
                <c:if test="${item.itemLID == locID}">
                    <c:forEach items="${maintenanceList}" var="maint">
                    <c:if test="${maint.archiveFlag == 1}">
                        <c:if test="${item.itemTID == maint.itemTypeId}">
                            <%-- Pass data to HTML elements using data-* attributes --%>
                             <div class="d-flex align-items-center border-bottom p-3 actItem" 
                                 style="border-color: #dee0e1 !important;"
                                data-last-maintenance-date="${item.lastMaintDate}"
                                 data-planned-maintenance-date="${item.plannedMaintDate}">
                                 
                                <div class="me-3">
                                    <img src="resources/images/greenDot.png" alt="activity status indicator" width="28" height="28">
                                </div>
                                <div>
                                    <h4 class="mb-1 fs-5 fw-semibold activity-text">
                                        Maintenance for ${item.itemName} ${not empty item.itemRoom ? item.itemRoom : ''} <span class="remaining-days">calculating...</span> days ago.
                                    </h4>
                                    <h6 class="mb-0 text-muted">
                                        <c:forEach items="${FMO_TYPES_LIST}" var="type">
                                        <c:if test="${type.itemTID == item.itemTID}">
                                                <c:forEach items="${FMO_CATEGORIES_LIST}" var="cat">
                                                <c:if test="${type.itemCID == cat.itemCID}">
                                                    ${cat.itemCat}
                                                </c:if>
                                                </c:forEach>
                                             - ${type.itemType}
                                        </c:if>
                                        </c:forEach>
                                    </h6>
                                </div>
                            </div>
                        </c:if>
                    </c:if>    
                    </c:forEach>
                </c:if>
                </c:forEach>
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
    
<script>
document.addEventListener('DOMContentLoaded', function () {
    const currentDate = new Date('<%= currentDate %>');
    console.log('Current Date:', currentDate);

    document.querySelectorAll('#upcoming-activities .actItem').forEach(function (itemDiv) {
        const lastMaintenanceDateStr = itemDiv.getAttribute('data-last-maintenance-date');
        const plannedMaintenanceDateStr = itemDiv.getAttribute('data-planned-maintenance-date');
        const noOfDays = parseInt(itemDiv.getAttribute('data-no-of-days')) || 0;
        const noOfDaysWarning = parseInt(itemDiv.getAttribute('data-no-of-days-warning')) || 0;

        console.log('UA Planned Maintenance Date String:', plannedMaintenanceDateStr);
        console.log('UA Last Maintenance Date String:', lastMaintenanceDateStr);
        console.log('UA Number of Days:', noOfDays);
        console.log('UA Number of Days Warning:', noOfDaysWarning);


        if (plannedMaintenanceDateStr) {
            const plannedMaintenanceDate = new Date(plannedMaintenanceDateStr);

            if (!isNaN(plannedMaintenanceDate)) {
                const daysSincePlannedMaintenance = (currentDate - plannedMaintenanceDate) / (1000 * 60 * 60 * 24);
                const daysRemaining = noOfDays - daysSincePlannedMaintenance;
                
                console.log('UA Days Remaining:', daysRemaining);

                if (daysRemaining > 0 && daysRemaining <= noOfDaysWarning) {
                    const remainingDaysElement = itemDiv.querySelector('.remaining-days');
                    if (remainingDaysElement) {
                        remainingDaysElement.textContent = Math.floor(daysRemaining);
                    }
                } else {
                    itemDiv.style.setProperty('display', 'none', 'important'); 
                }
            } else {
//                console.error("Invalid lastMaintenanceDate:", plannedMaintenanceDateStr);
                itemDiv.style.setProperty('display', 'none', 'important'); 
            }
        } else {
            itemDiv.style.setProperty('display', 'none', 'important'); 
        }
    });

    document.querySelectorAll('#recent-activities .actItem').forEach(function (itemDiv) {
        const plannedMaintenanceDateStr = itemDiv.getAttribute('data-planned-maintenance-date');
        const lastMaintenanceDateStr = itemDiv.getAttribute('data-last-maintenance-date');
//        console.log('RA Last Maintenance Date String:', lastMaintenanceDateStr);
        
        if (lastMaintenanceDateStr) {
            const lastMaintenanceDate = new Date(lastMaintenanceDateStr);

            if (!isNaN(lastMaintenanceDate)) {
                const daysSinceLastMaintenance = (currentDate - lastMaintenanceDate) / (1000 * 60 * 60 * 24);
                console.log('RA daysSinceLastMaintenance:', daysSinceLastMaintenance);
                if (daysSinceLastMaintenance >= 0 && daysSinceLastMaintenance <= 30) {
                    const remainingDaysElement = itemDiv.querySelector('.remaining-days');
                    if (remainingDaysElement) {
                        remainingDaysElement.textContent = Math.floor(daysSinceLastMaintenance);
                    }
                } else {
                    itemDiv.style.setProperty('display', 'none', 'important'); 
                }
            } else {
                console.error("RA Invalid lastMaintenanceDate:", lastMaintenanceDateStr);
                itemDiv.style.setProperty('display', 'none', 'important'); 
            }
        } else {
            itemDiv.style.setProperty('display', 'none', 'important'); 
        }
    });
});

</script>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>