<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
    work.jsp — 작업지시 관리 목록 화면 (Tiles content fragment)
    구성: 검색 필터(기간/상태/품목/키워드) + 목록 테이블 + 페이징 + 등록 모달.
    동작 스크립트는 work/work.js, 컨트롤러는 /work (WorkController.workList).
--%>
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/work/work.css">

<div class="main-cont">

<!-- 타이틀 헤더 -->
<div class="page-hdr">
    <h1>작업지시 관리</h1>
    <%-- e_level 2 이상(팀장·사장)만 등록버튼 표시 --%>
    <c:if test="${sessionScope.loginUser.e_level >= 2}">
        <button class="btn-reg" onclick="document.getElementById('workRegModal').style.display='flex'">+ 등록하기</button>
    </c:if>
</div>

<!-- 검색 필터 -->
<form id="searchForm" method="get" action="/work">
    <div class="sch-wrap">
        <!-- 1행: 기간 -->
        <div class="sch-row-1">
            <span class="label">▶ 기간</span>
            <input type="date" name="startDate" value="${page.startDate}" class="form-control">
            <span class="date-sep">~</span>
            <input type="date" name="endDate"   value="${page.endDate}"   class="form-control">
        </div>
        <!-- 2행: 상태 | 품목분류 | 품목명 (33:33:33) -->
        <div class="sch-row-2">
            <div>
                <span class="label">▶ 상태</span>
                <select name="work_status" class="form-control">
                    <option value="">상태 선택</option>
                    <option value="대기"  <c:if test="${page.work_status == '대기'}">selected</c:if>>대기</option>
                    <option value="진행"  <c:if test="${page.work_status == '진행'}">selected</c:if>>진행</option>
                    <option value="완료"  <c:if test="${page.work_status == '완료'}">selected</c:if>>완료</option>
                    <option value="취소"  <c:if test="${page.work_status == '취소'}">selected</c:if>>취소</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 정렬순서</span>
                <select name="sort" class="form-control">
                    <option value="reg"   <c:if test="${page.sort == 'reg' || empty page.sort}">selected</c:if>>최근 등록순</option>
                    <option value="start" <c:if test="${page.sort == 'start'}">selected</c:if>>빠른 작업일순</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 품목분류</span>
                <select name="item_type" id="workItemType" class="form-control"
                        onchange="filterWorkItems()">
                    <option value="">선택</option>
                    <option value="SEMIPRODUCT" <c:if test="${page.item_type == 'SEMIPRODUCT'}">selected</c:if>>반제품</option>
                    <option value="PRODUCT"     <c:if test="${page.item_type == 'PRODUCT'}">selected</c:if>>완제품</option>
                </select>
            </div>
            <div>
                <span class="label">▶ 품목명</span>
                <select name="item_num" id="workItemNum" class="form-control">
                    <option value="0">선택</option>
                    <c:forEach var="i" items="${itemList}">
                        <option value="${i.num}" data-type="${i.type}"
                            <c:if test="${page.item_num == i.num}">selected</c:if>>${i.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <!-- 3행: 키워드 검색 (우측 정렬) -->
        <div class="sch-row-3">
            <div class="sch-input-box">
                <span class="sch-icon">&#128269;</span>
                <input type="text" name="keyword" value="${page.keyword}" placeholder="작업번호 / 품목명">
            </div>
            <button type="submit" class="btn-sch">검색</button>
            <button type="button" class="select-reset" onclick="location.href='/work'">검색 초기화</button>
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
                <th>작업코드</th>
                <th>생산계획코드</th>
                <th>품목명</th>
                <th>품목분류</th>
                <th>지시수량</th>
                <th>생산완료</th>
                <th>담당자</th>
                <th>실무자</th>
                <th>작업일</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="w" items="${list}" varStatus="s">
                        <tr>
                            <td class="num-cell">${(page.page-1)*page.size + s.index + 1}</td>
                            <td><a href="/work/${w.work_order_id}" class="link-txt">${w.work_order_id}</a></td>
                            <td>${w.plan_id}</td>
                            <td>${w.item_name}</td>
                            <td><c:choose>
                                <c:when test="${w.type == 'PRODUCT'}">완제품</c:when>
                                <c:when test="${w.type == 'SEMIPRODUCT'}">반제품</c:when>
                                <c:otherwise>${w.type}</c:otherwise>
                            </c:choose></td>
                            <td>${w.order_qty}</td>
                            <td>${w.current_qty}</td>
                            <td>${w.ename}</td>
                            <td>${w.worker_ename}</td>
                            <td><fmt:formatDate value="${w.order_start}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <span class="badge <c:choose><c:when test="${w.work_status == '대기'}">badge-wait</c:when><c:when test="${w.work_status == '진행'}">badge-progress</c:when><c:when test="${w.work_status == '완료'}">badge-done</c:when><c:when test="${w.work_status == '취소'}">badge-cancel</c:when></c:choose>">${w.work_status}</span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="11" class="empty-cell">등록된 작업지시가 없습니다.</td></tr>
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

<!-- ===== 등록 모달 ===== -->
<div id="workRegModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
        <h3 class="modal-title">작업지시 등록</h3>
        <form action="/work" method="post">
            <div class="modal-grid">
                <div class="modal-field">
                    <label>생산계획</label>
                    <div class="plan-select-wrap">
                        <input type="text" id="planDisplay" readonly placeholder="계획 선택 후 표시"
                               class="plan-display-input">
                        <input type="hidden" name="plan_num" id="planNumInput">
                        <input type="hidden" id="planStartInput">
                        <input type="hidden" id="planEndInput">
                        <button type="button" onclick="openPlanModal()"
                                class="btn-search-sm">검색</button>
                    </div>
                </div>
                <div class="modal-field">
                    <label>담당자</label>
                    <span class="modal-readonly">${sessionScope.loginUser.ename}</span>
                    <input type="hidden" name="emp_num" value="${sessionScope.loginUser.emp_num}">
                </div>
                <div class="modal-field">
                    <label>실무자</label>
                    <select name="worker_num" class="form-control" required>
                        <option value="">실무자 선택</option>
                        <c:forEach var="w" items="${workerList}">
                            <option value="${w.num}">${w.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="modal-field">
                    <label>지시수량</label>
                    <input type="number" name="order_qty" min="1" required>
                </div>
                <div class="modal-field">
                    <label>작업시작일</label>
                    <input type="date" name="order_start" id="orderStartInput" required>
                </div>
                <div class="modal-field modal-field-full">
                    <label>지시사항</label>
                    <textarea name="content" placeholder="지시사항 입력"></textarea>
                </div>
            </div>
            <div class="modal-btn-wrap">
                <button type="submit" class="btn-reg" onclick="return validateReg()">등록</button>
                <button type="button" class="btn-cancel"
                        onclick="document.getElementById('workRegModal').style.display='none'">취소</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== 생산계획 검색 모달 ===== -->
<div id="planSearchModal" class="modal-overlay modal-overlay-top" style="display:none;">
    <div class="modal-box modal-box-lg">
        <h3 class="modal-title">생산계획 검색</h3>

        <!-- 검색 입력 -->
        <div class="modal-search-bar">
            <input type="text" id="planKeyword" placeholder="계획번호 / 품목명"
                   class="modal-search-input">
            <button type="button" onclick="searchPlans(1)"
                    class="btn-modal-search">검색</button>
        </div>

        <!-- 결과 테이블 -->
        <table class="stk-tbl plan-tbl">
            <thead>
                <tr>
                    <th>계획번호</th>
                    <th>품목명</th>
                    <th>계획수량</th>
                    <th>시작일</th>
                    <th>마감일</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody id="planSearchBody">
                <tr><td colspan="6" class="empty-modal-cell">검색어를 입력하거나 검색 버튼을 누르세요.</td></tr>
            </tbody>
        </table>

        <!-- 페이지네이션 -->
        <div class="pg-wrap plan-pagination" id="planPagination"></div>

        <div class="modal-btn-wrap modal-btn-wrap-mt">
            <button type="button" class="btn-cancel"
                    onclick="document.getElementById('planSearchModal').style.display='none'">닫기</button>
        </div>
    </div>
</div>

</div>

<script src="/resources/js/work/work.js"></script>
