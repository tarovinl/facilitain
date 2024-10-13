<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html lang="en">
    <head>
        <!-- Meta Tags -->
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta charset="UTF-8">
        
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        
        <!-- Optional: Add a custom title -->
        <title>Feedback</title>
    </head>
    <body>
     <jsp:include page="headerClient.jsp"/>
        <!-- Bootstrap Container Example -->
        <div class="w-100 h-100  bg-white d-flex flex-column justify-content-center align-items-center p-3">
        <div class="mw-50 h-75 bg-facilGray text-white p-5">
            <h1 class="text-center">FACILITAIN</h1>
            <h3 class="text-center ">Feedback Form</h3>
            <label for="room">Evaluation for</label>
             <div class="mt-1">
                <select name="room" id="room" class="form-control w-100">
                <option value="classroom">Classroom</option>
                <option value="auditorium">Auditorium</option>
                </select>
            </div>
            <label for="building">Building</label>
             <div class="mt-1">
                <select name="building" id="building" class="form-control w-100">
                <option value="frassati">Blessed Giorgio Frassati</option>
                <option value="main">Main Building</option>
                </select>
            </div>
            
            <div class="container mt-3">
        <label for="rating" class="text-center d-block mt-3 mb-3">
            Rate the performance of the <br /> equipments in your classroom
        </label>

        <!-- Radio buttons in a single line -->
        <div class="d-flex justify-content-center">
            <div class="radio-inline">
                <input type="radio" id="five" name="rating" value="5">
                <label for="five">5</label>
            </div>
            <div class="radio-inline">
                <input type="radio" id="four" name="rating" value="4">
                <label for="four">4</label>
            </div>
            <div class="radio-inline">
                <input type="radio" id="three" name="rating" value="3">
                <label for="three">3</label>
            </div>
            <div class="radio-inline">
                <input type="radio" id="two" name="rating" value="2">
                <label for="two">2</label>
            </div>
            <div class="radio-inline">
                <input type="radio" id="one" name="rating" value="1">
                <label for="one">1</label>
            </div>
        </div>
    </div>
        <label for="suggestions" class="text-center d-block mt-3 mb-3">
            Suggestions (Optional)
        </label>
        <textarea id="suggestions" name="suggestions" rows="4" cols="50" class="d-block">

</textarea>
            <!-- Example Bootstrap Button -->
             <div class="container mt-3 d-flex justify-content-center"> <!-- Centering with flexbox -->
        <button class="btn btn-primary">Submit</button>
    </div>
            </div>
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
