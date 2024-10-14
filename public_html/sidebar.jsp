<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .sidebar {
            background-color: #2c2c2c;
            height: 100vh; 
            padding: 20px;
            color: white;
            overflow-y: auto;
            position: fixed;
            width: 250px;
            top: 0;
            left: 0;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin-bottom: 10px;
        }

        .sidebar a:hover {
            background-color: #444;
            border-radius: 5px;
        }

        .sidebar .active {
            background-color: #ffca2c;
            color: yellow;
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
        <a href="<%=request.getContextPath()%>/index.jsp">
            <h2>FACILITAIN</h2>
        </a>
        <p>Welcome, Admin</p>
        <a href="<%=request.getContextPath()%>/homepage" class="${page == 'homepage.jsp' ? 'active' : ''}">
            <i class="bi bi-house"></i> Homepage
        </a>
        <a href="<%=request.getContextPath()%>/notification.jsp" class="${page == 'notification.jsp' ? 'active' : ''}">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a href="<%=request.getContextPath()%>/calendar.jsp" class="${page == 'calendar.jsp' ? 'active' : ''}">
            <i class="bi bi-calendar"></i> Calendar
        </a>
        <a href="<%=request.getContextPath()%>/history.jsp" class="${page == 'history.jsp' ? 'active' : ''}">
            <i class="bi bi-clock-history"></i> History Logs
        </a>
        <a href="<%=request.getContextPath()%>/feedback.jsp" class="${page == 'feedback.jsp' ? 'active' : ''}">
            <i class="bi bi-chat-dots"></i> Feedback
        </a>
        <a href="<%=request.getContextPath()%>/reports.jsp" class="${page == 'reportsPage.jsp' ? 'active' : ''}">
            <i class="bi bi-file-earmark-text"></i> Reports
        </a>
        <a href="<%=request.getContextPath()%>/settings.jsp" class="${page == 'settings.jsp' ? 'active' : ''}">
            <i class="bi bi-gear"></i> Settings
        </a>

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
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
</body>
</html>
