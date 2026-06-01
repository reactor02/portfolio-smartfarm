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
	font-family: 'Malgun Gothic', sans-serif; /* 한국어 가독성을 위해 맑은고딕 설정 */
}

.main-cont {
	flex: 1;
	padding: 2rem 2.5rem;
	min-width: 0;
}

.mat-all {
	display: flex; 
	flex-direction : column;
	min-height : 100vh;
	background-color : #f4f7f6;
}

body {
	background-color: #f4f6f9; /* 배경색 */
	padding: 20px;
}

/* 대시보드 메인 컨테이너 */
.container {
	width: 100%;
	max-width: 1600px;
	margin: 0 auto;
}

/* 상단 헤더 영역 */
.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.header h1 {
	font-size: 28px;
	color: #333;
}

.date-area {
	display: flex;
	align-items: center;
}

.date-input {
	padding: 8px 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	margin-right: 10px;
}

.btn-search {
	padding: 8px 20px;
	background-color: #2D6A4F;
	color: #fff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

/* 상단 KPI 카드 영역 */
.kpi-wrapper {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-bottom: 20px;
}

.kpi-card {
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.kpi-title {
	font-size: 14px;
	color: #777;
	margin-bottom: 5px;
}

.kpi-value {
	font-size: 24px;
	font-weight: bold;
	color: #333;
}

/* 중간 영역 그리드 (2단 구성) */
.main-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

/* 패널(테이블 및 차트 공통 컨테이너) */
.panel {
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
	margin-bottom: 20px;
}

.panel h2 {
	font-size: 18px;
	color: #333;
	margin-bottom: 15px;
}

/* 데이터 테이블 공통 스타일 */
.data-table {
	width: 100%;
	border-collapse: collapse;
}

.data-table th, .data-table td {
	text-align: left;
	padding: 12px 10px;
	border-bottom: 1px solid #eee;
}

.data-table th {
	color: #999;
	font-size: 13px;
}

.data-table td {
	font-size: 14px;
	color: #333;
}

/* 진행률 표시바 (Progress Bar) */
.progress-container {
	width: 80px;
	height: 8px;
	background-color: #e9ecef;
	border-radius: 4px;
	overflow: hidden;
	display: inline-block;
}

.progress-bar {
	height: 100%;
	background-color: #2D6A4F;
}

/* 상태 배지 (Badge) */
.badge {
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: bold;
}

.badge-green {
	background-color: #e6fffa;
	color: #2D6A4F;
}

.badge-gray {
	background-color: #f4f6f9;
	color: #777;
}

.badge-blue {
	background-color: #e3f2fd;
	color: #1976d2;
}

/* 차트/공지사항 대체 스타일 */
.empty-chart {
	background-color: #f9f9f9;
	height: 300px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 8px;
	border: 1px dashed #ddd;
	color: #aaa;
}

.notice-list {
	list-style: none;
}

.notice-item {
	padding: 12px 0;
	border-bottom: 1px solid #eee;
	display: flex;
	justify-content: space-between;
}

/* 타일즈 속성 임시 표시 */
.tiles-tag {
	font-family: monospace;
	font-size: 11px;
	color: #aaa;
	margin-bottom: 10px;
}
</style>
</head>
<body>
	
	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />
		
		<main class="main-cont">
		
		<div class="header">
			<h1>대시보드</h1>
			<div class="date-area">
				<input type="date" class="date-input" value="2025-06-04">
				<button class="btn-search">조회</button>
			</div>
		</div>

		<div class="kpi-wrapper">
			<div class="kpi-card">
				<div class="kpi-title">총 생산량</div>
				<div class="kpi-value">12,540 EA</div>
			</div>
			<div class="kpi-card">
				<div class="kpi-title">평균 불량률</div>
				<div class="kpi-value">2.13 %</div>
			</div>
			<div class="kpi-card">
				<div class="kpi-title">출하량</div>
				<div class="kpi-value">11,980 EA</div>
			</div>
			<div class="kpi-card">
				<div class="kpi-title">재고 부족</div>
				<div class="kpi-value">8 건</div>
			</div>
		</div>

		<div class="main-grid">
			
			<div class="panel">
				<h2>생산 계획</h2>
				<table class="data-table">
					<thead>
						<tr>
							<th>생산 계획명</th>
							<th>제품명</th>
							<th>계획 수량</th>
							<th>진행률</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>6월 1주차 생산계획</td>
							<td>제품 A</td>
							<td>5,000 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 75%;"></div>
								</div>
								<span style="font-size: 13px;">75%</span>
							</td>
							<td><span class="badge badge-green">진행중</span></td>
						</tr>
						<tr>
							<td>6월 2주차 생산계획</td>
							<td>제품 B</td>
							<td>6,000 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 30%;"></div>
								</div>
								<span style="font-size: 13px;">30%</span>
							</td>
							<td><span class="badge badge-green">진행중</span></td>
						</tr>
						<tr>
							<td>6월 3주차 생산계획</td>
							<td>제품 C</td>
							<td>4,000 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 0%;"></div>
								</div>
								<span style="font-size: 13px;">0%</span>
							</td>
							<td><span class="badge badge-gray">대기</span></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="panel">
				<h2>작업 지시 현황</h2>
				<table class="data-table">
					<thead>
						<tr>
							<th>작업 지시번호</th>
							<th>제품명</th>
							<th>지시 수량</th>
							<th>진행률</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>WO-250604-001</td>
							<td>제품 A</td>
							<td>1,000 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 60%;"></div>
								</div>
								<span style="font-size: 13px;">60%</span>
							</td>
							<td><span class="badge badge-green">진행중</span></td>
						</tr>
						<tr>
							<td>WO-250604-002</td>
							<td>제품 B</td>
							<td>1,500 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 40%;"></div>
								</div>
								<span style="font-size: 13px;">40%</span>
							</td>
							<td><span class="badge badge-green">진행중</span></td>
						</tr>
						<tr>
							<td>WO-250603-003</td>
							<td>제품 C</td>
							<td>800 EA</td>
							<td>
								<div class="progress-container">
									<div class="progress-bar" style="width: 100%;"></div>
								</div>
								<span style="font-size: 13px;">100%</span>
							</td>
							<td><span class="badge badge-blue">완료</span></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="panel">
				<h2>재고 현황</h2>
				<div class="empty-chart">(바 차트 영역)</div>
			</div>

			<div class="panel">
				<div class="card-header-wrapper">
								<h3 class="title">공지사항</h3>
								<a href="/plan" class="more-link">더보기 +</a>
							</div>
				<ul class="notice-list">
					<c:forEach var="item" items="${resultB}">
					<li class="notice-item">
						<span><a href="${pageContext.request.contextPath}/board/one"
							class="link-txt">${item.title}</a></span>
						<span style="font-size: 13px; color: #777;">
						${item.created_at}</span>
					</li>
					</c:forEach>
					
				</ul>
			</div>

		</div>
		</main>
		
		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

</body>
</html>