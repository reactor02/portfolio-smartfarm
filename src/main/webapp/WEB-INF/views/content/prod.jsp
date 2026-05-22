<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>생산계획 관리</title>
</head>
<body>

    <div class="mat-all">
        <tiles:insertAttribute name="header" ignore="true" />

        <div class="mat-body">
            <main class="main-cont">

                <!-- 타이틀 & 등록 버튼 -->
                <div class="hdr">
                    <h1>생산계획 관리</h1>
                    <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
                </div>

                <!-- 검색 폼 -->
                <form name="searchFrm" action="/prod" method="get">
                    <div class="sch-wrap">

                        <!-- 기간 + 상태 -->
                        <div class="sch-row">
                            <div class="sch-left">
                                <span class="label">▶ 기간</span>
                                <input type="date" name="startDate" id="startDate"
                                       value="${param.startDate}" class="form-control"
                                       onchange="validateDate()">
                                <span style="font-weight:bold;color:#666;">~</span>
                                <input type="date" name="endDate" id="endDate"
                                       value="${param.endDate}" class="form-control"
                                       onchange="validateDate()">

                                <span class="label" style="margin-left:15px;">▶ 상태</span>
                                <select name="plan_status" class="form-control">
                                    <option value="">선택</option>
                                    <option value="대기" <c:if test="${param.plan_status == '대기'}">selected</c:if>>대기</option>
                                    <option value="진행" <c:if test="${param.plan_status == '진행'}">selected</c:if>>진행</option>
                                    <option value="취소" <c:if test="${param.plan_status == '취소'}">selected</c:if>>취소</option>
                                    <option value="완료" <c:if test="${param.plan_status == '완료'}">selected</c:if>>완료</option>
                                </select>
                            </div>
                        </div>

                        <!-- 시설 + 품목 + 키워드 -->
                        <div class="sch-row">
                            <div class="sch-left">
                                <span class="label">▶ 시설</span>
                                <select name="facility_num" class="form-control">
                                    <option value="0">선택</option>
                                    <c:forEach var="f" items="${facilityList}">
                                        <option value="${f.num}"
                                            ${param.facility_num == f.num ? 'selected' : ''}>${f.name}</option>
                                    </c:forEach>
                                </select>

                                <span class="label" style="margin-left:15px;">▶ 품목명</span>
                                <select name="item_num" class="form-control">
                                    <option value="0">선택</option>
                                    <c:forEach var="i" items="${itemList}">
                                        <option value="${i.num}"
                                            ${param.item_num == i.num ? 'selected' : ''}>${i.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="sch-right">
                                <div class="sch-input-box">
                                    <span style="color:#888;">&#128269;</span>
                                    <input type="text" name="keyword"
                                           value="${param.keyword}" placeholder="계획번호 / 품목명">
                                </div>
                                <button type="submit" class="btn-sch">검색</button>
                                <button type="button" class="btn-reset"
                                        onclick="location.href='/prod'">초기화</button>
                            </div>
                        </div>

                    </div>
                </form>

                <!-- 목록 테이블 -->
                <div class="tbl-box">
                    <table class="stk-tbl">
                        <thead>
                            <tr>
                                <th style="width:60px;">번호</th>
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
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty list}">
                                    <c:forEach var="prod" items="${list}" varStatus="vs">
                                        <tr>
                                            <td style="font-weight:bold;color:#555;">
                                                ${page.totalCount - (page.page-1)*page.size - vs.count + 1}
                                            </td>
                                            <td><a href="/prod/${prod.plan_id}" >${prod.plan_id}</a></td>
                                            <td>${prod.item_name}</td>
                                            <td>${prod.plan_qty}</td>
                                            <td><fmt:formatDate value="${prod.plan_start}" pattern="yyyy-MM-dd"/></td>
                                            <td><fmt:formatDate value="${prod.plan_end}"   pattern="yyyy-MM-dd"/></td>
											<td><fmt:formatNumber
													value="${prod.plan_qty > 0 ? (prod.currentqty / prod.plan_qty * 100 > 100 ? 100 : prod.currentqty / prod.plan_qty * 100) : 0}"
													maxFractionDigits="1" />%</td>
											<td>${prod.plan_status}</td>
                                            <td>${prod.facility_name}</td>
                                            <td>${prod.ename}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
<%--                                     <c:forEach var="i" begin="1" end="5"> --%>
<!--                                         <tr> -->
<%--                                             <td style="font-weight:bold;color:#888;">${i}</td> --%>
<!--                                             <td></td><td></td><td></td><td></td> -->
<!--                                             <td></td><td></td><td></td><td></td><td></td> -->
<!--                                         </tr> -->
<%--                                     </c:forEach> --%>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션 -->
                <div class="pg-wrap">
                    <c:if test="${page.startPage > 1}">
                        <a href="/prod?page=${page.startPage-1}&startDate=${param.startDate}&endDate=${param.endDate}&plan_status=${param.plan_status}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
                           class="pg-btn">이전</a>
                    </c:if>
                    <c:forEach begin="${page.startPage}" end="${page.endPage}" var="p">
                        <a href="/prod?page=${p}&startDate=${param.startDate}&endDate=${param.endDate}&plan_status=${param.plan_status}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
                           class="pg-btn ${page.page == p ? 'pg-active' : ''}">${p}</a>
                    </c:forEach>
                    <c:if test="${page.endPage < page.totalPages}">
                        <a href="/prod?page=${page.endPage+1}&startDate=${param.startDate}&endDate=${param.endDate}&plan_status=${param.plan_status}&facility_num=${param.facility_num}&item_num=${param.item_num}&keyword=${param.keyword}"
                           class="pg-btn">다음</a>
                    </c:if>
                </div>

            </main>
        </div>

        <tiles:insertAttribute name="footer" ignore="true" />
    </div>

    <!-- ===== 등록 모달 ===== -->
    <div id="regModal" class="modal-overlay" style="display:none;">
        <div class="modal-box">
            <h3 class="modal-title">생산계획 등록</h3>
            <form id="regForm" action="/prod/create" method="post">
                <div class="modal-grid">
                    <div class="modal-field">
                        <label>계획수량</label>
                        <input type="number" name="plan_qty" placeholder="수량 입력">
                    </div>
                    <div class="modal-field">
                        <label>담당자</label>
                        <select name="emp_num">
                            <option value="">선택</option>
                            <c:forEach var="e" items="${empList}">
                                <option value="${e.num}">${e.name}</option>
                            </c:forEach>
                        </select>
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

    <script>
        /* 날짜 유효성 */
        function validateDate() {
            var start = document.getElementById('startDate').value;
            var end   = document.getElementById('endDate').value;
            if (start && end && start > end) {
                alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
                document.getElementById('endDate').value = "";
            }
        }
        /* 모달 열기/닫기 */
        document.getElementById('btnOpenModal').addEventListener('click', function() {
            document.getElementById('regModal').style.display = 'flex';
        });
        document.getElementById('btnCloseModal').addEventListener('click', function() {
            document.getElementById('regModal').style.display = 'none';
        });
        document.getElementById('regModal').addEventListener('click', function(e) {
            if (e.target === this) this.style.display = 'none';
        });
    </script>

</body>
</html>
