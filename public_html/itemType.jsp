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
             <div class="d-flex justify-content-between align-items-center">
                <h1>Item Types</h1>
                <button class="btn btn-warning my-3" data-bs-toggle="modal" data-bs-target="#addItemTypeModal">Add Item Type</button>
                </div>
                <!-- Display Table -->
            <table class="table table-striped mt-4">
    <thead>
        <tr>
            <th>Type ID</th>
            <th>Category Name</th>
            <th>Name</th>
            <th>Description</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="type" items="${itemTypeList}">
            <c:if test="${type.archivedFlag == 1}">
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
                    <td>
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#editItemTypeModal"
                                data-itemtypeid="${type.itemTypeId}" data-itemcatid="${type.itemCatId}"
                                data-name="${type.name}" data-description="${type.description}">Edit</button>

                        <form action="itemType" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to archive this item type?');">
                            <input type="hidden" name="itemTypeId" value="${type.itemTypeId}">
                            <input type="hidden" name="action" value="archive">
                            <button type="submit" class="btn btn-danger btn-sm">Archive</button>
                        </form>
                    </td>
                </tr>
            </c:if>
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
                                         <option value="" disabled selected>--Choose Item Type--</option>
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

                <!-- Edit Item Type Modal -->
                <div class="modal fade" id="editItemTypeModal" tabindex="-1" aria-labelledby="editItemTypeModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="itemType" method="post">
                                <input type="hidden" name="editMode" value="true">
                                <input type="hidden" id="editItemTypeId" name="itemTypeId">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editItemTypeModalLabel">Edit Item Type</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="editItemCatId" class="form-label">Category</label>
                                        <select class="form-select" id="editItemCatId" name="itemCatId" required>
                                            <c:forEach var="category" items="${categoryList}">
                                                <option value="${category.key}">${category.value}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editName" class="form-label">Name</label>
                                        <input type="text" class="form-control" id="editName" name="name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editDescription" class="form-label">Description</label>
                                        <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Prefill Edit Modal with selected item data
        const editModal = document.getElementById('editItemTypeModal');
        editModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            document.getElementById('editItemTypeId').value = button.getAttribute('data-itemtypeid');
            document.getElementById('editItemCatId').value = button.getAttribute('data-itemcatid');
            document.getElementById('editName').value = button.getAttribute('data-name');
            document.getElementById('editDescription').value = button.getAttribute('data-description');
        });
    </script>
</body>
</html>
