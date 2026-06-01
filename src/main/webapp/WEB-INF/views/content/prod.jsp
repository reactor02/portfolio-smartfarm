<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%--
    prod.jsp — 생산계획 관리 목록 화면 (Tiles content fragment)
    검색 필터 + 생산계획 목록 + 페이징 + 등록 모달.
    스크립트는 prod/prod.js, 컨트롤러는 /prod (ProdController.list).
--%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/prod/prod.css">

<div class="main-cont">

<!-- 타이틀 & 등록 버튼 -->
<div class="page-hdr">
    <h1>생산계획 관리</h1>
    <%-- e_level 2 이상(팀장·사장)만 등록버튼 표시 --%>
    <c:if test="${sessionScope.loginUser.e_level >= 2}">
        <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
    </c:if>
</div>

<!-- 검색 폼 -->
<form name="searchFrm" action="/prod" method="get">
    <div class="sch-wrap">

        <!-- 1행: 기간 -->
        <div class="sch-row-1">
            <span class="label">▶ 기간</span>
            <input type="date" name="startDate" id="startDate"
                   value="${param.startDate}" class="form-control"
                   onchange="validateDate()">
            <span class="date-sep">~</span>
            <input type="date" name="endDate" id="endDate"
                   value="${param.endDate}" class="form-control"
                   onchange="validateDate()">
        </div>

        <!-- 2행: 상태 | 품목분류 | 품목명 (33:33:33) -->
        <div class="sch-row-2">
            <div>
                <span class="label">▶ 상태</span>
                <select name="plan_status" class="form-control">
                    <option value="">선택</option>
                    <option value="대기" <c:if test="${param.plan_status == '대기'}">selected</c:if>>대기</option>
                    <option value="진행" <c:if test="${param.plan_status == '진행'}">selected</c:if>>진행</option>
                    <option value="취소" <c:if test="${param.plan_status == '취소'}">selected</c:if>>취소</option>
                    <option value="완료" <c:if test="${param.plan_status == '완료'}">selected</c:if>>완료</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 정렬순서</span>
                <select name="sort" class="form-control">
                    <option value="reg"   ${param.sort == 'reg'   || empty param.sort ? 'selected' : ''}>최근 등록순</option>
                    <option value="start" ${param.sort == 'start' ? 'selected' : ''}>빠른 생산일순</option>
                    <option value="end"   ${param.sort == 'end'   ? 'selected' : ''}>빠른 마감일순</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 품목분류</span>
                <select name="item_type" id="prodItemType" class="form-control"
                        onchange="filterProdItems()">
                    <option value="">선택</option>
                    <option value="SEMIPRODUCT" ${param.item_type == 'SEMIPRODUCT' ? 'selected' : ''}>반제품</option>
                    <option value="PRODUCT"     ${param.item_type == 'PRODUCT'     ? 'selected' : ''}>완제품</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 품목명</span>
                <select name="item_num" id="prodItemNum" class="form-control">
                    <option value="0">선택</option>
                    <c:forEach var="i" items="${itemList}">
                        <option value="${i.num}" data-type="${i.type}"
                            ${param.item_num == i.num ? 'selected' : ''}>${i.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- 3행: 키워드 검색 (우측 정렬) -->
        <div class="sch-row-3">
            <div class="sch-input-box">
                <span class="sch-icon">&#128269;</span>
                <input type="text" name="keyword"
                       value="${param.keyword}" placeholder="계획번호 / 품목명">
            </div>
            <button type="submit" class="btn-sch">검색</button>
            <button type="button" class="select-reset"
                    onclick="location.href='/prod'">검색 초기화</button>
        </div>

    </div>
</form>

<!-- 목록 테이블 -->
<div class="tbl-box">
    <table class="stk-tbl">
        <thead>
            <tr>
                <th class="col-no">번호</th>
                <th>계획번호</th>
                <th>품목</th>
                <th>품목분류</th>
                <th>계획수량</th>
                <th>생산수량</th>
                <th>생산일자</th>
                <th>생산마감</th>
                <th>진행률</th>
                <th>상태</th>
                <th>담당자</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="prod" items="${list}" varStatus="vs">
                        <tr>
                            <td class="num-cell">
                                ${(page.page - 1) * page.size + vs.count}
                            </td>
                            <td><a href="/prod/${prod.plan_id}" class="link-txt">${prod.plan_id}</a></td>
                            <td>${prod.item_name}</td>
                            <td><c:choose>
                                <c:when test="${prod.type == 'PRODUCT'}">완제품</c:when>
                                <c:when test="${prod.type == 'SEMIPRODUCT'}">반제품</c:when>
                                <c:otherwise>${prod.type}</c:otherwise>
                            </c:choose></td>
                            <td>${prod.plan_qty}</td>
                            <td>${prod.order_qty_sum > 0 ? prod.order_qty_sum : '-'}</td>
                            <td><fmt:formatDate value="${prod.plan_start}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${prod.plan_end}"   pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatNumber
                                    value="${prod.plan_qty > 0 ? (prod.currentqty / prod.plan_qty * 100 > 100 ? 100 : prod.currentqty / prod.plan_qty * 100) : 0}"
                                    maxFractionDigits="1" />%</td>
                            <td>
                                <span class="badge <c:choose><c:when test="${prod.plan_status == '대기'}">badge-wait</c:when><c:when test="${prod.plan_status == '진행'}">badge-progress</c:when><c:when test="${prod.plan_status == '완료'}">badge-done</c:when><c:when test="${prod.plan_status == '취소'}">badge-cancel</c:when></c:choose>">${prod.plan_status}</span>
                            </td>
                            <td>${prod.ename}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="11" class="empty-cell">등록된 생산계획이 없습니다.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<!-- 페이지네이션 -->
<div class="pg-wrap">
    <c:if test="${page.page > 1}">
        <a href="/prod?page=${page.page-1}&startDate=${page.startDate}&endDate=${page.endDate}&plan_status=${page.plan_status}&item_type=${page.item_type}&item_num=${page.item_num}&keyword=${page.keyword}"
           class="pg-btn">이전</a>
    </c:if>
    <c:forEach begin="${page.startPage}" end="${page.endPage}" var="p">
        <a href="/prod?page=${p}&startDate=${page.startDate}&endDate=${page.endDate}&plan_status=${page.plan_status}&item_type=${page.item_type}&item_num=${page.item_num}&keyword=${page.keyword}"
           class="pg-btn ${page.page == p ? 'pg-active' : ''}">${p}</a>
    </c:forEach>
    <c:if test="${page.page < page.totalPages}">
        <a href="/prod?page=${page.page+1}&startDate=${page.startDate}&endDate=${page.endDate}&plan_status=${page.plan_status}&item_type=${page.item_type}&item_num=${page.item_num}&keyword=${page.keyword}"
           class="pg-btn">다음</a>
    </c:if>
</div>

</div><%-- /main-cont --%>

<!-- ===== 등록 모달 ===== -->
<div id="regModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
        <h3 class="modal-title">생산계획 등록</h3>
        <form id="regForm" action="/prod/create" method="post">
            <div class="modal-grid">
                <div class="modal-field">
                    <label>계획수량</label>
                    <input type="number" name="plan_qty" placeholder="수량 입력" min="1">
                </div>
                <div class="modal-field">
                    <label>담당자</label>
                    <span class="modal-readonly">${sessionScope.loginUser.ename}</span>
                    <input type="hidden" name="emp_num" value="${sessionScope.loginUser.emp_num}">
                </div>
                <div class="modal-field">
                    <label>생산일자</label>
                    <input type="date" name="plan_start">
                </div>
                <div class="modal-field">
                    <label>생산마감</label>
                    <input type="date" name="plan_end">
                </div>
                <div class="modal-field">
                    <label>품목</label>
                    <select name="item_num">
                        <option value="">선택</option>
                        <c:forEach var="i" items="${itemList}">
                            <option value="${i.num}">${i.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="modal-field modal-field-full">
                    <label>추가지시사항</label>
                    <textarea name="content" rows="4" placeholder="추가지시사항 입력"></textarea>
                </div>
            </div>
            <div class="modal-btn-wrap">
                <button type="submit" class="btn-reg">등록</button>
                <button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
            </div>
        </form>
    </div>
</div>

<script src="/resources/js/prod/prod.js"></script>

<%--
===================================================
  [구버전 전체 HTML 구조 — 팀원 참고용 / 현재 미사용]
  Tiles 프래그먼트 전환 전 기존 코드 보존
===================================================

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생산계획 관리</title>
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
</head>
<body>

    <div class="mat-all">
        <tiles:insertAttribute name="header" ignore="true" />

        <div class="mat-body">
            <main class="main-cont">

                <div class="page-hdr">
                    <h1>생산계획 관리</h1>
                    <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
                </div>

                <form name="searchFrm" action="/prod" method="get">
                    <div class="sch-wrap">
                        <div class="sch-row-1">
                            [기간 startDate ~ endDate] + [상태 plan_status select]
                        </div>
                        <div class="sch-row-2">
                            [품목분류 item_type] | [품목명 item_num]
                        </div>
                        <div class="sch-row-3">
                            [keyword input] [검색] [초기화]
                        </div>
                    </div>
                </form>

                [목록 테이블 + 페이지네이션]

            </main>
        </div>

        <tiles:insertAttribute name="footer" ignore="true" />
    </div>

    [등록 모달]

    <script src="/resources/js/prod/prod.js"></script>

</body>
</html>
--%>
