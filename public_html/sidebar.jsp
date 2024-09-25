<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <link href="<%=request.getContextPath()%>/resources/css/sidebar.css" rel="stylesheet">
</head>
<body>
    <div class="sidebar">
        <a href="<%=request.getContextPath()%>/index.jsp">
            <h2>FACILITAIN</h2>
        </a>
        <p>Welcome, Admin</p>
        <a href="<%=request.getContextPath()%>/index.jsp" class="${page == 'homepage.jsp' ? 'active' : ''}">
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
</body>
</html>
