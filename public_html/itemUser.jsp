<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Item Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10">
                <h1 class="font-medium">Item Users</h1>
                <table class="table table-striped mt-4">
                    <thead class="font-medium">
                        <tr>
                            <th>Employee Number</th>
                            <th>Full Name</th>
                            <th>User Type</th>
                        </tr>
                    </thead>
                    <tbody class="font-light">
                        <c:forEach var="user" items="${itemUserList}">
                            <tr>
                                <td>${user.empNumber}</td>
                                <td>${user.fullName}</td>
                                <td>
                                    <form action="itemUser" method="post">
                                        <!-- Hidden field to store employee number -->
                                        <input type="hidden" name="empNumber" value="${user.empNumber}" />
                                        <select name="userType" class="form-select" onchange="this.form.submit()">
                                            <c:forEach var="type" items="${userTypeList}">
                                                <option value="${type.key}" ${type.key == user.userType ? 'selected' : ''}>${type.value}</option>
                                            </c:forEach>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
