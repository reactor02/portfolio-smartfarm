<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<%
if (session.getAttribute("loginUser") == null) {
    response.sendRedirect("/login");
    return;
}
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/paging.css">
<style>
/* 기본 초기화 */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
	font-family: 'Malgun Gothic', sans-serif;
}

/* 레이아웃 골격 */
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

/* ========== 1. 상단 타이틀 & 등록 버튼 ========== */
.hdr {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #2D6A4F; /* 메인 컬러 배경 */
	padding: 15px 25px;
	border-radius: 8px;
	margin-bottom: 25px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.hdr h1 {
	font-size: 1.8rem;
	color: #ffffff; /* 화이트 통일 */
	font-weight: bold;
	letter-spacing: -1px;
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

.btn-reg:hover {
	background-color: #B7E4C7;
}

/* ========== 2. 검색 영역 (입력창, 버튼 높이 및 정렬 완벽화) ========== */
.sch-wrap {
	background-color: #fff;
	border: 1px solid #bbb;
	border-radius: 10px;
	padding: 20px 25px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}
/* Flex를 이용한 양극단 정렬 */
.sch-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
}

.sch-row:last-child {
	margin-bottom: 0;
}

.sch-left, .sch-right {
	display: flex;
	align-items: center;
	gap: 12px;
}

.label {
	font-size: 0.95rem;
	font-weight: bold;
	color: #333;
	display: flex;
	align-items: center;
}

/* 폼 요소 공통 규격 (높이 강제 일치) */
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

/* 커스텀 검색창 (돋보기 포함) */
.sch-input-box {
	display: flex;
	align-items: center;
	border: 1px solid #aaa;
	border-radius: 4px;
	height: 38px;
	background: #fff;
	padding-left: 10px;
	width: 220px;
}

.sch-input-box input {
	border: none;
	outline: none;
	height: 100%;
	flex: 1;
	padding: 0 5px;
	font-size: 0.95rem;
}

/* 검색 버튼 (높이 맞춤) */
.btn-sch {
	height: 38px;
	padding: 0 20px;
	background-color: #fff;
	color: #2D6A4F;
	border: 1px solid #2D6A4F;
	border-radius: 4px;
	font-size: 1rem;
	font-weight: bold;
	cursor: pointer;
	transition: 0.2s;
}

.btn-sch:hover {
	background-color: #B7E4C7;
}

/* ========== 3. 커스텀 라디오 버튼 ========== */
.radio-label {
	display: flex;
	align-items: center;
	gap: 6px;
	cursor: pointer;
	font-size: 0.95rem;
	color: #333;
	font-weight: bold;
}

.radio-label input[type="radio"] {
	appearance: none;
	-webkit-appearance: none;
	width: 18px;
	height: 18px;
	border: 2px solid #aaa;
	border-radius: 50%;
	position: relative;
	outline: none;
	cursor: pointer;
}

.radio-label input[type="radio"]:checked {
	border-color: #4A90E2;
}

.radio-label input[type="radio"]:checked::after {
	content: "";
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 10px;
	height: 10px;
	border-radius: 50%;
	background-color: #4A90E2; /* 선택 시 파란색 원 */
}

/* ========== 4. 데이터 테이블 (세련된 스타일) ========== */
.tbl-box {
	background: #fff;
	border-radius: 8px;
	padding: 15px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.board-tbl {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid #2D6A4F; /* 상단 헤더 강조 */
	margin-bottom: 20px;
}

.board-tbl th {
	background-color: #f8f9fa;
	color: #222;
	padding: 14px 10px;
	border-bottom: 1px solid #ddd;
	font-weight: 700;
	font-size: 0.95rem;
}

.board-tbl td {
	padding: 12px 10px;
	border-bottom: 1px solid #eee;
	text-align: center;
	color: #444;
	font-size: 0.95rem;
}

/* 행 호버 효과 */
.board-tbl tbody tr:hover {
	background-color: #f9fdfb;
}

/* [핵심] 공지사항 스타일 */
.board-tbl tr.notice {
	background-color: #f1f8f5; /* 연한 초록 배경 */
	font-weight: bold;
}

.board-tbl tr.notice td {
	color: #2D6A4F; /* 글자 색상 강조 */
}

/* 공지 라벨 디자인 */
.notice-badge {
	background-color: #2D6A4F;
	color: #fff;
	padding: 2px 6px;
	border-radius: 4px;
	font-size: 0.8rem;
	margin-right: 5px;
}

.link-txt {
	color: #333;
	text-decoration: none;
}

.link-txt:hover {
	color: #2D6A4F;
	text-decoration: underline;
}
/* ========== 5. 페이징 ========== */
.pg-wrap {
	display: flex;
	justify-content: center;
	margin-top: 25px;
	gap: 6px;
}

.pg-btn {
	padding: 8px 12px;
	border: 1px solid #ccc;
	color: #555;
	text-decoration: none;
	border-radius: 4px;
	background: #fff;
	font-size: 0.9rem;
	transition: 0.2s;
}

.pg-btn:hover {
	background-color: #eee;
}

.pg-active {
	background-color: #2D6A4F;
	color: #fff;
	border-color: #2D6A4F;
	font-weight: bold;
}

.link-txt {
	color: #2D6A4F;
	text-decoration: none;
	font-weight: bold;
}

.link-txt:hover {
	text-decoration: underline;
}

.col-title {
	width: 50%;
}

/* 검색 조건 드롭다운 스타일 */
.select_option {
	position: relative;
	width: 120px;
	height: 38px;
	border: 1px solid #aaa;
	border-radius: 4px;
	cursor: pointer;
	background: #fff;
}

.select_option .option_text {
	display: block;
	padding: 8px 10px;
	font-size: 0.95rem;
}

.option_list {
	display: none; /* 기본 숨김 */
	position: absolute;
	top: 100%;
	left: 0;
	width: 100%;
	background: #fff;
	border: 1px solid #aaa;
	border-radius: 4px;
	list-style: none;
	z-index: 10;
	margin-top: 2px;
}

.option_list .item button {
	width: 100%;
	padding: 8px 10px;
	border: none;
	background: none;
	text-align: left;
	cursor: pointer;
}

.option_list .item button:hover {
	background-color: #f1f8f5;
}

/* 활성화 상태 */
.select_option.on .option_list {
	display: block;
}
</style>



</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>board</h1>
					<button type="button" class="btn-reg">
						<a href="${pageContext.request.contextPath}/board/write"
							class="link-txt">+ 글쓰기</a>
					</button>
				</div>

				<%-- 검색창 action  --%>
				<form name="searchFrm"
					action="${pageContent.request.contextPath}/board" method="get">

					<div class="sch-wrap">
						<div class="sch-row">
							<div class="sch-left">
								<!-- 드롭다운 컨테이너 -->
								<span class="label">▶ 검색 조건</span> <select class="form-control"
									name="type" id="mType">
									<option value="">선택</option>
									<option value="title">제목만</option>
									<option value="ename">글작성자</option>
								</select>
							</div>


							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> <input type="text"
										id="keyword" value="" placeholder="제목/작성자 검색">
								</div>
								<button type="button" class="btn-sch" id="search">검색</button>
								<button type="button" class="btn-sch select-reset" id="init">검색
									초기화</button>
							</div>
						</div>
					</div>

				</form>




				<table class="board-tbl">
					<thead>
						<tr>
							<th>no.</th>
							<th>카테고리</th>
							<th class="col-title">제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody id="tbody"></tbody>
				</table>

				<div class="table-responsive"></div>
				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>

		</div>
		<tiles:insertAttribute name="footer" ignore="true" />
	</div>


	<script> 
	window.addEventListener('load', ()=> {
		bind()
	})
	
		let page = ${param.page != null ? param.page : 1};
		let contextPath = "${pageContext.request.contextPath}";
		
	function bind(){
		reset(); 
		
		// 최초 로딩
		loadData(page);
		
		// 검색 버튼 
		const btn_sch = document.querySelector(".btn-sch");
		btn_sch.addEventListener('click', () => {
			loadData(1);
		});
		
		// Enter 검색 
		const keywordInput = document.querySelector("#keyword"); 
		keywordInput.addEventListener("keydown", (e) => {
			if (e.key === "Enter"){
				e.preventDefault(); // form submit 막기용
				loadData(1);
			}
		});
		
		// select 변경 검색 
		const typeSelect = document.querySelector("#mType");
		typeSelect.addEventListener("change",() => {
			loadData(1);
		})
	}
	
	// 초기화 버튼 
	function reset() {
		const select_reset = document.querySelector(".select-reset");
		select_reset.addEventListener('click', () => {
			location.reload(); 
		})
	}
	
	// 전체조회 + 검색 + 페이징 통합 
	function loadData(pageNum = 1){
		
		let type = document.querySelector("#mType").value;
		let keyword = document.querySelector("#keyword").value; 
		
		const params = new URLSearchParams(); 
		params.append("page", pageNum);
		params.append("type", type);
		params.append("keyword", keyword);
	
		fetch(`/board/search?\${params.toString()}`)
		.then(
			resp => resp.json()		
		).then(data => {
			
			let tbody = document.querySelector("#tbody");
			tbody.innerHTML = "";
			
			// 안전 처리 
			let list = data.searchResult ?? data.list ?? [];
			
			// 데이터 없음 
			if (list.length === 0){
				tbody.innerHTML = "<tr><td colspan = '8'>조회된 결과가 없습니다.</td></tr>";
				renderPagination(data.pageInfo);
				return;
			}
			
			// 데이터 출력 
			let html = "";
			for (let item of list){
				
				// 공지 여부 체크 
				let isNotice = item.category === '공지';
				
				// tr 클래스
				let trClass= isNotice ? 'class="notice"' : '';
				
				// 뱃지
				 let badge = isNotice ? '<span class="notice-badge">공지</span>': '';
				        
				html += `
				 <tr>
			        <td>\${item.board_num}</td>
			        <td>\${item.category}</td>
			        <td style="text-align: left; padding-left: 20px;">
			            \${badge}
			            <a href="/board/one?board_num=\${item.board_num}" class="link-txt">\${item.title}</a>
			        </td>
			        <td>\${item.ename}</td>
			        <td>\${formatDate(item.created_at)}</td>
			        <td>\${item.view_cnt}</td>
			    </tr>
				`;
			}
			
			tbody.innerHTML = html;
			
			//페이징 
			renderPagination(data.pageInfo);
			
			// URL 변경
			const newUrl = `${window.location.pathname}?\${params.toString()}`;
			window.history.pushState({ path: newUrl }, '', newUrl);
		})
		.catch(err => {
			console.error("fetch 에러:", err);
		});	
	}
	
	

	
	

	function formatDate(ts){
	    return ts ? new Date(ts).toLocaleString('ko-KR', {
	        year:'numeric',
	        month:'2-digit',
	        day:'2-digit',
	        hour:'2-digit',
	        minute:'2-digit'
	    }) : "";
	}
	
	function selectOption(text){
		document.getElementById('selectedText').innerText = text;
	}
	
	document.addEventListener('click', function(e){
		const select = document.getElementById('selectOption');
		if(!select.contains(e.target)){
			select.classList.remove('on');
		}
	})
	
	// 페이지네이션 함수 
	function renderPagination(pInfo){
		let pagingHtml = "";
		
		// 이전
		if(!pInfo.isFirstPage){
			// pg-btn -> page-link
			pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum - 1})">이전</a>`;
		}
		
		// 번호
	    pInfo.navigatepageNums.forEach(num => {
	        pagingHtml += `<a class="page-link prev-next \${num === pInfo.pageNum ? 'active' : ''}" href="javascript:movePage(\${num})">\${num}</a>`;
	    });
	    
	    // 다음
	    if (!pInfo.isLastPage) {
	        pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum + 1})">다음</a>`;
	    }
	    
	    document.querySelector(".pagination-container").innerHTML = pagingHtml;
	}
	
	window.movePage = function(pageNum){
		loadData(pageNum);
	};
	
	document.querySelector("#mType").addEventListener("change", (e) => {
	    const keyword = document.querySelector("#keyword");
	    
	    if (e.target.value === "title") {
	        keyword.placeholder = "제목 검색";
	    } else if (e.target.value === "ename") {
	        keyword.placeholder = "작성자 검색";
	    } else {
	        keyword.placeholder = "제목/작성자 검색";
	    }
	});
	
</script>

</body>
</html>