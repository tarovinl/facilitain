<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${unreadCount > 0}">
    <div class="modal fade" id="notificationPopup" tabindex="-1" aria-labelledby="notificationPopupLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="notificationPopupLabel">Unread Notifications</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>You have <strong>${unreadCount}</strong> unread notifications.</p>
                    <ul>
                        <c:forEach var="type" items="${unreadNotificationTypes}">
                            <li>${type}</li>
                        </c:forEach>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Got it</button>
                </div>
            </div>
        </div>
    </div>
</c:if>
