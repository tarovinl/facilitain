<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Item Categories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container-fluid">
      <div class="row vh-100">
        
          <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Item Categories</h1>
                    <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="bi bi-plus-lg"></i> Add Item Category
                    </button>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">Category ID</th>
                            <th scope="col">Category Name</th>
                            <th scope="col">Description</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categoryList}">
                            <tr>
                                <td>${category.itemCID}</td>
                                <td>${category.categoryName}</td>
                                <td>${category.description}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editCategoryModal"
                                            data-cid="${category.itemCID}" 
                                            data-name="${category.categoryName}" 
                                            data-description="${category.description}"
                                            data-active-flag="${category.activeFlag}"> 
                                        Edit
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <form action="itemCategories" method="post">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add Category</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="categoryName">Category Name</label>
                            <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea class="form-control" id="description" name="description" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="activeFlag">Active Flag</label>
                            <input type="number" class="form-control" id="activeFlag" name="activeFlag" required min="0" max="1" value="1">
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

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1" role="dialog" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <form action="itemCategories" method="post">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editCategoryModalLabel">Edit Category</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editItemCID" name="itemCID"> 
                        <div class="form-group">
                            <label for="editCategoryName">Category Name</label>
                            <input type="text" class="form-control" id="editCategoryName" name="categoryName" required>
                        </div>
                        <div class="form-group">
                            <label for="editDescription">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="editActiveFlag">Active Flag</label>
                            <input type="number" class="form-control" id="editActiveFlag" name="activeFlag" required min="0" max="1"> <!-- Hidden field for active flag -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning">Save Changes</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fill the Edit Modal with data when clicking the Edit button
        document.querySelectorAll('[data-bs-target="#editCategoryModal"]').forEach(button => {
            button.addEventListener('click', function() {
                const cid = this.getAttribute('data-cid');
                const name = this.getAttribute('data-name');
                const description = this.getAttribute('data-description');
                const activeFlag = this.getAttribute('data-active-flag'); 
                
                document.getElementById('editItemCID').value = cid;
                document.getElementById('editCategoryName').value = name;
                document.getElementById('editDescription').value = description;
                document.getElementById('editActiveFlag').value = activeFlag; 
            });
        });
    </script>
</body>
</html>
