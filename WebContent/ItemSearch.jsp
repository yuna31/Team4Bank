<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="connect.DBConnection" %>

<%
String search_itemName = request.getParameter("search_itemName") ;
String sessionName = (String)session.getAttribute("user_lastname") + " " + (String)session.getAttribute("user_firstname") ;
String sessionGrade = (String)session.getAttribute("user_grade") ;
Connection conn = DBConnection.getConnection() ;
int total = 0 ;

try {
	Statement st = conn.createStatement() ;
	String sqlCount = "SELECT COUNT(*) FROM items WHERE item_name='" + search_itemName + "';" ;
	ResultSet rs = st.executeQuery(sqlCount) ;
	if (rs.next()) {
		total = rs.getInt(1) ;
	}
	rs.close() ;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
function cartButton() {
	var selectedItem = document.getElementsByName("selectedItem") ;
	
	var numOfItem = document.getElementById("numOfItem").value ;
	document.form1.sendNumOfItem.value = numOfItem ;
	var flag = 0 ;
	
	for (i = 0 ; i < selectedItem.length ; i ++) {
		if (selectedItem[i].checked) {
			document.form1.arrSelValue.value = selectedItem[i].value ;
			flag = 1 ;
			break ;
		}
	}
	//no Check
	if (flag == 0) {
		alert("물품을 선택해주세요...") ;
		return false ;
	}
	else if (numOfItem == "" || numOfItem==null || numOfItem==0 ) {
		alert("물품은 1개 이상 담을 수 있습니다....") ;
		return false ;
	}
	else {
		alert("카트에 담았습니다.") ;
		return true ;
	}
	
}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>물품 검색</title>
</head>
<body>
<div style="float:right"> [<%=sessionGrade%>] <%=sessionName%> 님  환영합니다~ <input type="button" value="로그아웃" onClick="location.href='Logout.jsp'"> </div>
<input type="button" value="카트" onClick="location.href='Cart.jsp'">
<h1> PNU IPS 검색 </h1>

<%
out.print("총 검색결과 : " + total + "개") ;
%>

<br />
<br />
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>
<tr height="5"><td width="5"></td></tr>
<tr>
<td width="30">No</td>
<td width="120">물품명</td>
<td width="100">브랜드</td>
<td width="120">가격</td>
<td width="80">판매자</td>
<td width="60">재고</td>
<td width="60">판매량</td>
<td width="25">선택</td>
</tr>
<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>

<%	
	int index = 0 ;
	String sql = "SELECT DISTINCT item_code, item_name, item_price, item_brand, item_sellercode, item_stock, item_sales, seller_name"
				+ " FROM items JOIN seller ON items.item_sellerCode = seller.seller_code"
				+ " WHERE item_name='" + search_itemName + "'"
				+ " ORDER BY item_code ASC;" ;
	rs = st.executeQuery(sql) ;
	
	while (rs.next()) {
		index++ ;
		String item_name = rs.getString("item_name");
		String item_brand = rs.getString("item_brand") ;
		String item_price = rs.getString("item_price") ;
		String item_sellerName = rs.getString("seller_name") ;
		int item_numOfStock = rs.getInt("item_stock") ;
		int item_numOfSales = rs.getInt("item_sales") ;
		
		String item_itemCode = rs.getString("item_code") ;
		String item_sellerCode = rs.getString("item_sellercode") ;
		String item_key = item_itemCode +" "+ item_sellerCode ;
		
	%>
	<tr height="25" align="center">
		<td align="left"><%=index %></td>
		<td align="left"><%=item_name %></td>
		<td align="left"><%=item_brand %></td>
		<td align="left"><%=item_price %></td>
		<td align="left"><%=item_sellerName %></td>
		<td align="left"><%=item_numOfStock %></td>
		<td align="left"><%=item_numOfSales %></td>
		<td align="center"><input type="radio" name="selectedItem" value="<%=item_key%>"/></td>
	</tr>	
	<%		
	}
	rs.close() ;
	st.close() ;
	conn.close() ;
} catch (Exception e) {       
    out.println("DB 연동 실패");
}
%>	
<tr height="1" bgcolor="#82B5DF"><td colspan="8" width="752"></td></tr>
</table>
<br />
<div style="text-align:center"> 물품 선택 후 Cart로 이동하세요... </div>
<br />
<button onClick="location.href='Main.jsp'"> 뒤로 </button>

<form name="form1" action="InsertCart.jsp" method="post" onsubmit="return cartButton()">
<P align="right"> 갯수  : <input type="text" id="numOfItem" style="width:20px"/> <button> Cart </button></P>
<input type="hidden" name="sendNumOfItem" value=""/>
<input type="hidden" name="arrSelValue" value=""/>
</form>
</body>
</html>

