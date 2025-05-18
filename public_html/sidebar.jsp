<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
     
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
 
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="./resources/css/sidebar.css">
    <style>
.maintenance-container {
    margin: 10px 0;
}

.maintenance-header {
    display: flex;
    align-items: center;
    padding: 10px 15px;
    color: white;
    cursor: pointer;
    transition: background-color 0.3s;
}

.maintenance-header:hover {
    background-color: #444;
    border-radius: 5px;
}

.maintenance-header i {
    transition: transform 0.3s;
}

.maintenance-items {
    display: none;
    background-color: #3c3c3c;
    border-radius: 5px;
    margin-top: 5px;
}

.maintenance-items a {
    padding: 8px 15px;
    color: white;
    text-decoration: none;
    display: block;
    transition: background-color 0.3s;
}

.maintenance-items a:hover {
    background-color: #4a4a4a;
}

.maintenance-items a.active {
    background-color: #ffca2c;
    color: black;
}

/* Class for when menu is open */
.maintenance-container.open .maintenance-items {
    display: block;
}

.maintenance-container.open .maintenance-header i {
    transform: rotate(180deg);
}


#notificationBadge {
    position: relative;
    padding: 0.25em 0.6em;
    font-size: 0.75rem;
    font-weight: 700;
    vertical-align: middle;
    border-radius: 50%;
    display: inline-block;
}
</style>
</head>
<body>
    <div class="sidebar">
        <div class="text-center pt-4">
            <a href="<%=request.getContextPath()%>/homepage" class="p-0">

               <img src="resources/images/facilitain-home-logo.png" 

             alt="Facilitain Home Logo" 
             style="max-width: 100%; max-height: 100px; margin: 0 auto; display: block;" />
            </a>
            <p>Welcome, Admin</p>
        </div>
        <div class="ps-2">
            <a href="homepage" class="${page == 'homepage' ? 'active' : ''}">
                <img src="resources/images/icons/house.svg" alt="Home" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Homepage
            </a>
            <a href="notification" class="${page == 'notification' ? 'active' : ''}" style="position: relative;">
             <img src="resources/images/icons/bell-solid.svg" alt="Notifications" class="icon pe-2" 
                 style="width: 2em; height: 2em; vertical-align: middle;">
                Notifications 
            <span id="notificationBadge" class="badge bg-warning text-dark ms-2">0</span>
            </a>     
            <a href="calendar" class="${page == 'calendar' ? 'active' : ''}">
                <img src="resources/images/icons/calendar-solid.svg" alt="Calendar" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Calendar
            </a>
            <a href="history" class="${page == 'history' ? 'active' : ''}">
                <img src="resources/images/icons/clock-rotate-left-solid.svg" alt="History" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                History Logs
            </a>
            <a href="feedback" class="${page == 'feedback' ? 'active' : ''}">
                <img src="resources/images/icons/comments-solid.svg" alt="Feedback" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Feedback
            </a>
            <a href="reports" class="${page == 'reports' ? 'active' : ''}">
                <img src="resources/images/icons/circle-exclamation-solid.svg" alt="Reports" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Reports
            </a>
            <!--<a href="mapView" class="${page == 'mapView' ? 'active' : ''}">
                <img src="resources/images/map-white.svg" alt="Map" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Map View
            </a>-->
 <div class="maintenance-container">
            <div class="maintenance-header">
                <img src="resources/images/icons/gear-solid.svg" alt="Maintenance" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                <span>Maintenance</span>
                <i class="fas fa-chevron-down ms-auto"></i>
            </div>
            <div class="maintenance-items">
                <a href="itemType" class="${page == 'itemType' ? 'active' : ''}">
                    <span class="ps-4">Item Types</span>
                </a>
                <a href="itemCategories" class="${page == 'itemCategories' ? 'active' : ''}">
                    <span class="ps-4">Item Categories</span>
                </a>
                <a href="maintenanceSchedule" class="${page == 'maintenanceSchedule' ? 'active' : ''}">
                    <span class="ps-4">Item Schedule</span>
                </a>
                <a href="itemUser" class="${page == 'itemUser' ? 'active' : ''}">
                    <span class="ps-4">Item User</span>
                </a>
            </div>
        </div>

            
           
        </div>
        <div class="todo-list">
            <div class="d-flex justify-content-between align-items-center">
                <h4 class="ps-1">To-Do</h4>
                <div>
                <button class="btn btn-sm icon-button" data-bs-toggle="modal" data-bs-target="#showToDo">
                    <img src="resources/images/icons/external-link.svg" alt="All Items" class="icon" style="width: 2em; height: 2em; vertical-align: middle;">
                </button>
                <button class="btn btn-sm icon-button" data-bs-toggle="modal" data-bs-target="#addToDo">
                    <img src="resources/images/icons/plus-solid.svg" alt="Add" class="icon" style="width: 2em; height: 2em; vertical-align: middle;">
                </button>
                </div>
            </div>
            <!--<hr class="bg-light border-2 border-top border-light"/>
            <div class="todo-item d-flex justify-content-between align-items-center">
                <div class="ps-2">
                    <p>
                        Aircon Maintenance<br>
                        Frassati Building<br>
                        <small>July 24, 2024</small>
                    </p>
                </div>
                <div class="button-group d-flex flex-column">
                    <button class="btn btn-sm"><img src="resources/images/icons/check-solid.svg" alt="Check" class="icon" style="width: 1.5em; height: 1.5em; vertical-align: middle;"></button>
                    <button class="btn btn-sm"><img src="resources/images/icons/xmark-solid.svg" alt="X" class="icon" style="width: 1.5em; height: 1.5em; vertical-align: middle;"></button>
                </div>
            </div>
            <hr class="bg-light border-2 border-top border-light"/>-->
        </div>
     <!--   Log out to Portal -->
        <a href="<%=request.getContextPath()%>/logoutServlet" class="btn"><i class="bi bi-box-arrow-left pe-2"></i>Logout</a>
    </div>

<!--to do list item modal-->
<div class="modal fade" id="addToDo" tabindex="-1" aria-labelledby="addToDo" aria-hidden="true">
    <div class="modal-dialog">
        <form action="todolistcontroller" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addToDoListLabel">Add To-Do List Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="locName" class="form-label">What to do?</label>
                        <input type="text" class="form-control" id="tdListContent" name="tdListContent" maxlength="256" placeholder="Meeting tomorrow, etc." required>
                    </div>
                    <div class="mb-3">
                        <label for="" class="form-label">Start Date</label>
                        <input type="datetime-local" name="tdListStart" id="tdListStart" class="form-control" onchange="validateStartDate()" required>
                    </div>
                    <div class="mb-3">
                        <label for="" class="form-label">End Date</label>
                        <input type="datetime-local" name="tdListEnd" id="tdListEnd" class="form-control" onchange="validateEndDate()" required>
                    </div>
                    <div id="validationMessage" class="text-danger"></div>
                    <input type="hidden" name="originalUrl" value="<%= request.getRequestURL() %>?<%= request.getQueryString() %>" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Add</button>
                </div>
            </div>
        </form>
    </div>
</div>


<!--all to do list items modal-->
<div class="modal fade" id="showToDo" tabindex="-1" aria-labelledby="showToDo" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="addToDoListLabel">To-Do List</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 d-flex justify-content-end">
                    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addToDo" onclick="openAddToDoModal()">
                        Add
                    </button>
                </div>
                <div style="border: 1px solid black; max-height: 300px; overflow-y: auto;">
                    <table class="table table-bordered" id="tdTable" style="width:100%;">
                        <thead>
                            <tr>
                                <th>Task</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="todos" items="${FMO_TO_DO_LIST}">
                            <c:if test="${todos.empNumber == 1234}">
                                <c:if test="${todos.isChecked == 0}">
                                <form action="todolistcontroller" method="post">
                                    <tr>
                                        <td>${todos.listContent}</td>
                                        <td>${todos.startDate}</td>
                                        <td>${todos.endDate}</td>
                                        <td>
                                            <input type="hidden" name="originalUrl" value="<%= request.getRequestURL() %>?<%= request.getQueryString() %>" />
                                            <input type="hidden" name="tdListId" value="${todos.listItemId}" />
                                            <input type="hidden" name="tdListContent" value="${todos.listContent}" />
                                            <input type="hidden" name="tdListStart" value="${todos.startDate}" />
                                            <input type="hidden" name="tdListEnd" value="${todos.endDate}" />
                                            <input type="hidden" name="tdListChecked" value="${todos.isChecked}" />
                                            <input type="hidden" name="tdListCreationDate" value="${todos.creationDate}" />
                                            <button type="submit" name="tdAction" value="check" style="background: none; border: none; padding: 0;">
                                                <img src="resources/images/icons/square-check.svg" alt="Check" style="width: 24px; height: 24px;" />
                                            </button>                                
                                        </td>
                                        <td>
                                            <button type="submit" name="tdAction" value="delete" style="background: none; border: none; padding: 0;">
                                                <img src="resources/images/icons/trash-can.svg" alt="Delete" style="width: 24px; height: 24px;" />
                                            </button>  
                                        </td>
                                    </tr>
                                </form>
                                </c:if>
                            </c:if>
                            </c:forEach>
                            <c:forEach var="todos1" items="${FMO_TO_DO_LIST}">
                            <c:if test="${todos1.empNumber == 1234}">
                                <c:if test="${todos1.isChecked == 1}">
                                <form action="todolistcontroller" method="post">
                                    <tr>
                                        <td><s>${todos1.listContent}</s></td>
                                        <td><s>${todos1.startDate}</s></td>
                                        <td><s>${todos1.endDate}</s></td>
                                        <td>
                                            <input type="hidden" name="originalUrl" value="<%= request.getRequestURL() %>?<%= request.getQueryString() %>" />
                                            <input type="hidden" name="tdListId" value="${todos1.listItemId}" />
                                            <input type="hidden" name="tdListContent" value="${todos1.listContent}" />
                                            <input type="hidden" name="tdListStart" value="${todos1.startDate}" />
                                            <input type="hidden" name="tdListEnd" value="${todos1.endDate}" />
                                            <input type="hidden" name="tdListChecked" value="${todos1.isChecked}" />
                                            <input type="hidden" name="tdListCreationDate" value="${todos1.creationDate}" />
                                            <button type="submit" name="tdAction" value="uncheck" style="background: none; border: none; padding: 0;">
                                                <img src="resources/images/icons/eks-square.svg" alt="Uncheck" style="width: 24px; height: 24px;" />
                                            </button>  
                                        </td>
                                        <td>
                                            <button type="submit" name="tdAction" value="delete" style="background: none; border: none; padding: 0;">
                                                <img src="resources/images/icons/trash-can.svg" alt="Delete" style="width: 24px; height: 24px;" />
                                            </button>  
                                        </td>
                                    </tr>
                                </form>
                                </c:if>
                            </c:if>
                            </c:forEach>
                        
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
//        document.addEventListener('DOMContentLoaded', function() {
//            let tdTable = new DataTable('#tdTable', {
//                paging: true,
//                ordering: true,
//                scrollX: true,
//                columnDefs: [
//                    { targets: "_all", className: "dt-center" }, // Center-align all columns
//                    { targets: 3, orderable: false },
//                    { targets: 4, orderable: false }
//                ]
//            });
//        });
  const maintenanceDropdown = document.querySelector('.maintenance-dropdown');
        maintenanceDropdown.addEventListener('click', function() {
            const arrow = this.querySelector('.dropdown-arrow');
            arrow.style.transform = this.getAttribute('aria-expanded') === 'true' ? 'rotate(0deg)' : 'rotate(90deg)';
        });
    });


document.addEventListener("DOMContentLoaded", function() {
    fetch('/FMOCapstone/homepage/checkNotifications')
        .then(response => response.json())
        .then(data => {
            const unreadCount = data.unreadCount;
            const badge = document.getElementById('notificationBadge');

            if (unreadCount > 0) {
                badge.textContent = unreadCount; // Update the count
                badge.style.display = 'inline-block'; // Show the badge
            } else {
                badge.style.display = 'none'; 
            }
        })
        .catch(error => console.error('Error fetching notification count:', error));
});
function openAddToDoModal() {
    // Hide the first modal
    const firstTModal = bootstrap.Modal.getInstance(document.getElementById('showToDo'));
    firstTModal.hide();

    // Show the second modal
    const secondTModal = new bootstrap.Modal(document.getElementById('addToDo'));
    secondTModal.show();
    
    const secondModalEl = document.getElementById('addToDo');
    secondModalEl.addEventListener('hidden.bs.modal', () => {
        document.body.classList.remove('modal-open'); // Remove modal-open class
        document.querySelector('.modal-backdrop')?.remove(); // Remove any remaining backdrop
    });
}

function validateStartDate() {
    var startDate = document.getElementById('tdListStart').value;
    var endDate = document.getElementById('tdListEnd').value;
    var currentDate = new Date().toISOString().slice(0, 16);

    if (startDate < currentDate) {
        document.getElementById('validationMessage').innerText = "Start date cannot be in the past.";
        document.getElementById('tdListStart').classList.add('is-invalid');
        return false;
    } else {
        document.getElementById('validationMessage').innerText = "";
        document.getElementById('tdListStart').classList.remove('is-invalid');
    }

    if (endDate && endDate < startDate) {
        document.getElementById('validationMessage').innerText = "End date cannot be earlier than start date.";
        document.getElementById('tdListEnd').classList.add('is-invalid');
        return false;
    } else {
        document.getElementById('validationMessage').innerText = "";
        document.getElementById('tdListEnd').classList.remove('is-invalid');
    }
    return true;
}

function validateEndDate() {
    var startDate = document.getElementById('tdListStart').value;
    var endDate = document.getElementById('tdListEnd').value;

    if (endDate < startDate) {
        document.getElementById('validationMessage').innerText = "End date cannot be earlier than start date.";
        document.getElementById('tdListEnd').classList.add('is-invalid');
        return false;
    } else {
        document.getElementById('validationMessage').innerText = "";
        document.getElementById('tdListEnd').classList.remove('is-invalid');
    }
    return true;
}

document.querySelector('form').addEventListener('submit', function(event) {
    if (!validateStartDate() || !validateEndDate()) {
        event.preventDefault(); // Prevent form submission
    }
});
</script>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
  <script>
  document.addEventListener("DOMContentLoaded", function() {
    // Initialize the notification badge as hidden
    const badge = document.getElementById('notificationBadge');
    badge.style.display = 'none';
    
    // Fetch notification count
    fetch('/FMOCapstone/homepage/checkNotifications')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            const unreadCount = data.unreadCount;
            
            if (unreadCount > 0) {
                badge.textContent = unreadCount;
                badge.style.display = 'inline-block';
            } else {
                badge.style.display = 'none';
            }
        })
        .catch(error => {
            console.error('Error fetching notification count:', error);
            // For testing - remove in production
            // badge.textContent = "3";
            // badge.style.display = 'inline-block';
        });
});
  document.addEventListener('DOMContentLoaded', function() {
    const maintenanceHeader = document.querySelector('.maintenance-header');
    const maintenanceContainer = document.querySelector('.maintenance-container');
    
    maintenanceHeader.addEventListener('click', function() {
        maintenanceContainer.classList.toggle('open');
    });
});
document.addEventListener('DOMContentLoaded', function() {
    // Create arrow toggle button 
    const toggleButton = document.createElement('button');
    toggleButton.classList.add('hamburger-menu');
    
    // Create modern material design arrow icon
    const svgNS = "http://www.w3.org/2000/svg";
    const svg = document.createElementNS(svgNS, "svg");
    svg.setAttribute("viewBox", "0 0 24 24");
    svg.setAttribute("width", "14");
    svg.setAttribute("height", "14");
    svg.classList.add("arrow-icon");
    svg.style.fill = "none";
    svg.style.stroke = "white";
    svg.style.strokeWidth = "2";
    svg.style.strokeLinecap = "round";
    svg.style.strokeLinejoin = "round";
    
    // Create arrow using polyline for a cleaner look
    const polyline = document.createElementNS(svgNS, "polyline");
    polyline.setAttribute("points", "9 18 15 12 9 6");
    svg.appendChild(polyline);
    
    toggleButton.appendChild(svg);
    
    // Get the sidebar and add toggle button after it
    const sidebar = document.querySelector('.sidebar');
    sidebar.parentNode.insertBefore(toggleButton, sidebar.nextSibling);
    
    // Create overlay
    const overlay = document.createElement('div');
    overlay.classList.add('sidebar-overlay');
    document.body.prepend(overlay);
    
    // Toggle sidebar function
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        
        // Change arrow direction
        if (sidebar.classList.contains('active')) {
            // Left-pointing arrow when sidebar is open
            polyline.setAttribute("points", "15 18 9 12 15 6");
        } else {
            // Right-pointing arrow when sidebar is closed
            polyline.setAttribute("points", "9 18 15 12 9 6");
        }
    }

    // Event listeners
    toggleButton.addEventListener('click', toggleSidebar);
    overlay.addEventListener('click', toggleSidebar);

    // Close sidebar when a link is clicked on mobile
    if (window.innerWidth <= 800) {
        sidebar.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', function() {
                if (sidebar.classList.contains('active')) {
                    toggleSidebar();
                }
            });
        });
    }
});
</script>
</body>
</html>