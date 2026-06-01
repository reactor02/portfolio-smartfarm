<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
    shipment.jsp — 출하 관리 목록 화면 (Tiles content fragment)
    검색 필터(상태/기간/품목/키워드) + 출하 목록 + 페이징.
    컨트롤러는 /shipment (ShipmentController.shipmentList), 검색은 /searchShipment AJAX.
--%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>출하 관리</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/shipment/shipment.css">
</head>
<body>

<div class="mat-all">
	<tiles:insertAttribute name="header" ignore="true" />

	<div class="mat-body">
		<main class="main-cont">
			<div class="page-hdr">
				<h1>출하 관리</h1>
				<%-- e_level 2 이상(팀장·사장)만 등록버튼 표시 --%>
				<c:if test="${sessionScope.loginUser.e_level >= 2}">
					<button type="button" class="btn-reg" id="btnOpenShipModal">+ 등록하기</button>
				</c:if>
			</div>

			<div class="sch-wrap">
				<div class="sch-row-1">
					<span class="label">&#9654; 출하일자</span>
					<input type="date" id="sDate" class="form-control" onchange="validateDate()">
					<span class="date-sep">~</span>
					<input type="date" id="eDate" class="form-control" onchange="validateDate()">
				</div>

				<div class="sch-row-2">
					<div>
						<span class="label">&#9654; 상태</span>
						<select id="status" class="form-control">
							<option value="all" selected>전체</option>
							<option value="출하대기">출하대기</option>
							<option value="진행">진행</option>
							<option value="출하완료">출하완료</option>
							<option value="취소">취소</option>
						</select>
					</div>
					<div>
						<span class="label">&#9654; 정렬순서</span>
						<select id="sortSelect" class="form-control">
							<option value="reg">최근 등록순</option>
							<option value="date">빠른 출하일순</option>
						</select>
					</div>
					<div>
						<span class="label">&#9654; 품목명</span>
						<select id="itemNum" class="form-control">
							<option value="0">전체</option>
							<c:forEach var="it" items="${itemList}">
								<option value="${it.ITEM_NUM}">${it.NAME}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="sch-row-3">
					<div class="sch-input-box">
						<span class="sch-icon">&#128269;</span>
						<input type="text" id="keyword" value="" placeholder="거래처명 혹은 출하ID 검색">
					</div>
					<button type="button" class="btn-sch">검색</button>
					<button type="button" class="select-reset">검색 초기화</button>
				</div>
			</div>

			<div class="tbl-box">
				<table class="stk-tbl">
					<thead>
						<tr>
							<th class="col-no">번호</th>
							<th>출하ID</th>
							<th>출하일</th>
							<th>거래처명</th>
							<th>품목명</th>
							<th>계획수량</th>
							<th>담당자</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody id="shipment-body">
						<c:choose>
							<c:when test="${not empty result}">
								<c:forEach var="item" items="${result}" varStatus="vs">
									<tr>
										<td class="num-cell">${vs.count}</td>
										<td><a href="/shipmentDetail/${item.SHIPMENT_ID}" class="link-id">${item.SHIPMENT_ID}</a></td>
										<td>${item.SHIPMENT_DATE}</td>
										<td>${item.VENDER_NAME}</td>
										<td>${item.NAME}</td>
										<td>${item.PLAN_QTY}</td>
										<td>${item.ENAME}</td>
										<td>
											<c:choose>
												<c:when test="${item.SHIPMENT_STATUS == '출하대기'}">
													<span class="badge badge-waiting">출하대기</span>
												</c:when>
												<c:when test="${item.SHIPMENT_STATUS == '진행'}">
													<span class="badge badge-progress">진행</span>
												</c:when>
												<c:when test="${item.SHIPMENT_STATUS == '출하완료'}">
													<span class="badge badge-done">출하완료</span>
												</c:when>
												<c:when test="${item.SHIPMENT_STATUS == '취소'}">
													<span class="badge badge-cancel">취소</span>
												</c:when>
												<c:otherwise>
													<span class="badge">${item.SHIPMENT_STATUS}</span>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="8" class="empty-cell">조회된 결과가 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<div id="paging-area">
				<jsp:include page="/WEB-INF/views/common/paging.jsp" />
			</div>
		</main>
	</div>

	<tiles:insertAttribute name="footer" ignore="true" />
</div>


<!-- ===== 출하지시 등록 모달 (메인) ===== -->
<div id="shipRegModal" class="modal-overlay" style="display:none;">
	<div class="modal-box">
		<h3 class="modal-title">출하지시 등록</h3>

		<form id="shipInsertForm" method="POST" action="/insertShipment">
			<input type="hidden" id="selectedRequestNum" name="shipmentRequestNum">
			<input type="hidden" id="selectedItemNum"    name="itemNum">

			<!-- 선택된 주문 표시 카드 -->
			<div class="modal-section-label">주문 선택 <span class="required-mark">*</span></div>
			<div class="selected-order-card" id="selectedOrderCard">
				<span class="empty-order-msg">선택된 주문이 없습니다. 주문 검색 버튼을 눌러 선택하세요.</span>
			</div>
			<button type="button" class="btn-pick-order" id="btnOpenOrderModal">&#128269; 주문 검색</button>

			<!-- 입력 필드 -->
			<div class="modal-grid">
				<div class="modal-field">
					<label>담당자</label>
					<span class="modal-readonly">${sessionScope.loginUser.ename}</span>
					<input type="hidden" id="empNum" name="empNum" value="${sessionScope.loginUser.emp_num}">
				</div>
				<div class="modal-field">
					<label>출하일 <span class="required-mark">*</span></label>
					<input type="date" id="shipmentDate" name="shipmentDate" class="modal-input">
				</div>
				<div class="modal-field modal-field-full">
					<label>계획수량 <span class="required-mark">*</span></label>
					<input type="number" id="planQty" name="planQty" min="1" class="modal-input">
				</div>
			</div>

			<div class="modal-btn-wrap">
				<button type="button" class="btn-reg" id="btnInsertShipment">등록</button>
				<button type="button" class="btn-cancel" id="btnCloseShipModal">취소</button>
			</div>
		</form>
	</div>
</div>

<!-- ===== 주문 검색 서브모달 ===== -->
<div id="orderSearchModal" class="modal-overlay modal-sub-overlay" style="display:none;">
	<div class="modal-box modal-box-wide">
		<h3 class="modal-title">주문 검색</h3>

		<!-- 검색 입력 -->
		<div class="order-search-row">
			<input type="text" id="orderSearchInput" class="order-search-input"
			       placeholder="요청번호 / 거래처명 / 품목명 검색">
		</div>

		<!-- 접수 주문 테이블 -->
		<div class="modal-tbl-wrap">
			<table class="modal-req-tbl">
				<thead>
					<tr>
						<th>요청번호</th>
						<th>주문일</th>
						<th>납기일</th>
						<th>거래처명</th>
						<th>품목명</th>
						<th>수량</th>
					</tr>
				</thead>
				<tbody id="pendingRequestBody">
					<tr><td colspan="6" class="empty-cell">불러오는 중...</td></tr>
				</tbody>
			</table>
		</div>

		<div class="modal-btn-wrap">
			<button type="button" class="btn-cancel" id="btnCloseOrderModal">닫기</button>
		</div>
	</div>
</div>

<script src="/resources/js/shipment/shipment.js"></script>
</body>
</html>
