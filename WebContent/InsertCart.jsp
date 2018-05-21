<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="java.lang.String" %>
<%@ page import="connect.DBConnection" %>

<%
String sessionEmail = (String)session.getAttribute("user_email") ;

String selectedValue = request.getParameter("arrSelValue") ;
String numOfItemOfString = request.getParameter("sendNumOfItem") ;
int numOfItem = 0 ;

if (numOfItemOfString != "") {
	numOfItem = Integer.parseInt(numOfItemOfString) ;
}

String[] arrString = selectedValue.split(" ") ;

String item_code = arrString[0] ;
String item_sellerCode = arrString[1] ;

try {
	Connection conn = DBConnection.getConnection() ;
	Statement st = conn.createStatement() ;
	String sql = "SELECT * FROM cart WHERE user_email='" + sessionEmail + "' AND item_code='" 
			+ item_code + "' AND seller_code='" + item_sellerCode + "'"  ;
	ResultSet rs = st.executeQuery(sql) ;
	
	if (rs.next()) {
		int item_amount = rs.getInt("item_amount") + numOfItem ;
		sql = "UPDATE cart SET item_amount='" + item_amount + "' WHERE user_email='" + sessionEmail + "' AND item_code='" 
			+ item_code + "' AND seller_code='" + item_sellerCode + "'"  ;
		st.executeUpdate(sql) ;
	}
	else {
		sql = "INSERT INTO cart VALUES('"+ sessionEmail + "','" + item_code + "','"+ numOfItem + "', '" + item_sellerCode +"')" ;
		st.executeUpdate(sql) ;
	}
	
	response.sendRedirect("Cart.jsp") ;
	
} catch (Exception e) {
	out.println("DB 연동 실패") ;
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
</body>
</html>