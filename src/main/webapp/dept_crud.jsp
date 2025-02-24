<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>부서 관리 시스템</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
    </style>
</head>
<body>
    <h2>부서 관리 시스템</h2>
    
    <!-- 검색 폼 추가 -->
    <div style="margin-bottom: 20px;" >
    	<form method="get">
    		<select name="searchType">
    			<option value="deptno">부서번호</option>
    			<option value="dname">부서이름</option>
    		</select>
    		<input type="text" name="searchKeyword" placeholder="검색어를 입력하세요">
    		<input type="submit" value="검색">
    	</form>
    </div>
    
    <%	
    	// 한글처리
    	request.setCharacterEncoding("UTF-8");
    	
        // DB 연결 정보
        String url = "jdbc:mysql://localhost:3306/spring5fs";
        String username = "root";
        String password = "1234";
        
        Connection conn = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);
            
            // CREATE 처리
            if (request.getParameter("action") != null && request.getParameter("action").equals("create")) {
                String deptno = request.getParameter("deptno");
                String dname = request.getParameter("dname");
                String loc = request.getParameter("loc");
                
                // 여기
                System.out.println("1");
                PreparedStatement pstmt = conn.prepareStatement("insert into dept values (?, ?, ?)");
              //pstmt.setInt(1, Integer.parseInt(deptno));
                pstmt.setString(1, deptno);
                pstmt.setString(2, dname);
                pstmt.setString(3, loc);
                pstmt.executeUpdate();
            }
            
            // UPDATE 처리
            if (request.getParameter("action") != null && request.getParameter("action").equals("update")) {
                String deptno = request.getParameter("deptno");
                String dname = request.getParameter("dname");
                String loc = request.getParameter("loc");
                
               // 여기
                System.out.println("2");
               PreparedStatement pstmt = conn.prepareStatement("update dept set dname=?, loc=? where deptno=?");
               pstmt.setString(1, dname);
               pstmt.setString(2, loc);
               pstmt.setString(3, deptno);
               pstmt.executeUpdate();
            }
            
            // DELETE 처리
            if (request.getParameter("action") != null && request.getParameter("action").equals("delete")) {
                String deptno = request.getParameter("deptno");
                
                // 여기
                System.out.println("3");
                PreparedStatement pstmt = conn.prepareStatement("delete from dept where deptno=?");
                pstmt.setString(1, deptno);
                pstmt.executeUpdate();
            }
    %>
    
    <!-- 입력 폼 -->
    <h3>새 부서 추가</h3>
    <form method="post">
        <input type="hidden" name="action" value="create">
        부서번호: <input type="text" name="deptno" required>
        부서이름: <input type="text" name="dname" required>
        지역: <input type="text" name="loc" required>
        <input type="submit" value="추가">
    </form>
    
    <!-- READ: 부서 목록 표시 -->
    <h3>부서 목록</h3>
    <table>
        <tr>
            <th>부서번호</th>
            <th>부서이름</th>
            <th>지역</th>
            <th>작업</th>
        </tr>
        <%
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM dept");
            
            while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("deptno") %></td>
            <td><%= rs.getString("dname") %></td>
            <td><%= rs.getString("loc") %></td>
            <td>
                <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="deptno" value="<%= rs.getString("deptno") %>">
                    <input type="submit" value="삭제">
                </form>
                <button onclick="showUpdateForm('<%= rs.getString("deptno") %>', '<%= rs.getString("dname") %>', '<%= rs.getString("loc") %>')">수정</button>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    
    <!-- 수정 폼 (기본적으로 숨겨져 있음) -->
    <div id="updateForm" style="display: none;">
        <h3>부서 정보 수정</h3>
        <form method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="deptno" id="update_deptno">
            부서이름: <input type="text" name="dname" id="update_dname" required>
            지역: <input type="text" name="loc" id="update_loc" required>
            <input type="submit" value="수정">
        </form>
    </div>
    
    <script>
        function showUpdateForm(deptno, dname, loc) {
            document.getElementById('updateForm').style.display = 'block';
            document.getElementById('update_deptno').value = deptno;
            document.getElementById('update_dname').value = dname;
            document.getElementById('update_loc').value = loc;
        }
    </script>
    
    <%
        } catch(Exception e) {
            out.println("오류 발생: " + e.getMessage());
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    %>
</body>
</html> 