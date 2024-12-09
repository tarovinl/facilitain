<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Calendar</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.5/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/rrule@2.6.6/dist/es5/rrule.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.5/main.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
    
    <script>
        
    </script>

    <style>
    /* Apply custom styles for smaller screens */
    @media (max-width: 768px) {
        .fc-toolbar {
            display: flex;
            flex-direction: column; /* Stack the toolbar items vertically */
            align-items: center;
        }

        .fc-toolbar-chunk {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping if necessary */
            justify-content: center;
            margin-bottom: 0.5rem; /* Add spacing between rows */
        }

        .fc-toolbar-title {
            margin-bottom: 0.5rem;
            font-size: 1.2rem; /* Adjust title size for better readability */
        }

        .fc-button {
            margin: 0.2rem; /* Add spacing around buttons */
        }
    }
    
    .fc-button.fc-dayGridMonth-button,
    .fc-button.fc-timeGridWeek-button,
    .fc-button.fc-timeGridDay-button {
        background-color: #fccc4c;
        color: black;
    }
    .fc-button.fc-today-button,
    .fc-button.fc-prev-button,
    .fc-button.fc-next-button{
        background-color: #fccc4c;
        color: black;
        border: none;
    }
    .fc-button.fc-prev-button:hover,
    .fc-button.fc-next-button:hover {
        background-color: #ffcc00;
    }
    
    .fc .fc-col-header-cell a,
    .fc .fc-daygrid-day-number a,
    .fc .fc-daygrid-day-top a {
        text-decoration: none; /* Remove underline */
        color: inherit; /* Use the inherited color */
        cursor: default; /* Change cursor to default arrow */
    }

    
    
    </style>

</head>
<body>
<div class="container-fluid">
<div class="row min-vh-100">
    <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10">
        <div class="mt-4">
            <h1>Maintenance Calendar</h1>
        </div>
        <div class="mb-4">
        <div id='calendar'></div>
        
        </div>
    </div>
    
</div>
</div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>  
</body>
</html>
