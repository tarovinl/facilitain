<%@ page import="java.util.ArrayList, java.util.List" %>
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
                            <th scope="col">Type</th>
                            <th scope="col">Building</th>
                            <th scope="col">Suggestions</th>
                            <th scope="col">Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            class Feedback {
                                String rating, type, building, suggestions, date;

                                public Feedback(String rating, String type, String building, String suggestions, String date) {
                                    this.rating = rating;
                                    this.type = type;
                                    this.building = building;
                                    this.suggestions = suggestions;
                                    this.date = date;
                                }
                            }

                            List<Feedback> feedbackList = new ArrayList<>();
                            feedbackList.add(new Feedback("5", "Classroom", "Albertus Magnus", "Need more maintenance in classrooms", "07/13/2024"));
                            feedbackList.add(new Feedback("3", "Auditorium", "Frassati", "Aircon is not felt throughout the auditorium", "07/12/2024"));
                            feedbackList.add(new Feedback("1", "Classroom", "Benevides", "Need more maintenance in classrooms", "07/11/2024"));

                            for (Feedback feedback : feedbackList) {
                        %>
                        <tr>
                            <td><%= feedback.rating %></td>
                            <td><%= feedback.type %></td>
                            <td><%= feedback.building %></td>
                            <td><%= feedback.suggestions %></td>
                            <td><%= feedback.date %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>

</html>
