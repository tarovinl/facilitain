<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap-icons/1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <title>Notifications</title>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <h1 class="mb-4">Notifications</h1>

          <h2 class="mb-3">Reports</h2>
<c:choose>
    <c:when test="${empty reportNotifications}">
        <div class="alert alert-info" role="alert">
            No report notifications available.
        </div>
    </c:when>
    <c:otherwise>
        <div class="list-group">
            <c:forEach var="notification" items="${reportNotifications}">
    <form action="notification" method="POST" class="list-group-item">
        <input type="hidden" name="id" value="${notification.notificationId}"/>
        <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/reports"/>
        <button type="submit" class="btn btn-link text-start w-100 ${notification.isRead ? 'list-group-item-secondary' : 'list-group-item-light'}">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'}"></i>
                    ${notification.message}
                </h5>
                <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'}">
                    ${notification.isRead ? 'Read' : 'Unread'}
                </span>
            </div>
            <p class="mb-0"><strong>Type:</strong> ${notification.type}</p>
            <p class="mb-0"><strong>Created At:</strong> ${notification.createdAt}</p>
            <p class="mb-0"><strong>Location:</strong> ${notification.locName}</p>
        </button>
    </form>
</c:forEach>

        </div>
    </c:otherwise>
</c:choose>

<h2 class="mb-3">Quotations</h2>
<c:choose>
    <c:when test="${empty quotationNotifications}">
        <div class="alert alert-info" role="alert">
            No quotation notifications available.
        </div>
    </c:when>
    <c:otherwise>
        <div class="list-group">
            <c:forEach var="notification" items="${quotationNotifications}">
                <form action="notification" method="POST" class="list-group-item">
                    <input type="hidden" name="id" value="${notification.notificationId}"/>
                   
                    <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}"/>
                    <button type="submit" class="btn btn-link text-start w-100 ${notification.isRead ? 'list-group-item-secondary' : 'list-group-item-light'}">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'}"></i>
                                ${notification.message}
                            </h5>
                            <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'}">
                                ${notification.isRead ? 'Read' : 'Unread'}
                            </span>
                        </div>
                        <p class="mb-0"><strong>Type:</strong> ${notification.type}</p>
                        <p class="mb-0"><strong>Created At:</strong> ${notification.createdAt}</p>
                        <p class="mb-0"><strong>Location:</strong> ${notification.locName}</p>
                    </button>
                </form>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>



<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
