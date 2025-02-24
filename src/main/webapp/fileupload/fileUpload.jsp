<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>파일 업로드</title>
</head>
<body>
    <h2>파일 업로드</h2>
    <form action="uploadProcess.jsp" method="post" enctype="multipart/form-data">
        파일 설명: <input type="text" name="description"><br><br>
        파일 선택: <input type="file" name="uploadFile"><br><br>
        <input type="submit" value="업로드">
    </form>
</body>
</html> 