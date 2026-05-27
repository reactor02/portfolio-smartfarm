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
<title>Insert title here</title>
</head>
<body>
<!-- table -->
<div class="tbl-box">
	<table class="tbl">
		<thead>
			<tr>
				<th style="width: 60px;">번호</th>
				<th>품목명</th>
				<th>검사일</th>
				<th>검사구분</th>
				<th>통과여부</th>
				<th>자재량</th>
			</tr>
		</thead>	
		
		<tbody id="">
			<c:choose>
				<c:when test="${not empty result}">
					<c:forEach var="item" items="${result}">
						<tr>
							<td style="font-weight: bold; color: #555;">${item.io_num}</td>
							<td>${item.code} ${item.name}</td>
							<td>${item.io_date}</td>
							<td>${item.qc_type}</td>
							<td>${item.qc_pass}</td>
							<td>${item.io_qty}${item.unit}</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<c:forEach var="i" begin="1" end="5">
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

</body>

</html>