/*
 * shipmentDetail.js — 출하 상세 화면 스크립트
 *   1. 진행률 게이지 렌더링
 *   2. LOT 출하 라벨 보기 / 인쇄 기능
 *
 *   서버값은 인라인 스크립트가 아니라 DOM data-* 에서 읽는다.
 *     #shipmentMeta data-*           — 계획/완료수량 + 출하 기본정보(SHIPMENT_DATA)
 *     .btn-label   data-*            — LOT별 라벨 데이터
 */

/* ── 출하 기본정보(SHIPMENT_DATA): #shipmentMeta data-* 에서 구성 ── */
function getShipmentData() {
    var m = document.getElementById('shipmentMeta');
    if (!m) return {};
    return {
        shipmentId:   m.dataset.shipmentId   || '',
        venderName:   m.dataset.venderName   || '',
        requestId:    m.dataset.requestId    || '',
        dueDate:      m.dataset.dueDate      || '',
        shipmentDate: m.dataset.shipmentDate || ''
    };
}

/* ── LOT 한 건 data-* → 라벨 데이터 객체 ── */
function lotFromBtn(btn) {
    return {
        lotCode:    btn.dataset.lotCode  || '',
        itemName:   btn.dataset.itemName || '',
        qty:        btn.dataset.qty      || '',
        lotDate:    btn.dataset.lotDate  || '',
        expiryDate: btn.dataset.expiry   || ''
    };
}

/* 현재 모달에 표시 중인 LOT (단일 PDF 저장용) */
var CURRENT_LABEL_LOT = null;

/* ══ 1. 진행률 게이지 (너비는 CSS 변수 --pct 로 주입) ══ */
function renderProgress() {
    var m = document.getElementById('shipmentMeta');
    if (!m) return;
    var plan     = parseInt(m.dataset.planQty, 10)     || 0;
    var complete = parseInt(m.dataset.completeQty, 10)  || 0;
    var pct  = plan > 0 ? Math.min(100, Math.round(complete / plan * 100)) : 0;
    var bar  = document.getElementById('progressBar');
    var text = document.getElementById('progressText');
    if (bar)  bar.style.setProperty('--pct', pct + '%');
    if (text) text.textContent = pct + '%';
}

/* ══ 2. 라벨 기능 ══ */

/**
 * 라벨 카드 HTML 생성
 * @param {Object} lot       - LOT 데이터 (lotCode, itemName, qty, expiryDate)
 * @param {Object} shipment  - 출하 데이터 (shipmentId, venderName, requestId, dueDate)
 * @param {string} qrDivId   - QR 코드를 렌더링할 div의 id
 */
function buildLabelHTML(lot, shipment, qrDivId) {
    var expiry = lot.expiryDate || '-';
    return ''
        + '<div class="label-header">ZmartFarm 출하 라벨</div>'
        + '<div class="label-body">'
        +   '<table class="label-table">'
        +     '<tr><td>LOT 번호</td><td>' + escHtml(lot.lotCode)      + '</td></tr>'
        +     '<tr><td>품목명</td><td>'   + escHtml(lot.itemName)     + '</td></tr>'
        +     '<tr><td>수량</td><td>'     + escHtml(String(lot.qty))  + ' EA</td></tr>'
        +     '<tr><td>유통기한</td><td>' + escHtml(expiry)           + '</td></tr>'
        +     '<tr><td class="label-divider" colspan="2"></td></tr>'
        +     '<tr><td class="label-section" colspan="2">출하 정보</td></tr>'
        +     '<tr><td>출하코드</td><td>' + escHtml(shipment.shipmentId)  + '</td></tr>'
        +     '<tr><td>거래처</td><td>'   + escHtml(shipment.venderName)  + '</td></tr>'
        +     '<tr><td>주문번호</td><td>' + escHtml(shipment.requestId)   + '</td></tr>'
        +     '<tr><td>납기일</td><td>'   + escHtml(shipment.dueDate)     + '</td></tr>'
        +   '</table>'
        +   '<div class="label-qr" id="' + qrDivId + '"></div>'
        + '</div>';
}

/** HTML 특수문자 이스케이프 (XSS 방지) */
function escHtml(str) {
    return String(str || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

/** QR 코드 생성 (qrcode.js 사용) */
function generateQR(elementId, lotCode, size) {
    var el = document.getElementById(elementId);
    if (!el) return;
    try {
        new QRCode(el, {
            text:   'http://localhost:8080/lot/' + lotCode,
            width:  size || 120,
            height: size || 120,
            correctLevel: QRCode.CorrectLevel.M
        });
    } catch (e) {
        el.textContent = '[QR 오류]';
    }
}

/* ── LOT 한 건 라벨 모달 표시 ── */
function showLabel(lot) {
    if (!lot || !lot.lotCode) {
        alert('라벨 데이터를 찾을 수 없습니다.');
        return;
    }
    CURRENT_LABEL_LOT = lot;
    var qrId = 'qr-modal-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');

    var preview = document.getElementById('labelPreview');
    preview.innerHTML = buildLabelHTML(lot, getShipmentData(), qrId);

    // QR 코드 렌더링 (DOM 추가 직후 바로 실행)
    generateQR(qrId, lot.lotCode, 120);

    document.getElementById('labelModal').classList.add('is-open');
}

/* ── 단일 라벨 PDF 다운로드 ── */
function downloadSingleLabel() {
    var preview = document.getElementById('labelPreview');
    if (!preview || !preview.innerHTML) return;

    var currentLot = CURRENT_LABEL_LOT;

    html2pdf().set({
        margin: 5,
        filename: currentLot ? ('label_' + currentLot.lotCode + '.pdf') : 'label.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { 
            scale: 2, 
            useCORS: true,
            scrollY: 0,          // 스크롤 위치 때문에 상단/하단이 밀리는 현상 방지
            windowScrollY: 0 
        },
        jsPDF: { unit: 'mm', format: 'a6', orientation: 'portrait' }
    }).from(preview).save();
}

/* ── 전체 라벨 PDF 다운로드 ── */
function downloadAllLabels() {
    var lots = [].slice.call(document.querySelectorAll('.btn-label')).map(lotFromBtn);
    if (lots.length === 0) {
        alert('배정된 LOT가 없어 다운로드할 라벨이 없습니다.');
        return;
    }

    var shipment = getShipmentData();
    var area = document.getElementById('printLabelArea');
    var grid = document.getElementById('printLabelGrid');
    var html = '';

    lots.forEach(function(lot, idx) {
        var qrId = 'qr-dl-' + idx + '-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');
        html += '<div class="label-print-card">' + buildLabelHTML(lot, shipment, qrId) + '</div>';
    });

    grid.innerHTML = html;

    // 캡처 중에만 화면 밖으로 표시 (.capturing 클래스로 제어 — 인라인 style 금지)
    area.classList.add('capturing');

    lots.forEach(function(lot, idx) {
        var qrId = 'qr-dl-' + idx + '-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');
        generateQR(qrId, lot.lotCode, 100);
    });

    // LOT 개수가 많을 경우를 대비해 대기 시간을 800ms 정도로 여유롭게 조절
    setTimeout(function() {
        html2pdf().set({
            margin: 5,
            filename: 'labels_' + shipment.shipmentId + '.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: {
                scale: 2,
                useCORS: true,
                scrollY: 0,
                windowScrollY: 0
            },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        }).from(grid).save().then(function() {
            area.classList.remove('capturing');
            grid.innerHTML = '';
        });
    }, 800); // 400ms -> 800ms로 상향
}

/* ── 라벨 모달 닫기 ── */
function closeLabelModal() {
    document.getElementById('labelModal').classList.remove('is-open');
    document.getElementById('labelPreview').innerHTML = '';
    CURRENT_LABEL_LOT = null;
}

/* ── 진행률/라벨 기능 이벤트 연결 (인라인 onclick 대체) ── */
(function initLabelFeature() {
    renderProgress();

    // LOT별 "라벨 보기" — 버튼 data-* 에서 LOT 구성
    document.querySelectorAll('.btn-label').forEach(function(btn) {
        btn.addEventListener('click', function() { showLabel(lotFromBtn(btn)); });
    });

    var btnAll = document.getElementById('btnDownloadAll');
    if (btnAll) btnAll.addEventListener('click', downloadAllLabels);

    var btnDl = document.getElementById('btnLabelDownload');
    if (btnDl) btnDl.addEventListener('click', downloadSingleLabel);

    var btnClose = document.getElementById('btnLabelClose');
    if (btnClose) btnClose.addEventListener('click', closeLabelModal);

    var modal = document.getElementById('labelModal');
    if (modal) modal.addEventListener('click', function(e) {
        if (e.target === this) closeLabelModal();   // 외부 클릭 시 닫기
    });

    // 출하 취소 폼 — 제출 전 확인 (인라인 onclick 대체)
    var cancelForm = document.getElementById('cancelShipmentForm');
    if (cancelForm) cancelForm.addEventListener('submit', function(e) {
        if (!confirm('출하를 취소하시겠습니까?')) e.preventDefault();
    });
})();

/* ══════════════════════════════════════════════════════════════
 * 3. 출하 LOT 수동 선택/확정 (출하대기 + 권한 있을 때만)
 *   - 후보 LOT(FIFO)을 AJAX로 불러와 출하수량 입력
 *   - 등록완료 시 plan_qty 충족 여부 확인 → 미달이면 경고 후 부분출하
 * ════════════════════════════════════════════════════════════ */

function _esc(s) {
    return String(s == null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

/* 선택 박스(출하대기+권한일 때만 렌더)와 그 data-* 값 */
function _selBox()  { return document.getElementById('lotSelectBox'); }
function _shipId()  { var b = _selBox(); return b ? b.getAttribute('data-shipment-id') : ''; }
function _planQty() { var b = _selBox(); return b ? (parseInt(b.getAttribute('data-plan-qty'), 10) || 0) : 0; }

/* 후보 LOT 목록 로드 → 테이블 렌더 */
function loadCandidateLots() {
    var body = document.getElementById('candBody');
    if (!body) return;
    fetch('/shipmentCandidateLots?shipmentId=' + encodeURIComponent(_shipId()))
        .then(function(r) { return r.json(); })
        .then(function(list) {
            if (!list || list.length === 0) {
                body.innerHTML = '<tr><td colspan="5" class="empty-cell">출하 가능한 후보 LOT이 없습니다.</td></tr>';
                return;
            }
            var html = '';
            list.forEach(function(lot) {
                var cur = lot.current_qty;
                html += '<tr>'
                    + '<td>' + _esc(lot.lot_code) + '</td>'
                    + '<td>' + _esc(lot.lot_date) + '</td>'
                    + '<td>' + _esc(lot.expiry_date || '-') + '</td>'
                    + '<td>' + cur + '</td>'
                    + '<td><input type="number" min="0" max="' + cur + '" value="0" '
                    +        'class="qty-input" data-lot="' + lot.lot_num + '" data-cur="' + cur + '"></td>'
                    + '</tr>';
            });
            body.innerHTML = html;
            recalcTotal();
        })
        .catch(function() {
            body.innerHTML = '<tr><td colspan="5" class="empty-cell">후보 LOT 조회 중 오류가 발생했습니다.</td></tr>';
        });
}

/* 입력 합계 재계산 + 안내 메시지 */
function recalcTotal() {
    var inputs = document.querySelectorAll('.qty-input');
    var total = 0;
    var hint = '';
    inputs.forEach(function(inp) {
        var v   = parseInt(inp.value, 10) || 0;
        var cur = parseInt(inp.getAttribute('data-cur'), 10) || 0;
        if (v < 0) { v = 0; inp.value = 0; }
        if (v > cur) { hint = '보유수량을 초과한 입력이 있습니다.'; } // 분할은 보유 이하만 가능
        total += v;
    });
    var totalEl = document.getElementById('selTotal');
    if (totalEl) totalEl.textContent = total;

    // 계획 대비 남은(부족) 수량 안내 — 100% 채우려면 몇 개 더 필요한지
    var plan   = _planQty();
    var remain = plan - total;              // 양수=부족, 0=충족, 음수=초과
    var remainEl = document.getElementById('selRemain');
    if (remainEl) {
        remainEl.classList.remove('txt-danger', 'txt-success');
        if (remain > 0) {
            remainEl.textContent = '계획까지 ' + remain + '개 더 필요';
            remainEl.classList.add('txt-danger');
        } else if (remain === 0) {
            remainEl.textContent = '계획 수량 충족 (100%)';
            remainEl.classList.add('txt-success');
        } else {
            remainEl.textContent = '계획 초과 ' + (-remain) + '개';
            remainEl.classList.add('txt-danger');
        }
    }

    if (!hint && total > plan) hint = '계획 수량을 초과했습니다.';
    var hintEl = document.getElementById('selHint');
    if (hintEl) hintEl.textContent = hint ? ('  ⚠ ' + hint) : '';
    return total;
}

/* 등록완료 — 충족 검사 → (미달 시 경고) → AJAX 확정 */
function submitConfirm() {
    var inputs = document.querySelectorAll('.qty-input');
    var plan = _planQty();
    var selections = [];
    var total = 0;
    var over  = false;
    inputs.forEach(function(inp) {
        var qty = parseInt(inp.value, 10) || 0;
        var cur = parseInt(inp.getAttribute('data-cur'), 10) || 0;
        if (qty > cur) over = true;
        if (qty > 0) {
            selections.push({ lot_num: parseInt(inp.getAttribute('data-lot'), 10), qty: qty });
            total += qty;
        }
    });

    if (selections.length === 0) { alert('출하할 LOT 수량을 입력하세요.'); return; }
    if (over)          { alert('보유수량을 초과한 LOT이 있습니다. 분할은 보유수량 이하만 가능합니다.'); return; }
    if (total > plan)  { alert('선택 합계가 계획 수량(' + plan + ')을 초과했습니다.'); return; }

    var force = false;
    if (total < plan) {
        if (!confirm('지정 수량(' + plan + ')을 다 채우지 못했습니다. 이대로 출하완료하시겠습니까?')) return;
        force = true;
    }

    fetch('/confirmShipment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ shipmentId: _shipId(), force: force, selections: selections })
    })
    .then(function(r) { return r.json(); })
    .then(function(res) {
        if (res.status === 'ok') {
            alert('출하완료 처리되었습니다.');
            location.reload();
        } else {
            alert('출하확정 실패: ' + _confirmReason(res.reason));
        }
    })
    .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/* 서버 reason 코드 → 사용자 메시지 */
function _confirmReason(code) {
    switch (code) {
        case 'empty_selection': return '선택된 LOT이 없습니다.';
        case 'invalid_qty':     return '수량 입력이 올바르지 않습니다.';
        case 'over_plan':       return '계획 수량을 초과했습니다.';
        case 'under_plan':      return '계획 수량 미달(부분출하 미승인).';
        case 'stock_error':     return '보유 재고가 부족합니다.';
        case 'forbidden':       return '권한이 없습니다.';
        case 'not_found':       return '출하 정보를 찾을 수 없습니다.';
        case 'login':           return '로그인이 필요합니다.';
        default:                return code || '알 수 없는 오류';
    }
}

/* 초기화 — #lotSelectBox는 출하대기+권한일 때만 렌더되므로, 존재할 때만 동작 연결 */
(function initLotSelect() {
    var box = _selBox();
    if (!box) return;                 // 선택 UI 없음(완료/취소/권한없음) → 아무것도 안 함
    loadCandidateLots();
    var body = document.getElementById('candBody');
    if (body) {
        body.addEventListener('input', function (e) {   // 동적 행 → 이벤트 위임
            if (e.target && e.target.classList.contains('qty-input')) recalcTotal();
        });
    }
    var btn = document.getElementById('btnConfirm');
    if (btn) btn.addEventListener('click', submitConfirm);
})();
