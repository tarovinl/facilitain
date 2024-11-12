<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Item Types</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            <div class="col-md-9 col-lg-10 p-4">
                <h1>Item Types</h1>
                <button class="btn btn-primary my-3" data-bs-toggle="modal" data-bs-target="#addItemTypeModal">Add Item Type</button>

                <!-- Display Table -->
                <table class="table table-striped mt-4">
                    <thead>
                        <tr>
                            <th>Type ID</th>
                            <th>Category Name</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Active</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="type" items="${itemTypeList}">
                            <tr>
                                <td>${type.itemTypeId}</td>
                                <td>
                                    <c:forEach var="category" items="${categoryList}">
                                        <c:if test="${category.key == type.itemCatId}">
                                            ${category.value}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>${type.name}</td>
                                <td>${type.description}</td>
                                <td>${type.activeFlag == 1 ? 'Yes' : 'No'}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Add Item Type Modal -->
                <div class="modal fade" id="addItemTypeModal" tabindex="-1" aria-labelledby="addItemTypeModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="itemType" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addItemTypeModalLabel">Add Item Type</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="itemCatId" class="form-label">Category</label>
                                        <select class="form-select" id="itemCatId" name="itemCatId" required>
                                            <c:forEach var="category" items="${categoryList}">
                                                <option value="${category.key}">${category.value}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Name</label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-primary">Add Item Type</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
