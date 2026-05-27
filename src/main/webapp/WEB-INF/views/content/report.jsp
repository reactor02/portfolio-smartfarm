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
	box-sizing : border-box;
	margin: 0; 
	padding : 0; 
	font-family: 'Malgun Gothic', sans-serif;
}

.mat-all {
	display: flex;
	flex-direction : column; 
	min-height: 100vh; 
	background-color : #f4f7f6;
}

.mat-body {
	display :flex; 
	flex : 1; 
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
  box-shadow: 0 4px 12px rgba(0,0,0,0.04);
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
						<h1> 리포트</h1>
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
							<h3 class="title">시설 현황</h3>
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
							<h3 class="title">설비 가동</h3>
							<table>
								<tr>
									<th>설비</th>
									<th>가동률</th>
								</tr>
								<tr>
									<td>라인1</td>
									<td>85%</td>
								</tr>
								<tr>
									<td>라인2</td>
									<td>72%</td>
								</tr>
							</table>
						</div>

						<div class="card">
							<h3 class="title">생산 계획</h3>
							<table>
								<tr>
									<th>제품</th>
									<th>수량</th>
								</tr>
								<tr>
									<td>A</td>
									<td>5000</td>
								</tr>
								<tr>
									<td>B</td>
									<td>3000</td>
								</tr>
							</table>
						</div>
					</div>

					<!-- 2줄 -->
					<div class="grid-2">
						<div class="card">
							<h3 class="title">작업 진행 상황</h3>
							<table id="workTable">
								<tr>
									<th>날짜</th>
									<th>작업</th>
									<th>진행률</th>
								</tr>
								<tr data-date="2026-06-01">
									<td>2026-06-01</td>
									<td>조립</td>
									<td>60%</td>
								</tr>
								<tr data-date="2026-06-03">
									<td>2026-06-03</td>
									<td>검사</td>
									<td>90%</td>
								</tr>
							</table>
						</div>

						<div class="card">
							<h3 class="title">불량 현황</h3>
							<table>
								<tr>
									<th>유형</th>
									<th>수량</th>
								</tr>
								<tr>
									<td>스크래치</td>
									<td>12</td>
								</tr>
								<tr>
									<td>파손</td>
									<td>5</td>
								</tr>
							</table>
						</div>
					</div>

					<!-- 3줄 -->
					<div class="grid-3">
						<div class="card">
							<h3 class="title">출하</h3>
							<table>
								<tr>
									<th>제품</th>
									<th>수량</th>
								</tr>
								<tr>
									<td>A</td>
									<td>1200</td>
								</tr>
							</table>
						</div>

						<div class="card">
							<h3 class="title">재고</h3>
							<table>
								<tr>
									<th>자재</th>
									<th>수량</th>
								</tr>
								<tr>
									<td>원자재A</td>
									<td>8200</td>
								</tr>
							</table>
						</div>

						<div class="card">
							<h3 class="title">설비 다운타임</h3>
							<table>
								<tr>
									<th>설비</th>
									<th>시간</th>
								</tr>
								<tr>
									<td>라인3</td>
									<td>2h</td>
								</tr>
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