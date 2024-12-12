<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="en">
<head>
    <!-- Meta Tags -->
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
     <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@483&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="./resources/css/rating.css">
    <title>Feedback</title>
    <style>
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
        <h3 class="text-center montserrat-bold">Feedback Form</h3>

        <form action="feedbackClient" method="POST" onsubmit="return validateForm()">
           <label for="room">Evaluation for <span style="color: red;">*</span></label>
<div class="mt-1">
    <select name="room" id="room" class="form-select w-100" required >
        <option value="" disabled selected>Choose type of room</option>
        <c:forEach var="type" items="${typeList}">
            <option value="${type.value}">${type.value}</option>
        </c:forEach>
    </select>
    <small class="text-danger" id="roomError"></small>
</div>
            
          <label for="equipment" class="mt-2">Type of Equipment <span style="color: red;">*</span></label>
<div class="mt-1">
    <select name="equipment" id="equipment" class="form-select w-100" onchange="toggleOtherOption()" required>
        <option value="">Select equipment type</option>
        <c:forEach var="category" items="${catList}">
            <option value="${category.key}">${category.value.toUpperCase()}</option>
        </c:forEach>
        <option value="Other">OTHER</option> 
    </select>
    <div id="equipmentError" class="error-message"></div>
</div>
<div id="otherEquipmentDiv" style="display: none;" class="mt-1">
    <label for="otherEquipment" class="mt-2">Please specify: <span style="color: red;">*</span></label>
    <input type="text" id="otherEquipment" name="otherEquipment" class="form-control w-100" required>
</div>

            
            <label for="location" class="mt-2">Location <span style="color: red;">*</span></label>
            <div class="mt-1">
                <select name="location" id="location" class="form-select w-100" required >
                    <option value="" disabled selected >Choose a Location</option>
                    <c:forEach var="location" items="${locationList}">
                        <option value="${location.key}">${location.value}</option>
                    </c:forEach>
                </select>
                <small class="text-danger" id="locationError"></small>
            </div>

             <div class="container mt-3">
                <label for="rating" class="text-center d-block mt-3 mb-3">
                    Rate the performance of the <br/> equipment in your location
                </label>

<div class="container-wrapper">  
  <div class="container d-flex align-items-center justify-content-center">
    <div class="row justify-content-center">    
      
      <!-- star rating -->
      <div class="rating-wrapper">
        <input type="radio" id="five" name="rating" value="5" onclick="updateRatingLabel(5)">
        <label for="five" class="star-rating">
          <i class="fas fa-star d-inline-block"></i>
        </label>
    
        <!-- star 4 -->
        <input type="radio" id="four" name="rating" value="4" onclick="updateRatingLabel(4)">
        <label for="four" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
    
        <!-- star 3 -->
        <input type="radio" id="three" name="rating" value="3" onclick="updateRatingLabel(3)">
        <label for="three" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
    
        <!-- star 2 -->
        <input type="radio" id="two" name="rating" value="2" onclick="updateRatingLabel(2)">
        <label for="two" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
    
        <!-- star 1 -->
        <input type="radio" id="one" name="rating" value="1" onclick="updateRatingLabel(1)">
        <label for="one" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
       </div>
      
      
    </div>
  </div>
</div>
<div class="mt-1 text-center fw-bold" id="ratingLabel"></div>
    </div>
    
        <div class="mt-1 text-center fw-bold">
        <small class="text-danger" id="ratingError"></small>
        </div>

            <label for="suggestions" class="text-center  mt-3 mb-3">
                Feedback and Suggestions (Optional)
            </label>
            <div class="mt-1">
            <textarea id="suggestions" name="suggestions" rows="4" cols="50" class="d-block p-3 w-100 mx-auto rounded border"
    style="width: 100%;" placeholder="Enter your feedback and suggestions here..." maxlength="250"></textarea>
            <div id="suggestionsError" class="text-danger"></div>
            <div id="suggestionsCount" class="text-muted" style="font-size: 12px; text-align: right;">
                0 / 250 characters
            </div>
            </div>

            <div class="mt-1 w-100">
                <button type="submit" class="btn w-100 mt-2" 
                    style="background-color: #fbbe15; color: #212529; border: none; transition: background-color 0.3s, color 0.3s;"
                    onmouseover="this.style.backgroundColor='#292927'; this.style.color='#fbbe15';" 
                    onmouseout="this.style.backgroundColor='#fbbe15'; this.style.color='#212529';">
                    Submit
                </button>
            </div>

           
            <div>
                <button type="button" onclick="window.location.href='menuClient.jsp';" class="btn  p-2 shadow-none focus:outline-none active:outline-none"
                        style="background-color: transparent; border: none;">
                    <i class="bi bi-arrow-left-short"></i>Back
                </button>
            </div>
        </form>
        </div>
    </div>
    </div>
    </div>
    </div>
    </div>
</div>

<!-- JavaScript Validation -->
<script>
function toggleOtherOption() {
    const equipmentSelect = document.getElementById('equipment');
    const otherEquipmentDiv = document.getElementById('otherEquipmentDiv');
    const otherEquipmentInput = document.getElementById('otherEquipment');

    if (equipmentSelect.value === 'Other') {
        otherEquipmentDiv.style.display = 'block';
        otherEquipmentInput.setAttribute('required', 'true');  // Make it required
    } else {
        otherEquipmentDiv.style.display = 'none';
        otherEquipmentInput.removeAttribute('required');  // Remove the required attribute
    }
}

function updateRatingLabel(rating) {
    const label = document.getElementById('ratingLabel');
    
    // Set label text and color based on rating value
    switch (rating) {
      case 1:
        label.textContent = "Very Poor";
        label.style.color = "red";
        break;
      case 2:
        label.textContent = "Poor";
        label.style.color = "orange";
        break;
      case 3:
        label.textContent = "Average";
        label.style.color = "#fbbe15";
        break;
      case 4:
        label.textContent = "Good";
        label.style.color = "green";
        break;
      case 5:
        label.textContent = "Great";
        label.style.color = "darkgreen";
        break;
      default:
        label.textContent = "";
    }
  }
  

function validateForm() {
    let valid = true;

    // Clear previous error messages
    
    document.getElementById('ratingError').textContent = '';
    



    // Validate Rating
    const rating = document.querySelector('input[name="rating"]:checked');
    if (!rating) {
        document.getElementById('ratingError').textContent = 'Please provide a rating.';
        valid = false;
    }

    // Validate Suggestions (max 250 characters)
    const suggestions = document.getElementById('suggestions').value;
    if (suggestions.length > 250) {
        document.getElementById('suggestionsError').textContent = 'Feedback cannot exceed 250 characters.';
        valid = false;
    }

    // Validate Suggestions Length Display
    document.getElementById('suggestionsCount').textContent = suggestions.length + " / 250 characters";

    return valid;
}

document.getElementById('suggestions').addEventListener('input', function() {
    validateForm();
});
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkm6Yc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<jsp:include page="footerClient.jsp"/>
</body>
</html>