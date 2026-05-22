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
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
	font-family: 'Malgun Gothic', sans-serif;
}

.mat-all {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	background-color: #f4f7f6;
}

.mat-body {
	display: flex;
	flex: 1;
}

.side {
	width: 250px;
	background-color: #fff;
	border-right: 1px solid #ddd;
	flex-shrink: 0;
}

.main-cont {
	flex: 1;
	padding: 2rem 2.5rem;
	min-width: 0;
}

.hdr {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #2D6A4F;
	padding: 15px 25px;
	border-radius: 8px;
	margin-bottom: 25px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.hdr h1 {
	font-size: 1.8rem;
	color: #ffffff;
	font-weight: bold;
	letter-spacing: -1px;
}

.btn-reg {
	background-color: #fff;
	color: #2D6A4F;
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

.btn-reg:hover {
	background-color: #B7E4C7;
}

.write-content {
	background: #fff;
	border-radius: 8px;
	padding: 20px;
	margin: 20px 0;
	min-height: 250px;
	line-height: 1.6;
	border: 1px solid #ddd;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.btn-area {
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
}

.btn-reg {
	background-color: #fff;
	color: #2D6A4F;
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

.btn-reg:hover {
	background-color: #B7E4C7;
}

.form-control {
	height: 38px;
	border: 1px solid #aaa;
	border-radius: 4px;
	padding: 0 10px;
	font-size: 0.95rem;
	outline: none;
	transition: border-color 0.2s;
}

.form-control:focus {
	border-color: #2D6A4F;
}

select.form-control {
	width: 140px;
}



</style>

</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">



				<div class="hdr">
					<h1>게시판 글쓰기</h1>
					<button type="button" class="btn-reg"
						onclick="location.href='${pageContext.request.contextPath}/board'">
						목록</button>

				</div>

				<div class="write-content">
					<form action="${pageContext.request.contextPath}/board/${mode == 'modify' ? 'modify' : 'write'}" method="post">
						
						<c:if test="${mode == 'modify'}">
							<input type="hidden" name="board_num" value="${board.board_num}" />
						</c:if>
						
						
						<select name="category" class="form-control">
							<option value="">카테고리 선택</option>
							<option value="공지" ${board.category == '공지' ? 'selected' : ''}>공지</option>
							<option value="일반" ${board.category ==  '일반' ? 'selected' : ''}>일반</option>
							<option value="자유" ${board.category ==  '자유' ? 'selected' : ''}>자유</option>
						</select>

						<!-- 제목 -->
						<div style="margin-bottom: 15px;">
							<input type="text" name="title" value="${board.title}" placeholder="제목을 입력하세요" 
							class="form-control" style="width:100%;" />
						</div>

						<!-- 에디터 영역 -->
						<div id="editor">${board.content}</div>

						<!-- 실제 전송될 값 -->
						<input type="hidden" name="content" id="content" value="${board.content}" />

						<!-- 버튼 -->
						<div class="btn-area">
							<button type="submit" class="btn-reg">${mode == 'modify' ? '수정완료' : '등록'}</button>
						</div>
					</form>

				</div>

			</main>
		</div>
		<tiles:insertAttribute name="footer" ignore="true" />
	</div>


	<script>
		const editor = new toastui.Editor({
			el : document.querySelector('#editor'),
			height : '400px',
			initialEditType : 'wysiwyg',
			previewStyle : 'vertical'
		});

		// submit 전에 내용 넣기
		document.querySelector("form").addEventListener("submit", function() {
			document.querySelector("#content").value = editor.getHTML();
		});
	</script>



</body>
</html>