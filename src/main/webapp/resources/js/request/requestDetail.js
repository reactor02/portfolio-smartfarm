/*
 * requestDetail.js — 출하요청 상세 화면 스크립트
 *   출하 진행률 게이지 렌더링.
 *   전역변수 (JSP가 주입): REQ_QTY, SHIPPED_QTY
 */
(function() {
    var pct  = REQ_QTY > 0 ? Math.min(100, Math.round(SHIPPED_QTY / REQ_QTY * 100)) : 0;
    var bar  = document.getElementById('progressBar');
    var text = document.getElementById('progressText');
    if (bar)  bar.style.width  = pct + '%';
    if (text) text.textContent = pct + '%';
})();
