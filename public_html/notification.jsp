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
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
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

        .assign-notification {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
        }
        
        /* Enhanced read/unread styling */
        .list-group-item.unread {
            background-color: #f8f9ff;
            border-left: 4px solid #0d6efd;
            font-weight: 500;
        }
        
        .list-group-item.read {
            background-color: #f8f9fa;
            border-left: 4px solid #6c757d;
            opacity: 0.85;
        }
        
        /* Better status badges */
        .status-badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.4rem 0.8rem;
            border-radius: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-badge.unread {
            background-color: #0d6efd;
            color: white;
            box-shadow: 0 2px 4px rgba(13, 110, 253, 0.3);
        }
        
        .status-badge.read {
            background-color: #6c757d;
            color: white;
        }
        
        /* Subtle hover effects */
        .list-group-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
        }
        
        /* Better form controls */
        .form-control {
            border-radius: 0.5rem;
            border: 1px solid #dee2e6;
            padding: 0.6rem 0.75rem;
        }
        
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }
        
        /* Pagination styling */
        .pagination {
            margin-top: 2rem;
            justify-content: center;
        }
        
        .pagination .page-link {
            border-radius: 0.5rem;
            margin: 0 0.2rem;
            border: 1px solid #dee2e6;
            color: #495057;
            padding: 0.6rem 0.9rem;
        }
        
        .pagination .page-link:hover {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
        }
        
        .pagination .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        
        /* Icon improvements */
        .notification-icon {
            font-size: 1.1rem;
            margin-right: 0.5rem;
        }
        
        .unread .notification-icon {
            color: #0d6efd;
        }
        
        .read .notification-icon {
            color: #6c757d;
        }
        
        /* Better spacing */
        .list-group-item {
            padding: 1.2rem;
            margin-bottom: 0.5rem;
            border-radius: 0.5rem;
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
                <form action="notification" method="get" class="d-flex gap-2" id="notificationForm">
                    <select name="sortBy" class="form-control" onchange="this.form.submit()">
                        <option value="date" <c:if test="${sortBy == 'date'}">selected</c:if>>Sort by Date</option>
                        <option value="read" <c:if test="${sortBy == 'read'}">selected</c:if>>Sort by Read Status</option>
                        <option value="unread" <c:if test="${sortBy == 'unread'}">selected</c:if>>Sort by Unread Status</option>
                    </select>
                    <select name="filterBy" class="form-control" onchange="this.form.submit()">
                        <option value="">All Notifications</option>
                        <option value="report" <c:if test="${filterBy == 'report'}">selected</c:if>>Reports</option>
                        <option value="quotation" <c:if test="${filterBy == 'quotation'}">selected</c:if>>Quotations</option>
                        <option value="maintenance" <c:if test="${filterBy == 'maintenance'}">selected</c:if>>Maintenance</option>
                        <option value="assign" <c:if test="${filterBy == 'assign'}">selected</c:if>>Assignments</option>
                        <option value="warning" <c:if test="${filterBy == 'warning'}">selected</c:if>>Warnings</option>
                        <option value="read" <c:if test="${filterBy == 'read'}">selected</c:if>>Read Only</option>
                        <option value="unread" <c:if test="${filterBy == 'unread'}">selected</c:if>>Unread Only</option>
                    </select>
                    <select name="perPage" class="form-control" onchange="this.form.submit()">
                        <option value="10" <c:if test="${perPage == 10}">selected</c:if>>10 per page</option>
                        <option value="25" <c:if test="${perPage == 25}">selected</c:if>>25 per page</option>
                        <option value="50" <c:if test="${perPage == 50}">selected</c:if>>50 per page</option>
                    </select>
                    <input type="hidden" name="page" value="${currentPage}">
                </form>
            </div>

            <!-- Notifications List -->
            <div class="overflow-auto">
                <ul class="list-group">
                    <c:forEach var="notification" items="${notifications}">
                        <li class="list-group-item list-group-item-action d-flex justify-content-between position-relative ${notification.isRead ? 'read' : 'unread'} ${notification.assignmentNotification ? 'assign-notification' : ''}">
                            <form action="notification" method="POST" class="flex-grow-1">
                                <input type="hidden" name="id" value="${notification.notificationId}"/>
                                <input type="hidden" name="redirectUrl" value="  
                                    <c:choose>
                                        <c:when test="${notification.type == 'MAINTENANCE'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                        <c:when test="${notification.type == 'REPORT'}"><%=request.getContextPath()%>/reports</c:when>
                                        <c:when test="${notification.type == 'QUOTATION'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                        <c:when test="${notification.type == 'ASSIGN'}"><%=request.getContextPath()%>/maintenancePage</c:when>
                                        <c:when test="${notification.type == 'WARNING'}"><%=request.getContextPath()%>/buildingDashboard?locID=${notification.itemLocId}</c:when>
                                    </c:choose>
                                "/>
                                <button type="submit" class="btn btn-block text-start p-0 bg-transparent border-0 w-100">
                                    <div class="text-start">
                                        <h6 class="mb-1 text-start">
                                            <c:choose>
                                                <c:when test="${notification.assignmentNotification}">
                                                    <i class="bi bi-person-check-fill notification-icon text-info"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-bell-fill notification-icon"></i>
                                                </c:otherwise>
                                            </c:choose>
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
                                        <small class="text-muted text-start d-block">
                                            <i class="bi bi-clock me-1"></i>Created At: ${notification.createdAt}
                                        </small>
                                        <small class="text-muted text-start d-block">
                                            <i class="bi bi-geo-alt me-1"></i>Location: ${notification.locName}
                                        </small>
                                        
                                        <!-- Dropdown for grouped maintenance items -->
                                        <c:if test="${notification.groupedMaintenance}">
                                            <div class="maintenance-dropdown mt-2 text-start">
                                                <strong><i class="bi bi-list-check text-warning me-2"></i>Items requiring maintenance:</strong>
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
                                <span class="status-badge ${notification.isRead ? 'read' : 'unread'} mb-2">
                                    <i class="bi bi-${notification.isRead ? 'check-circle-fill' : 'circle-fill'} me-1"></i>
                                    ${notification.isRead ? 'Read' : 'Unread'}
                                </span>
                                <button class="btn btn-danger btn-sm" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteModal" 
                                        data-id="${notification.notificationId}">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Notification pagination">
                    <ul class="pagination">
                        <!-- Previous Button -->
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&sortBy=${sortBy}&filterBy=${filterBy}&perPage=${perPage}">
                                <i class="bi bi-chevron-left"></i> Previous
                            </a>
                        </li>
                        
                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <c:if test="${pageNum <= 5 || pageNum >= totalPages - 4 || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&sortBy=${sortBy}&filterBy=${filterBy}&perPage=${perPage}">${pageNum}</a>
                                </li>
                            </c:if>
                            <c:if test="${pageNum == 6 && currentPage > 8}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                            <c:if test="${pageNum == totalPages - 5 && currentPage < totalPages - 7}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:forEach>
                        
                        <!-- Next Button -->
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&sortBy=${sortBy}&filterBy=${filterBy}&perPage=${perPage}">
                                Next <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                
                <!-- Pagination Info -->
                <div class="text-center text-muted mt-2">
                    <small>
                        Showing ${(currentPage - 1) * perPage + 1} to ${currentPage * perPage > totalNotifications ? totalNotifications : currentPage * perPage} 
                        of ${totalNotifications} notifications
                    </small>
                </div>
            </c:if>

            <!-- Modal for Deleting Notifications -->
            <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <form action="notification" method="POST">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteModalLabel">
                                    <i class="bi bi-exclamation-triangle text-warning me-2"></i>Confirm Deletion
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete this notification?
                                <input type="hidden" name="id" id="notificationId" value="">
                                <input type="hidden" name="action" value="delete">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </button>
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