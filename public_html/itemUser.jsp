<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Users</title>
    <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>
        <div class="col-md-10">
            <h1>Manage Item Users</h1>
            <table id="itemUserTable" class="table table-striped table-bordered mt-4">
                <thead>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${itemUserList}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>
                            <form action="itemUser" method="post" class="role-form">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <select name="role" class="form-select" onchange="this.form.submit()">
                                    <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                    <option value="Respondent" ${user.role == 'Respondent' ? 'selected' : ''}>Respondent</option>
                                    <option value="Support" ${user.role == 'Support' ? 'selected' : ''}>Support Staff</option>
                                </select>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Success Message Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="successModalLabel">Success</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Role updated successfully!
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#itemUserTable').DataTable();

        // Trigger success modal if the session contains the success message
        const successMessage = "${sessionScope.updateSuccess}";
        if (successMessage) {
            const modal = new bootstrap.Modal(document.getElementById('successModal'));
            modal.show();

            // Remove the success message from the session
            <c:remove var="updateSuccess" scope="session" />
        }
    });
</script>
</body>
</html>
