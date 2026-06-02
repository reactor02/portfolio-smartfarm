<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	 <%request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8;"); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<aside class="side">
	<ul class="nav-list">
		<li class="nav-item"><a href="/dashboard" class="nav-btn">대시보드</a></li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">기준 관리</div>
			<ul class="sub-nav">
				<li><a href="/codemanage">공통 코드 관리</a></li>
				<li><a href="/stockSelect">자재 관리</a></li>
				<li><a href="/selectBom">BOM 관리</a></li>
				<li><a href="/process">공정 관리</a></li>
				<li><a href="/facility">시설 관리</a></li>
				<li><a href="/equip">설비 관리</a></li>
				<li><a href="/vender">거래처 관리</a></li>
			</ul>
		</li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">생산 관리</div>
			<ul class="sub-nav">
				<li><a href="/prod">생산 계획</a></li>
				<li><a href="/work">작업 지시</a></li>
			</ul>
		</li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">품질 관리</div>
			<ul class="sub-nav">
				<li><a href="/qc">품질 검사</a></li>
				<li><a href="/defective">불량 관리</a></li>
			</ul>
		</li>
		<!--         <li class="nav-item"> -->
		<!--             <div class="nav-btn toggle-btn">창고 관리</div> -->
		<!--             <ul class="sub-nav"> -->
		<!--                 <li><a href="">입/출고 관리</a></li> -->
		<!--                 <li><a href="">재고 현황</a></li> -->
		<!--             </ul> -->
		<!--         </li> -->
		<li class="nav-item"><a href="/lot" class="nav-btn">LOT 관리</a></li>
		<li class="nav-item"><a href="/io" class="nav-btn">입고/출고 관리</a></li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">출하 관리</div>
			<ul class="sub-nav">
				<li><a href="/request">주문 관리</a></li>
				<li><a href="/shipment">출하 관리</a></li>
			</ul>
		</li>
		<li class="nav-item"><a href="/board" class="nav-btn">게시판</a></li>
		<li class="nav-item"><a href="/report" class="nav-btn">리포트</a></li>
		<c:if test="${not empty sessionScope.loginUser && (sessionScope.role == 3 || sessionScope.role == 4)}">
    <li class="nav-item"><a href="/usermanage" class="nav-btn">사용자 관리</a></li>
</c:if>
	
		</ul>
</aside>