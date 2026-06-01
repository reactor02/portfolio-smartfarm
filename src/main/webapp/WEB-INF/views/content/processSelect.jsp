<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>공정 관리 시스템</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
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
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px rgba(0, 0, 0, 0.2);
	transition: background-color 0.2s;
}

.btn-reg:hover {
	background-color: #B7E4C7;
}

.btn-plus {
	background-color: #fff;
	color: #2D6A4F;
	padding: 10px 24px;
	border-radius: 6px;
	border: 1px solid #2D6A4F;
	font-weight: bold;
	font-size: 1.05rem;
	cursor: pointer;
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px rgba(0, 0, 0, 0.2);
	transition: background-color 0.2s;
}

.btn-plus:hover {
	background-color: #B7E4C7;
}

.sch-wrap {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	background-color: #f8f9fa;
	border: 1px solid #d1d5db;
	border-radius: 8px;
	padding: 20px 25px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.sch-left {
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.sch-row {
	display: flex;
	align-items: center;
	gap: 15px;
}

.sch-right {
	display: flex;
	gap: 10px;
}

.label {
	font-size: 0.95rem;
	font-weight: bold;
	color: #333;
	display: flex;
	align-items: center;
	white-space: nowrap;
}

.form-control {
	height: 38px;
	border: 1px solid #aaa;
	border-radius: 4px;
	padding: 0 10px;
	font-size: 0.95rem;
	outline: none;
	transition: border-color 0.2s;
	background-color: #fff;
}

.form-control:focus {
	border-color: #2D6A4F;
}

select.form-control {
	width: 150px;
}

.sch-input-box {
	display: flex;
	align-items: center;
	border: 1px solid #aaa;
	border-radius: 4px;
	height: 42px;
	background: #fff;
	padding-left: 10px;
	width: 570px;
}

.sch-input-box:focus-within {
	border-color: #2D6A4F;
}

.sch-input-box input {
	border: none;
	outline: none;
	height: 100%;
	flex: 1;
	padding: 0 5px;
	font-size: 0.95rem;
}

.btn-sch {
	height: 42px;
	padding: 0 24px;
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

.select-reset {
	height: 42px;
	padding: 0 24px;
	background-color: #fff;
	color: #2D6A4F;
	border: 1px solid #2D6A4F;
	border-radius: 4px;
	font-size: 1rem;
	font-weight: bold;
	cursor: pointer;
	transition: 0.2s;
}

.select-reset:hover {
	background-color: #FFB703;
	color: #fff;
	border-color: #FFB703;
}

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
	background-color: #4A90E2;
}

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

#processDesc {
	max-height: 200px;
}

.textarea-desc {
	width: 100%;
	border: 1px solid #aaa;
	border-radius: 4px;
	padding: 10px;
	font-size: 0.95rem;
	font-family: 'Malgun Gothic', sans-serif;
	outline: none;
	resize: vertical;
}

.textarea-desc:focus {
	border-color: #2D6A4F;
}
										
/* 모달 내부 박스 중앙 정렬 및 크기 지정 */
.modal-box {
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    max-width: 90%;      /* 화면이 작아질 경우를 대비 */
    overflow-y: auto;    /* 내용이 길어지면 내부 스크롤 */
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
    align-items: center;     /* 세로 중앙 */
    
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
					<h1>공정 관리</h1>
					<c:if test="${sessionScope.role >= 2}">
					<button type="button" class="btn-reg">+ 등록하기</button>
				</c:if>
				</div>

				<form name="searchFrm" method="get">
					<div class="sch-wrap">
						<div class="sch-left">
							<div class="sch-row">
								<span class="label">▶ 생산제품 타입</span>
								<select id="type" class="form-control">
									<option value="all">선택</option>
									<option value="product">완제품</option>
									<option value="semiproduct">반제품</option>
								</select>
								
								<span class="label" style="margin-left: 20px;">▶ 사용 여부</span>
								<select id="process_status" class="form-control">
									<option value="all">전체</option>
									<option value="사용중">사용중</option>
									<option value="미사용">미사용</option>
								</select>
							</div>
							
							<div class="sch-row">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span>
									<input type="text" id="keyword" value="" placeholder="공정 품목 검색">
								</div>
							</div>
						</div>
						
						<div class="sch-right">
							<button type="button" class="btn-sch">검색</button>
							<button type="button" class="select-reset">검색 초기화</button>
						</div>
					</div>
				</form>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>공정 품목</th>
								<th>생산제품 타입</th>
								<th>작업 순서</th>
								<th>작업 인원</th>
								<th>등록일자</th>
								<th>사용 여부</th>
							</tr>
						</thead>
						<tbody id="stock-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}" varStatus="vs">
										<tr>
											<td style="font-weight: bold; color: #555;">${vs.count}</td>
											<td><a href="/processDetail?process_num=${item.PROCESS_NUM}"
												class="link-txt">${item.NAME}</a></td>
											<td>${item.TYPE}</td>
											<td>${item.FLOW}</td>
											<td>${item.HEAD_COUNT}</td>
											<td>${item.CREATED_AT}</td>
											<td>${item.PROCESS_STATUS}</td>
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

	<div id="regModal" class="modal-overlay" style="display: none;">
		<div class="modal-box" style="width: 600px;">
			<h3 class="modal-title">공정 등록</h3>

			<form method="POST" accept-charset="UTF-8" action="/PinsertController" id="insert-form"
				enctype="multipart/form-data">
				<div class="modal-grid">
					<div class="modal-field">
						<label for="itemSearch">품목명 검색</label> <input type="text"
							id="itemSearch" class="searchgo" placeholder="품목명 검색">
					</div>

					<div class="modal-field">
						<label for="headCount">작업 인원</label> <input type="number"
							name="head_count" id="head_count" min="1" placeholder="필요 작업인원 입력">
					</div>
					
					<div class="modal-field">
						<label for="flowOrder">작업 순서</label> <input type="number"
							name="flow" id="flow" min="1"
							placeholder="해당 작업 순서 입력">
					</div>

					<div class="modal-field modal-field-full"
						id="selectedItemContainer"
						style="display: none; margin-top: 10px;">
						<span
							style="display: inline-block; padding: 6px 12px; background-color: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; border-radius: 4px; font-weight: bold; font-size: 14px;">
							📌 선택된 품목: <span id="selectedItemName" style="color: #0050b3;">-</span>
						</span>
					</div>

					<div class="modal-field modal-field-full" style="margin-top: 15px;">
						<label>선택 가능한 품목 리스트 (아래 행을 클릭하여 선택하세요)</label>

						<div id="searchResultArea"
							style="width: 100%; height: 200px; border: 1px solid #ccc; background: #fff; overflow-y: scroll; border-radius: 4px;">
							<table
								style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; table-layout: fixed;">
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 25%;">
									<col style="width: 35%;">
									<col style="width: 15%;">
									<col style="width: 15%;">
								</colgroup>
								<thead
									style="background: #f5f5f5; position: sticky; top: 0; border-bottom: 1px solid #ddd; z-index: 10;">
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
										<td colspan="5"
											style="padding: 50px 10px; text-align: center; color: #999;">
											품목명을 입력하면 조건에 맞는 기준관리 항목이 여기에 표시됩니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="modal-field modal-field-full" style="display: flex; flex-direction: row; gap: 20px; margin-top: 20px;">
						<div style="flex: 1; display: flex; flex-direction: column; gap: 10px;">
							<div>
								<label for="processImage">공정 이미지 첨부</label>
								<input type="file" name="image" id="processImage" accept="image/*"
									style="width: 100%; border: 1px solid #aaa; border-radius: 4px; padding: 6px; background: #fff; cursor: pointer; margin-top: 5px;">
							</div>
							<div id="imagePreviewContainer" style="width: 100%; min-height: 150px; border: 1px solid #ddd; border-radius: 4px; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9; overflow: hidden; flex: 1;">
								<span id="noImageText" style="color: #999; font-size: 14px;">첨부 된 이미지가 없습니다.</span>
								<img id="previewImage" src="#" alt="미리보기" style="display: none; max-width: 100%; max-height: 200px; object-fit: contain;">
							</div>
						</div>
						
						<div style="flex: 1; display: flex; flex-direction: column;">
							<label for="processDesc">공정 설명</label>
							<textarea name="process_content" id="processDesc" class="textarea-desc"
								placeholder="해당 공정에 대한 상세 설명을 작성해주세요." style="margin-top: 5px; flex: 1; resize: none;"></textarea>
						</div>
					</div>

				</div>
				<div class="modal-btn-wrap" style="margin-top: 30px;">
					<button type="button" class="btn-plus">등록</button>
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		function validateDate() {
			const start = document.getElementById('sDate').value;
			const end = document.getElementById('eDate').value;
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('eDate').value = "";
			}
		}
		
		function renderPagination(pInfo) {
			let pagingHtml = "";
		
			if (!pInfo.isFirstPage) {
				pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum - 1})">이전</a>`;
			}
			
			pInfo.navigatepageNums.forEach(num => {
				pagingHtml += `<a class="page-link prev-next \${num === pInfo.pageNum ? 'active' : ''}" href="javascript:movePage(\${num})">\${num}</a>`;
			});
			
			if (!pInfo.isLastPage) {
				pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum + 1})">다음</a>`;
			}
			
			document.querySelector(".pagination-container").innerHTML = pagingHtml;
		}
		
		const btn_sch = document.querySelector(".btn-sch");
		btn_sch.addEventListener('click', ()=>{
			movePage(1)
		})
		
		function movePage(pageNum) {
			let type = document.querySelector("#type").value;
			let process_status = document.querySelector("#process_status").value;
			let keyword = document.querySelector("#keyword").value;
			
			const params = new URLSearchParams();
			params.append("page", pageNum);
			params.append("type", type);
			params.append("process_status", process_status);
			params.append("keyword", keyword);
			
			fetch(`/searchProcess?\${params.toString()}`)
			.then(response => response.json())
			.then(data => {
				if(data.searchResult.length == 0){
					let tbody = document.querySelector("#stock-body");
					tbody.innerHTML = "<tr><td colspan='7'>조회된 결과가 없습니다.</td></tr>";
					renderPagination(data.pageInfo);
					return;
				}
				if(data.status === "good"){
					let tbody = document.querySelector("#stock-body");
					tbody.innerHTML = "";
					
					let html = "";
					for(let i = 0; i < data.searchResult.length; i++) {
						let item = data.searchResult[i];
						html += `<tr>
							<td style='font-weight: bold; color: #555;'>\${i + 1 + (data.pageInfo.pageNum - 1) * 5}</td>
							<td><a href="/processDetail?process_num=\${item.PROCESS_NUM}" class="link-txt">\${item.NAME}</a></td>
							<td>\${item.TYPE}</td>
							<td>\${item.FLOW}</td>
							<td>\${item.HEAD_COUNT}</td>
							<td>\${item.CREATED_AT}</td>
							<td>\${item.PROCESS_STATUS}</td>
						</tr>`;
					}
					tbody.innerHTML = html;
					
					renderPagination(data.pageInfo);

					const newUrl = window.location.pathname + `?page=\${pageNum}&type=\${type}&keyword=\${keyword}`;
					window.history.pushState({path: newUrl}, '', newUrl);
				}
			});
		}
		
		const plus_btn = document.querySelector(".btn-reg");
		const modal = document.querySelector(".modal-overlay");
		plus_btn.addEventListener('click', ()=>{
			modal.style.display = "flex";
		})
		
		const cancel = document.querySelector(".btn-cancel");
		cancel.addEventListener('click',()=>{
			modal.style.display = "none";
		})
			
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
			
			fetch(`/processModal?search=\${encodeURIComponent(query)}`)
			.then(response => response.json())
			.then(data=>{
				uploadData(data);
			})
			.catch(error=>{
				console.log(error);
			});
		})
			
		function uploadData(data){
			const suggestList = document.getElementById('suggestList');
			const Message = document.getElementById('emptyMessage');
			
			const rows = suggestList.querySelectorAll('tr');
			rows.forEach(row=>{
				if(row.id !== 'emptyMessage'){
					row.remove();
				}
			});
			
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
				});
				
				suggestList.insertAdjacentHTML('beforeend', html);
			}
			else{
				Message.querySelector('td').innerText = '검색한 조건에 맞는 항목이 없습니다.';
				Message.style.display = 'table-row';
			}
		}	
			
		const btn_plus = document.querySelector(".btn-plus");
		btn_plus.addEventListener('click',()=>{
			const radio = document.querySelector("input[type='radio']:checked");
			if(!radio){
				alert("품목을 선택해주세요.");
				return;
			}

			const headCount = document.querySelector("#head_count").value.trim();
			if(headCount === "" || isNaN(headCount) || Number(headCount) <= 0){
				alert("작업 인원을 올바르게 입력해주세요.");
				document.querySelector("#head_count").focus();
				return;
			}

			const flow = document.querySelector("#flow").value.trim();
			if(flow === "" || isNaN(flow) || Number(flow) <= 0){
				alert("작업 순서를 올바르게 입력해주세요.");
				document.querySelector("#flow").focus();
				return;
			}

			const processDesc = document.querySelector("#processDesc").value.trim();
			if(processDesc === ""){
				alert("공정 설명을 입력해주세요.");
				document.querySelector("#processDesc").focus();
				return;
			}
			
			const insert_form = document.querySelector("#insert-form");
			insert_form.submit();
		});
		
		const msgFlag = "${msg}";
		if(msgFlag == "true"){
			alert("등록되었습니다.");
			window.history.replaceState({}, document.title, window.location.pathname);
		}else if(msgFlag == "false"){
			alert("등록에 실패했습니다.");
		}
		
		const select_reset = document.querySelector(".select-reset");
		select_reset.addEventListener('click', ()=>{
			location.reload();
		})
				
		const fileInput = document.querySelector("#processImage");
		const preview = document.querySelector("#previewImage");
		const noImageText = document.querySelector("#noImageText");

		fileInput.addEventListener('change', function() {
			const file = this.files[0];
			if (file) {
				const reader = new FileReader();
				reader.onload = (e) => {
					preview.src = e.target.result;
					preview.style.display = "block";
					noImageText.style.display = "none";
				}
				reader.readAsDataURL(file);
			} else {
				preview.style.display = "none";
				preview.src = "#";
				noImageText.style.display = "block";
			}
		});
	</script>

</body>
</html>