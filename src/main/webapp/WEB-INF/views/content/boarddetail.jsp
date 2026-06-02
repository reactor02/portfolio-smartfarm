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
<style>
/* --- 공통 스타일 --- */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
	font-family: 'Malgun Gothic', sans-serif;
}

body {
	background-color: #f9f9f9; /* 배경색을 아주 옅은 회색으로 */
	color: #333;
}

/* --- 게시글 상세 영역 (기존 스타일 유지하되 약간 수정) --- */
.detail-top {
	background: #fff;
	border-radius: 12px; /* 더 부드럽게 */
	padding: 25px 30px;
	margin-bottom: 25px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03); /* 더 은은한 그림자 */
}

.detail-title h1 {
	font-size: 1.8rem; /* 약간 더 크게 */
	color: #2D6A4F;
	margin-bottom: 12px;
	font-weight: 800; /* 더 굵게 */
}

.detail-content {
	background: #fff;
	border-radius: 12px;
	padding: 30px;
	margin: 25px 0;
	min-height: 300px;
	line-height: 1.8; /* 줄간격 더 넓게 */
	border: 1px solid #eee;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
}

.detail-meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 15px;
	padding-top: 15px;
	border-top: 1px solid #eee;
	font-size: 0.95rem;
	color: #666;
}

.detail-meta .left span {
	margin-right: 20px;
}

/* --- 버튼 스타일 (기존 스타일 유지하되 약간 수정) --- */
.btn-reg {
	background-color: #fff;
	color: #2D6A4F;
	padding: 10px 24px;
	border-radius: 8px; /* 더 부드럽게 */
	border: 1px solid #2D6A4F;
	font-weight: bold;
	font-size: 1rem;
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
	transition: all 0.2s;
}

.btn-reg:hover {
	background-color: #2D6A4F; /* 호버 시 색상 반전 */
	color: #fff;
}

.btn-area {
	display: flex;
	justify-content: space-between;
	margin-top: 30px;
}


/* =========================================================================
   ======================= [새로운 댓글 스타일 (Gemini)] =========================
   ========================================================================= */

/* 1. 전체 댓글 영역 */
.comment-section {
	margin-top: 40px;
	max-width: 900px; /* 전체 너비 제한 */
	margin-left: auto;
	margin-right: auto;
}

.comment-title {
	font-size: 1.3rem;
	color: #2D6A4F;
	margin-bottom: 18px;
	font-weight: 800;
	padding-bottom: 8px;
	border-bottom: 2px solid #B7E4C7; /* 제목 아래 포인트 줄 */
	display: inline-block;
}

/* 2. 전체 댓글 목록 감싸는 영역 */
.comment-wrap {
	display: flex;
	flex-direction: column;
	gap: 15px; /* 댓글 카드 간 간격 */
	margin-bottom: 30px;
}

/* 3. 댓글 카드 (독립된 카드 형태) */
.comment {
    background: #fff;
    border: 1px solid #eef1f3;
    border-radius: 8px; /* 모서리 곡률 약간 축소 */
    padding: 12px 15px; /* 내부 여백 대폭 축소 */
    box-shadow: 0 1px 3px rgba(0,0,0,0.05); /* 그림자도 가볍게 */
    margin-bottom: 8px; /* 댓글 사이 간격 축소 */
}

.comment:hover {
	box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06); /* 호버 시 그림자 살짝 강조 */
}

/* 4. 댓글 헤더 (작성자, 날짜) */
.comment-header {
    margin-bottom: 6px;
    font-size: 0.85rem;
}

.comment-header b {
    font-size: 0.9rem;
}

.comment-header .cmt-date {
	font-size: 0.85rem;
	color: #aaa;
}

/* 5. 댓글 내용 */
.comment-body {
    font-size: 0.9rem; /* 폰트 사이즈 살짝 축소 */
    line-height: 1.5;
    margin-bottom: 6px;
}

/* 6. 댓글 액션 버튼 (답글, 삭제) */
.comment-actions {
    display: flex;       /* 가로 배치 */
    gap: 12px;           /* 버튼 사이의 간격 */
    margin-top: 5px;     /* 댓글 본문과의 거리 */
}

.comment-actions button {
    background: none;    /* 배경색 제거 */
    border: none;        /* 테두리 제거 */
    font-size: 0.75rem;  /* 작은 폰트 크기 */
    color: #888;         /* 은은한 회색 */
    cursor: pointer;
    padding: 0;
    transition: color 0.2s; /* 마우스 올렸을 때 부드럽게 색상 변경 */
}

/* 3. 마우스 올렸을 때 효과 */
.comment-actions button:hover {
    color: #2D6A4F;      /* 마우스를 올리면 NodeFarm 그린 색상으로 */
    text-decoration: underline; /* 밑줄 추가 */
}

/* 7. 대댓글(답글) 영역 */
.reply-box {
    margin-left: 15px; /* 들여쓰기 폭 조절 */
    margin-top: 8px;
    padding-left: 12px;
    border-left: 2px solid #ddd;
}

/* 8. 댓글 입력창 영역 */
.comment-box-area {
	margin-top: 30px;
	background: #fff;
	border: 1px solid #eee;
	border-radius: 16px;
	padding: 20px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
}

.comment-box-area .comment-title {
	border-bottom: none;
	margin-bottom: 15px;
}

/* 9. 입력창 (textarea) */
.detail-cmt {
    flex: 1;           /* 남은 공간 모두 차지 */
    height: 60px;      /* 높이 고정 */
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 8px;
    resize: none;      /* 사이즈 조절 방지 */
    font-size: 0.9rem;
}

.detail-cmt:focus {
	border-color: #B7E4C7; /* 포커스 시 연한 그린 */
	background-color: #fff;
	box-shadow: 0 0 0 3px rgba(183, 228, 199, 0.3);
}

/* 10. 댓글 등록 버튼 */

.cmt-submit {
    width: 80px;       /* 가로 고정 */
    height: 60px;      /* textarea와 높이 맞춤 */
    padding: 0;
    margin-top: 0;
    flex-shrink: 0;    /* 버튼 크기 안 줄어들게 */
}


/* 댓글 입력 폼 컨테이너 */
.comment-box {
    display: flex; /* 가로 정렬 */
    gap: 10px;      /* 입력창과 버튼 사이 간격 */
    align-items: flex-start; /* 상단 정렬 */
    margin-top: 15px;
}

/* 답글 클릭 시 폼이 이동했을 때 스타일 */
.comment > #commentForm {
    margin-top: 15px;
    padding: 10px;
    background: #f0f0f0; /* 답글 작성 중임을 알기 쉽게 배경색 변경 */
    border-radius: 8px;
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
				<span>작성자: ${boardDTO.ename}</span> <span>작성일: <fmt:formatDate
						value="${boardDTO.created_at}" pattern="yyyy-MM-dd" /></span>
			</div>
			<div class="right">
				<span>조회수: ${boardDTO.view_cnt}</span>
			</div>
		</div>
	</div>


	<%-- 내용 --%>
	<div class="detail-content">
		${boardDTO.content}
		
		<h3> 첨부파일</h3>
		<c:if test="${not empty files}"> 
			<ul>
				<c:forEach var="file" items="${files}">
					<li>
						<a href="/file/download?fileName=${file.file_name}">
						${file.file_name}
						</a>
					</li>
				</c:forEach>
			</ul>
		</c:if>
	</div>


	<div class="comment-section">
		<h3 class="comment-title">댓글</h3>
		<div id="commentList" class="comment-wrap"></div>

		<%-- 댓글 쓰기 --%>
		<form onsubmit="return writeComment(event);" id="commentForm" class="comment-box-area" >
		
			<input type="hidden" id="board_num" value="${boardDTO.board_num}">
			<input type="hidden" id="parent_cmt" value=""> 

			<div class="comment-box">
				<textarea class="detail-cmt" id="content" placeholder="댓글을 입력하세요"
					required></textarea>
				<button type="submit" class="cmt-submit btn-reg">등록</button>
			</div>
		</form>

	</div>

	<div class="btn-area">
		<div class="left">
			<button type="button" class="btn-reg"
				onclick="location.href='${pageContext.request.contextPath}/board/modify?board_num=${boardDTO.board_num}'">수정</button>
			<button type="button" class="btn-reg"
				onclick="if(confirm('정말 삭제하시겠습니까?')) {location.href='${pageContext.request.contextPath}/board/delete?board_num=${boardDTO.board_num}';}">삭제</button>
		</div>
		<div class="right">
			<button type="button" class="btn-reg"
				onclick="location.href='${pageContext.request.contextPath}/board'">목록</button>
			<button type="button" class="btn-reg">TOP</button>
		</div>
	</div>



	<script> 
	window.addEventListener('load',()=>{
		loadComments();
	
	})

	
	function writeComment(event){
		event.preventDefault();
		
		const content = document.getElementById("content").value;
		const board_num = document.getElementById("board_num").value; 
		
		fetch("/comment/write", {
			method: "POST", 
			headers: {
				"Content-Type" : "application/json"
			},
			body: JSON.stringify({
				cmt_content: content,
				board_num : board_num
			})
		})
		.then(res => res.text())
		.then(data => {
			
			if(data === "success"){
				alert("댓글 등록 성공");
				
				// 입력 초기화 
				document.getElementById("content").value = "";
				
				// 댓글 다시 불러오기 
				loadComments();
					
			} else if(data === "login_required"){
				alert("로그인 필요");
				location.href = "/login";
			} else {
				alert("댓글 실패");
			}
		});
		return false; // form submit 막기용 
	}
	
	function loadComments(){
		const boardNum = document.getElementById("board_num").value;

		fetch("/comment/list?board_num=" + boardNum)
		.then(res => res.json())
		.then(list => {
			
			window.commentListData = list; 
			// 부모 댓글만
			const roots = list.filter(c => !c.parent_cmt);

			document.getElementById("commentList").innerHTML =
				roots.map(renderComment).join("");
		});
	}

	function renderComment(c){

	    const children = window.commentListData
	        ? window.commentListData.filter(x => x.parent_cmt == c.comment_num)
	        : [];

	    return `
	    <div class="comment">
	        <div class="comment-header">
	            <b>\${c.ename}</b>
	        </div>

	        <div class="comment-body">
	            \${c.cmt_content}
	        </div>

	        <div class="comment-actions">
	            <button onclick="reply(event, \${c.comment_num})">답글</button>
	            <button onclick="deleteComment(\${c.comment_num})">삭제</button>
	        </div>

	        \${children.length > 0 ? `
	            <div class="reply-box">
	                \${children.map(renderComment).join("")}
	            </div>
	        ` : ""}
	    </div>
	    `;
	}
	
	function reply(e, parentId){
		const form = document.getElementById("commentForm");
		
		// 1. form을 해당 댓글 아래로 이동 
		const targetComment = e.target.closest('.comment');
		targetComment.appendChild(form);
		
		// 2. 부모 댓글 번호 설정 
		document.getElementById("parent_cmt").value = parentId;
		
		// 3. 포커스 주기 
		document.getElementById("content").focus();
		
		// reply 함수 마지막에 추가
		if (!document.getElementById("cancelBtn")) {
		    const cancelBtn = document.createElement("button");
		    cancelBtn.id = "cancelBtn";
		    cancelBtn.innerText = "취소";
		    cancelBtn.style.marginLeft = "10px";
		    cancelBtn.onclick = function() {
		        document.querySelector('.comment-section').appendChild(form);
		        document.getElementById("parent_cmt").value = "";
		        this.remove(); // 취소 버튼 삭제
		    };
		    form.querySelector('.comment-box').appendChild(cancelBtn);
		};
		
		}
		
		// 댓글 작성/답글 작성(공통)
	function writeComment(event){
			event.preventDefault();
			
			const content = document.getElementById("content").value; 
			const board_num = document.getElementById("board_num").value; 
			const parent_cmt = document.getElementById("parent_cmt").value; 
			
			fetch("/comment/write",{
				method: "POST",
				headers: {"Content-Type" : "application/json"},
				body : JSON.stringify({
					cmt_content: content,
					board_num : board_num,
					parent_cmt: parent_cmt || null // 값이 없으면 null
				})
			})
			.then(res => res.text())
			.then(data => {
				if(data === "success"){
					alert("등록 성공");
					document.getElementById("content").value = "";
					document.getElementById("parent_cmt").value = ""; // 초기화
					
					loadComments();
				}
			});
			return false;
			
		}
	
	function deleteComment(comment_num){
		
		fetch("/comment/delete", {
			method:"POST",
			headers:{
				"Content-Type": "application/json"
			},
			body: JSON.stringify({
				comment_num: comment_num
			})
		})
		.then(res=> res.text())
		.then(data => {
			if (data === "success"){
				loadComments();
			}
		});
	}
	
	</script>
</body>
</html>