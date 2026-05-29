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
    완료수량은 배정 LOT 수량 합계로 계산하며, 출하확정 중 재고 부족 시
    컨트롤러가 ?error=stock 으로 리다이렉트하면 하단 스크립트가 alert를 띄운다.
    컨트롤러는 /shipmentDetail/{shipmentId} (ShipmentController.shipmentDetail).
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>출하 상세</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/shipment/shipmentDetail.css">
</head>
<body>

<main class="cont">

    <div class="hdr">
        <h1>출하 상세</h1>
        <div class="hdr-right">
            <c:if test="${detail.SHIPMENT_STATUS == '출하대기'}">
                <form method="POST" action="/confirmShipment" style="display:inline;">
                    <input type="hidden" name="shipmentNum"        value="${detail.SHIPMENT_NUM}">
                    <input type="hidden" name="shipmentId"         value="${detail.SHIPMENT_ID}">
                    <input type="hidden" name="shipmentRequestNum" value="${detail.SHIPMENT_REQUEST_NUM}">
                    <button type="submit" class="btn-action btn-primary"
                            onclick="return confirm('출하확정하시겠습니까? 재고가 차감됩니다.')">출하확정</button>
                </form>
            </c:if>
            <c:if test="${detail.SHIPMENT_STATUS != '취소' and detail.SHIPMENT_STATUS != '출하완료'}">
                <form method="POST" action="/cancelShipment" style="display:inline;">
                    <input type="hidden" name="shipmentNum"        value="${detail.SHIPMENT_NUM}">
                    <input type="hidden" name="shipmentId"         value="${detail.SHIPMENT_ID}">
                    <input type="hidden" name="shipmentRequestNum" value="${detail.SHIPMENT_REQUEST_NUM}">
                    <button type="submit" class="btn-action btn-del"
                            onclick="return confirm('출하를 취소하시겠습니까?')">취소</button>
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

            <div class="section-box">
                <div class="section-title">기본 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">출하ID</span>
                        <span class="info-value">${detail.SHIPMENT_ID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등록일</span>
                        <span class="info-value">${detail.SHIPMENT_DATE}</span>
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

            <div class="section-box">
                <div class="section-title">연결 LOT 번호</div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>LOT 코드</th>
                            <th>품목명</th>
                            <th>배정수량</th>
                            <th>생성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty lots}">
                                <c:forEach var="lot" items="${lots}">
                                    <tr>
                                        <td>${lot.LOT_CODE}</td>
                                        <td>${lot.ITEM_NAME}</td>
                                        <td>${lot.QTY}</td>
                                        <td>${lot.LOT_DATE}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="4" class="empty-cell">배정된 LOT가 없습니다.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </c:when>
        <c:otherwise>
            <div class="section-box">
                <p style="text-align:center; color:#999; padding:30px;">출하 정보를 찾을 수 없습니다.</p>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<script>
    (function() {
        var planQty     = parseInt('${detail.PLAN_QTY}') || 0;
        var completeQty = parseInt('${completeQty}')     || 0;
        var pct = planQty > 0 ? Math.min(100, Math.round(completeQty / planQty * 100)) : 0;
        var bar  = document.getElementById('progressBar');
        var text = document.getElementById('progressText');
        if (bar)  bar.style.width = pct + '%';
        if (text) text.textContent = pct + '%';
    })();

    // [방어] 출하확정 중 재고 부족(stock_error)으로 롤백된 경우 — 컨트롤러가 ?error=stock 으로 redirect
    <c:if test="${param.error == 'stock'}">
        alert('재고가 부족하여 출하확정을 완료하지 못했습니다. 재고를 확인해 주세요.');
    </c:if>
</script>

</body>
</html>
