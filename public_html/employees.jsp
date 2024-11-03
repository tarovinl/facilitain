<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Employee List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Employees List</h1>
                    <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
                        <i class="bi bi-plus-lg"></i> Add Employee
                    </button>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Employee ID</th>
                            <th>Surname</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Other Name</th>
                            <th>Service Area ID</th>
                            <th>Employee Status</th>
                            <th>Company</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="employee" items="${employeeList}" varStatus="status">
                            <tr>
                                <td>${employee.employeeId}</td>
                                <td>${employee.surname}</td>
                                <td>${employee.firstName}</td>
                                <td>${employee.middleName}</td>
                                <td>${employee.otherName}</td>
                                <td>${employee.serviceAreaId}</td>
                                <td>${employee.status}</td>
                                <td>${employee.companyName}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editEmployeeModal"
                                            data-id="${employee.employeeId}"
                                            data-surname="${employee.surname}"
                                            data-firstname="${employee.firstName}"
                                            data-middlename="${employee.middleName}"
                                            data-othername="${employee.otherName}"
                                            data-srvc-area-id="${employee.serviceAreaId}"
                                            data-status="${employee.status}"
                                            data-company="${employee.companyName}">
                                        Edit
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="employeeList?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="employeeList?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="employeeList?page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>

            </div>
        </div>
    </div>

    <!-- Add Employee Modal -->
    <div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <form action="employeeController" method="post">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addEmployeeModalLabel">Add Employee</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="surname">Surname</label>
                            <input type="text" class="form-control" id="surname" name="surname" required>
                        </div>
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                        </div>
                        <div class="form-group">
                            <label for="middleName">Middle Name</label>
                            <input type="text" class="form-control" id="middleName" name="middleName">
                        </div>
                        <div class="form-group">
                            <label for="otherName">Other Name</label>
                            <input type="text" class="form-control" id="otherName" name="otherName">
                        </div>
                        <div class="form-group">
                            <label for="srvcAreaId">Service Area ID</label>
                            <input type="number" class="form-control" id="srvcAreaId" name="serviceAreaId" required>
                        </div>
                        <div class="form-group">
                            <label for="empStatus">Employee Status</label>
                            <select class="form-control" id="empStatus" name="status" required>
                                <option value="1">Regular</option>
                                <option value="2">Casual</option>
                                <option value="3">Service Provider</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="companyName">Company Name</label>
                            <input type="text" class="form-control" id="companyName" name="companyName">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning">Add</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Employee Modal -->
    <div class="modal fade" id="editEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="editEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <form action="employeeController" method="post">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editEmployeeModalLabel">Edit Employee</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editEmpId" name="employeeId">
                        <div class="form-group">
                            <label for="editSurname">Surname</label>
                            <input type="text" class="form-control" id="editSurname" name="surname" required>
                        </div>
                        <div class="form-group">
                            <label for="editFirstName">First Name</label>
                            <input type="text" class="form-control" id="editFirstName" name="firstName" required>
                        </div>
                        <div class="form-group">
                            <label for="editMiddleName">Middle Name</label>
                            <input type="text" class="form-control" id="editMiddleName" name="middleName">
                        </div>
                        <div class="form-group">
                            <label for="editOtherName">Other Name</label>
                            <input type="text" class="form-control" id="editOtherName" name="otherName">
                        </div>
                        <div class="form-group">
                            <label for="editSrvcAreaId">Service Area ID</label>
                            <input type="number" class="form-control" id="editSrvcAreaId" name="serviceAreaId" required>
                        </div>
                        <div class="form-group">
                            <label for="editEmpStatus">Employee Status</label>
                            <select class="form-control" id="editEmpStatus" name="status" required>
                                <option value="1">Regular</option>
                                <option value="2">Casual</option>
                                <option value="3">Service Provider</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editCompanyName">Company Name</label>
                            <input type="text" class="form-control" id="editCompanyName" name="companyName">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning">Update</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const editButtons = document.querySelectorAll('[data-bs-target="#editEmployeeModal"]');
        editButtons.forEach(button => {
            button.addEventListener('click', function () {
                document.getElementById('editEmpId').value = this.getAttribute('data-id');
                document.getElementById('editSurname').value = this.getAttribute('data-surname');
                document.getElementById('editFirstName').value = this.getAttribute('data-firstname');
                document.getElementById('editMiddleName').value = this.getAttribute('data-middlename');
                document.getElementById('editOtherName').value = this.getAttribute('data-othername');
                document.getElementById('editSrvcAreaId').value = this.getAttribute('data-srvc-area-id');
                document.getElementById('editEmpStatus').value = this.getAttribute('data-status');
                document.getElementById('editCompanyName').value = this.getAttribute('data-company');
            });
        });
    </script>
</body>
</html>