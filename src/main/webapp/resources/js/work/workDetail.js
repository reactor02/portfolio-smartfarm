/*
 * workDetail.js — 작업지시 상세 (공정별 라우팅 진행)
 *   작업시작 / 소모자재 투입(공정별) / 공정 시작 / 공정 완료 / 작업완료 / 취소 (AJAX).
 *   설정값(WORK_ORDER_ID/ORDER_START/ORDER_QTY/CURRENT_QTY/INPUT_QTY/MAX_PRODUCIBLE)은
 *   #workDetail 의 data-* 에서 읽는다. (인라인 JS/EL 주입 금지)
 */

var CFG = {};            // #workDetail data-* 에서 로드
var ACTIVE_PROCESS = 0;  // 현재 소모자재 투입 모달 대상 공정

document.addEventListener('DOMContentLoaded', function () {
    var el = document.getElementById('workDetail');
    if (!el) return;
    CFG = {
        workOrderId:   el.dataset.workOrderId,
        orderStart:    el.dataset.orderStart,
        orderQty:      parseInt(el.dataset.orderQty, 10)      || 0,
        currentQty:    parseInt(el.dataset.currentQty, 10)    || 0,
        inputQty:      parseInt(el.dataset.inputQty, 10)      || 0,   // 확정 배치 생산수량(0=미확정)
        maxProducible: parseInt(el.dataset.maxProducible, 10) || 0
    };
    wireEvents();
});

/* 모든 버튼/입력 이벤트 연결 (인라인 onclick/oninput 대체) */
function wireEvents() {
    bindClick('btnStartWork',    startWork);
    bindClick('btnCompleteWork', function () { completeWork(); });
    bindClick('btnCancelWork',   cancelWork);
    bindClick('btnGoList',       function () { location.href = '/work'; });

    bindProcessBtn('btnInputMaterial',   openInputModal);
    bindProcessBtn('btnStartProcess',    startProcess);
    bindProcessBtn('btnCompleteProcess', completeProcess);

    bindClick('btnDateErrClose', closeDateErrModal);
    bindClick('btnSubmitInput',  submitInput);
    bindClick('btnCloseInput',   closeInputModal);

    var qtyInput = document.getElementById('inputQty');
    if (qtyInput) qtyInput.addEventListener('input', loadPreview);
}

function bindClick(id, handler) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('click', handler);
}
/* data-process 값을 인자로 넘기는 공정 제어 버튼 연결 */
function bindProcessBtn(id, handler) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('click', function () {
        handler(parseInt(el.dataset.process, 10));
    });
}

/* ── 작업시작(완제품 LOT 생성) ── */
function showDateErr() {
    document.getElementById('dateErrDate').innerText = CFG.orderStart;
    document.getElementById('dateErrModal').classList.add('is-open');
}
function closeDateErrModal() {
    document.getElementById('dateErrModal').classList.remove('is-open');
}
function startWork() {
    var today = new Date();
    var todayStr = today.getFullYear() + '-'
        + String(today.getMonth() + 1).padStart(2, '0') + '-'
        + String(today.getDate()).padStart(2, '0');
    if (todayStr !== CFG.orderStart) { showDateErr(); return; }
    if (!confirm('작업을 시작하시겠습니까? (완제품 LOT이 생성됩니다)')) return;
    fetch('/work/' + CFG.workOrderId + '/start', { method: 'POST' })
        .then(function(r){ return r.text(); })
        .then(function(result){
            if (result === 'forbidden')    { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'date_error')   { showDateErr(); return; }
            if (result === 'error')        { alert('처리할 수 없는 작업입니다.'); return; }
            location.reload();
        })
        .catch(function(){ alert('처리 중 오류가 발생했습니다.'); });
}

/* ── 소모자재 투입 모달 ── */
function openInputModal(processNum) {
    ACTIVE_PROCESS = processNum;
    document.getElementById('inputMax').innerText = CFG.maxProducible;
    document.getElementById('shortageBox').classList.remove('is-open');
    var input = document.getElementById('inputQty');
    var lockMsg = document.getElementById('inputLockMsg');
    if (CFG.inputQty > 0) {
        // 배치 생산수량은 첫 투입에서 이미 확정됨 → 고정
        input.value = CFG.inputQty;
        input.readOnly = true;
        lockMsg.innerText = '배치 생산수량은 ' + CFG.inputQty + '개로 확정되어 있습니다.';
    } else {
        if (CFG.maxProducible <= 0) { alert('생산 가능한 재고가 없습니다.'); return; }
        input.value = CFG.maxProducible;   // 기본 = 최대 생산 가능 수량
        input.readOnly = false;
        lockMsg.innerText = '';
    }
    loadPreview();
    document.getElementById('inputModal').classList.add('is-open');
}
function closeInputModal() {
    document.getElementById('inputModal').classList.remove('is-open');
}

/** 차감 예정 FIFO LOT 미리보기 */
function loadPreview() {
    var qty = parseInt(document.getElementById('inputQty').value) || 0;
    var body = document.getElementById('previewBody');
    if (qty < 1) { body.innerText = '수량을 입력하세요.'; return; }
    fetch('/work/' + CFG.workOrderId + '/process/' + ACTIVE_PROCESS + '/preview?qty=' + qty)
        .then(function(r){ return r.json(); })
        .then(function(list){
            if (!list || list.length === 0) { body.innerText = '차감할 자재가 없습니다.'; return; }
            var html = '<table class="preview-tbl"><thead><tr><th>자재</th><th>LOT</th><th>차감</th></tr></thead><tbody>';
            list.forEach(function(p){
                html += '<tr><td>' + (p.item_name||'') + '</td><td>' + p.lot_num + '</td><td>' + p.deduct + '</td></tr>';
            });
            html += '</tbody></table>';
            body.innerHTML = html;
        })
        .catch(function(){ body.innerText = '미리보기 조회 실패'; });
}

/** 소모자재 투입 실행 */
function submitInput() {
    var qty = CFG.inputQty > 0 ? CFG.inputQty : (parseInt(document.getElementById('inputQty').value) || 0);
    if (qty < 1) { alert('생산수량은 1 이상이어야 합니다.'); return; }
    fetch('/work/' + CFG.workOrderId + '/process/' + ACTIVE_PROCESS + '/input', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'qty=' + qty
    })
        .then(function(r){ return r.json(); })
        .then(function(res){
            if (res.result === 'ok') { location.reload(); return; }
            if (res.result === 'unauthorized') { location.href = '/login'; return; }
            if (res.result === 'forbidden')   { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (res.result === 'state_error') { alert('지금은 이 공정에 자재를 투입할 수 없습니다.'); location.reload(); return; }
            if (res.result === 'qty_error')   { renderShortage(res); return; }
            alert('처리 중 오류가 발생했습니다.');
        })
        .catch(function(){ alert('처리 중 오류가 발생했습니다.'); });
}

/** 부족 자재·부족분 표시 (입력 > 최대생산량) */
function renderShortage(res) {
    var box = document.getElementById('shortageBox');
    var html = '<b>입력 수량이 최대 생산 가능 수량(' + (res.max != null ? res.max : 0) + ')을 초과합니다.</b>';
    if (res.shortages && res.shortages.length > 0) {
        html += '<table class="preview-tbl"><thead><tr><th>부족 자재</th><th>필요</th><th>현재고</th><th>부족분</th></tr></thead><tbody>';
        res.shortages.forEach(function(s){
            html += '<tr><td>' + (s.name||'') + '</td><td>' + s.need + '</td><td>' + s.available + '</td><td class="mat-short">' + s.shortage + '</td></tr>';
        });
        html += '</tbody></table>';
    }
    html += '<div class="produce-sub">수량을 낮춰서 다시 시도하세요.</div>';
    box.innerHTML = html;
    box.classList.add('is-open');
}

/* ── 공정 시작 / 완료 ── */
function startProcess(processNum) {
    if (!confirm('공정을 시작하시겠습니까?')) return;
    processAction(processNum, 'start');
}
function completeProcess(processNum) {
    if (!confirm('공정을 완료하시겠습니까?')) return;
    processAction(processNum, 'complete');
}
function processAction(processNum, action) {
    fetch('/work/' + CFG.workOrderId + '/process/' + processNum + '/' + action, { method: 'POST' })
        .then(function(r){ return r.text(); })
        .then(function(result){
            if (result === 'ok') { location.reload(); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'forbidden')   { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'state_error') { alert('지금은 처리할 수 없는 단계입니다.'); location.reload(); return; }
            alert('처리 중 오류가 발생했습니다.');
        })
        .catch(function(){ alert('처리 중 오류가 발생했습니다.'); });
}

/* ── 작업완료 ── */
function completeWork(force) {
    fetch('/work/' + CFG.workOrderId + '/complete-work' + (force ? '?force=true' : ''), { method: 'POST' })
        .then(function(r){ return r.text(); })
        .then(function(result){
            if (result === 'ok') { location.reload(); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            if (result === 'forbidden')   { alert('담당자 또는 실무자만 가능합니다.'); return; }
            if (result === 'in_progress') { alert('진행 중인 공정이 있어 완료할 수 없습니다.'); return; }
            if (result === 'not_full') {
                if (confirm('지시수량만큼 생산하지 못했습니다. 그래도 완료합니까?')) completeWork(true);
                return;
            }
            alert('처리 중 오류가 발생했습니다.');
        })
        .catch(function(){ alert('처리 중 오류가 발생했습니다.'); });
}

/* ── 작업지시 취소 ── */
function cancelWork() {
    if (!confirm('작업지시를 취소하시겠습니까? 취소 후에는 변경이 불가합니다.')) return;
    fetch('/work/' + CFG.workOrderId + '/cancel', { method: 'POST' })
        .then(function(r){ return r.text(); })
        .then(function(result){
            if (result === 'forbidden')    { alert('권한이 없습니다.'); return; }
            if (result === 'unauthorized') { location.href = '/login'; return; }
            location.reload();
        })
        .catch(function(){ alert('처리 중 오류가 발생했습니다.'); });
}
