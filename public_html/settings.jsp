<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Settings</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="<%=request.getContextPath()%>/css/sidebar.css" rel="stylesheet"/>
</head>
<body>
    <div class="d-flex vh-100">
       
        <jsp:include page="sidebar.jsp"/>
        
        <div class="flex-grow-1 p-4">
            <div class="container">
                <h1 class="my-4">Settings</h1>
                <div class="row">
                    <!-- Service Providers Card -->
                    <div class="col-md-6">
                        <div class="card text-center mb-4">
                            <div class="card-body">
                                <div class="mb-3">
                                    <span class="display-1"><i class="fas fa-cogs"></i></span>
                                </div>
                                <h5 class="card-title">Service Providers</h5>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="card text-center mb-4">
                         <a href='#'>
                            <div class="card-body">
                                <div class="mb-3">
                                    <span class="display-1"><i class="fas fa-users"></i></span>
                                </div>
                                <h5 class="card-title">Item Users</h5>
                            </div>
                            </a>
                        </div>
                    </div>
                </div>
                 <div class="row">
            
                    <div class="col-md-6">
                        <div class="card text-center mb-4">
                            <div class="card-body">
                            <a href='#'>
                                <div class="mb-3">
                                    <span class="display-1"><i class="fas fa-users"></i></span>
                                </div>
                                <h5 class="card-title">QR management</h5>
                             </a>
                             </div>
                          
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</body>
</html>
