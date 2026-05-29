<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<aside class="side">
	<ul class="nav-list">
		<li class="nav-item"><a href="/dashboard" class="nav-btn">대시보드</a></li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">기준 관리</div>
			<ul class="sub-nav">
				<li><a href="">공통 코드 관리</a></li>
				<li><a href="/stockSelect">자재 관리</a></li>
				<li><a href="/selectBom">BOM 관리</a></li>
				<li><a href="/process">공정 관리</a></li>
				<li><a href="/facility">시설 관리</a></li>
				<li><a href="/equip">설비 관리</a></li>
				<li><a href="/vender">거래처 관리</a></li>
				<li><a href="">사용자/권한 관리</a></li>
			</ul>
		</li>
		<li class="nav-item">
			<div class="nav-btn toggle-btn">생산 관리</div>
			<ul class="sub-nav">
				<li><a href="">생산 계획</a></li>
				<li><a href="">작업 지시</a></li>
				<li><a href="">실적 등록</a></li>
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
		<li class="nav-item">
			<div class="nav-btn toggle-btn">이력 및 추적 관리</div>
			<ul class="sub-nav">
				<li><a href="">Lot 번호 관리</a></li>
				<li><a href="">이력 추적</a></li>
			</ul>
		</li>
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
	</ul>
</aside>