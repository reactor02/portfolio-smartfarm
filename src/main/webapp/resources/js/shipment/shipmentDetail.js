/*
 * shipmentDetail.js — 출하 상세 화면 스크립트
 *   1. 진행률 게이지 렌더링
 *   2. LOT 출하 라벨 보기 / 인쇄 기능
 *
 *   전역변수 (JSP가 주입):
 *     PLAN_QTY, COMPLETE_QTY — 진행률용
 *     SHIPMENT_DATA           — 출하 기본 정보 객체
 *     LOT_DATA                — LOT 배열
 */

/* ══ 1. 진행률 게이지 ══ */
(function() {
    var pct  = PLAN_QTY > 0 ? Math.min(100, Math.round(COMPLETE_QTY / PLAN_QTY * 100)) : 0;
    var bar  = document.getElementById('progressBar');
    var text = document.getElementById('progressText');
    if (bar)  bar.style.width  = pct + '%';
    if (text) text.textContent = pct + '%';
})();

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
function showLabel(idx) {
    if (!LOT_DATA || LOT_DATA.length === 0 || idx < 0 || idx >= LOT_DATA.length) {
        alert('라벨 데이터를 찾을 수 없습니다.');
        return;
    }
    var lot = LOT_DATA[idx];
    var qrId = 'qr-modal-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');

    var preview = document.getElementById('labelPreview');
    preview.innerHTML = buildLabelHTML(lot, SHIPMENT_DATA, qrId);

    // QR 코드 렌더링 (DOM 추가 직후 바로 실행)
    generateQR(qrId, lot.lotCode, 120);

    document.getElementById('labelModal').style.display = 'flex';
}

/* ── 단일 라벨 PDF 다운로드 ── */
function downloadSingleLabel() {
    var preview = document.getElementById('labelPreview');
    if (!preview || !preview.innerHTML) return;

    var currentLot = null;
    LOT_DATA.forEach(function(lot) {
        var qrId = 'qr-modal-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');
        if (document.getElementById(qrId)) currentLot = lot;
    });

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
    if (!LOT_DATA || LOT_DATA.length === 0) {
        alert('배정된 LOT가 없어 다운로드할 라벨이 없습니다.');
        return;
    }

    var area = document.getElementById('printLabelArea');
    var grid = document.getElementById('printLabelGrid');
    var html = '';

    LOT_DATA.forEach(function(lot, idx) {
        var qrId = 'qr-dl-' + idx + '-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');
        html += '<div class="label-print-card">' + buildLabelHTML(lot, SHIPMENT_DATA, qrId) + '</div>';
    });

    grid.innerHTML = html;

    // display: block 상태에서 브라우저가 높이를 온전히 계산할 수 있도록 설정
    // left: 0, top: 0으로 하되 z-index와 투명도로 숨기는 것이 html2canvas 캡처에 더 안전합니다.
    area.style.cssText = 'display:block; position:fixed; left:0; top:0; z-index:-9999; opacity:0; width:100%;';

    LOT_DATA.forEach(function(lot, idx) {
        var qrId = 'qr-dl-' + idx + '-' + lot.lotCode.replace(/[^a-zA-Z0-9]/g, '_');
        generateQR(qrId, lot.lotCode, 100);
    });

    // LOT 개수가 많을 경우를 대비해 대기 시간을 800ms 정도로 여유롭게 조절
    setTimeout(function() {
        html2pdf().set({
            margin: 5,
            filename: 'labels_' + SHIPMENT_DATA.shipmentId + '.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { 
                scale: 2, 
                useCORS: true,
                scrollY: 0,
                windowScrollY: 0
            },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        }).from(grid).save().then(function() {
            area.style.cssText = '';
            grid.innerHTML = '';
        });
    }, 800); // 400ms -> 800ms로 상향
}

/* ── 라벨 모달 닫기 ── */
function closeLabelModal() {
    document.getElementById('labelModal').style.display = 'none';
    document.getElementById('labelPreview').innerHTML   = '';
}

/* ── 모달 외부 클릭 시 닫기 ── */
document.getElementById('labelModal').addEventListener('click', function(e) {
    if (e.target === this) closeLabelModal();
});
