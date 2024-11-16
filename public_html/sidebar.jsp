<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/sidebar.css">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
   
</head>
<body>
        <div class="col-md-2 d-flex flex-column justify-content-between sidebar">
            <div class="text-center pt-4 ">
                <a href="<%=request.getContextPath()%>/homepage" class="p-0">
                    <h2 style=" font-family: NeueHaasMedium, sans-serif;">Facilitain</h2>
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
                    <button class="btn btn-sm icon-button"><img src="resources/images/icons/plus-solid.svg" alt="Add" class="icon" style="width: 2em; height: 2em; vertical-align: middle;"></button>
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
            <a href="#" class="btn"><i class="bi bi-box-arrow-left pe-2"></i>Logout</a>
        </div>
        <div class="col-md-2 d-flex flex-column justify-content-between sidebarunder"></div>


    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>