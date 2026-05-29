/*
 * prod.js — 생산계획 목록 화면 스크립트
 *   품목 타입 필터, 검색 날짜 유효성 검사, 등록 모달 열고/닫기.
 */

/** 품목 타입 선택값에 맞는 품목만 드롭다운에 표시 */
function filterProdItems() {
    var type = document.getElementById('prodItemType').value;
    var sel  = document.getElementById('prodItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

/** 검색 기간 유효성 검사 — 시작일이 종료일보다 이후면 종료일 초기화 */
function validateDate() {
    var start = document.getElementById('startDate').value;
    var end   = document.getElementById('endDate').value;
    if (start && end && start > end) {
        alert('시작 날짜는 종료 날짜보다 이후일 수 없습니다.');
        document.getElementById('endDate').value = '';
    }
}

// 초기화: 품목 필터 1회 적용 + 등록 모달 열기/닫기/바깥클릭 바인딩
document.addEventListener('DOMContentLoaded', function() {
    filterProdItems();

    document.getElementById('btnOpenModal').addEventListener('click', function() {
        document.getElementById('regModal').style.display = 'flex';
    });
    document.getElementById('btnCloseModal').addEventListener('click', function() {
        document.getElementById('regModal').style.display = 'none';
    });
    document.getElementById('regModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
});
