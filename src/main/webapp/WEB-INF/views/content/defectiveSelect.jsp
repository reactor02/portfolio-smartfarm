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
<title>불량품관리 페이지</title>
</head>
<body>

<div class="mat-all">
	<!-- header -->
	<tiles:insertAttribute name="header" ignore="true" />
	
	<!-- 타이틀 & 등록 버튼 -->
	<div class="page-hdr">
	    <h1>불량품관리</h1>
	    <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
	</div>
	                
	<!-- table -->
	<div class="tbl-box">
		<table class="tbl">
			<thead>
				<tr>
					<th style="width: 60px;">번호</th>
					<th>품목명</th>
					<th>불량사유</th>
					<th>조치방법</th>
					<th>불량품 개수</th>
					<th>승인상태</th>
					<th>검사일자</th>
				</tr>
			</thead>
			
			<tbody id="">
				<c:choose>
					<c:when test="${not empty result}">
						<c:forEach var="item" items="${result}">
							<tr>
								<td style="font-weight: bold; color: #555;">${item.defective_num}</td>
								<td>${item.code} ${item.name}</td>
								<td>${item.defective_reason}</td>
								<td>${item.defect_action}</td>
								<td>${item.io_qty}</td>
								<td>${item.defect_status}</td>
								<td>${item.io_date}</td>
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
	        <h3 class="modal-title">불량 등록</h3>
	        <form id="regForm" action="/prod/create" method="post">
	            <div class="modal-grid">
	                <div class="modal-field">
	                    <label>품목명</label>
	                   	<select name="item_num">
	                   		<option value="">선택</option>
	                   		<c:forEach var="i" items="${itemList}">
	                            <option value="${i.code}">${i.name}</option>
	                        </c:forEach>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>불량사유</label>
	                   	<select name="defect_reason">
	                   		<option value="">선택</option>
	                   		<option value="습도이상">습도이상</option>
	                   		<option value="온도이상">온도이상</option>
	                   		<option value="오염">오염</option>
	                   		<option value="바이러스 감염">바이러스 감염</option>
	                   		<option value="곰팡이 발생">곰팡이 발생</option>
	                   		<option value="변색">변색</option>
	                   		<option value="손상">손상</option>
	                   		<option value="배양실패">배양실패</option>
	                   	</select>
	                </div>
	                  <div class="modal-field">
	                    <label>조치방법</label>
	                   	<select name="defective_action">
	                   		<option value="폐기">폐기</option>
	                   		<option value="격리">격리</option>
	                   		<option value="재검사">재검사</option>
	                   		<option value="원인분석">원인분석</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>승인상태</label>
	                   	<select name="defect_status">
	                   		<option value="Y">Y</option>
	                   		<option value="N">N</option>
	                   	</select>
	                </div>
	
	            <div class="modal-btn-wrap">
	                <button type="submit" class="btn-reg">등록</button>
	                <button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
	            </div>
	            
	        </form>
	    </div>
	</div>
	
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