<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>재고 관리 시스템 - 재고관리 상세</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>
/* ================= 기본 초기화 및 공통 레이아웃 (기존 동일) ================= */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
	font-family: 'Malgun Gothic', sans-serif;
}

.mat-all {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	background-color: #f4f7f6;
}

.mat-body {
	display: flex;
	flex: 1;
}

.main-cont {
	flex: 1;
	padding: 2rem 2.5rem;
	min-width: 0;
}

/* ================= 1. 상단 타이틀 & 목록 버튼 ================= */
.hdr {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #2D6A4F; 
	padding: 15px 25px;
	border-radius: 8px;
	margin-bottom: 25px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.hdr h1 {
	font-size: 1.8rem;
	color: #ffffff;
	font-weight: bold;
	letter-spacing: -1px;
}

.btn-list {
	background-color: #fff;
	color: #2D6A4F;
	padding: 10px 24px;
	border-radius: 6px;
	border: 1px solid #2D6A4F;
	font-weight: bold;
	font-size: 1.05rem;
	cursor: pointer;
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px rgba(0, 0, 0, 0.2);
	transition: background-color 0.2s;
	text-decoration: none;
	display: inline-block;
}

.btn-list:hover {
	background-color: #B7E4C7;
}

/* ================= 2. 상세 페이지 전용 섹션 스타일 ================= */
.detail-section {
	background-color: #fff;
	border: 1px solid #bbb;
	border-radius: 10px;
	padding: 25px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.section-title {
	font-size: 1.15rem;
	font-weight: bold;
	color: #333;
	margin-bottom: 15px;
	padding-bottom: 10px;
	border-bottom: 2px solid #2D6A4F;
	display: inline-block;
}

/* 2-1. 상단 요약 정보 (그리드 레이아웃) */
.info-grid-top {
    display: grid;
    grid-template-columns: repeat(5, 1fr); /* 5개 등분 */
    gap: 15px;
    margin-bottom: 20px; /* 하단 행과 간격 */
    padding-bottom: 20px;
    border-bottom: 1px solid #eee; /* 구분선 (선택사항) */
}

.info-grid-sub {
    display: grid;
    grid-template-columns: repeat(2, 200px); /* 2개 항목을 왼쪽에 배치 */
    gap: 40px; /* 두 항목 사이 간격 */
}

.info-item {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.info-label {
	font-size: 0.9rem;
	color: #777;
	font-weight: bold;
}

.info-value {
	font-size: 1.1rem;
	color: #222;
	font-weight: bold;
}

/* 2-2. 하단 상세 정보 (2단 레이아웃) */
.info-grid-bottom {
	display: grid;
	grid-template-columns: 1fr 1fr;
	row-gap: 15px;
	column-gap: 30px;
}

.info-row {
	display: flex;
	align-items: center;
	font-size: 0.95rem;
}

.info-row .label {
	width: 120px;
	font-weight: bold;
	color: #555;
}

.info-row .value {
	color: #222;
	flex: 1;
}

.value a {
	color: #2D6A4F;
	text-decoration: underline;
	font-weight: bold;
}

/* ================= 3. 데이터 테이블 ================= */
.tbl-box {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
	/* 아래 테이블 영역 박스 사이즈 늘림 (데이터 5개 이상 넉넉히 보임) 및 스크롤 생성 */
	height: 350px;
	overflow-y: auto;
}

.stk-tbl {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid #555;
	border-bottom: 2px solid #555;
}

.stk-tbl th {
	background-color: #e9ecef;
	color: #222;
	padding: 12px 10px;
	border: 1px solid #ccc;
	border-top: none;
	font-weight: bold;
	font-size: 0.95rem;
	/* 스크롤 시 헤더 상단 고정 */
	position: sticky;
	top: 0;
	z-index: 10;
}

.stk-tbl td {
	padding: 12px 10px;
	border: 1px solid #ccc;
	text-align: center;
	color: #333;
	font-size: 0.95rem;
}

.stk-tbl tbody tr:hover {
	background-color: #f1f8f5;
}
</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				
				<div class="hdr">
					<h1>재고관리 상세</h1>
					<a href="/stockSelect" class="btn-list">목록으로</a>
				</div>

				<div class="detail-section">
    <div class="info-grid-top">
        <div class="info-item">
            <span class="info-label">자재 코드</span>
            <span class="info-value">${resultList[0].CODE}</span>
        </div>
        <div class="info-item">
            <span class="info-label">자재명</span>
            <span class="info-value">${resultList[0].NAME}</span>
        </div>
        <div class="info-item">
            <span class="info-label">자재 구분</span>
            <span class="info-value">${resultList[0].TYPE}</span>
        </div>
        <div class="info-item">
            <span class="info-label">자재 단위</span>
            <span class="info-value">${resultList[0].UNIT}</span>
        </div>
        <div class="info-item">
            <span class="info-label">보관 위치</span>
            <span class="info-value">${resultList[0].FACILITY_NAME}</span>
        </div>
    </div>
    
    <div class="info-grid-sub">
        <div class="info-item">
            <span class="info-label">총 수량</span>
            <span class="info-value">${resultList[0].STOCK_QTY}</span>
        </div>
        <div class="info-item">
            <span class="info-label">안전 재고량</span>
            <span class="info-value">${resultList[0].SAFE}</span>
        </div>
    </div>
</div>

				<div class="detail-section">
					<div class="section-title">상세 내용</div>
					<div class="tbl-box">
						<table class="stk-tbl">
							<thead>
								<tr>
									<th style="width: 60px;">번호</th>
									<th>LOT 코드</th>
									<th>수량</th>
									<th>입고일</th>
									<th>유통기한</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty resultList}">
										<c:forEach var="history" items="${resultList}" varStatus="vs">
											<tr>
												<td style="font-weight: bold; color: #555;">${vs.count}</td>
												<td>${history.LOT_CODE}</td>
												<td>${history.STOCK_QTY}</td>
												<td><fmt:formatDate value="${history.LOT_DATE}" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatDate value="${history.EXPIRY_DATE}" pattern="yyyy-MM-dd" /></td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" style="padding: 30px; color: #888;">조회된 이력 데이터가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div>

			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

</body>
</html>