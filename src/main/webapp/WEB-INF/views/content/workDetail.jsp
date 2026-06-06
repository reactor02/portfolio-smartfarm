<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%--
    workDetail.jsp — 작업지시 상세 화면
    기본정보 + 진행률 게이지 + 액션 버튼(시작/완료/생산/취소).
    버튼 동작은 work/workDetail.js, 컨트롤러는 /work/{id} (WorkController.detail).
--%>

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
                <%-- 작업시작: 담당자 또는 실무자 본인만 노출 --%>
                <c:if test="${canWork and workDTO.work_status == '대기'}">
                    <button type="button" class="btn-action" onclick="startWork()">작업시작</button>
                </c:if>
                <%-- 생산투입: 진행 + 더 투입할 여지(order_qty > input_qty) --%>
                <c:if test="${canWork and workDTO.work_status == '진행' and workDTO.order_qty > workDTO.input_qty}">
                    <button type="button" class="btn-action" onclick="openInputModal()">생산투입</button>
                </c:if>
                <%-- 작업완료/투입취소: 진행 + 미생산 투입분 존재(input_qty > current_qty) --%>
                <c:if test="${canWork and workDTO.work_status == '진행' and workDTO.input_qty > workDTO.current_qty}">
                    <button type="button" class="btn-action" onclick="produceWork()">작업완료</button>
                    <button type="button" class="btn-action btn-del" onclick="cancelInput()">투입취소</button>
                </c:if>
                <%-- 취소버튼: e_level >= 3(사장) 또는 담당자 본인 + 진행 가능 상태 --%>
                <c:if test="${canCancel and workDTO.work_status != '완료' and workDTO.work_status != '취소'}">
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
                <span class="info-label">담당자</span>
                <span class="info-value">${workDTO.ename}</span>
            </div>
            <div class="info-item">
                <span class="info-label">실무자</span>
                <span class="info-value">${workDTO.worker_ename}</span>
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

        <!-- 2-1. 소모 자재 / 재고 -->
        <div class="section-title">■ 소모 자재 / 재고</div>
        <div class="mat-summary">
            투입수량 <span class="mat-max-num">${produceInfo.input_qty}</span> /
            지시수량 ${workDTO.order_qty}
            &nbsp;|&nbsp; 미생산 투입분 : <span class="mat-max-num">${produceInfo.pendingProduce}</span>
            &nbsp;|&nbsp; 재고부족에 따른 <strong>최대 투입 가능 수량</strong> :
            <span class="mat-max-num">${produceInfo.maxInput}</span>
            <c:if test="${produceInfo.maxInput < produceInfo.inputtable}">
                <span class="mat-short">(미투입 잔여 ${produceInfo.inputtable} 중 재고 부족으로 제한됨)</span>
            </c:if>
        </div>
        <div class="tbl-box">
            <table class="stk-tbl">
                <thead>
                    <tr>
                        <th>자재명</th>
                        <th>코드</th>
                        <th>단위 소요량</th>
                        <th>필요수량(잔여기준)</th>
                        <th>현재고</th>
                        <th>부족분</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty produceInfo.materials}">
                            <c:forEach var="m" items="${produceInfo.materials}">
                                <tr>
                                    <td>${m.name}</td>
                                    <td>${m.code}</td>
                                    <td>${m.unitQty}</td>
                                    <td>${m.needQty}</td>
                                    <td>${m.available}</td>
                                    <td <c:if test="${m.shortage > 0}">class="mat-short"</c:if>>${m.shortage}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="6" class="empty-cell">등록된 BOM 자재가 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 2-2. 투입 LOT 내역 (생산투입으로 출고된 자재 LOT) -->
        <div class="section-title">■ 투입 LOT 내역</div>
        <div class="tbl-box">
            <table class="stk-tbl">
                <thead>
                    <tr>
                        <th>LOT 코드</th>
                        <th>품목명</th>
                        <th>출고수량</th>
                        <th>생성일</th>
                        <th>유통기한</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orderLots}">
                            <c:forEach var="ol" items="${orderLots}">
                                <tr>
                                    <td>${ol.LOT_CODE}</td>
                                    <td>${ol.ITEM_NAME}</td>
                                    <td>${ol.QTY}</td>
                                    <td>${ol.LOT_DATE}</td>
                                    <td>${not empty ol.EXPIRY_DATE ? ol.EXPIRY_DATE : '-'}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="5" class="empty-cell">투입된 LOT이 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
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
            <span class="info-label">공정 순서별 링크:</span>
            <c:choose>
                <c:when test="${not empty processList}">
                    <c:forEach var="proc" items="${processList}">
                        <div class="process-link-item">
                            <span class="process-order-badge">순서 ${proc.FLOW}</span>
                            <a href="/processDetail?process_num=${proc.PROCESS_NUM}" class="link-txt">공정 상세 보기</a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <span class="process-empty">등록된 공정이 없습니다.</span>
                </c:otherwise>
            </c:choose>
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
        
        <button type="button" class="date-err-btn" onclick="closeDateErrModal()">확인</button>
    </div>
</div>

<!-- 생산투입 수량 입력 모달 -->
<div id="produceModal">
    <div class="produce-box">
        <div class="produce-title">생산투입 수량 입력</div>
        <div class="produce-msg">
            투입(출고)할 생산 수량을 입력하세요.<br>
            최대 투입 가능 수량 : <span id="produceMax" class="mat-max-num"></span>
        </div>
        <input type="number" id="produceQty" class="produce-input" min="1">
        <div class="produce-btn-wrap">
            <button type="button" class="produce-btn" onclick="submitInput()">생산투입</button>
            <button type="button" class="produce-btn produce-btn-cancel" onclick="closeProduceModal()">취소</button>
        </div>
    </div>
</div>

<script>
    var WORK_ORDER_ID = '${workDTO.work_order_id}';
    var ORDER_START   = '<fmt:formatDate value="${workDTO.order_start}" pattern="yyyy-MM-dd"/>';
    var ORDER_QTY     = parseInt('${workDTO.order_qty}')   || 0;
    var CURRENT_QTY   = parseInt('${workDTO.current_qty}') || 0;
    var INPUT_QTY     = parseInt('${produceInfo.input_qty}')      || 0;
    var PENDING_PRODUCE = parseInt('${produceInfo.pendingProduce}') || 0;
    var MAX_INPUT     = parseInt('${produceInfo.maxInput}')       || 0;
</script>
<script src="/resources/js/work/workDetail.js"></script>

</body>
</html>
