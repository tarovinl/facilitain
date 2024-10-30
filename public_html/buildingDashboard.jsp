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
    </head>
    <body>
    <div class="container-fluid">
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
              <button class="buttonsBuilding" data-bs-toggle="modal" data-bs-target="#editBuildingModal">
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
                <h2>Frequency of Repairs</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
            <!-- Pending Maintenance -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Pending Maintenance</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
            <!-- Punctuality -->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Punctuality</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
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
    <div class="modal fade" id="editBuildingModal" tabindex="-1" aria-labelledby="editBuildingModalLabel" aria-hidden="true">
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
              <!-- Hidden input to store locID -->
              <input type="hidden" name="locID" value="${locID}">
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="submit" class="btn btn-primary">Save changes</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>