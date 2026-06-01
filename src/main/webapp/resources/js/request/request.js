/*
 * request.js — 출하요청(주문) 목록 화면 스크립트
 *   날짜 유효성, AJAX 검색/페이징, 카드 렌더링, 수량 비교 차트, 주문 등록 모달, 거래처 검색 드롭다운.
 */

/* ── 날짜 유효성 ── */
function validateDate() {
	const start = document.getElementById('sDate').value;
	const end   = document.getElementById('eDate').value;
	if (start && end && start > end) {
		alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
		document.getElementById('eDate').value = "";
	}
}

/* ── 페이징 렌더링 ── */
function renderPagination(pInfo) {
	let html = "";
	if (!pInfo.isFirstPage)
		html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum - 1) + ')">이전</a>';
	pInfo.navigatepageNums.forEach(function(num) {
		html += '<a class="page-link prev-next ' + (num == pInfo.pageNum ? 'active' : '') + '" href="javascript:movePage(' + num + ')">' + num + '</a>';
	});
	if (!pInfo.isLastPage)
		html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum + 1) + ')">다음</a>';
	document.querySelector(".pagination-container").innerHTML = html;
}

/* ── 카드 렌더링 ── */
function renderCards(items) {
	var grid = document.getElementById('request-body');
	if (!items || items.length === 0) {
		grid.innerHTML = '<div class="card-empty">조회된 결과가 없습니다.</div>';
		return;
	}
	var html = '';
	items.forEach(function(item) {
		var statusClass =
			item.REQUEST_STATUS === '접수'    ? 'badge-progress' :
			item.REQUEST_STATUS === '출하대기' ? 'badge-waiting'  :
			item.REQUEST_STATUS === '출하완료' ? 'badge-done'     :
			item.REQUEST_STATUS === '취소'    ? 'badge-cancel'   : '';
		var reqQty  = parseInt(item.REQUEST_QTY  || 0);
		var shipQty = parseInt(item.SHIPPED_QTY  || 0);
		var pct = reqQty > 0 ? Math.min(100, Math.round(shipQty / reqQty * 100)) : 0;

		html += '<div class="req-card" onclick="location.href=\'/requestDetail/' + (item.REQUEST_ID || '') + '\'">'
			+ '<div class="req-card-top">'
			+   '<span class="badge ' + statusClass + '">' + (item.REQUEST_STATUS || '') + '</span>'
			+   '<span class="req-card-date">납기 ' + (item.DUE_DATE || '-') + '</span>'
			+ '</div>'
			+ '<div class="req-card-id">' + (item.REQUEST_ID || '') + '</div>'
			+ '<div class="req-card-vender">' + (item.VENDER_NAME || '') + '</div>'
			+ '<div class="req-card-item">' + (item.NAME || '') + ' · ' + (item.ENAME || '') + '</div>'
			+ '<div class="req-card-qty">주문 <strong>' + reqQty + '</strong> / 출하 <strong>' + shipQty + '</strong></div>'
			+ '<div class="req-progress-bg"><div class="req-progress-fill" style="width:' + pct + '%"></div></div>'
			+ '</div>';
	});
	grid.innerHTML = html;
}

/* ── 목록 검색 / 페이지 이동 ── */
function movePage(pageNum) {
	const sDate   = document.getElementById('sDate').value;
	const eDate   = document.getElementById('eDate').value;
	const status  = document.getElementById('status').value;
	const keyword = document.getElementById('keyword').value;
	const sort    = document.getElementById('sortSelect').value;

	const params = new URLSearchParams();
	params.append("page",    pageNum);
	params.append("sDate",   sDate);
	params.append("eDate",   eDate);
	params.append("status",  status);
	params.append("type",    '');
	params.append("keyword", keyword);
	params.append("sort",    sort);

	fetch('/searchRequest?' + params.toString())
		.then(res => res.json())
		.then(data => {
			if (!data.searchResult || data.searchResult.length === 0) {
				renderCards([]);
				renderPagination(data.pageInfo);
				updateChart([]);
				return;
			}
			if (data.status === "good") {
				renderCards(data.searchResult);
				renderPagination(data.pageInfo);
				updateChart(data.searchResult);
			}
		})
		.catch(err => console.error("데이터 통신 오류:", err));
}

document.getElementById('btnSearch').addEventListener('click', () => movePage(1));
document.getElementById('btnReset').addEventListener('click',  () => location.reload());

/* ════════════════════════════════
   수량 비교 차트 (Chart.js)
   INITIAL_CHART_DATA는 JSP가 주입한다.
   ════════════════════════════════ */
var reqChart = null;

function buildChartData(items) {
	return {
		labels:   items.map(function(d) { return d.REQUEST_ID  || d.id      || ''; }),
		qtyData:  items.map(function(d) { return parseInt(d.REQUEST_QTY || d.qty     || 0); }),
		shipData: items.map(function(d) { return parseInt(d.SHIPPED_QTY || d.shipped || 0); })
	};
}

function initChart(rawData) {
	var d = buildChartData(rawData);
	var ctx = document.getElementById('requestChart').getContext('2d');
	reqChart = new Chart(ctx, {
		type: 'bar',
		data: {
			labels: d.labels,
			datasets: [
				{ label: '주문수량', data: d.qtyData,  backgroundColor: '#B7E4C7', borderRadius: 4 },
				{ label: '출하수량', data: d.shipData, backgroundColor: '#2D6A4F', borderRadius: 4 }
			]
		},
		options: {
			responsive: true,
			plugins: { legend: { position: 'top' } },
			scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
		}
	});
}

function updateChart(items) {
	if (!reqChart) return;
	var d = buildChartData(items);
	reqChart.data.labels            = d.labels;
	reqChart.data.datasets[0].data  = d.qtyData;
	reqChart.data.datasets[1].data  = d.shipData;
	reqChart.update();
}

if (typeof INITIAL_CHART_DATA !== 'undefined' && INITIAL_CHART_DATA.length > 0) {
	initChart(INITIAL_CHART_DATA);
}

/* ════════════════════════════════
   모달 열기 / 닫기 / 초기화
   등록버튼은 e_level 2 이상만 렌더링 — null 체크 필수
   ════════════════════════════════ */
var btnOpenModal = document.getElementById('btnOpenModal');
if (btnOpenModal) {
	btnOpenModal.addEventListener('click', openModal);
}

document.getElementById('btnCloseModal').addEventListener('click', closeModal);
document.getElementById('regModal').addEventListener('click', function(e) {
	if (e.target === this) closeModal();
});

function openModal() {
	resetModal();
	document.getElementById('regModal').style.display = 'flex';
}

function closeModal() {
	document.getElementById('regModal').style.display = 'none';
	resetModal();
}

function resetModal() {
	document.getElementById('venderSearch').value       = '';
	document.getElementById('selectedVenderSeq').value  = '';
	document.getElementById('dueDate').value            = '';
	document.getElementById('requestQty').value         = '1';
	document.getElementById('requestContent').value     = '';
	document.getElementById('itemSelect').selectedIndex = 0;
	document.getElementById('venderDropdown').style.display = 'none';
	document.getElementById('requestDate').value = new Date().toISOString().split('T')[0];
}

/* ════════════════════════════════
   거래처 검색 (드롭다운 방식)
   ════════════════════════════════ */
document.getElementById('venderSearch').addEventListener('focus', function() {
	loadVenderList(this.value.trim());
	document.getElementById('venderDropdown').style.display = 'block';
});

document.getElementById('venderSearch').addEventListener('input', function() {
	loadVenderList(this.value.trim());
	document.getElementById('venderDropdown').style.display = 'block';
});

document.addEventListener('click', function(e) {
	const wrap = document.getElementById('venderSearch').closest('div');
	if (!wrap.contains(e.target)) {
		document.getElementById('venderDropdown').style.display = 'none';
	}
});

function loadVenderList(keyword) {
	fetch('/searchVender?keyword=' + encodeURIComponent(keyword))
		.then(res => res.json())
		.then(data => renderVenderTable(data))
		.catch(err => console.error("거래처 검색 오류:", err));
}

function renderVenderTable(list) {
	const tbody = document.getElementById('venderList');
	if (!list || list.length === 0) {
		tbody.innerHTML = '<tr><td colspan="3" class="vender-list-empty">검색 결과가 없습니다.</td></tr>';
		return;
	}
	let html = '';
	list.forEach(function(v) {
		const num  = v.vender_num  || '';
		const name = v.vender_name || '';
		const type = v.vender_type || '';
		const emp  = v.ven_ename   || v.ename || '';
		html += '<tr class="vender-list-row"'
			+ ' onclick="selectVender(' + num + ',\'' + name.replace(/'/g, "\\'") + '\')">'
			+ '<td class="vender-list-cell">' + name + '</td>'
			+ '<td class="vender-list-cell-muted">' + type + '</td>'
			+ '<td class="vender-list-cell-muted">' + emp  + '</td>'
			+ '</tr>';
	});
	tbody.innerHTML = html;
}

function selectVender(num, name) {
	document.getElementById('selectedVenderSeq').value  = num;
	document.getElementById('venderSearch').value       = name;
	document.getElementById('venderDropdown').style.display = 'none';
}

/* ── 등록 버튼 ── */
var btnInsert = document.getElementById('btnInsert');
if (btnInsert) {
	btnInsert.addEventListener('click', () => {
		const venderSeq   = document.getElementById('selectedVenderSeq').value;
		const itemNum     = document.getElementById('itemSelect').value;
		const requestDate = document.getElementById('requestDate').value;
		const dueDate     = document.getElementById('dueDate').value;
		const requestQty  = document.getElementById('requestQty').value;

		if (!venderSeq)   { alert('거래처를 선택해주세요.'); return; }
		if (!itemNum)     { alert('품목을 선택해주세요.');   return; }
		if (!requestDate) { alert('주문일을 입력해주세요.'); return; }
		if (!dueDate)     { alert('납기일을 입력해주세요.'); return; }
		if (!requestQty || requestQty < 1) { alert('수량을 입력해주세요.'); return; }

		document.getElementById('insert-form').submit();
	});
}
