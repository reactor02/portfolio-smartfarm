/*
 * lotDetail.js — LOT 상세 화면 스크립트
 *   탭 전환 + 롯이력 지연 로드 + QR 코드 초기화.
 *   lotCode 전역변수는 JSP가 주입한다.
 */

let lotHistoryLoaded = false;

function switchTab(name, btn) {
    document.querySelectorAll('.tab-btn').forEach(function(b) {
        b.classList.remove('active');
        b.style.background   = '#f5f5f5';
        b.style.color        = '#888';
        b.style.borderBottom = 'none';
    });
    document.querySelectorAll('.tab-panel').forEach(function(p) {
        p.style.display = 'none';
    });
    btn.classList.add('active');
    btn.style.background   = '#fff';
    btn.style.color        = '#000';
    btn.style.borderBottom = '2px solid #fff';
    document.getElementById('tab-' + name).style.display = 'block';

    if (name === 'lothistory' && !lotHistoryLoaded) {
        fetch('/lot/' + lotCode + '/lotHistory')
            .then(function(r) { return r.json(); })
            .then(renderLotHistory)
            .catch(function(err) { console.error('롯이력 로드 오류:', err); });
        lotHistoryLoaded = true;
    }
}

function renderLotHistory(data) {
    var tbody = document.getElementById('lothistory-body');
    if (!data || data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="empty-cell">롯이력이 없습니다.</td></tr>';
        return;
    }
    var html = '';
    data.forEach(function(r) {
        var isShipment = (r.GUBUN === '출하');
        html += '<tr>'
            + '<td>' + (r.DEPTH       != null ? r.DEPTH       : 0)   + '</td>'
            + '<td>' + (r.LOT_CODE    || '-') + '</td>'
            + '<td>' + (r.ITEM_NAME   || '-') + '</td>'
            + '<td>' + (r.ITEM_TYPE   || '-') + '</td>'
            + '<td><span class="history-badge ' + (isShipment ? 'badge-shipment' : 'badge-prod') + '">'
            +      (r.GUBUN || '-') + '</span></td>'
            + '<td>' + (r.ID_COL      || '-') + '</td>'
            + '<td>' + (r.CONTENT_COL || '-') + '</td>'
            + '<td>' + (r.DATE_COL    || '-') + '</td>'
            + '<td>' + (r.STATUS_COL  || '-') + '</td>'
            + '<td>' + (r.WORKER      || '-') + '</td>'
            + '</tr>';
    });
    tbody.innerHTML = html;
}

new QRCode(document.getElementById('qrcode'), 'http://localhost:8080/lot/' + lotCode);
