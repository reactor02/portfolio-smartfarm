<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%--
    shipmentDetail.jsp — 출하 상세 화면
    기본정보 + 수량 현황(계획/완료/잔여) + 진행률 + 연결 주문/LOT 목록 + 액션(확정/취소).
    LOT 테이블에 "라벨 보기" 버튼 + "전체 라벨 다운로드" 버튼 포함.
    컨트롤러는 /shipmentDetail/{shipmentId} (ShipmentController.shipmentDetail).
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>출하 상세</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/shipment/shipmentDetail.css">
<link rel="stylesheet" href="/resources/css/shipment/label.css">
</head>
<body>

<main class="cont">

    <div class="hdr">
        <h1>출하 상세</h1>
        <div class="hdr-right">
            <%-- 등록완료(수동 LOT 선택 확정): 담당자 또는 실무자 본인만 노출 --%>
            <c:if test="${canConfirm and detail.SHIPMENT_STATUS == '출하대기'}">
                <button type="button" id="btnConfirm" class="btn-action btn-primary">등록완료</button>
            </c:if>
            <%-- 취소버튼: e_level >= 3(사장) 또는 담당자 본인 + 진행 가능 상태 --%>
            <c:if test="${canCancel and detail.SHIPMENT_STATUS != '취소' and detail.SHIPMENT_STATUS != '출하완료'}">
                <form method="POST" action="/cancelShipment" id="cancelShipmentForm" class="form-inline">
                    <input type="hidden" name="shipmentNum"        value="${detail.SHIPMENT_NUM}">
                    <input type="hidden" name="shipmentId"         value="${detail.SHIPMENT_ID}">
                    <input type="hidden" name="shipmentRequestNum" value="${detail.SHIPMENT_REQUEST_NUM}">
                    <button type="submit" class="btn-action btn-del">취소</button>
                </form>
            </c:if>
            <a href="/shipment" class="btn-action">목록으로</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty detail}">

            <%-- 완료수량: 배정된 LOT 수량 합계 --%>
            <c:set var="completeQty" value="0"/>
            <c:forEach var="lot" items="${lots}">
                <c:set var="completeQty" value="${completeQty + lot.QTY}"/>
            </c:forEach>

            <%-- JS가 읽는 출하 메타값 (EL → data-*, 인라인 스크립트 금지) --%>
            <div id="shipmentMeta" class="is-hidden"
                 data-plan-qty="${detail.PLAN_QTY}"
                 data-complete-qty="${completeQty}"
                 data-shipment-id="<c:out value='${detail.SHIPMENT_ID}'/>"
                 data-vender-name="<c:out value='${detail.VENDER_NAME}'/>"
                 data-request-id="<c:out value='${detail.REQUEST_ID}'/>"
                 data-due-date="<c:out value='${detail.DUE_DATE}'/>"
                 data-shipment-date="<c:out value='${detail.SHIPMENT_DATE}'/>"></div>

            <div class="section-box">
                <div class="section-title">기본 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">출하ID</span>
                        <span class="info-value">${detail.SHIPMENT_ID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">상태</span>
                        <span class="info-value">
                            <span class="badge
                                <c:choose>
                                    <c:when test="${detail.SHIPMENT_STATUS == '출하대기'}">badge-waiting</c:when>
                                    <c:when test="${detail.SHIPMENT_STATUS == '진행'}">badge-progress</c:when>
                                    <c:when test="${detail.SHIPMENT_STATUS == '출하완료'}">badge-done</c:when>
                                    <c:when test="${detail.SHIPMENT_STATUS == '취소'}">badge-cancel</c:when>
                                </c:choose>
                            ">${detail.SHIPMENT_STATUS}</span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">거래처</span>
                        <span class="info-value">${detail.VENDER_NAME}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">품목</span>
                        <span class="info-value">${detail.NAME}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">담당자</span>
                        <span class="info-value">${detail.ENAME}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등록일</span>
                        <span class="info-value">${detail.SHIPMENT_DATE}</span>
                    </div>
                </div>
            </div>

            <!-- 수량 현황 카드 -->
            <div class="section-title">&#9632; 출하 수량 현황</div>
            <div class="status-grid">
                <div class="status-card">
                    <div class="info-label">계획 수량</div>
                    <div class="status-num">${detail.PLAN_QTY} EA</div>
                </div>
                <div class="status-card">
                    <div class="info-label info-label-accent">완료 수량</div>
                    <div class="status-num status-num-accent">${completeQty} EA</div>
                </div>
                <div class="status-card">
                    <div class="info-label">잔여 수량</div>
                    <div class="status-num">
                        ${detail.PLAN_QTY - completeQty < 0 ? 0 : detail.PLAN_QTY - completeQty} EA
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

            <%-- ══ 출하 LOT 수동 선택 (출하대기 + 권한 있을 때만) ══ --%>
            <c:if test="${canConfirm and detail.SHIPMENT_STATUS == '출하대기'}">
            <div class="section-box" id="lotSelectBox"
                 data-shipment-id="${detail.SHIPMENT_ID}"
                 data-item-num="${detail.ITEM_NUM}"
                 data-plan-qty="${detail.PLAN_QTY}">
                <div class="section-title">출하 LOT 선택 (FIFO · 오래된 순)</div>
                <table class="data-table" id="candTable">
                    <thead>
                        <tr>
                            <th>LOT 코드</th>
                            <th>생성일</th>
                            <th>유통기한</th>
                            <th>보유수량</th>
                            <th>출하수량(입력)</th>
                        </tr>
                    </thead>
                    <tbody id="candBody">
                        <tr><td colspan="5" class="empty-cell">후보 LOT을 불러오는 중...</td></tr>
                    </tbody>
                </table>
                <div class="progress-text sel-summary">
                    선택 합계 <b id="selTotal">0</b> / 계획 <b>${detail.PLAN_QTY}</b> EA
                    &nbsp;·&nbsp; <b id="selRemain"></b>
                    <span id="selHint" class="sel-hint"></span>
                </div>
            </div>
            </c:if>

            <div class="section-box">
                <div class="section-title">연결 주문 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">요청번호</span>
                        <span class="info-value">
                            <a href="/requestDetail/${detail.REQUEST_ID}" class="link-id">${detail.REQUEST_ID}</a>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">주문 수량</span>
                        <span class="info-value">${detail.REQUEST_QTY} EA</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">주문일</span>
                        <span class="info-value">${detail.REQUEST_DATE}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">납기일</span>
                        <span class="info-value">${detail.DUE_DATE}</span>
                    </div>
                </div>
            </div>

            <%-- ══ 연결 LOT 번호 (라벨 기능 포함) ══ --%>
            <div class="section-box">
                <div class="section-title-row">
                    <span class="section-title">연결 LOT 번호</span>
                    <c:if test="${not empty lots}">
                        <button type="button" class="btn-label-all" id="btnDownloadAll">
                            &#128229; 전체 라벨 다운로드
                        </button>
                    </c:if>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>LOT 코드</th>
                            <th>품목명</th>
                            <th>배정수량</th>
                            <th>생성일</th>
                            <th>유통기한</th>
                            <th>라벨</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty lots}">
                                <c:forEach var="lot" items="${lots}" varStatus="vs">
                                    <tr>
                                        <td>${lot.LOT_CODE}</td>
                                        <td>${lot.ITEM_NAME}</td>
                                        <td>${lot.QTY}</td>
                                        <td>${lot.LOT_DATE}</td>
                                        <td>${not empty lot.EXPIRY_DATE ? lot.EXPIRY_DATE : '-'}</td>
                                        <td>
                                            <button type="button" class="btn-label"
                                                    data-lot-code="<c:out value='${lot.LOT_CODE}'/>"
                                                    data-item-name="<c:out value='${lot.ITEM_NAME}'/>"
                                                    data-qty="${lot.QTY}"
                                                    data-lot-date="<c:out value='${lot.LOT_DATE}'/>"
                                                    data-expiry="<c:out value='${not empty lot.EXPIRY_DATE ? lot.EXPIRY_DATE : ""}'/>">라벨 보기</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6" class="empty-cell">배정된 LOT가 없습니다.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </c:when>
        <c:otherwise>
            <div class="section-box">
                <p class="empty-msg">출하 정보를 찾을 수 없습니다.</p>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<%-- ══ 라벨 미리보기 모달 ══ --%>
<div id="labelModal" class="label-overlay">
    <div class="label-modal-box">
        <div class="label-card" id="labelPreview"></div>
        <div class="label-modal-btns">
            <button type="button" class="btn-label-print" id="btnLabelDownload">&#128229; PDF 저장</button>
            <button type="button" class="btn-label-close" id="btnLabelClose">닫기</button>
        </div>
    </div>
</div>

<%-- ══ 인쇄 전용 전체 라벨 영역 ══ --%>
<div id="printLabelArea">
    <div class="print-label-grid" id="printLabelGrid"></div>
</div>

<script src="/resources/js/lib/qrcode.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script src="/resources/js/shipment/shipmentDetail.js"></script>

<%-- 재고 부족 알림 --%>
<c:if test="${param.error == 'stock'}">
    <script src="/resources/js/common/alertStock.js"></script>
</c:if>
<%-- 권한 없음 알림 --%>
<c:if test="${param.error == 'forbidden'}">
    <script src="/resources/js/common/alertForbidden.js"></script>
</c:if>

</body>
</html>
