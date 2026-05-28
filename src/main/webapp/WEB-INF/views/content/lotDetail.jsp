<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOT 관리 상세</title>
<link rel="stylesheet" href="/resources/css/lot/lotDetail.css">
</head>
<body>
<main class="cont">

    <div class="hdr">
        <h1>LOT 관리 상세</h1>
        <div class="hdr-right">
            <button type="button" class="btn-action" onclick="location.href='/lot'">목록으로</button>
        </div>
    </div>

    <!-- 1. 기본 정보 -->
    <div class="section-title">&#9632; 기본 정보</div>
    <div class="info-grid">
        <div class="info-item">
            <span class="info-label">LOT 번호</span>
            <span class="info-value">${lotDTO.lot_code}</span>
        </div>

        <div class="info-item">
            <span class="info-label">품목 유형</span>
            <span class="info-value">${lotDTO.type}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목명</span>
            <span class="info-value">${lotDTO.item_name}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목 코드</span>
            <span class="info-value">${lotDTO.code}</span>
        </div>
        <div class="info-item">
            <span class="info-label">초기 수량</span>
            <span class="info-value">${lotDTO.init_qty}</span>
        </div>
        <div class="info-item">
            <span class="info-label">현재 수량</span>
            <span class="info-value">${lotDTO.current_qty}</span>
        </div>
        <div class="info-item">
            <span class="info-label">만료일</span>
            <span class="info-value"><fmt:formatDate value="${lotDTO.expiry_date}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="info-item">
            <span class="info-label">생성일</span>
            <span class="info-value"><fmt:formatDate value="${lotDTO.lot_date}" pattern="yyyy-MM-dd"/></span>
        </div>
    </div>

    <!-- 2. 연관관계 + 소모 자재 -->
    <div class="bottom-grid">

        <!-- 연관관계 (CONNECT BY 재귀 트리 + 상위투입) -->
        <div class="section-box">
            <div class="section-title">&#9632; 연관관계</div>
            <ul class="lot-tree">
                <li>&#9660; ${lotDTO.lot_code} (${lotDTO.item_name})
                    <ul>
                        <!-- 소모 자재 재귀 트리 -->
                        <li class="tree-group-label">&#8595; 소모 자재 (이 LOT 생산에 투입된 재료)</li>
                        <c:choose>
                            <c:when test="${not empty recursiveMaterials}">
                                <c:forEach var="m" items="${recursiveMaterials}">
                                    <li class="tree-child" style="padding-left:${m.DEPTH * 20}px;">
                                        |-- ${m.CHILD_LOT_CODE} <span class="tree-item-name">(${m.ITEM_NAME})</span>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="tree-empty">소모 자재 없음</li>
                            </c:otherwise>
                        </c:choose>

                        <!-- 상위 투입 -->
                        <li class="tree-group-label" style="margin-top:10px;">&#8593; 상위 투입 (이 LOT이 투입된 생산)</li>
                        <c:choose>
                            <c:when test="${not empty usedIn}">
                                <c:forEach var="u" items="${usedIn}">
                                    <li class="tree-child">|-- ${u.parent_lot_code} <span class="tree-item-name">(${u.item_name})</span></li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="tree-empty">상위 투입 없음</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- 소모 자재 테이블 (직접 1단계 소모재료 + BOM 수량) -->
        <div class="section-box">
            <div class="section-title">&#9632; 소모 자재</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>LOT 번호</th>
                        <th>품목명</th>
                        <th>소모 수량</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty materials}">
                            <c:forEach var="m" items="${materials}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${m.child_lot_code}</td>
                                    <td>${m.item_name}</td>
                                    <td>${m.required_qty > 0 ? m.required_qty : '-'}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="4" class="empty-cell">등록된 소모 자재가 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>

</main>
</body>
</html>
