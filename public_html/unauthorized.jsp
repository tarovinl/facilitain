<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized - Facilitain</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    <style>
        body {
            font-family: 'NeueHaasLight', sans-serif !important;
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .unauthorized-container {
            background: white;
            border-radius: 8px;
            padding: 2.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .logo {
            max-width: 200px;
            height: auto;
            margin-bottom: 1.5rem;
        }
        
        .error-icon {
            font-size: 3rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        
        h1 {
            font-family: 'NeueHaasMedium', sans-serif !important;
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .message {
            color: #495057;
            margin-bottom: 2rem;
            line-height: 1.5;
            font-weight: 500;
        }
        
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
            padding: 0.5rem 1.5rem;
            border-radius: 4px;
            transition: all 0.2s ease;
            background: transparent;
            text-decoration: none;
        }
        
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="unauthorized-container">
        <img src="<%=request.getContextPath()%>/resources/images/facilitain-home-logo.png" alt="Facilitain Logo" class="logo">
        
        <div class="error-icon">⚠️</div>
        
        <h1>Unauthorized</h1>
        
        <p class="message">This page is unauthorized. Please contact your administrator for access.</p>
        
        <button onclick="history.back()" class="btn btn-outline-secondary">
            Go Back
        </button>
    </div>
</body>
</html>