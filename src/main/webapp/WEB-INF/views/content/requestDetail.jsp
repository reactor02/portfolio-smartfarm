<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%--
    requestDetail.jsp — 출하요청 상세 화면
    요청 기본정보 + 연계 출하지시 목록 + 액션(취소).
    컨트롤러는 /requestDetail/{requestId} (RequestController.requestDetail).
--%>

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
            <%-- 취소버튼: e_level >= 3(사장) 또는 담당자 본인 + 진행 가능 상태 --%>
            <c:if test="${canCancel and detail.REQUEST_STATUS != '취소' and detail.REQUEST_STATUS != '출하완료'}">
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
                        <span class="info-label">납기일</span>
                        <span class="info-value">${detail.DUE_DATE}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">담당자</span>
                        <span class="info-value">${detail.ENAME}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">등록일</span>
                        <span class="info-value">${detail.REQUEST_DATE}</span>
                    </div>
                    <c:if test="${not empty detail.CONTENT}">
                    <div class="info-item info-item-full">
                        <span class="info-label">상세지시사항</span>
                        <span class="info-value">${detail.CONTENT}</span>
                    </div>
                    </c:if>
                </div>
            </div>

            <!-- 출하 수량 현황 -->
            <div class="section-box">
                <div class="section-title">출하 수량 현황</div>
                <div class="status-grid">
                    <div class="status-card">
                        <div class="info-label">주문 수량</div>
                        <div class="status-num">${detail.REQUEST_QTY} EA</div>
                    </div>
                    <div class="status-card">
                        <div class="info-label info-label-accent">출하 완료</div>
                        <div class="status-num status-num-accent">${detail.SHIPPED_QTY} EA</div>
                    </div>
                    <div class="status-card">
                        <div class="info-label">잔여 수량</div>
                        <div class="status-num">
                            ${detail.REQUEST_QTY - detail.SHIPPED_QTY < 0 ? 0 : detail.REQUEST_QTY - detail.SHIPPED_QTY} EA
                        </div>
                    </div>
                </div>
                <div class="progress-box">
                    <div class="info-label">출하 진행률</div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" id="progressBar"></div>
                    </div>
                    <div class="progress-text" id="progressText"></div>
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

<c:if test="${not empty detail}">
<script>
var REQ_QTY    = ${detail.REQUEST_QTY};
var SHIPPED_QTY = ${detail.SHIPPED_QTY};
</script>
<script src="/resources/js/request/requestDetail.js"></script>
</c:if>

<%-- [권한] 담당자 아닌 사람이 취소 시도한 경우 --%>
<c:if test="${param.error == 'forbidden'}">
    <script src="/resources/js/common/alertForbidden.js"></script>
</c:if>

</body>
</html>
