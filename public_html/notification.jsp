<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap-icons/1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <title>Notifications</title>
    
    <style>
        body, h1, h2, h3, h4, th {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h5, h6, input, textarea, td, tr, p, label, select, option {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .maintenance-dropdown {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.5rem;
            margin-top: 0.5rem;
        }
        
        .maintenance-item {
            padding: 0.25rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .maintenance-item:last-child {
            border-bottom: none;
        }
        
        .maintenance-count {
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            margin-left: 0.5rem;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>

        <div class="col-md-10 p-4">
            <h1 class="mb-4" style="color: black; font-family: 'NeueHaasMedium', sans-serif;">Notifications</h1>

            <!-- Sorting and Filtering controls -->
            <div class="d-flex justify-content-between mb-3 gap-2" style="font-family: NeueHaasLight, sans-serif;">
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
                                        <c:when test="${notification.type == 'WARNING'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                    </c:choose>
                                "/>
                                <button type="submit" class="btn btn-block text-start p-0 bg-transparent border-0 w-100">
                                    <div class="text-start">
                                        <h6 class="mb-1 text-start">
                                            <i class="bi bi-bell-fill text-${notification.isRead ? 'secondary' : 'primary'} me-2"></i>
                                            <c:choose>
                                                <c:when test="${notification.groupedMaintenance}">
                                                    Maintenance Required - ${notification.locName}
                                                    <span class="maintenance-count">${notification.maintenanceItemCount}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${notification.message}
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                        <small class="text-muted text-start">Created At: ${notification.createdAt}</small>
                                        <br>
                                        <small class="text-muted text-start">Location: ${notification.locName}</small>
                                        
                                        <!-- Dropdown for grouped maintenance items -->
                                        <c:if test="${notification.groupedMaintenance}">
                                            <div class="maintenance-dropdown mt-2 text-start">
                                                <strong>Items requiring maintenance:</strong>
                                                <c:forEach var="item" items="${notification.maintenanceItems}">
                                                    <div class="maintenance-item text-start">
                                                        <i class="bi bi-wrench text-warning me-2"></i>
                                                        ${item}
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </button>
                            </form>
                            <div class="d-flex flex-column align-items-end">
                                <span class="badge badge-${notification.isRead ? 'secondary' : 'primary'} mb-2">
                                    ${notification.isRead ? 'Read' : 'Unread'}
                                </span>
                                <button class="btn btn-danger btn-sm" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteModal" 
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
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete this notification?
                                <input type="hidden" name="id" id="notificationId" value="">
                                <input type="hidden" name="action" value="delete">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // When the delete button is clicked, set the notification ID in the modal form
                document.getElementById('deleteModal').addEventListener('show.bs.modal', function (event) {
                    var button = event.relatedTarget;
                    var notificationId = button.getAttribute('data-id');
                    var modal = this;
                    modal.querySelector('#notificationId').value = notificationId;
                });
            </script>
        </div>
    </div>
</body>
</html>
