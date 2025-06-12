<!DOCTYPE html>
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

        /* Fixed Star Rating CSS */
        .rating-wrapper {
            display: flex;
            flex-direction: row;
            gap: 5px;
            justify-content: center;
            align-items: center;
        }

        .rating-wrapper input[type="radio"] {
            display: none;
        }

        .rating-wrapper label {
            cursor: pointer;
            color: #ddd;
            font-size: 2rem;
            transition: color 0.2s;
        }

        .rating-wrapper label:hover,
        .rating-wrapper label:hover ~ label {
            color: #fbbe15;
        }

        .rating-wrapper input[type="radio"]:checked ~ label {
            color: #fbbe15;
        }

        .rating-wrapper input[type="radio"]:checked ~ label:hover,
        .rating-wrapper input[type="radio"]:checked ~ label:hover ~ label {
            color: #fbbe15;
        }

        /* This is the key fix - we need to style the stars from left to right */
        .rating-wrapper {
            flex-direction: row-reverse;
        }

        .rating-wrapper input[type="radio"]:checked ~ label,
        .rating-wrapper input[type="radio"]:checked ~ label ~ label {
            color: #fbbe15;
        }

        .rating-wrapper label:hover,
        .rating-wrapper label:hover ~ label,
        .rating-wrapper input[type="radio"]:checked ~ label:hover,
        .rating-wrapper input[type="radio"]:checked ~ label:hover ~ label {
            color: #fbbe15;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100" style="background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23f8f9fa"/></svg>'); 
             background-size: cover; 
             background-position: center; 
             background-repeat: no-repeat;">

<div class="container justify-content-center align-items-center flex-grow-1 my-5 montserrat-regular">
    <div class="row justify-content-center align-items-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-6">
            <div class="card">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <h2 class="montserrat-bold" style="color: #fbbe15;">FACILITAIN</h2>
                    </div>
                    <h3 class="text-center montserrat-bold">Feedback Form</h3>

                    <form onsubmit="return validateForm()">
                        <label for="room">Evaluation for <span style="color: red;">*</span></label>
                        <div class="mt-1">
                            <select name="room" id="room" class="form-select w-100" required>
                                <option value="" disabled selected>Choose type of room</option>
                                <option value="Classroom">Classroom</option>
                                <option value="Laboratory">Laboratory</option>
                                <option value="Conference Room">Conference Room</option>
                                <option value="Auditorium">Auditorium</option>
                            </select>
                            <small class="text-danger" id="roomError"></small>
                        </div>
                                                        
                        <label for="equipment" class="mt-2">Type of Equipment <span style="color: red;">*</span></label>
                        <div class="mt-1">
                            <select name="equipment" id="equipment" class="form-select w-100" onchange="toggleOtherOption()" required>
                                <option value="" disabled selected>Select equipment type</option>
                                <option value="projector">PROJECTOR</option>
                                <option value="computer">COMPUTER</option>
                                <option value="microphone">MICROPHONE</option>
                                <option value="speakers">SPEAKERS</option>
                                <option value="Other">OTHER</option>
                            </select>
                            <div id="otherEquipmentDiv" style="display: none;" class="mt-1">
                                <label for="otherEquipment" class="mt-2">Please specify: <span style="color: red;">*</span></label>
                                <input type="text" id="otherEquipment" name="otherEquipment" class="form-control w-100">
                            </div>
                        </div>

                        <label for="location" class="mt-2">Location <span style="color: red;">*</span></label>
                        <div class="mt-1">
                            <select name="location" id="location" class="form-select w-100" required>
                                <option value="" disabled selected>Choose a Location</option>
                                <option value="building-a">Building A</option>
                                <option value="building-b">Building B</option>
                                <option value="building-c">Building C</option>
                                <option value="main-hall">Main Hall</option>
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
                                            <!-- star 5 (rightmost in display, but highest value) -->
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
                                            
                                            <!-- star 1 (leftmost in display, lowest value) -->
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

                        <label for="suggestions" class="text-center mt-3 mb-3">
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
                            <button type="button" onclick="alert('Going back to menu');" class="btn p-2 shadow-none focus:outline-none active:outline-none"
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

<!-- JavaScript Validation -->
<script>
function toggleOtherOption() {
    const equipmentSelect = document.getElementById("equipment");
    const otherDiv = document.getElementById("otherEquipmentDiv");
    const otherInput = document.getElementById("otherEquipment");
    
    if (equipmentSelect.value === "Other") {
        otherDiv.style.display = "block";
        otherInput.required = true;
    } else {
        otherDiv.style.display = "none";
        otherInput.value = ""; // Clear the input if "Other" is not selected
        otherInput.required = false;
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
    document.getElementById('suggestionsError').textContent = '';

    // Validate Rating
    const rating = document.querySelector('input[name="rating"]:checked');
    if (!rating) {
        document.getElementById('ratingError').textContent = 'Please provide a rating.';
        valid = false;
    }

    // Validate Equipment "Other" option
    const equipment = document.getElementById("equipment").value;
    const otherEquipment = document.getElementById("otherEquipment").value;

    if (equipment === "Other" && otherEquipment.trim() === "") {
        alert("Please specify the equipment.");
        return false;
    }

    // Validate Suggestions (max 250 characters)
    const suggestions = document.getElementById('suggestions').value;
    if (suggestions.length > 250) {
        document.getElementById('suggestionsError').textContent = 'Feedback cannot exceed 250 characters.';
        valid = false;
    }

    // Update character count
    updateCharacterCount();

    if (valid) {
        alert('Form submitted successfully!');
    }

    return valid;
}

function updateCharacterCount() {
    const suggestions = document.getElementById('suggestions').value;
    document.getElementById('suggestionsCount').textContent = suggestions.length + " / 250 characters";
}

// Add event listener for real-time character count
document.getElementById('suggestions').addEventListener('input', function() {
    updateCharacterCount();
    // Clear error message if within limit
    if (this.value.length <= 250) {
        document.getElementById('suggestionsError').textContent = '';
    }
});
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>