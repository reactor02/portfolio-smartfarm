/*
 * shipment.js — 출하 목록 화면 스크립트
 *   날짜 유효성, 검색/페이징, 출하지시 등록 모달, 주문 검색 서브모달.
 *   JSP 인라인 스크립트를 외부 파일로 분리.
 */

/* ── 날짜 유효성 ── */
function validateDate() {
	var start = document.getElementById('sDate').value;
	var end   = document.getElementById('eDate').value;
	if (start && end && start > end) {
		alert('시작 날짜는 종료 날짜보다 이후일 수 없습니다.');
		document.getElementById('eDate').value = '';
	}
}

/* ── 페이징 렌더링 ── */
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
	var itemNum = document.querySelector('#itemNum').value;
	var sort    = document.querySelector('#sortSelect').value;

	var params = new URLSearchParams();
	params.append('page',     pageNum);
	params.append('sDate',    sDate);
	params.append('eDate',    eDate);
	params.append('status',   status);
	params.append('keyword',  keyword);
	params.append('item_num', itemNum);
	params.append('sort',     sort);

	fetch('/searchShipment?' + params.toString())
	.then(function(response) { return response.json(); })
	.then(function(data) {
		var tbody = document.querySelector('#shipment-body');

		if (!data.searchResult || data.searchResult.length == 0) {
			tbody.innerHTML = '<tr><td colspan="9" class="empty-cell">조회된 결과가 없습니다.</td></tr>';
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
				      + '<td>' + (item.WORKER_ENAME  || '') + '</td>'
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

/* ════════════════════════════════
   출하지시 등록 모달
   ════════════════════════════════ */
var allPendingOrders = [];

/* 등록버튼은 e_level 2 이상만 렌더링 — 없을 수도 있으므로 null 체크 */
var btnOpenShipModal = document.getElementById('btnOpenShipModal');
if (btnOpenShipModal) {
	btnOpenShipModal.addEventListener('click', function() {
		resetShipModal();
		document.getElementById('shipRegModal').style.display = 'flex';
	});
}

var btnCloseShipModal = document.getElementById('btnCloseShipModal');
if (btnCloseShipModal) {
	btnCloseShipModal.addEventListener('click', closeShipModal);
}

var shipRegModal = document.getElementById('shipRegModal');
if (shipRegModal) {
	shipRegModal.addEventListener('click', function(e) {
		if (e.target === this) closeShipModal();
	});
}

function closeShipModal() {
	document.getElementById('shipRegModal').style.display = 'none';
	resetShipModal();
}

function resetShipModal() {
	document.getElementById('selectedRequestNum').value = '';
	document.getElementById('selectedItemNum').value    = '';
	/* empNum은 로그인 사용자 hidden input — 세션값 유지, 초기화 불필요 */
	document.getElementById('shipmentDate').value       = '';
	document.getElementById('planQty').value            = '';
	document.getElementById('workerNum').value          = '';
	document.getElementById('workerDisplay').value      = '';
	setSelectedOrderCard(null);
}

/* ── 서브모달 열기/닫기 ── */
var btnOpenOrderModal = document.getElementById('btnOpenOrderModal');
if (btnOpenOrderModal) {
	btnOpenOrderModal.addEventListener('click', function() {
		document.getElementById('orderSearchInput').value = '';
		loadPendingRequests();
		document.getElementById('orderSearchModal').style.display = 'flex';
	});
}

document.getElementById('btnCloseOrderModal').addEventListener('click', function() {
	document.getElementById('orderSearchModal').style.display = 'none';
});
document.getElementById('orderSearchModal').addEventListener('click', function(e) {
	if (e.target === this) document.getElementById('orderSearchModal').style.display = 'none';
});

/* ── 접수 주문 목록 AJAX ── */
function loadPendingRequests() {
	fetch('/loadPendingRequests')
		.then(function(res) { return res.json(); })
		.then(function(data) {
			allPendingOrders = data || [];
			renderPendingTable(allPendingOrders);
		})
		.catch(function(err) { console.error('주문 목록 조회 오류:', err); });
}

/* ── 서브모달 검색 필터 ── */
document.getElementById('orderSearchInput').addEventListener('input', function() {
	var kw = this.value.trim().toLowerCase();
	if (!kw) { renderPendingTable(allPendingOrders); return; }
	renderPendingTable(allPendingOrders.filter(function(r) {
		return (r.REQUEST_ID  || '').toLowerCase().indexOf(kw) !== -1
		    || (r.VENDER_NAME || '').toLowerCase().indexOf(kw) !== -1
		    || (r.NAME        || '').toLowerCase().indexOf(kw) !== -1;
	}));
});

function renderPendingTable(list) {
	var tbody = document.getElementById('pendingRequestBody');
	if (!list || list.length === 0) {
		tbody.innerHTML = '<tr><td colspan="6" class="empty-cell">접수된 주문이 없습니다.</td></tr>';
		return;
	}
	var html = '';
	list.forEach(function(r) {
		html += '<tr class="req-row" onclick="selectRequest('
			+ '\'' + esc(r.SHIPMENT_REQUEST_NUM || '') + '\','
			+ (r.ITEM_NUM || 0) + ','
			+ (r.REQUEST_QTY || 1) + ','
			+ '\'' + esc(r.REQUEST_ID   || '') + '\','
			+ '\'' + esc(r.VENDER_NAME  || '') + '\','
			+ '\'' + esc(r.NAME         || '') + '\','
			+ '\'' + esc(r.REQUEST_DATE || '') + '\','
			+ '\'' + esc(r.DUE_DATE     || '') + '\''
			+ ')">'
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

function esc(s) { return String(s).replace(/\\/g, '\\\\').replace(/'/g, "\\'"); }

/* ── 행 선택 → 메인 모달에 반영 후 서브모달 닫기 ── */
function selectRequest(requestNum, itemNum, qty, requestId, venderName, itemName, requestDate, dueDate) {
	document.getElementById('selectedRequestNum').value = requestNum;
	document.getElementById('selectedItemNum').value    = itemNum;
	document.getElementById('planQty').value            = qty;
	setSelectedOrderCard({ requestId: requestId, venderName: venderName,
	                       itemName: itemName, qty: qty, dueDate: dueDate });
	document.getElementById('orderSearchModal').style.display = 'none';
}

function setSelectedOrderCard(order) {
	var card = document.getElementById('selectedOrderCard');
	if (!order) {
		card.className = 'selected-order-card';
		card.innerHTML = '<span class="empty-order-msg">선택된 주문이 없습니다. 주문 검색 버튼을 눌러 선택하세요.</span>';
		return;
	}
	card.className = 'selected-order-card has-order';
	card.innerHTML = '<div class="order-info-row">'
		+ mkInfo('요청번호', order.requestId)
		+ mkInfo('거래처',   order.venderName)
		+ mkInfo('품목',     order.itemName)
		+ mkInfo('주문수량', order.qty + ' EA')
		+ mkInfo('납기일',   order.dueDate)
		+ '</div>';
}

function mkInfo(label, val) {
	return '<span class="order-info-item">'
	     + '<span class="order-info-label">' + label + '</span>'
	     + '<span class="order-info-val">'   + val   + '</span>'
	     + '</span>';
}

/* ── 등록 버튼 ── */
var btnInsertShipment = document.getElementById('btnInsertShipment');
if (btnInsertShipment) {
	btnInsertShipment.addEventListener('click', function() {
		var requestNum   = document.getElementById('selectedRequestNum').value;
		var shipmentDate = document.getElementById('shipmentDate').value;
		var planQty      = document.getElementById('planQty').value;
		var workerNum    = document.getElementById('workerNum').value;

		if (!requestNum)             { alert('주문을 선택해주세요.');     return; }
		if (!workerNum)              { alert('실무자를 선택해주세요.');   return; }
		if (!shipmentDate)           { alert('출하일을 입력해주세요.');   return; }
		if (!planQty || planQty < 1) { alert('계획수량을 입력해주세요.'); return; }

		document.getElementById('shipInsertForm').submit();
	});
}

/* ════════════════════════════════
   실무자 검색 서브모달 (부서 3·5 재직자, /work/workers 재사용)
   ════════════════════════════════ */
function openWorkerModal() {
	document.getElementById('workerSearchInput').value = '';
	searchWorkers(1);
	document.getElementById('workerSearchModal').style.display = 'flex';
}

var btnOpenWorkerModal = document.getElementById('btnOpenWorkerModal');
if (btnOpenWorkerModal) {
	btnOpenWorkerModal.addEventListener('click', openWorkerModal);
}

/* 표시 인풋창 클릭으로도 실무자 검색 모달 열기 */
var workerDisplayInput = document.getElementById('workerDisplay');
if (workerDisplayInput) {
	workerDisplayInput.addEventListener('click', openWorkerModal);
}

var btnCloseWorkerModal = document.getElementById('btnCloseWorkerModal');
if (btnCloseWorkerModal) {
	btnCloseWorkerModal.addEventListener('click', function() {
		document.getElementById('workerSearchModal').style.display = 'none';
	});
}

var workerSearchModalEl = document.getElementById('workerSearchModal');
if (workerSearchModalEl) {
	workerSearchModalEl.addEventListener('click', function(e) {
		if (e.target === this) this.style.display = 'none';
	});
}

var workerSearchInput = document.getElementById('workerSearchInput');
if (workerSearchInput) {
	workerSearchInput.addEventListener('keydown', function(e) {
		if (e.key === 'Enter') searchWorkers(1);
	});
}

/* 실무자 검색 AJAX — work 모듈의 /work/workers 엔드포인트 재사용(부서 3·5 재직자) */
function searchWorkers(page) {
	var keyword = document.getElementById('workerSearchInput').value;
	fetch('/work/workers?keyword=' + encodeURIComponent(keyword) + '&page=' + page)
		.then(function(r) { return r.json(); })
		.then(function(data) {
			renderWorkerTable(data.list);
			renderWorkerPaging(data.currentPage, data.totalPages);
		})
		.catch(function(err) { console.error('실무자 검색 오류:', err); });
}

function renderWorkerTable(list) {
	var tbody = document.getElementById('workerSearchBody');
	if (!list || list.length === 0) {
		tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:20px;color:#888;">검색 결과가 없습니다.</td></tr>';
		return;
	}
	var html = '';
	list.forEach(function(w) {
		var empNum = w.EMP_NUM   || '';
		var ename  = w.ENAME     || '';
		var tel    = w.TEL       || '';
		html += '<tr style="cursor:pointer;" onclick="selectWorker(\'' + esc(String(empNum)) + '\',\'' + esc(ename) + '\')">'
		      + '<td style="text-align:center;">' + empNum + '</td>'
		      + '<td style="text-align:center;">' + ename  + '</td>'
		      + '<td style="text-align:center;">' + tel    + '</td>'
		      + '</tr>';
	});
	tbody.innerHTML = html;
}

function renderWorkerPaging(cur, total) {
	var wrap = document.getElementById('workerPagination');
	var html = '';
	if (cur > 1) {
		html += '<a href="#" class="pg-btn" onclick="searchWorkers(' + (cur - 1) + ');return false;">이전</a>';
	}
	for (var p = 1; p <= total; p++) {
		html += p === cur
			? '<a href="#" class="pg-btn pg-active">' + p + '</a>'
			: '<a href="#" class="pg-btn" onclick="searchWorkers(' + p + ');return false;">' + p + '</a>';
	}
	if (cur < total) {
		html += '<a href="#" class="pg-btn" onclick="searchWorkers(' + (cur + 1) + ');return false;">다음</a>';
	}
	wrap.innerHTML = html;
}

function selectWorker(empNum, ename) {
	document.getElementById('workerNum').value     = empNum;
	document.getElementById('workerDisplay').value = ename + ' (' + empNum + ')';
	document.getElementById('workerSearchModal').style.display = 'none';
}
