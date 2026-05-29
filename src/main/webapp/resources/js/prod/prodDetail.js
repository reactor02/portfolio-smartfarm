/*
 * prodDetail.js — 생산계획 상세 화면 스크립트
 *   진행률 게이지, 연관 작업지시 목록 AJAX 조회/페이징, 계획 취소.
 *   PLAN_QTY/CURRENT_QTY/PLAN_ID 전역값은 JSP가 주입한다.
 */

/** 작업 상태 문자열 → CSS 배지 클래스 매핑 */
function getBadgeClass(status) {
    if (status === '대기') return 'badge-wait';
    if (status === '진행') return 'badge-progress';
    if (status === '완료') return 'badge-done';
    if (status === '취소') return 'badge-cancel';
    return '';
}

// 로딩 시 진행률 바 채우고 작업지시 목록 1페이지 조회
window.onload = function () {
    var pct = PLAN_QTY > 0 ? Math.min((CURRENT_QTY / PLAN_QTY) * 100, 100) : 0;   // 0 나눗셈 방지
    document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
    document.getElementById('progressText').innerText  = pct.toFixed(1) + '%';
    loadWorkOrders(1);
};

/** 이 생산계획에 연관된 작업지시 목록을 AJAX로 조회해 테이블/페이징 렌더링 */
function loadWorkOrders(page) {
    fetch('/prod/' + PLAN_ID + '/work-orders?page=' + page)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var list       = data.list        || [];
            var totalPages = data.totalPages  || 0;
            var curPage    = data.currentPage || 1;

            var tbody = document.getElementById('workOrderTbody');
            if (list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" style="padding:20px;color:#aaa;">등록된 작업지시가 없습니다.</td></tr>';
            } else {
                var html = '';
                for (var i = 0; i < list.length; i++) {
                    var w = list[i];
                    html += '<tr>'
                          + '<td>' + ((curPage - 1) * 5 + i + 1) + '</td>'
                          + '<td><a href="/work/' + (w.work_order_id || '') + '" class="link-text">' + (w.work_order_id || '-') + '</a></td>'
                          + '<td>' + (w.ename       || '-') + '</td>'
                          + '<td>' + (w.order_qty   || 0)   + '</td>'
                          + '<td>' + (w.current_qty || 0)   + '</td>'
                          + '<td>' + (w.order_start ? w.order_start.substring(0, 10) : '-') + '</td>'
                          + '<td>' + (w.order_end   ? w.order_end.substring(0, 10)   : '-') + '</td>'
                          + '<td><span class="badge ' + getBadgeClass(w.work_status) + '">' + (w.work_status || '-') + '</span></td>'
                          + '</tr>';
                }
                tbody.innerHTML = html;
            }

            var pagingDiv = document.getElementById('workOrderPaging');
            if (totalPages <= 1) { pagingDiv.innerHTML = ''; return; }
            var ph = '';
            if (curPage > 1) ph += '<a onclick="loadWorkOrders(' + (curPage - 1) + ')">이전</a>';
            for (var p = 1; p <= totalPages; p++) {
                ph += '<a class="' + (p === curPage ? 'current' : '') + '" onclick="loadWorkOrders(' + p + ')">' + p + '</a>';
            }
            if (curPage < totalPages) ph += '<a onclick="loadWorkOrders(' + (curPage + 1) + ')">다음</a>';
            pagingDiv.innerHTML = ph;
        })
        .catch(function() {
            document.getElementById('workOrderTbody').innerHTML =
                '<tr><td colspan="8" style="padding:20px;color:#aaa;">데이터를 불러올 수 없습니다.</td></tr>';
        });
}

/** 생산계획 취소 처리 */
function cancelPlan() {
    if (!confirm('해당 생산계획을 취소하시겠습니까?')) return;
    fetch('/prod/' + PLAN_ID + '/cancel', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function() { location.reload(); })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}
