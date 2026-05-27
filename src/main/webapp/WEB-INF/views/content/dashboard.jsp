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
<title>대시보드</title>

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

.dashboard {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

/* KPI */
.kpi-wrap {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 15px;
}

.kpi-card {
	background: linear-gradient(135deg, #2D6A4F, #40916C);
	color: #fff;
	padding: 20px;
	border-radius: 12px;
}

.kpi-card b {
	display: block;
	font-size: 1.6rem;
	margin-top: 10px;
}

/* grid */
.grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

/* panel */
.panel {
	background: #fff;
	padding: 20px;
	border-radius: 10px;
	min-height: 250px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

/* table */
.tbl {
	width: 100%;
	border-collapse: collapse;
}

.tbl th, .tbl td {
	padding: 8px;
	border-bottom: 1px solid #ddd;
	text-align: left;
}

/* money */
.money-wrap {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
}

.money-wrap div {
	background: #f8f9fa;
	padding: 15px;
	border-radius: 8px;
}

/* notice */
.notice {
	list-style: none;
	padding: 0;
}

.notice li {
	padding: 10px;
	border-bottom: 1px solid #eee;
}
</style>
</head>
<body>


	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="dashboard">

					<!-- KPI -->
					<div class="kpi-wrap">
						<div class="kpi-card">
							총 생산량 <b>12,540</b>
						</div>
						<div class="kpi-card">
							평균 불량률 <b>2.13%</b>
						</div>
						<div class="kpi-card">
							출하량 <b>11,980</b>
						</div>
						<div class="kpi-card">
							재고 부족 <b>8건</b>
						</div>
					</div>

					<!-- 생산계획 + 작업지시 -->
					<div class="grid-2">

						<div class="panel">
							<h3>📅 생산 계획</h3>
							<table class="tbl">
								<tr>
									<th>계획명</th>
									<th>제품</th>
									<th>수량</th>
									<th>진행률</th>
								</tr>
								<tr>
									<td>6월 1주차</td>
									<td>A</td>
									<td>5000</td>
									<td>75%</td>
								</tr>
								<tr>
									<td>6월 2주차</td>
									<td>B</td>
									<td>6000</td>
									<td>30%</td>
								</tr>
							</table>
						</div>

						<div class="panel">
							<h3>📌 작업 지시</h3>
							<table class="tbl">
								<tr>
									<th>지시번호</th>
									<th>제품</th>
									<th>수량</th>
									<th>상태</th>
								</tr>
								<tr>
									<td>WO-001</td>
									<td>A</td>
									<td>1000</td>
									<td>진행중</td>
								</tr>
								<tr>
									<td>WO-002</td>
									<td>B</td>
									<td>1500</td>
									<td>완료</td>
								</tr>
							</table>
						</div>

					</div>

					<!-- 재고 + 불량 -->
					<div class="grid-2">

						<div class="panel">
							<h3>📦 재고 현황</h3>
							<canvas id="stockChart"></canvas>
						</div>

						<div class="panel">
							<h3>⚠ 불량 유형</h3>
							<canvas id="defectChart"></canvas>
						</div>

					</div>

					<!-- 금액 + 공지 -->
					<div class="grid-2">

						<div class="panel money">
							<h3>💰 금액 현황</h3>
							<div class="money-wrap">
								<div>
									매출 <b>₩1,245,000,000</b>
								</div>
								<div>
									원가 <b>₩872,300,000</b>
								</div>
								<div>
									이익 <b>₩372,700,000</b>
								</div>
								<div>
									이익률 <b>29.9%</b>
								</div>
							</div>
						</div>

						<div class="panel">
							<h3>📢 공지사항</h3>
							<ul class="notice">
								<li>시스템 점검 안내</li>
								<li>신규 자재 등록 안내</li>
								<li>MES 교육 일정</li>
							</ul>
						</div>

					</div>

				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>


	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
		new Chart(document.getElementById('stockChart'), {
			type : 'bar',
			data : {
				labels : [ '원자재A', '원자재B', '부자재C', '포장재' ],
				datasets : [ {
					label : '재고',
					data : [ 8200, 6500, 4200, 2800 ]
				} ]
			}
		});

		new Chart(document.getElementById('defectChart'), {
			type : 'doughnut',
			data : {
				labels : [ '스크래치', '조립불량', '파손', '오염' ],
				datasets : [ {
					data : [ 38, 26, 18, 12 ],
					backgroundColor : [ '#2D6A4F', '#40916C', '#74C69D',
							'#B7E4C7' ]
				} ]
			}
		});
	</script>
</body>
</html>