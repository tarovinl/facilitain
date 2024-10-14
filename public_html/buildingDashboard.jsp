<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("locID", request.getParameter("locID"));
%>
            <c:forEach items="${locations}" var="location">
                <c:if test="${location.itemLocId == locID}">
                    <c:set var="locName" value="${location.locName}" />
                </c:if>
            </c:forEach>


<html>
    <head>
        <!--<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>-->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Building Dashboard</title>
        <link rel="stylesheet" href="./resources/css/bDash.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
    <div class="container-fluid">
      <div class="row min-vh-100">
        <div class=" col-lg-2 bg-light p-0">
          <jsp:include page="sidebar.jsp"/>
        </div>
        

        <div class="col-md-9 col-lg-10">
          <div class="topButtons"> <!--top buttons-->
            <div>
              <a href="./homepage" class="buttonsBack" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;">
                <img src="resources/images/backIcon.svg" alt="back icon" width="16" height="16" style="transform: rotateY(180deg); margin-right: 8px;">
                Back
              </a>
            </div>
            <div>
              <button class="buttonsBuilding"> <!--hidden if acc is not admin-->
                Edit
              </button>
              <button class="buttonsBuilding">Generate Report</button>
            </div>
          </div>

	  <!--building banner stuff-->
          <div class="buildingBanner"
          style="background: blue;
          border-radius: 10px; margin-top: 14px; margin-bottom: 14px;"> <!--chnge blue into image-->
          <div class="statusDiv">
            <img src="resources/images/greenDot.png" alt="building status indicator" width="56" height="56"> <!--change greenDot based on status of bilding-->
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

	  <!--graphs and charts-->
          <div class=buildingDiagrams>
	    <!--freq of repairs-->
            <div class=diagram>
              <div class=diagramTitle>
                <h2>Frequency of Repairs</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
	    <!--pending maintenance-->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Pending Maintenance</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
	    <!--punctuality-->
            <div class="diagram">
              <div class="diagramTitle">
                <h2>Punctuality</h2>
              </div>
              <div style="background: green; height: 280px; overflow: auto;">
                <div>graph and chart and stuff</div>
              </div>
            </div>
        </div>

        <div class="buildingActivities"> <!--activities-->
          <div class="activity">
	    <div class="actCategories">
              <h2>Upcoming Activities</h2>
	    </div>
	    <div class="actContainer">
	    <!-- change link to where item is -->
	      <a href="#" style="text-decoration: none; color: black;">
		<div class="actItem">
		  <img src="resources/images/greenDot.png" alt="activity status indicator" width="28" height="28"> <!--change based on deadline of activity-->
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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>