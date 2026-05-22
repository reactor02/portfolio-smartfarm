<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>생산계획 상세</title>
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
    .btn-row .btn-back   { background-color: var(--m-cl); color: #FFF; border: none; }
    .btn-row .btn-back:hover { background-color: var(--s-cl); }
    .btn-row .btn-reg    { background-color: var(--s-cl); color: #FFF; border: none; }
    .btn-row .btn-reg:hover  { background-color: var(--m-cl); }
    .btn-row .btn-cancel { background-color: #DC3545; color: #FFF; border: none; }
    .btn-row .btn-cancel:active { background-color: #C82333; }

    .section-title { font-size: 1.1rem; font-weight: bold; margin: 2rem 0 1rem 0; color: var(--m-cl); }

    .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; background-color: var(--bg); padding: 20px; border: 1px solid var(--border-cl); border-radius: 8px; }
    .info-item { display: flex; flex-direction: column; gap: 6px; }
    .info-label { font-size: 12px; color: #777; font-weight: bold; }
    .info-value { font-size: 14px; font-weight: bold; }
    .badge { background-color: var(--p-cl); color: var(--m-cl); padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; width: fit-content; }

    .status-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 1.5rem; text-align: center; }
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

    /* 페이징 */
    .wo-paging { text-align: center; margin-top: 1rem; }
    .wo-paging a { display: inline-block; padding: 5px 11px; margin: 0 2px; border: 1px solid var(--border-cl); border-radius: 4px; text-decoration: none; color: var(--txt); font-size: 13px; cursor: pointer; }
    .wo-paging a:hover { background: var(--p-cl); }
    .wo-paging .current { background: var(--m-cl); color: #FFF; border-color: var(--m-cl); }

    /* 작업 등록 모달 */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
    .modal-box { background: #FFF; border-radius: 10px; padding: 30px; width: 520px; max-height: 90vh; overflow-y: auto; box-shadow: 0 8px 30px rgba(0,0,0,0.15); }
    .modal-title { font-size: 1.2rem; font-weight: bold; color: var(--m-cl); margin-bottom: 20px; }
    .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .modal-field { display: flex; flex-direction: column; gap: 6px; }
    .modal-field label { font-size: 12px; color: #777; font-weight: bold; }
    .modal-field input, .modal-field select, .modal-field textarea { padding: 8px 10px; border: 1px solid var(--border-cl); border-radius: 6px; font-size: 13px; font-family: inherit; }
    .modal-field-full { grid-column: 1 / -1; }
    .modal-btn-wrap { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
    .modal-btn-wrap button { padding: 9px 22px; border-radius: 6px; border: none; cursor: pointer; font-weight: bold; font-size: 13px; }
    .modal-btn-wrap .btn-submit { background: var(--m-cl); color: #FFF; }
    .modal-btn-wrap .btn-submit:hover { background: var(--s-cl); }
    .modal-btn-wrap .btn-close  { background: #EEE; color: #555; }
</style>
</head>
<body>

    <main class="cont">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <div class="btn-row">
                <button class="btn-back" onclick="location.href='/prod'">목록으로</button>
                <div>
                    <c:if test="${prodDTO.plan_status != '취소' and prodDTO.plan_status != '완료'}">
                        <button class="btn-reg" id="btnOpenWorkModal">작업 등록</button>
                        <button class="btn-cancel" style="margin-left:6px;"
                                onclick="cancelPlan()">취소</button>
                    </c:if>
                </div>
            </div>
            <h1 class="page-title">생산계획 상세</h1>
        </div>

        <!-- 1. 기본 정보 -->
        <div class="section-title">■ 기본 정보</div>
        <div class="info-grid">
            <div class="info-item"><span class="info-label">계획번호</span><span class="info-value">${prodDTO.plan_id}</span></div>
            <div class="info-item"><span class="info-label">상태</span><span class="badge">${prodDTO.plan_status}</span></div>
            <div class="info-item"><span class="info-label">담당자</span><span class="info-value">${prodDTO.ename}</span></div>
            <div class="info-item"><span class="info-label">품목명</span><span class="info-value">${prodDTO.item_name}</span></div>
            <div class="info-item"><span class="info-label">품목 코드</span><span class="info-value">${prodDTO.code}</span></div>
            <div class="info-item"><span class="info-label">품목 유형</span><span class="info-value">${prodDTO.type}</span></div>
            <div class="info-item"><span class="info-label">생산시작일</span><span class="info-value"><fmt:formatDate value="${prodDTO.plan_start}" pattern="yyyy-MM-dd"/></span></div>
            <div class="info-item"><span class="info-label">생산마감일</span><span class="info-value"><fmt:formatDate value="${prodDTO.plan_end}"   pattern="yyyy-MM-dd"/></span></div>
            <div class="info-item"><span class="info-label">등록일</span><span class="info-value"><fmt:formatDate value="${prodDTO.created_at}" pattern="yyyy-MM-dd"/></span></div>
        </div>

        <!-- 2. 생산 진행 현황 -->
        <div class="section-title">■ 생산 진행 현황</div>
        <div class="status-grid">
            <div class="status-card">
                <div class="info-label">계획 수량</div>
                <div class="status-num">${prodDTO.plan_qty} EA</div>
            </div>
            <div class="status-card">
                <div class="info-label" style="color:var(--s-cl);">생산 완료</div>
                <div class="status-num" style="color:var(--s-cl);">${prodDTO.currentqty} EA</div>
            </div>
            <div class="status-card">
                <div class="info-label">잔여 수량</div>
                <div class="status-num">
                    ${prodDTO.plan_qty - prodDTO.currentqty < 0 ? 0 : prodDTO.plan_qty - prodDTO.currentqty} EA
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

        <!-- 3. 작업 이력 -->
        <div class="section-title">■ 작업 이력</div>
        <div id="workOrderSection">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:8%;">번호</th>
                        <th>작업번호</th>
                        <th>담당자</th>
                        <th>지시수량</th>
                        <th>생산완료</th>
                        <th>작업일</th>
                        <th>완료일</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody id="workOrderTbody">
                    <tr><td colspan="8" style="padding:20px;color:#aaa;">불러오는 중...</td></tr>
                </tbody>
            </table>
            <div class="wo-paging" id="workOrderPaging"></div>
        </div>

        <!-- 4. 공정 정보 -->
        <div class="section-title">■ 공정 정보</div>
        <div style="margin-bottom:8px;">
            <span class="info-label">공정 정보 링크:</span>
            <a href="/process/item/${prodDTO.item_num}" class="link-text">${prodDTO.item_name} 공정관리 링크</a>
        </div>
        <div class="instruction-box">
            <span class="info-label" style="display:block;margin-bottom:6px;">상세 지시사항</span>
            <strong>${prodDTO.content}</strong>
        </div>

    </main>

    <!-- ===== 작업 등록 모달 ===== -->
    <div id="workModal" class="modal-overlay">
        <div class="modal-box">
            <h3 class="modal-title">작업지시 등록</h3>
            <form id="workRegForm" action="/work" method="post">
                <input type="hidden" name="plan_num" value="${prodDTO.plan_num}">
                <div class="modal-grid">
                    <div class="modal-field">
                        <label>담당자</label>
                        <select name="emp_num">
                            <option value="">선택</option>
                            <c:forEach var="e" items="${empList}">
                                <option value="${e.num}">${e.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="modal-field">
                        <label>지시수량</label>
                        <input type="number" name="order_qty" placeholder="수량 입력" min="1">
                    </div>
                    <div class="modal-field">
                        <label>작업 시작일</label>
                        <input type="date" name="order_start">
                    </div>
                    <div class="modal-field">
                        <label>작업 완료일</label>
                        <input type="date" name="order_end">
                    </div>
                    <div class="modal-field modal-field-full">
                        <label>지시사항</label>
                        <textarea name="content" rows="3" placeholder="작업 지시사항 입력"></textarea>
                    </div>
                </div>
                <div class="modal-btn-wrap">
                    <button type="submit" class="btn-submit">등록</button>
                    <button type="button" class="btn-close" id="btnCloseWorkModal">닫기</button>
                </div>
            </form>
        </div>
    </div>

<script>
    var PLAN_ID = '${prodDTO.plan_id}';

    /* 진행률 바 */
    window.onload = function () {
        var planQty    = parseInt('${prodDTO.plan_qty}')    || 0;
        var currentQty = parseInt('${prodDTO.currentqty}')  || 0;
        var pct = planQty > 0 ? Math.min((currentQty / planQty) * 100, 100) : 0;
        document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
        document.getElementById('progressText').innerText  = pct.toFixed(1) + '%';

        loadWorkOrders(1);
    };

    /* 작업이력 AJAX 로드 */
    function loadWorkOrders(page) {
        fetch('/prod/' + PLAN_ID + '/work-orders?page=' + page)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var list       = data.list       || [];
                var totalPages = data.totalPages  || 0;
                var curPage    = data.currentPage || 1;

                var tbody = document.getElementById('workOrderTbody');
                if (list.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" style="padding:20px;color:#aaa;">등록된 작업지시가 없습니다.</td></tr>';
                } else {
                    var html = '';
                    for (var i = 0; i < list.length; i++) {
                        var w = list[i];
                        html += '<tr>'
                              + '<td>' + ((curPage - 1) * 5 + i + 1) + '</td>'
                              + '<td><a href="/work/' + (w.work_order_id || '') + '" class="link-text">' + (w.work_order_id || '-') + '</a></td>'
                              + '<td>' + (w.ename         || '-') + '</td>'
                              + '<td>' + (w.order_qty     || 0)   + '</td>'
                              + '<td>' + (w.current_qty   || 0)   + '</td>'
                              + '<td>' + (w.order_start   ? w.order_start.substring(0, 10) : '-') + '</td>'
                              + '<td>' + (w.order_end     ? w.order_end.substring(0, 10)   : '-') + '</td>'
                              + '<td><span class="badge">' + (w.work_status || '-') + '</span></td>'
                              + '</tr>';
                    }
                    tbody.innerHTML = html;
                }

                /* 페이징 렌더링 */
                var pagingDiv = document.getElementById('workOrderPaging');
                if (totalPages <= 1) { pagingDiv.innerHTML = ''; return; }
                var ph = '';
                if (curPage > 1) ph += '<a onclick="loadWorkOrders(' + (curPage - 1) + ')">이전</a>';
                for (var p = 1; p <= totalPages; p++) {
                    ph += '<a class="' + (p === curPage ? 'current' : '') + '" onclick="loadWorkOrders(' + p + ')">' + p + '</a>';
                }
                if (curPage < totalPages) ph += '<a onclick="loadWorkOrders(' + (curPage + 1) + ')">다음</a>';
                pagingDiv.innerHTML = ph;
            })
            .catch(function() {
                document.getElementById('workOrderTbody').innerHTML =
                    '<tr><td colspan="8" style="padding:20px;color:#aaa;">데이터를 불러올 수 없습니다.</td></tr>';
            });
    }

    /* 생산계획 취소 */
    function cancelPlan() {
        if (!confirm('해당 생산계획을 취소하시겠습니까?')) return;
        fetch('/prod/' + PLAN_ID + '/cancel', { method: 'POST' })
            .then(function(r) { return r.text(); })
            .then(function() { location.reload(); })
            .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
    }

    /* 작업등록 모달 */
    var btnOpenWork = document.getElementById('btnOpenWorkModal');
    if (btnOpenWork) btnOpenWork.addEventListener('click', function() {
        document.getElementById('workModal').style.display = 'flex';
    });
    document.getElementById('btnCloseWorkModal').addEventListener('click', function() {
        document.getElementById('workModal').style.display = 'none';
    });
    document.getElementById('workModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
</script>

</body>
</html>
