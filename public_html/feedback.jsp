<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <!-- JSTL fmt taglib for date formatting -->
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="resources/feedback.css">
</head>

<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1>Feedback</h1>
                    <button class="btn btn-warning">Generate Report</button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Satisfaction Rate</h5>
                        <div class="chart">
                            <div class="d-flex justify-content-around align-items-end" style="height: 200px;">
                                <div class="bar" style="width: 50px; height: 80%; background-color: green;">Jan</div>
                                <div class="bar" style="width: 50px; height: 30%; background-color: yellow;">Feb</div>
                                <div class="bar" style="width: 50px; height: 60%; background-color: green;">Mar</div>
                                <div class="bar" style="width: 50px; height: 50%; background-color: yellow;">Apr</div>
                                <div class="bar" style="width: 50px; height: 90%; background-color: green;">May</div>
                                <div class="bar" style="width: 50px; height: 30%; background-color: red;">June</div>
                                <div class="bar" style="width: 50px; height: 20%; background-color: red;">July</div>
                                <div class="bar" style="width: 50px; height: 70%; background-color: green;">Aug</div>
                                <div class="bar" style="width: 50px; height: 40%; background-color: yellow;">Sep</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <select class="form-select w-auto" aria-label="Sort feedback">
                        <option selected>Sort by</option>
                        <option value="1">Rating</option>
                        <option value="2">Date</option>
                    </select>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">Rating</th>
                            <th scope="col">Room</th>
                            <th scope="col">Location</th>
                            <th scope="col">Suggestions</th>
                            <th scope="col">Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Iterate over feedbackList passed from the controller -->
                        <c:forEach var="feedback" items="${feedbackList}">
                            <tr>
                                <td>${feedback.rating}</td>
                                <td>${feedback.room}</td>
                                <td>${feedback.location}</td>
                                <td>${feedback.suggestions}</td>
                                <!-- Format the REC_INS_DT date using JSTL fmt:formatDate -->
                                <td>
                                    <fmt:formatDate value="${feedback.recInsDt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>

</html>
