<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String url = "jdbc:mysql://localhost:3306/spring5fs";
	String user = "root"; String pw = "1234";
	String sql_select = "select * from dept";
	String sql_ = "insert into dept values (?, ?, ?)";
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rset = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, pw);
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form>
		<label>DEPT 값 추가</label><br>
		<span>DEPTNO : </span><input type="text" name="deptno" />
		<span>DNAME : </span><input type="text" name="dname" />
		<span>LOC : </span><input type="text" name="loc" />
		<input type="button" onclick="" value="입력"/>
	</form>
	<table border=1>
		<tr>
			<th>DEPTNO</th>
			<th>DNAME</th>
			<th>LOC</th>
		</tr>
		
<%
	try {
		pstmt = conn.prepareStatement(sql_select);
		rset = pstmt.executeQuery();
		while (rset.next()) {
			%>
			<tr>
				<td><%=rset.getInt("deptno")%></td>
				<td><%=rset.getString("dname") %></td>
				<td><%=rset.getString("loc") %></td>
			</tr>
			<%
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rset != null) { try{rset.close();} catch (Exception e) {e.printStackTrace();}}
		if (pstmt != null) { try{pstmt.close();} catch (Exception e) {e.printStackTrace();}}
	}
%>
		
	</table>
</body>
</html>

<!-- 

insert, delete, update가 이루어지면 select 문으로 다시 dept 테이블 불러오기

사용자에게 입력 받아서 불러오기


 -->