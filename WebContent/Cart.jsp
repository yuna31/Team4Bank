<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="java.lang.String" %>
<%@ page import="connect.DBConnection" %>

<%
String sessionName = (String)session.getAttribute("user_lastname") + " " + (String)session.getAttribute("user_firstname") ;
String sessionEmail = (String)session.getAttribute("user_email") ;
String sessionGrade = (String)session.getAttribute("user_grade") ;
int total = 0 ;

try {
	//count cart tuple
	Connection conn = DBConnection.getConnection() ;
	Statement st = conn.createStatement() ;
	String sqlCount = "SELECT COUNT(*) FROM cart WHERE user_email='" + sessionEmail + "';" ;
	ResultSet rs = st.executeQuery(sqlCount) ;
	if (rs.next()) {
		total = rs.getInt(1) ;
	}
	rs.close() ;	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<script>
function purchaseButton() {
	//form2
	var selectedCoupon = document.getElementsByName("selectedCoupon") ;
	var flag = 0 ;
	
	for (i = 0 ; i < selectedCoupon.length ; i ++) {
		if (selectedCoupon[i].checked) {
			document.form2.WhatCouponId.value = selectedCoupon[i].value ;
			flag = 1 ;
			break ;
		}
	}
	
	//no Check
	if (flag == 0) {
		alert("쿠폰을 적용하지 않습니다") ;
		return true ;
	}
	else {
		alert("쿠폰을 적용했습니다") ;
		return true ;
	}
	
}

function deleteButton() {
	
	//form3
	var deleteItem = document.getElementsByName("deleteItem") ;
	
	var deleteItemNum = document.getElementById("deleteItemNum").value ;
	document.form3.numOfDelete.value = deleteItemNum ;
	
	var flag = 0 ;	
	for (i = 0 ; i < deleteItem.length ; i ++) {
		if (deleteItem[i].checked) {
			document.form3.arrSelValue.value = deleteItem[i].value ;
			flag = 1 ;
			break ;
		}
	}
	//no Check
	if (flag == 0) {
		alert("물품을 선택해주세요...") ;
		return false ;
	}
	else if (deleteItemNum == "" || deleteItemNum==null || deleteItemNum==0 ) {
		alert("물품은 1개 이상 지울 수 있습니다....") ;
		return false ;
	}
	else {
		alert("삭제했습니다.") ;
		return true ;
	}
	
}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Cart</title>
</head>
<body>
<h1> PNU IPS 카트 </h1> 
<div style="float:right"> [<%=sessionGrade%>] <%=sessionName%> 님  환영합니다~ <input type="button" value="로그아웃" onClick="location.href='Logout.jsp'"> </div>

<br />
<form name="form3" action="CartDelete.jsp" method="post" onsubmit="return deleteButton()">
<P align="right"> 삭제할 갯수  : <input type="text" id="deleteItemNum" style="width:20px"/> <button> 삭제 </button></P>
<input type="hidden" name="numOfDelete" value=""/>
<input type="hidden" name="arrSelValue" value=""/>
</form>
<%
out.print("총 물품 수 : " + total + "개") ;
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="30">No</td>
<td width="120">물품명</td>
<td width="100">브랜드</td>
<td width="120">가격</td>
<td width="60">재고</td>
<td width="60">판매량</td>
<td width="50" style="color:red"><strong>구입 수량</strong></td>
<td width="25">삭제</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>

<%	
	int index = 0 ;
	String sql = "SELECT items.*, cart.item_amount FROM items JOIN cart ON "
			+ "items.item_code=cart.item_code AND items.item_sellerCode=cart.seller_code "
			+ "WHERE user_email='" + sessionEmail + "'";
	rs = st.executeQuery(sql) ;
	
	while (rs.next()) {
		index++ ;
		String item_name = rs.getString("item_name");
		String item_brand = rs.getString("item_brand") ;
		String item_price = rs.getString("item_price") ;
		int item_numOfStock = rs.getInt("item_stock") ;
		int item_numOfSales = rs.getInt("item_sales") ;
		int item_amount = rs.getInt("item_amount") ;
		
		String item_itemCode = rs.getString("item_code") ;
		String item_sellerCode = rs.getString("item_sellercode") ;
		String item_key = item_itemCode +" "+ item_sellerCode ;
		
	%>
	<tr height="25" align="center">
		<td align="left"><%=index %></td>
		<td align="left"><%=item_name %></td>
		<td align="left"><%=item_brand %></td>
		<td align="left"><%=item_price %></td>
		<td align="left"><%=item_numOfStock %></td>
		<td align="left"><%=item_numOfSales %></td>
		<td align="center" style="color:red"><strong><%=item_amount %></strong></td>
		<td align="center"><input type="radio" name="deleteItem" value="<%=item_key%>"/></td>
	</tr>
	<%
	}
	%>

<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>
</table>
<br />
<br />
<button onClick='history.back();'> 뒤로 </button>
<div style="text-align:center">※ 보유하고 있는 쿠폰 ※  </div>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="3" width="200"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="150">쿠폰명</td>
<td width="100">할인율</td>
<td width="25">선택</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="3" width=200></td></tr>

<%	
	//find coupon

	String sqlCoupon = "SELECT * FROM coupon WHERE coupon_email='"+ sessionEmail + "'" ;
	Statement st2 = conn.createStatement() ;
	ResultSet rs1 = st2.executeQuery(sqlCoupon) ;

	while (rs1.next()) {
		String coupon_grade = rs1.getString("coupon_grade") ;
		String coupon_id = rs1.getString("coupon_id") ;
		int coupon_percent = rs1.getInt("coupon_percent") ;
	%>
	<tr height="25" align="center">
		<td align="left"><%=coupon_grade %></td>
		<td align="left" style="color:red"><strong><%=coupon_percent%> % </strong></td>
		<td align="left"><input type="radio" name="selectedCoupon" value="<%=coupon_id%>"/></td>
	</tr>
	<%
	}
} catch (Exception e) {
	out.println("DB 연동 실패") ;
}
%>
<tr height="1" bgcolor="#82B5DF"><td colspan="3" width="200"></td></tr>
</table>

<form name="form2" action="Purchase.jsp" method="post" onsubmit="return purchaseButton()">
<P align="right"> <button> Purchase </button></P>
<input type="hidden" name="WhatCouponId" value=""/>
</form>
</body>
</html>
