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

				<!-- ======================================================
				     [타이틀 & 등록 버튼]
				     - h1 : 페이지 제목
				     - btn-reg : 등록 모달 또는 등록 페이지로 연결하는 버튼
				     ====================================================== -->
				<div class="hdr">
					<h1>생산계획 관리</h1>
					<button type="button" class="btn-reg">+ 등록하기</button>
				</div>

				<!-- ======================================================
				     [검색 폼]
				     - method="get" : 검색 조건이 URL 파라미터로 전달됨
				     - action : 현재 목록 URL로 설정 (예: /prod/list)
				     - 검색 후 페이지네이션 링크도 동일 파라미터를 유지해야 함
				     - 컨트롤러에서 @ModelAttribute PageDTO로 자동 바인딩됨

				     [파라미터 → PageDTO 필드 매핑]
				       startDate   → String startDate
				       endDate     → String endDate
				       facility_num → int facility_num  (선택 없을 때 value="0" 필수 - 빈 문자열은 int 바인딩 오류)
				       item_num    → int item_num       (동일)
				       keyword     → String keyword
				     ====================================================== -->
				<form name="searchFrm" action="/prod/list" method="get">
					<div class="sch-wrap">

						<!-- 기간 검색 -->
						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 기간</span>
								<input type="date" name="startDate" id="startDate"
									value="${param.startDate}" class="form-control"
									onchange="validateDate()">
								<span style="font-weight: bold; color: #666;">~</span>
								<input type="date" name="endDate" id="endDate"
									value="${param.endDate}" class="form-control"
									onchange="validateDate()">
							</div>
						</div>

						<!-- 드롭다운 검색 + 키워드 검색 -->
						<div class="sch-row">
							<div class="sch-left">

								<!-- 시설 드롭다운
								     - facilityList : 컨트롤러에서 model.addAttribute("facilityList", ...)로 전달
								     - SelectOptionDTO : { int num, String name } 구조
								     - 검색 후 선택값 유지: param.facility_num 비교 -->
								<span class="label">▶ 시설</span>
								<select name="facility_num" class="form-control">
									<option value="0">선택</option>
									<c:forEach var="f" items="${facilityList}">
										<option value="${f.num}"
											${param.facility_num == f.num ? 'selected' : ''}>${f.name}</option>
									</c:forEach>
								</select>

								<!-- 제품 드롭다운
								     - itemList : 컨트롤러에서 model.addAttribute("itemList", ...)로 전달
								     - SQL에서 TYPE = 'PRODUCT' 조건으로 필터링된 목록 -->
								<span class="label" style="margin-left: 15px;">▶ 제품명</span>
								<select name="item_num" class="form-control">
									<option value="0">선택</option>
									<c:forEach var="i" items="${itemList}">
										<option value="${i.num}"
											${param.item_num == i.num ? 'selected' : ''}>${i.name}</option>
									</c:forEach>
								</select>

							</div>

							<!-- 키워드 검색 + 검색/초기화 버튼 -->
							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span>
									<input type="text" name="keyword"
										value="${param.keyword}" placeholder="검색">
								</div>
								<!-- 검색 버튼 : form submit -->
								<button type="submit" class="btn-sch">검색</button>
								<!-- 초기화 버튼 : 모든 검색 조건 제거하고 목록 첫 페이지로 이동 -->
								<button type="button" class="btn-reset"
									onclick="location.href='/prod/list'">초기화</button>
							</div>
						</div>

					</div>
				</form>

				<!-- ======================================================
				     [목록 테이블]
				     - list : 컨트롤러에서 model.addAttribute("list", ...)로 전달 (List<DTO>)
				     - varStatus="vs" : vs.count로 현재 행 순번 계산
				     - 번호 역순 공식 : totalCount - (page-1)*size - vs.count + 1
				     - 데이터 없을 때 빈 행 5개 표시 (레이아웃 유지용)
				     ====================================================== -->
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
											<!-- 역순 번호: 전체건수 기준으로 내림차순 표시 -->
											<td style="font-weight: bold; color: #555;">
												${page.totalCount - (page.page - 1) * page.size - vs.count + 1}
											</td>
											<td>
												<a href="/prod/detail?planNum=${prod.plan_num}" class="link-txt">
													${prod.plan_num}
												</a>
											</td>
											<td>${prod.item_name}</td>
											<td>${prod.plan_qty}</td>
											<td>${prod.plan_start}</td>
											<td>${prod.plan_end}</td>
											<!-- 진행률: 작업지시 누적수량 / 계획수량 * 100 -->
											<td>
												<fmt:formatNumber
													value="${prod.plan_qty > 0 ? (prod.currentqty / prod.plan_qty) * 100 : 0}"
													maxFractionDigits="1" />%
											</td>
											<td>${prod.plan_status}</td>
											<td>${prod.facility_name}</td>
											<td>${prod.ename}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<!-- 데이터 없을 때 빈 행으로 테이블 높이 유지 -->
									<c:forEach var="i" begin="1" end="5">
										<tr>
											<td style="font-weight: bold; color: #888;">${i}</td>
											<td></td><td></td><td></td><td></td>
											<td></td><td></td><td></td><td></td><td></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<!-- ======================================================
				     [페이지네이션]
				     - page : 컨트롤러에서 model.addAttribute("page", pageDTO)로 전달
				     - PageDTO 필드: startPage, endPage, totalPages, page(현재)
				     - 페이지 이동 시 검색 조건 파라미터를 그대로 유지해야 함
				       (startDate, endDate, facility_num, item_num, keyword 전부 포함)
				     - 이전/다음 버튼: 블록 단위 이동 (blockSize=10 기준)
				     ====================================================== -->
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
		/* 시작일이 종료일보다 이후인 경우 종료일 초기화 */
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
