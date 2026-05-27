<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
    
    
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>설비관리 페이지</title>
</head>
<body>

<div class="mat-all">
	<!-- header -->
	<tiles:insertAttribute name="header" ignore="true" />
	
	<!-- 타이틀 & 등록 버튼 -->
	<div class="page-hdr">
	    <h1>설비관리로그</h1>
	    <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
	</div>
	                
	<!-- table -->
	<div class="tbl-box">
		<table class="tbl">
			<thead>
				<tr>
					<th style="width: 60px;">번호</th>
					<th>설비코드</th>
					<th>설비명</th>
					<th>상태</th>
					<th>이상여부</th>
					<th>조치사항</th>
					<th>점검날짜</th>
					<th>가동시작</th>
					<th>가동종료</th>
					<th>확인자</th>
				</tr>
			</thead>	
			
			<tbody id="">
				<c:choose>
					<c:when test="${not empty result}">
						<c:forEach var="item" items="${result}">
							<tr>
								<td style="font-weight: bold; color: #555;">${item.equip_num}</td>
								<td>${item.code}</td>
								<td>${item.name}</td>
								<td>${item.equip_status}</td>
								<td>${item.error_sign}</td>
								<td>${item.equip_action}</td>
								<td>${item.maintenance_date}</td>
								<td>${item.start_date}</td>
								<td>${item.end_date}</td>
								<td>${item.ename}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:forEach var="i" begin="1" end="10">
							<tr>
								<td style="font-weight: bold; color: #888;">${i}</td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
					
					
	<!-- paging -->
	<div id="paging-area">
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</div>
	
	<!-- footer -->
	<tiles:insertAttribute name="footer" ignore="true" />
	
	<!-- 등록 모달 -->
	<div id="regModal" class="modal-overlay" style="display:none;">
	    <div class="modal-box">
	        <h3 class="modal-title">설비관리 등록</h3>
	        <form id="regForm" action="/prod/create" method="post">
	            <div class="modal-grid">
	                <div class="modal-field">
	                    <label>설비코드(설비명)</label>
	                   	<select name="item_num">
	                   		<option value="">선택</option>
	                   		<c:forEach var="i" items="${itemList}">
	                            <option value="${i.code}">${i.name}</option>
	                        </c:forEach>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>상태</label>
	                   	<select name="equip_status">
	                   		<option value="RUNNING">RUNNING</option>
	                   		<option value="ERROR">ERROR</option>
	                   		<option value="MAINTENANCE">MAINTENANCE</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>에러여부</label>
	                   	<select name="equip_sign">
	                   		<option value="Y">Y</option>
	                   		<option value="N">N</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>조치사항</label>
	                   	<select name="equip_action">
	                   		<option value="NONE">NONE</option>
	                   		<option value="REPAIR">REPAIR</option>
	                   		<option value="CHECK">CHECK</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>가동시작일자</label>
	                   	<input type="date" name="start_date">
	                </div>
	                <div class="modal-field">
	                    <label>가동종료일자</label>
	                   	<input type="date" name="end_date">
	                </div>
	                <div class="modal-field">
	                    <label>확인자</label>
	                    <select name="emp_num">
	                        <option value="">선택</option>
	                        <c:forEach var="e" items="${empList}">
	                            <option value="${e.num}">${e.name}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	
	            <div class="modal-btn-wrap">
	                <button type="submit" class="btn-reg">등록</button>
	                <button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
	            </div>
	            </form>
</div>   
<script>
              
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