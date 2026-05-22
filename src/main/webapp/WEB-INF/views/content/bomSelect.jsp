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
<title>BOM 관리 시스템</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>
/* 기존 초기화 및 골격 유지 */
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

/* ========== 1. 상단 타이틀 & 등록 버튼 ========== */
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

/* ========== 2. 검색 영역 ========== */
.sch-wrap {
	background-color: #fff;
	border: 1px solid #bbb;
	border-radius: 10px;
	padding: 20px 25px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

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

/* 폼 요소 공통 규격 */
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

.sch-input-box {
	display: flex;
	align-items: center;
	border: 1px solid #aaa;
	border-radius: 4px;
	height: 38px;
	background: #fff;
	padding-left: 10px;
	width: 250px; /* 검색창 너비 조정 */
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

/* ========== 3. 데이터 테이블 ========== */
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
</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>BOM 관리</h1>
					<button type="button" class="btn-reg">+ 등록 버튼</button>
				</div>

				<form name="searchFrm" action="bomList.do" method="get">
					<div class="sch-wrap">
						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 등록일자</span>
								<input type="date" id="sDate" class="form-control" onchange="validateDate()">
								<span style="margin: 0 10px; font-weight: bold;">~</span>
								<input type="date" id="eDate" class="form-control" onchange="validateDate()">
							</div>
						</div>

						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 사용여부</span> 
								<select id="useYn" class="form-control">
									<option value="all">전체</option>
									<option value="Y" selected>사용 중</option>
									<option value="N">미사용</option>
								</select>

								<span class="label" style="margin-left: 20px;">▶ 품목 분류</span> 
								<select id="itemCat" class="form-control">
									<option value="all">전체</option>
									<option value="finished" selected>완제품</option>
									<option value="semi">반제품</option>
								</select>
							</div>

							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> 
									<input type="text" id="keyword" value="" placeholder="품목명 혹은 BOM코드 검색">
								</div>
								<button type="button" class="btn-sch">검색</button>
							</div>
						</div>
					</div>
				</form>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>BOM코드</th>
								<th>품목명</th>
								<th>품목코드</th>
								<th>기준 생산 수량</th>
								<th>상태</th>
								<th>등록일</th>
								<th>담당자</th>
							</tr>
						</thead>
						<tbody id="bom-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}" varStatus="vs">
										<tr>
											<td style="font-weight: bold; color: #555;">${vs.count}</td>
											<td>${item.BOM_CODE}</td>
											<td>${item.ITEM_NAME}</td>
											<td>${item.ITEM_CODE}</td>
											<td>${item.BASE_QTY}</td>
											<td>${item.STATUS}</td>
											<td>${item.REG_DATE}</td>
											<td>${item.MANAGER}</td>
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

	<script>
		/* 날짜 유효성 검사 로직 */
		function validateDate() {
			const start = document.getElementById('sDate').value;
			const end = document.getElementById('eDate').value;
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('eDate').value = "";
			}
		}
		
		/* 페이징 렌더링 함수 */
		function renderPagination(pInfo) {
			let pagingHtml = "";
			
			// 이전
			if (!pInfo.isFirstPage) {
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
		
		/* 검색 버튼 이벤트 */
		const btn_sch = document.querySelector(".btn-sch");
		btn_sch.addEventListener('click', ()=>{
			movePage(1);
		});
		
		/* 페이징 및 Ajax 검색 통신 함수 */
		function movePage(pageNum) {
			let sDate = document.querySelector("#sDate").value;
			let eDate = document.querySelector("#eDate").value;
			let useYn = document.querySelector("#useYn").value;
			let itemCat = document.querySelector("#itemCat").value;
			let keyword = document.querySelector("#keyword").value;
			
			const params = new URLSearchParams();
			params.append("page", pageNum);
			params.append("sDate", sDate);
			params.append("eDate", eDate);
			params.append("useYn", useYn);
			params.append("itemCat", itemCat);
			params.append("keyword", keyword);
			
			// BOM 검색 API 호출 (URL을 프로젝트 환경에 맞게 수정해주세요)
			fetch(`/searchBom?\${params.toString()}`)
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
						// 페이징 번호 계산 및 테이블 행 추가
						html += `<tr>
							<td style='font-weight: bold; color: #555;'>\${i + 1 + (data.pageInfo.pageNum - 1) * data.pageInfo.pageSize}</td>
							<td>\${item.BOM_CODE}</td>
							<td>\${item.ITEM_NAME}</td>
							<td>\${item.ITEM_CODE}</td>
							<td>\${item.BASE_QTY}</td>
							<td>\${item.VERSION}</td>
							<td>\${item.STATUS}</td>
							<td>\${item.REG_DATE}</td>
							<td>\${item.MANAGER}</td>
						</tr>`;
					}
					tbody.innerHTML = html;
					
					// 페이징 갱신
					renderPagination(data.pageInfo);

					// 브라우저 URL 갱신 (뒤로가기 지원용)
					const newUrl = window.location.pathname + `?\${params.toString()}`;
					window.history.pushState({path: newUrl}, '', newUrl);
				}
			})
			.catch(error => {
				console.error("데이터 통신 중 오류가 발생했습니다.", error);
			});
		}
	</script>
</body>
</html>