/*
 * lotDetail.js — LOT 상세 화면 스크립트
 *   탭 전환 + 공정이력 지연 로드 + QR 코드 초기화.
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
            .catch(function(err) { console.error('공정이력 로드 오류:', err); });
        lotHistoryLoaded = true;
    }
}

function renderLotHistory(data) {
    var tbody = document.getElementById('lothistory-body');
    if (!data || data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="empty-cell">공정이력이 없습니다.</td></tr>';
        return;
    }
    var html = '';
    data.forEach(function(r) {
        // [수정] 쿼리에서 변경된 세분화된 구분값에 따라 CSS 클래스 분기 처리
        var badgeClass = 'badge-prod'; // 기본값 (생산공정 등)
        if (r.GUBUN === '원자재투입') {
            badgeClass = 'badge-material'; // 원자재 전용 디자인 클래스 (css에서 설정 가능)
        } else if (r.GUBUN === '완제품생산') {
            badgeClass = 'badge-prod-complete'; // 완제품 생성 순간 강조 클래스
        } else if (r.GUBUN === '출하완료') {
            badgeClass = 'badge-shipment'; // 출하 완료 클래스
        } else if (r.GUBUN === '입고') {
            badgeClass = 'badge-io-in';
        } else if (r.GUBUN === '생산투입출고') {
            badgeClass = 'badge-io-out';
        }

        // [수정] 완제품생산 행(Row)은 현재 화면의 메인 롯이므로 시각적 강조 효과 부여
        var rowStyle = (r.GUBUN === '완제품생산') ? ' style="background-color: #f0f7ff; font-weight: bold;"' : '';

        html += '<tr' + rowStyle + '>'
            // 1. 단계 (기존 r.DEPTH 대신 1, 2, 3으로 순서대로 떨어지는 r.SEQ_NUM 적용)
            + '<td>' + (r.SEQ_NUM || 1) + '</td>'
            + '<td>' + (r.LOT_CODE    || '-') + '</td>'
            + '<td>' + (r.ITEM_NAME   || '-') + '</td>'
            + '<td>' + (r.ITEM_TYPE   || '-') + '</td>'
            // 2. 구분 (세분화된 한글 명칭과 그에 맞는 배지 클래스 바인딩)
            + '<td><span class="history-badge ' + badgeClass + '">' + (r.GUBUN || '-') + '</span></td>'
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
