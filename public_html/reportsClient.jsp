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

        <title>Reports</title>
    </head>
    <body>
        <jsp:include page="headerClient.jsp"/>
        <div class="w-100 h-100 bg-white d-flex flex-column justify-content-center align-items-center p-3">
            <div class="mw-50 h-75 bg-facilGray text-white p-5">
                <img src="resources/images/FACILITAIN.png" alt="FACILITAIN" style="height: 4rem;"/>
                <h3 class="text-center">Report a Problem</h3>

                <!-- Form Starts Here -->
                <form action="reportsClient" method="post">
                    <label for="equipment">Type of Equipment</label>
                    <div class="mt-1">
                        <input type="text" name="equipment" id="equipment" class="form-control w-100" placeholder="Enter equipment type">
                    </div>

                    <label for="location">Location</label>
                    <div class="mt-1">
                        <select name="location" id="location" class="form-control w-100">
                            <!-- Dynamically populated locations -->
                            <c:forEach var="location" items="${locationList}">
                                <option value="${location.key}">${location.value}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <label for="floor">Floor</label>
                    <div class="mt-1">
                        <input type="text" name="floor" id="floor" class="form-control w-100" placeholder="Enter floor">
                    </div>

                    <label for="room">Room</label>
                    <div class="mt-1">
                        <input type="text" name="room" id="room" class="form-control w-100" placeholder="Enter room">
                    </div>

                    <label for="issue" class="text-center d-block mt-3 mb-3">
                        Describe the Issue
                    </label>
                    <textarea id="issue" name="issue" rows="4" cols="50" class="form-control"></textarea>

                    <!-- Submit Button -->
                    <div class="container mt-3 d-flex justify-content-center">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
                <!-- Form Ends Here -->

                <div class="">
                    <button class="btn text-white p-2" style="background-color: transparent;">
                        <i class="bi bi-arrow-left-short"></i>Back
                    </button>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <jsp:include page="footerClient.jsp"/>
    </body>
</html>
