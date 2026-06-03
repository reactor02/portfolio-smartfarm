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
<title>Insert title here</title>

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

body {
	background: #f8fafc;
	font-family: 'Segoe UI', sans-serif;
	color: #333;
}

/* 컨테이너 */
.report-container {
	padding: 30px;
}

/* 상단 */
.report-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
}

.report-header h2 {
	font-size: 22px;
	font-weight: 600;
}

/* 검색 */
.search-box {
	display: flex;
	gap: 8px;
}

.search-box input {
	padding: 8px 10px;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	background: white;
}

.search-box button {
	padding: 8px 14px;
	border-radius: 8px;
	border: none;
	cursor: pointer;
	font-weight: 500;
}

.search-box button:first-of-type {
	background: #22c55e;
	color: white;
}

.search-box button:last-of-type {
	background: #e2e8f0;
}

/* 그리드 */
.grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 18px;
	margin-bottom: 18px;
}

.grid-3 {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr;
	gap: 18px;
	margin-bottom: 18px;
}

/* 카드 */
.card {
	background: white;
	border-radius: 14px;
	padding: 18px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
	transition: 0.2s;
}

.card:hover {
	transform: translateY(-2px);
}

/* 카드 제목 */
.card h3 {
	font-size: 15px;
	margin-bottom: 12px;
	font-weight: 600;
}

/* 테이블 */
table {
	width: 100%;
	border-collapse: collapse;
	font-size: 13px;
}

th {
	text-align: left;
	padding: 10px;
	background: #f1f5f9;
	border-radius: 6px;
}

td {
	padding: 10px;
	border-bottom: 1px solid #f1f5f9;
}

/* 상태 */
.ok {
	color: #22c55e;
	font-weight: 600;
}

.warn {
	color: #f59e0b;
	font-weight: 600;
}

.bad {
	color: #ef4444;
	font-weight: 600;
}

.title {
	font-size: 15px;
	font-weight: 600;
	margin-bottom: 12px;
	padding-left: 10px;
	border-left: 4px solid #22c55e;
}
/* 리포트 페이지용 css */
.card-header-wrapper {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 12px;
}

.more-link {
	font-size: 12px;
	color: #2D6A4F;
	text-decoration: none;
	font-weight: bold;
}

.more-link:hover {
	text-decoration: underline;
}

/* 기본 배지 스타일 */
.status-badge {
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: bold;
    text-transform: uppercase;
}

/* 상태별 색상 */
.status-badge.RUNNING {
    color: #49a47a; /* 녹색 */
}

.status-badge.ERROR {
  color: #e63946; /* 빨간색 */
}

.status-badge.MAINTENANCE {
   color: #ffb703; /* 노랑/주황색 */
}
.status-badge.WAITING {
	color: #ffb703;
}
.status-badge.PASS {
	 color: #49a47a;
}
.status-badge.사용중 {
 	color: #49a47a;
}
.status-badge.미사용 {
	color: #e63946;
}

</style>
</head>
<body>


	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="report-container">

					<!-- 상단 검색 -->
					<div class="hdr">
						<h1>리포트</h1>
					</div>

					<div class="report-header">
						<div class="search-box">
							<input type="date" id="startDate"> <span>~</span> <input
								type="date" id="endDate">
							<button onclick="filterData()">조회</button>
							<button onclick="downloadExcel()">엑셀 다운로드</button>
						</div>
					</div>

					<!-- 1줄 -->
					<div class="grid-3">
						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">시설 현황</h3>
								<a href="/equip" class="more-link">더보기 +</a>
							</div>
							<table>
								<tr>
									<th>시설명</th>
									<th>상태</th>
								</tr>
								<tr>
									<td>공장 A</td>
									<td class="ok">정상</td>
								</tr>
								<tr>
									<td>공장 B</td>
									<td class="warn">점검중</td>
								</tr>
								
							</table>
						</div>

						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">설비 가동</h3>
								<a href="/equip" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>설비코드</th>
										<th>설비명</th>
										<th>상태</th>
									</tr>
									<c:forEach var="item" items="${result}" begin="0" end="4">
										<tr>
											<td>${item.code}</td>
											<td>${item.name}</td>
											<td>
												<span class="status-badge ${item.equip_status}">
													${item.equip_status} 
												</span>
											</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>

						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">공정</h3>
								<a href="/plan" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>공정 품목</th>
										<th>사용 여부</th>
									</tr>
									<c:forEach var="item" items="${resultProc}" begin="0" end="4">
										<tr>
											<td>${item.name}</td>
											<td>
												<span class="status-badge ${item.process_status}">${item.process_status}</span>
											</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>

					<!-- 2줄 -->
					<div class="grid-2">
						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">품질 관리</h3>
								<a href="/qc" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>품목명</th>
										<th>검사구분</th>
										<th>통과여부</th>
										<th>검사일</th>
									</tr>
									<c:forEach var="item" items="${resultqc}" begin="0" end="4">
										<tr>
											<td>${item.name}</td>
											<td>${item.qc_type}</td>
											<td>
												<span class="status-badge ${item.qc_pass}">${item.qc_pass}</span>
											</td>
											<td>${item.io_date}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>

						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">입출고 관리</h3>
								<a href="/defect" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>자재명</th>
										<th>입/출고 여부</th>
										<th>날짜</th>
										<th>저장위치</th>
									</tr>
									<c:forEach var="item" items="${resultIO}" begin="0" end="4">
										<tr>
											<td>${item.name}</td>
											<td>${item.io_type}</td>
											<td>${item.io_date}</td>
											<td>${item.facility_name}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>

					<!-- 3줄 -->
					<div class="grid-3">
						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">Lot 관리</h3>
								<a href="/shipment" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>LOT 번호</th>
										<th>품목명</th>
										<th>생성일</th>
									</tr>
									<c:forEach var="item" items="${result}" begin="0" end="4">
										<tr>
											<td>${item.lot_code}</td>
											<td>${item.name}</td>
											<td>${item.lot_date}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>

						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">재고</h3>
								<a href="/stock" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>자재코드</th>
										<th>자재명</th>
										<th>현재고 수량</th>
									</tr>
									<c:forEach var="item" items="${result}" begin="0" end="4">
										<tr>
											<td>${item.code}</td>
											<td>${item.name}</td>
											<td>${item.stock_qty}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>

						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">BOM 관리</h3>
								<a href="/runtime" class="more-link">더보기 +</a>
							</div>
							<table>
								<tr>
									<th>BOM 코드</th>
									<th>품목명</th>
									<th>상태</th>
								</tr>
								<c:forEach var="item" items="${result}" begin="0" end="4">
									<tr>
										<td>${item.bom_code}</td>
										<td>${item.name}</td>
										<td>${item.bom_status}</td>
									</tr>
								</c:forEach>
							</table>
						</div>
					</div>

				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>


	<script>
	// 날짜 필터
	function filterData() {
	  const start = document.getElementById("startDate").value;
	  const end = document.getElementById("endDate").value;

	  const rows = document.querySelectorAll("#workTable tr[data-date]");

	  rows.forEach(row => {
	    const date = row.getAttribute("data-date");

	    if ((!start || date >= start) && (!end || date <= end)) {
	      row.style.display = "";
	    } else {
	      row.style.display = "none";
	    }
	  });
	}


	// 엑셀 다운로드 (CSV)
	function downloadExcel() {
	  let csv = [];
	  const rows = document.querySelectorAll("table tr");

	  rows.forEach(row => {
	    let cols = row.querySelectorAll("td, th");
	    let data = [];

	    cols.forEach(col => data.push(col.innerText));

	    csv.push(data.join(","));
	  });

	  const blob = new Blob([csv.join("\n")], { type: "text/csv" });
	  const url = window.URL.createObjectURL(blob);

	  const a = document.createElement("a");
	  a.href = url;
	  a.download = "report.csv";
	  a.click();
	}
	</script>


</body>
</html>