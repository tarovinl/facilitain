<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
     <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Item Categories - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
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

                    a.paginate-button {
                    margin: 0 5px;
                    
                    border: 1px solid black; /* Border color */
                    background-color: #fccc4c;   /* Background color */
                    color: black;            /* Text color */
                    cursor: pointer;
                    border-radius: 5px;
                    font-size: 14px;
                    font-weight: bold;
                    transition: background-color 0.3s, color 0.3s; /* Add a smooth hover effect */
                }
                a.paginate-button:hover {
                    background-color: #ffcc00; /* Blue background on hover */
                    color: black;              /* White text on hover */
                }
                a.paginate-button.active {
                    background-color: black; /* Active button background */
                    color: #fccc4c;              /* Active button text color */
                    border-color: black;     /* Border color for the active button */
                }
                                
                                .btn-cancel-outline {
                  color: #8388a4 !important;        /* Text color */
                  background-color: white !important; /* White background */
                  border: 2px solid #8388a4 !important; /* Outline */
                  box-shadow: none !important;       /* Remove default shadow */
                }
                
                /* Optional: add hover effect */
                .btn-cancel-outline:hover {
                  background-color: #f0f2f7 !important; /* Light gray bg on hover */
                  border-color: #8388a4 !important;
                  color: #8388a4 !important;
                }
                .responsive-padding-top {
                                  padding-top: 100px;
                                }
                                
                @media (max-width: 576px) {
                .responsive-padding-top {
                padding-top: 80px; /* or whatever smaller value you want */
                }
                }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="container-fluid">
    <div class="row vh-100">
    <c:set var="page" value="itemCategories" scope="request"/>
            <jsp:include page="sidebar.jsp"></jsp:include>
        <div class="col-md-10 responsive-padding-top">
            <!-- Header Section -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Item Categories</h1>
                <button class="buttonsBuilding d-flex align-items-center px-3 py-2 rounded-2 hover-outline " style="background-color: #fccc4c;" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <img src="resources/images/icons/plus.svg" alt="add"  width="25" height="25"> 
                    <span class="d-none d-lg-inline ps-2">Add</span>
                </button>
            </div>

            <!-- Table Section -->
            <div class="table-responsive">
                <table id="categoriesTable" class="table table-striped table-bordered align-middle mt-4">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">Category ID</th>
                            <th scope="col">Category Name</th>
                            <th scope="col">Description</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="table-light">
                        <c:forEach var="category" items="${categoryList}">
                            <c:if test="${category.archivedFlag == 1}">
                                <tr>
                                    <td>${category.itemCID}</td>
                                    <td>${category.categoryName.toUpperCase()}</td>
                                    <td>${category.description}</td>
                                    <td>
                                        <!-- Edit Button -->
                                        <button class="btn btn-sm btn-primary shadow-sm me-2" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#editCategoryModal"
                                                data-cid="${category.itemCID}" 
                                                data-name="${category.categoryName}" 
                                                data-description="${category.description}"> 
                                            Edit
                                        </button>
                                        <!-- Archive Form -->
                                      <form action="itemCategories" method="post" class="d-inline">
                                            <input type="hidden" name="itemCID" value="${category.itemCID}">
                                            <input type="hidden" name="action" value="archive">
                                            <button type="submit" 
                                                    class="btn btn-sm btn-danger shadow-sm" 
                                                    >
                                                Archive
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form action="itemCategories" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCategoryModalLabel">Add Item Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="categoryName">Category Name</label>
                        <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea class="form-control" id="description" name="description" ></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success">Add</button>
                    
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
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editItemCID" name="itemCID">
            <input type="hidden" name="editMode" value="true">  <!-- Add this line -->
            <div class="form-group">
                <label for="editCategoryName">Category Name</label>
                <input type="text" class="form-control" id="editCategoryName" name="categoryName" required>
            </div>
            <div class="form-group">
                <label for="editDescription">Description</label>
                <textarea class="form-control" id="editDescription" name="description" required></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-success">Save Changes</button>
        </div>
    </div>
</form>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script>
    $(document).ready(function () {
        // Initialize DataTable
        $('#categoriesTable').DataTable();

        // Prefill Edit Modal with data
        const editModal = document.getElementById('editCategoryModal');
        editModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const cid = button.getAttribute('data-cid');
            const name = button.getAttribute('data-name');
            const description = button.getAttribute('data-description');

            document.getElementById('editItemCID').value = cid;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editDescription').value = description;
        });

        // Handle SweetAlert2 notifications
        const urlParams = new URLSearchParams(window.location.search);
        const action = urlParams.get('action');
        const error = urlParams.get('error');

        if (action || error) {
            let alertConfig = {
                confirmButtonText: 'OK',
                allowOutsideClick: false
            };

            if (error) {
                alertConfig = {
                    ...alertConfig,
                    title: 'Error!',
                    text: 'An error occurred while processing your request.',
                    icon: 'error'
                };
            } else {
                switch(action) {
                    case 'archived':
                        alertConfig = {
                            ...alertConfig,
                            title: 'Archived!',
                            text: 'The category has been successfully archived.',
                            icon: 'success'
                        };
                        break;
                    case 'updated':
                        alertConfig = {
                            ...alertConfig,
                            title: 'Updated!',
                            text: 'The category has been successfully updated.',
                            icon: 'success'
                        };
                        break;
                    case 'added':
                        alertConfig = {
                            ...alertConfig,
                            title: 'Added!',
                            text: 'The new category has been successfully added.',
                            icon: 'success'
                        };
                        break;
                }
            }

            Swal.fire(alertConfig).then(() => {
                // Remove the parameters from the URL without refreshing
                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            });
        }

        // Archive confirmation handler 
        $(document).on('click', '.btn-danger', function(e) {
            // Check if this button is within a form with archive action
            const form = $(this).closest('form');
            const archiveInput = form.find('input[name="action"][value="archive"]');
            
            if (archiveInput.length > 0) {
                e.preventDefault();
                e.stopPropagation();
                
                const formElement = form[0];
                
                Swal.fire({
                    title: 'Are you sure?',
                    text: 'You want to archive this category?',
                    icon: 'warning',
                    showCancelButton: true,
                    reverseButtons: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Yes, Archive it!',
                    cancelButtonText: 'Cancel',
                    customClass: {
                        cancelButton: 'btn-cancel-outline'
                    },
                    allowOutsideClick: false,
                    allowEscapeKey: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Submit the form directly
                        formElement.submit();
                    }
                });
                
                return false;
            }
        });
    });
</script>
</body>
</html>