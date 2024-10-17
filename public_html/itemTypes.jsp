<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Item Types</title>
</head>
<body>
    <h1>Item Types</h1>
    <table border="1">
        <tr>
            <th>Type ID</th>
            <th>Category ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Active Flag</th>
        </tr>
        <c:forEach var="itemType" items="${itemTypes}">
            <tr>
                <td>${itemType.itemTID}</td>
                <td>${itemType.itemCID}</td>
                <td>${itemType.itemType}</td>
                <td>${itemType.itemTypeDescription}</td>
                <td>${itemType.activeFlag}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>