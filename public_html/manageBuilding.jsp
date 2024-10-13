<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%> 
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Building Dashboard</title>
        <link rel="stylesheet" href="resources/css/mBuilding.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    </head>

<%
    String fullBuildingID = request.getParameter("locID");
    String locID = fullBuildingID.split("/")[0]; 
    String floorName = null;
    int floorIndex = fullBuildingID.indexOf("floor=");
    if (floorIndex != -1) {
        floorName = fullBuildingID.substring(floorIndex + 6);  // Extract everything after "floor="
    }
    request.setAttribute("locID", locID);
    request.setAttribute("floorName", floorName);
%>
            <c:forEach items="${locations}" var="location">
                <c:if test="${location.itemLocId == locID}">
                    <c:set var="locName" value="${location.locName}"/>
                </c:if>
            </c:forEach>

    <body>
    <div class="container-fluid">
      <div class="row min-vh-100">
        <div class=" col-lg-2 bg-light p-0">
          <jsp:include page="sidebar.jsp"/>
        </div>
    
    <div class="col-md-9 col-lg-10">
        <div class="topButtons"> <!-- top buttons -->
            <div>
                <!-- Link component remains unchanged -->
                <a href="./buildingDashboard?locID=${locID}" class="buttonsBack" style="text-decoration: none;color: black; font-size: 20px; margin-left: 2px; display: flex; align-items: center;">
                <img
                        src="resources/images/backIcon.svg" 
                        alt="next icon"
                        width="16"
                        height="16"
                        style="transform: rotateY(180deg); margin-right: 8px;"
                    /> <!-- change based on state of building -->
                    Back
                </a>
            </div>
        </div>
        <div class="buildingName">
            <h1>${locName}</h1>
        </div>
        <div class="floorContainer">
        <c:forEach var="floors" items="${FMO_FLOORS_LIST}">
            <c:if test="${floors.key == locID}">
                <c:forEach var="floor" items="${floors.value}">
                    <a href="./buildingDashboard?locID=${locID}/manage?floor=${floor}" class="floorLinks">
                        ${floor}
                    </a>
                </c:forEach>
            </c:if>
        </c:forEach>    
       
        </div>
        <div class="floorAndButtons">
            <div class="floorName">
              <h1>${floorName}</h1>
            </div>
            <div>
              <button class="buttonsBuilding"> <!--hidden if acc is not admin-->
                Edit Building
              </button>
              <button class="buttonsBuilding" data-toggle="modal" data-target="#addEquipment" type="button">Add Equipment</button>
            </div>
        </div>
        
        <!-- list of room dropdowns  (turn roomDropdown <li> into foreach)-->
        <div class="roomDropsdiv">
            <ul class="roomDropdowns">
             <c:forEach items="${FMO_ITEMS_LIST}" var="item" >
                <c:if test="${item.itemLID == locID}">
                    <c:if test="${item.itemFloor == floorName}">
            
           
                <li class="roomDropdown">
                    <div class="roomDropDiv">
                        <div class="roomDLblDiv">
                            <h3>
                                <button onclick="showTblDiv()" >${item.itemRoom != null ? item.itemRoom : 'Non-Room Equipment'}</button>
                            </h3>
                        </div>
                        <div class="roomDTblDiv">
                            <table aria-label="history logs table" >
                                <tr style="margin-bottom: 120px;">
                                    <th ></th>
                                    <th >ID</th>
                                    <th >Codename</th>
                                    <th >Type</th>
                                    <th >Brand</th>
                                    <th >Date Installed</th>
                                    <th style="display: flex; justify-content: center; align-items: center;">
                                        Quotation
                                    </th>
                                    <th >Status</th>
                                </tr>
                                
                                <tr>
                                    <td style="display: flex; justify-content: center; align-items: center; margin-bottom: 8px;">
                                        <input type="image" src="resources/images/editItem.svg" id="quotModalButton" alt="Open Modal" width="24" height="24">
                                    </td>
                                    <td >1</td>
                                    <td >5505</td>
                                    <td >Aircon</td>
                                    <td >Mitsubishi</td>
                                    <td >01/01/2001</td>
                                    <td style="display: flex; justify-content: center; align-items: center; margin-top: 8px;">
                                        <input type="image" src="resources/images/quotationsIcon.svg" id="quotModalButton" alt="Open Modal" width="24" height="24">
                                    </td>
                                    <td >
                                        <select id="status" class="statusDropdown">
                                            <option value="working" class="working">Working</option>
                                            <option value="nwork" class="nwork">Not Working</option>
                                            <option value="maintenance" class="maintenance">In Maintenance</option>
                                        </select>
                                    </td>
                                </tr>
                                
                                
                            </table>
                        </div>
                    </div>
                </li>
                
              </c:if>  
            </c:if>
          </c:forEach> 
           
                <li>room 808</li>
            </ul>
         </div>
        </div>
     </div>
    </div>   
    
    <!--add equipment modal-->
    <div class="modal fade" id="addEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentAdd" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
                <div class="centered-div bg-white">
                    <div class="container p-4 mt-4 mb-4">
                        <form action="./homepage" method="">
                            <div class="row">
                                <div class="col">
                                    <h3 class="fw-bold">Add Equipment</h3>
                                </div>
                            </div>
                            <div class="row mt-1">
                                <div class="col">
                                    <label for="" class="form-label">Codename</label>
                                    <input type="text" name="itemCode" id="" class="form-control">
                                </div>
                                <div class="col">
                                    <label for="" class="form-label">Building</label>
                                    <input type="text" name="itemBuilding" id="" class="form-control">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemType" class="form-label">Type</label>
                                    <select class="form-select" name="itemType">
                                      <option value="aircon" selected>Aircon</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemFloor" class="form-label">Floor</label>
                                    <select class="form-select" name="itemFloor">
                                      <option value="1" selected>1F</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="itemBrand" class="form-label">Brand</label>
                                    <select class="form-select" name="itemBrand">
                                      <option value="mitsubishi" selected>Mitsubishi</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="itemRoom" class="form-label">Room</label>
                                    <select class="form-select" name="itemRoom">
                                      <option value="1" selected>1804</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <label for="" class="form-label">Date Installed</label>
                                    <input type="date" name="itemInstalled" id="" class="form-control">
                                </div>
                                <div class="col">
                                    <div class="row"><label for="itemSched" class="form-label">Maintenance Cycle: Every...</label></div>
                                    <div class="row">
                                        <div class="col">
                                            <input type="number" name="itemSchedNum" min="1" oninput="validity.valid||(value='');" class="form-control">
                                        </div>
                                        <div class="col">
                                            <select class="form-select" name="itemSched">
                                              <option value="hours" selected>Hour/s</option>
                                              <option value="days" >Day/s</option>
                                              <option value="months" >Month/s</option>
                                              <option value="years" >Year/s</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="row">
                                <div class="col text-center">
                                    <input type="submit" value="Save" class="btn btn-warning btn-lg mt-5 w-50 fw-bold">
                                </div> 
                                <div class="col text-center">
                                    <button type="button" class="btn btn-warning btn-lg mt-5 w-50 fw-bold" data-dismiss="modal">Cancel</button>
                                </div> 
                            </div>
                        </form>
                    </div>     
                </div>
            
        </div>
    </div>
</div>
<!--end of add equipment modal-->
    
    <script>
    
        function showTblDiv() {
            var tblDiv = document.querySelector('.roomDTblDiv');
                        tblDiv.style.display = (tblDiv.style.display === 'none' || tblDiv.style.display === '') ? 'block' : 'none';
        }
    
       const statusDropdown = document.getElementById('status');

        // Function to update the dropdown's background color based on the selected option
        function updateDropdownColor() {
          const selectedValue = statusDropdown.value;
        
          // Remove all existing classes
          statusDropdown.classList.remove('working', 'nwork', 'maintenance');
        
          // Add the class corresponding to the selected value
          if (selectedValue === 'working') {
            statusDropdown.classList.add('working');
          } else if (selectedValue === 'nwork') {
            statusDropdown.classList.add('nwork');
          } else if (selectedValue === 'maintenance') {
            statusDropdown.classList.add('maintenance');
          }
        }

        // Set initial color when the page loads
        updateDropdownColor();

        // Update the color whenever the dropdown value changes
        statusDropdown.addEventListener('change', updateDropdownColor);
    </script>
    
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>