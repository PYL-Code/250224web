<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.File"%>

<%
// 업로드 경로를 C:/upload로 변경
String uploadPath = "C:/upload";
// 업로드 디렉토리가 없으면 생성
File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) {
    uploadDir.mkdirs();
}

int maxSize = 10 * 1024 * 1024; // 최대 10MB
String encoding = "UTF-8";

MultipartRequest multi = new MultipartRequest(request, uploadPath, maxSize,
        encoding, new DefaultFileRenamePolicy());

String fileName = multi.getFilesystemName("uploadFile");
String description = multi.getParameter("description");
String originalFileName = multi.getOriginalFileName("uploadFile");

// 데이터베이스 연결 정보
String jdbcUrl = "jdbc:mysql://localhost:3306/파일업로드DB";
String dbId = "root";
String dbPass = "1234";

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
    
    String sql = "INSERT INTO uploaded_files (file_name, original_file_name, description, upload_date) VALUES (?, ?, ?, NOW())";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, fileName);
    pstmt.setString(2, originalFileName);
    pstmt.setString(3, description);
    
    pstmt.executeUpdate();
    
    out.println("<script>alert('파일이 성공적으로 업로드되었습니다.'); location.href='fileList.jsp';</script>");
    
} catch(Exception e) {
    out.println("오류 발생: " + e.getMessage());
} finally {
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}
%> 