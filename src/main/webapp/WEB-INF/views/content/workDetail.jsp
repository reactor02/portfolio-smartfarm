<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업지시 상세</title>
<style>
    :root {
        --m-cl: #2D6A4F;
        --s-cl: #49A47A;
        --p-cl: #B7E4C7;
        --bg: #F8F9FA;
        --txt: #333;
        --warning-cl: #FFB703;
        --danger-cl: #E63946;
        --border-cl: #E9ECEF;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; color: var(--txt); background-color: var(--bg); }
    .mat-all { display: flex; flex-direction: column; min-height: 100vh; }
    .hdr { display: flex; justify-content: space-between; align-items: center; background-color: var(--m-cl); color: #FFF; padding: 0 20px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .hdr-logo-area { display: flex; align-items: center; text-decoration: none; color: #FFF; }
    .hdr-logo-img { height: 40px; width: auto; margin-right: 10px; }
    .hdr-logo-txt { font-size: 1.4rem; font-weight: bold; letter-spacing: -1px; }
    .hdr-user { font-size: 0.9rem; }
    .hdr-user a { color: var(--p-cl); text-decoration: none; margin-left: 10px; }
    .wrap { display: flex; flex: 1; }
    .side { width: 240px; background-color: #FFF; border-right: 1px solid #DDD; }
    .nav-list { list-style: none; }
    .nav-item { border-bottom: 1px solid #EEE; }
    .nav-btn { display: block; padding: 1rem 1.5rem; cursor: pointer; font-weight: bold; color: var(--m-cl); transition: background 0.3s; text-decoration: none; user-select: none; }
    .nav-btn:hover { background-color: var(--p-cl); }
    .sub-nav { list-style: none; display: none; background-color: #F9FDFB; }
    .sub-nav.on { display: block; }
    .sub-nav a { display: block; padding: 0.7rem 1.5rem 0.7rem 2.5rem; font-size: 0.9rem; color: #555; text-decoration: none; }
    .sub-nav a:hover { color: var(--m-cl); font-weight: bold; text-decoration: underline; text-underline-offset: 4px; }
    .cont { flex: 1; padding: 2rem; background-color: #FFF; }
    .ftr { text-align: center; padding: 1rem 0; background-color: #EEE; font-size: 0.8rem; color: #777; margin-top: auto; }

    .page-header { display: flex; flex-direction: column; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid var(--m-cl); }
    .page-title { font-size: 1.5rem; font-weight: bold; color: var(--txt); }
    .btn-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem; }

    .btn-row button { padding: 8px 18px; border-radius: 6px; border: 1px solid var(--border-cl); background: #FFF; cursor: pointer; font-weight: bold; font-size: 13px; transition: background 0.2s; }
    .btn-row .btn-back { background-color: var(--m-cl); color: #FFF; border: none; }
    .btn-row .btn-back:hover { background-color: var(--s-cl); }
    .btn-row .btn-reg  { background-color: var(--s-cl); color: #FFF; border: none; }
    .btn-row .btn-reg:hover  { background-color: var(--m-cl); }
    .btn-row .btn-cancel { background-color: #DC3545; color: #FFF; border: none; }
    .btn-row .btn-cancel:active { background-color: #C82333; }
    .btn-row .btn-start    { background-color: var(--m-cl); color: #FFF; border: none; }
    .btn-row .btn-start:hover { background-color: var(--s-cl); }
    .btn-row .btn-complete { background-color: var(--warning-cl); color: #333; border: none; }
    .btn-row .btn-complete:hover { filter: brightness(0.92); }
    .btn-row .btn-cancel { background-color: #DC3545; color: #FFF; border: none; }
    .btn-row .btn-cancel:active { background-color: #C82333; }

    .section-title { font-size: 1.1rem; font-weight: bold; margin: 2rem 0 1rem 0; color: var(--m-cl); }

    .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; background-color: var(--bg); padding: 20px; border: 1px solid var(--border-cl); border-radius: 8px; }
    .info-item { display: flex; flex-direction: column; gap: 6px; }
    .info-label { font-size: 12px; color: #777; font-weight: bold; }
    .info-value { font-size: 14px; font-weight: bold; }
    .badge { background-color: var(--p-cl); color: var(--m-cl); padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; width: fit-content; }
    .badge-wait     { background: #E9ECEF; color: #6C757D; }
    .badge-progress { background: #FFF3CD; color: #856404; }
    .badge-done     { background: #D1E7DD; color: #0A3622; }
    .badge-cancel   { background: #F8D7DA; color: #842029; }

    .status-grid { display: grid; gap: 15px; margin-bottom: 1.5rem; text-align: center; }
    .status-card { background-color: #FFF; border: 1px solid var(--border-cl); padding: 16px; border-radius: 8px; }
    .status-num { font-size: 1.3rem; font-weight: bold; margin-top: 6px; }

    .progress-box { background-color: var(--bg); border: 1px solid var(--border-cl); padding: 20px; border-radius: 8px; }
    .progress-bar-bg { background-color: #E9ECEF; height: 12px; border-radius: 6px; overflow: hidden; margin-top: 8px; }
    .progress-bar-fill { background-color: var(--s-cl); height: 100%; width: 0%; transition: width 0.3s ease; }
    .progress-text { display: flex; justify-content: flex-end; font-size: 13px; font-weight: bold; color: var(--s-cl); margin-top: 6px; }

    .data-table { width: 100%; border-collapse: collapse; margin-top: 0.5rem; }
    .data-table th { background-color: var(--bg); border-bottom: 2px solid var(--s-cl); color: var(--txt); font-weight: bold; padding: 12px; text-align: center; font-size: 13px; }
    .data-table td { padding: 12px; border-bottom: 1px solid var(--border-cl); text-align: center; color: #555; }
    .data-table tbody tr:hover { background-color: rgba(183, 228, 199, 0.15); }

    .link-text { color: var(--s-cl); font-weight: bold; text-decoration: none; }
    .link-text:hover { text-decoration: underline; }
    .instruction-box { background-color: var(--bg); padding: 18px; border-left: 4px solid var(--s-cl); margin-top: 15px; border-top: 1px solid var(--border-cl); border-right: 1px solid var(--border-cl); border-bottom: 1px solid var(--border-cl); border-radius: 0 8px 8px 0; }

    .section-box { border: 1px solid var(--border-cl); border-radius: 8px; padding: 20px; background-color: #FFF; }
    .section-box .section-title { margin-top: 0; }
</style>
</head>
<body>

    <main class="cont">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <div class="btn-row">
                <button class="btn-back" onclick="location.href='/work'">목록으로</button>
                <div>
                    <c:if test="${workDTO.work_status == '대기'}">
                        <button class="btn-start" onclick="startWork()">작업시작</button>
                    </c:if>
                    <c:if test="${workDTO.work_status == '진행'}">
                        <button class="btn-complete" onclick="completeWork()">작업종료</button>
                        <button class="btn-reg" style="margin-left:6px;" onclick="produceWork()">작업완료</button>
                    </c:if>
                    <c:if test="${workDTO.work_status != '완료' and workDTO.work_status != '취소'}">
                        <button class="btn-cancel" style="margin-left:6px;" onclick="cancelWork()">취소</button>
                    </c:if>
                </div>
            </div>
            <h1 class="page-title">작업지시 상세</h1>
        </div>

        <!-- 1. 기본 정보 -->
        <div class="section-title">■ 기본 정보</div>
        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">작업번호</span>
                <span class="info-value">${workDTO.work_order_id}</span>
            </div>
            <div class="info-item">
                <span class="info-label">상태</span>
                <span class="badge <c:choose><c:when test="${workDTO.work_status == '대기'}">badge-wait</c:when><c:when test="${workDTO.work_status == '진행'}">badge-progress</c:when><c:when test="${workDTO.work_status == '완료'}">badge-done</c:when><c:when test="${workDTO.work_status == '취소'}">badge-cancel</c:when></c:choose>">${workDTO.work_status}</span>
            </div>
            <div class="info-item">
                <span class="info-label">작업자</span>
                <span class="info-value">${workDTO.ename}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목명</span>
                <span class="info-value">${workDTO.item_name}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목 코드</span>
                <span class="info-value">${workDTO.code}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목 유형</span>
                <span class="info-value">${workDTO.type}</span>
            </div>
            <div class="info-item">
                <span class="info-label">작업일</span>
                <span class="info-value"><fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/></span>
            </div>
            <div class="info-item">
                <span class="info-label">작업완료</span>
                <span class="info-value"><fmt:formatDate value="${workDTO.order_end}" pattern="yyyy-MM-dd"/></span>
            </div>
            <div class="info-item">
                <span class="info-label">등록일시</span>
                <fmt:timeZone value="Asia/Seoul">
                <span class="info-value"><fmt:formatDate value="${workDTO.created_at}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
                </fmt:timeZone>
            </div>
        </div>

        <!-- 2. 작업 현황 -->
        <div class="section-title">■ 작업 현황</div>
        <div class="status-grid" style="grid-template-columns: repeat(3, 1fr);">
            <div class="status-card">
                <div class="info-label">지시 수량</div>
                <div class="status-num">${workDTO.order_qty}</div>
            </div>
            <div class="status-card">
                <div class="info-label" style="color: var(--s-cl);">생산 완료</div>
                <div class="status-num" style="color: var(--s-cl);">${workDTO.current_qty}</div>
            </div>
            <div class="status-card">
                <div class="info-label">잔여 수량</div>
                <div class="status-num">
                    ${workDTO.order_qty - workDTO.current_qty < 0 ? 0 : workDTO.order_qty - workDTO.current_qty}
                </div>
            </div>
        </div>
        <div class="progress-box">
            <div class="info-label">진행률</div>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" id="progressBar"></div>
            </div>
            <div class="progress-text" id="progressText"></div>
        </div>

        <!-- 3. 생산계획 정보 -->
        <div class="section-title">■ 생산계획정보</div>
        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">계획번호</span>
                <span class="info-value">${workDTO.plan_id}</span>
            </div>
            <div class="info-item">
                <span class="info-label">계획상태</span>
                <span class="badge <c:choose><c:when test="${workDTO.plan_status == '대기'}">badge-wait</c:when><c:when test="${workDTO.plan_status == '진행'}">badge-progress</c:when><c:when test="${workDTO.plan_status == '완료'}">badge-done</c:when><c:when test="${workDTO.plan_status == '취소'}">badge-cancel</c:when></c:choose>">${workDTO.plan_status}</span>
            </div>
            <div class="info-item">
                <span class="info-label">계획수량</span>
                <span class="info-value">${workDTO.plan_qty}</span>
            </div>
            <div class="info-item">
                <span class="info-label">생산시작일</span>
                <span class="info-value"><fmt:formatDate value="${workDTO.plan_start}" pattern="yyyy-MM-dd"/></span>
            </div>
            <div class="info-item">
                <span class="info-label">생산마감일</span>
                <span class="info-value"><fmt:formatDate value="${workDTO.plan_end}" pattern="yyyy-MM-dd"/></span>
            </div>
        </div>

        <!-- 4. 공정 정보 -->
        <div class="section-title">■ 공정 정보</div>
        <div style="margin-bottom: 8px;">
            <span class="info-label">공정 정보 링크:</span>
            <a href="/process/item/${workDTO.item_num}" class="link-text">${workDTO.item_name} 공정관리 링크</a>
        </div>
        <div class="instruction-box">
            <span class="info-label" style="display:block; margin-bottom:6px;">상세 지시사항</span>
            <strong>${workDTO.content}</strong>
        </div>

    </main>

<script>
    var WORK_ORDER_ID = '${workDTO.work_order_id}';
    var ORDER_START   = '<fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/>';

    window.onload = function () {
        var orderQty   = parseInt('${workDTO.order_qty}')   || 0;
        var currentQty = parseInt('${workDTO.current_qty}') || 0;

        if (orderQty <= 0) return;

        var pct = Math.min((currentQty / orderQty) * 100, 100);
        document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
        document.getElementById('progressText').innerText  = pct.toFixed(1) + '%';
    };

    function startWork() {
        var today = new Date();
        var todayStr = today.getFullYear() + '-'
            + String(today.getMonth() + 1).padStart(2, '0') + '-'
            + String(today.getDate()).padStart(2, '0');
        if (todayStr !== ORDER_START) {
            alert('작업일이 아닙니다.\n작업시작일: ' + ORDER_START);
            return;
        }
        if (!confirm('작업을 시작하시겠습니까?')) return;
        fetch('/work/' + WORK_ORDER_ID + '/start', { method: 'POST' })
            .then(function(r) { return r.text(); })
            .then(function(result) {
                if (result === 'date_error') {
                    alert('작업일이 아닙니다.');
                    return;
                }
                if (result === 'error') {
                    alert('처리할 수 없는 작업입니다.');
                    return;
                }
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
        var qty = parseInt('${workDTO.order_qty}') || 0;
        if (!confirm('지시수량(' + qty + ')만큼 생산 완료 처리하시겠습니까?')) return;
        fetch('/work/' + WORK_ORDER_ID + '/produce', { method: 'POST' })
            .then(function(r) { return r.text(); })
            .then(function(result) {
                if (result === 'stock_error') {
                    alert('원재료 재고가 부족합니다.\nBOM 기준 재고를 확인해주세요.');
                    return;
                }
                if (result === 'error') {
                    alert('처리 중 오류가 발생했습니다.');
                    return;
                }
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
</script>

</body>
</html>
