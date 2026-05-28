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
<title>주문 상세</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/request/requestDetail.css">
</head>
<body>

<main class="cont">

    <div class="hdr">
        <h1>주문 상세</h1>
        <div class="hdr-right">
            <c:if test="${detail.REQUEST_STATUS != '취소' and detail.REQUEST_STATUS != '출하완료'}">
                <form method="POST" action="/cancelRequest" style="display:inline;">
                    <input type="hidden" name="shipmentRequestNum" value="${detail.SHIPMENT_REQUEST_NUM}">
                    <input type="hidden" name="requestId"          value="${detail.REQUEST_ID}">
                    <button type="submit" class="btn-action btn-del"
                            onclick="return confirm('주문을 취소하시겠습니까?')">취소</button>
                </form>
            </c:if>
            <a href="/request" class="btn-action">목록으로</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty detail}">

            <!-- 기본 정보 -->
            <div class="section-box">
                <div class="section-title">기본 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">요청번호</span>
                        <span class="info-value">${detail.REQUEST_ID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등록일</span>
                        <span class="info-value">${detail.REQUEST_DATE}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">납기일</span>
                        <span class="info-value">${detail.DUE_DATE}</span>
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
                        <span class="info-label">수량</span>
                        <span class="info-value">${detail.REQUEST_QTY}</span>
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
                                    <c:when test="${detail.REQUEST_STATUS == '접수'}">badge-progress</c:when>
                                    <c:when test="${detail.REQUEST_STATUS == '출하대기'}">badge-waiting</c:when>
                                    <c:when test="${detail.REQUEST_STATUS == '출하완료'}">badge-done</c:when>
                                    <c:when test="${detail.REQUEST_STATUS == '취소'}">badge-cancel</c:when>
                                </c:choose>
                            ">${detail.REQUEST_STATUS}</span>
                        </span>
                    </div>
                </div>
            </div>

            <!-- 연계된 출하지시 -->
            <div class="section-box">
                <div class="section-title">연계된 출하지시</div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>출하ID</th>
                            <th>출하일</th>
                            <th>계획수량</th>
                            <th>담당자</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty linkedShipments}">
                                <c:forEach var="s" items="${linkedShipments}">
                                    <tr>
                                        <td><a href="/shipmentDetail/${s.SHIPMENT_ID}" class="link-id">${s.SHIPMENT_ID}</a></td>
                                        <td>${s.SHIPMENT_DATE}</td>
                                        <td>${s.PLAN_QTY}</td>
                                        <td>${s.ENAME}</td>
                                        <td>
                                            <span class="badge
                                                <c:choose>
                                                    <c:when test="${s.SHIPMENT_STATUS == '출하대기'}">badge-waiting</c:when>
                                                    <c:when test="${s.SHIPMENT_STATUS == '진행'}">badge-progress</c:when>
                                                    <c:when test="${s.SHIPMENT_STATUS == '출하완료'}">badge-done</c:when>
                                                    <c:when test="${s.SHIPMENT_STATUS == '취소'}">badge-cancel</c:when>
                                                </c:choose>
                                            ">${s.SHIPMENT_STATUS}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5" class="empty-cell">출하지시 없음</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </c:when>
        <c:otherwise>
            <div class="section-box">
                <p style="text-align:center; color:#999; padding:30px;">주문 정보를 찾을 수 없습니다.</p>
            </div>
        </c:otherwise>
    </c:choose>

</main>

</body>
</html>
