<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
String fileName = request.getParameter("fileName");
if (fileName == null || fileName.trim().equals("")) {
    response.sendRedirect("fileList.jsp");
    return;
}

String uploadPath = "C:/upload";
String jdbcUrl = "jdbc:mysql://localhost:3306/파일업로드DB";
String dbId = "root";
String dbPass = "1234";

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // 파일 삭제
    File file = new File(uploadPath + File.separator + fileName);
    if (file.exists()) {
        file.delete();
    }

    // DB에서 레코드 삭제
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
    
    String sql = "DELETE FROM uploaded_files WHERE file_name = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, fileName);
    pstmt.executeUpdate();
    
    out.println("<script>alert('파일이 성공적으로 삭제되었습니다.'); location.href='fileList.jsp';</script>");
    
} catch(Exception e) {
    out.println("오류 발생: " + e.getMessage());
} finally {
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}
%> 