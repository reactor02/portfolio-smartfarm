window.onload = function () {
    if (ORDER_QTY <= 0) return;
    var pct = Math.min((CURRENT_QTY / ORDER_QTY) * 100, 100);
    document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
    document.getElementById('progressText').innerText  = pct.toFixed(1) + '%';
};

function showDateErr() {
    document.getElementById('dateErrDate').innerText = ORDER_START;
    document.getElementById('dateErrModal').style.display = 'flex';
}

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
            if (result === 'date_error') { showDateErr(); return; }
            if (result === 'error')      { alert('처리할 수 없는 작업입니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

function completeWork() {
    if (!confirm('작업을 완료하시겠습니까?')) return;
    fetch('/work/' + WORK_ORDER_ID + '/complete', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function() { location.reload(); })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

function produceWork() {
    if (!confirm('지시수량(' + ORDER_QTY + ')만큼 생산 완료 처리하시겠습니까?')) return;
    fetch('/work/' + WORK_ORDER_ID + '/produce', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(result) {
            if (result === 'stock_error') {
                alert('원재료 재고가 부족합니다.\nBOM 기준 재고를 확인해주세요.');
                return;
            }
            if (result === 'error') { alert('처리 중 오류가 발생했습니다.'); return; }
            location.reload();
        })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

function cancelWork() {
    if (!confirm('작업지시를 취소하시겠습니까? 취소 후에는 변경이 불가합니다.')) return;
    fetch('/work/' + WORK_ORDER_ID + '/cancel', { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function() { location.reload(); })
        .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}
