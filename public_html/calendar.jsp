<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Calendar</title>

    <!-- Include FullCalendar and Bootstrap from CDN -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.15/main.min.css" rel="stylesheet"/>
  

    <style>
        .tile-event {
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="container-fluid">
      <div class="row min-vh-100">
        
          <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10">
            <h1>Maintenance Calendar</h1>

            <!-- Calendar Div -->
            <div id="calendar"></div>
        </div>
    </div>

    <!-- Initialize the FullCalendar -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',  // Shows a full month view by default
                events: [
                    {
                        id: 1,
                        title: "Aircon Maintenance",
                        start: "2024-07-24",
                        description: "Aircons at Frassati Building",
                        url: "equipment.jsp?id=1" // Dynamic link
                    },
                    {
                        id: 2,
                        title: "GenSet Maintenance",
                        start: "2024-07-09",
                        description: "GenSet at Main Campus",
                        url: "equipment.jsp?id=2"
                    },
                    {
                        id: 3,
                        title: "Skibiding some toilets",
                        start: "2024-09-09",
                        description: "Toilet Maintenance at Main Campus",
                        url: "equipment.jsp?id=3"
                    }
                ],
                eventClick: function(info) {
                    info.jsEvent.preventDefault(); // Prevent the default action

                    // If the event has a URL, open it
                    if (info.event.url) {
                        window.location.href = info.event.url;
                    }
                }
            });

            calendar.render();
        });
    </script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.15/index.min.js"></script>
           
</body>
</html>
