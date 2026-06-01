<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
    request.jsp — 출하요청(주문) 관리 목록 화면 (Tiles content fragment)
    검색 필터 + 요청 목록 + 페이징 + 등록 모달(거래처/품목 검색).
    컨트롤러는 /request (RequestController.requestList), 검색은 /searchRequest AJAX.
--%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>


<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/request/request.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="page-hdr">
					<h1>주문 관리</h1>
					<%-- e_level 2 이상(팀장·사장)만 등록버튼 표시 --%>
					<c:if test="${sessionScope.loginUser.e_level >= 2}">
						<button type="button" class="btn-reg" id="btnOpenModal">+ 등록하기</button>
					</c:if>
				</div>

				<div class="sch-wrap">
					<!-- 1행: 기간 -->
					<div class="sch-row-1">
						<span class="label">▶ 납기일자</span>
						<input type="date" id="sDate" class="form-control" onchange="validateDate()">
						<span class="date-sep">~</span>
						<input type="date" id="eDate" class="form-control" onchange="validateDate()">
					</div>

					<!-- 2행: 상태 | 정렬순서 -->
					<div class="sch-row-2">
						<div>
							<span class="label">▶ 상태</span>
							<select id="status" class="form-control">
								<option value="all">전체</option>
								<option value="접수">접수</option>
								<option value="출하대기">출하대기</option>
								<option value="출하완료">출하완료</option>
								<option value="취소">취소</option>
							</select>
						</div>
						<div>
							<span class="label">▶ 정렬순서</span>
							<select id="sortSelect" class="form-control">
								<option value="reg">최근 등록순</option>
								<option value="due">빠른 납기일순</option>
							</select>
						</div>
					</div>

					<!-- 3행: 키워드 검색 -->
					<div class="sch-row-3">
						<div class="sch-input-box">
							<span class="sch-icon">&#128269;</span>
							<input type="text" id="keyword" placeholder="거래처명 또는 요청번호 검색">
						</div>
						<button type="button" class="btn-sch" id="btnSearch">검색</button>
						<button type="button" class="select-reset" id="btnReset">검색 초기화</button>
					</div>
				</div>

				<!-- 수량 비교 차트 -->
				<div class="chart-wrap">
					<canvas id="requestChart"></canvas>
				</div>

				<!-- 카드 그리드 -->
				<div class="card-grid" id="request-body">
					<c:choose>
						<c:when test="${not empty result}">
							<c:forEach var="item" items="${result}">
								<c:set var="pct" value="${item.REQUEST_QTY > 0 ? (item.SHIPPED_QTY > item.REQUEST_QTY ? 100 : item.SHIPPED_QTY * 100 / item.REQUEST_QTY) : 0}"/>
								<div class="req-card" onclick="location.href='/requestDetail/${item.REQUEST_ID}'">
									<div class="req-card-top">
										<span class="badge
											<c:choose>
												<c:when test="${item.REQUEST_STATUS == '접수'}">badge-progress</c:when>
												<c:when test="${item.REQUEST_STATUS == '출하대기'}">badge-waiting</c:when>
												<c:when test="${item.REQUEST_STATUS == '출하완료'}">badge-done</c:when>
												<c:when test="${item.REQUEST_STATUS == '취소'}">badge-cancel</c:when>
											</c:choose>
										">${item.REQUEST_STATUS}</span>
										<span class="req-card-date">납기 ${item.DUE_DATE}</span>
									</div>
									<div class="req-card-id">${item.REQUEST_ID}</div>
									<div class="req-card-vender">${item.VENDER_NAME}</div>
									<div class="req-card-item">${item.NAME} · ${item.ENAME}</div>
									<div class="req-card-qty">주문 <strong>${item.REQUEST_QTY}</strong> / 출하 <strong>${item.SHIPPED_QTY}</strong></div>
									<div class="req-progress-bg">
										<div class="req-progress-fill" style="width:${pct}%"></div>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="card-empty">등록된 출하 요청이 없습니다.</div>
						</c:otherwise>
					</c:choose>
				</div>

				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<!-- ===== 주문 등록 모달 ===== -->
	<div id="regModal" class="modal-overlay">
		<div class="modal-box">
			<h3 class="modal-title">주문 등록</h3>

			<form method="POST" action="/insertRequest" id="insert-form">
				<div class="modal-grid">

					<!-- 거래처 검색 (드롭다운 방식) -->
					<div class="modal-field modal-field-full">
						<label>거래처명 <span class="required-mark">*</span></label>
						<div class="vender-search-wrap">
							<input type="text" id="venderSearch" placeholder="거래처명 입력 (클릭하면 전체 표시)" autocomplete="off">
							<div id="venderDropdown">
								<table class="vender-tbl">
									<colgroup>
										<col><col><col>
									</colgroup>
									<tbody id="venderList"></tbody>
								</table>
							</div>
						</div>
					</div>

					<!-- 주문일 | 납기일 -->
					<div class="modal-field">
						<label>주문일 <span class="required-mark">*</span></label>
						<input type="date" name="request_date" id="requestDate">
					</div>
					<div class="modal-field">
						<label>납기일 <span class="required-mark">*</span></label>
						<input type="date" name="due_date" id="dueDate">
					</div>

					<!-- 품목 (full) -->
					<div class="modal-field modal-field-full">
						<label>품목 <span class="required-mark">*</span></label>
						<select name="item_num" id="itemSelect">
							<option value="">-- 품목 선택 --</option>
							<c:forEach var="item" items="${itemList}">
								<option value="${item.ITEM_NUM}">${item.NAME}</option>
							</c:forEach>
						</select>
					</div>

					<!-- 수량 -->
					<div class="modal-field">
						<label>수량 <span class="required-mark">*</span></label>
						<input type="number" name="request_qty" id="requestQty" min="1" value="1">
					</div>

					<!-- 상세지시사항 -->
					<div class="modal-field modal-field-full">
						<label>상세지시사항</label>
						<textarea name="content" id="requestContent" rows="4" placeholder="상세지시사항 입력"></textarea>
					</div>

				</div>

				<input type="hidden" name="vender_seq" id="selectedVenderSeq">

				<div class="modal-btn-wrap">
					<button type="button" class="btn-reg" id="btnInsert">등록</button>
					<button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
				</div>
			</form>
		</div>
	</div>

<script>
var INITIAL_CHART_DATA = [
    <c:forEach var="item" items="${result}" varStatus="vs">
    { id: '<c:out value="${item.REQUEST_ID}"/>', qty: ${item.REQUEST_QTY}, shipped: ${item.SHIPPED_QTY} }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];
</script>
<script src="/resources/js/request/request.js"></script>
</body>
</html>
