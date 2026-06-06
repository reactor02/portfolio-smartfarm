/*
 * workDetail.js — 작업지시 상세 화면 스크립트
 *   진행률 게이지 렌더링 + 시작/완료/생산/취소 액션(AJAX POST).
 *   ORDER_QTY/CURRENT_QTY/ORDER_START/WORK_ORDER_ID 전역값은 JSP가 주입한다.
 *   서버 응답 문자열(date_error/qty_error/error)에 따라 분기 처리한다.
 */

// 로딩 시 (현재수량/지시수량) 비율로 진행률 바를 채운다(최대 100%)
window.onload = function () {
    if (ORDER_QTY <= 0) return;   // 0 나눗셈 방지
    var pct = Math.min((CURRENT_QTY / ORDER_QTY) * 100, 100);
    document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
    document.getElementById('progressText').innerText  = pct.toFixed(1) + '%';
};

/** 작업시작일이 오늘이 아닐 때 안내 모달 표시 */
function showDateErr() {
    document.getElementById('dateErrDate').innerText = ORDER_START;
    document.getElementById('dateErrModal').style.display = 'flex';
}

function closeDateErrModal() {
    document.getElementById('dateErrModal').style.display = 'none';
}

/** 작업 시작 — 오늘이 작업시작일일 때만 진행(아니면 날짜 오류 모달) */
function startWork() {
    var today    = new Date();
    var todayStr = today.getFullYear() + '-'
        + String(today.getMonth() + 1).padStart(2, '0') + '-'
        + String(today.getDate()).padStart(2, '0');
    if (todayStr !== ORDER_START) {
        showDateErr();
        return;
    }
    if (!confirm('작업을 시작하시겠습니까?')) return;
    fetch('/work/' + WORK_ORDER_ID + '/start', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'date_error')   { showDateErr(); return; }
            if (result === 'error')        { alert('처리할 수 없는 작업입니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/** 작업 완료 처리 */
function completeWork() {
    if (!confirm('작업을 완료하시겠습니까?')) return;
    fetch('/work/' + WORK_ORDER_ID + '/complete', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/** 생산투입 모달 열기 — 수량 입력칸 기본값/상한을 최대 투입 가능 수량으로 설정 */
function openInputModal() {
    if (MAX_INPUT <= 0) {
        alert('투입 가능한 재고가 없습니다.\nBOM 기준 재고를 확인해주세요.');
        return;
    }
    document.getElementById('produceMax').innerText = MAX_INPUT;
    var input = document.getElementById('produceQty');
    input.max   = MAX_INPUT;
    input.value = MAX_INPUT;   // 기본값 = 최대 투입 가능 수량
    document.getElementById('produceModal').style.display = 'flex';
}

function closeProduceModal() {
    document.getElementById('produceModal').style.display = 'none';
}

/** 생산투입(출고) — 입력 수량(1~최대)만큼 서버에서 BOM 자재 FIFO 출고 + order_lot 기록 */
function submitInput() {
    var qty = parseInt(document.getElementById('produceQty').value);
    if (!qty || qty < 1) { alert('투입 수량은 1 이상이어야 합니다.'); return; }
    if (qty > MAX_INPUT) {
        alert('입력 수량이 투입 가능 수량(' + MAX_INPUT + ')을 초과합니다.');
        return;
    }
    fetch('/work/' + WORK_ORDER_ID + '/input', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'qty=' + qty
    })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'qty_error') {
                alert('입력 수량이 투입 가능 수량을 초과합니다.\nBOM 기준 재고를 확인해주세요.');
                return;
            }
            if (result === 'error') { alert('처리 중 오류가 발생했습니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/** 작업완료(생산) — 투입된 미생산 분량만큼 완제품 LOT 생성 (자재 재차감 없음) */
function produceWork() {
    if (PENDING_PRODUCE <= 0) {
        alert('먼저 생산투입을 해주세요.');
        return;
    }
    if (!confirm('투입분 ' + PENDING_PRODUCE + '개를 완제품으로 생산 완료하시겠습니까?')) return;
    fetch('/work/' + WORK_ORDER_ID + '/produce', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'nothing')      { alert('먼저 생산투입을 해주세요.'); return; }
            if (result === 'error')        { alert('처리 중 오류가 발생했습니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/** 투입취소 — 아직 생산되지 않은 남은 투입 자재를 되돌린다 */
function cancelInput() {
    if (!confirm('남은 투입 자재(' + PENDING_PRODUCE + '개분)를 되돌립니다.\n이미 생산된 분량은 환원되지 않습니다.')) return;
    fetch('/work/' + WORK_ORDER_ID + '/input-cancel', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'error')        { alert('처리 중 오류가 발생했습니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/** 작업지시 취소 (취소 후 변경 불가) */
function cancelWork() {
    if (!confirm('작업지시를 취소하시겠습니까? 취소 후에는 변경이 불가합니다.')) return;
    fetch('/work/' + WORK_ORDER_ID + '/cancel', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'forbidden')    { alert('권한이 없습니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}
