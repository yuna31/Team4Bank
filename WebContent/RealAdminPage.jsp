<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="java.lang.String" %>
<%@ page import="connect.DBConnection" %>
<%@ page import="java.util.*, java.text.*" %>

<%
String user_email = request.getParameter("user") ;
String seller_name = request.getParameter("seller") ;
String time1 = request.getParameter("time1") ;
String time2 = request.getParameter("time2") ;
String[] T1 = time1.split("-") ;
String[] T2 = time2.split("-") ;

out.println("t1 : " + time1) ;
out.println("t2 : " + time2) ;

session.setAttribute("user", user_email) ;
session.setAttribute("seller", seller_name) ;
try {
	Connection conn = DBConnection.getConnection() ;
	Statement st = conn.createStatement() ;
	ResultSet rs = null ;
	

	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy");
	int currentYear = Integer.parseInt(formatter.format(new java.util.Date())) ;
%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Admin Page</title>
</head>
<body>
<div style="float:right"> <input type="button" value="나가기" onClick="location.href='Login.jsp'"> </div>
	<h1> PNU IPS 관리자 </h1>
	
<br />
<h3> A) 클라이언트의 구매 기록 </h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">구매자</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="100">구매수량</td>
<td width="150">구매시간</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>

<%
	String sql = "select user_email, item_name, item_brand, item_price, purchase_amount, purchase_time " 
			+ "from purchase join items on purchase.item_code=items.item_code AND purchase.seller_code=items.item_sellercode "
			+ "WHERE user_email='"+ user_email +"'" ;
	rs = st.executeQuery(sql) ;
	int index = 0 ;
	while (rs.next()) {
		index++ ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int item_price = rs.getInt("item_price") ;
		int purchase_amount = rs.getInt("purchase_amount") ;
		String purchase_time = rs.getString("purchase_time") ; 
		%>
		<tr height="25" align="center">
			<td align="left"><%=index %></td>
			<td align="left"><%=user_email %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=item_price %></td>
			<td align="left"><%=purchase_amount %></td>
			<td align="left"><%=purchase_time %></td>
		</tr>
		<%
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
</table>

<br />
<h3> B, C) 판매자 판매 기록, 판매량 </h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="6" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">판매자</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="150">판매량</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="6" width="752"></td></tr>

<%
	
	sql = "select seller_name, item_name, item_brand, item_price, item_sales "
		+ "from items join seller on items.item_sellercode=seller.seller_code AND items.item_code=seller.seller_itemcode "
		+ "WHERE seller_name='"+ seller_name +"'" ;
	index= 0 ;
	rs = st.executeQuery(sql) ;
	while (rs.next()) {
		index++ ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int item_price = rs.getInt("item_price") ;
		int item_sales = rs.getInt("item_sales") ;
		%>
		<tr height="25" align="center">
			<td align="left"><%=index %></td>
			<td align="left"><%=seller_name %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=item_price %></td>
			<td align="left"><%=item_sales %></td>
		</tr>
		<%
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="6" width="752"></td></tr>
</table>

<br />
<h3> D) 일정 기간 동안 가장 잘 팔린 물품 3개</h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="100">판매량</td>
<td width="100">총 수입</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>

<%
	
	sql = "select item_name, item_brand, item_price, purchase_amount, purchase_time " 
		+ "from purchase join items on purchase.item_code=items.item_code AND purchase.seller_code=items.item_sellercode" ;

	rs = st.executeQuery(sql) ;
	int count = 0 ;
	while (rs.next()) {
		count++ ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int item_price = rs.getInt("item_price") ;
		int purchase_amount = rs.getInt("purchase_amount") ;
		String purchase_time = rs.getString("purchase_time") ;
		String[] date = purchase_time.split("-") ;
		%>
		<tr height="25" align="center">
			<td align="left"><%=count %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=item_price %></td>
			<td align="left"><%=purchase_amount %></td>
			<td align="left"><%=purchase_time %></td>
		</tr>
		<%
		if (count==3) break ;
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>
</table>


<br />
<h3> E) 판매하지는 않지만 가장 수입이 높은 10개 제품 </h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">판매자</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="100">판매량</td>
<td width="100">총 수입</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>

<%
	
	sql = "select seller_name, item_name, item_brand, item_price, item_sales, (item_price*item_sales) as totalprice "
		+ "from items join seller on items.item_sellercode=seller.seller_code AND items.item_code=seller.seller_itemcode "
		+ "WHERE seller_name<>'"+ seller_name +"' "
		+ "ORDER BY totalprice DESC ";

	rs = st.executeQuery(sql) ;
	count = 0 ;
	while (rs.next()) {
		count++ ;
		String difseller_name = rs.getString("seller_name") ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int item_price = rs.getInt("item_price") ;
		int item_sales = rs.getInt("item_sales") ;
		int totalprice = rs.getInt("totalprice") ;
		%>
		<tr height="25" align="center">
			<td align="left"><%=count %></td>
			<td align="left"><%=difseller_name %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=item_price %></td>
			<td align="left"><%=item_sales %></td>
			<td align="left"><%=totalprice %></td>
		</tr>
		<%
		if (count==10) break ;
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>
</table>

<br />
<h3> F) cart에 담긴 총량보다 잔고가 적은 아이템 </h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="100">재고 수</td>
<td width="100">카트 총량</td>
<td width="100">해당 사용자</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>

<%	
	sql = "select item_name, item_brand, item_price, item_stock, item_amount, user_email "
		+ "from items join cart on items.item_code=cart.item_code AND items.item_sellercode=cart.seller_code "
		+ "WHERE item_stock < item_amount " ;
	index = 0 ;
	rs = st.executeQuery(sql) ;
	while (rs.next()) {
		index++ ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int item_price = rs.getInt("item_price") ;
		int item_stock = rs.getInt("item_stock") ;
		int item_amount = rs.getInt("item_amount") ;
		String user_emailCart = rs.getString("user_email") ;
		%>
		<tr height="25" align="center">
			<td align="left"><%=index %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=item_price %></td>
			<td align="left"><%=item_stock %></td>
			<td align="left"><%=item_amount %></td>
			<td align="left"><%=user_emailCart %></td>
		</tr>
		<%
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>
</table>

<br />
<h3> G) 20~30대에 인기 있는 아이템 </h3>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="900"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="25">No</td>
<td width="100">물품명</td>
<td width="100">브랜드</td>
<td width="100">가격</td>
<td width="100">판매량</td>
<td width="100">해당 사용자</td>
<td width="100">나이</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>

<%	
	sql = "select item_name, item_brand, purchase_price, item_sales, users.user_email, user_birth "
		+ "from (select user_email, purchase_price, item_name, item_brand, item_sales "
		+ "from purchase join items on purchase.item_code=items.item_code AND purchase.seller_code=items.item_sellercode)as tb join users on tb.user_email=users.user_email "
		+ "order by item_sales DESC";

	rs = st.executeQuery(sql) ;
	count = 0 ;
	while (rs.next()) {
		count++ ;
		String item_name = rs.getString("item_name") ;
		String item_brand = rs.getString("item_brand") ;
		int purchase_price = rs.getInt("purchase_price") ;
		int item_sales = rs.getInt("item_sales") ;
		
		String user_birth = rs.getString("user_birth") ;
		String[] birth = user_birth.split("-") ;
		int age = currentYear - Integer.parseInt(birth[0]) + 1 ;
		String user_emailBirth = rs.getString("user_email") ;
		
		if ( age > 30 ) {
			count = count - 1 ;
			continue ;
		}
		else if ( age < 20 ) {
			count = count - 1 ;
			continue ;
		}
		
		%>
		<tr height="25" align="center">
			<td align="left"><%=count %></td>
			<td align="left"><%=item_name %></td>
			<td align="left"><%=item_brand %></td>
			<td align="left"><%=purchase_price %></td>
			<td align="left"><%=item_sales %></td>
			<td align="left"><%=user_emailBirth %></td>
			<td align="left"><%=age %></td>
		</tr>
		<%
		if (count==10) break ;
	}
	%>
<tr height="1" bgcolor="#82B5DF"><td colspan="7" width="752"></td></tr>
</table>
<%
	
} catch (Exception e) {
	out.println("DB 연동 실패") ;
}

%>
</body>
</html>