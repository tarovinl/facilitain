<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap-icons/1.10.0/font/bootstrap-icons.css" rel="stylesheet">
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <title>Notifications</title>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <h1 class="mb-4" style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Notifications</h1>

            <!-- Sorting and Filtering controls -->
            <div class="d-flex justify-content-between mb-3">
                <form action="notification" method="get" class="d-flex" id="notificationForm">
                    <select name="sortBy" class="form-control mr-2" onchange="this.form.submit()">
                        <option value="date" <c:if test="${sortBy == 'date'}">selected</c:if>>Sort by Date</option>
                        <option value="read" <c:if test="${sortBy == 'read'}">selected</c:if>>Sort by Read Status</option>
                        <option value="unread" <c:if test="${sortBy == 'unread'}">selected</c:if>>Sort by Unread Status</option>
                    </select>
                    <select name="filterBy" class="form-control" onchange="this.form.submit()">
                        <option value="">All Notifications</option>
                        <option value="report" <c:if test="${filterBy == 'report'}">selected</c:if>>Reports</option>
                        <option value="quotation" <c:if test="${filterBy == 'quotation'}">selected</c:if>>Quotations</option>
                        <option value="maintenance" <c:if test="${filterBy == 'maintenance'}">selected</c:if>>Maintenance</option>
                        <option value="warning" <c:if test="${filterBy == 'warning'}">selected</c:if>>Warnings</option>
                        <option value="read" <c:if test="${filterBy == 'read'}">selected</c:if>>Read Only</option>
                        <option value="unread" <c:if test="${filterBy == 'unread'}">selected</c:if>>Unread Only</option>
                    </select>
                </form>
            </div>

            <!-- Notifications List -->
            <div class="overflow-auto">
                <ul class="list-group">
                    <c:forEach var="notification" items="${notifications}">
                        <li class="list-group-item list-group-item-action d-flex justify-content-between ${notification.isRead ? 'list-group-item-secondary' : ''}">
                            <form action="notification" method="POST" class="flex-grow-1">
                                <input type="hidden" name="id" value="${notification.notificationId}"/>
                                <input type="hidden" name="redirectUrl" value="  
                                    <c:choose>
                                        <c:when test="${notification.type == 'MAINTENANCE'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                        <c:when test="${notification.type == 'REPORT'}"><%=request.getContextPath()%>/reports</c:when>
                                        <c:when test="${notification.type == 'QUOTATION'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                         <c:when test="${notification.type == 'WARNING'}"><%=request.getContextPath()%>//buildingDashboard?locID=${notification.itemLocId}</c:when>
                                    </c:choose>
                                "/>
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

            <!-- Modal for Deleting Notifications -->
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
    // When the delete button is clicked, set the notification ID in the modal form
    $('#deleteModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var notificationId = button.data('id'); // Extract notificationId from data-id attribute
        var modal = $(this);
        modal.find('#notificationId').val(notificationId); // Set the notification ID in the hidden input
    });
</script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
        </div>
    </div>
</body>
</html>
