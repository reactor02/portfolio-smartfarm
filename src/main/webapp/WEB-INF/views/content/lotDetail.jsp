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
    <div class="section-title">■ 기본 정보</div>
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

    <!-- 2. 공정 이력 + 소모 자재 -->
    <div class="bottom-grid">

        <!-- 공정 이력 (이 LOT이 어느 생산 LOT에 투입됐는지) -->
        <div class="section-box">
            <div class="section-title">■ 공정 이력</div>
            <ul class="lot-tree">
                <li>▼ ${lotDTO.lot_code}
                    <ul>
                        <c:choose>
                            <c:when test="${not empty usedIn}">
                                <c:forEach var="u" items="${usedIn}">
                                    <li>→ ${u.child_lot_code} (${u.item_name})</li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li>등록된 공정 이력이 없습니다.</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- 소모 자재 (이 LOT 생산에 사용된 원재료 LOT) -->
        <div class="section-box">
            <div class="section-title">■ 소모 자재</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>LOT 번호</th>
                        <th>품목명</th>
                        <th>소모자재 수량</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty materials}">
                            <c:forEach var="m" items="${materials}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${m.parent_lot_code}</td>
                                    <td>${m.item_name}</td>
                                    
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="4" style="padding:20px; color:#aaa;">등록된 소모 자재가 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>

</main>
</body>
</html>
