<%@page import="model.Board"%>
<%@page import="java.util.List"%>
<%@page import="service.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table, tr {
	border: solid 1px gray;
	border-collapse: collapse;
	padding: 8px;
	text-align: center;
}
th {
	text-align: right;
	padding: 5px;
	}
td {
	border: solid 1px gray;
	border-collapse: collapse;
	padding: 8px;
}
.title {
	margin-top: 100px;
	text-align: center;
	font-size: 30px;
}
.head {
	background-color: black;
	color: white;
	font-size: 20px
}
.box {
	margin-top: 5px;
	margin: auto;
	padding: 8px;
	width: 1300px;
	height: 450px;
	background-color: #BDBDBD;
}
.header {
	background:burlywood;
	display: flex;
	justify-content: space-between;
	right:0;
	left:0;
	top:0;
	position:fixed;
}
.menu {
	margin: auto;
	margin-right: 20px;
	display: flex;
	padding-right: 40px;
	text-decoration: none;
}
.menu li {
	padding-left: 20px;
	list-style: none;
}
.logo {
	height: 50px;}
.login {
	background-color: #BDBDBD;
	margin: auto;
	padding: 8px;
	width: 1300px;
	height: 200px;
}
.logintd{
	background-color: #B5B2FF;
	color: white;
	font-size: 20px;
	width: 300px;
}
.size {
	display: grid;
	width: 98%;
	height: 70%;
	margin: 2px;
	padding: 3px;
}
.bsize {
	height: 80%;
	margin: 1px;
}
#input-txt {
	text-align: center;
	text-decoration: underline;
}
#imagebox {
	width: 100px;
	height: 100px;
	margin: 0 auto;
	border-radius: 15px;
	border: 1px solid black;
	position: relative;
}
#preview-image {
			width: 100px;
			height: 100px;
			margin : 0;
			padding : 0;			
			border-radius : 15px;
			position: relative;
			top: 0%;
			left: 0%;
			object-fit: cover;
}
</style>
<script>
window.onload = function() {	// 모든 콘텐츠 동작후 이벤트 발생

	const inputImage = document.getElementById("input-image");	// ()값 가져오기
	inputImage.addEventListener("change", readImage);	// readimage로 변경 이벤트 실행
};
function readImage(e){
		const reader = new FileReader();	// 파일객체 생성
		reader.onload = function (e) {
			const previewImage = document.getElementById("preview-image");	// ()값 가져오기
			previewImage.src = e.target.result; 	// previewImage.src 에 url 정보 대입
		}
		reader.readAsDataURL(e.target.files[0]);	// 파일의 실제 경로 받아옴
};
</script>
</head>
<body>
<%
String boardid = "1";

BoardDao bd = new BoardDao();
int boardcount = bd.boardCount(boardid);

int pageInt = 1;
int limit = 3;
try {
	pageInt = Integer.parseInt(request.getParameter("pageNum"));
} catch (Exception e) {
	pageInt=1;
}
/* 
-- 1, 4, 7, 10
-- start : (pageInt-1)*limit + 1;
-- end : start + limit - 1;
-- 1 p --> 1 ~ 3
-- 2 p --> 4
-- 3 p --> 7 
*/

List<Board> list = bd.boardList(pageInt, limit, boardcount, boardid);
/*
-- 1 p --> boardcount ~
-- 2 p --> boardcount - 1 * limit ~
-- 3 p --> boardcount - 2 * limit
*/

int boardnum = boardcount - (pageInt - 1) * limit;
/*
-- 1 p --> boardcount ~
-- 2 p --> boardcount - 1 * limit ~
-- 3 p --> boardcount - 2 * limit
*/

int bottomLine = 3;
int startPage = (pageInt -1) / bottomLine * bottomLine + 1;
int endPage = startPage + bottomLine - 1;
int maxPage = (boardcount / limit) + (boardcount % limit == 0 ? 0 : 1);
if (endPage > maxPage) endPage = maxPage;
/*
-- 1 p --> startpage = 1	(p-1)/3*3+1
-- 2 P --> startpage = 1
-- 3 p --> startpage = 1
-- 4 p --> startpage = 4
-- 5 p --> startpage = 4
-- 6 p --> startpage = 4
 1 2 3 , 4 5 6 , 7, 8, 9
*/
/*
int 
*/
%>
<hr>
	<!-- table list start -->
	<div class="container">
		<h2  class="title">게시판 리스트</h2>
		<p align="right">
		<% if (boardcount > 0) { %> 글개수 <%=boardcount %> <% } else { %>
		등록된 게시물이 없습니다.
		<% } %> </p>
		<table class="table table-hover">
			<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>등록일</th>
					<th>파일</th>
					<th>조회수</th>

				</tr>
			</thead>
			<tbody>
			<%
			for (Board b : list) {
			%>
				<tr>
					<td><%=(boardnum--) %></td>
					<td><a href="boardInfo.jsp?num=<%=b.getNum() %>"><%=b.getSubject() %></a></td>
					<td><%=b.getWriter() %></td>
					<td><%=b.getRegdate() %></td>
					<td><%=b.getFile1() %></td>
					<td><%=b.getReadcnt() %></td>
				</tr>
			<% } %>
			</tbody>
		</table>
		<p align="right"><a href="<%=request.getContextPath() %>/view/board/writeForm.jsp">게시판입력</a></p>
		<div class="container"  >
		<ul class="pagination justify-content-center"  >
   <li class="page-item <% if (startPage <= bottomLine) { %> disabled <% } %> "><a class="page-link" href="list.jsp?pageNum=<%=startPage-bottomLine%>">Previous</a></li>
   <% for (int i = startPage; i <= endPage; i++) { %>
  <li class="page-item <% if (i == pageInt) { %>active <% } %>"><a class="page-link" href="list.jsp?pageNum=<%=i %>"><%=i %></a></li>
  <% } %>
  <li class="page-item <% if (endPage >= maxPage) { %> disabled <% } %>"><a class="page-link" href="list.jsp?pageNum=<%=startPage+bottomLine%>">Next</a></li>
 
</ul> </div>
	</div>
</body>
</html>