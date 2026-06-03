<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("utf-8");
String vender_type = request.getParameter("vender_type");
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>거래처 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">

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


/* ========== 4. 데이터 테이블 ========== */
.tbl-box {
	background: #fff;
	border-radius: 8px;
	padding: 15px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.ven-tbl {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid #555;
	border-bottom: 2px solid #555;
}

.ven-tbl th {
	background-color: #e9ecef;
	color: #222;
	padding: 12px 10px;
	border: 1px solid #ccc;
	border-top: none;
	font-weight: bold;
	font-size: 0.95rem;
}

.ven-tbl td {
	padding: 12px 10px;
	border: 1px solid #ccc;
	text-align: center;
	color: #333;
	font-size: 0.95rem;
}

.ven-tbl tbody tr:hover {
	background-color: #f1f8f5;
}

.link-txt {
	color: #2D6A4F;
	text-decoration: none;
	font-weight: bold;
}

.link-txt:hover {
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

/* 작업 등록 모달 */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	justify-content: center;
	align-items: center;
}

.modal-box {
	background: #fff;
	border-radius: 10px;
	padding: 30px;
	width: 520px;
	max-height: 90vh;
	overflow-y: auto;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.modal-title {
	font-size: 1.2rem;
	font-weight: bold;
	color: var(- -m-cl);
	margin-bottom: 20px;
}

.modal-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 16px;
}

.modal-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.modal-field label {
	font-size: 12px;
	color: #777;
	font-weight: bold;
}

.modal-field input, .modal-field select, .modal-field textarea {
	padding: 8px 10px;
	border: 1px solid var(- -border-cl);
	border-radius: 6px;
	font-size: 13px;
	font-family: inherit;
}

.modal-field-full {
	grid-column: 1/-1;
}

.modal-btn-wrap {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 20px;
}

.modal-btn-wrap button {
	padding: 9px 22px;
	border
}
</style>


</head>
<body>
	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="hdr">
					<h1>거래처 관리</h1>
					<c:if test="${sessionScope.role >= 2 }">
					<button type="button" class="btn-reg link-txt"
						id="btnOpenWorkModal">+ 등록하기</button>
					</c:if>
				</div>

				<%-- 검색창 action --%>
				<form name="searchFrm" action="${pageContext.request.contextPath}/vender/search" method="get">
					<div class="sch-wrap">
						<div class="sch-row">

							<div class="sch-left">
								<span class="label">▶ 거래 유형</span> 
								<select class="form-control" name="type" id="mType">
									<option value="">선택</option>
									<option value="공급업체">공급업체</option>
									<option value="고객사">고객사</option>
									<option value="협력업체">협력업체</option>
									<option value="유통업체">유통업체</option>
								</select>


							</div>
							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> <input type="text"
										id="keyword" name="keyword" placeholder="거래처명 검색">

								</div>
								<button type="button" class="btn-sch" id="search">검색</button>
								<button type="button" class="select-reset" id="init">검색 초기화</button>
							</div>
						</div>
					</div>

				</form>

				<%-- 테이블 리스트 --%>

				<div class="tbl-box">
					<table class="ven-tbl">
						<thead>
							<tr>
								<th>no.</th>
								<th>거래처명</th>
								<th>대표자명</th>
								<th>거래 유형</th>
								<th>거래처 연락처</th>
								<th>거래처 주소</th>
								<th>담당 사원</th>
							</tr>
						</thead>
						<tbody id="tbody"></tbody>
					</table>
				</div>

				<div class="table-responsive"></div>

				<jsp:include page="/WEB-INF/views/common/paging.jsp" />
			</main>

		</div>
		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<!-- 거래처 등록 모달 -->
	<div id="workModal" class="modal-overlay">
		<div class="modal-box">
			<h3 class="modal-title">거래처 등록</h3>
			<form id="venRegForm" action="/vender/insert" method="post"
				accept-charset="UTF-8">
				<div class="modal-grid">
					<div class="modal-field">
						<label>거래처명</label> <input type="text" name="vender_name"
							placeholder="거래처명">
					</div>
					<div class="modal-field">
						<label>대표자명</label> <input type="text" name="ven_ename"
							placeholder="대표자명">
					</div>
					<div class="modal-field">
						<label>사업자등록번호</label> <input type="text" name="biz_no"
							placeholder="사업자등록번호">
					</div>
					<div class="modal-field">
						<label>거래처 타입</label> <select name="vender_type">
							<option value="">선택</option>
							<option value="공급업체">공급업체</option>
							<option value="고객사">고객사</option>
							<option value="협력업체">협력업체</option>
							<option value="유통업체">유통업체</option>
						</select>
					</div>
					<div class="modal-field">
						<label>연락처</label> <input type="text" name="vender_phone"
							placeholder="연락처">
					</div>
					<div class="modal-field">
						<label>주소</label> <input type="text" name="vender_addr"
							placeholder="주소">
					</div>
					<div class="modal-field">
						<label>담당 사원</label> <input type="number" name="emp_num"
							placeholder="사원번호">
					</div>
				</div>
				<div class="modal-btn-wrap">
					<button type="submit" class="btn-submit">등록</button>
					<button type="button" class="btn-close" id="btnCloseWorkModal">닫기</button>
				</div>
			</form>
		</div>
	</div>


	<div id="pagination"></div>

	<script>

	window.addEventListener('load', () => {
	    bind();
	});

	// 서버에서 넘어온 page 값
	let page = ${param.page != null ? param.page : 1};

	function bind() {
	    reset();
	    modal();

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
	        if (e.key === "Enter") {
	            e.preventDefault(); // form submit 막기
	            loadData(1);
	        }
	    });
	    
	    // select 변경 검색 
	    const typeSelect = document.querySelector("#mType");
	    typeSelect.addEventListener("change", () => {
	        loadData(1);
	    });
	    
	}
	
	

	// 초기화 버튼
	function reset() {
	    const select_reset = document.querySelector(".select-reset");
	    select_reset.addEventListener('click', () => {
	        location.reload();
	    });
	}

	//  전체조회 + 검색 + 페이징 통합
	function loadData(pageNum = 1) {

	    let type = document.querySelector("#mType").value;
	    let keyword = document.querySelector("#keyword").value;

	    const params = new URLSearchParams();
	    params.append("page", pageNum);
	    params.append("type", type);
	    params.append("keyword", keyword);

	    fetch(`/vender/search?\${params.toString()}`)
	    .then(res => res.json())
	    .then(data => {

	        let tbody = document.querySelector("#tbody");
	        tbody.innerHTML = "";

	        // 안전 처리
	        let list = data.searchResult ?? data.list ?? [];

	        // 데이터 없음
	        if (list.length === 0) {
	            tbody.innerHTML = "<tr><td colspan='8'>조회된 결과가 없습니다.</td></tr>";
	            renderPagination(data.pageInfo);
	            return;
	        }

	        // 데이터 출력
	        let html = "";
	        for (let item of list) {
	            html += `
	                <tr>
	                    <td>\${item.vender_num}</td>
	                    <td style="text-align:left; padding-left:20px">
	                        <a href="/vender/one?vender_num=\${item.vender_num}" class="link-txt">
	                            \${item.vender_name}
	                        </a>
	                    </td>
	                    <td>\${item.ven_ename}</td>
	                    <td>\${item.vender_type}</td>
	                    <td>\${item.vender_phone}</td>
	                    <td>\${item.vender_addr}</td>
	                    <td>\${item.ename}</td>
	                </tr>
	            `;
	        }

	        tbody.innerHTML = html;

	        // 페이징
	        renderPagination(data.pageInfo);

	        // URL 변경
	        const newUrl = `${window.location.pathname}?\${params.toString()}`;
	        window.history.pushState({ path: newUrl }, '', newUrl);
	    })
	    .catch(err => {
	        console.error("fetch 에러:", err);
	    });
	}

	// 모달
	function modal() {
	    var btnOpenWork = document.getElementById('btnOpenWorkModal');

	    if (btnOpenWork) {
	        btnOpenWork.addEventListener('click', function () {
	            document.getElementById('workModal').style.display = 'flex';
	        });
	    }

	    document.getElementById('btnCloseWorkModal').addEventListener('click', function () {
	        document.getElementById('workModal').style.display = 'none';
	    });

	    document.getElementById('workModal').addEventListener('click', function (e) {
	        if (e.target == this) this.style.display = 'none';
	    });
	}

	// 페이지네이션 함수
	function renderPagination(pInfo) {
	    let pagingHtml = "";
	    
	    // 이전
	    if (!pInfo.isFirstPage) {
	        // pg-btn -> page-link
	        pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum - 1})">이전</a>`;
	    }
	    
	    // 번호
	    pInfo.navigatepageNums.forEach(num => {
	        // pg-btn -> page-link, pg-active -> active (원하시는 명칭으로)
	        pagingHtml += `<a class="page-link prev-next \${num === pInfo.pageNum ? 'active' : ''}" href="javascript:movePage(\${num})">\${num}</a>`;
	    });
	    
	    // 다음
	    if (!pInfo.isLastPage) {
	        // pg-btn -> page-link
	        pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum + 1})">다음</a>`;
	    }
	    
	    document.querySelector(".pagination-container").innerHTML = pagingHtml;
	}
	
	window.movePage = function(pageNum) {
	    loadData(pageNum);
	};
	
</script>

</body>
</html>