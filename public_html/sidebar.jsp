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
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
    /* Sidebar base styles */
.sidebar {
    background-color: #FFFFFF;
    color: white;
    width: 250px;
    height: 100vh;
    position: fixed;
    top: 70px;
    left: -250px; /* Hide off-screen by default */
    transition: left 0.3s ease;
    z-index: 1020;
    overflow-y: auto;
   padding:20px;
    box-sizing: border-box;
    font-family: NeueHaasLight, sans-serif;
     border-right: 1px solid #dee2e6;
}
.sidebar.active {
    left: 0; /* Slide in when active */
}
/* Sidebar Header Styles */
.sidebar h2, 
.sidebar p {
    text-align: center;
}
/* Navigation Links */
.sidebar a {
    color: white;
    text-decoration: none;
    display: block;
    margin-bottom: 0;
    text-align: left;
    padding: 6px 12px; /* Adjust vertical and horizontal padding */
    line-height: 1.2;  /* Optional: tighter line spacing */
    font-size: 0.95rem; /* Optional: slightly smaller text */
}

.sidebar .dropdown-menu {
    background-color: inherit;
    border: none;
    margin-left: 2rem;
    padding: 0;
}
  
.sidebar a:hover {
    background-color: #f2f2f2;
    border-radius: 5px;
}
.sidebar a.active {
    background-color: #f2f2f2;
    color: black;
    border-radius: 5px;
}
/* Overlay */
.sidebar-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
    z-index: 1;
}
.sidebar-overlay.active {
    display: block;
}
/* Todo List */
.todo-list {
    margin-top: 20px;
}
.todo-item {
    background-color: #000000;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 10px;
}
.sidebar .dropdown-toggle {
    display: flex;
    align-items: center;
    text-decoration: none;
    color: inherit;
    padding: 0.5rem 1rem;
    transition: background-color 0.3s;
}
.sidebar .dropdown-toggle::after {
    margin-left: auto;
}
.sidebar .dropdown-menu {
    margin-top: 0;
    border-radius: 0;
    border: none;
    background-color: rgba(0, 0, 0, 0.2);
    width: 100%;
}
.sidebar .dropdown-item {
    padding: 0.5rem 1.5rem;
    color: inherit;
    transition: background-color 0.3s;
}
.sidebar .dropdown-item:hover {
    background-color: rgba(255, 255, 255, 0.1);
}
.sidebar .dropdown-item.active {
    background-color: var(--bs-primary);
}

/* Arrow Toggle Button - Vertically centered */
.hamburger-menu {
    position: fixed;
    top: 20%; /* Center vertically */
    transform: translateY(-50%); /* Perfect vertical centering */
    left: 0; /* Position at the very edge */
    z-index: 1100;
    background-color: #ffffff;
    border: none;
    cursor: pointer;
    width: 20px; /* Narrower width */
    height: 50px;
    border-top-right-radius: 8px;
    border-bottom-right-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 2px 0 5px rgba(0,0,0,0.3);
    transition: left 0.3s ease; /* Match sidebar transition */
    padding: 0;
}

/* When sidebar is active, move the button */
.sidebar.active ~ .hamburger-menu {
    left: 250px; /* Match sidebar width */
}

.hamburger-menu:hover {
    background-color: #f2f2f2;
}

/* SVG Arrow styles */
.arrow-icon {
    width: 12px;
    height: 12px;
    fill: #000000;
}


/* Responsive Design */
@media (max-width: 800px) {
    .sidebar {
        width: 250px;
    }
    .hamburger-menu {
        display: flex;
    }
    .col-md-10 {
        margin-left: 0;
        width: 100%;
    }
    .sidebar a {
        text-align: left;
    }
}

@media (min-width: 800px) {
    .sidebar {
        left: 0; /* Always visible on desktop */
        width: 250px;
    }
    .hamburger-menu {
        display: none;
    }
    .col-md-10 {
        margin-left: 250px;
        width: calc(100% - 250px);
    }
}

    body, h1, h2, h3,h5, th {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
   h4, h6, input, textarea, td, tr, p, label, select, option {
    font-family: 'NeueHaasLight', sans-serif !important;
}
  .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
            }

            .hover-outline:hover {
                background-color: #1C1C1C !important;
                color: #f2f2f2 !important;
                border: 1px solid #f2f2f2 !important;
            }
            .hover-outline img {
                transition: filter 0.3s ease;
            }

            .hover-outline:hover img {
                filter: invert(1);
            }
            
.maintenance-container {
    margin: 0px;
}

.maintenance-header {
    display: flex;
    align-items: center;
    color: white;
    cursor: pointer;
    transition: background-color 0.3s;
     padding: 6px 12px; /* Adjust vertical and horizontal padding */
    line-height: 1.2;  /* Optional: tighter line spacing */
    font-size: 0.95rem; /* Optional: slightly smaller text */
}

.maintenance-header:hover {
    background-color: #f2f2f2;
    border-radius: 5px;
}

.maintenance-header i {
    transition: transform 0.3s;
}

.maintenance-items {
  opacity: 0;
  transform: translateY(-10px);
  max-height: 0;
  overflow: hidden;
  transition:
    opacity 0.3s ease,
    transform 0.3s ease,
    max-height 0.4s ease;
    background-color: transparent;
  background-color: #ffffff;

}



/* Show dropdown with animation */
.maintenance-container.open .maintenance-items {
  opacity: 1;
  transform: translateY(0);
  max-height: 500px; /* ensure its large enough for all items */
  visibility: visible;
  pointer-events: auto;
}



.maintenance-items a {
      color: black;
    text-decoration: none;
    display: block;
    margin-bottom: 0;
    text-align: left;
    padding: 6px 12px; /* Adjust vertical and horizontal padding */
    line-height: 1.2;  /* Optional: tighter line spacing */
    font-size: 0.95rem; /* Optional: slightly smaller text */
}

.maintenance-items a:hover {
    background-color: #f2f2f2;
}

.maintenance-items a.active {
    background-color: #ffffff;
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
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 1.5em;
  height: 1.5em;
  font-size: 0.75rem;
  font-weight: 700;
  color: white;
  background-color: red;
  border-radius: 50%;
  position: relative;
  line-height: 1; /* Prevents vertical misalignment */
  text-align: center;
  vertical-align: middle; /* Helps in inline contexts */
}

.sidebar a.active {
  background-color: #f2f2f2;
  color: black;
  border-radius: 0.375rem;
  display: block;
  font-weight: bold;
}

</style>
</head>
        <c:set var="empNum" value="${sessionScope.userID}" />

<body>
    <div class="sidebar">
    <!-- This is a comment 
                    <div class="text-center pt-4">
                
                
              
                <c:choose>
                    <c:when test="${sessionScope.role == 'Admin'}">
                        <p class="text-dark">Welcome, Admin</p>
                    </c:when>
                    <c:when test="${sessionScope.role == 'Support'}">
                        <p class="text-dark">Welcome, Support</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-dark">Welcome</p>
                    </c:otherwise>
                </c:choose> 
                
            </div>-->
    <div class="ps-0">
   <a href="homepage" class="sidebar-link ${page == 'homepage' ? 'active' : ''} text-dark">
    <img src="resources/images/icons/homeb.svg" alt="Home" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
    Home 
</a>

<a href="maintenancePage" class="sidebar-link ${page == 'pending' ? 'active' : ''} text-dark">
    <img src="resources/images/icons/maintenanceb.svg" alt="maintenance" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
    Maintenance
</a>

   
    
 <!-- Maintenance Management section - Admin only -->
<c:if test="${sessionScope.role == 'Admin'}">
    <div class="maintenance-container ${page == 'itemType' || page == 'itemCategories' || page == 'maintenanceSchedule' ? 'open' : ''}">
        <div class="maintenance-header text-dark">
            <img src="resources/images/icons/constructionb.svg" alt="Maintenance" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
            <span>Maintenance Configuration</span>
            <i class="fas fa-chevron-down ms-auto"></i>
        </div>
        <div class="maintenance-items">
            <a href="itemType" class=" ${page == 'itemType' ? 'active' : ''}">
              <img src="resources/images/icons/tune.svg" alt="ItemType" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                <span>Item Types</span>
            </a>
            <a href="itemCategories" class=" ${page == 'itemCategories' ? 'active' : ''}">
              <img src="resources/images/icons/category.svg" alt="ItemCategory" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                <span>Item Categories</span>
            </a>
            <a href="maintenanceSchedule" class=" ${page == 'maintenanceSchedule' ? 'active' : ''}">
              <img src="resources/images/icons/autorenew.svg" alt="Schedule" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                <span>Maintenance Schedule</span>
            </a>
        </div>
    </div>
</c:if>


    
<a href="notification" class="${page == 'notification' ? 'active' : ''} text-dark">
  <span style="position: relative; display: inline-block;">
    <img src="resources/images/icons/notifb.svg" alt="Notifications"
         class="icon pe-2"
         style="width: 2em; height: 2em; vertical-align: middle;">

    
  </span>

  Notifications
</a>




  
    
    <a href="calendar" class="${page == 'calendar' ? 'active' : ''} text-dark">
        <img src="resources/images/icons/calendarb.svg" alt="Calendar" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
        Calendar
    </a>
    
    <a href="history" class="${page == 'history' ? 'active' : ''} text-dark">
        <img src="resources/images/icons/historyb.svg" alt="History" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
        History Logs
    </a>
    
    <a href="feedback" class="${page == 'feedback' ? 'active' : ''} text-dark">
        <img src="resources/images/icons/feedbackb.svg" alt="Feedback" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
        Feedback
    </a>
    
    <a href="reports" class="${page == 'reports' ? 'active' : ''} text-dark">
        <img src="resources/images/icons/reportsb.svg" alt="Reports" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
        Reports
    </a>
    
    <!-- Only show Users link for Admin users -->
    <c:if test="${sessionScope.role == 'Admin'}">
        <a href="itemUser" class="${page == 'itemUser' ? 'active' : ''} text-dark">
            <img src="resources/images/icons/manage-usersb.svg" alt="User" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
            Users
        </a>
    
    
    </c:if>
            <!--<a href="mapView" class="${page == 'mapView' ? 'active' : ''}">
                <img src="resources/images/map-white.svg" alt="Map" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Map View
            </a>-->
            <a href="#" data-bs-toggle="modal" data-bs-target="#showToDo" class="d-flex align-items-center ${page == 'todo' ? 'active' : ''} text-dark">
    <img src="resources/images/icons/todob.svg" alt="To-Do" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
    To-Do
</a>
       <!-- Sidebar container -->



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
        
    </div>

<!--add to do list item modal-->
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
                    <input type="hidden" name="originalUrl" class="form-control" value="<%= request.getRequestURI() %>?<%= request.getQueryString() %>" />
                    <input type="hidden" name="userNum" class="form-control" value="${empNum}" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Add</button>
                </div>
            </div>
            
        </form>
    </div>
</div>


<!--to do list items modal-->
<div class="modal fade" id="showToDo" tabindex="-1" aria-labelledby="showToDo" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="addToDoListLabel" style="font-family: 'NeueHaasMedium', sans-serif !important;">To-Do List</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 d-flex justify-content-end align-items-center">
                    <button type="button" class="btn hover-outline"  style="font-family: NeueHaasMedium, sans-serif; background-color: #fccc4c;" data-bs-toggle="modal" data-bs-target="#addToDo" onclick="openAddToDoModal()">
                       <img src="resources/images/icons/plus.svg" alt="add" class="icon pe-2" style=" vertical-align: middle;" width="25" height="25">
                        Add
                    </button>
                </div>
                <div style=" max-height: 300px; overflow-y: auto;">
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
                        <tbody id="tdTableBody">
                            <!-- To-do list items will be dynamically loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var empNum = '${empNum}'; // dynamically injected from session/JSP
    loadToDoList(empNum);
});

function loadToDoList(empNum) {
    fetch('todolistcontroller?empNum=' + empNum)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var tbody = document.getElementById('tdTableBody');
            tbody.innerHTML = '';

            if (data.error) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">' + data.error + '</td></tr>';
                return;
            }

            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center">No to-do items found</td></tr>';
                return;
            }

            data.forEach(function(todo) {
                var row = document.createElement('tr');
                var checked = todo.isChecked === 1;
                
                var taskCell = checked ? '<s>' + todo.content + '</s>' : todo.content;
                var startCell = checked ? '<s>' + todo.startDate + '</s>' : todo.startDate;
                var endCell = checked ? '<s>' + todo.endDate + '</s>' : todo.endDate;
                var checkVal = checked ? 'uncheck' : 'check';
                var checkIcon = checked ? 'square-check' : 'empty-box';
                var delt = 'delete';


                row.innerHTML = '' +
                    '<td>' + taskCell + '</td>' +
                    '<td>' + startCell + '</td>' +
                    '<td>' + endCell + '</td>' +
                    '<td>' +
                        '<button type="button" onclick="handleToDoAction(\'' + checkVal + '\', ' + todo.id + ')" style="background: none; border: none; padding: 0; cursor: pointer;">' +
                            '<img src="resources/images/icons/' + checkIcon + '.svg" width="24" height="24">' +
                        '</button>' +
                    '</td>' +
                    '<td>' +
                        '<button type="button" onclick="handleToDoAction(\'' + delt + '\', ' + todo.id + ')" style="background: none; border: none; padding: 0; cursor: pointer;">' +
                            '<img src="resources/images/icons/trash-can.svg" width="24" height="24">' +
                        '</button>' +
                    '</td>';
                    
                tbody.appendChild(row);
            });
        })
        .catch(function(err) {
            console.error("Failed to load To-Do list:", err);
            document.getElementById('tdTableBody').innerHTML =
                '<tr><td colspan="5" class="text-center text-danger">Error loading list</td></tr>';
        });
}

function handleToDoAction(action, id) {
    // Use URLSearchParams instead of FormData for proper form encoding
    var params = new URLSearchParams();
    params.append('tdAction', action);
    params.append('tdListId', id);

    
    fetch('todolistcontroller', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(function(res) {
        if (!res.ok) {
            throw new Error('Server returned ' + res.status);
        }
        return res.json();
    })
    .then(function(result) {
        // Show SweetAlert2 popup based on response and action
        if (result.success) {
            let msg = '';
            if (action === 'check') msg = 'Task marked as complete!';
            else if (action === 'uncheck') msg = 'Task marked as incomplete!';
            else if (action === 'delete') msg = 'Task deleted successfully!';

            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: msg,
                showConfirmButton: false,
                timer: 1500,
                timerProgressBar: true
            });
        } else {
            Swal.fire({
                icon: 'warning',
                title: 'No changes made',
                text: result.message || 'Please try again.',
            });
        }

        // Reload the to-do list after a short delay
        setTimeout(function() {
            var empNum = '${empNum}';
            loadToDoList(empNum);
        }, 500);
    })
    .then(function() {
        // Reload the to-do list after successful action
        var empNum = '${empNum}';
        loadToDoList(empNum);
    })
    .catch(function(err) {
        console.error('Error performing action:', err);
        alert('Failed to perform action. Please try again.');
    });
}

</script>
<%
Boolean todoSuccess = (Boolean) session.getAttribute("todoSuccess");
String todoError = (String) session.getAttribute("todoError");

if (todoSuccess != null && todoSuccess) {
    session.removeAttribute("todoSuccess");
%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        icon: 'success',
        title: 'Task Added!',
        text: 'Your new to-do item has been successfully added.',
        showConfirmButton: false,
        timer: 2000
    });
});
</script>
<%
} else if (todoSuccess != null && !todoSuccess && todoError != null) {
    session.removeAttribute("todoSuccess");
    session.removeAttribute("todoError");
%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        icon: 'error',
        title: 'Invalid Dates',
        text: '<%= todoError %>',
        showConfirmButton: true
    });
});
</script>
<%
}
%>


<!-- bad eggs
<script>
function deleteTodo(id) {
    if (!confirm('Are you sure you want to delete this to-do item?')) return;

    var formData = new FormData();
    formData.append('tdListId', id);
    formData.append('tdAction', 'delete');

    fetch('todolistcontroller', { method: 'POST', body: formData })
        .then(function() {
            var empNum = '${empNum}';
            loadToDoList(empNum);
        });
}
</script>

<script>
document.getElementById('addToDoForm').addEventListener('submit', function(e) {
    e.preventDefault();
    if (!validateStartDate() || !validateEndDate()) return;

    var formData = new FormData(this);
    fetch('todolistcontroller', { method: 'POST', body: formData })
        .then(function() {
            var modal = bootstrap.Modal.getInstance(document.getElementById('addToDo'));
            modal.hide();
            var empNum = '${empNum}';
            loadToDoList(empNum);
        })
        .catch(function(err) { 
            console.error('Add to-do failed:', err); 
        });
});
</script>-->

<script>
document.addEventListener('DOMContentLoaded', function() {
    const maintenanceHeader = document.querySelector('.maintenance-header');
    const maintenanceContainer = document.querySelector('.maintenance-container');
    
    if (maintenanceHeader) {
        maintenanceHeader.addEventListener('click', function() {
            maintenanceContainer.classList.toggle('open');
        });
    }
});

document.addEventListener("DOMContentLoaded", function() {
  fetch('<%= request.getContextPath() %>/facilitain/homepage/checkNotifications')
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
   fetch('<%= request.getContextPath() %>/facilitain/homepage/checkNotifications')
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
    svg.style.stroke = "black";
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