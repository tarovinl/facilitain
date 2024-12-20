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
    
        </style>
      
    </head>
     <body class="d-flex flex-column min-vh-100" style="background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url('resources/images/ust-bg.jpg'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">
        <jsp:include page="headerClient.jsp"/>
       <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
                <div class="card">
                    <div class="card-body ">
                <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4 d-block mx-auto" style="max-height: 4rem;">
                <h3 class="text-center montserrat-bold">Report a Problem</h3>

                <!-- Form Starts Here -->
                <form action="reportsClient" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
                    <!-- Equipment -->
                   <label for="equipment">Type of Equipment</label>
<div class="mt-1">
    <select name="equipment" id="equipment" class="form-control w-100" onchange="toggleOtherOption()">
        <option value="">Select equipment type</option>
        <c:forEach var="equipment" items="${equipmentList}">
            <option value="${equipment.key}">${equipment.value}</option>
        </c:forEach>
        <option value="Other">Other</option>
    </select>
    <div id="equipmentError" class="error-message"></div>

    <!-- Input field for "Other" option -->
    <div id="otherEquipmentDiv" style="display:none;">
        <label for="otherEquipment">Please specify:</label>
        <input type="text" id="otherEquipment" name="otherEquipment" class="form-control w-100" />
    </div>
</div>


                    <!-- Location -->
                    <label for="location" class="mt-2">Location</label>
                    <div class="mt-1">
                        <select name="location" id="location" class="form-control w-100">
                            <option value="">Select a location</option>
                            <c:forEach var="location" items="${locationList}">
                                <option value="${location.key}">${location.value}</option>
                            </c:forEach>
                        </select>
                        <div id="locationError" class="error-message"></div>
                    </div>

                    <!-- Floor -->
                    <label for="floor"class="mt-2">Floor</label>
                    <div class="mt-1">
                        <input type="text" name="floor" id="floor" class="form-control w-100" placeholder="Enter floor">
                        <div id="floorError" class="error-message"></div>
                    </div>

             
                    <label for="room"class="mt-2">Room</label>
                    <div class="mt-1">
                        <input type="text" name="room" id="room" class="form-control w-100" placeholder="Enter room">
                        <div id="roomError" class="error-message"></div>
                    </div>
                    
<!-- Optional Email for Notification -->
<label for="email" class="mt-3">Email Address (Optional)</label>
<div class="mt-1">
    <input type="email" name="email" id="email" class="form-control w-100" placeholder="Enter your email address here...">
    <div id="emailError" class="error-message"></div>
</div>

                    <label for="issue" class=" d-block mt-3 mb-3">Describe Issue</label>
                    <textarea id="issue" name="issue" rows="4" cols="50" class="form-control"placeholder="Explain the issue here..."></textarea>
                    <div id="issueError" class="error-message"></div>

                
                    <label for="imageUpload" class=" d-block mt-3 mb-3">Upload an Image</label>
                    <input type="file" name="imageUpload" id="imageUpload" class="form-control" accept="image/*">
                    <div id="imageUploadError" class="error-message"></div>


                    <!-- Submit Button -->
                    <div class="container mt-3 px-0">
                    <button type="submit" 
                     class="btn  w-100" 
                    style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
                     onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                    onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';">
                    Submit
                    </button>
                    </div>

                </form>

            
                <div>
               <button type="button" onclick="window.location.href='menuClient.jsp';" class="btn  p-2 shadow-none focus:outline-none active:outline-none"
                        style="background-color: transparent; border: none;">
                    <i class="bi bi-arrow-left-short"></i>Back
                </button>
            </div>
            </div>
            </div>
            </div>
            </div>
        </div>
        <script>
   function toggleOtherOption() {
    var equipmentSelect = document.getElementById("equipment");
    var otherEquipmentDiv = document.getElementById("otherEquipmentDiv");
    var selectedValue = equipmentSelect.value;

    // Show the input field when "Other" is selected
    if (selectedValue === "Other") {
        otherEquipmentDiv.style.display = "block";
    } else {
        otherEquipmentDiv.style.display = "none";
    }
}

</script>
            <script>
            function validateForm() {
                let valid = true;

                // Clear previous error messages
                document.querySelectorAll('.text-danger').forEach(el => el.textContent = '');

                // Validate Equipment
                const equipment = document.getElementById('equipment').value.trim();
                if (!equipment) {
                    document.getElementById('equipmentError').textContent = 'Please enter the type of equipment.';
                    valid = false;
                }

                // Validate Location
                const location = document.getElementById('location').value;
                if (!location) {
                    document.getElementById('locationError').textContent = 'Please select a location.';
                    valid = false;
                }

                // Validate Floor
                const floor = document.getElementById('floor').value.trim();
                if (!floor) {
                    document.getElementById('floorError').textContent = 'Please enter the floor.';
                    valid = false;
                }

                // Validate Room
                const room = document.getElementById('room').value.trim();
                if (!room) {
                    document.getElementById('roomError').textContent = 'Please enter the room.';
                    valid = false;
                }

                // Validate Issue
                const issue = document.getElementById('issue').value.trim();
                if (!issue) {
                    document.getElementById('issueError').textContent = 'Please describe the issue.';
                    valid = false;
                }
                //validate image
                const imageUpload = document.getElementById('imageUpload').files[0];
                if (!imageUpload) {
                document.getElementById('imageUploadError').textContent = 'Please upload an image.';
                valid = false;
                } else if (!imageUpload.type.startsWith('image/')) {
                 document.getElementById('imageUploadError').textContent = 'Only image files are allowed.';
                valid = false;
                } else if (imageUpload.size > 5 * 1024 * 1024) { // Check file size in bytes
                document.getElementById('imageUploadError').textContent = 'Image size must be below 5MB.';
                valid = false;
}

                return valid;
            }
           // Validate Email (optional)
const email = document.getElementById('email').value.trim();
if (email && !/\S+@\S+\.\S+/.test(email)) {
    document.getElementById('emailError').textContent = 'Please enter a valid email address.';
    valid = false;
}


        </script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>