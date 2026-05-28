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
							<option value="대기">대기</option>
							<option value="진행">진행</option>
							<option value="완료">완료</option>
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
												<c:when test="${item.SHIPMENT_STATUS == '대기'}">
													<span class="badge badge-waiting">대기</span>
												</c:when>
												<c:when test="${item.SHIPMENT_STATUS == '진행'}">
													<span class="badge badge-progress">진행</span>
												</c:when>
												<c:when test="${item.SHIPMENT_STATUS == '완료'}">
													<span class="badge badge-done">완료</span>
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
					if (statusLabel == '대기')      statusClass = 'badge-waiting';
					else if (statusLabel == '진행') statusClass = 'badge-progress';
					else if (statusLabel == '완료') statusClass = 'badge-done';
					else if (statusLabel == '취소') statusClass = 'badge-cancel';

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
</body>
</html>
