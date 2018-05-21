<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%@ page import="connect.DBConnection" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>회원가입</title>
</head>
<body>
<h1> PNU IPS 회원가입 </h1> 
	<form action="SignConfirm.jsp" method="post" onsubmit="return input_check_func()">
    <table border="0">
        <tr>
            <th> Email </th> <td> <input id="JOIN_Email" name="JOIN_Email" type="text" ></td>
        </tr>
        <tr>
            <th> Password </th> <td> <input id="JOIN_pw" name="JOIN_pw" type="password"> </td>
        </tr>
        <tr>
            <th> Last Name </th> <td> <input id="JOIN_lastname" name="JOIN_lastname" type="text"> </td>
        </tr>
        <tr>
            <th> First Name </th> <td> <input id="JOIN_firstname" name="JOIN_firstname" type="text"> </td>
        </tr>
        <tr>
            <th> Birth </th> <td> <input id="JOIN_birth" name="JOIN_birth" type="text"> YYYY-MM-DD </td>
        </tr>
    </table>
    <button> 가입하기 </button>
	</form>
   	<br/>
   	<button onClick="location.href='Login.jsp'"> 뒤로 </button>
	<script>

	
    function input_check_func() {
        var email = document.getElementById('JOIN_Email').value;
        var pw = document.getElementById('JOIN_pw').value;
        var lastName = document.getElementById('JOIN_lastname').value;
        var firstName = document.getElementById('JOIN_firstname').value;        
        var birth = document.getElementById('JOIN_birth').value;
        
        if ( email == null || email == "") {
        	alert("ID를 입력하세요...");
            return false;
        }
        else if (pw == null || pw == "") {
        	alert("PW를 입력하세요...");
            return false;
        }
        else if (lastName == null || lastName == "") {
			alert("Last Name를 입력하세요...");
            return false;
        }
		else if (firstName == null || firstName == "") {
			alert("First Name를 입력하세요...");
            return false;
        }
		
		else if (birth == null || birth == "") {
			alert("Birth를 입력하세요...");
            return false;
        }
        else {
        	alert("가입이 완료되었습니다.")
            return true;
        }
    }    
    </script>
</body>
</html>