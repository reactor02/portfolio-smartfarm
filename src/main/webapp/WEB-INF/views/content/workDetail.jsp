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
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/work/workDetail.css">
</head>
<body>

    <main class="cont">

        <!-- 페이지 헤더 -->
        <div class="hdr">
            <h1>작업지시 상세</h1>
            <div class="hdr-right">
                <c:if test="${workDTO.work_status == '대기'}">
                    <button type="button" class="btn-action" onclick="startWork()">작업시작</button>
                </c:if>
                <c:if test="${workDTO.work_status == '진행'}">
                    <button type="button" class="btn-action" onclick="completeWork()">작업종료</button>
                    <button type="button" class="btn-action" onclick="produceWork()">작업완료</button>
                </c:if>
                <c:if test="${workDTO.work_status != '완료' and workDTO.work_status != '취소'}">
                    <button type="button" class="btn-action btn-del" onclick="cancelWork()">취소</button>
                </c:if>
                <button type="button" class="btn-action" onclick="location.href='/work'">목록으로</button>
            </div>
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
        <div class="status-grid">
            <div class="status-card">
                <div class="info-label">지시 수량</div>
                <div class="status-num">${workDTO.order_qty}</div>
            </div>
            <div class="status-card">
                <div class="info-label info-label-accent">생산 완료</div>
                <div class="status-num status-num-accent">${workDTO.current_qty}</div>
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
        <div class="process-link-wrap">
            <span class="info-label">공정 정보 링크:</span>
            <a href="/process/item/${workDTO.item_num}" class="link-text">${workDTO.item_name} 공정관리 링크</a>
        </div>
        <div class="instruction-box">
            <span class="info-label info-label-block">상세 지시사항</span>
            <strong>${workDTO.content}</strong>
        </div>

    </main>

<!-- 작업일 오류 알림 모달 -->
<div id="dateErrModal" style="display:none; position:fixed; inset:0;
     background:rgba(0,0,0,0.45); z-index:9999;
     align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:12px; padding:32px 36px;
                max-width:340px; width:90%; box-shadow:0 8px 28px rgba(0,0,0,0.2);
                text-align:center; font-family:'Malgun Gothic',sans-serif;">
        <div style="font-size:2.2rem; margin-bottom:14px;">📅</div>
        <div style="font-size:1.1rem; font-weight:bold; color:#333; margin-bottom:8px;">
            작업일이 아닙니다
        </div>
        <div style="font-size:0.88rem; color:#666; margin-bottom:24px;">
            작업시작일: <strong id="dateErrDate" style="color:#2D6A4F;"></strong>
        </div>
        <button onclick="document.getElementById('dateErrModal').style.display='none'"
                style="padding:10px 32px; background:#2D6A4F; color:#fff;
                       border:none; border-radius:6px; font-size:0.95rem;
                       font-weight:bold; cursor:pointer;">확인</button>
    </div>
</div>

<script>
    var WORK_ORDER_ID = '${workDTO.work_order_id}';
    var ORDER_START   = '<fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/>';
    var ORDER_QTY     = parseInt('${workDTO.order_qty}')   || 0;
    var CURRENT_QTY   = parseInt('${workDTO.current_qty}') || 0;
</script>
<script src="/resources/js/work/workDetail.js"></script>

</body>
</html>
