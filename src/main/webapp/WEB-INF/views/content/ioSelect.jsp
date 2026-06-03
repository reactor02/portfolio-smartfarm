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
<title>입출고 관리</title>
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
	font-size: 1.7rem;
	color: #ffffff;
	font-weight: bold;
	letter-spacing: -1px;
}

.btn-reg, .btn-plus, .btn-out {
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

.btn-reg:hover, .btn-plus:hover, .btn-out:hover {
	background-color: #B7E4C7;
}

.sch-wrap {
	background-color: #fff;
	border: 1px solid #bbb;
	border-radius: 10px;
	padding: 20px 25px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.sch-row {
	display: flex;
	align-items: center;
	width: 100%;
	gap: 20px;
}

.sch-group {
	display: flex;
	align-items: center;
	gap: 10px;
}

.sch-group-right {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-left: auto;
}

.label {
	font-size: 0.95rem;
	font-weight: bold;
	color: #333;
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
}

.form-control.date-input {
	width: 150px;
}

.form-control.select-input {
	width: 220px;
}

.form-control:focus {
	border-color: #2D6A4F;
}

.sch-input-box {
	display: flex;
	align-items: center;
	border: 1px solid #aaa;
	border-radius: 4px;
	height: 38px;
	background: #fff;
	padding-left: 10px;
	width: 280px;
}

.sch-input-box input {
	border: none;
	outline: none;
	height: 100%;
	flex: 1;
	padding: 0 8px;
	font-size: 0.95rem;
}

.btn-sch, .select-reset {
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
	white-space: nowrap;
}

.btn-sch:hover {
	background-color: #B7E4C7;
}

.select-reset:hover {
	background-color: #FFB703;
	color: #fff;
	border-color: #FFB703;
}

.sch-radio-group {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-left: 20px;
	padding-left: 20px;
	border-left: 1px solid #ddd;
}

.radio-label {
	display: flex;
	align-items: center;
	cursor: pointer;
	font-size: 0.95rem;
	color: #222;
}

.radio-label input[type="radio"] {
	appearance: none;
	-webkit-appearance: none;
	width: 18px;
	height: 18px;
	border: 2px solid #ccc;
	border-radius: 50%;
	margin-right: 6px;
	position: relative;
	cursor: pointer;
	outline: none;
}

.radio-label input[type="radio"]:checked {
	border-color: #2D6A4F;
}

.radio-label input[type="radio"]:checked::after {
	content: '';
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 8px;
	height: 8px;
	background-color: #2D6A4F;
	border-radius: 50%;
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

.modal-box {
	max-width: 800px !important;
	width: 90% !important;
}

.section-title {
	font-size: 1.1rem;
	color: #2D6A4F;
	margin-bottom: 15px;
	font-weight: bold;
	border-left: 4px solid #2D6A4F;
	padding-left: 8px;
}

.child-row {
	transition: background-color 0.2s, color 0.2s;
}

.child-row.disabled {
	background-color: #f4f4f4;
	color: #a0a0a0;
}

.child-row.disabled input[type="number"] {
	background-color: #e9e9e9;
	cursor: not-allowed;
	border-color: #ddd;
	color: #a0a0a0;
}

.qty-input {
	width: 100%;
	max-width: 100px;
	padding: 6px;
	border: 1px solid #aaa;
	border-radius: 4px;
	text-align: right;
	outline: none;
	transition: border-color 0.2s;
}

.qty-input:focus {
	border-color: #2D6A4F;
}

.link-txt {
	color: #2D6A4F;
	text-decoration: none;
	font-weight: bold;
}

.link-txt:hover {
	text-decoration: underline;
}
</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>입고/출고 조회</h1>
					<c:if test="${sessionScope.role >= 2}">
						<div style="display: flex; gap: 20px; align-items: center;">
							<button type="button" class="btn-reg">+ 입고 등록하기</button>
							<button type="button" class="btn-out">+ 출고 등록하기</button>
						</div>
					</c:if>
				</div>

				<form name="searchFrm" action="bomList.do" method="get">
					<div class="sch-wrap">
						<div class="sch-row">
							<div class="sch-group">
								<span class="label">▶ 입고/출고 날짜</span> 
								<input type="date" id="sDate" class="form-control date-input" onchange="validateDate()"> 
								<span style="font-weight: bold; padding: 0 5px;">~</span> 
								<input type="date" id="eDate" class="form-control date-input" onchange="validateDate()">
							</div>

							<div class="sch-radio-group">
								<label class="radio-label"> 
									<input type="radio" name="io_type" value="all" checked> 전체
								</label> 
								<label class="radio-label"> 
									<input type="radio" name="io_type" value="in"> 입고
								</label> 
								<label class="radio-label"> 
									<input type="radio" name="io_type" value="out"> 출고
								</label>
							</div>
						</div>

						<div class="sch-row">
							<div class="sch-group">
								<span class="label">▶ 자재유형</span> 
								<select id="type" class="form-control select-input">
									<option value="all" selected>전체</option>
									<option value="product">완제품</option>
									<option value="semiproduct">반제품</option>
									<option value="equip">설비</option>
									<option value="raw">재료</option>
								</select>
							</div>

							<div class="sch-group-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> 
									<input type="text" id="keyword" value="" placeholder="자재명 혹은 LOT번호 검색">
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
								<th>입고/출고 여부</th>
								<th>자재명</th>
								<th>수량</th>
								<th>LOT번호</th>
								<th>자재유형</th>
								<th>입고/출고 날짜</th>
								<th>저장 위치</th>
								<th>비고/사유</th>
							</tr>
						</thead>
						<tbody id="bom-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}" varStatus="vs">
										<tr>
											<td style="font-weight: bold; color: #555;">${vs.count}</td>
											<td>${item.IO_TYPE}</td>
											<td>${item.NAME}</td>
											<td>${item.IO_QTY}</td>
											<td>${item.LOT_CODE}</td>
											<td>${item.TYPE}</td>
											<td>${item.IO_DATE}</td>
											<td>${item.FACILITY_NAME}</td>
											<td>${item.IO_REASON}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" begin="1" end="6">
										<tr>
											<td style="font-weight: bold; color: #888;">${i}</td>
											<td></td>
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

				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<div id="regModal" class="modal-overlay" style="display: none;">
		<div class="modal-box" style="max-width: 650px;">
			<h3 class="modal-title">입고 등록</h3>
			<form method="POST" action="insertIo" accept-charset="UTF-8" onsubmit="document.charset='UTF-8';" id="insert-form"> 
				<div class="modal-grid">
					<div class="modal-field">
						<label for="ioDate">입출고 날짜</label> 
						<input type="date" name="io_date" id="ioDate" required>
					</div>

					<div class="modal-field">
						<label for="itemSearch">자재 검색 (완제품 제외)</label> 
						<input type="text" id="itemSearch" placeholder="자재명 또는 자재코드 입력">
					</div>

					<div class="modal-field">
						<label for="ioQty">수량</label> 
						<input type="number" name="io_qty" id="ioQty" min="1" placeholder="수량 입력" required>
					</div>

					<div class="modal-field modal-field-full" id="selectedItemContainer" style="display: none; margin-top: 5px;">
						<span style="display: inline-block; padding: 6px 12px; background-color: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; border-radius: 4px; font-weight: bold; font-size: 14px;">
							📌 선택된 자재: <span id="selectedItemName" style="color: #0050b3;">-</span>
							<span style="margin-left: 10px; font-weight: normal; color: #666;">
								[타입: <span id="selectedItemType">-</span>]
							</span>
						</span>
					</div>

					<div class="modal-field modal-field-full" style="margin-top: 5px;">
						<label>검색 결과 (클릭하여 자재를 선택하세요)</label>
						<div id="searchResultArea" style="width: 100%; height: 150px; border: 1px solid #ccc; background: #fff; overflow-y: scroll; border-radius: 4px;">
							<table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; table-layout: fixed;">
								<colgroup>
									<col style="width: 12%;">
									<col style="width: 28%;">
									<col style="width: 35%;">
									<col style="width: 25%;">
								</colgroup>
								<thead style="background: #f5f5f5; position: sticky; top: 0; border-bottom: 1px solid #ddd; z-index: 10;">
									<tr>
										<th style="padding: 8px; text-align: center;">선택</th>
										<th style="padding: 8px;">자재코드</th>
										<th style="padding: 8px;">자재명</th>
										<th style="padding: 8px;">자재유형</th>
									</tr>
								</thead>
								<tbody id="suggestList">
									<tr id="emptyMessage">
										<td colspan="4" style="padding: 30px 10px; text-align: center; color: #999;">
											자재명을 입력하면 완제품을 제외한 항목이 표시됩니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="modal-field modal-field-full">
						<label for="facilityNum">위치 (창고/시설)</label> 
						<select name="facility_num" id="facilityNum" style="width: 100%; height: 40px; border: 1px solid #ccc; border-radius: 4px; padding: 0 10px;" required>
							<c:forEach var="f" items="${facilityList}">
								<option value="${f.FACILITY_NUM}">${f.FACILITY_NAME}</option>
							</c:forEach>
						</select>
					</div>

					<div class="modal-field modal-field-full">
						<label for="ioReason">사유 / 비고</label> 
						<input type="text" name="io_reason" id="ioReason" placeholder="예: 생산투입, 고객출고, 초기재고입고 등">
					</div>
				</div>

				<div class="modal-btn-wrap" style="margin-top: 25px;">
					<button type="submit" class="btn-plus">입고 등록</button>
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>

	<div id="outModal" class="modal-overlay" style="display: none;">
		<div class="modal-box" style="max-width: 750px;">
			<h3 class="modal-title">출고 등록</h3>
			<form method="POST" action="/insertOutbound" accept-charset="UTF-8" id="outbound-form">
				<input type="hidden" name="emp_num" value="${sessionScope.loginUser.emp_num}">

				<div class="modal-grid">
					<div class="modal-field">
						<label for="outDate">출고 날짜</label> 
						<input type="date" name="io_date" id="outDate" required>
					</div>
					<div class="modal-field">
						<label for="outFacility">출고 대상 시설/창고</label> 
						<select name="facility_num" id="outFacility" style="width: 100%; height: 40px; border: 1px solid #ccc; border-radius: 4px; padding: 0 10px;" required>
							<c:forEach var="f" items="${facilityList}">
								<option value="${f.FACILITY_NUM}">${f.FACILITY_NAME}</option>
							</c:forEach>
						</select>
					</div>

					<div class="modal-field modal-field-full" style="margin-top: 15px;">
						<label>출고 대상 LOT (현재 재고가 있는 제품만 표시됩니다)</label>
						<div style="width: 100%; height: 200px; border: 1px solid #ccc; background: #fff; overflow-y: scroll; border-radius: 4px;">
							<table style="width: 100%; border-collapse: collapse; text-align: center; font-size: 14px;">
								<thead style="background: #f5f5f5; position: sticky; top: 0; border-bottom: 1px solid #ddd; z-index: 10;">
									<tr>
										<th style="padding: 8px;">선택</th>
										<th style="padding: 8px;">LOT 번호</th>
										<th style="padding: 8px;">제품 번호</th>
										<th style="padding: 8px;">제품 명</th>
										<th style="padding: 8px;">현재 수량</th>
										<th style="padding: 8px;">유통 기한</th>
									</tr>
								</thead>
								<tbody id="lotListBody">
									</tbody>
							</table>
						</div>
					</div>

					<div class="modal-field">
						<label for="outQty">출고 수량</label>
						<div style="display: flex; align-items: center; gap: 10px;">
							<input type="number" name="io_qty" id="outQty" min="1" placeholder="수량 입력" required disabled> 
							<span id="maxQtyGuide" style="color: #e63946; font-size: 13px; font-weight: bold;">LOT를 먼저 선택해주세요.</span>
						</div>
					</div>

					<div class="modal-field modal-field-full">
						<label for="outReason">사유 / 비고</label> 
						<input type="text" name="io_reason" id="outReason" placeholder="예: 생산 라인 투입, 불량 폐기 등">
					</div>
				</div>

				<div class="modal-btn-wrap" style="margin-top: 25px;">
					<button type="submit" class="btn-plus">출고 등록</button>
					<button type="button" class="btn-cancel" id="closeOutModal">취소</button>
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
			movePage(1);
		});
		
		function movePage(pageNum) {
			let sDate = document.querySelector("#sDate").value;
			let eDate = document.querySelector("#eDate").value;
			let type = document.querySelector("#type").value;
			let keyword = document.querySelector("#keyword").value;
			let io_type = document.querySelector('input[name="io_type"]:checked').value;
			
			const params = new URLSearchParams();
			params.append("page", pageNum);
			params.append("sDate", sDate);
			params.append("eDate", eDate);
			params.append("type", type);
			params.append("io_type", io_type);
			params.append("keyword", keyword);
			
			fetch(`/searchIo?\${params.toString()}`)
			.then(response => response.json())
			.then(data => {
				if(data.searchResult.length == 0){
					 let tbody = document.querySelector("#bom-body");
					 tbody.innerHTML = "<tr><td colspan='9'>조회된 결과가 없습니다.</td></tr>";
					 renderPagination(data.pageInfo);
					 return;
				}
				
				if(data.status === "good"){
					let tbody = document.querySelector("#bom-body");
					tbody.innerHTML = "";
					let html = "";
					for(let i = 0; i < data.searchResult.length; i++) {
						let item = data.searchResult[i];
						html += `<tr>
							<td style='font-weight: bold; color: #555;'>\${i + 1 + (data.pageInfo.pageNum - 1) * data.pageInfo.pageSize}</td>
							<td>\${item.IO_TYPE}</td>
							<td>\${item.NAME}</td>
							<td>\${item.IO_QTY}</td>
							<td>\${item.LOT_CODE}</td>
							<td>\${item.TYPE}</td>
							<td>\${item.IO_DATE}</td>
							<td>\${item.FACILITY_NAME}</td>
							<td>\${item.IO_REASON}</td>
						</tr>`;
					}
					tbody.innerHTML = html;
					renderPagination(data.pageInfo);

					const newUrl = window.location.pathname + `?page=\${pageNum}&ioType=\${ioType}&keyword=\${keyword}`
					window.history.pushState({path: newUrl}, '', newUrl);
				}
			})
			.catch(error => {
				console.error("데이터 통신 중 오류가 발생했습니다.", error);
			});
		}
		
		const select_reset = document.querySelector(".select-reset");
		select_reset.addEventListener('click', ()=>{
			location.reload();
		})
		
		const plus_btn = document.querySelector(".btn-reg");
		const modal = document.querySelector(".modal-overlay");
		
		plus_btn.addEventListener('click', ()=>{
			modal.style.display = "flex";
		})
		
		const cancel = document.querySelector(".btn-cancel");
		cancel.addEventListener('click',()=>{
			modal.style.display = "none";
		})

		function toggleChildRow(checkbox) {
			const row = checkbox.closest('tr');
			const input = row.querySelector('.qty-input');
			
			if (checkbox.checked) {
				row.classList.remove('disabled');
				input.disabled = false;
				input.focus();
			} else {
				row.classList.add('disabled');
				input.disabled = true;
				input.value = ''; 
			}
		}
		
		const itemSearch = document.querySelector("#itemSearch");
		itemSearch.addEventListener('input', ()=>{
			const query = itemSearch.value.trim();
			if(query === ""){
				document.querySelector("#suggestList").innerHTML = `
					<tr id="emptyMessage">
						<td colspan="4" style="padding: 30px 10px; text-align: center; color: #999;">
							자재명을 입력하면 완제품을 제외한 항목이 표시됩니다.
						</td>
					</tr>
				`;
				return;
			}
			
			fetch(`/modalSearch2?keyword=\${encodeURIComponent(query)}`)
			.then(response => response.json())
			.then(data=>{
				uploadData(data);
			})
			.catch(error=>{
				console.log("등록모달 검색 에러 났음", error);
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
			const itemList = data;
			if(itemList && itemList.length > 0){
				Message.style.display = 'none';
				
				let html = "";
				itemList.forEach(item =>{
					html += `<tr>
						<td style="text-align:center;"><input type="radio" name="item_num" value="\${item.ITEM_NUM || ''}"></td>
						<td>\${item.CODE || ''}</td>
						<td>\${item.NAME || ''}</td>
						<td>\${item.TYPE || ''}</td>
					</tr>`;
				});
				
				suggestList.insertAdjacentHTML('beforeend', html);
			} else {
				Message.querySelector('td').innerText = '검색한 조건에 맞는 항목이 없습니다.';
				Message.style.display = 'table-row';
			}
		}	
		
		const insertForm = document.querySelector("#insert-form");
		insertForm.addEventListener('submit', function(e) {
			const checkedRadio = document.querySelector('input[name="item_num"]:checked');
			if (!checkedRadio) {
				alert("등록하실 자재를 검색 후 선택해주세요.");
				e.preventDefault();
				return false;
			}
			
			const ioQty = document.querySelector("#ioQty").value;
			if (!ioQty || ioQty < 1) {
				alert("수량을 1개 이상 입력해주세요.");
				e.preventDefault();
				return false;
			}
		});

		const out_btn = document.querySelector(".btn-out");
		const outModal = document.querySelector("#outModal");
		const closeOutModal = document.querySelector("#closeOutModal");

		out_btn.addEventListener('click', () => {
			outModal.style.display = "flex";
			document.querySelector("#outDate").value = new Date().toISOString().substring(0, 10);
			document.querySelector("#outQty").value = "";
			document.querySelector("#outQty").disabled = true;
			document.querySelector("#maxQtyGuide").innerText = "LOT를 먼저 선택해주세요.";
			
			fetch('/outModalSelect')
				.then(response => response.json())
				.then(data => {
					const tbody = document.querySelector("#lotListBody");
					tbody.innerHTML = "";
					
					if(data.length === 0) {
						tbody.innerHTML = `<tr><td colspan="6" style="padding: 20px; color:#999;">현재 출고 가능한 재고(LOT)가 없습니다.</td></tr>`;
						return;
					}

					let html = "";
					data.forEach(lot => {
						let expiryDate = lot.EXPIRY_DATE ? String(lot.EXPIRY_DATE).substring(0, 10) : '-';
						html += `
							<tr style="border-bottom: 1px solid #eee;">
								<td style="padding: 8px;">
									<input type="radio" name="lot_num" value="\${lot.LOT_NUM}" data-max-qty="\${lot.CURRENT_QTY}" onchange="selectLot(this)">
								</td>
								<td style="padding: 8px; font-weight: bold;">\${lot.LOT_NUM}</td>
								<td style="padding: 8px;">\${lot.ITEM_NUM}</td>
								<td style="padding: 8px;">\${lot.NAME}</td>
								<td style="padding: 8px; color: #2D6A4F; font-weight: bold;">\${lot.CURRENT_QTY}</td>
								<td style="padding: 8px;">\th{expiryDate}</td>
							</tr>
						`;
					});
					tbody.innerHTML = html;
				})
				.catch(err => console.error("LOT 목록 조회 실패:", err));
		});

		closeOutModal.addEventListener('click', () => {
			outModal.style.display = "none";
		});

		let selectedMaxQty = 0;
		function selectLot(radioElem) {
			selectedMaxQty = parseInt(radioElem.getAttribute('data-max-qty'));
			const qtyInput = document.querySelector("#outQty");
			const guide = document.querySelector("#maxQtyGuide");
			
			qtyInput.disabled = false;
			qtyInput.max = selectedMaxQty;
			guide.innerText = `(최대 출고 가능 수량: \${selectedMaxQty}개)`;
			guide.style.color = "#2D6A4F";
		}

		const outboundForm = document.querySelector("#outbound-form");
		outboundForm.addEventListener('submit', function(e) {
			const checkedLot = document.querySelector('input[name="lot_num"]:checked');
			const inputQty = parseInt(document.querySelector("#outQty").value);

			if (!checkedLot) {
				alert("출고할 LOT를 선택해주세요.");
				e.preventDefault();
				return;
			}

			if (!inputQty || inputQty < 1) {
				alert("출고 수량을 1개 이상 입력해주세요.");
				e.preventDefault();
				return;
			}

			if (inputQty > selectedMaxQty) {
				alert(`출고 수량은 현재 재고 수량(\${selectedMaxQty}개)을 초과할 수 없습니다.`);
				e.preventDefault();
				return;
			}
		});
	</script>
</body>
</html>