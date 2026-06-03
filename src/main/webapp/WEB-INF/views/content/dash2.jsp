<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%-- <% --%>
// request.setCharacterEncoding("utf-8");
// String vender_type = request.getParameter("vender_type");
<%-- %> --%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> --%>
<%-- <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> --%>
<%-- <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> --%>
<%-- <%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%> --%>
<!-- <!DOCTYPE html> -->
<!-- <html> -->
<!-- <head> -->
<!-- <meta charset="UTF-8"> -->
<!-- <title>대시보드</title> -->
<!-- <style> -->
/* /* 기본 초기화 */ */
/* * { */
/* 	box-sizing: border-box; */
/* 	margin: 0; */
/* 	padding: 0; */
/* 	font-family: 'Malgun Gothic', sans-serif; */
/* } */

/* .main-cont { */
/* 	flex: 1; */
/* 	padding: 2rem 2.5rem; */
/* 	min-width: 0; */
/* } */

/* .mat-all { */
/* 	display: flex; */
/* 	flex-direction: column; */
/* 	min-height: 100vh; */
/* 	background-color: #f4f7f6; */
/* } */

/* body { */
/* 	background-color: #f4f6f9; */
/* 	padding: 20px; */
/* } */

/* .container { */
/* 	width: 100%; */
/* 	max-width: 1600px; */
/* 	margin: 0 auto; */
/* } */

/* .header { */
/* 	display: flex; */
/* 	justify-content: space-between; */
/* 	align-items: center; */
/* 	margin-bottom: 20px; */
/* } */

/* .header h1 { */
/* 	font-size: 28px; */
/* 	color: #333; */
/* } */

/* .date-area { */
/* 	display: flex; */
/* 	align-items: center; */
/* } */

/* .date-input { */
/* 	padding: 8px 12px; */
/* 	border: 1px solid #ccc; */
/* 	border-radius: 4px; */
/* 	margin-right: 10px; */
/* } */

/* .btn-search { */
/* 	padding: 8px 20px; */
/* 	background-color: #2D6A4F; */
/* 	color: #fff; */
/* 	border: none; */
/* 	border-radius: 4px; */
/* 	cursor: pointer; */
/* } */

/* .kpi-wrapper { */
/* 	display: grid; */
/* 	grid-template-columns: repeat(4, 1fr); */
/* 	gap: 20px; */
/* 	margin-bottom: 20px; */
/* } */

/* .kpi-card { */
/* 	background-color: #fff; */
/* 	padding: 20px; */
/* 	border-radius: 8px; */
/* 	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05); */
/* } */

/* .kpi-title { */
/* 	font-size: 14px; */
/* 	color: #777; */
/* 	margin-bottom: 5px; */
/* } */

/* .kpi-value { */
/* 	font-size: 24px; */
/* 	font-weight: bold; */
/* 	color: #333; */
/* } */

/* .main-grid { */
/* 	display: grid; */
/* 	grid-template-columns: 1fr 1fr; */
/* 	gap: 20px; */
/* } */

/* .panel { */
/* 	background-color: #fff; */
/* 	padding: 20px; */
/* 	border-radius: 8px; */
/* 	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05); */
/* 	margin-bottom: 20px; */
/* } */

/* .panel h2 { */
/* 	font-size: 18px; */
/* 	color: #333; */
/* 	margin-bottom: 15px; */
/* } */

/* .data-table { */
/* 	width: 100%; */
/* 	border-collapse: collapse; */
/* } */

/* .data-table th, .data-table td { */
/* 	text-align: left; */
/* 	padding: 12px 10px; */
/* 	border-bottom: 1px solid #eee; */
/* } */

/* .data-table th { */
/* 	color: #999; */
/* 	font-size: 13px; */
/* } */

/* .data-table td { */
/* 	font-size: 14px; */
/* 	color: #333; */
/* } */

/* .progress-container { */
/* 	width: 80px; */
/* 	height: 8px; */
/* 	background-color: #e9ecef; */
/* 	border-radius: 4px; */
/* 	overflow: hidden; */
/* 	display: inline-block; */
/* } */

/* .progress-bar { */
/* 	height: 100%; */
/* 	background-color: #2D6A4F; */
/* } */

/* .badge { */
/* 	padding: 4px 8px; */
/* 	border-radius: 4px; */
/* 	font-size: 12px; */
/* 	font-weight: bold; */
/* } */

/* .badge-green { */
/* 	background-color: #e6fffa; */
/* 	color: #2D6A4F; */
/* } */

/* .badge-gray { */
/* 	background-color: #f4f6f9; */
/* 	color: #777; */
/* } */

/* .badge-blue { */
/* 	background-color: #e3f2fd; */
/* 	color: #1976d2; */
/* } */

/* .notice-list { */
/* 	list-style: none; */
/* } */

/* .notice-item { */
/* 	padding: 12px 0; */
/* 	border-bottom: 1px solid #eee; */
/* 	display: flex; */
/* 	justify-content: space-between; */
/* } */

/* .card-header-wrapper { */
/* 	display: flex; */
/* 	justify-content: space-between; */
/* 	align-items: center; */
/* 	margin-bottom: 12px; */
/* } */

/* .more-link { */
/* 	font-size: 12px; */
/* 	color: #2D6A4f; */
/* 	text-decoration: none; */
/* 	font-weight: bold; */
/* } */

/* .more-link:hover { */
/* 	text-decoration: underline; */
/* } */

/* .btn-per { */
/* 	padding: 6px 12px; */
/* 	margin-right: 8px; */
/* 	border-radius: 6px; */
/* 	background: #eee; */
/* 	text-decoration: none; */
/* 	color: #333; */
/* } */

/* .btn-per.active { */
/* 	background : #2D6A4F;  */
/* 	color : #fff;  */
/* 	font-weight: bold; */
/* } */

/* .btn-per:hover { */
/* 	background-color: #1b4332;  */
/* 	transform : translateY(-1px); */
/* 	box-shadow : 0 2px 6px rgba(0,0,0,0.1); */
/* }  */

/* .date-sep { */
/* 	margin: 0 8px 0 0;  */
/* 	font-weight: bold; */
/* 	color: #555; */
/* } */
<!-- </style> -->
<!-- </head> -->
<!-- <body> -->

<!-- 	<div class="mat-all"> -->

<!-- 		<main class="main-cont"> -->
<!-- 			<form action="/dashboard" method="get"> -->
<!-- 			<div class="header"> -->
<!-- 				<h1>대시보드</h1> -->
<!-- 				<div class="date-area"> -->
<%-- 					<a href="/dashboard?period=day" class="btn-per ${period == 'day' ? 'active' : ''}">오늘</a> --%>
<%-- 					<a href="/dashboard?period=week" class="btn-per ${period == 'week' ? 'active' : ''}">이번주</a> --%>
<%-- 					<a href="/dashboard?period=month" class="btn-per ${period == 'month' ? 'active' : ''}">이번달</a> --%>
<%-- 					<input type="date" class="date-input" name="startDate" value="${startDate}" > --%>
<!-- 					<span class="date-sep">~</span> -->
<%-- 					<input type="date" class="date-input" name="endDate" value="${endDate}" > --%>
<!-- 					<button type="submit" class="btn-search">조회</button> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 			</form> -->

<!-- 			<div class="kpi-wrapper"> -->
<%-- 				<c:forEach var="k" items="${resultKPIPP}"> --%>
<!-- 				<div class="kpi-card"> -->
<!-- 					<div class="kpi-title">총 생산량</div> -->
<%-- 					<div class="kpi-value">${k.plan_qty} 건</div> --%>
<!-- 				</div> -->
<%-- 				</c:forEach> --%>
<%-- 				<c:forEach var="k" items="${resultKPIShip}"> --%>
<!-- 				<div class="kpi-card"> -->
<!-- 					<div class="kpi-title">출하량</div> -->
<%-- 					<c:choose> --%>
<%-- 					<c:when test="${not empty k.ship_qty}" >  --%>
<%-- 					<div class="kpi-value">${k.ship_qty} 건</div> --%>
<%-- 					</c:when> --%>
<%-- 					<c:otherwise>  --%>
<!-- 						<div class="kpi-value">0 건</div> -->
<%-- 					</c:otherwise> --%>
<%-- 					</c:choose> --%>
<!-- 				</div> -->
<%-- 				</c:forEach> --%>
<%-- 				<c:forEach var="k" items="${resultKPIDefect}"> --%>
<!-- 				<div class="kpi-card"> -->
<!-- 					<div class="kpi-title">불량수</div> -->
<%-- 					<c:choose> --%>
<%-- 					<c:when test="${not empty k.defect_qty}"> --%>
<%-- 					<div class="kpi-value">${k.defect_qty} EA</div> --%>
<%-- 					</c:when> --%>
<%-- 					<c:otherwise> --%>
<!-- 						<div class="kpi-value">0 EA</div> -->
<%-- 					</c:otherwise> --%>
<%-- 					</c:choose> --%>
<!-- 				</div> -->
<%-- 				</c:forEach> --%>
<!-- 				<div class="kpi-card"> -->
<!-- 					<div class="kpi-title">총가동 시설</div> -->
<%-- 					<c:choose> --%>
<%-- 					<c:when test="${not empty resultKPIFacility}"> --%>
<%-- 					<div class="kpi-value">${resultKPIFacility} 구역</div> --%>
<%-- 					</c:when> --%>
<%-- 					<c:otherwise> --%>
<!-- 						<div class="kpi-value">0 구역</div> -->
<%-- 					</c:otherwise> --%>
<%-- 					</c:choose> --%>
<!-- 				</div> -->
<!-- 			</div> -->

<!-- 			<div class="main-grid"> -->

<!-- 				<div class="panel"> -->
<!-- 					<h2>생산 계획</h2> -->
<!-- 					<table class="data-table"> -->
<!-- 						<thead> -->
<!-- 							<tr> -->
<!-- 								<th>생산계획 아이디</th> -->
<!-- 								<th>제품명</th> -->
<!-- 								<th>계획 수량</th> -->
<!-- 								<th>상태</th> -->
<!-- 							</tr> -->
<!-- 						</thead> -->
<!-- 						<tbody> -->
<%-- 							<c:forEach var="i" items="${resultDash.resultProd}"> --%>
<!-- 							<tr> -->
<%-- 								<td>${i.plan_id}</td> --%>
<%-- 								<td>${i.name}</td> --%>
<%-- 								<td>${i.plan_qty}${i.unit}</td> --%>
<%-- 								<td><span class="badge badge-green">${i.plan_status}</span></td> --%>
<!-- 							</tr> -->
<%-- 							</c:forEach> --%>
<!-- 						</tbody> -->
<!-- 					</table> -->
<!-- 				</div> -->

<!-- 				<div class="panel"> -->
<!-- 					<h2>작업 지시 현황</h2> -->
<!-- 					<table class="data-table"> -->
<!-- 						<thead> -->
<!-- 							<tr> -->
<!-- 								<th>작업 지시번호</th> -->
<!-- 								<th>제품명</th> -->
<!-- 								<th>지시 수량</th> -->
<!-- 								<th>진행률</th> -->
<!-- 								<th>상태</th> -->
<!-- 							</tr> -->
<!-- 						</thead> -->
<!-- 						<tbody> -->
<%-- 							<c:forEach var="i" items="${resultDash.resultOrder}"> --%>
<!-- 								<tr> -->
<%-- 									<td>${i.order_id}</td> --%>
<%-- 									<td>${i.name}</td> --%>
<%-- 									<td>${i.order_qty}</td> --%>
<!-- 									<td> -->
<!-- 										<div class="progress-container"> -->
<%-- 											<div class="progress-bar" style="width: ${(i.current_qty / i.order_qty) * 100}%;"></div> --%>
<%-- 										</div> <span style="font-size: 13px;">${(i.current_qty / i.order_qty) * 100}%</span> --%>
<!-- 									</td> -->
<%-- 									<td><span class="badge badge-green">${i.order_status}</span></td> --%>
<!-- 								</tr> -->
<%-- 							</c:forEach> --%>
<!-- 						</tbody> -->
<!-- 					</table> -->
<!-- 				</div> -->

<!-- 				<div class="panel"> -->
<!-- 					<h2>생산/출하 그래프</h2> -->
<%-- 					<c:choose> --%>
<%-- 						<c:when test="${param.isSlide == 'true'}"> --%>
<%-- 							<canvas id="myChartSlide"></canvas> --%>
<%-- 						</c:when> --%>
<%-- 						<c:otherwise> --%>
<%-- 							<canvas id="myChart"></canvas> --%>
<%-- 						</c:otherwise> --%>
<%-- 					</c:choose> --%>
<!-- 				</div> -->

<!-- 				<div class="panel"> -->
<!-- 					<div class="card-header-wrapper"> -->
<!-- 						<h3 class="title">공지사항</h3> -->
<!-- 						<a href="/board" class="more-link">더보기 +</a> -->
<!-- 					</div> -->
<!-- 					<ul class="notice-list"> -->
<%-- 						<c:forEach var="item" items="${resultB}"> --%>
<!-- 							<li class="notice-item"><span><a -->
<%-- 									href="${pageContext.request.contextPath}/board/one?board_num=${item.board_num}" --%>
<%-- 									class="link-txt">${item.title}</a></span> <span --%>
<%-- 								style="font-size: 13px; color: #777;"> ${item.created_at}</span> --%>
<!-- 							</li> -->
<%-- 						</c:forEach> --%>
<!-- 					</ul> -->
<!-- 				</div> -->

<!-- 			</div> -->
<!-- 		</main> -->

<!-- 	</div> -->
<!-- 	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script> -->

<!-- 	<script>  -->
// 	{
// 		// 1. 서버 데이터가 비어있거나 null일 때를 위한 방어 코드
// 		const rawData = '${not empty chartData ? chartData : "[]"}';
// 		const chartData = JSON.parse(rawData.trim() === '' ? '[]' : rawData);
		
// 		const labels = chartData.map(d => d.dt);
// 		const planData = chartData.map(d => d.plan_qty);
// 		const shipData = chartData.map(d => d.ship_qty);
		
// 		// Chart.js에 들어갈 기본 설정 템플릿 정보
// 		const getChartConfig = () => ({
// 			type: 'line',
// 			data: {
// 				labels: labels,
// 				datasets: [
// 					{
// 						label : '생산계획',
// 						data: planData,
// 						borderWidth : 2,
// 						fill: false,
// 						tension : 0.3 ,
// 						borderColor : 'gray',
// 						borderDash: [5,5]
// 					},
// 					{
// 						label : '출하량',
// 						data: shipData,
// 						borderWidth : 2,
// 						fill : false,
// 						tension : 0.3,
// 						borderColor : 'blue'
// 					}
// 				]
// 			},
// 			options: {
// 				responsive: true,
// 				maintainAspectRatio: false,
// 				plugins: {
// 					legend : { position : 'top' }
// 				}
// 			}
// 		});

// 		// 2. 특정 캔버스 ID에 안전하게 차트를 그리는 독립 함수
// 		function renderChartById(canvasId) {
// 			const canvas = document.getElementById(canvasId);
// 			if (!canvas) return; // 해당 ID를 가진 캔버스가 현재 페이지에 없으면 조용히 패스 (에러 방지)
// 			if (chartData.length === 0) return; // 그릴 데이터가 없으면 패스

// 			// 중복 생성으로 인한 충돌 방지 (기존 차트 객체가 있으면 파괴)
// 			const existingChart = Chart.getChart(canvas);
// 			if (existingChart) {
// 				existingChart.destroy();
// 			}

// 			// 새로운 차트 생성
// 			new Chart(canvas, getChartConfig());
// 		}

// 		// 3. 페이지가 로드되었을 때 및 토글될 때의 실행 제어
// 		document.addEventListener("DOMContentLoaded", () => {
			
// 			// [상황 A] 현재 페이지가 '대시보드 메인 화면'이라면 메인 차트를 즉시 렌더링
// 			renderChartById('myChart');

// 			// [상황 B] 헤더 슬라이더 박스 내부에 있는 차트 제어
// 			// 기존에 정의된 toggleDashboard 함수가 있다면 기능을 확장하여 가로챕니다.
// 			const originalToggle = window.toggleDashboard;
// 			if (originalToggle) {
// 				window.toggleDashboard = function() {
// 					originalToggle(); // 원래 있던 열고 닫히는 애니메이션 실행
					
// 					const panel = document.getElementById('dashboardContainer');
// 					// 슬라이더 패널이 열려 있는 상태('open' 클래스 보유)인지 확인
// 					if (panel && panel.classList.contains('open')) {
// 						// display:none 상태에서는 크기가 0이라 차트가 안 그려지므로,
// 						// 슬라이더가 다 열려서 픽셀 크기가 확보되는 시점(400ms 뒤)에 안전하게 렌더링
// 						setTimeout(() => {
// 							renderChartById('myChartSlide');
// 						}, 400);
// 					}
// 				};
// 			}
// 		});
<!-- 	}	</script> -->

<!-- </body> -->
<!-- </html> -->