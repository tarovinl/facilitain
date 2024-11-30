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
    <div class="overflow-auto" style="max-height: 400px;">
        <ul class="list-group">
            <c:forEach var="notification" items="${reportNotifications}">
                <form action="notification" method="POST">
                    <input type="hidden" name="id" value="${notification.notificationId}"/>
                    <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/reports"/>

                    <button type="submit" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${notification.isRead ? 'list-group-item-secondary' : ''}">
                        <div>
                            <h6 class="mb-1">
                                <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'} me-2"></i>
                                ${notification.message}
                            </h6>
                            <small class="text-muted">Created At: ${notification.createdAt}</small>
                            <br>
                            <small class="text-muted">Location: ${notification.locName}</small>
                        </div>
                        <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'}">
                            ${notification.isRead ? 'Read' : 'Unread'}
                        </span>
                    </button>
                </form>
                 <button type="button" class="btn btn-danger btn-sm mt-2" data-toggle="modal" data-target="#deleteModal" onclick="setModalData(${notification.notificationId})">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
            </c:forEach>
        </ul>
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
        <div class="overflow-auto" style="max-height: 400px;">
            <ul class="list-group">
                <c:forEach var="notification" items="${quotationNotifications}">
                    <form action="notification" method="POST">
                        <input type="hidden" name="id" value="${notification.notificationId}"/>
                        <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}"/>

                        <button type="submit" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${notification.isRead ? 'list-group-item-secondary' : ''}">
                            <div>
                                <h6 class="mb-1">
                                    <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'} me-2"></i>
                                    ${notification.message}
                                </h6>
                                <small class="text-muted">Created At: ${notification.createdAt}</small>
                                <br>
                                <small class="text-muted">Location: ${notification.locName}</small>
                                <br>
                                <small class="text-muted">Item Name: ${notification.itemName}</small>
                                <br>
                                <small class="text-muted">Room: ${notification.roomNo}, Floor: ${notification.floorNo}</small>
                            </div>
                            <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'}">
                                ${notification.isRead ? 'Read' : 'Unread'}
                            </span>
                        </button>
                    </form>
                     <button type="button" class="btn btn-danger btn-sm mt-2" data-toggle="modal" data-target="#deleteModal" onclick="setModalData(${notification.notificationId})">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                </c:forEach>
            </ul>
        </div>
    </c:otherwise>
</c:choose>
<h2 class="mb-3">Maintenance</h2>
<c:choose>
    <c:when test="${empty maintenanceNotifications}">
        <div class="alert alert-info" role="alert">
            No maintenance notifications available.
        </div>
    </c:when>
    <c:otherwise>
        <div class="overflow-auto" style="max-height: 400px;">
            <ul class="list-group">
                <c:forEach var="notification" items="${maintenanceNotifications}">
                    <form action="notification" method="POST">
                        <input type="hidden" name="id" value="${notification.notificationId}"/>
                        <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}"/>

                        <button type="submit" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${notification.isRead ? 'list-group-item-secondary' : ''}">
                            <div>
                                <h6 class="mb-1">
                                    <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'} me-2"></i>
                                    ${notification.message}
                                </h6>
                                <small class="text-muted">Created At: ${notification.createdAt}</small>
                                <br>
                                <small class="text-muted">Location: ${notification.locName}</small>
                                <br>
                                <small class="text-muted">Item Name: ${notification.itemName}</small>
                                <br>
                                <small class="text-muted">Room: ${notification.roomNo}, Floor: ${notification.floorNo}</small>
                            </div>
                            <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'}">
                                ${notification.isRead ? 'Read' : 'Unread'}
                            </span>
                        </button>
                    </form>
                     <button type="button" class="btn btn-danger btn-sm mt-2" data-toggle="modal" data-target="#deleteModal" onclick="setModalData(${notification.notificationId})">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                </c:forEach>
            </ul>
        </div>
    </c:otherwise>
</c:choose>
<!--Delete modal-->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Delete Notification</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this notification?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <form action="deleteNotification" method="POST">
                    <input type="hidden" id="deleteNotificationId" name="id"/>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>


<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
