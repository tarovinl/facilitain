<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History Logs</title>
    <link rel="stylesheet" href="resources/hLogs.css">        
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
    <div class="d-flex vh-100" style="background: red;">
    <jsp:include page="sidebar.jsp"></jsp:include>
        <div class="topLevel">
            <div>
                <h1>History Logs</h1>
            </div>
            <div>
                <select class="sortDropdown">
                    <option value="all">Sort</option>
                </select>
            </div>
        </div>

        <!-- Table structure -->
        <table aria-label="history logs table" class="logContainer">
            <thead>
                <tr style="display: flexbox; justify-item: start;">
                    <th class="logHeader">Date</th>
                    <th class="logHeader">Time</th>
                    <th class="logHeader">By</th>
                    <th class="logHeader">Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="logBody">01/01/2001</td>
                    <td class="logBody">11:11 PM</td>
                    <td class="logBody">Administrator 1</td>
                    <td class="logBody">
                        Manage thingy 1 fand do some stuff and do some stuff and do some
                        stuff and do some stuff and do some stuff and do some stuff and do
                        some stuff and do some stuff and do some stuff and do some stuff
                        and do some stuff and do some stuff and do some stuff
                    </td>
                </tr>
                <tr>
                    <td class="logBody">02/02/2002</td>
                    <td class="logBody">2:22 PM</td>
                    <td class="logBody">System</td>
                    <td class="logBody">Manage thingy 2</td>
                </tr>
                <tr>
                    <td class="logBody">03/03/2003</td>
                    <td class="logBody">3:33 PM</td>
                    <td class="logBody">Administrator 2</td>
                    <td class="logBody">Manage thingy 3</td>
                </tr>
                <tr>
                    <td class="logBody">04/04/2004</td>
                    <td class="logBody">4:44 PM</td>
                    <td class="logBody">Support Staff 4</td>
                    <td class="logBody">Manage thingy 4</td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>