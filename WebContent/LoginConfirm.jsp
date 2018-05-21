<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="connect.DBConnection" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Login Confirm</title>
</head>
<body>
<%
try {
	Connection conn = DBConnection.getConnection() ;

	String user_email = request.getParameter("login_email") ;
	String user_pw = request.getParameter("login_pw") ;
	String user_lastName = null ;
	String user_firstName = null ;
	String user_grade = null ;


 	Statement st = conn.createStatement() ;
	String sql = "SELECT * FROM users WHERE user_email='" + user_email + "' AND user_password='" + user_pw + "'";
	ResultSet rs = st.executeQuery(sql);

	Boolean isLogin = false ;

	while(rs.next()) {
		isLogin = true ;
		user_lastName = rs.getString("user_lastname") ;
		user_firstName = rs.getString("user_firstname") ;
	}
	
	sql = "SELECT * FROM usergrade WHERE email='" + user_email + "'" ;
	rs = st.executeQuery(sql);
	if (rs.next()) user_grade = rs.getString("grade") ;
	
	conn.close() ;
	rs.close() ;
	st.close() ;
	if (isLogin) {
		session.setAttribute("user_email", user_email) ;
		session.setAttribute("user_lastname", user_lastName) ;
		session.setAttribute("user_firstname", user_firstName) ;
		session.setAttribute("user_grade", user_grade) ;
			
		response.sendRedirect("Main.jsp") ;
	} else {
		%> <script> alert("로그인 실패"); history.go(-1); </script> <%
	}
} catch (Exception e) {       
    out.println("DB 연동 실패");
}

%>
</body>
</html>