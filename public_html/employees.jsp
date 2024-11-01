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


