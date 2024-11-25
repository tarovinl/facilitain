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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <title>Feedback</title>
    </head>
    <body>
        <jsp:include page="headerClient.jsp"/>
        
        <!-- Bootstrap Container Example -->
        <div class="w-100 h-100 bg-white d-flex flex-column justify-content-center align-items-center p-3">
            <div class="mw-50 h-75 bg-facilGray text-white p-5">
                <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" style="height: 4rem;"/>
                <h3 class="text-center">Feedback Form</h3>

                <form action="feedbackClientController" method="POST">
                    <label for="room">Evaluation for</label>
                    <div class="mt-1">
                        <select name="room" id="room" class="form-control w-100">
                            <option value="Classroom">Classroom</option>
                            <option value="Auditorium">Auditorium</option>
                        </select>
                    </div>

                    <label for="location">Location</label>
                    <div class="mt-1">
                        <select name="location" id="location" class="form-control w-100">
                            <c:forEach var="location" items="${locationList}">
                                <option value="${location.key}">${location.value}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="container mt-3">
                        <label for="rating" class="text-center d-block mt-3 mb-3">
                            Rate the performance of the <br /> equipments in your location
                        </label>

                        <div class="d-flex justify-content-center">
                            <div class="radio-inline p-2 d-flex flex-column align-items-center">
                                <input type="radio" id="five" name="rating" value="5">
                                <label for="five">5</label>
                            </div>
                            <div class="radio-inline p-2 d-flex flex-column align-items-center">
                                <input type="radio" id="four" name="rating" value="4">
                                <label for="four">4</label>
                            </div>
                            <div class="radio-inline p-2 d-flex flex-column align-items-center">
                                <input type="radio" id="three" name="rating" value="3">
                                <label for="three">3</label>
                            </div>
                            <div class="radio-inline p-2 d-flex flex-column align-items-center">
                                <input type="radio" id="two" name="rating" value="2">
                                <label for="two">2</label>
                            </div>
                            <div class="radio-inline p-2 d-flex flex-column align-items-center">
                                <input type="radio" id="one" name="rating" value="1">
                                <label for="one">1</label>
                            </div>
                        </div>
                    </div>

                    <label for="suggestions" class="text-center d-block mt-3 mb-3">
                       Detailed Feedback and Suggestions (Optional)
                    </label>
                    <textarea id="suggestions" name="suggestions" rows="4" cols="50" class="d-block"></textarea>

                    <div class="container mt-3 d-flex justify-content-center">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                    <div class="">
                        <button class="btn text-white p-2" style="background-color: transparent;">
                            <i class="bi bi-arrow-left-short"></i>Back
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
        
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
