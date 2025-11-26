<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=windows-1252"%>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
         <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
        <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
        <title>Reports</title>
        <style>
            .error-message {
                color: red;
                font-size: 0.875rem;
            }
            
        .montserrat-regular {
         font-family: "Montserrat", sans-serif;
         font-weight: 400;
         font-style: normal;
                            }
        
        .montserrat-bold {
         font-family: "Montserrat", sans-serif;
         font-weight: 600;
         font-style: normal;
                            }

        /* Image preview styles */
        .image-preview-container {
            position: relative;
            display: none;
            margin-top: 10px;
        }
        
        .image-preview {
            max-width: 100%;
            max-height: 200px;
            border: 2px solid #ddd;
            border-radius: 8px;
            object-fit: cover;
        }
        
        .remove-image-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 14px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .remove-image-btn:hover {
            background-color: #c82333;
        }
        
        .file-upload-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }
        
        .file-upload-label {
            display: block;
            padding: 12px;
            background-color: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .file-upload-label:hover {
            background-color: #e9ecef;
            border-color: #adb5bd;
        }
        
        .file-upload-label.has-file {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }
    
        </style>
       
    </head>
     <body class="d-flex flex-column min-vh-100" style="background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url('resources/images/ust-bg.jpg'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">
         <!-- Embedded header directly with logo and logout button -->
        <%
            // Prevent caching of header
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
        %>
        <header class="bg-facilGray p-3 d-flex justify-content-between align-items-center">
            <!-- For large devices -->
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-none d-md-block" style="max-height: 4rem;">
            <!-- For small devices -->
            <img src="resources/images/USTLogo2.png" alt="UST Logo" class="img-fluid d-md-none" style="max-height: 2rem;">
            
            <% 
                boolean isLoggedIn = session != null && session.getAttribute("email") != null;
                if (isLoggedIn) { 
            %>
                <!-- Logout Button for logged-in users -->
                <a href="<%=request.getContextPath()%>/LogoutController?source=reports" class="montserrat-regular btn btn-danger d-none d-md-block">
                     <img src="resources/images/icons/logout.svg" alt="logout" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Logout
                </a>
                <a href="<%=request.getContextPath()%>/LogoutController?source=reports" class="montserrat-regular btn btn-danger d-md-none">
                     <img src="resources/images/icons/logout.svg" alt="logout" class="icon pe-2" style="width: 2em; height: 2em; vertical-align: middle;"> Logout
                </a>
            <% } %>
        </header>
       <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
                <div class="card">
                    <div class="card-body ">
                <img src="resources/images/FACILITAIN_WLOGO2.png" 
     alt="FACILITAIN" 
     class="img-fluid mb-4 d-block mx-auto" 
     style="max-height: 5rem;">
                <h3 class="text-center montserrat-bold">Report a Problem</h3>
                 <!-- Form Starts Here -->
               <form action="reportsClient" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
    
            <!-- Location -->
            <label for="location">Location <span style="color: red;"> *</span></label>
            <div class="mt-1">
                <select name="location" id="location" class="form-control w-100" onchange="loadFloors()" required>
                    <option value="">Select a location</option>
                    <c:forEach var="location" items="${locationList}">
                        <option value="${location.key}">${location.value}</option>
                    </c:forEach>
                </select>
                <div id="locationError" class="error-message"></div>
            </div>
        
            <!-- Floor -->
            <label for="floor" class="mt-2">Floor <span style="color: red;"> *</span></label>
            <div class="mt-1">
                <select name="floor" id="floor" class="form-control w-100" onchange="loadRooms()" required disabled>
                    <option value="">Select a floor</option>
                </select>
                <div id="floorError" class="error-message"></div>
            </div>
        
            <!-- Room -->
            <label for="room" class="mt-2">Room <span style="color: red;"> *</span></label>
            <div class="mt-1">
                <select name="room" id="room" class="form-control w-100" required disabled>
                    <option value="">Select a room</option>
                </select>
                <div id="roomError" class="error-message"></div>
            </div>
        
            <!-- Equipment -->
            <label for="equipment" class="mt-2">Type of Equipment<span style="color: red;"> *</span></label>
            <div class="mt-1">
                <select name="equipment" id="equipment" class="form-control w-100" onchange="toggleOtherOption()" required disabled>
                    <option value="">Select a floor first</option>
                </select>
                <div id="equipmentError" class="error-message"></div>
        
                <!-- Input field for "Other" option -->
                <div id="otherEquipmentDiv" style="display:none;">
                    <label for="otherEquipment" class="mt-2">Please specify: <span style="color: red;"> *</span></label>
                    <input type="text" id="otherEquipment" name="otherEquipment" class="form-control w-100" />
                </div>
            </div>
            
            <!-- Email field removed since it's now taken from session -->
            <% if (session.getAttribute("email") != null) { %>
            <div class="alert alert-info mt-3">
                <small>Your report will be linked to your email: <strong>${sessionScope.email}</strong></small>
            </div>
            <% } %>
        
            <!-- Issue Description -->
            <label for="issue" class="d-block mt-3 mb-3">Describe Issue <span style="color: red;"> *</span></label>
            <div class="mt-1">
                <textarea id="issue" name="issue" rows="4" cols="50" class="d-block p-3 w-100 mx-auto rounded border" 
                style="width: 100%;" placeholder="Explain the issue here..." maxlength="500" required></textarea>
                <div id="issueError" class="text-danger"></div>
                <div id="issueCount" class="text-muted" style="font-size: 12px; text-align: right;">
                    0 / 500 characters
                </div>
            </div>
        
            <!-- Image Upload -->
            <label for="imageUpload" class="d-block mt-3 mb-2">Upload an Image <span style="color: red;"> *</span></label>
            
            <!-- File Upload with Custom Styling -->
            <div class="file-upload-wrapper">
                <input type="file" name="imageUpload" id="imageUpload" class="form-control" accept="image/*" style="display: none;" onchange="handleImageSelect(event)">
                <label for="imageUpload" class="file-upload-label" id="fileUploadLabel">
                    <i class="bi bi-cloud-upload"></i>
                    <div class="mt-1">Click to select an image</div>
                    <small class="text-muted">Supports JPG, PNG, GIF (Max 5MB)</small>
                </label>
            </div>
            
            <!-- Image Preview Container -->
            <div class="image-preview-container" id="imagePreviewContainer">
                <img id="imagePreview" class="image-preview" alt="Image Preview">
                <button type="button" class="remove-image-btn" onclick="removeImage()" title="Remove image">
                    <i class="bi bi-x"></i>
                </button>
            </div>
            
            <div id="imageUploadError" class="error-message"></div>
        
            <!-- Submit Button -->
            <div class="container mt-3 px-0">
                <button type="submit" 
                 class="btn w-100" 
                style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
                 onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';">
                <strong>Submit</strong>
                </button>
            </div>

</form>

            
            </div>
            </div>
            </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
         // Function to toggle 'Other' option visibility
        function toggleOtherOption() {
            const equipmentSelect = document.getElementById("equipment");
            const otherEquipmentDiv = document.getElementById("otherEquipmentDiv");
            const selectedValue = equipmentSelect.value;

            if (selectedValue === "Other") {
                otherEquipmentDiv.style.display = "block";
                document.getElementById("otherEquipment").setAttribute("required", "true");
            } else {
                otherEquipmentDiv.style.display = "none";
                document.getElementById("otherEquipment").removeAttribute("required");
            }
        }
        
             // Function to load floors based on selected location
           function loadFloors() {
            const locationId = document.getElementById("location").value;
            const floorSelect = document.getElementById("floor");
            const roomSelect = document.getElementById("room");
            const equipmentSelect = document.getElementById("equipment");
            
            // Reset all dependent dropdowns
            floorSelect.innerHTML = '<option value="" disabled selected>Select a floor</option>';
            floorSelect.disabled = true;
            roomSelect.innerHTML = '<option value="" disabled selected>Select a room</option>';
            roomSelect.disabled = true;
            
            // Reset equipment dropdown (will load after floor selection)
            equipmentSelect.innerHTML = '<option value="" disabled selected>Select a floor first</option>';
            equipmentSelect.disabled = true;
            
            // Hide "Other" input if visible
            document.getElementById("otherEquipmentDiv").style.display = "none";
            document.getElementById("otherEquipment").removeAttribute("required");
            
            if (locationId) {
                // Make AJAX call to get floors
                fetch('reportsClient?action=getFloors&locationId=' + locationId)
                    .then(response => response.json())
                    .then(floors => {
                        floorSelect.innerHTML = '<option value="" disabled selected>Select a floor</option>';
                        
                        if (floors && floors.length > 0) {
                            floors.forEach(floor => {
                                const option = document.createElement('option');
                                option.value = floor;
                                option.textContent = floor;
                                floorSelect.appendChild(option);
                            });
                            floorSelect.disabled = false;
                        } else {
                            const option = document.createElement('option');
                            option.value = 'N/A';
                            option.textContent = 'No specific floor (General area)';
                            floorSelect.appendChild(option);
                            floorSelect.disabled = false;
                            floorSelect.value = 'N/A';
                            
                            // Load equipment for N/A floor
                            loadEquipment();
                            
                            // Load rooms for no floor
                            loadRoomsForNoFloor(locationId);
                        }
                    })
                    .catch(error => {
                        console.error('Error loading floors:', error);
                        floorSelect.innerHTML = '<option value="">Error loading floors</option>';
                    });
            }
}
            
            function loadEquipment() {
                const locationId = document.getElementById("location").value;
                const floorNo = document.getElementById("floor").value;
                const equipmentSelect = document.getElementById("equipment");
                
                // Reset equipment dropdown
                equipmentSelect.innerHTML = '<option value="" disabled selected>Loading equipment...</option>';
                equipmentSelect.disabled = true;
                
                // Hide "Other" input if visible
                document.getElementById("otherEquipmentDiv").style.display = "none";
                document.getElementById("otherEquipment").removeAttribute("required");
                
                if (locationId && floorNo) {
                    // Make AJAX call to get equipment types for this location and floor
                    fetch('reportsClient?action=getEquipment&locationId=' + locationId + '&floorNo=' + encodeURIComponent(floorNo))
                        .then(response => response.json())
                        .then(equipmentTypes => {
                            equipmentSelect.innerHTML = '<option value="" disabled selected>Select equipment type</option>';
                            
                            if (equipmentTypes && equipmentTypes.length > 0) {
                                equipmentTypes.forEach(equipment => {
                                    const option = document.createElement('option');
                                    option.value = equipment;
                                    option.textContent = equipment;
                                    equipmentSelect.appendChild(option);
                                });
                                
                                // Always add "Other" option at the end
                                const otherOption = document.createElement('option');
                                otherOption.value = 'Other';
                                otherOption.textContent = 'OTHER';
                                equipmentSelect.appendChild(otherOption);
                                
                                equipmentSelect.disabled = false;
                            } else {
                                // No equipment found for this location and floor - only show "Other"
                                const otherOption = document.createElement('option');
                                otherOption.value = 'Other';
                                otherOption.textContent = 'OTHER (No equipment registered for this floor)';
                                equipmentSelect.appendChild(otherOption);
                                equipmentSelect.disabled = false;
                            }
                        })
                        .catch(error => {
                            console.error('Error loading equipment:', error);
                            equipmentSelect.innerHTML = '<option value="">Error loading equipment</option>';
                        });
                }
            }
            // Function to load rooms for locations that don't have floors
            function loadRoomsForNoFloor(locationId) {
                const roomSelect = document.getElementById("room");
                
                // For locations without floors, we still try to load rooms
                fetch('reportsClient?action=getRooms&locationId=' + locationId + '&floorNo=N/A')
                    .then(response => response.json())
                    .then(rooms => {
                        roomSelect.innerHTML = '<option value="" disabled selected>Select a room</option>';
                        
                        if (rooms && rooms.length > 0) {
                            rooms.forEach(room => {
                                const option = document.createElement('option');
                                option.value = room;
                                option.textContent = room;
                                roomSelect.appendChild(option);
                            });
                            roomSelect.disabled = false;
                        } else {
                            // No rooms either - add N/A option
                            const option = document.createElement('option');
                            option.value = 'N/A';
                            option.textContent = 'No specific room (General area)';
                            roomSelect.appendChild(option);
                            roomSelect.disabled = false;
                            roomSelect.value = 'N/A';
                        }
                    })
                    .catch(error => {
                        console.error('Error loading rooms:', error);
                        // On error, default to N/A
                        roomSelect.innerHTML = '<option value="N/A">No specific room (General area)</option>';
                        roomSelect.disabled = false;
                        roomSelect.value = 'N/A';
                    });
            }
            
            // Function to load rooms based on selected location and floor
            function loadRooms() {
    const locationId = document.getElementById("location").value;
    const floorNo = document.getElementById("floor").value;
    const roomSelect = document.getElementById("room");
    
    // Reset room dropdown
    roomSelect.innerHTML = '<option value="" disabled selected>Select a room</option>';
    roomSelect.disabled = true;
    
    // Load equipment for the selected floor
    loadEquipment();
    
    // Don't load rooms if floor is N/A (already handled in loadFloors)
    if (floorNo === 'N/A') {
        return;
    }
    
    if (locationId && floorNo) {
        // Make AJAX call to get rooms
        fetch('reportsClient?action=getRooms&locationId=' + locationId + '&floorNo=' + encodeURIComponent(floorNo))
            .then(response => response.json())
            .then(rooms => {
                roomSelect.innerHTML = '<option value="" disabled selected>Select a room</option>';
                
                if (rooms && rooms.length > 0) {
                    rooms.forEach(room => {
                        const option = document.createElement('option');
                        option.value = room;
                        option.textContent = room;
                        roomSelect.appendChild(option);
                    });
                    roomSelect.disabled = false;
                } else {
                    const option = document.createElement('option');
                    option.value = 'N/A';
                    option.textContent = 'No specific room (General floor area)';
                    roomSelect.appendChild(option);
                    roomSelect.disabled = false;
                    roomSelect.value = 'N/A';
                }
            })
            .catch(error => {
                console.error('Error loading rooms:', error);
                roomSelect.innerHTML = '<option value="">Error loading rooms</option>';
            });
    }
}

        
        function updateCharCount() {
            const issueField = document.getElementById('issue');
            const issueCount = document.getElementById('issueCount');
            const maxLength = issueField.getAttribute('maxlength');
            const currentLength = issueField.value.length;

            issueCount.textContent = `${currentLength}/${maxLength} characters`;
        }

        // Add event listener to issue textarea for character counting
        document.getElementById('issue').addEventListener('input', updateCharCount);

        // Image preview functions
        function handleImageSelect(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('imagePreviewContainer');
            const preview = document.getElementById('imagePreview');
            const label = document.getElementById('fileUploadLabel');
            const errorDiv = document.getElementById('imageUploadError');
            
            // Clear any previous error messages
            errorDiv.textContent = '';
            
            if (file) {
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    errorDiv.textContent = 'Only image files are allowed.';
                    resetImageUpload();
                    return;
                }
                
                // Validate file size (5MB = 5 * 1024 * 1024 bytes)
                if (file.size > 5 * 1024 * 1024) {
                    errorDiv.textContent = 'Image size must be below 5MB.';
                    resetImageUpload();
                    return;
                }
                
                // Create image preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    previewContainer.style.display = 'block';
                    
                    // Update label appearance
                    label.classList.add('has-file');
                    label.innerHTML = `
                        <i class="bi bi-check-circle-fill text-success"></i>
                        <div class="mt-1">Image selected: ${file.name}</div>
                        <small class="text-success">Click to change image</small>
                    `;
                };
                reader.readAsDataURL(file);
            } else {
                resetImageUpload();
            }
        }
        
        function removeImage() {
            document.getElementById('imageUpload').value = '';
            resetImageUpload();
        }
        
        function resetImageUpload() {
            const previewContainer = document.getElementById('imagePreviewContainer');
            const preview = document.getElementById('imagePreview');
            const label = document.getElementById('fileUploadLabel');
            
            // Hide preview
            previewContainer.style.display = 'none';
            preview.src = '';
            
            // Reset label
            label.classList.remove('has-file');
            label.innerHTML = `
                <i class="bi bi-cloud-upload"></i>
                <div class="mt-1">Click to select an image</div>
                <small class="text-muted">Supports JPG, PNG, GIF (Max 5MB)</small>
            `;
        }

</script>
            <script>
           function validateForm() {
    let valid = true;

    // Clear previous error messages
    document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
    
    // Validate equipment
    const equipment = document.getElementById('equipment').value;
    if (!equipment) {
        document.getElementById('equipmentError').textContent = 'Please select an equipment type.';
        valid = false;
    }
    
    // Validate "Other" equipment if selected
    if (equipment === 'Other') {
        const otherEquipment = document.getElementById('otherEquipment').value.trim();
        if (!otherEquipment) {
            document.getElementById('equipmentError').textContent = 'Please specify the equipment type.';
            valid = false;
        }
    }
    
    // Validate location
    const location = document.getElementById('location').value;
    if (!location) {
        document.getElementById('locationError').textContent = 'Please select a location.';
        valid = false;
    }
    
    // Validate floor
    const floor = document.getElementById('floor').value;
    if (!floor) {
        document.getElementById('floorError').textContent = 'Please select a floor.';
        valid = false;
    }
    
    // Validate room
    const room = document.getElementById('room').value;
    if (!room) {
        document.getElementById('roomError').textContent = 'Please select a room.';
        valid = false;
    }
    
    // Validate issue description
    const issueTextarea = document.getElementById('issue');
    const issueError = document.getElementById('issueError');
    const currentLength = issueTextarea.value.trim().length;

    if (currentLength === 0) {
        issueError.textContent = 'Please describe the issue.';
        valid = false;
    } else if (currentLength > 500) {
        issueError.textContent = 'Issue description cannot exceed 500 characters.';
        valid = false;
    }
    
    // Validate image upload
    const imageUpload = document.getElementById('imageUpload').files[0];
    const imageError = document.getElementById('imageUploadError');
    
    if (!imageUpload) {
        imageError.textContent = 'Please upload an image of the issue.';
        valid = false;
        // Scroll to the image upload section so user can see the error
        document.getElementById('imageUpload').scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else if (!imageUpload.type.startsWith('image/')) {
        imageError.textContent = 'Only image files are allowed.';
        valid = false;
    } else if (imageUpload.size > 5 * 1024 * 1024) {
        imageError.textContent = 'Image size must be below 5MB.';
        valid = false;
    }

    return valid;
}

        const issueTextarea = document.getElementById('issue');
        const issueCount = document.getElementById('issueCount');
        const issueError = document.getElementById('issueError');

        // Update character count and validate input on input event
        issueTextarea.addEventListener('input', function() {
            const currentLength = issueTextarea.value.length;

            // Update the character count
            issueCount.textContent = currentLength + " / 500 characters";

            // Validate the issue length
            if (currentLength > 500) {
                issueError.textContent = 'Issue description cannot exceed 500 characters.';
            } else {
                issueError.textContent = ''; // Clear the error message
            }
        });

        </script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>