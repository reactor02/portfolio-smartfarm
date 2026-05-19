<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/prod/prodPlan.css">

<!-- ===== 생산계획 관리 (content 영역) ===== -->

<!-- 페이지 타이틀 + 등록 버튼 -->
<div class="page-header">
    <h2 class="page-title">생산계획 관리</h2>
    <button class="btn-register" onclick="location.href='#'">+ 등록 버튼</button>
</div>

<!-- 검색 영역 -->
<div class="search-box">
    <div class="search-row">
        <div class="search-group">
            <span class="search-label">▶ 기간</span>
            <input type="date" class="date-start" placeholder="YYYY-MM-DD">
            <span class="search-tilde">~</span>
            <input type="date" class="date-end" placeholder="YYYY-MM-DD">
        </div>
    </div>
    <div class="search-row">
        <div class="search-group">
            <span class="search-label">▶ 시설</span>
            <select class="select-box">
                <option value="">전체</option>
            </select>
        </div>
        <div class="search-group">
            <span class="search-label">▶ 제품명</span>
            <select class="select-box">
                <option value="">전체</option>
            </select>
        </div>
        <div class="search-group search-keyword-group">
            <input type="text" class="input-keyword" placeholder="검색">
            <button class="btn-search">검색</button>
        </div>
    </div>
</div>

<!-- 목록 테이블 -->
<div class="table-wrap">
    <table class="list-table">
        <thead>
            <tr>
                <th>번호</th>
                <th>계획번호</th>
                <th>품목</th>
                <th>계획수량</th>
                <th>생산일자</th>
                <th>생산마감</th>
                <th>진행률</th>
                <th>상태</th>
                <th>시설</th>
                <th>담당자</th>
            </tr>
        </thead>
        <tbody id="planTableBody">
            <%-- JSTL c:forEach로 데이터 출력 예시
            <c:forEach var="plan" items="${planList}" varStatus="vs">
            <tr>
                <td>${vs.count}</td>
                <td>${plan.planNo}</td>
                <td>${plan.itemName}</td>
                <td>${plan.planQty}</td>
                <td>${plan.startDate}</td>
                <td>${plan.endDate}</td>
                <td>${plan.progress}%</td>
                <td>${plan.status}</td>
                <td>${plan.facility}</td>
                <td>${plan.manager}</td>
            </tr>
            </c:forEach>
            --%>
            <!-- 데이터 없을 때 빈 행 -->
            <tr class="empty-row"><td colspan="10">데이터가 없습니다.</td></tr>
        </tbody>
    </table>
</div>

<!-- 페이지네이션 -->
<div class="pagination">
    <a href="#" class="page-btn">이전</a>
    <a href="#" class="page-num active">1</a>
    <a href="#" class="page-num">2</a>
    <a href="#" class="page-num">3</a>
    <a href="#" class="page-num">4</a>
    <a href="#" class="page-num">5</a>
    <a href="#" class="page-btn">다음</a>
</div>

<script src="${pageContext.request.contextPath}/static/js/prod/prodPlan.js"></script>