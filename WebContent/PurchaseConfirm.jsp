<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="java.lang.String" %>
<%@ page import="connect.DBConnection" %>
<%@ page import="java.util.*, java.text.*" %>

<%
String sessionName = (String)session.getAttribute("user_lastname") + " " + (String)session.getAttribute("user_firstname") ;
String sessionEmail = (String)session.getAttribute("user_email") ;
String sessionGrade = (String)session.getAttribute("user_grade") ;

String totalItemString = request.getParameter("totalItemString") ;
String totalIndex = request.getParameter("totalIndex") ;
String couponId = request.getParameter("couponId") ;
String totalPriceToString = request.getParameter("totalPriceDiscount") ;
String gradeRegular = "Regular" ;
String gradeVip = "VIP" ;
String gradeVVIP = "VVIP" ;

int vipFlag = 0 ;
int vvipFlag = 0 ;

java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = formatter.format(new java.util.Date());
out.println(currentTime);

int coupon_percent = 0 ;

if (couponId.equals("000000")) {
	coupon_percent = 30 ;
}
else if (couponId.equals("000005")) {
	coupon_percent = 10 ;
}
else {
	couponId.equals(null) ;
	coupon_percent = 0 ;
}

int totalPrice = Integer.parseInt(totalPriceToString);
int numIndex = Integer.parseInt(totalIndex) ;

out.println(totalPrice);
out.println(numIndex);
out.println(coupon_percent);
out.println(totalItemString);

String[] arrString = totalItemString.split(",") ;

try {
	
	Connection conn = DBConnection.getConnection() ;
	Statement st = conn.createStatement() ;
	ResultSet rs = null ;
	String sql = null ;
	
	for (int i = 1 ; i < numIndex+1 ; i ++) {
		String[] arrCode = arrString[i].split(" ") ;
		String item_code = arrCode[0] ;
		String item_sellerCode = arrCode[1] ;
				
		//purchase table input
		sql = "SELECT cart.*, items.item_price FROM cart JOIN items ON cart.item_code=items.item_code AND cart.seller_code=items.item_sellercode"
			+ " WHERE user_email='" + sessionEmail + "' AND cart.item_code='" + item_code + "' AND cart.seller_code='" + item_sellerCode + "'"  ;
		rs = st.executeQuery(sql) ;
		out.println("SELECT cart") ;
		int item_amount = 0 ;
		int item_price = 0 ;
		if (rs.next()){
			item_amount = rs.getInt("item_amount") ;
			item_price = rs.getInt("item_price") ;
		}
		
		sql = "INSERT INTO purchase VALUES('"+ sessionEmail+"','"+ item_amount+"','"
		+ coupon_percent+"','"+ currentTime +"','"+ item_price + "','"+ item_code+"','"+ item_sellerCode+"')";
		st.executeUpdate(sql) ;
		out.println("purchase INSERT") ;
		
		//items stock-- sales++
		sql = "UPDATE items SET item_stock=item_stock-'" + item_amount + "', item_sales=item_sales+'" + item_amount + "' WHERE item_code='"
			+ item_code + "' AND item_sellerCode='" + item_sellerCode + "'" ;
		st.executeUpdate(sql) ;
		out.println("items UPDATE") ;
	}
	//cart delete
	sql = "DELETE FROM cart WHERE user_email='"+ sessionEmail +"'" ;
	st.executeUpdate(sql) ;
	out.println("cart DELETE") ;
	
	//coupon delete -> email couponid
	if (!couponId.equals(null)) {
		sql = "DELETE FROM coupon WHERE coupon_email='"+ sessionEmail + "' AND coupon_id='"+ couponId + "'" ;
		st.executeUpdate(sql) ;
		out.println("coupon DELETE") ;
	}
	else out.println("coupon NO") ;
	
	//usergrade update ->upgrade -> coupon update
	sql = "SELECT * FROM usergrade WHERE email='" + sessionEmail + "'" ;
	rs = st.executeQuery(sql) ;
	
	int user_totalamount = 0 ;
	String userGrade = null ;
	if (rs.next()) {
		user_totalamount = rs.getInt("totalamount") ;
		userGrade = rs.getString("grade") ;
	}
	out.println(userGrade) ;
	
	int user_CurrentAmount = user_totalamount + totalPrice ;
	
	if (user_CurrentAmount >= 500000) {
		//regular - vvip
		if (gradeRegular.equals(userGrade)) {
			userGrade = "VVIP" ;
			out.println(userGrade) ;
			sql = "INSERT INTO coupon VALUES('"+sessionEmail+"', 'VVIP-Coupon', '30', '000000');"
				+ "INSERT INTO coupon VALUES('"+sessionEmail+"', 'VIP-Coupon', '10', '000005');";
			st.executeUpdate(sql) ;
			out.println("upgrade VVIP") ;
			vvipFlag = 1 ;
			vipFlag = 1 ;
		}
		//vip - vvip
		else if (gradeVip.equals(userGrade)) {
			userGrade = "VVIP" ;
			sql = "INSERT INTO coupon VALUES('"+sessionEmail+"', 'VVIP-Coupon', '30', '000000')" ;
			st.executeUpdate(sql) ;
			out.println("upgrade VVIP") ;
			vvipFlag = 1 ;
		}
		//vvip - vvip
		//else if (user_grade.equals("VVIP")) {
			
		//}
	}
	//else if (user_CurrentAmount < 200000) {
		//regular
	//}
	else if (user_CurrentAmount >= 200000 && user_CurrentAmount < 500000) {
		//regular - vip
		if (gradeRegular.equals(userGrade)) {
			userGrade="VIP" ;
			sql = "INSERT INTO coupon VALUES('"+sessionEmail+"', 'VIP-Coupon', '10', '000005')" ;
			st.executeUpdate(sql) ;
			out.println("upgrade VIP") ;
			vipFlag = 1 ;
		}
		//vip
		//else if (user_grade.equals("VIP")) {
		//	
		//}
	}
	out.println(userGrade) ;
	//usergrade update
	sql = "UPDATE usergrade SET totalamount='"+ user_CurrentAmount + "', grade='"+userGrade+"' "
		+ "WHERE email='"+sessionEmail+"'" ;
	st.executeUpdate(sql) ;
	out.println("grade UPDATE") ;
	
	
} catch (Exception e) {
	out.println("DB 연동 실패") ;
}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
function calls() {
	var vipFlag = <%=vipFlag %> ;
	var vvipFlag = <%=vvipFlag %> ;
	
	
	if (vipFlag == 1) {
		alert("축하합니다! VIP 등급이 되셨습니다. VIP 10% 할인쿠폰이 지급되었습니다.") ;
	}
	if (vvipFlag == 1) {
		alert("축하합니다! VVIP 등급이 되셨습니다. VVIP 30%쿠폰이 지급되었습니다.") ;
	}
	else {
		alert("결제가 완료 되었습니다. 감사합니다.") ;
	}
	document.form.submit() ;
}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>구입 명세서</title>
</head>
<body onLoad="calls()">
<form name="form" action="Main.jsp">
</form>

</body>


</html>











