<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
String fileName = request.getParameter("fileName");
if (fileName == null || fileName.trim().equals("")) {
    response.sendRedirect("fileList.jsp");
    return;
}

// 데이터베이스에서 원본 파일명 조회
String originalFileName = "";
String jdbcUrl = "jdbc:mysql://localhost:3306/파일업로드DB";
String dbId = "root";
String dbPass = "1234";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
    
    String sql = "SELECT original_file_name FROM uploaded_files WHERE file_name = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, fileName);
    rs = pstmt.executeQuery();
    
    if(rs.next()) {
        originalFileName = rs.getString("original_file_name");
    }
} catch(Exception e) {
    out.println("오류 발생: " + e.getMessage());
    return;
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e) {}
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}

// 파일 다운로드 처리
String uploadPath = "C:/upload";
File file = new File(uploadPath + File.separator + fileName);

if (!file.exists()) {
    response.sendRedirect("fileList.jsp");
    return;
}

// 파일 다운로드를 위한 응답 헤더 설정
response.setContentType("application/octet-stream");
response.setHeader("Content-Transfer-Encoding", "binary");
response.setHeader("Content-Disposition", "attachment; filename=\"" + 
    new String(originalFileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");

try {
    FileInputStream fis = new FileInputStream(file);
    ServletOutputStream sos = response.getOutputStream();
    
    byte[] buffer = new byte[4096];
    int numRead;
    
    while ((numRead = fis.read(buffer, 0, buffer.length)) != -1) {
        sos.write(buffer, 0, numRead);
    }
    
    sos.flush();
    fis.close();
    sos.close();
} catch(Exception e) {
    out.println("파일 다운로드 중 오류 발생: " + e.getMessage());
}
%> 