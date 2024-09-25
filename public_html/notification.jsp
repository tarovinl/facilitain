<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- StackPath Bootstrap CSS -->
     <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- StackPath Bootstrap Icons -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap-icons/1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <title>Notifications</title>
</head>
<body>
    <div class="d-flex">
        <!-- Include Sidebar here -->
        <jsp:include page="sidebar.jsp"></jsp:include>

        <!-- Main container for Notifications -->
        <div class="container p-4">
            <h1 class="mb-4">Notifications</h1>

            <!-- Hardcoded array of notifications (for now) -->
            <%
                class Notification {
                    int id;
                    String title;
                    String description;
                    String date;
                    String icon;
                    String link;

                    Notification(int id, String title, String description, String date, String icon, String link) {
                        this.id = id;
                        this.title = title;
                        this.description = description;
                        this.date = date;
                        this.icon = icon;
                        this.link = link;
                    }
                }

                Notification[] notifications = new Notification[]{
                    new Notification(1, "Upcoming Maintenance", "Aircons at Frassati Building", "July 24", "bi-clock-history", "equipment.jsp?id=1"),
                    new Notification(2, "Quotation Uploaded", "Aircon Quotation for Building", "July 14", "bi-file-earmark-text", "equipment.jsp?id=2")
                };
            %>

            <!-- Iterate over the notifications and display them -->
            <%
                for (Notification notification : notifications) {
            %>
            <a href="<%=notification.link%>" class="text-decoration-none">
                <div class="d-flex justify-content-between align-items-center border-bottom py-3 clickable">
                    <div class="d-flex align-items-center">
                        <i class="bi <%=notification.icon%> fs-3 me-3"></i>
                        <div>
                            <h5 class="mb-0"><%=notification.title%></h5>
                            <p class="text-muted"><%=notification.description%></p>
                        </div>
                    </div>
                    <div>
                        <span class="text-muted"><%=notification.date%></span>
                    </div>
                </div>
            </a>
            <%
                }
            %>
        </div>
    </div>

    <!-- StackPath Bootstrap JS -->
     <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
