<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

.detail-top{
	background: #fff;
	border-radius: 8px;
	padding: 20px 25px;
	margin-bottom: 20px; 
	box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.detail-title h1{
	font-size : 1.6rem;
	color: #2D6A4F;
	margin-bottom: 10px;
}


.detail-content {
	background: #fff;
	border-radius: 8px;
	padding: 20px;
	margin : 20px 0; 
	min-height: 250px; 
	line-height: 1.6; 
	border : 1px solid #ddd;
	box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}

.detail-cmt {
	width: 100%;
	height: 80px; 
	resize : none;
	border: 1px solid #ccc; 
	border-radius: 10px; 
	padding : 10px; 
	font-size: 0.95rem;
	outline: none;
}

.detail-cmt:focus{
	border-color : #2D6A4F;
}

.detail-meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 10px; 
	padding-top: 10px; 
	border-top: 1px solid #eee;
	font-size: 0.95rem;
	color: #555;
}

.detail-meta .left span {
	margin-right: 15px;
}

.btn-area {
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
}

.btn-reg {
	background-color: #fff;
	color: #2D6A4F; /* 텍스트가 아닌 명확한 버튼 디자인 */
	padding: 10px 24px;
	border-radius: 6px;
	border: 1px solid #2D6A4F;
	font-weight: bold;
	font-size: 1.05rem;
	cursor: pointer;
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px
		rgba(0, 0, 0, 0.2);
	transition: background-color 0.2s;
}

.btn-reg:hover{
	backgroung-color: #B7E4C7;
}
.comment-box{
	position:relative;
	background: #fff;
	border-radius: 8px;
	padding : 15px; 
	border : 1px soild #ddd; 
	box-shadow: 0 2px 8px rgba(0,0,0,0.3);
	margin-bottom: 20px;
}

.cmt-submit{
 position:absolute;
 right : 15px; 
 bottom: 15px; 
 height: 36px; 
 padding : 0 18px; 
}
</style>
<script>
	
</script>
</head>
<body>
	<%-- 제목 --%>

	<div class="detail-top">
		<div class="detail-title">
			<h1>제목: ${boardDTO.title}</h1>
		</div>
		<div>
			<span>구분: ${boardDTO.category}</span>

		</div>

		<div class="detail-meta">
			<div class="left">
				<span>작성자: ${boardDTO.board_num}</span> <span>작성일: <fmt:formatDate
						value="${boardDTO.created_at}" pattern="yyyy-MM-dd" /></span>
			</div>
			<div class="right">
				<span>조회수: ${boardDTO.view_cnt}</span>
			</div>
		</div>
	</div>

	
	<%-- 내용 --%>
	<div class="detail-content">${boardDTO.content}</div>
	
	<%-- 댓글 쓰기 --%>
	<form method="post" action="" class="">
		<input type="hidden" name="action" value="write"> <input
			type="hidden" name="board_num" value="${boardDTO.board_num}">
		<div class="comment-box">
		<textarea class="detail-cmt" name="content" placeholder="댓글을 입력하세요"
			required></textarea>
		<button type="submit" class="cmt-submit btn-reg">등록</button>
		</div>
	</form>

	<div class="btn-area">
		<div class="left">
			<button type="button" class="btn-reg">수정</button>
			<button type="button" class="btn-reg">삭제</button>
		</div>
		<div class="right">
			<button type="button" class="btn-reg">목록</button>
			<button type="button" class="btn-reg">TOP</button>
		</div>
	</div>
</body>
</html>