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
            background-color: #000000;
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
        }

        .sidebar a:hover {
            color: #fbbf16;
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
            background-color: #000000;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
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
        <div class="ps-1">
         <a href="<%=request.getContextPath()%>/homepage" class="${page == './homepage.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-house pe-2"></i> Homepage
        </a>
        <a href="<%=request.getContextPath()%>/notification.jsp" class="${page == 'notification.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-bell pe-2"></i> Notifications
        </a>
        <a href="<%=request.getContextPath()%>/calendar.jsp" class="${page == 'calendar.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-calendar pe-2"></i> Calendar
        </a>
        <a href="<%=request.getContextPath()%>/history.jsp" class="${page == 'history.jsp' ? 'active' : ''}">
           <i class="fa-solid fa-clock-rotate-left pe-2"></i> History Logs
        </a>
        <a href="<%=request.getContextPath()%>/feedback.jsp" class="${page == 'feedback.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-comments pe-2"></i> Feedback
        </a>
        <a href="<%=request.getContextPath()%>/reports.jsp" class="${page == 'reports.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-circle-exclamation pe-2"></i> Reports
        </a>
        <a href="<%=request.getContextPath()%>/settings.jsp" class="${page == 'settings.jsp' ? 'active' : ''}">
            <i class="fa-solid fa-gear pe-2"></i> Settings
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

        <a href="#" class="btn btn-outline-light mt-4">Logout</a>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
