<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

<c:if test="${matchFound == false}">
    <script>
        window.location.href = './homepage'; 
    </script>
</c:if>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Building Dashboard</title>
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
                    <c:if test="${itemz.itemMaintStat == 1}">
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
            ['October', 10],
            ['November', 14],
            ['December', 16]
        ]);
        // Set options for the column chart
        var options = {
            hAxis: { title: 'Month' },
            vAxis: { title: 'Repairs' },
            colors: ['#fccc4c'],
            legend: { position: 'none' }
        };
        // Instantiate and draw the column chart
        var chart = new google.visualization.ColumnChart(document.getElementById('repairNoChart'));
        chart.draw(data, options);
    }
        </script>
    </head>
    <body>
    <div class="container-fluid contwhole" style="margin-right: 1px;">
      <div class="row min-vh-100">
        <div class="col-lg-2 bg-light p-0">
          <jsp:include page="sidebar.jsp"/>
        </div>
        <div class="col-md-9 col-lg-10">
          <div class="topButtons">
            <div>
              <a href="./homepage" class="buttonsBack" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;">
                <img src="resources/images/backIcon.svg" alt="back icon" width="16" height="16" style="transform: rotateY(180deg); margin-right: 8px;">
                Back
              </a>
            </div>
            <div>
              <!-- Edit button triggers the modal -->
              <button class="buttonsBuilding" onclick="window.location.href='buildingDashboard?locID=${locID}/edit'"><!--hidden if acc is not admin-->
                Edit
              </button>
              <button class="buttonsBuilding">Generate Report</button>
            </div>
          </div>

          <!-- Building Banner -->
          <div class="buildingBanner" style="background: blue; border-radius: 10px; margin-top: 14px; margin-bottom: 14px;">
            <div class="statusDiv">
              <img src="resources/images/greenDot.png" alt="building status indicator" width="56" height="56">
            </div>
            <div class="buildingName">
              <h1>${locName}</h1>
            </div>
            <div>
              <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
                <c:if test="${floors.key == locID}">
                  <c:forEach var="floor" items="${floors.value}" varStatus="status">
                    <c:if test="${status.first}">
                      <a href="buildingDashboard?locID=${locID}/manage?floor=${floor}" class="buildingManage">
                        Manage
                        <img src="resources/images/manageNext.svg" alt="next icon" width="20" height="20">
                      </a>
                    </c:if>
                  </c:forEach>
                </c:if>
              </c:forEach>
            </div>
          </div>

          <!-- Graphs and Charts -->
          <div class="buildingDiagrams">
            <!-- Frequency of Repairs -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Repairs per Month</h2>
              </div>
              <div style="background: green; height: 280px; ">
                <div id="repairNoChart" style="height: 100%; width: 100%;"></div>
              </div>
            </div>
            <!-- Pending Maintenance -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Pending Maintenance</h2>
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
                <h2>Upcoming Activities</h2>
              </div>
              <div class="actContainer">
                <a href="#" style="text-decoration: none; color: black;">
                  <div class="actItem">
                    <img src="resources/images/greenDot.png" alt="activity status indicator" width="28" height="28">
                    <h3>|type| for |unit number| - |room| in |time|.</h3>
                  </div>
                </a>
              </div>
            </div>
            <div class="activity">
              <div class="actCategories">
                <h2>Recent Activities</h2>
              </div>
              <div class="actContainer"></div>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>
