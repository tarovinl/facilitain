<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
    // Current date for calculations
    LocalDate currentDate = LocalDate.now();
    request.setAttribute("currentDate", currentDate);
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
<c:if test="${matchFound == false}">
    <script>
        window.location.href = './homepage'; 
    </script>
</c:if>

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
        chart.draw(data, options);
        }
function generateReport() {
    // Capture chart elements
    var maintenanceChartDiv = document.getElementById('pendingMainChart');
    
    // Get SVG of the pie chart
    var maintenanceChartSvg = maintenanceChartDiv.querySelector('svg');
    
    // Verify SVG exists
    if (!maintenanceChartSvg) {
        alert('Charts are not yet loaded. Please refresh the page and try again.');
        return;
    }

    // Clone the SVG to modify without affecting the original
    var clonedSvg = maintenanceChartSvg.cloneNode(true);
    
    // Add title to the SVG
    var titleElement = document.createElementNS("http://www.w3.org/2000/svg", "text");
    titleElement.setAttribute("x", "50%");
    titleElement.setAttribute("y", "30");
    titleElement.setAttribute("text-anchor", "middle");
    titleElement.setAttribute("font-size", "16");
    titleElement.setAttribute("font-weight", "bold");
    titleElement.textContent = "Pending Maintenance";
    
    clonedSvg.insertBefore(titleElement, clonedSvg.firstChild);

    // Create a canvas to combine charts and table
    var canvas = document.createElement('canvas');
    canvas.width = 800;
    canvas.height = 700; // Increased height to fit everything
    var ctx = canvas.getContext('2d');
    
    // Create image from the modified maintenance pie chart SVG
    var img2 = new Image();
    
    img2.onload = function() {
        // Clear canvas with white background
        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        // Add UST Logo at the top left
        var logoImg = new Image();
        logoImg.onload = function() {
            // Draw logo in top left with more padding
            ctx.drawImage(logoImg, 10, 10, 120, 60); // Slightly larger and more padded
            
            // Draw title next to logo
            ctx.font = '24px Arial';
            ctx.fillStyle = 'black';
            ctx.fillText(`${locName} - Location Dashboard`, 150, 40);
            
            // Draw the pie chart (now with title)
            ctx.drawImage(img2, 200, 150, 400, 300); // Adjust positioning as needed
            
            // Draw the Repairs Table title
            ctx.font = '18px Arial';
            ctx.fillStyle = 'black';
            ctx.fillText('Repairs per Month', 50, 480); // Position below pie chart

            var x = 50;
            var y = 510; // Starting position for repair data
            ctx.font = '16px Arial';
            
            // Create HTML table for repairs data
            var tableHtml = '<table style="width: 100%; border-collapse: collapse; margin-top: 20px;">';
            tableHtml += '<thead>';
            tableHtml += '<tr><th style="border: 1px solid #ddd; padding: 8px; background-color: #f2f2f2;">Month</th>';
            tableHtml += '<th style="border: 1px solid #ddd; padding: 8px; background-color: #f2f2f2;">Number of Repairs</th></tr>';
            tableHtml += '</thead>';
            tableHtml += '<tbody>';
            
            // Loop through repairs to add table rows
            var repairData = [
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
                    '<tr><td style="border: 1px solid #ddd; padding: 8px;">${month}</td><td style="border: 1px solid #ddd; padding: 8px;">${repairCount}</td></tr>',
                </c:forEach>
            ];

            // Render the repair table rows
            repairData.forEach(function(data) {
                tableHtml += data;
            });
            
            tableHtml += '</tbody>';
            tableHtml += '</table>';

            // Create a container to hold the report content
            const reportContainer = document.createElement('div');
            reportContainer.style.fontFamily = 'Arial, sans-serif';
            reportContainer.style.maxWidth = '1200px';
            reportContainer.style.margin = '0 auto';
            reportContainer.style.padding = '20px';
            
            // Add chart
            const chartImage = img2.src;
            const chartImgElement = document.createElement('img');
            chartImgElement.src = chartImage;
            chartImgElement.style.width = '100%';
            chartImgElement.style.maxHeight = '400px';
            chartImgElement.style.objectFit = 'contain';
            reportContainer.appendChild(chartImgElement);
            
            // Add the repair table
            reportContainer.innerHTML += tableHtml;

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
                link.download = `${locName}_dashboard_report.png`;
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
                link.download = `${locName}_dashboard_report.png`;
                link.href = chartImage;
                link.click();
            });
        };

        logoImg.src = 'resources/images/USTLogo.png'; // Path to the logo image
    };

    // Convert modified SVG to base64
    img2.src = 'data:image/svg+xml;base64,' + btoa(new XMLSerializer().serializeToString(clonedSvg));
}

// Attach event listener after page load
document.addEventListener('DOMContentLoaded', function() {
    var generateReportButton = document.querySelector('.buttonsBuilding:nth-child(2)');
    if (generateReportButton) {
        generateReportButton.addEventListener('click', generateReport);
    } else {
        console.error('Generate Report button not found');
    }
});
        </script>
    </head>
    <body>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
       
    
    <div class="col-md-10">
        
          <div class="topButtons">
            <div>
              <a href="./homepage" class="buttonsBack d-flex align-items-center gap-2" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;font-family: NeueHaasLight, sans-serif;">
                <img src="resources/images/icons/angle-left-solid.svg" alt="back icon" width="20" height="20">
                Back
              </a>
            </div>
            <div>
              <!-- Edit button triggers the modal -->
              <button class="buttonsBuilding" onclick="window.location.href='buildingDashboard?locID=${locID}/edit'" style="font-family: NeueHaasMedium, sans-serif;"><!--hidden if acc is not admin-->
                <img src="resources/images/icons/pen-solid.svg" class="pe-2" alt="edit icon" width="25" height="25">
                Edit
              </button>
              <button class="buttonsBuilding" style="font-family: NeueHaasMedium, sans-serif;">
              <img src="resources/images/icons/file-export-solid.svg" class="pe-2" alt="generate report icon" width="25" height="25">
              Generate Report</button>
            </div>
          </div>

          <!-- Building Banner -->
<div class="buildingBanner rounded-4" style="margin-top: 14px; margin-bottom: 14px; background-image: 
                                    linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 100%), 
                                    url('./buildingdisplaycontroller?locID=${locID}'); background-size: cover; background-position: center;">
    <div class="statusDiv">
        <img src="resources/images/greenDot.png" alt="building status indicator" width="56" height="56">
    </div>
    <div class="buildingName text-light" style="font-family: NeueHaasMedium, sans-serif;">
        <h1>${locName}</h1>
    </div>
    <div>
        <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
            <c:if test="${floors.key == locID}">
                <c:forEach var="floor" items="${floors.value}" varStatus="status">
                    <c:if test="${status.first}">
                        <a href="buildingDashboard?locID=${locID}/manage?floor=${floor}" class="buildingManage d-flex align-items-center" style="font-family: NeueHaasMedium, sans-serif;">
                            Manage
                            <img src="resources/images/icons/angle-right-solid.svg" alt="next icon" width="25" height="25">
                        </a>
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>
    </div>
</div>


          <!-- Graphs and Charts -->
          <div class="buildingDiagrams" >
            <!-- Frequency of Repairs -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2 style=" font-family: NeueHaasMedium, sans-serif;">Repairs per Month</h2>
              </div>
              <div style="background: green; height: 280px; ">
                <div id="repairNoChart" style="height: 100%; width: 100%;"></div>
              </div>
            </div>
            <!-- Pending Maintenance -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2 style=" font-family: NeueHaasMedium, sans-serif;">Pending Maintenance</h2>
              </div>
              <div style="background: green; height: 280px;">
                  <div id="pendingMainChart" style="height: 100%; width: 100%;"></div>
              </div>
            </div>
            <!-- Punctuality -->
            <!--<div class="diagram">
              <div class="diagramTitle">
                <h2>Punctuality</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>-->
          </div>

          <!-- Activities -->
          <div class="buildingActivities">
            <div class="activity">
              <div class="actCategories">
                <h2 style=" font-family: NeueHaasMedium, sans-serif;">Upcoming Activities</h2>
              </div>
              <div class="actContainer" id="upcoming-activities">
                <c:forEach items="${FMO_ITEMS_LIST}" var="item">
                <c:if test="${item.itemLID == locID}">
                    <c:forEach items="${maintenanceList}" var="maint">
                    <c:if test="${maint.activeFlag == 1}">
                        <c:if test="${item.itemTID == maint.itemTypeId}">
                            <%-- Pass data to HTML elements using data-* attributes --%>
                            <div class="actItem"
                                 data-item-name="${item.itemName}" 
                                 data-item-room="${item.itemRoom}" 
                                 data-last-maintenance-date="${item.lastMaintDate}" 
                                 data-no-of-days="${maint.noOfDays}" 
                                 data-no-of-days-warning="${maint.noOfDaysWarning}">
                                <img src="resources/images/yellowDot.png" alt="activity status indicator" width="28" height="28">
                                <h3 class="activity-text">
                                    Maintenance for ${item.itemName} ${not empty item.itemRoom ? '- ' + item.itemRoom : ''} in <span class="remaining-days">calculating...</span> days.
                                </h3>
                            </div>
            
                        </c:if>
                    </c:if>
                    </c:forEach>
                </c:if>
                </c:forEach>
              </div>
            </div>
                       <div class="activity">
              <div class="actCategories">
                <h2 style=" font-family: NeueHaasMedium, sans-serif;">Recent Activities</h2>
              </div>
              <div class="actContainer" id="recent-activities">
                <c:forEach items="${FMO_ITEMS_LIST}" var="item">
                <c:if test="${item.itemLID == locID}">
                    <c:forEach items="${maintenanceList}" var="maint">
                    <c:if test="${maint.archiveFlag == 1}">
                        <c:if test="${item.itemTID == maint.itemTypeId}">
                            <%-- Pass data to HTML elements using data-* attributes --%>
                            <div class="actItem"
                                 data-last-maintenance-date="${item.lastMaintDate}">
                                <img src="resources/images/yellowDot.png" alt="activity status indicator" width="28" height="28">
                                <h3 class="activity-text">
                                    Maintenance for ${item.itemName} ${not empty item.itemRoom ? '- ' + item.itemRoom : ''} <span class="remaining-days">calculating...</span> days ago.
                                </h3>
                            </div>
                        </c:if>
                    </c:if>    
                    </c:forEach>
                </c:if>
                </c:forEach>
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
        // Convert the server-side current date to a JavaScript Date object
        const currentDate = new Date('<%= currentDate %>');
        console.log('Current Date:', currentDate);

        // Loop through each item and calculate the remaining days
        document.querySelectorAll('#upcoming-activities .actItem').forEach(function (itemDiv) {
            // Accessing data attributes from the div
            const lastMaintenanceDateStr = itemDiv.getAttribute('data-last-maintenance-date');
            const noOfDays = parseInt(itemDiv.getAttribute('data-no-of-days'));
            const noOfDaysWarning = parseInt(itemDiv.getAttribute('data-no-of-days-warning'));

            // Parse the last maintenance date into a Date object
            const lastMaintenanceDate = new Date(lastMaintenanceDateStr);

            // Calculate the difference in days
            const timeDifference = currentDate - lastMaintenanceDate;
            const daysSinceLastMaintenance = timeDifference / (1000 * 60 * 60 * 24);
            const daysRemaining = noOfDays - daysSinceLastMaintenance;

            // Update the text with the remaining days, if within the warning threshold
            if (daysRemaining > 0 && daysRemaining <= noOfDaysWarning) {
                const remainingDaysElement = itemDiv.querySelector('.remaining-days');
                remainingDaysElement.textContent = Math.floor(daysRemaining);  // Display as an integer
            } else {
                itemDiv.style.display = "none";
            }
        });
        
        document.querySelectorAll('#recent-activities .actItem').forEach(function (itemDiv) {
            const lastMaintenanceDateStr = itemDiv.getAttribute('data-last-maintenance-date');
    
            if (lastMaintenanceDateStr) {
                const lastMaintenanceDate = new Date(lastMaintenanceDateStr);
                const daysSinceLastMaintenance = (currentDate - lastMaintenanceDate) / (1000 * 60 * 60 * 24);

                if (daysSinceLastMaintenance >= 0 && daysSinceLastMaintenance <= 30) {
                    itemDiv.querySelector('.remaining-days').textContent = Math.floor(daysSinceLastMaintenance);
                } else {
                    itemDiv.style.display = "none"; // Hide items not within 30 days
                }
            } else {
                itemDiv.style.display = "none"; // Hide items with no maintenance date
            }
        });
    });
</script>

</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>