/*
 * lot.js — LOT 목록 화면 스크립트
 *   - 페이지 이동(폼 제출 방식 페이징)
 *   - 품목 타입 선택에 따른 품목 드롭다운 동적 필터링
 */

/** 페이지 번호를 hidden input에 넣고 검색 폼을 제출해 해당 페이지로 이동 */
function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}

/**
 * 선택한 품목 타입(lotItemType)에 맞는 품목만 드롭다운에 보이도록 토글한다.
 * 타입 변경 시 선택값을 '0'(전체)로 초기화하고, 각 옵션의 data-type과 비교해 표시/숨김.
 */
function filterLotItems() {
    var type = document.getElementById('lotItemType').value;
    var sel  = document.getElementById('lotItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;   // '전체' 옵션은 항상 표시
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

// 최초 로딩 시 현재 선택된 타입 기준으로 필터를 한 번 적용
document.addEventListener('DOMContentLoaded', function() {
    filterLotItems();
});
