<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
    lotDetail.jsp — LOT 상세 화면
    LOT 기본정보 + 소모자재(상위) 관계 + 롯이력 추적 트리(재귀 조회 결과)를 표시한다.
    롯이력/소모자재 데이터는 LotController가 getRecursiveMaterials/getLotHistory로 조회.
--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOT 관리 상세</title>
<link rel="stylesheet" href="/resources/css/detail-common.css">
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

    <!-- 2. 탭 네비게이션 -->
    <div class="tab-nav" style="display:flex; gap:4px; margin-bottom:0; border-bottom:2px solid #d9d9d9;">
        <button class="tab-btn active" onclick="switchTab('relation', this)"
                style="padding:8px 20px; border:1px solid #d9d9d9; border-bottom:none; background:#fff;
                       cursor:pointer; font-size:14px; border-radius:4px 4px 0 0;">
            연관관계 · 소모자재
        </button>
        <button class="tab-btn" onclick="switchTab('lothistory', this)"
                style="padding:8px 20px; border:1px solid #d9d9d9; border-bottom:none; background:#f5f5f5;
                       cursor:pointer; font-size:14px; border-radius:4px 4px 0 0; color:#888;">
            롯이력
        </button>
    </div>

    <!-- 탭 1: 연관관계 + 소모자재 -->
    <div id="tab-relation" class="tab-panel">
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

        <!-- 소모 자재 테이블 (전체 재귀 소모재료) -->
        <div class="section-box">
            <div class="section-title">&#9632; 소모 자재</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>단계</th>
                        <th>LOT 번호</th>
                        <th>품목명</th>
                        <th>소모 수량</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty recursiveMaterials}">
                            <c:forEach var="m" items="${recursiveMaterials}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${m.DEPTH}</td>
                                    <td>${m.CHILD_LOT_CODE}</td>
                                    <td>${m.ITEM_NAME}</td>
                                    <td>${m.REQUIRED_QTY > 0 ? m.REQUIRED_QTY : '-'}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="5" class="empty-cell">등록된 소모 자재가 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
    </div><!-- /tab-relation -->

    <!-- 탭 2: 롯이력 -->
    <div id="tab-lothistory" class="tab-panel" style="display:none;">
        <div class="section-box" style="padding:16px 0;">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>단계</th>
                        <th>LOT번호</th>
                        <th>품목명</th>
                        <th>유형</th>
                        <th>구분</th>
                        <th>ID</th>
                        <th>내용(공정/거래처)</th>
                        <th>날짜</th>
                        <th>상태</th>
                        <th>담당자</th>
                    </tr>
                </thead>
                <tbody id="lothistory-body">
                    <tr><td colspan="10" class="empty-cell">롯이력 탭을 클릭하면 로드됩니다.</td></tr>
                </tbody>
            </table>
        </div>
    </div><!-- /tab-lothistory -->

</main>

<script>
    /* ── 탭 전환 ── */
    let lotHistoryLoaded = false;

    function switchTab(name, btn) {
        document.querySelectorAll('.tab-btn').forEach(function(b) {
            b.classList.remove('active');
            b.style.background  = '#f5f5f5';
            b.style.color       = '#888';
            b.style.borderBottom = 'none';
        });
        document.querySelectorAll('.tab-panel').forEach(function(p) {
            p.style.display = 'none';
        });
        btn.classList.add('active');
        btn.style.background  = '#fff';
        btn.style.color       = '#000';
        btn.style.borderBottom = '2px solid #fff';
        document.getElementById('tab-' + name).style.display = 'block';

        if (name === 'lothistory' && !lotHistoryLoaded) {
            fetch('/lot/${lotDTO.lot_code}/lotHistory')
                .then(function(r) { return r.json(); })
                .then(renderLotHistory)
                .catch(function(err) { console.error('롯이력 로드 오류:', err); });
            lotHistoryLoaded = true;
        }
    }

    /* ── 롯이력 렌더링 ── */
    function renderLotHistory(data) {
        var tbody = document.getElementById('lothistory-body');
        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="10" class="empty-cell">롯이력이 없습니다.</td></tr>';
            return;
        }
        var html = '';
        data.forEach(function(r) {
            var isShipment = (r.GUBUN === '출하');
            html += '<tr>'
                + '<td>' + (r.DEPTH       != null ? r.DEPTH       : 0)   + '</td>'
                + '<td>' + (r.LOT_CODE    || '-') + '</td>'
                + '<td>' + (r.ITEM_NAME   || '-') + '</td>'
                + '<td>' + (r.ITEM_TYPE   || '-') + '</td>'
                + '<td><span style="padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold;'
                +      (isShipment ? 'background:#fff7e6;color:#fa8c16;border:1px solid #ffd591;'
                                   : 'background:#f6ffed;color:#52c41a;border:1px solid #b7eb8f;') + '">'
                +      (r.GUBUN || '-') + '</span></td>'
                + '<td>' + (r.ID_COL      || '-') + '</td>'
                + '<td>' + (r.CONTENT_COL || '-') + '</td>'
                + '<td>' + (r.DATE_COL    || '-') + '</td>'
                + '<td>' + (r.STATUS_COL  || '-') + '</td>'
                + '<td>' + (r.WORKER      || '-') + '</td>'
                + '</tr>';
        });
        tbody.innerHTML = html;
    }
</script>
</body>
</html>
