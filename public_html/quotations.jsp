<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="sample.model.Quotation" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style>       
        body, h1, h2, h3, h4,h5, th {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h6, input, textarea, td, tr, p, label, select, option {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        
        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.2) !important; 
        }
    
        .modal-backdrop.show {
            opacity: 1 !important;
        }
       
        .hover-outline {
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }
        .hover-outline:hover {
            background-color: #1C1C1C !important;
            color: #f2f2f2 !important;
            border: 1px solid #f2f2f2 !important;
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
        
        .file-upload-container {
            border: 2px dashed #ccc;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            margin-bottom: 15px;
            transition: border-color 0.3s ease;
        }
        
        .file-upload-container:hover {
            border-color: #007bff;
        }
        
        .file-upload-container.dragover {
            border-color: #28a745;
            background-color: #f8f9fa;
        }
        
        .file-upload-container.error {
            border-color: #dc3545;
            background-color: #fff5f5;
        }
        
        .file-preview-ellipsis {
            max-width: 100%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            display: block;
        }

        
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        .character-counter {
            font-size: 0.875rem;
            color: #6c757d;
            text-align: right;
            margin-top: 5px;
            font-family: 'NeueHaasLight', sans-serif !important;
        }
        .character-counter.warning {
            color: #ffc107;
        }
        .character-counter.danger {
            color: #dc3545;
        }
        
        .file-upload-container small {
        font-family: 'NeueHaasLight', sans-serif !important;
        }
        .form-control.invalid {
            border-color: #dc3545;
        }
        .buttonsBuilding {
            font-family: 'NeueHaasMedium', sans-serif !important;
            border: none;
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
        }
        
        body.modal-open {
            overflow: hidden;
        }
        
        .modal-content {
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            border: none;
        }
        
        .description-cell {
            max-width: 250px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .description-text {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            flex: 1;
        }
        
        .description-btn {
            border: none;
            background-color: transparent;
            color: #6c757d;
            padding: 0;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;  
        }
        
        .description-btn:hover {
            color: #495057;  
            transform: scale(1.1); 
        }
        
        .description-btn:active {
            transform: scale(0.95);  
        }
        
        @media (max-width: 768px) {
            .description-cell {
                max-width: 150px;
            }
            .description-text {
                max-width: 100px;
            }
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
   <!-- Main Quotations Modal -->
<div class="modal fade" id="quotEquipmentModal" tabindex="-1" aria-labelledby="equipmentquot" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg" role="document">
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
                    <button type="button" style="background-color: #fccc4c;" class="buttonsBuilding px-3 py-2 rounded-1 hover-outline d-flex align-items-center mb-3" data-bs-toggle="modal" data-bs-target="#uploadQuotationModal">
                         <img src="resources/images/icons/upload.svg" class="pe-2" alt="upload icon" width="25" height="25">
                        Upload Quotation
                    </button>

                    <!-- Quotations Table -->
                    <div class="table-responsive">
                        <table id="quotationsTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Description</th>
                                    <th>Date Uploaded</th>
                                    <th>Files</th>
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
</div>

<!-- Upload Quotation Modal -->
<div class="modal fade" id="uploadQuotationModal" tabindex="-1" aria-labelledby="uploadQuotationLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <form id="uploadQuotationForm" method="post" enctype="multipart/form-data" action="quotationcontroller">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBuildingModalLabel" style="font-family: 'NeueHaasMedium', sans-serif;">Upload Quotation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <input type="hidden" name="locID" value="${locID}">
                <input type="hidden" name="floorName" value="${floorName}">
                <input type="hidden" name="itemID" id="uploadHiddenItemId">
                
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="quotationDescription" class="form-label">Quotation Description <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="description" id="quotationDescription" rows="3" maxlength="255" required></textarea>
                        <div class="character-counter" id="characterCounter">0 / 255 characters</div>
                    </div>
                    
                    <!-- File Upload Section -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="file-upload-container" id="fileContainer1">
                                <label for="quotationFile1" class="form-label">Upload File 1 <span class="text-danger">*</span></label>
                                <input class="form-control" type="file" name="quotationFile1" id="quotationFile1" 
                                       accept=".pdf,.jpg,.jpeg,.png,.gif,.bmp,.tiff">
                                <small class="text-muted">Max size: 10MB. Supported: PDF, Images</small>
                                <div class="error-message" id="file1Error">Please upload at least one file</div>
                                <div id="file1Preview" class="mt-2"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="file-upload-container" id="fileContainer2">
                                <label for="quotationFile2" class="form-label">Upload File 2 (Optional)</label>
                                <input class="form-control" type="file" name="quotationFile2" id="quotationFile2" 
                                       accept=".pdf,.jpg,.jpeg,.png,.gif,.bmp,.tiff">
                                <small class="text-muted">Max size: 10MB. Supported: PDF, Images</small>
                                <div class="error-message" id="file2Error">File size exceeds 10MB</div>
                                <div id="file2Preview" class="mt-2"></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger" id="cancelUploadBtn" style="font-family: 'NeueHaasMedium', sans-serif;">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-success" onclick="submitQuotationForm()" style="font-family: 'NeueHaasMedium', sans-serif;">
                        Upload
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // File size validation (10MB)
    const MAX_FILE_SIZE = 10 * 1024 * 1024;
    const MAX_DESCRIPTION_LENGTH = 255;
    
    // Character counter functionality
    function setupCharacterCounter() {
        var textarea = document.getElementById('quotationDescription');
        var counter = document.getElementById('characterCounter');
        
        if (!textarea || !counter) return;
        
        textarea.addEventListener('input', function() {
            var currentLength = textarea.value.length;
            counter.textContent = currentLength + ' / ' + MAX_DESCRIPTION_LENGTH + ' characters';
            
            counter.classList.remove('warning', 'danger');
            textarea.classList.remove('invalid');
            
            if (currentLength > MAX_DESCRIPTION_LENGTH) {
                counter.classList.add('danger');
                textarea.classList.add('invalid');
            } else if (currentLength > MAX_DESCRIPTION_LENGTH * 0.8) {
                counter.classList.add('warning');
            }
        });
    }
    
    // Enhanced file validation
    function validateFile(file, inputId, errorId, containerId) {
        const errorElement = document.getElementById(errorId);
        const container = document.getElementById(containerId);
        
        if (!errorElement || !container) return true;
        
        // Clear previous errors
        errorElement.classList.remove('show');
        container.classList.remove('error');
        
        if (!file) {
            return true; // No file is okay for optional fields
        }
        
        // Validate file size
        if (file.size > MAX_FILE_SIZE) {
            errorElement.textContent = 'File size exceeds 10MB limit';
            errorElement.classList.add('show');
            container.classList.add('error');
            return false;
        }
        
        return true;
    }
    
    // File preview and validation
    function setupFileInput(inputId, previewId, errorId, containerId) {
        const input = document.getElementById(inputId);
        const preview = document.getElementById(previewId);
        
        if (!input || !preview) return;
        
        input.addEventListener('change', function(e) {
            const file = e.target.files[0];
            preview.innerHTML = '';
            
            if (file) {
                // Validate file
                if (!validateFile(file, inputId, errorId, containerId)) {
                    input.value = '';
                    return;
                }
                
                // Show file info
                const fileInfo = document.createElement('div');
                fileInfo.className = 'alert alert-info';
                fileInfo.innerHTML = 
    '<strong>Selected:</strong> <span class="file-preview-ellipsis">' + file.name + '</span>' +
    '<br><strong>Size:</strong> ' + (file.size / 1024 / 1024).toFixed(2) + ' MB';
                preview.appendChild(fileInfo);
                
                // Show preview for images
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'img-thumbnail mt-2';
                        img.style.maxHeight = '100px';
                        preview.appendChild(img);
                    };
                    reader.readAsDataURL(file);
                }
            }
        });
    }
    
    // Drag and drop functionality
    function setupDragDrop(containerId, inputId) {
        const container = document.getElementById(containerId);
        const input = document.getElementById(inputId);
        
        if (!container || !input) return;
        
        container.addEventListener('dragover', function(e) {
            e.preventDefault();
            container.classList.add('dragover');
        });
        
        container.addEventListener('dragleave', function(e) {
            e.preventDefault();
            container.classList.remove('dragover');
        });
        
        container.addEventListener('drop', function(e) {
            e.preventDefault();
            container.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                input.files = files;
                input.dispatchEvent(new Event('change'));
            }
        });
    }
    
    // Enhanced form submission with better validation
    function submitQuotationForm() {
        const hiddenItemId = document.getElementById('uploadHiddenItemId').value;
        const description = document.getElementById('quotationDescription').value.trim();
        const file1 = document.getElementById('quotationFile1').files[0];
        const file2 = document.getElementById('quotationFile2').files[0];
        
        console.log("Submitting form with itemID:", hiddenItemId);
        
        // Clear all previous errors
        document.getElementById('file1Error').classList.remove('show');
        document.getElementById('file2Error').classList.remove('show');
        document.getElementById('fileContainer1').classList.remove('error');
        document.getElementById('fileContainer2').classList.remove('error');
        
        // Validate description
        if (!description) {
            Swal.fire({
                title: 'Missing Description',
                text: 'Please enter a quotation description',
                icon: 'warning'
            });
            document.getElementById('quotationDescription').focus();
            return;
        }
        
        if (description.length > MAX_DESCRIPTION_LENGTH) {
            Swal.fire({
                title: 'Description Too Long',
                text: 'Description must be ' + MAX_DESCRIPTION_LENGTH + ' characters or less. Current length: ' + description.length,
                icon: 'warning'
            });
            document.getElementById('quotationDescription').focus();
            return;
        }
        
        // Validate that at least one file is uploaded
        if (!file1 && !file2) {
            document.getElementById('file1Error').textContent = 'At least one file must be uploaded';
            document.getElementById('file1Error').classList.add('show');
            document.getElementById('fileContainer1').classList.add('error');
            
            Swal.fire({
                title: 'No File Uploaded',
                text: 'Please upload at least one file',
                icon: 'warning'
            });
            return;
        }
        
        // Validate file sizes
        if (file1 && !validateFile(file1, 'quotationFile1', 'file1Error', 'fileContainer1')) {
            Swal.fire({
                title: 'File Too Large',
                text: 'File 1 size must be less than 10MB',
                icon: 'error'
            });
            return;
        }
        
        if (file2 && !validateFile(file2, 'quotationFile2', 'file2Error', 'fileContainer2')) {
            Swal.fire({
                title: 'File Too Large',
                text: 'File 2 size must be less than 10MB',
                icon: 'error'
            });
            return;
        }
        
        // Show loading
        Swal.fire({
            title: 'Uploading...',
            text: 'Please wait while your quotation is being saved',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
        
        // Submit the form
        document.getElementById('uploadQuotationForm').submit();
    }

    // Cancel button functionality - close upload modal and reopen quotation list
    const cancelBtn = document.getElementById('cancelUploadBtn');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            // Close the upload modal
            const uploadModal = bootstrap.Modal.getInstance(document.getElementById('uploadQuotationModal'));
            if (uploadModal) {
                uploadModal.hide();
            }
            
            // Wait for the modal to fully close, then reopen the quotation list modal
            document.getElementById('uploadQuotationModal').addEventListener('hidden.bs.modal', function reopenQuotList() {
                // Remove this event listener after it fires once
                document.getElementById('uploadQuotationModal').removeEventListener('hidden.bs.modal', reopenQuotList);
                
                // Reopen the quotation list modal
                const quotModal = new bootstrap.Modal(document.getElementById('quotEquipmentModal'));
                quotModal.show();
            });
        });
    }

    // Event listener to populate the hidden input field when the modal is shown
    document.getElementById('uploadQuotationModal').addEventListener('show.bs.modal', function () {
        const itemId = sessionStorage.getItem('selectedItemId');
        console.log("Populating upload modal with itemID:", itemId);
        
        const uploadHiddenInput = document.getElementById('uploadHiddenItemId');
        if (uploadHiddenInput) {
            uploadHiddenInput.value = itemId;
            console.log("uploadHiddenItemId value:", uploadHiddenInput.value);
        } else {
            console.error("Hidden input element not found!");
        }
        
        // Clear previous form data and errors
        const textarea = document.getElementById('quotationDescription');
        if (textarea) textarea.value = '';
        
        const file1 = document.getElementById('quotationFile1');
        const file2 = document.getElementById('quotationFile2');
        if (file1) file1.value = '';
        if (file2) file2.value = '';
        
        const file1Preview = document.getElementById('file1Preview');
        const file2Preview = document.getElementById('file2Preview');
        if (file1Preview) file1Preview.innerHTML = '';
        if (file2Preview) file2Preview.innerHTML = '';
        
        // Clear error states
        document.getElementById('file1Error').classList.remove('show');
        document.getElementById('file2Error').classList.remove('show');
        document.getElementById('fileContainer1').classList.remove('error');
        document.getElementById('fileContainer2').classList.remove('error');
        
        // Reset character counter
        const counter = document.getElementById('characterCounter');
        if (counter) {
            counter.textContent = '0 / 255 characters';
            counter.classList.remove('warning', 'danger');
        }
        if (textarea) textarea.classList.remove('invalid');
    });

    // Handle modal backdrop cleanup
    $(document).on('hidden.bs.modal', function () {
        setTimeout(function () {
            if ($('.modal.show').length === 0) {
                $('.modal-backdrop').remove();
            }
        }, 300);
    });

    // Initialize DataTable only once
    $(document).ready(function() {
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

    // Initialize popovers for description buttons
    function initializeDescriptionPopovers() {
        console.log('Initializing description popovers...');
        
        // Destroy any existing popovers first
        const existingPopovers = document.querySelectorAll('[data-bs-toggle="popover"]');
        existingPopovers.forEach(function(el) {
            const existingPopover = bootstrap.Popover.getInstance(el);
            if (existingPopover) {
                existingPopover.dispose();
            }
        });
        
        // Initialize new popovers
        const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
        console.log('Found ' + popoverTriggerList.length + ' popover triggers');
        
        const popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
            return new bootstrap.Popover(popoverTriggerEl, {
                trigger: 'click',
                html: true,
                customClass: 'description-popover'
            });
        });
        
        // Show ellipsis button only if text is truncated
        const descriptionTexts = document.querySelectorAll('.description-text');
        descriptionTexts.forEach(function(textEl) {
            const button = textEl.nextElementSibling;
            if (button && button.classList.contains('description-btn')) {
                if (textEl.scrollWidth > textEl.clientWidth) {
                    button.style.display = 'inline-block';
                } else {
                    button.style.display = 'none';
                }
            }
        });
    }

    // Close popover when clicking outside
    document.addEventListener('click', function(event) {
        const popovers = document.querySelectorAll('[data-bs-toggle="popover"]');
        popovers.forEach(function(trigger) {
            const popoverInstance = bootstrap.Popover.getInstance(trigger);
            if (popoverInstance && 
                !trigger.contains(event.target) && 
                !document.querySelector('.popover')?.contains(event.target)) {
                popoverInstance.hide();
            }
        });
    });

    // Function to reload quotations in modal
    function reloadQuotations(itemId) {
        console.log('Reloading quotations for item:', itemId);
        
        fetch('quotationdisplaycontroller?itemID=' + itemId)
            .then(response => response.text())
            .then(data => {
                console.log('Quotation data received, updating modal content...');
                document.getElementById('quotationModalContent').innerHTML = data;
                
                // Re-initialize popovers after content loads
                setTimeout(() => {
                    console.log('Calling initializeDescriptionPopovers after reload...');
                    initializeDescriptionPopovers();
                }, 200);
            })
            .catch(error => console.error('Error fetching quotations:', error));
    }

    // Function to capture the itemID when opening the main quotations modal
    function openQuotModal(button) {
        // Extract the clicked item ID
        const itemId = button.getAttribute("data-itemid");
        console.log("Button clicked, itemID:", itemId);

        // Store the item ID in session storage
        sessionStorage.setItem('selectedItemId', itemId);

        // Make an AJAX request to fetch quotations
        fetch('quotationdisplaycontroller?itemID=' + itemId)
            .then(response => response.text())
            .then(data => {
                console.log('Quotation data received, updating modal content...');
                document.getElementById('quotationModalContent').innerHTML = data;

                // Re-initialize popovers after content loads
                setTimeout(() => {
                    console.log('Calling initializeDescriptionPopovers after timeout...');
                    initializeDescriptionPopovers();
                }, 200);

                // Open the modal
                const modal = new bootstrap.Modal(document.getElementById('quotEquipmentModal'));
                modal.show();
            })
            .catch(error => console.error('Error fetching quotations:', error));
    }
    
    // Fixed archive confirmation function with AJAX
// Archive confirmation function with AJAX
function confirmArchive(quotationId) {
    console.log('Archive button clicked for quotation ID:', quotationId);
    
    Swal.fire({
        title: 'Are you sure?',
        text: "This action will archive the selected quotation.",
        icon: 'warning',
        showCancelButton: true,
        reverseButtons: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, archive it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Archiving...',
                text: 'Please wait while we archive the quotation.',
                allowOutsideClick: false,
                showConfirmButton: false,
                willOpen: () => {
                    Swal.showLoading();
                }
            });
            
            // Get current item ID from session storage
            const itemId = sessionStorage.getItem('selectedItemId');
            
            console.log('Sending archive request for quotation ID:', quotationId);
            
            // Use URLSearchParams instead of FormData for better compatibility
            const params = new URLSearchParams();
            params.append('quotationId', quotationId);
            
            console.log('Request params:', params.toString());
            
            fetch('quotationdisplaycontroller', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(response => {
                console.log('Archive response status:', response.status);
                if (response.ok) {
                    // Show success message
                    Swal.fire({
                        title: 'Archived!',
                        text: 'Quotation has been archived successfully.',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then(() => {
                        // Reload quotations without closing modal
                        reloadQuotations(itemId);
                    });
                } else {
                    return response.text().then(text => {
                        throw new Error(text || 'Archive failed');
                    });
                }
            })
            .catch(error => {
                console.error('Error archiving quotation:', error);
                Swal.fire({
                    title: 'Error!',
                    text: error.message || 'An error occurred while archiving the quotation.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            });
        }
    });
}
    
    // Check for upload results on page load and auto-open modal
    function checkUploadResults() {
        const urlParams = new URLSearchParams(window.location.search);
        const uploadResult = urlParams.get('uploadResult');
        const uploadMessage = urlParams.get('uploadMessage');
        const itemID = urlParams.get('itemID');
        
        if (uploadResult && itemID) {
            // Store item ID in session storage
            sessionStorage.setItem('selectedItemId', itemID);
            
            if (uploadResult === 'success') {
                Swal.fire({
                    title: 'Success!',
                    text: uploadMessage || 'Quotation uploaded successfully!',
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then(() => {
                    // Auto-open the quotation modal for the item
                    const itemId = sessionStorage.getItem('selectedItemId');
                    if (itemId) {
                        fetch('quotationdisplaycontroller?itemID=' + itemId)
                            .then(response => response.text())
                            .then(data => {
                                document.getElementById('quotationModalContent').innerHTML = data;
                                setTimeout(() => {
                                    initializeDescriptionPopovers();
                                }, 200);
                                const modal = new bootstrap.Modal(document.getElementById('quotEquipmentModal'));
                                modal.show();
                            })
                            .catch(error => console.error('Error fetching quotations:', error));
                    }
                    
                    // Clean URL
                    const cleanUrl = window.location.pathname + window.location.search
                        .replace(/[?&](uploadResult|uploadMessage|itemID)=[^&]*/g, '')
                        .replace(/^&/, '?').replace(/&&/g, '&').replace(/\?$/, '');
                    window.history.replaceState({}, document.title, cleanUrl);
                });
            } else {
                Swal.fire({
                    title: 'Error!',
                    text: uploadMessage || 'Failed to upload quotation.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                }).then(() => {
                    // Clean URL
                    const cleanUrl = window.location.pathname + window.location.search
                        .replace(/[?&](uploadResult|uploadMessage|itemID)=[^&]*/g, '')
                        .replace(/^&/, '?').replace(/&&/g, '&').replace(/\?$/, '');
                    window.history.replaceState({}, document.title, cleanUrl);
                });
            }
        }
    }

    // Initialize everything on DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded - initializing components');
        setupFileInput('quotationFile1', 'file1Preview', 'file1Error', 'fileContainer1');
        setupFileInput('quotationFile2', 'file2Preview', 'file2Error', 'fileContainer2');
        setupCharacterCounter();
        setupDragDrop('fileContainer1', 'quotationFile1');
        setupDragDrop('fileContainer2', 'quotationFile2');
        
        // Check for upload results
        checkUploadResults();
    });
</script>
</body>
</html>