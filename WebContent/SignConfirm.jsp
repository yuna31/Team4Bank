
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="connect.DBConnection" %>

<%
String user_email = request.getParameter("JOIN_Email") ;
String user_pw = request.getParameter("JOIN_pw") ;
String user_lastname = request.getParameter("JOIN_lastname") ;
String user_firstname = request.getParameter("JOIN_firstname") ;
String user_birth = request.getParameter("JOIN_birth") ;
int totalamount = 0 ;
int coupon_percent = 0 ;
String user_grade = "Regular" ;

Connection conn = DBConnection.getConnection() ;

try {
	
	Statement st = conn.createStatement() ;	
	String sql = "INSERT INTO users VALUES ('"
		+ user_email + "','"
		+ user_pw + "','"
		+ user_firstname + "','"
		+ user_lastname + "','"
		+ user_birth + "')" ;
	
	st.executeUpdate(sql) ;
	
	sql = "INSERT INTO usergrade VALUES ('"
			+ user_email + "','" 
			+ totalamount +"','"
			+ user_grade + "')";
	st.executeUpdate(sql) ;
	
	response.sendRedirect("Login.jsp") ;
	
} catch (Exception e) {
	out.println("DB 연동 실패") ;
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
function calls() {
	alert("가입이 완료되었습니다.");
	document.form.submit() ;
}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Sign Confirm</title>
</head>
<body onLoad="calls()">
<form name="form" action="Main.jsp">
</form>
<script>
</script>
</body>
</html>

