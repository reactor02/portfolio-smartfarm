<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>리포트 페이지</title>

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

/* ========== 상단 타이틀 & 등록 버튼 ========== */
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

/* 그리드 (2열로 고정) */
.grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
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

.title {
	font-size: 15px;
	font-weight: 600;
	margin-bottom: 12px;
	padding-left: 10px;
	border-left: 4px solid #22c55e;
}

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
.status-badge.RUNNING { color: #49a47a; }
.status-badge.ERROR { color: #e63946; }
.status-badge.MAINTENANCE { color: #ffb703; }
.status-badge.WAITING { color: #ffb703; }
.status-badge.PASS { color: #49a47a; }
.status-badge.사용중 { color: #49a47a; }
.status-badge.미사용 { color: #e63946; }

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="report-container">

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

					<div class="grid-2">
						<div class="card">
							<div class="card-header-wrapper">
								<h3 class="title">시설 현황</h3>
								<a href="facilityLog" class="more-link">더보기 +</a>
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
										<th>설비명(코드)</th>
										<th>상태</th>
										<th>누적시간</th>
									</tr>
									<c:forEach var="item" items="${resultEquip}" begin="0" end="4">
										<tr>
											<td>${item.code} ${item.name}</td>
											<td>
												<span class="status-badge ${item.equip_status}">
													${item.equip_status} 
												</span>
											</td>
											<td>${item.total_runtime}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>

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
								<h3 class="title">불량률 관리</h3>
								<a href="/defective" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>품목명</th>
										<th>불량품 개수</th>
										<th>날짜</th>
									</tr>
									<c:forEach var="item" items="${resultDefective}" begin="0" end="4">
										<tr>
											<td>${item.name}</td>
											<td>${item.defect_qty}</td>
											<td>${item.io_date}</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>

					<div class="grid-2">
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
								<h3 class="title">입출고 관리</h3>
								<a href="io" class="more-link">더보기 +</a>
							</div>
							<div>
								<table>
									<tr>
										<th>자재명</th>
										<th>입/출고</th>
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
					</div> </div> </main>
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