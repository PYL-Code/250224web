<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>파일 목록</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>업로드된 파일 목록</h2>
    <table>
        <tr>
            <th>파일명</th>
            <th>설명</th>
            <th>업로드 날짜</th>
            <th>다운로드</th>
            <th>삭제</th>
        </tr>
        <%
        String jdbcUrl = "jdbc:mysql://localhost:3306/파일업로드DB";
        String dbId = "root";
        String dbPass = "1234";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
            
            String sql = "SELECT * FROM uploaded_files ORDER BY upload_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                %>
                <tr>
                    <td><%=rs.getString("original_file_name")%></td>
                    <td><%=rs.getString("description")%></td>
                    <td><%=rs.getString("upload_date")%></td>
                    <td><a href="download.jsp?fileName=<%=rs.getString("file_name")%>">다운로드</a></td>
                    <td>
                        <a href="#" onclick="deleteFile('<%=rs.getString("file_name")%>')">삭제</a>
                    </td>
                </tr>
                <%
            }
        } catch(Exception e) {
            out.println("오류 발생: " + e.getMessage());
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
        %>
    </table>
    <br>
    <a href="fileUpload.jsp">파일 업로드 페이지로 이동</a>
    
    <script>
    function deleteFile(fileName) {
        if(confirm('정말로 이 파일을 삭제하시겠습니까?')) {
            location.href = 'deleteFile.jsp?fileName=' + fileName;
        }
    }
    </script>
</body>
</html> 