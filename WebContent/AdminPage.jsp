<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="java.lang.String" %>
<%@ page import="connect.DBConnection" %>

<%
String selectedUserEmail = (String)session.getAttribute("user_email") ;
String selectedSellerName = (String)session.getAttribute("seller_name") ;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>

function goPage() {
}

function change_user(form) {
	var uservalue = form.user_email.options[form.user_email.selectedIndex].value ;
	document.form4.user.value = uservalue ;
}

function change_seller(form) {
	var sellervalue = form.seller_name.options[form.seller_name.selectedIndex].value ;
	document.form4.seller.value = sellervalue
}

</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>관리자 페이지</title>
</head>
<body>
<div style="float:right"> <input type="button" value="나가기" onClick="location.href='Login.jsp'"> </div>
	<h1> PNU IPS 관리자 </h1>
	
<%
try {
	Connection conn = DBConnection.getConnection() ;
	Statement st = conn.createStatement() ;
	String sql = "SELECT user_email FROM users" ;
	ResultSet rs = st.executeQuery(sql) ;
	%>
	<form name="userform" method="post">
	<select name="user_email" style="height:25px" onchange="change_user(this.form)">
	<option value=""> 사용자 선택 </option>

	<%
	while(rs.next()) {
		String user_email = rs.getString("user_email") ;
		%>
		<option value="<%=user_email%>"> <%=user_email%> </option>
		<%
				
	}
	sql = "SELECT DISTINCT seller_name FROM seller" ;
	rs = st.executeQuery(sql) ;
%>

</select></form> <form name="sellerform" method="post"><select name="seller_name" style="height:25px" onchange="change_seller(this.form)">
<option value=""> 판매자 선택 </option>
<%
	while(rs.next()) {
		String seller_name = rs.getString("seller_name") ;
		%>
		<option value="<%=seller_name%>"> <%=seller_name%> </option>
		<%
	}
%>
</select></form>

<h4> 일정 기간  T1 ~ T2 </h4>
<form name="form4" action="RealAdminPage.jsp" method="post" onsubmit="goPage()">

 <table border="0">
	 <tr>
	     <th> T1 </th> <td> <input name="time1" type="text" > YYYY-MM-DD </td>
	 </tr>
	 <tr>
	     <th> T2 </th> <td> <input name="time2" type="text"> YYYY-MM-DD </td>
	 </tr>
</table>
<button> GO </button>
<input type="hidden" name="user" value=""/>
<input type="hidden" name="seller" value=""/>
</form>

</body>

<%
	} catch (Exception e) {
		out.println("DB 연동 실패") ;
	}
%>


</html>