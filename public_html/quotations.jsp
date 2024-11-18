<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="sample.model.Quotation" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
    <div class="modal fade" id="quotEquipmentModal" tabindex="-1" aria-labelledby="equipmentquot" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="equipmentquot">
                        <span id="modalItemIdDisplay">Quotations</span>
                    </h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="container mt-2 mb-2">
                        <!-- Upload Quotation Button -->
                        <button type="button" class="btn btn-warning mb-3" data-bs-toggle="modal" data-bs-target="#uploadQuotationModal">
                            Upload Quotation
                        </button>

                        <!-- Quotations Table -->
                        <table id="quotationsTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Description</th>
                                    <th>Date Uploaded</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                         
<tbody id="quotationModalContent">
                        <!-- Quotations will be loaded here via AJAX -->
                    </tbody>

                                
                          
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

 <!-- Upload Quotation Modal -->
<div class="modal fade" id="uploadQuotationModal" tabindex="-1" aria-labelledby="uploadQuotationLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
          <form id="uploadQuotationForm" method="post" enctype="multipart/form-data" action="quotationcontroller" >
            <input type="hidden" name="locID" value="${locID}">
            <input type="hidden" name="floorName" value="${floorName}">
    <!-- Hidden field to store Item ID -->
    <input type="hidden" name="itemID" id="uploadHiddenItemId">
    
    <div class="mb-3">
        <label for="quotationDescription" class="form-label">Quotation Description</label>
        <textarea class="form-control" name="description" id="quotationDescription" rows="3" required></textarea>
    </div>
    <div class="mb-3">
        <label for="quotationFile" class="form-label">Upload File</label>
        <input class="form-control" type="file" name="quotationFile" id="quotationFile" accept=".pdf, image/*" required>
    </div>
    
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="submitQuotationForm()">Upload</button>
    </div>
</form>


        </div>
    </div>
</form>

</div>


<script>
    // Function to submit the upload form
    // Function to submit the form
    function submitQuotationForm() {
        // Get the hidden input value (itemID)
        const hiddenItemId = document.getElementById('uploadHiddenItemId').value;
        console.log("Submitting form with itemID:", hiddenItemId);


            // Ensure all required fields are filled
            const description = document.getElementById('quotationDescription').value;
            const fileInput = document.getElementById('quotationFile').files[0];
                // Submit the form if all fields are valid
            document.getElementById('uploadQuotationForm').submit();
 
    }

    // Function to populate the hidden input field when the modal is opened
//    function populateUploadModal(itemId) {
//        sessionStorage.setItem('selectedItemId', itemId);
//        const hiddenInput = document.getElementById('uploadHiddenItemId');
//
//        if (hiddenInput) {
//            hiddenInput.value = itemId;
//            console.log("Setting hidden field in upload modal:", itemId);
//        } else {
//            console.error("Hidden input element not found!");
//        }
//    }

//    // Event listener to populate the hidden input field when the modal is shown
//    $('#quotEquipmentModal').on('show.bs.modal', function () {
//        const itemId = sessionStorage.getItem('selectedItemId');
//        console.log("Populating upload modal with itemID:", itemId);
//
//        const hiddenInput = document.getElementById('uploadHiddenItemId');
//        if (hiddenInput) {
//            hiddenInput.value = itemId;
//            console.log("uploadHiddenItemId value:", hiddenInput.value);
//        }
//    });
        // Ensure DataTable initializes only once
     $(document).ready(function() {
    // Check if DataTable is already initialized
    if ($.fn.DataTable && !$.fn.DataTable.isDataTable('#quotationsTable')) {
        $('#quotationsTable').DataTable({
            paging: true,
            pageLength: 5,
            lengthChange: false,
            info: false,
            searching: false,
            ordering: false
        });
    }
});


        // Function to populate the item ID in the hidden field when uploading
      
//function populateQuotModal(button) {
//    const itemId = button.getAttribute("data-itemid");
//    console.log("Item ID from buttonAAAAAAAAAAA:", itemId);
//
//    // Set the hidden input value for the upload form
//    document.getElementById('uploadHiddenItemId').value = itemId;
//
//    // Check if the hidden input is being set
//    console.log("Hidden field value set to:", document.getElementById('uploadHiddenItemId').value);
//}

document.getElementById('uploadQuotationModal').addEventListener('show.bs.modal', function () {
    // Retrieve the stored item ID from sessionStorage
    const itemId = sessionStorage.getItem('selectedItemId');
    console.log("Populating upload modal with itemID:", itemId);

    // Populate the hidden input field with the item ID
    const uploadHiddenInput = document.getElementById('uploadHiddenItemId');
    if (uploadHiddenInput) {
        uploadHiddenInput.value = itemId;
        console.log("uploadHiddenItemId value:", uploadHiddenInput.value);
    } else {
        console.error("Hidden input element not found!");
    }
});

// Remove leftover backdrops when any modal is hidden
$(document).on('hidden.bs.modal', function () {
    // Delay to allow Bootstrap to finish closing the modal
    setTimeout(function () {
        if ($('.modal.show').length === 0) {
            $('.modal-backdrop').remove();
        }
    }, 300);
});


    // Function to capture the itemID when opening the main quotations modal
    function openQuotModal(button) {
    // Extract the clicked item ID
    const itemId = button.getAttribute("data-itemid");
    console.log("Button clicked, itemID:", itemId);

    // Store the item ID in session storage
    sessionStorage.setItem('selectedItemId', itemId);

    // Make an AJAX request to fetch quotations for the selected item
    fetch('quotationdisplaycontroller?itemID=' + itemId)
        .then(response => response.text())
        .then(data => {
            // Update the modal content with the received HTML content
            document.getElementById('quotationModalContent').innerHTML = data;

            // Open the modal
            const modal = new bootstrap.Modal(document.getElementById('quotEquipmentModal'));
            modal.show();
        })
        .catch(error => console.error('Error fetching quotations:', error));
}

    

    // Function to populate the hidden input when the upload modal is shown
//    function populateUploadModal() {
//        const itemId = sessionStorage.getItem('selectedItemId');
//        console.log("Populating upload modal with itemID:", itemId);
//
//        const uploadHiddenInput = document.getElementById('uploadHiddenItemId');
//        uploadHiddenInput.value = itemId;
//        console.log("uploadHiddenItemId value:", uploadHiddenInput.value);
//    }

    // Attach the function to the modal's show event
    //document.getElementById('uploadQuotationModal').addEventListener('show.bs.modal', populateUploadModal);

    // Function to submit the form
//    function submitQuotationForm() {
//        const hiddenItemId = document.getElementById('uploadHiddenItemId').value;
//        console.log("Submitting form with itemID:", hiddenItemId);
//        // Retrieve the data-itemid attribute
//    const itemID = button.getAttribute('data-itemid');
//    
//    // Set the value of the hidden input field
//    document.getElementById('hiddenItemID').value = itemID;
//    
//    // Submit the form to quotations.jsp with the itemID
//    document.getElementById('quotForm').submit();
//
//        if (hiddenItemId) {
//            document.getElementById('uploadQuotationForm').submit();
//        } else {
//            alert("Item ID is missing!");
//        }
//    }
    </script>
</body>
</html>