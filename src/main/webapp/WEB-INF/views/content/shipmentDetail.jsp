<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>출하 상세</title>
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

            <div class="section-box">
                <div class="section-title">기본 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">출하ID</span>
                        <span class="info-value">${detail.SHIPMENT_ID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">출하일</span>
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
                        <span class="info-label">계획수량</span>
                        <span class="info-value">${detail.PLAN_QTY}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">담당자</span>
                        <span class="info-value">${detail.ENAME}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등록일</span>
                        <span class="info-value">${detail.SHIPMENT_DATE}</span>
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

</body>
</html>
