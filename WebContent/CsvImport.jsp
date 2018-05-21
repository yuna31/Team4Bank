<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="connect.DBConnection" %>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
   request.setCharacterEncoding("UTF-8");

   String root = "C:\\";
   String savePath = root + "csv";
  
   int read = 0;
   byte[] buf = new byte[1024];
   FileInputStream fin = null;
   FileOutputStream fout = null;

   Connection conn = null;
   PreparedStatement pstmt = null;
   String sql = "";   
   
   conn = DBConnection.getConnection() ;

   sql = "delete from users ;"
   		+ "delete from items ;"
   		+ "delete from usergrade ;"
   		+ "delete from coupon ;"
   		+ "delete from seller ;"
   		+ "delete from purchase ;"
   		+ "delete from cart ;" ;
   pstmt = conn.prepareStatement(sql);
   pstmt.executeUpdate();
   
   
   //READ user.csv---------------------------------------------------------
   File csv1 = new File(savePath + "\\user.csv");
   String email = null;
   String passwd = null;
   String firstname = null;
   String lastname = null;
   String birth = null;
   String coupontemp = null;
   String coupontemp2 = null;
   String coupon_id = null;
   String coupon_grade = null;
   String coupon_percent = null;

   BufferedReader br1 = new BufferedReader(new FileReader(csv1));
   br1.readLine();
   String line = "";

   while ((line = br1.readLine()) != null) {
      // -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션

      coupontemp = null;
      String[] token = line.split(",", -1);
      email = token[0];
      passwd = token[1];
      firstname = token[2];
      lastname = token[3];
      birth = token[4];
      coupontemp = token[5];

      SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
      java.util.Date temp = transFormat.parse(birth);
      java.sql.Date to = new java.sql.Date(temp.getTime());

      //USER DATA INSERT---------------------------------------------------------
      sql = "INSERT INTO users (user_email, user_password, user_firstname, user_lastname, user_birth) VALUES (?,?,?,?,?)";

      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, email);
      pstmt.setString(2, passwd);
      pstmt.setString(3, firstname);
      pstmt.setString(4, lastname);
      pstmt.setDate(5, to);
      pstmt.executeUpdate();
      
      
   
      //COUPON DATA INSERT---------------------------------------------------------
      if (coupontemp.length() == 0)
         continue;

      else {

         coupontemp2 = null;
         coupon_id = null;
         coupon_grade = null;
         coupon_percent = null;
         int loopindex = 0;

         String[] token2 = coupontemp.split("\\|", -1);

         loopindex = token2.length;

         for (int i = 0; i < loopindex; i++) {

            coupontemp2 = token2[i];
            String[] token3 = coupontemp2.split("\\s", -1);
            coupon_id = token3[0];
            coupon_grade = token3[1];
            coupon_percent = token3[2];
            int a = Integer.parseInt(coupon_percent);

            sql = "INSERT INTO coupon (coupon_email, coupon_grade, coupon_percent, coupon_id) VALUES (?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, coupon_grade);
            pstmt.setInt(3, a);
            pstmt.setString(4, coupon_id);
            pstmt.executeUpdate();
         }
      }

   }
   br1.close();

   //READ, DEFINE item.csv---------------------------------------------------------
   File csv2 = new File(savePath + "\\item.csv");
   String itemcode = null;
   String itemname = null;
   String brand = null;
   String sellercode = null;
   String sellername = null;
   String price = null;
   String numberofstocks = null;
   String numberofsales = null;
   String cart = null;
   String purchase = null;

   BufferedReader br2 = new BufferedReader(new FileReader(csv2));
   br2.readLine();
   line = "";

   while ((line = br2.readLine()) != null) {
      // -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션      

      String[] token = line.split(",", -1);
      itemcode = token[0];
      itemname = token[1];
      brand = token[2];
      sellercode = token[3];
      sellername = token[4];
      price = token[5];
      numberofstocks = token[6];
      numberofsales = token[7];
      cart = token[8];
      purchase = token[9];
      int a, b, c;

      //CONVERT TO INT
      a = Integer.parseInt(price);
      b = Integer.parseInt(numberofstocks);
      c = Integer.parseInt(numberofsales);

      //item DATA INSERT---------------------------------------------------------      
      sql = "INSERT INTO items (item_code, item_name, item_price, item_brand, item_sellerCode, item_stock, item_sales) VALUES (?,?,?,?,?,?,?)";

      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, itemcode);
      pstmt.setString(2, itemname);
      pstmt.setInt(3, a);
      pstmt.setString(4, brand);
      pstmt.setString(5, sellercode);
      pstmt.setInt(6, b);
      pstmt.setInt(7, c);

      pstmt.executeUpdate();
      

      //salesman DATA INSERT---------------------------------------------------------
      sql = "INSERT INTO seller (seller_code, seller_name, seller_itemcode) VALUES (?,?,?)";

      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, sellercode);
      pstmt.setString(2, sellername);
      pstmt.setString(3, itemcode);
      
      pstmt.executeUpdate();
      

      //cart DATA INSERT---------------------------------------------------------
      if (cart.length() != 0) {
         String[] token2 = cart.split("\\|", -1);
         int loopindex = token2.length;

         for (int i = 0; i < loopindex; i++) {

            String carttemp = token2[i];
            String c_u_email = null;
            String c_number = null;

            String[] token3 = carttemp.split("\\s", -1);

            c_u_email = token3[0];
            c_number = token3[1];
            a = Integer.parseInt(c_number);

            sql = "INSERT INTO cart (user_email, item_code, item_amount, seller_code) VALUES (?,?,?,?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, c_u_email);
            pstmt.setString(2, itemcode);
            pstmt.setInt(3, a);
            pstmt.setString(4, sellercode);

            pstmt.executeUpdate();
         }
      }

      //purchase DATA INSERT---------------------------------------------------------
      if (purchase.length() != 0) {

         String[] token2 = purchase.split("\\|", -1);
         int loopindex = token2.length;

         for (int i = 0; i < loopindex; i++) {

            String purchase_temp = token2[i];
            String p_u_email = null;
            String p_number = null;
            String p_coupon = null;
            String p_date = null;
            String p_time = null;

            String[] token3 = purchase_temp.split("\\s", -1);

            p_u_email = token3[0];
            p_number = token3[1];
            p_coupon = token3[2];
            p_date = token3[3];
            p_time = token3[4];

            a = Integer.parseInt(p_number);
            b = Integer.parseInt(p_coupon);
            String p_timestamp = p_date + " " + p_time;
            c = Integer.parseInt(price);

            SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date temp = transFormat.parse(p_timestamp);
            java.sql.Timestamp to = new java.sql.Timestamp(temp.getTime());

            sql = "INSERT INTO purchase (user_email, purchase_amount, usedcoupon, purchase_time, purchase_price, item_code, seller_code) VALUES (?,?,?,?,?,?,?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, p_u_email);
            pstmt.setInt(2, a);
            pstmt.setInt(3, b);
            pstmt.setTimestamp(4, to);
            pstmt.setInt(5, c);
            pstmt.setString(6, itemcode);
            pstmt.setString(7, sellercode);

            pstmt.executeUpdate();
         }
      }
   }
   br2.close();
   
   ResultSet rs= null;
   sql = "SELECT user_email, SUM(totalprice) AS g_price FROM (SELECT user_email, purchase.seller_code, SUM(purchase_amount * purchase_price) as totalPrice FROM purchase JOIN seller ON (purchase.seller_code= seller.seller_code) AND (purchase.item_code=seller.seller_itemcode) GROUP BY (user_email, purchase.seller_code)) AS priceTable GROUP BY user_email";
   pstmt = conn.prepareStatement(sql);      
   rs = pstmt.executeQuery();
   
   while(rs.next()){
      int g_amount = rs.getInt("g_price");
      String g_email = rs.getString("user_email");
      String g_grade = null;
      
      if(g_amount<= 200000) g_grade="Regular";
      else if(g_amount> 200000 && g_amount< 500000) g_grade="VIP";
      else g_grade="VVIP";
   
      sql = "INSERT INTO usergrade (email, totalamount, grade) VALUES (?,?,?)";

      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, g_email);
      pstmt.setInt(2, g_amount);
      pstmt.setString(3, g_grade);

      pstmt.executeUpdate();

   }
   
%>

<jsp:forward page="Login.jsp" />