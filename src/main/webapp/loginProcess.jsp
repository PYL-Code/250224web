<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String empno = request.getParameter("empno");
    String ename = request.getParameter("ename");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String jdbcUrl = "jdbc:mysql://" + System.getenv("MYSQL_HOST") + ":3306/" + System.getenv("MYSQL_DATABASE");
    String username = System.getenv("MYSQL_USER");
    String password = System.getenv("MYSQL_PASSWORD");
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, username, password);
        
        String sql = "SELECT * FROM emp WHERE empno=? AND ename=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, empno);
        pstmt.setString(2, ename);
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            session.setAttribute("empno", empno);
            session.setAttribute("ename", ename);
            response.sendRedirect("main.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 