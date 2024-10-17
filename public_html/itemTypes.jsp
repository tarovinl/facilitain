<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item List</title>
    <!-- Bootstrap CSS from StackPath -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="resources/custom.css">
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
                    <h1>Item List</h1>
                    <select class="form-select w-auto" aria-label="Sort items">
                        <option selected>Sort by</option>
                        <option value="1">Item Type</option>
                        <option value="2">Category</option>
                        <option value="3">Name</option>
                    </select>
                </div>

                <!-- Table structure -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">Item Type ID</th>
                            <th scope="col">Item Category ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">Description</th>
                            <th scope="col">Active Flag</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Dynamic Data Display -->
                        <c:forEach var="item" items="${itemList}">
                            <tr>
                                <td>${item.ITEM_TYPE_ID}</td>
                                <td>${item.ITEM_CAT_ID}</td>
                                <td>${item.NAME}</td>
                                <td>${item.DESCRIPTION}</td>
                                <td>${item.ACTIVE_FLAG}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- StackPath Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
