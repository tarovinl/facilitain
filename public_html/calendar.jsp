<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Calendar - Facilitain</title>
    
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/rrule@2.6.6/dist/es5/rrule.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.all.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.15.10/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="resources/images/FMO-Logo.ico">
    <style>
            body, h1, h2, h3, h4, th {
            font-family: 'NeueHaasMedium', sans-serif !important;
        }
        h5, h6, input, textarea, td, tr, p, label, select, option {
            font-family: 'NeueHaasLight', sans-serif !important;
        }
            .responsive-padding-top {
                                              padding-top: 100px;
                                            }
                                            
                            @media (max-width: 576px) {
                            .responsive-padding-top {
                            padding-top: 80px; /* or whatever smaller value you want */
                            }
                            }
    </style>
    
    <%@ page import="java.util.HashSet" %>
<%
    HashSet<String> displayedLocations = new HashSet<>();
    request.setAttribute("displayedLocations", displayedLocations);
%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            // Get the current year
            var currentYear = new Date().getFullYear();

            // Generate recurring events for 10 years before and after
            var startYear = currentYear - 5; // 10 years before current year
            var endYear = currentYear + 10;   // 10 years after current year
            var recurringEvents = [];


            for (var year = startYear; year <= endYear; year++) {
                <c:forEach var="job" items="${calendarSched}">
                <c:if test="${fn:contains(job.repeatInterval, 'YEARLY')}">
                    <c:set var="jobNumber" value="${fn:substringBefore(fn:substringAfter(job.jobName, 'CAT'), '_')}" />
                    <c:set var="jobNumberInt" value="${jobNumber + 0}" />
                    <c:set var="monthNumber" value="${fn:substringBefore(fn:substringAfter(job.repeatInterval, 'BYMONTH='), ';')}" />
                    <c:choose>
                        <c:when test="${fn:length(monthNumber) == 1}">
                            <c:set var="monthNumber" value="0${monthNumber}" />
                        </c:when>
                        <c:otherwise>
                        </c:otherwise>
                    </c:choose>
                    <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                        <c:if test="${cat.itemCID == jobNumberInt}">
                            recurringEvents.push({
                                title: 'Annual Maintenance for '+'${cat.itemCat}',
                                start: year + '-${monthNumber}-01', 
                                allDay: true
                            });
                        </c:if>
                    </c:forEach>
                </c:if>
                </c:forEach>
                
                <c:forEach var="job" items="${calendarSched}">
                <c:if test="${fn:contains(job.repeatInterval, 'MONTHLY')}">
                <c:if test="${fn:contains(job.repeatInterval, 'BYMONTH=')}">
                    <c:set var="qjobNumber" value="${fn:substringBefore(fn:substringAfter(job.jobName, 'CAT'), '_')}" />
                    <c:set var="qjobNumberInt" value="${qjobNumber + 0}" />
                        <c:set var="monthNumbers" value="${fn:substringAfter(job.repeatInterval, 'BYMONTH=')}" />
                        <c:set var="monthNumbers" value="${fn:substringBefore(monthNumbers, ';')}" />
                        <c:set var="monthArray" value="${fn:split(monthNumbers, ',')}" />
                            <c:forEach var="month" items="${monthArray}">
                                <c:set var="monthInt" value="${month * 1}" /> 
                                <c:choose>
                                    <c:when test="${monthInt < 10}">
                                        <c:set var="monthStr" value="0${monthInt}" /> 
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="monthStr" value="${monthInt}" /> 
                                    </c:otherwise>
                                </c:choose>
                                <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                                <c:if test="${cat.itemCID == qjobNumberInt}">
                                    recurringEvents.push({
                                        title: 'Quarterly Maintenance for '+'${cat.itemCat}',
                                        start: year + '-${monthStr}-01', 
                                        allDay: true
                                    });
                                </c:if>
                                </c:forEach>
                            </c:forEach>
                </c:if>
                </c:if>
                </c:forEach>
                
                for (var month = 1; month <= 12; month++) {
                    var monthStr = month < 10 ? '0' + month : month; 
                    <c:forEach var="job" items="${calendarSched}">
                    <c:if test="${fn:contains(job.repeatInterval, 'MONTHLY') && !fn:contains(job.repeatInterval, 'BYMONTH=')}">                        
                        <c:set var="mjobNumber" value="${fn:substringBefore(fn:substringAfter(job.jobName, 'CAT'), '_')}" />
                        <c:set var="mjobNumberInt" value="${mjobNumber + 0}" />
                            <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                            <c:if test="${cat.itemCID == mjobNumberInt}">
                                recurringEvents.push({
                                    title: 'Monthly Maintenance for '+'${cat.itemCat}',
                                    start: year + '-' + monthStr + '-01', 
                                    allDay: true
                                });
                            </c:if>
                            </c:forEach>
                    </c:if>
                    </c:forEach>
                    
                }
                
                var startOfYear = new Date(year, 0, 1); 
                var firstMonday = startOfYear.getDate() + (1 - startOfYear.getDay() + 7) % 7; 
                startOfYear.setDate(firstMonday);                
                var weekIncrement = 7 * 24 * 60 * 60 * 1000; 
                for (var week = 0; week < 52; week++) { // 52 weeks in a year
                    var weeklyDate = new Date(startOfYear.getTime() + week * weekIncrement);
                    var weekMonthStr = (weeklyDate.getMonth() + 1).toString().padStart(2, '0'); 
                    var weekDayStr = weeklyDate.getDate().toString().padStart(2, '0'); 
                    <c:forEach var="job" items="${calendarSched}">
                    <c:if test="${fn:contains(job.repeatInterval, 'WEEKLY')}">
                        <c:set var="jobNumber" value="${fn:substringBefore(fn:substringAfter(job.jobName, 'CAT'), '_')}" />
                        <c:set var="jobNumberInt" value="${jobNumber + 0}" />
                            <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                            <c:if test="${cat.itemCID == jobNumberInt}">
                            recurringEvents.push({
                                title: 'Weekly Maintenance for '+'${cat.itemCat}',
                                start: year + '-' + weekMonthStr + '-' + weekDayStr, 
                                allDay: true
                            });
                            </c:if>
                            </c:forEach>
                    </c:if>
                    </c:forEach>
                }
                
                
            }
            
            <c:forEach var="job" items="${calendarSched}">
            <c:if test="${fn:contains(job.repeatInterval, 'DAILY')}">
                <c:set var="interval" value="${fn:substringAfter(job.repeatInterval, 'INTERVAL=')}" />
                var jobCreated = new Date("${job.jobCreated}");
                var repeatInterval = ${interval};
                var currentDate = new Date(jobCreated);
                var endDate = new Date(new Date().getFullYear() + 10, 11, 31); // 10 years after current year
                <c:set var="jobNumber" value="${fn:substringBefore(fn:substringAfter(job.jobName, 'CAT'), '_')}" />
                <c:set var="jobNumberInt" value="${jobNumber + 0}" />
                
                while (currentDate <= endDate) {
                    <c:forEach var="cat" items="${FMO_CATEGORIES_LIST}">
                    <c:if test="${cat.itemCID == jobNumberInt}">            
                    recurringEvents.push({
                        title: 'Biannual Maintenance for '+'${cat.itemCat}',
                        start: currentDate.toISOString().split('T')[0],
                        allDay: true
                    });
                    </c:if>
                    </c:forEach>      
                    // Increment the current date by the interval
                    currentDate.setDate(currentDate.getDate() + repeatInterval);
                }
            </c:if>
            </c:forEach>
            
            <c:forEach items="${FMO_USERS}" var="user" >
                <c:if test="${sessionScope.email == user.email}">
                    <c:set var="empNum" value="${user.userId}" />
                </c:if>
            </c:forEach>
            // Other static events
            var events = [
                ...recurringEvents,
            <c:forEach var="todos" items="${FMO_TO_DO_LIST}">
            <c:if test="${todos.empNumber == empNum}">
                {
                    title: '${todos.listContent}', 
                    start: '${todos.startDate}',
                    end: '${todos.endDate}',
                    <!--display: 'background'-->
                },
            </c:if>
            </c:forEach>
            ];
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                events: events,
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                eventClick: function(info) {
                var title = info.event.title;
                
                // Check if "Maintenance for" exists but is NOT at the start
                if (title.includes("Maintenance for") && title.indexOf("Maintenance for") > 0) {
                    var eventTitleParts = title.split("for");
                    var eventCat = eventTitleParts.length > 1 ? eventTitleParts[1].trim() : '';
            
                    console.log("eventCat: " + eventCat);
                    
                    $.ajax({
                    type: "GET",
                    url: "calendar",
                    data: { eventCat: eventCat },
                    dataType: "json",
                    success: function(response) {
                        let locationList = response.map(loc => `<div>`+loc+`</div>`).join('');
                        console.log(locationList);
            
                        Swal.fire({
                            title: info.event.title,
                            icon: 'info',
                            showConfirmButton: true,
                            html: `
                                <table style="width: 100%; text-align: left; border-collapse: collapse;">
                                    <tr>
                                        <td style="font-weight: bold; padding: 8px; border-bottom: 1px solid #ddd;">Date:</td>
                                        <td style="padding: 8px; border-bottom: 1px solid #ddd;">`+info.event.start.toLocaleDateString()+`</td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold; padding: 8px; border-bottom: 1px solid #ddd;">Location/s:</td>
                                        <td style="padding: 8px; border-bottom: 1px solid #ddd;">
                                            <div style="max-height: 150px; overflow-y: auto; padding: 4px;">
                                            `+locationList+`
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            `,
                            confirmButtonText: 'Close'
                        });
                    },
                        error: function() {
                            Swal.fire("Error", "Failed to fetch locations.", "error");
                        }
                    });
                } else {
                    // Show a normal SweetAlert for invalid titles
                    Swal.fire({
                        title: info.event.title,
                        icon: "info",
                        confirmButtonText: "OK"
                    });
                }
            }

            });
            calendar.render();
        });
    </script>

    <style>
    /* Apply custom styles for smaller screens */
    
    
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
<jsp:include page="navbar.jsp"/>
<div class="container-fluid">
<div class="row min-vh-100">
<c:set var="page" value="calendar" scope="request"/>
    <jsp:include page="sidebar.jsp"/>
    
    <div class="col-md-10  responsive-padding-top">
        <div class="">
            
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
