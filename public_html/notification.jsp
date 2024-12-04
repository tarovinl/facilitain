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
                            <li class="list-group-item list-group-item-action d-flex justify-content-between ${notification.isRead ? 'list-group-item-secondary' : ''}">
                                <form action="notification" method="POST" class="flex-grow-1">
                                    <input type="hidden" name="id" value="${notification.notificationId}"/>
                                    <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/reports"/>

                                    <button type="submit" class="btn btn-block text-left p-0 bg-transparent border-0">
                                        <div>
                                            <h6 class="mb-1">
                                                <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'} me-2"></i>
                                                ${notification.message}
                                            </h6>
                                            <small class="text-muted">Created At: ${notification.createdAt}</small>
                                            <br>
                                            <small class="text-muted">Location: ${notification.locName}</small>
                                        </div>
                                    </button>
                                </form>
                                <div class="d-flex flex-column align-items-end">
                                    <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'} mb-2">
                                        ${notification.isRead ? 'Read' : 'Unread'}
                                    </span>
                                    <button class="btn btn-danger btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#deleteModal" 
                                            data-id="${notification.notificationId}">
                                        Delete
                                    </button>
                                </div>
                            </li>
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
                                <li class="list-group-item list-group-item-action d-flex justify-content-between ${notification.isRead ? 'list-group-item-secondary' : ''}">
                                    <form action="notification" method="POST" class="flex-grow-1">
                                        <input type="hidden" name="id" value="${notification.notificationId}"/>
                                        <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}"/>

                                        <button type="submit" class="btn btn-block text-left p-0 bg-transparent border-0">
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
                                        </button>
                                    </form>
                                    <div class="d-flex flex-column align-items-end">
                                        <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'} mb-2">
                                            ${notification.isRead ? 'Read' : 'Unread'}
                                        </span>
                                      <button class="btn btn-danger btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#deleteModal" 
                                            data-id="${notification.notificationId}">
                                        Delete
                                    </button>
                                    </div>
                                </li>
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
                                <li class="list-group-item list-group-item-action d-flex justify-content-between ${notification.isRead ? 'list-group-item-secondary' : ''}">
                                    <form action="notification" method="POST" class="flex-grow-1">
                                        <input type="hidden" name="id" value="${notification.notificationId}"/>
                                        <input type="hidden" name="redirectUrl" value="<%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}"/>

                                        <button type="submit" class="btn btn-block text-left p-0 bg-transparent border-0">
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
                                        </button>
                                    </form>
                                    <div class="d-flex flex-column align-items-end">
                                        <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'} mb-2">
                                            ${notification.isRead ? 'Read' : 'Unread'}
                                        </span>
                                       <button class="btn btn-danger btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#deleteModal" 
                                            data-id="${notification.notificationId}">
                                        Delete
                                    </button>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="notification" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this notification?
                    <input type="hidden" name="id" id="notificationId" value="">
                    <input type="hidden" name="action" value="delete">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>
            <script>
    $('#deleteModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var notificationId = button.data('id'); // Extract notification ID
        var modal = $(this);
        modal.find('#notificationId').val(notificationId);
    });
</script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
        </div>
    </div>
</body>
</html>