<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
            
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1>Reports</h1>
                    <select class="form-select w-auto" aria-label="Sort reports">
                        <option selected>Sort by</option>
                        <option value="1">Date</option>
                        <option value="2">Equipment Type</option>
                        <option value="3">Building</option>
                    </select>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Equipment Type</th>
                            <th scope="col">Building</th>
                            <th scope="col">Floor</th>
                            <th scope="col">Room</th>
                            <th scope="col">Describe the Issue</th>
                            <th scope="col">Proof</th>
                            <th scope="col">Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            class Report {
                                String id, equipmentType, building, floor, room, issue, proofIcon, date;

                                public Report(String id, String equipmentType, String building, String floor, String room, String issue, String proofIcon, String date) {
                                    this.id = id;
                                    this.equipmentType = equipmentType;
                                    this.building = building;
                                    this.floor = floor;
                                    this.room = room;
                                    this.issue = issue;
                                    this.proofIcon = proofIcon;
                                    this.date = date;
                                }
                            }
                            //mock data
                            Report[] reports = new Report[] {
                                new Report("1", "Aircon", "Albertus Magnus", "2", "2", "Broken Aircon", "🖼️", "07/13/2024"),
                                new Report("2", "Aircon", "Frassati", "19", "19", "Aircon is not working", "🖼️", "07/12/2024"),
                                new Report("3", "Generator", "Benevides", "1", "1", "Power broke out and didn't come again", "🖼️", "07/11/2024")
                            };

                            for (Report report : reports) {
                        %>
                            <tr>
                                <td><%= report.id %></td>
                                <td><%= report.equipmentType %></td>
                                <td><%= report.building %></td>
                                <td><%= report.floor %></td>
                                <td><%= report.room %></td>
                                <td><%= report.issue %></td>
                                <td><%= report.proofIcon %></td>
                                <td><%= report.date %></td>
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
