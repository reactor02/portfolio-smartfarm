<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>생산계획 관리</title>

</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<!-- 타이틀 & 등록 버튼 -->
				<div class="hdr">
					<h1>생산계획 관리</h1>
					<button type="button" class="btn-reg">+ 등록하기</button>
				</div>

				<!-- 검색 폼 -->
				<form name="searchFrm" action="/prod/list" method="get">
					<div class="sch-wrap">
						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 기간</span> <input type="date"
									name="startDate" id="startDate" value="${param.startDate}"
									class="form-control" onchange="validateDate()"> <span
									style="font-weight: bold; color: #666;">~</span> <input
									type="date" name="endDate" id="endDate"
									value="${param.endDate}" class="form-control"
									onchange="validateDate()">
							</div>
						</div>

						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 시설</span> <select name="facility_num"
									class="form-control">
									<option value="0">선택</option>
									<c:forEach var="f" items="${facilityList}">
										<option value="${f.num}"
											${param.facility_num == f.num ? 'selected' : ''}>${f.name}</option>
									</c:forEach>
								</select> <span class="label" style="margin-left: 15px;">▶ 제품명</span> <select
									name="item_num" class="form-control">
									<option value="0">선택</option>
									<c:forEach var="i" items="${itemList}">
										<option value="${i.num}"
											${param.item_num == i.num ? 'selected' : ''}>${i.name}</option>
									</c:forEach>
								</select>
							</div>

							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> <input type="text"
										name="keyword" value="${param.keyword}" placeholder="검색">
								</div>
								<button type="submit" class="btn-sch">검색</button>
							</div>
						</div>
					</div>
				</form>

				<!-- 테이블 -->
				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>계획번호</th>
								<th>품목</th>
								<th>계획수량</th>
								<th>생산일자</th>
								<th>생산마감</th>
								<th>진행률</th>
								<th>상태</th>
								<th>시설</th>
								<th>담당자</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty list}">
									<c:forEach var="prod" items="${list}" varStatus="vs">
										<tr>
											<td style="font-weight: bold; color: #555;">
												${page.totalCount - (page.page - 1) * page.size - vs.count + 1}
											</td>
											<td><a href="/prod/detail?planNum=${prod.plan_num}"
												class="link-txt">${prod.plan_num}</a></td>
											<td>${prod.item_name}</td>
											<td>${prod.plan_qty}</td>
											<td>${prod.plan_start}</td>
											<td>${prod.plan_end}</td>
											<td><fmt:formatNumber
													value="${prod.plan_qty > 0 ? (prod.currentqty / prod.plan_qty) * 100 : 0}"
													maxFractionDigits="1" />%</td>
											<td>${prod.plan_status}</td>
											<td>${prod.facility_name}</td>
											<td>${prod.ename}</td>
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
											<td></td>
											<td></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<!-- 페이지네이션 -->
				<div class="pg-wrap">
					<c:if test="${page.startPage > 1}">
						<a href="/prod/list?page=${page.startPage - 1}&startDate=${param.startDate}&endDate=${param.endDate}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
							class="pg-btn">이전</a>
					</c:if>

					<c:forEach begin="${page.startPage}" end="${page.endPage}" var="p">
						<a href="/prod/list?page=${p}&startDate=${param.startDate}&endDate=${param.endDate}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
							class="pg-btn ${page.page == p ? 'pg-active' : ''}">${p}</a>
					</c:forEach>

					<c:if test="${page.endPage < page.totalPages}">
						<a href="/prod/list?page=${page.endPage + 1}&startDate=${param.startDate}&endDate=${param.endDate}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
							class="pg-btn">다음</a>
					</c:if>
				</div>

			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<script>
		function validateDate() {
			const start = document.getElementById('startDate').value;
			const end = document.getElementById('endDate').value;
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('endDate').value = "";
			}
		}
	</script>

</body>
</html>