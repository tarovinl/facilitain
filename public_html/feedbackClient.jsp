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
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="./resources/css/rating.css">
    <title>Feedback</title>
</head>
<body>
<jsp:include page="headerClient.jsp"/>


   <div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
                <div class="card">
                    <div class="card-body ">
        <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" class="img-fluid mb-4" style="max-height: 4rem;">
        <h3 class="text-center">Feedback Form</h3>

        <form action="feedbackClient" method="POST" onsubmit="return validateForm()">
            <label for="room">Evaluation for</label>
            <div class="mt-1">
                <select name="room" id="room" class="form-control w-100" required>
                    <option value="" disabled selected>-- Choose Room --</option>
                    <option value="Classroom">Classroom</option>
                    <option value="Auditorium">Auditorium</option>
                </select>
                <small class="text-danger" id="roomError"></small>
            </div>

            <label for="location">Location</label>
            <div class="mt-1">
                <select name="location" id="location" class="form-control w-100" required>
                    <option value="" disabled selected>-- Choose Location --</option>
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
        
        <!-- star 5 -->
        <input type="radio" id="five" name="rating" value="5">
        <label for="five" class="star-rating">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
         <!-- star 4 -->
        <input type="radio" id="four" name="rating" value="4">
        <label for="four" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
         <!-- star 3 -->
        <input type="radio" id="three" name="rating" value="3">
        <label for="three" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
        <!-- star 2 -->
        <input type="radio" id="two" name="rating" value="2">
        <label for="two" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
        <!-- star 1 -->
        <input type="radio" id="one" name="rating" value="1">
        <label for="one" class="star-rating star">
          <i class="fas fa-star d-inline-block"></i>
        </label>
        
       </div>
      
    </div>
  </div>
</div>
    </div>

                <small class="text-danger" id="ratingError"></small>
            </div>

            <label for="suggestions" class="text-center d-block mt-3 mb-3">
                Feedback and Suggestions (Optional)
            </label>
            <textarea id="suggestions" name="suggestions" rows="4" cols="50" class="d-block"></textarea>

            <div class="container mt-3 d-flex justify-content-center">
                <button type="submit" class="btn btn-primary"
                style="background-color: #fbbe15; border: none;">Submit</button>
            </div>
            <div class="">
                <button type="button" onclick="window.location.href='menuClient.jsp';" class="btn  p-2"
                        style="background-color: transparent;">
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

<!-- JavaScript Validation -->
<script>
    function validateForm() {
        let valid = true;

        // Clear previous error messages
        document.getElementById('roomError').textContent = '';
        document.getElementById('locationError').textContent = '';
        document.getElementById('ratingError').textContent = '';

        // Validate Room
        const room = document.getElementById('room');
        if (room.value === "") {
            document.getElementById('roomError').textContent = 'Please select a room.';
            valid = false;
        }

        // Validate Location
        const location = document.getElementById('location');
        if (location.value === "") {
            document.getElementById('locationError').textContent = 'Please select a location.';
            valid = false;
        }

        // Validate Rating
        const rating = document.querySelector('input[name="rating"]:checked');
        if (!rating) {
            document.getElementById('ratingError').textContent = 'Please provide a rating.';
            valid = false;
        }

        return valid;
    }
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkm6Yc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<jsp:include page="footerClient.jsp"/>
</body>
</html>
