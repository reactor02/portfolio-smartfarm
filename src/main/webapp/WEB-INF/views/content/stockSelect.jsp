<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>재고 관리 시스템</title>
<link rel="stylesheet" href="/resources/css/paging.css">
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

.btn-plus:hover {
	background-color: #B7E4C7;
}
.btn-plus {
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
.select-reset{
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
.select-reset:hover{
background-color: #FFB703;
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

/* ========== 4. 데이터 테이블 ========== */
.tbl-box {
	background: #fff;
	border-radius: 8px;
	padding: 15px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.stk-tbl {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid #555;
	border-bottom: 2px solid #555;
}

.stk-tbl th {
	background-color: #e9ecef;
	color: #222;
	padding: 12px 10px;
	border: 1px solid #ccc;
	border-top: none;
	font-weight: bold;
	font-size: 0.95rem;
}

.stk-tbl td {
	padding: 12px 10px;
	border: 1px solid #ccc;
	text-align: center;
	color: #333;
	font-size: 0.95rem;
}

.stk-tbl tbody tr:hover {
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
/* 모달 내부 박스 중앙 정렬 및 크기 지정 */
.modal-box {
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    max-width: 90%;      /* 화면이 작아질 경우를 대비 */
    overflow-y: auto;    /* 내용이 길어지면 내부 스크롤 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}
.modal-overlay {
    position: fixed; /* 화면 기준 고정 */
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
    
    /* 여기서 중앙 정렬 핵심! */
    display: flex;         
    justify-content: center; /* 가로 중앙 */
    align-items: center;     /* 세로 중앙 */
    
    z-index: 1000; /* 다른 요소보다 위에 표시 */
}
</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>재고 관리</h1>
					<button type="button" class="btn-reg">+ 등록하기</button>
				</div>

				<form name="searchFrm" action="stockList.do" method="get">
					<div class="sch-wrap">


						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 자재유형</span> <select id="mType"
									class="form-control">
									<option value="all">선택</option>
									<option value="equip">설비</option>
									<option value="product">제품</option>
									<option value="semiproduct">반제품</option>
									<option value="raw">재료</option>
								</select>
							</div>

							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> <input type="text"
										id="keyword" value="" placeholder="자재 명 검색">
								</div>
								<button type="button" class="btn-sch">검색</button>
								<button type="button" class="select-reset">검색 초기화</button>
							</div>
						</div>
					</div>
				</form>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>자재 코드</th>
								<th>자재 명</th>
								<th>자재 구분</th>
								<th>현재고 수량</th>
								<th>안전재고 수량</th>
								<th>단위</th>
								<th>보관위치</th>
							</tr>
						</thead>
						<tbody id="stock-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}" varStatus="vs">
										<tr>
											<td style="font-weight: bold; color: #555;">${vs.count}</td>
											<td>${item.CODE}</td>
											<td><a href="/stockDetail?stock_id=${item.STOCK_ID}" class="link-txt">${item.NAME}</a></td>
											<td>${item.TYPE}</td>
											<td>${item.STOCK_QTY}</td>
											<td>${item.SAFE}</td>
											<td>${item.UNIT}</td>
											<td>${item.FACILITY_NAME}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" begin="1" end="5">
										<tr>
											<td style="font-weight: bold; color: #888;">${i}</td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<div class="table-responsive"></div>
				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>
	<!-- 재고 등록 -->
	<div id="regModal" class="modal-overlay" style="display: none;">
		<div class="modal-box">
			<h3 class="modal-title">재고 등록</h3>

			<form method="POST" action="/insertController" id="insert-form">
				<div class="modal-grid">
					<div class="modal-field">
						<label for="itemSearch">품목명 검색</label> 
						<input type="text" id="itemSearch" placeholder="품목명 검색"> 
					</div>
					
					<div class="modal-field">
						<label for="quantity">개수</label> 
						<input type="number" name="stock_qty" id="quantity" min="1" placeholder="수량 입력">
					</div>

					<div class="modal-field modal-field-full" id="selectedItemContainer" style="display: none; margin-top: 10px;">
						<span style="display: inline-block; padding: 6px 12px; background-color: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; border-radius: 4px; font-weight: bold; font-size: 14px;">
							📌 선택된 품목: <span id="selectedItemName" style="color: #0050b3;">-</span>
						</span>
					</div>

					<div class="modal-field modal-field-full" style="margin-top: 15px;">
						<label>선택 가능한 품목 리스트 (아래 행을 클릭하여 선택하세요)</label>

						<div id="searchResultArea" style="width: 100%; height: 200px; border: 1px solid #ccc; background: #fff; overflow-y: scroll; border-radius: 4px;">
							<table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; table-layout: fixed;">
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 25%;">
									<col style="width: 35%;">
									<col style="width: 15%;">
									<col style="width: 15%;">
								</colgroup>
								<thead style="background: #f5f5f5; position: sticky; top: 0; border-bottom: 1px solid #ddd; z-index: 10;">
									<tr>
										<th style="padding: 10px; text-align: center;">선택</th>
										<th style="padding: 10px;">품목코드</th>
										<th style="padding: 10px;">품목명</th>
										<th style="padding: 10px;">타입</th>
										<th style="padding: 10px;">단위</th>
									</tr>
								</thead>
								<tbody id="suggestList">
									<tr id="emptyMessage">
										<td colspan="5" style="padding: 50px 10px; text-align: center; color: #999;">
											품목명을 입력하면 조건에 맞는 기준관리 항목이 여기에 표시됩니다.
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="modal-btn-wrap" style="margin-top: 20px;">
					<button type="button" class="btn-plus">등록</button>
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>



	<!-- 스크립트 -->
	<script>
		/* 날짜 유효성 검사 로직 */
		function validateDate() {
			const start = document.getElementById('sDate').value;
			const end = document.getElementById('eDate').value;
			//(start && end) start와 end가 존재할 때 start의 값이 end보다 크면
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('eDate').value = "";
			}
		}
		
		
		
		
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
		
		
		
		
// 		검색 버튼 클릭시 아작스
		const btn_sch = document.querySelector(".btn-sch");
		btn_sch.addEventListener('click', ()=>{
			movePage(1)
		})
		
		
		//페이징 관련 함수
	function movePage(pageNum) {
    let type = document.querySelector("#mType").value;
    let keyword = document.querySelector("#keyword").value;
    
    const params = new URLSearchParams();
    params.append("page", pageNum); // 누른 페이지 번호를 전달
    params.append("type", type);
    params.append("keyword", keyword);
    
    fetch(`/searchStock?\${params.toString()}`)
    .then(response => response.json())
    .then(data => {
    	if(data.searchResult.length == 0){
    		 let tbody = document.querySelector("#stock-body");
    	    tbody.innerHTML = "<tr><td colspan='8'>조회된 결과가 없습니다.</td></tr>";
    	    renderPagination(data.pageInfo); // 페이지 정보도 갱신하여 페이징 버튼도 사라지게 처리
    	    return;
    	}
        if(data.status === "good"){
            // 1. 테이블 데이터 갱신
            let tbody = document.querySelector("#stock-body");
            tbody.innerHTML = "";
            
            let html = "";
            for(let i = 0; i < data.searchResult.length; i++) {
                let item = data.searchResult[i];
                html += `<tr>
                    <td style='font-weight: bold; color: #555;'>\${i + 1 + (data.pageInfo.pageNum - 1) * 5}</td>
                    <td>\${item.CODE}</td>
                    <td><a href='/stockDetail?stock_id=\${item.STOCK_ID}' class='link-txt'>\${item.NAME}</a></td>
                    <td>\${item.TYPE}</td>
                    <td>\${item.STOCK_QTY}</td>
                    <td>\${item.SAFE}</td>
                    <td>\${item.UNIT}</td>
                    <td>\${item.FACILITY_NAME}</td>
                </tr>`;
            }
            tbody.innerHTML = html;
            
            renderPagination(data.pageInfo);

            const newUrl = window.location.pathname + `?page=\${pageNum}&type=\${type}&keyword=\${keyword}`;
            window.history.pushState({path: newUrl}, '', newUrl);
        }
    });
}
		
		
		
		////////모달 영역
		const plus_btn = document.querySelector(".btn-reg");
			const modal =  document.querySelector(".modal-overlay");
		plus_btn.addEventListener('click', ()=>{
			modal.style.display = "flex";
		})
			//취소 버튼 클릭
			const cancel = document.querySelector(".btn-cancel");
			cancel.addEventListener('click',()=>{
				modal.style.display = "none";
			})
			
			
			
		//모달///////////////////////////////////////////////
		
		//모달 검색창 인풋 ajax
		const itemSearch = document.querySelector("#itemSearch");
			itemSearch.addEventListener('input', ()=>{
				const query = itemSearch.value.trim();
				
				if(query === ""){
					document.querySelector("#suggestList").innerHTML = "";
					suggestList.innerHTML = `
			            <tr id="emptyMessage">
			                <td colspan="5" style="padding: 50px 10px; text-align: center; color: #999;">
			                    품목명을 입력하면 조건에 맞는 기준관리 항목이 여기에 표시됩니다.
			                </td>
			            </tr>
			        `;
					return;
				}
				
				fetch(`/modal?search=\${encodeURIComponent(query)}`)
				.then(response => response.json())
				.then(data=>{
					//여기에 받은 데이터 화면 갱신 로직 넣기 메서드 만들어서 넣으면 될듯 전달인자로 data넣어서
					uploadData(data);
				})
				.catch(error=>{
					console.log("등록모달 검색 에러 났음", error);
				});
			})
			
			
			
			//받은 data를 들고 테이블 만드는 함수
			function uploadData(data){
				const suggestList = document.getElementById('suggestList');
				const Message = document.getElementById('emptyMessage');
				
				
				const rows = suggestList.querySelectorAll('tr');
				rows.forEach(row=>{
					//테이블에 있는 tr중에 id가 emptyMessage(메시지)인것 빼고 제거
					if(row.id !== 'emptyMessage'){
						row.remove();
					}
				});//rows.forEach
				const itemList = data.result;
				if(itemList && itemList.length> 0){
					Message.style.display = 'none';
					
					let html = "";
					itemList.forEach(item =>{
						html += `<tr>
							<td style="text-align:center;"><input type="radio" name="item_num" value="\${item.ITEM_NUM || ''}"></td>
			                <td>\${item.CODE || ''}</td>
			                <td>\${item.NAME || ''}</td>
			                <td>\${item.TYPE || ''}</td>
			                <td>\${item.UNIT || 0}</td>
			            </tr>`;
			        });//data.forEach
					
			        //insertAdjacentHTML: html문자열을 태그로 바꿔서 넣음
			        //'beforeend': suggestList의 태그가 닫히기 직전에 넣음
					suggestList.insertAdjacentHTML('beforeend', html);
					}//if(data && data.length> 0)
					else{
						Message.querySelector('td').innerText = '검색한 조건에 맞는 항목이 없습니다.';
						Message.style.display = 'table-row';
					}
				}	//메서드 끝	
				
				
				
				//등록버튼 누르면 insert
				const btn_plus = document.querySelector(".btn-plus");
				btn_plus.addEventListener('click',()=>{
					
					//개수 인풋 값
					const quantity = document.querySelector("#quantity").value;
					//체크된 라디오 
					const radio = document.querySelector("input[type='radio']:checked");
					if(radio == null){//방어로직 : 아무 것도 선택하지 않았다면 작동
						alert("선택된 항목이 없습니다.");
					return;
					}
					if(quantity < 0){
						alert("개수를 제대로 확인해주세요");
						return;
					}
					const insert_form = document.querySelector("#insert-form");
					insert_form.submit();
				});
					const msgFlag = "${msg}";
					console.log("msgFlag:  ",msgFlag);
					if(msgFlag == "true"){
						
						alert("등록되었습니다.");
						//알림창 뜬 후에 주소창 쿼리스트링 제거
						window.history.replaceState({}, document.title, window.location.pathname);
					}else if(msgFlag == "false"){
						alert("등록에 실패했습니다.");
					}
					
					const select_reset = document.querySelector(".select-reset");
					select_reset.addEventListener('click', ()=>{
						location.reload();
					})

				
	</script>

</body>
</html>