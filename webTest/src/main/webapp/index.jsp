<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<script type="text/javascript" src="jquery3.4.1.js"></script>
<!-- 
<script type="text/javascript" src="jquery.ajax-cross-origin.min.js"></script>
 -->
<body>

  <a id="goLogin">로그인</a> <br />
  <a id="chkCookie">쿠키값 확인</a> <br />
  <a id="delCookie">쿠키 삭제</a> <br />
  <a id="chkData">데이터 확인</a> <br />

<br/>
<br/>

<div>--결과--</div>
<div id="resultBox">

</div>

</body>



<script>


$(document).ready(function() {
//	login(); 
});

$("#goLogin").on("click", function(){
	login() ;
}); 

$("#chkCookie").on("click", function(){
	var cookieVal = getCookie( "token" ) ; 
	$("#resultBox").html("쿠키값:"+cookieVal);
}); 

$("#chkData").on("click", function(){
	getData() ; 
});

$("#delCookie").on("click", function(){
	deleteCookie("token") ; 
});

function login() {
	var obj = {"id":"mono","pwd":"12345", "val":"value12345"} ; 

	$.ajax({
//		crossOrigin: true,
		url:'/testConn',
//		url:'/getData',
		url:'/login',
		type:'POST',
		dataType:"JSON",
		contentType: 'application/json',
		data:JSON.stringify(obj),
		success:function(data){
			//console.log("접속 성공");
			if (data.result=='ok'){ 
				$("#resultBox").html("로그인 성공"+"<br/>토큰값: "+data.token);
				setCookie( "token",data.token , 1 ) ; 
			} else { 
				$("#resultBox").html("로그인 실패");
			}

		},
		error : function(xhr, status, error) {
			//alert("에러발생");
			$("#resultBox").text("에러발생");
		}

	});
}



function getData() {
	var obj = {"data1":"A","data2":"2","val":"12345"} ; 

	$.ajax({
		url:'/getData',
		type:'POST',
		dataType:"JSON",
		contentType: 'application/json',
		data:JSON.stringify(obj),
		success:function(data){
			//console.log("접속 성공");
			if (data.result=='ok'){ 
				$("#resultBox").html("val:" +data.val);
			} else { 
				$("#resultBox").html("데이터 가져오기 실패");
			}

		},
		error : function(xhr, status, error) {
			//alert("에러발생");
			$("#resultBox").text("에러발생");
		}

	});
}




/**
* 쿠키 설정
* @param cookieName 쿠키명
* @param cookieValue 쿠키값
* @param expireDay 쿠키 유효날짜
*/
function setCookie( cookieName, cookieValue, expireDate ) {
	var today = new Date();
	today.setDate( today.getDate() + parseInt( expireDate ) );
	document.cookie = cookieName + "=" + escape( cookieValue ) + "; path=/; expires=" + today.toGMTString() + ";";
}

/**
* 쿠키값 추출
* @param cookieName 쿠키명
*/
function getCookie( cookieName ){
	var search = cookieName + "=";
	var cookie = document.cookie;
	
	// 현재 쿠키가 존재할 경우
	if( cookie.length > 0 ) {
		// 해당 쿠키명이 존재하는지 검색한 후 존재하면 위치를 리턴.
		startIndex = cookie.indexOf( cookieName );
	
		// 만약 존재한다면
		if( startIndex != -1 ) {
			// 값을 얻어내기 위해 시작 인덱스 조절
			startIndex += cookieName.length;
		
			// 값을 얻어내기 위해 종료 인덱스 추출
			endIndex = cookie.indexOf( ";", startIndex );
			
			// 만약 종료 인덱스를 못찾게 되면 쿠키 전체길이로 설정
			if( endIndex == -1) endIndex = cookie.length;
			
			// 쿠키값을 추출하여 리턴
			return unescape( cookie.substring( startIndex + 1, endIndex ) );
		} else {
			// 쿠키 내에 해당 쿠키가 존재하지 않을 경우
			return false;
		}
	} else {
		// 쿠키 자체가 없을 경우
		return false;
	}
}


/**
* 쿠키 삭제
* @param cookieName 삭제할 쿠키명
*/
function deleteCookie( cookieName ) {
	var expireDate = new Date();
	
	//어제 날짜를 쿠키 소멸 날짜로 설정한다.
	expireDate.setDate( expireDate.getDate() - 1 );
	document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}

</script>



</html>