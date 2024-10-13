<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History Logs</title>
    <!-- Bootstrap CSS from StackPath -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Custom CSS for history logs -->
    <link rel="stylesheet" href="resources/hLogs.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row vh-100">
            <!-- Sidebar: Fixed width using Bootstrap's grid system -->
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"></jsp:include>
            </div>
            
            <!-- Main content: Use col and offset to avoid overlap with sidebar -->
            <div class="col-md-9 col-lg-10 p-4">
                <!-- Page title and sort dropdown -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1>History Logs</h1>
                    <select class="form-select w-auto" aria-label="Sort history logs">
                        <option selected>Sort by</option>
                        <option value="1">Date</option>
                        <option value="2">By</option>
                        <option value="3">Action</option>
                    </select>
                </div>

                <!-- Table structure -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Time</th>
                            <th scope="col">By</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- JSP mock data - using a custom class to store logs -->
                        <%
                            class HistoryLog {
                                String date, time, by, action;
                                HistoryLog(String date, String time, String by, String action) {
                                    this.date = date;
                                    this.time = time;
                                    this.by = by;
                                    this.action = action;
                                }
                            }
                            HistoryLog[] logs = new HistoryLog[] {
                                new HistoryLog("07/15/2024", "12:06 PM", "Administrator 1", "Manual status change"),
                                new HistoryLog("07/12/2024", "1:04 PM", "Administrator 2", "Quotation of XY2010 uploaded"),
                                new HistoryLog("06/28/2024", "11:24 AM", "Administrator 3", "Added building 'Henry Sy'"),
                                new HistoryLog("06/20/2024", "9:05 AM", "System", "Auto status change to 'in maintenance'"),
                                new HistoryLog("05/14/2024", "2:32 PM", "Administrator 1", "Manual status change"),
                                new HistoryLog("05/09/2024", "12:30 PM", "Administrator 2", "Quotation of KC0100 uploaded"),
                                new HistoryLog("05/07/2024", "7:04 AM", "Administrator 3", "Added building 'Parish'"),
                                new HistoryLog("04/20/2024", "11:04 AM", "System", "Auto status change to 'in maintenance'")
                            };
                            for (HistoryLog log : logs) {
                        %>
                        <tr>
                            <td><%= log.date %></td>
                            <td><%= log.time %></td>
                            <td><%= log.by %></td>
                            <td><%= log.action %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- StackPath Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
