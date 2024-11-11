<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
    <style>
        .sidebar {
             background: #000000;
            height: 100vh; 
            padding: 20px;
            color: white;
            overflow-y: auto;
            position: fixed;
            width: 250px;
            top: 0;
            left: 0;
            font-family: 'GothamBook', sans-serif;
        }

        .sidebar a {
        color: white;
        text-decoration: none;
        display: block;
        padding: 10px;
        margin-bottom: 10px;
         transition: filter 0.3s ease;
    }

    .sidebar a:hover {
        color: #fbbf16;
       
    }

    /* Target SVG icons specifically */
       .sidebar a img.icon {
     filter: brightness(0) saturate(100%) invert(100%);
    transition: filter 0.3s ease;
                            }

    .sidebar a:hover img.icon {
    filter: brightness(0) saturate(100%) invert(72%) sepia(82%) saturate(1973%) hue-rotate(1deg) brightness(103%) contrast(106%);
                            }


        .sidebar .active {
            background-color: #ffca2c;
            color: #fbbf16;
            border-radius: 5px;
        }

        .todo-list {
            margin-top: 20px;
        }

        .todo-item {
            background-color: #ffffff;
            padding: 10px;
            margin-bottom: 10px;
            color:#000000;
        }
        h2{
            color: #fbbf16;
            font-family: 'NeueHaas', sans-serif;
            font-size: 50px;
        }

        @media (max-width: 768px) {
            .sidebar {
                position: relative; /* Make sidebar scroll with content in smaller screens */
                width: 100%; /* Full width for small screens */
                height: auto; /* Adjust height */
                padding: 10px; /* Add padding for smaller screens */
            }

            .sidebar a {
                float: none; /* Avoid floating elements */
                text-align: center; /* Center text on smaller screens */
            }

            .sidebar h2, .sidebar p {
                text-align: center; /* Center heading and text */
            }
        }
       

    </style>
</head>
<body>
    <div class="sidebar d-flex flex-column">
    <div class="text-center pt-2 pb-4">
        <a href="<%=request.getContextPath()%>/homepage" class="p-0">
            <h2>Facilitain</h2>
        </a>
        <p>Welcome, Admin</p>
        </div>
        <div class="ps-2">
        <a href="<%=request.getContextPath()%>/homepage" class="${page == 'homepage.jsp' ? 'active' : ''}">
        <img src="resources/images/icons/house.svg" alt="Home" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
        Homepage
        </a>


        <a href="<%=request.getContextPath()%>/notification.jsp" class="${page == 'notification.jsp' ? 'active' : ''}">
           <img src="resources/images/icons/bell-solid.svg" alt="Notifications" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
           Notifications
        </a>
        <a href="<%=request.getContextPath()%>/calendar.jsp" class="${page == 'calendar.jsp' ? 'active' : ''}">
            <img src="resources/images/icons/calendar-solid.svg" alt="Calendar" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
            Calendar
        </a>
        <a href="<%=request.getContextPath()%>/history.jsp" class="${page == 'history.jsp' ? 'active' : ''}">
            <img src="resources/images/icons/clock-rotate-left-solid.svg" alt="History" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;">
            History Logs
        </a>
        <a href="<%=request.getContextPath()%>/feedback.jsp" class="${page == 'feedback.jsp' ? 'active' : ''}">
             <img src="resources/images/icons/comments-solid.svg" alt="Feedback" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Feedback
        </a>
        <a href="<%=request.getContextPath()%>/reports.jsp" class="${page == 'reports.jsp' ? 'active' : ''}">
             <img src="resources/images/icons/circle-exclamation-solid.svg" alt="Reports" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Reports
        </a>
        <a href="<%=request.getContextPath()%>/settings.jsp" class="${page == 'settings.jsp' ? 'active' : ''}">
            <img src="resources/images/icons/gear-solid.svg" alt="Settings" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Settings
        </a>
        </div>
        <div class="todo-list">
            <h4>To-Do</h4>
            <div class="todo-item">
                <p>
                    Aircon Maintenance<br>
                    Frassati Building<br>
                    <small>July 24, 2024</small>
                </p>
                <button class="btn btn-sm btn-outline-success">✓</button>
                <button class="btn btn-sm btn-outline-danger">✕</button>
            </div>
        </div>

        <a href="#" class="btn  mt-4"><i class="bi bi-box-arrow-left pe-2"></i>Logout</a>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
