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
							<div class="card-head">
								<h3>생산 계획</h3>
							</div>
							<div class="card-body">
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
						</div>

						<div class="panel">
							<div class="card-head">
								<h3>작업 지시</h3>
							</div>
							<div class="card-body">
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

					</div>

					<!-- 재고 + 불량 -->
					<div class="grid-2">

						<div class="panel">
							<h3>재고 현황</h3>
							<canvas id="stockChart"></canvas>
						</div>

						<div class="panel">
							<h3>불량 유형</h3>
							<canvas id="defectChart"></canvas>
						</div>

					</div>

					<!-- 금액 + 공지 -->
					<div class="grid-2">

						<div class="panel money">
							<h3>금액 현황</h3>
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
							<h3>공지사항</h3>
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