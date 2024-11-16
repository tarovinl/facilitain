<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
    <!-- Bootstrap 5 CSS and JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


    <style>
        .modal-backdrop {
            z-index: 1040;
        }
        .modal {
            z-index: 1050;
        }
    </style>
</head>
<body>
    <!-- Main Quotations Modal -->
    <div class="modal fade" id="quotEquipment" tabindex="-1" aria-labelledby="equipmentquot" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header d-flex align-items-center justify-content-space-between">
                    <h3 class="modal-title fw-bold" id="equipmentquot">Quotations</h3>
                    <div>
                        <button class="btn btn-dark text-warning fw-bold mx-3 mt-2" id="uploadQuotationBtn" onclick="itemIDcarry(getModalItemId())">
                            Upload Quotations
                        </button>
                        <button type="button" class="btn btn-warning fw-bold ms-auto" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>

                <div class="modal-body">
                    <div class="centered-div bg-white">
                        <div class="container mt-2 mb-2">
                            <!-- Table Section -->
                            <div class="row mt-1">
                                <div class="col">
                                    <table id="quotationsTable" class="table table-striped table-hover table-bordered">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th scope="col">Code</th>
                                                <th scope="col">Description</th>
                                                <th scope="col">Date Uploaded</th>
                                                <th scope="col">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="quotation" items="${quotations}">
                                                <tr>
                                                    <td>${quotation.quotationId}</td>
                                                    <td>${quotation.description}</td>
                                                    <td>${quotation.dateUploaded}</td>
                                                    <td>
                                                        <!-- Add any specific actions you need here -->
                                                        <button type="button" class="btn btn-sm btn-primary">View</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>     
                    </div>            
                </div>
            </div>
        </div>
    </div>

    <!-- Upload Quotation Modal -->
    <div class="modal fade" id="uploadQuotationModal" tabindex="-1" aria-labelledby="uploadQuotationLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="uploadQuotationLabel">Upload Quotation</h5>
                    <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="uploadQuotationForm" enctype="multipart/form-data" method="post" action="quotations">
                        <!-- Hidden Field to Store Item ID -->
                        <input type="hidden" name="hiddenItemId" id="hiddenItemId">


                        <div class="row mt-1">
                            <div class="col">
                                <table id="quotationsTable" class="table table-striped table-hover table-bordered">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th scope="col">Code</th>
                                            <th scope="col">Description</th>
                                            <th scope="col">Date Uploaded</th>
                                            <th scope="col"></th> <!-- Empty column for actions -->
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>001</td>
                                            <td>Sample Description 1</td>
                                            <td>2024-10-17</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        <div class="mb-3">
                            <label for="quotationDescription" class="form-label">Quotation Description</label>
                            <textarea class="form-control" name="description" id="quotationDescription" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="quotationFile" class="form-label">Upload File</label>
                            <input class="form-control" type="file" name="quotationFile" id="quotationFile" accept="image/*, .pdf" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="saveQuotationBtn">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#quotationsTable').DataTable({
                "paging": true,
                "pageLength": 5,
                "lengthChange": false,
                "info": false,
                "searching": false,
                "ordering": false
            });

            // Handle opening upload modal
            $('#uploadQuotationBtn').on('click', function() {
                $('#quotEquipment').modal('hide');
                setTimeout(function() {
                    $('#uploadQuotationModal').modal('show');
                }, 200);
            });

            // Handle close button on upload modal
            $('.btn-close, .btn-secondary').on('click', function() {
                $('#uploadQuotationModal').modal('hide');
                setTimeout(function() {
                    $('#quotEquipment').modal('show');
                }, 200);
            });

            // Handle save button
            $('#saveQuotationBtn').on('click', function() {
                // Submit the form to the servlet
                $('#uploadQuotationForm').submit();
            });

            // Handle modal backdrop cleanup
            $('.modal').on('hidden.bs.modal', function() {
                if($('.modal.show').length > 0) {
                    $('body').addClass('modal-open');
                } else {
                    $('.modal-backdrop').remove();
                }
            });
        });

        // Function to populate the quotation modal with item ID
           function populateQuotModal(button) {
        // Retrieve the itemID from the clicked button
        const itemId = button.getAttribute("data-itemid");
        
        // Find the element inside the modal to display itemID (e.g., a hidden field or a display span)
        const modalItemId = document.getElementById("modalItemId"); 
        
       
        modalItemId.value = itemId; 
           }
function itemIDcarry(itemId) {
    // Set the value of the hidden field in the upload modal with the item ID
    document.querySelector('input[name="hiddenItemId"]').value = itemId;
}

      
    
    // Function to get the item ID from the hidden span
function getModalItemId() {
    // Assuming there's an element (span or similar) in the modal that contains the item ID
    return document.getElementById("modalItemId").innerText;
}


    </script>
</body>
</html>
