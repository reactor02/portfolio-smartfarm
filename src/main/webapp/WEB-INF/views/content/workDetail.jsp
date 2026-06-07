<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%--
    workDetail.jsp — 작업지시 상세 (공정별 라우팅 진행)
    공정 라우트 흐름도 + 공정 진행기록 테이블 + 공정 제어패널(소모자재투입/공정시작/공정완료) + 작업완료.
    동작은 work/workDetail.js, 컨트롤러는 /work/{id} (WorkController.detail).
--%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업지시 상세</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/lot/lotRoute.css">
<link rel="stylesheet" href="/resources/css/work/workDetail.css">
</head>
<body>

    <main class="cont" id="workDetail"
          data-work-order-id="${workDTO.work_order_id}"
          data-order-start="<fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/>"
          data-order-qty="${workDTO.order_qty}"
          data-current-qty="${workDTO.current_qty}"
          data-input-qty="${workDTO.input_qty}"
          data-max-producible="${maxInfo.maxProducible}">

        <!-- 페이지 헤더 -->
        <div class="hdr">
            <h1>작업지시 상세</h1>
            <div class="hdr-right">
                <%-- 작업시작: 담당자/실무자 본인, 대기 상태 --%>
                <c:if test="${canWork and workDTO.work_status == '대기'}">
                    <button type="button" class="btn-action" id="btnStartWork">작업시작</button>
                </c:if>
                <%-- 작업완료: 진행 상태 (공정 진행 중이면 서버가 차단) --%>
                <c:if test="${canWork and workDTO.work_status == '진행'}">
                    <button type="button" class="btn-action" id="btnCompleteWork">작업완료</button>
                </c:if>
                <%-- 취소: e_level>=3 또는 담당자 본인, 완료/취소 아님 --%>
                <c:if test="${canCancel and workDTO.work_status != '완료' and workDTO.work_status != '취소'}">
                    <button type="button" class="btn-action btn-del" id="btnCancelWork">취소</button>
                </c:if>
                <button type="button" class="btn-action" id="btnGoList">목록으로</button>
            </div>
        </div>

        <!-- 1. 기본 정보 -->
        <div class="section-title">■ 기본 정보</div>
        <div class="info-grid">
            <div class="info-item"><span class="info-label">작업번호</span><span class="info-value">${workDTO.work_order_id}</span></div>
            <div class="info-item"><span class="info-label">상태</span>
                <span class="badge <c:choose><c:when test="${workDTO.work_status == '대기'}">badge-wait</c:when><c:when test="${workDTO.work_status == '진행'}">badge-progress</c:when><c:when test="${workDTO.work_status == '완료'}">badge-done</c:when><c:when test="${workDTO.work_status == '취소'}">badge-cancel</c:when></c:choose>">${workDTO.work_status}</span>
            </div>
            <div class="info-item"><span class="info-label">품목명</span><span class="info-value">${workDTO.item_name}</span></div>
            <div class="info-item"><span class="info-label">품목 코드</span><span class="info-value">${workDTO.code}</span></div>
            <div class="info-item"><span class="info-label">품목 유형</span><span class="info-value">${workDTO.type}</span></div>
            <div class="info-item"><span class="info-label">작업일</span><span class="info-value"><fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/></span></div>
            <div class="info-item"><span class="info-label">작업완료</span><span class="info-value"><fmt:formatDate value="${workDTO.order_end}" pattern="yyyy-MM-dd"/></span></div>
            <div class="info-item"><span class="info-label">담당자</span><span class="info-value">${workDTO.ename}</span></div>
            <div class="info-item"><span class="info-label">실무자</span><span class="info-value">${workDTO.worker_ename}</span></div>
        </div>

        <!-- 2. 작업 현황 -->
        <div class="section-title">■ 작업 현황</div>
        <div class="status-grid">
            <div class="status-card"><div class="info-label">지시 수량</div><div class="status-num">${workDTO.order_qty}</div></div>
            <div class="status-card"><div class="info-label info-label-accent">생산 완료수량</div><div class="status-num status-num-accent">${workDTO.current_qty}</div></div>
            <div class="status-card"><div class="info-label">재고기준 최대 생산량</div><div class="status-num">${maxInfo.maxProducible}</div></div>
        </div>

        <!-- 3. 공정 라우트 (가로 흐름도) -->
        <div class="section-title">■ 공정 라우트</div>
        <c:choose>
            <c:when test="${not empty routeSteps}">
                <div class="route-scroll">
                    <div class="route-flow">
                        <c:forEach var="step" items="${routeSteps}">
                            <div class="route-step">
                                <div class="mat-chips">
                                    <c:choose>
                                        <c:when test="${not empty step.materials}">
                                            <c:forEach var="m" items="${step.materials}">
                                                <span class="mat-chip">${m.material_name}<b>&times;${m.required_qty}</b></span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise><span class="mat-none">투입 자재 없음</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mat-connector">&#9660;</div>
                                <div class="route-node ${step.process_num == 0 ? 'route-node-etc' : ''}">
                                    <div class="node-order"><c:choose><c:when test="${step.flow != null}">${step.flow}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
                                    <div class="node-content">${step.process_content}</div>
                                    <div class="node-meta">
                                        <c:if test="${not empty step.facility_name}"><span class="node-tag">설비 ${step.facility_name}</span></c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <p class="route-hint">&#8593; 각 공정 위 자재가 해당 공정에서 투입됩니다. 가로 스크롤로 전체 확인.</p>
            </c:when>
            <c:otherwise><div class="route-empty">등록된 공정이 없습니다.</div></c:otherwise>
        </c:choose>

        <!-- 4. 공정 제어 (현재 활성 공정만 — 테이블과 별개) -->
        <c:if test="${canWork and workDTO.work_status == '진행'}">
            <div class="section-title">■ 공정 제어</div>
            <div class="wp-control">
                <c:choose>
                    <c:when test="${actionState.allDone}">
                        <c:choose>
                            <c:when test="${actionState.canNextCycle}">
                                <span class="wp-ctl-msg">${actionState.currentCycleNo}회차 공정이 모두 완료되었습니다.
                                    지시수량 미달(${workDTO.current_qty}/${workDTO.order_qty}) — 다음 회차를 진행하세요.</span>
                                <button type="button" class="btn-action" id="btnNextCycle">다음 회차 생산</button>
                            </c:when>
                            <c:otherwise>
                                <span class="wp-final-badge">✔ 최종생산완료</span>
                                <span class="wp-ctl-msg">모든 공정이 완료되었습니다. 상단 [작업완료]로 마감하세요.</span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <span class="wp-ctl-msg">현재 공정 (순서 ${actionState.activeFlow}) :
                            <b>${actionState.activeStatus}</b></span>
                        <c:choose>
                            <c:when test="${actionState.action == 'input'}">
                                <button type="button" class="btn-action" id="btnInputMaterial" data-process="${actionState.activeProcessNum}">소모자재 투입</button>
                            </c:when>
                            <c:when test="${actionState.action == 'start'}">
                                <button type="button" class="btn-action" id="btnStartProcess" data-process="${actionState.activeProcessNum}">공정 시작</button>
                            </c:when>
                            <c:when test="${actionState.action == 'complete'}">
                                <button type="button" class="btn-action" id="btnCompleteProcess" data-process="${actionState.activeProcessNum}">공정 완료</button>
                            </c:when>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- 5. 공정 진행 기록 (읽기전용) -->
        <div class="section-title">■ 공정 진행 기록</div>
        <div class="tbl-box">
            <table class="stk-tbl">
                <thead>
                    <tr><th>순서</th><th>공정</th><th>상태</th><th>시작시각</th><th>완료시각</th></tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty workProcesses}">
                            <c:forEach var="wp" items="${workProcesses}">
                                <tr>
                                    <td>${wp.FLOW}</td>
                                    <td>${wp.PROCESS_CONTENT}</td>
                                    <td><span class="wp-st wp-st-${wp.STATUS}">${wp.STATUS}</span></td>
                                    <td>${not empty wp.START_TIME ? wp.START_TIME : '-'}</td>
                                    <td>${not empty wp.END_TIME ? wp.END_TIME : '-'}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise><tr><td colspan="5" class="empty-cell">공정 기록이 없습니다.</td></tr></c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 6. 투입(소모) 자재 LOT 내역 -->
        <div class="section-title">■ 투입 자재 LOT 내역</div>
        <div class="tbl-box">
            <table class="stk-tbl">
                <thead>
                    <tr><th>공정순서</th><th>자재명</th><th>LOT 코드</th><th>소모수량</th></tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty workProcessLots}">
                            <c:forEach var="wl" items="${workProcessLots}">
                                <tr>
                                    <td>${wl.FLOW}</td>
                                    <td>${wl.ITEM_NAME}</td>
                                    <td>${wl.LOT_CODE}</td>
                                    <td>${wl.QTY}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise><tr><td colspan="4" class="empty-cell">투입된 자재가 없습니다.</td></tr></c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 7. 생산계획 정보 -->
        <div class="section-title">■ 생산계획정보</div>
        <div class="info-grid">
            <div class="info-item"><span class="info-label">계획번호</span><span class="info-value">${workDTO.plan_id}</span></div>
            <div class="info-item"><span class="info-label">계획상태</span>
                <span class="badge <c:choose><c:when test="${workDTO.plan_status == '대기'}">badge-wait</c:when><c:when test="${workDTO.plan_status == '진행'}">badge-progress</c:when><c:when test="${workDTO.plan_status == '완료'}">badge-done</c:when><c:when test="${workDTO.plan_status == '취소'}">badge-cancel</c:when></c:choose>">${workDTO.plan_status}</span>
            </div>
            <div class="info-item"><span class="info-label">계획수량</span><span class="info-value">${workDTO.plan_qty}</span></div>
            <div class="info-item"><span class="info-label">생산시작일</span><span class="info-value"><fmt:formatDate value="${workDTO.plan_start}" pattern="yyyy-MM-dd"/></span></div>
            <div class="info-item"><span class="info-label">생산마감일</span><span class="info-value"><fmt:formatDate value="${workDTO.plan_end}" pattern="yyyy-MM-dd"/></span></div>
        </div>

        <div class="instruction-box">
            <span class="info-label info-label-block">상세 지시사항</span>
            <strong>${workDTO.content}</strong>
        </div>

    </main>

<!-- 작업일 오류 알림 모달 -->
<div id="dateErrModal">
    <div class="date-err-box">
        <div class="date-err-icon">⚠️</div>
        <div class="date-err-title">작업 시작 불가</div>
        <div class="date-err-msg">
            지정된 작업 시작일은 <span id="dateErrDate" class="date-err-date"></span>입니다.<br>
            작업 시작일 당일에만 작업을 개시할 수 있습니다.
        </div>
        <button type="button" class="date-err-btn" id="btnDateErrClose">확인</button>
    </div>
</div>

<!-- 소모자재 투입 수량 모달 -->
<div id="inputModal">
    <div class="produce-box">
        <div class="produce-title">소모자재 투입</div>
        <div class="produce-msg">
            생산수량을 입력하세요. (최대 생산 가능 수량 : <span id="inputMax" class="mat-max-num"></span>)<br>
            <span class="produce-sub" id="inputLockMsg"></span>
        </div>
        <input type="number" id="inputQty" class="produce-input" min="1">
        <div class="preview-wrap">
            <div class="info-label info-label-block">차감 예정 LOT (FIFO)</div>
            <div id="previewBody" class="preview-body">수량을 입력하세요.</div>
        </div>
        <div id="shortageBox" class="shortage-box"></div>
        <div class="produce-btn-wrap">
            <button type="button" class="produce-btn" id="btnSubmitInput">투입</button>
            <button type="button" class="produce-btn produce-btn-cancel" id="btnCloseInput">취소</button>
        </div>
    </div>
</div>

<script src="/resources/js/work/workDetail.js"></script>

</body>
</html>
