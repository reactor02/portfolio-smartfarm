<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    lotRoute.jsp — LOT 공정 라우트(Routing) 흐름도
    이 LOT 품목의 공정 단계(flow 순)를 가로 흐름도로 그리고,
    각 공정 노드 위에 그 공정에서 투입되는 자재(bom.process_num 매핑)를 칩으로 합류시킨다.
    데이터는 LotController.route()가 steps(List<LotRouteStepDTO>)로 전달.
--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOT 공정 라우트</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
<link rel="stylesheet" href="/resources/css/lot/lotRoute.css">
</head>
<body>
<main class="cont">

    <div class="hdr">
        <h1>LOT 공정 라우트</h1>
        <div class="hdr-right">
            <button type="button" class="btn-action" onclick="location.href='/lot/${lotCode}'">LOT 상세</button>
            <button type="button" class="btn-action" onclick="location.href='/lot'">목록으로</button>
        </div>
    </div>

    <!-- 기본 정보 -->
    <div class="info-grid">
        <div class="info-item">
            <span class="info-label">LOT 번호</span>
            <span class="info-value">${lotDTO.lot_code}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목명</span>
            <span class="info-value">${lotDTO.item_name}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목 유형</span>
            <span class="info-value">${lotDTO.type}</span>
        </div>
    </div>

    <!-- 공정 라우트 흐름도 -->
    <div class="section-title">&#9632; 공정 라우트 (자재 투입 흐름)</div>

    <c:choose>
        <c:when test="${not empty steps}">
            <div class="route-scroll">
                <div class="route-flow">
                    <c:forEach var="step" items="${steps}">
                        <div class="route-step">

                            <!-- 공정 위로 합류하는 투입 자재 칩 -->
                            <div class="mat-chips">
                                <c:choose>
                                    <c:when test="${not empty step.materials}">
                                        <c:forEach var="m" items="${step.materials}">
                                            <span class="mat-chip">
                                                ${m.material_name}<b>&times;${m.required_qty}</b>
                                            </span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mat-none">투입 자재 없음</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 자재 → 공정 합류 커넥터 -->
                            <div class="mat-connector">&#9660;</div>

                            <!-- 공정 노드 -->
                            <div class="route-node ${step.process_num == 0 ? 'route-node-etc' : ''}">
                                <div class="node-order">
                                    <c:choose>
                                        <c:when test="${step.flow != null}">${step.flow}</c:when>
                                        <c:otherwise>?</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="node-content">${step.process_content}</div>
                                <div class="node-meta">
                                    <c:if test="${not empty step.facility_name}">
                                        <span class="node-tag">설비 ${step.facility_name}</span>
                                    </c:if>
                                    <c:if test="${step.head_count > 0}">
                                        <span class="node-tag">인원 ${step.head_count}</span>
                                    </c:if>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </div>
            <p class="route-hint">&#8593; 각 공정 노드 위 자재가 해당 공정에서 투입됩니다. &nbsp;|&nbsp; 가로로 스크롤하여 전체 공정을 확인하세요.</p>
        </c:when>
        <c:otherwise>
            <div class="route-empty">등록된 공정이 없습니다.</div>
        </c:otherwise>
    </c:choose>

</main>
</body>
</html>
