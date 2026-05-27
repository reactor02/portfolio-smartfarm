<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="/resources/css/list-common.css">

<!-- 타이틀 헤더 -->
<div class="page-hdr">
    <h1>LOT 관리</h1>
</div>

<!-- 검색 필터 -->
<form id="searchForm" method="get" action="/lot">
    <div class="sch-wrap">
        <div class="sch-row">
            <div class="sch-left">
                <span class="label">▶ 기간</span>
                <input type="date" name="startDate" value="${page.startDate}" class="form-control">
                <span style="font-weight:bold;color:#666;">~</span>
                <input type="date" name="endDate"   value="${page.endDate}"   class="form-control">
                <span class="label" style="margin-left:10px;">▶ 상태</span>
                <select name="lot_status" class="form-control">
                    <option value="">상태 선택</option>
                    <option value="사용가능" <c:if test="${page.lot_status == '사용가능'}">selected</c:if>>사용가능</option>
                    <option value="소진"     <c:if test="${page.lot_status == '소진'}">selected</c:if>>소진</option>
                    <option value="만료"     <c:if test="${page.lot_status == '만료'}">selected</c:if>>만료</option>
                </select>
            </div>
        </div>
        <div class="sch-row">
            <div class="sch-left">
                <span class="label">▶ 품목분류</span>
                <select name="item_type" id="lotItemType" class="form-control"
                        onchange="filterLotItems()">
                    <option value="">선택</option>
                    <option value="MATERIAL"    <c:if test="${page.item_type == 'MATERIAL'}">selected</c:if>>자재</option>
                    <option value="SEMIPRODUCT" <c:if test="${page.item_type == 'SEMIPRODUCT'}">selected</c:if>>반제품</option>
                    <option value="RAW"         <c:if test="${page.item_type == 'RAW'}">selected</c:if>>원자재</option>
                    <option value="PRODUCT"     <c:if test="${page.item_type == 'PRODUCT'}">selected</c:if>>완제품</option>
                </select>

                <span class="label" style="margin-left:10px;">▶ 품목명</span>
                <select name="item_num" id="lotItemNum" class="form-control">
                    <option value="0">선택</option>
                    <c:forEach var="i" items="${itemList}">
                        <option value="${i.num}" data-type="${i.type}"
                            <c:if test="${page.item_num == i.num}">selected</c:if>>${i.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="sch-right">
                <div class="sch-input-box">
                    <span style="color:#888;">&#128269;</span>
                    <input type="text" name="keyword" value="${page.keyword}" placeholder="LOT번호 / 품목명">
                </div>
                <button type="submit" class="btn-sch">검색</button>
                <button type="button" class="select-reset" onclick="location.href='/lot'">초기화</button>
            </div>
        </div>
    </div>
    <input type="hidden" name="page" id="pageInput" value="1">
</form>

<!-- 목록 테이블 -->
<div class="tbl-box">
    <table class="stk-tbl">
        <thead>
            <tr>
                <th class="col-no">번호</th>
                <th>LOT번호</th>
                <th>품목명</th>
                <th>품목분류</th>
                <th>품목코드</th>
                <th>현재수량</th>
                <th>생성일</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="l" items="${list}" varStatus="s">
                        <tr>
                            <td class="num-cell">${(page.page-1)*page.size + s.index + 1}</td>
                            <td><a href="/lot/${l.lot_code}" class="link-txt">${l.lot_code}</a></td>
                            <td>${l.item_name}</td>
                            <td><c:choose>
                                <c:when test="${l.type == 'MATERIAL'}">자재</c:when>
                                <c:when test="${l.type == 'EQUIP'}">장비</c:when>
                                <c:when test="${l.type == 'SEMIPRODUCT'}">반제품</c:when>
                                <c:when test="${l.type == 'RAW'}">원자재</c:when>
                                <c:when test="${l.type == 'PRODUCT'}">완제품</c:when>
                                <c:otherwise>${l.type}</c:otherwise>
                            </c:choose></td>
                            <td>${l.code}</td>
                            <td>${l.current_qty}</td>
                            <td><fmt:formatDate value="${l.lot_date}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <span class="badge <c:choose><c:when test="${l.lot_status == 'available'}">badge-available</c:when><c:when test="${l.lot_status == 'used'}">badge-used</c:when><c:when test="${l.lot_status == 'expired'}">badge-expired</c:when></c:choose>">${l.lot_status}</span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8" class="empty-cell">등록된 LOT가 없습니다.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<!-- 페이지네이션 -->
<div class="pg-wrap">
    <c:if test="${page.page > 1}">
        <a href="#" onclick="movePage(${page.page-1})" class="pg-btn">이전</a>
    </c:if>
    <c:forEach begin="${page.startPage}" end="${page.endPage}" var="p">
        <c:choose>
            <c:when test="${p == page.page}"><a href="#" class="pg-btn pg-active">${p}</a></c:when>
            <c:otherwise><a href="#" onclick="movePage(${p})" class="pg-btn">${p}</a></c:otherwise>
        </c:choose>
    </c:forEach>
    <c:if test="${page.page < page.totalPages}">
        <a href="#" onclick="movePage(${page.page+1})" class="pg-btn">다음</a>
    </c:if>
</div>

<script>
function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}

/* 품목분류 → 품목명 연계 드롭다운 */
function filterLotItems() {
    var type = document.getElementById('lotItemType').value;
    var sel  = document.getElementById('lotItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}
window.addEventListener('load', function() { filterLotItems(); });
</script>
