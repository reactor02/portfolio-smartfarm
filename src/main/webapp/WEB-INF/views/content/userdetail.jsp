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

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>재고 관리 시스템 - 재고관리 상세</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>

/* 공통 및 메인 레이아웃 */
* { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; }
.mat-all { display: flex; flex-direction: column; min-height: 100vh; background-color: #f4f7f6; }
.mat-body { display: flex; flex: 1; }
.main-cont { flex: 1; padding: 2rem 2.5rem; min-width: 0; }

/* 상단 타이틀 헤더 */
.hdr { display: flex; justify-content: space-between; align-items: center; background-color: #2D6A4F; padding: 15px 25px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, .1); }
.hdr h1 { font-size: 1.8rem; color: #fff; font-weight: bold; letter-spacing: -1px; }

/* 목록 버튼 */
.btn-list { display: inline-block; background-color: #fff; color: #2D6A4F; padding: 10px 24px; border: 1px solid #2D6A4F; border-radius: 6px; font-size: 1.05rem; font-weight: bold; text-decoration: none; cursor: pointer; box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 2px 3px rgba(0, 0, 0, .2); transition: background-color .2s; }
.btn-list:hover { background-color: #B7E4C7; }

/* 상세 페이지 전용 및 타이틀 */
.detail-section { background-color: #fff; border: 1px solid #bbb; border-radius: 10px; padding: 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }
.section-title { display: inline-block; font-size: 1.15rem; font-weight: bold; color: #333; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #2D6A4F; }

/* 상단 요약 정보 (3칸으로 변경) */
.info-grid-top { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #eee; }

/* 하단 상세 정보 (4칸으로 변경 및 너비 유연하게 수정) */
.info-grid-sub { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
.info-item { display: flex; flex-direction: column; gap: 8px; }
.info-label { font-size: .9rem; color: #777; font-weight: bold; }
.info-value { font-size: 1.1rem; color: #222; font-weight: bold; }

/* 데이터 테이블 및 스크롤 박스 */
.tbl-box { height: 350px; overflow-y: auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }
.stk-tbl { width: 100%; border-collapse: collapse; border-top: 2px solid #555; border-bottom: 2px solid #555; }

/* 테이블 헤더 (상단 고정) */
.stk-tbl th { position: sticky; top: 0; z-index: 10; background-color: #e9ecef; color: #222; padding: 12px 10px; border: 1px solid #ccc; border-top: none; font-weight: bold; font-size: .95rem; }

/* 테이블 내용 및 호버 효과 */
.stk-tbl td { padding: 12px 10px; border: 1px solid #ccc; text-align: center; color: #333; font-size: .95rem; }
.stk-tbl tbody tr:hover { background-color: #f1f8f5; }

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="hdr">
					<h1>사용자 상세</h1>
					<a href="/stockSelect" class="btn-list">목록으로</a>
				</div>

				<div class="detail-section">
					<div class="info-grid-top">
						<div class="info-item">
							<span class="info-label">사원번호</span> <span class="info-value">${list.emp_num}</span>
						</div>
						<div class="info-item">
							<span class="info-label">이름</span> <span class="info-value">${list.ename}</span>
						</div>
						<div class="info-item">
							<span class="info-label">부서</span> <span class="info-value">${list.dept_name}</span>
						</div>
					</div>

					<div class="info-grid-sub">
						<div class="info-item">
							<span class="info-label">부서번호</span> <span class="info-value">${list.dept_num}</span>
						</div>
						<div class="info-item">
							<span class="info-label">연락처</span> <span class="info-value">${list.tel}</span>
						</div>
						<div class="info-item">
							<span class="info-label">입사일</span> <span class="info-value">${list.hire_date}</span>
						</div>
						<div class="info-item">
							<span class="info-label">재직여부</span> <span class="info-value">${list.status}</span>
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
									<th>담당자</th>
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
												<td><fmt:formatDate value="${history.LOT_DATE}"
														pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatDate value="${history.EXPIRY_DATE}"
														pattern="yyyy-MM-dd" /></td>
												<td>하드코딩</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" style="padding: 30px; color: #888;">조회된
												이력 데이터가 없습니다.</td>
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