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
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
     <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
  body, h1, h2, h3, h4, th,h5 {
    font-family: 'NeueHaasMedium', sans-serif !important;
}
 h6, input, textarea, td, tr, p, label, select, option {
    font-family: 'NeueHaasLight', sans-serif !important;
}
.hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
                            }

            .hover-outline:hover {
                background-color: 	#1C1C1C !important;
                color: 	#f2f2f2 !important;
                border: 1px solid 	#f2f2f2 !important;
                                }
            .hover-outline img {
                transition: filter 0.3s ease;
                                }

            .hover-outline:hover img {
                filter: invert(1);
                            }

            .buttonsBack:hover {
                text-decoration: underline !important;
                }
            .buildingManage:hover {
                text-decoration: underline !important;
                }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row vh-100">
            <jsp:include page="sidebar.jsp"></jsp:include>
        <div class="col-md-10 p-4">
            <h1 style="font-family: 'NeueHaasMedium', sans-serif;">Manage Users</h1>
            <table id="itemUserTable" class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                    </tr>
                </thead>
                <tbody class="table-light">
                    <c:forEach var="user" items="${itemUserList}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.name}</td>
                            <td>${user.email}</td>
                            <td>
                                <form action="itemUser" method="post" class="role-form">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <select name="role" class="form-select form-select-sm" onchange="this.form.submit()">
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

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#itemUserTable').DataTable();

        // Show SweetAlert2 alert if success parameter is present
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'true') {
            Swal.fire({
                title: 'Role Updated!',
                text: 'The user role has been successfully updated.',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(() => {
                // Remove the 'success' parameter from the URL
                const newUrl = window.location.origin + window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            });
        }
    });
</script>
</body>
</html>
