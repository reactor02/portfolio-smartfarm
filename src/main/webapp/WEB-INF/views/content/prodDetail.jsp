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
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/prod/prodDetail.css">
</head>
<body>

    <main class="cont">

        <!-- 페이지 헤더 -->
        <div class="hdr">
            <h1>생산계획 상세</h1>
            <div class="hdr-right">
                <c:if test="${prodDTO.plan_status != '취소' and prodDTO.plan_status != '완료'}">
                    <button type="button" class="btn-action btn-del" onclick="cancelPlan()">취소</button>
                </c:if>
                <button type="button" class="btn-action" onclick="location.href='/prod'">목록으로</button>
            </div>
        </div>

        <!-- 1. 기본 정보 -->
        <div class="section-title">■ 기본 정보</div>
        <div class="info-grid">
            <div class="info-item"><span class="info-label">계획번호</span><span class="info-value">${prodDTO.plan_id}</span></div>
            <div class="info-item"><span class="info-label">상태</span><span class="badge <c:choose><c:when test="${prodDTO.plan_status == '대기'}">badge-wait</c:when><c:when test="${prodDTO.plan_status == '진행'}">badge-progress</c:when><c:when test="${prodDTO.plan_status == '완료'}">badge-done</c:when><c:when test="${prodDTO.plan_status == '취소'}">badge-cancel</c:when></c:choose>">${prodDTO.plan_status}</span></div>
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
                <div class="info-label info-label-accent">생산 완료</div>
                <div class="status-num status-num-accent">${prodDTO.currentqty} EA</div>
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
                        <th class="col-no-sm">번호</th>
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
                    <tr><td colspan="8" class="empty-cell">불러오는 중...</td></tr>
                </tbody>
            </table>
            <div class="wo-paging" id="workOrderPaging"></div>
        </div>

        <!-- 4. 공정 정보 -->
        <div class="section-title">■ 공정 정보</div>
        <div class="process-link-wrap">
            <span class="info-label">공정 정보 링크:</span>
            <a href="/process/item/${prodDTO.item_num}" class="link-text">${prodDTO.item_name} 공정관리 링크</a>
        </div>
        <div class="instruction-box">
            <span class="info-label info-label-block">상세 지시사항</span>
            <strong>${prodDTO.content}</strong>
        </div>

    </main>


<script>
    var PLAN_ID     = '${prodDTO.plan_id}';
    var PLAN_QTY    = parseInt('${prodDTO.plan_qty}')   || 0;
    var CURRENT_QTY = parseInt('${prodDTO.currentqty}') || 0;
</script>
<script src="/resources/js/prod/prodDetail.js"></script>

</body>
</html>
