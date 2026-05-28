<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>출하 관리</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/shipment/shipment.css">
</head>
<body>

<div class="mat-all">
	<tiles:insertAttribute name="header" ignore="true" />

	<div class="mat-body">
		<main class="main-cont">
			<div class="hdr">
				<h1>출하 관리</h1>
				<button type="button" class="btn-reg" id="btnOpenShipModal">+ 등록하기</button>
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
					<div></div>
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

<script>
	function validateDate() {
		var start = document.getElementById('sDate').value;
		var end = document.getElementById('eDate').value;
		if (start && end && start > end) {
			alert('시작 날짜는 종료 날짜보다 이후일 수 없습니다.');
			document.getElementById('eDate').value = '';
		}
	}

	function renderPagination(pInfo) {
		var html = '';
		if (!pInfo.isFirstPage) {
			html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum - 1) + ')">이전</a>';
		}
		for (var i = 0; i < pInfo.navigatepageNums.length; i++) {
			var num = pInfo.navigatepageNums[i];
			html += '<a class="page-link prev-next ' + (num == pInfo.pageNum ? 'active' : '') + '" href="javascript:movePage(' + num + ')">' + num + '</a>';
		}
		if (!pInfo.isLastPage) {
			html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum + 1) + ')">다음</a>';
		}
		document.querySelector('.pagination-container').innerHTML = html;
	}

	document.querySelector('.btn-sch').addEventListener('click', function() {
		movePage(1);
	});

	function movePage(pageNum) {
		var sDate   = document.querySelector('#sDate').value;
		var eDate   = document.querySelector('#eDate').value;
		var status  = document.querySelector('#status').value;
		var keyword = document.querySelector('#keyword').value;

		var params = new URLSearchParams();
		params.append('page',    pageNum);
		params.append('sDate',   sDate);
		params.append('eDate',   eDate);
		params.append('status',  status);
		params.append('keyword', keyword);

		fetch('/searchShipment?' + params.toString())
		.then(function(response) { return response.json(); })
		.then(function(data) {
			var tbody = document.querySelector('#shipment-body');

			if (!data.searchResult || data.searchResult.length == 0) {
				tbody.innerHTML = '<tr><td colspan="8" class="empty-cell">조회된 결과가 없습니다.</td></tr>';
				renderPagination(data.pageInfo);
				return;
			}

			if (data.status === 'good') {
				var html = '';
				var offset = (data.pageInfo.pageNum - 1) * data.pageInfo.pageSize;
				for (var i = 0; i < data.searchResult.length; i++) {
					var item = data.searchResult[i];
					var statusClass = '';
					var statusLabel = item.SHIPMENT_STATUS || '';
					if (statusLabel == '출하대기')      statusClass = 'badge-waiting';
					else if (statusLabel == '진행')    statusClass = 'badge-progress';
					else if (statusLabel == '출하완료') statusClass = 'badge-done';
					else if (statusLabel == '취소')    statusClass = 'badge-cancel';

					html += '<tr>'
					      + '<td class="num-cell">' + (offset + i + 1) + '</td>'
					      + '<td><a href="/shipmentDetail/' + (item.SHIPMENT_ID || '') + '" class="link-id">' + (item.SHIPMENT_ID || '') + '</a></td>'
					      + '<td>' + (item.SHIPMENT_DATE || '') + '</td>'
					      + '<td>' + (item.VENDER_NAME   || '') + '</td>'
					      + '<td>' + (item.NAME          || '') + '</td>'
					      + '<td>' + (item.PLAN_QTY      || '') + '</td>'
					      + '<td>' + (item.ENAME         || '') + '</td>'
					      + '<td><span class="badge ' + statusClass + '">' + statusLabel + '</span></td>'
					      + '</tr>';
				}
				tbody.innerHTML = html;
				renderPagination(data.pageInfo);
			}
		})
		.catch(function(error) {
			console.error('통신 오류:', error);
		});
	}

	document.querySelector('.select-reset').addEventListener('click', function() {
		location.reload();
	});
</script>

<!-- ===== 출하지시 등록 모달 ===== -->
<div id="shipRegModal" class="modal-overlay" style="display:none;">
	<div class="modal-box modal-box-wide">
		<h3 class="modal-title">출하지시 등록</h3>

		<form id="shipInsertForm" method="POST" action="/insertShipment">
			<input type="hidden" id="selectedRequestNum" name="shipmentRequestNum">
			<input type="hidden" id="selectedItemNum"    name="itemNum">

			<!-- 주문 선택 테이블 -->
			<div class="modal-section-label">주문 선택 <span class="required-mark">*</span></div>
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

			<!-- 입력 필드 -->
			<div class="modal-grid" style="margin-top:18px;">
				<div class="modal-field">
					<label>담당자 <span class="required-mark">*</span></label>
					<select id="empNum" name="empNum" class="modal-select">
						<option value="">-- 선택 --</option>
						<c:forEach var="emp" items="${empList}">
							<option value="${emp.EMP_NUM}">${emp.ENAME}</option>
						</c:forEach>
					</select>
				</div>
				<div class="modal-field">
					<label>출하일 <span class="required-mark">*</span></label>
					<input type="date" id="shipmentDate" name="shipmentDate" class="modal-input">
				</div>
				<div class="modal-field">
					<label>계획수량 <span class="required-mark">*</span></label>
					<input type="number" id="planQty" name="planQty" min="1" value="" class="modal-input">
				</div>
			</div>

			<div class="modal-btn-wrap">
				<button type="button" class="btn-reg" id="btnInsertShipment">등록</button>
				<button type="button" class="btn-cancel" id="btnCloseShipModal">취소</button>
			</div>
		</form>
	</div>
</div>

<script>
	/* ── 모달 열기/닫기 ── */
	document.getElementById('btnOpenShipModal').addEventListener('click', function() {
		resetShipModal();
		loadPendingRequests();
		document.getElementById('shipRegModal').style.display = 'flex';
	});
	document.getElementById('btnCloseShipModal').addEventListener('click', closeShipModal);
	document.getElementById('shipRegModal').addEventListener('click', function(e) {
		if (e.target === this) closeShipModal();
	});

	function closeShipModal() {
		document.getElementById('shipRegModal').style.display = 'none';
		resetShipModal();
	}

	function resetShipModal() {
		document.getElementById('selectedRequestNum').value = '';
		document.getElementById('selectedItemNum').value    = '';
		document.getElementById('empNum').selectedIndex     = 0;
		document.getElementById('shipmentDate').value       = '';
		document.getElementById('planQty').value            = '';
		document.getElementById('pendingRequestBody').innerHTML =
			'<tr><td colspan="6" class="empty-cell">불러오는 중...</td></tr>';
	}

	/* ── 접수 주문 목록 AJAX ── */
	function loadPendingRequests() {
		fetch('/loadPendingRequests')
			.then(function(res) { return res.json(); })
			.then(function(data) { renderPendingTable(data); })
			.catch(function(err) { console.error('주문 목록 조회 오류:', err); });
	}

	function renderPendingTable(list) {
		var tbody = document.getElementById('pendingRequestBody');
		if (!list || list.length === 0) {
			tbody.innerHTML = '<tr><td colspan="6" class="empty-cell">접수된 주문이 없습니다.</td></tr>';
			return;
		}
		var html = '';
		list.forEach(function(r) {
			html += '<tr class="req-row" onclick="selectRequest(this,\''
				+ (r.SHIPMENT_REQUEST_NUM || '') + '\',' + (r.ITEM_NUM || 0) + ',' + (r.REQUEST_QTY || 1) + ')">'
				+ '<td>' + (r.REQUEST_ID   || '') + '</td>'
				+ '<td>' + (r.REQUEST_DATE || '') + '</td>'
				+ '<td>' + (r.DUE_DATE     || '') + '</td>'
				+ '<td>' + (r.VENDER_NAME  || '') + '</td>'
				+ '<td>' + (r.NAME         || '') + '</td>'
				+ '<td>' + (r.REQUEST_QTY  || '') + '</td>'
				+ '</tr>';
		});
		tbody.innerHTML = html;
	}

	/* ── 행 선택 ── */
	function selectRequest(row, requestNum, itemNum, qty) {
		document.querySelectorAll('.req-row').forEach(function(r) {
			r.classList.remove('req-row-selected');
		});
		row.classList.add('req-row-selected');
		document.getElementById('selectedRequestNum').value = requestNum;
		document.getElementById('selectedItemNum').value    = itemNum;
		document.getElementById('planQty').value            = qty;
	}

	/* ── 등록 버튼 ── */
	document.getElementById('btnInsertShipment').addEventListener('click', function() {
		var requestNum   = document.getElementById('selectedRequestNum').value;
		var empNum       = document.getElementById('empNum').value;
		var shipmentDate = document.getElementById('shipmentDate').value;
		var planQty      = document.getElementById('planQty').value;

		if (!requestNum)   { alert('주문을 선택해주세요.');     return; }
		if (!empNum)       { alert('담당자를 선택해주세요.');   return; }
		if (!shipmentDate) { alert('출하일을 입력해주세요.');   return; }
		if (!planQty || planQty < 1) { alert('계획수량을 입력해주세요.'); return; }

		document.getElementById('shipInsertForm').submit();
	});
</script>
</body>
</html>
