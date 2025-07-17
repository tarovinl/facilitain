<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="page" value="itemType" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Item Types - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
     <link rel="stylesheet" href="./resources/css/custom-fonts.css">
     <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    body, h1, h2, h3, h4, th ,h5{
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
   <jsp:include page="sidebar.jsp">
  <jsp:param name="page" value="itemType" />
</jsp:include>
        <div class="col-md-10 responsive-padding-top">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0" style="font-family: 'NeueHaasMedium', sans-serif; font-size: 2rem;">Item Types</h1>
                <button class="buttonsBuilding d-flex align-items-center px-3 py-2 rounded-2 hover-outline " style="background-color: #fccc4c;" data-bs-toggle="modal" data-bs-target="#addItemTypeModal">
                    <img src="resources/images/icons/plus.svg" alt="add"  width="25" height="25">  
                    <span class="d-none d-lg-inline ps-2">Add</span>
                </button>
            </div>

            <!-- Item Types List Table -->
            <table id="itemTypeTable" class="table table-striped table-bordered mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>Type ID</th>
                        <th>Category Name</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody class="table-light">
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
                                    <button class="btn btn-primary btn-sm" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editItemTypeModal"
                                            data-itemtypeid="${type.itemTypeId}"
                                            data-itemcatid="${type.itemCatId}"
                                            data-name="${type.name}"
                                            data-description="${type.description}">
                                        Edit
                                    </button>
                                    <form action="itemType" method="post" class="d-inline" >
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
                                <button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="itemCatId" class="form-label">Category</label>
                                    <select class="form-select" id="itemCatId" name="itemCatId" required>
                                        <option value="" disabled selected>-- Choose Item Category --</option>
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
                                <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success">Add</button>
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
                                 <button type="button" class="btn btn-outline-danger" style="font-family: 'NeueHaasMedium', sans-serif;" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-success">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
$(document).ready(function () {
    // Initialize DataTable
    $('#itemTypeTable').DataTable();

    // Prefill Edit Modal with selected item data
    const editModal = document.getElementById('editItemTypeModal');
    editModal.addEventListener('show.bs.modal', event => {
        const button = event.relatedTarget;
        document.getElementById('editItemTypeId').value = button.getAttribute('data-itemtypeid');
        document.getElementById('editItemCatId').value = button.getAttribute('data-itemcatid');
        document.getElementById('editName').value = button.getAttribute('data-name');
        document.getElementById('editDescription').value = button.getAttribute('data-description');
    });

    // Handle SweetAlert2 notifications for success/error messages
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
                        text: 'The item type has been successfully archived.',
                        icon: 'success'
                    };
                    break;
                case 'updated':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Updated!',
                        text: 'The item type has been successfully updated.',
                        icon: 'success'
                    };
                    break;
                case 'added':
                    alertConfig = {
                        ...alertConfig,
                        title: 'Added!',
                        text: 'The new item type has been successfully added.',
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

    // Archive confirmation handler - target Archive buttons specifically
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
                text: 'You want to archive this item type?',
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

</body>
</html>
