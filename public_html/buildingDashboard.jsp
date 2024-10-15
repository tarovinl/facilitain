<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("locID", request.getParameter("locID"));
%>

<c:set var="matchFound" value="false"/>

<c:forEach items="${locations}" var="location">
    <c:if test="${location.itemLocId == locID}">
        <c:set var="locName" value="${location.locName}"/>
        <c:set var="locDescription" value="${location.locDescription}"/>
        <c:set var="matchFound" value="true"/>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
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
                            <a href="./homepage" class="buttonsBack" style="text-decoration: none; color: black; font-size: 20px; display: flex; align-items: center;">
                                <img src="resources/images/backIcon.svg" alt="back icon" width="16" height="16" style="transform: rotateY(180deg); margin-right: 8px;">
                                Back
                            </a>
                        </div>
                        <div>
                            <!-- Edit button to trigger modal -->
                            <button class="buttonsBuilding" data-toggle="modal" data-target="#editBuildingModal">
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
                    </div>

                    <!-- Floors Management Section -->
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

                    <!-- Graphs and Diagrams -->
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

                    <!-- Activities Section -->
                    <div class="buildingActivities">
                        <!-- Upcoming Activities -->
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

                        <!-- Recent Activities -->
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

        <!-- Edit Building Modal -->
        <div class="modal fade" id="editBuildingModal" tabindex="-1" role="dialog" aria-labelledby="editBuildingModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <form action="building" method="post">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editBuildingModalLabel">Edit Building</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- Hidden input for locID -->
                            <input type="hidden" id="locID" name="locID" value="${locID}">

                            <!-- Building Name -->
                            <div class="form-group">
                                <label for="locName">Building Name</label>
                                <input type="text" class="form-control" id="locName" name="locName" value="${locName}" required>
                            </div>

                            <!-- Building Description -->
                            <div class="form-group">
                                <label for="locDescription">Building Description</label>
                                <input type="text" class="form-control" id="locDescription" name="locDescription" value="${locDescription}" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-warning">Save Changes</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
