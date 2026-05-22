<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOT 관리</title>
<style>
    :root { --m-cl:#2D6A4F; --s-cl:#49A47A; --p-cl:#B7E4C7; --bg:#F8F9FA; --txt:#333; --border-cl:#E9ECEF; }
    * { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Malgun Gothic',sans-serif; color:var(--txt); background:var(--bg); }
    .cont { flex:1; padding:2rem; background:#FFF; }

    .page-header { margin-bottom:1.5rem; }
    .page-title  { font-size:1.8rem; font-weight:bold; }

    .search-box  { background:var(--bg); border:1px solid var(--border-cl); border-radius:8px; padding:16px 20px; margin-bottom:1.5rem; }
    .search-row  { display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:8px; }
    .search-row:last-child { margin-bottom:0; }
    .search-label { font-weight:bold; font-size:13px; white-space:nowrap; }
    .search-row input[type=date], .search-row select { padding:6px 10px; border:1px solid var(--border-cl); border-radius:6px; font-size:13px; }
    .search-row input[type=text] { padding:6px 10px; border:1px solid var(--border-cl); border-radius:6px; font-size:13px; width:180px; }
    .btn-search  { padding:7px 18px; background:var(--m-cl); color:#FFF; border:none; border-radius:6px; cursor:pointer; font-size:13px; font-weight:bold; }
    .btn-reset   { padding:7px 18px; background:#FFF; border:1px solid var(--border-cl); border-radius:6px; cursor:pointer; font-size:13px; }
    .btn-search:hover { background:var(--s-cl); }

    .data-table { width:100%; border-collapse:collapse; }
    .data-table th { background:var(--bg); border-bottom:2px solid var(--s-cl); padding:12px; text-align:center; font-size:13px; font-weight:bold; }
    .data-table td { padding:12px; border-bottom:1px solid var(--border-cl); text-align:center; font-size:13px; color:#555; }
    .data-table tbody tr:hover { background:rgba(183,228,199,0.2); }
    .link-txt { color:var(--m-cl); text-decoration:none; font-weight:bold; }
    .link-txt:hover { text-decoration:underline; }
    .badge { display:inline-block; padding:3px 10px; border-radius:12px; font-size:11px; font-weight:bold; background:var(--p-cl); color:var(--m-cl); }

    .paging { text-align:center; margin-top:1.5rem; }
    .paging a, .paging span { display:inline-block; padding:6px 12px; margin:0 2px; border:1px solid var(--border-cl); border-radius:4px; text-decoration:none; color:var(--txt); font-size:13px; }
    .paging a:hover  { background:var(--p-cl); }
    .paging .current { background:var(--m-cl); color:#FFF; border-color:var(--m-cl); }
</style>
</head>
<body>
<main class="cont">

    <div class="page-header">
        <h1 class="page-title">LOT 관리</h1>
    </div>

    <form id="searchForm" method="get" action="/lot">
        <div class="search-box">
            <div class="search-row">
                <span class="search-label">▶ 기간</span>
                <input type="date" name="startDate" value="${page.startDate}">
                <span>~</span>
                <input type="date" name="endDate"   value="${page.endDate}">
                <span class="search-label">▶ 상태</span>
                <select name="lot_status">
                    <option value="">상태 선택</option>
                    <option value="AVAILABLE" <c:if test="${page.lot_status == 'AVAILABLE'}">selected</c:if>>사용가능</option>
                    <option value="USED"      <c:if test="${page.lot_status == 'USED'}">selected</c:if>>소진</option>
                    <option value="EXPIRED"   <c:if test="${page.lot_status == 'EXPIRED'}">selected</c:if>>만료</option>
                </select>
            </div>
            <div class="search-row">
                <span class="search-label">▶ 검색</span>
                <input type="text" name="keyword" value="${page.keyword}" placeholder="LOT번호 / 품목명">
                <button type="submit" class="btn-search">검색</button>
                <button type="button" class="btn-reset" onclick="location.href='/lot'">초기화</button>
            </div>
        </div>
        <input type="hidden" name="page" id="pageInput" value="1">
    </form>

    <table class="data-table">
        <thead>
            <tr>
                <th style="width:6%">번호</th>
                <th>LOT번호</th>
                <th>품목명</th>
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
                            <td>${(page.page-1)*page.size + s.index + 1}</td>
                            <td><a href="/lot/${l.lot_code}" class="link-txt">${l.lot_code}</a></td>
                            <td>${l.item_name}</td>
                            <td>${l.code}</td>
                            <td>${l.current_qty}</td>
                            <td><fmt:formatDate value="${l.lot_date}" pattern="yyyy-MM-dd"/></td>
                            <td><span class="badge">${l.lot_status}</span></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="7" style="padding:40px; color:#aaa;">등록된 LOT가 없습니다.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="paging">
        <c:if test="${page.startPage > 1}">
            <a href="#" onclick="movePage(${page.startPage-1})">이전</a>
        </c:if>
        <c:forEach begin="${page.startPage}" end="${page.endPage}" var="p">
            <c:choose>
                <c:when test="${p == page.page}"><span class="current">${p}</span></c:when>
                <c:otherwise><a href="#" onclick="movePage(${p})">${p}</a></c:otherwise>
            </c:choose>
        </c:forEach>
        <c:if test="${page.endPage < page.totalPages}">
            <a href="#" onclick="movePage(${page.endPage+1})">다음</a>
        </c:if>
    </div>

</main>
<script>
function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}
</script>
</body>
</html>
