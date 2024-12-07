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
</head>
<body>
    <div class="sidebar">
        <div class="text-center pt-4">
            <a href="<%=request.getContextPath()%>/homepage" class="p-0">
                <h2 style="font-family: NeueHaasMedium, sans-serif;">Facilitain</h2>
            </a>
            <p>Welcome, Admin</p>
        </div>
        <div class="ps-2">
            <a href="homepage" class="${page == 'homepage' ? 'active' : ''}">
                <img src="resources/images/icons/house.svg" alt="Home" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Homepage
            </a>
            <a href="notification" class="${page == 'notification' ? 'active' : ''}">
                <img src="resources/images/icons/bell-solid.svg" alt="Notifications" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Notifications
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
            <a href="settings" class="${page == 'settings' ? 'active' : ''}">
                <img src="resources/images/icons/gear-solid.svg" alt="Settings" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
                Settings
            </a>
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
            <hr class="bg-light border-2 border-top border-light"/>
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
            <hr class="bg-light border-2 border-top border-light"/>
        </div>
     <!--   Log out to Portal -->
        <a href="#" class="btn"><i class="bi bi-box-arrow-left pe-2"></i>Logout</a>
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
                    <table class="table table-bordered">
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
                                        <td style="text-align: center;">
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
                                        <td style="text-align: center;">
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
                                        <td style="text-align: center;">
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
                                        <td style="text-align: center;">
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
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
  <script>
document.addEventListener('DOMContentLoaded', function() {
    // Create hamburger menu button
    const hamburgerMenu = document.createElement('button');
    hamburgerMenu.classList.add('hamburger-menu');
    hamburgerMenu.innerHTML = `
        <span></span>
        <span></span>
        <span></span>
    `;
    document.body.prepend(hamburgerMenu);

    // Create overlay
    const overlay = document.createElement('div');
    overlay.classList.add('sidebar-overlay');
    document.body.prepend(overlay);

    const sidebar = document.querySelector('.sidebar');
    
    // Toggle sidebar function
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
    }

    // Event listeners
    hamburgerMenu.addEventListener('click', toggleSidebar);
    overlay.addEventListener('click', toggleSidebar);

    // Close sidebar when a link is clicked
    sidebar.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', toggleSidebar);
    });
});
</script>
</body>
</html>