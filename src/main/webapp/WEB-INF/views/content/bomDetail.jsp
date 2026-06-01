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
<title>제조 관리 시스템 - BOM 상세</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>
/* ================= 기본 초기화 및 공통 레이아웃 ================= */
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

/* ================= 1. 상단 타이틀 & 버튼 ================= */
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

.hdr-left {
	flex: 1;
}

.hdr-center {
	flex: 1;
	text-align: center;
}

.hdr-right {
	flex: 1;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.hdr h1 {
	font-size: 1.8rem;
	color: #ffffff;
	font-weight: bold;
	letter-spacing: -1px;
	margin: 0;
}

.btn-action {
	background-color: #fff;
	color: #2D6A4F;
	padding: 10px 24px;
	border-radius: 6px;
	border: 1px solid #2D6A4F;
	font-weight: bold;
	font-size: 1.05rem;
	cursor: pointer;
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px
		rgba(0, 0, 0, 0.2);
	transition: all 0.2s ease-in-out;
	text-decoration: none;
	display: inline-block;
}

.btn-action:hover {
	background-color: #B7E4C7;
	color: #1b4332;
	border-color: #B7E4C7;
}

.btn-del {
	color: #dc3545;
	border-color: #dc3545;
}

.btn-del:hover {
	background-color: #dc3545;
	color: #fff;
	border-color: #dc3545;
}

/* ================= 2. 공통 섹션 스타일 ================= */
.detail-section {
	background-color: #fff;
	border: 1px solid #e0e0e0;
	border-radius: 10px;
	padding: 25px;
	margin-bottom: 25px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
}

.section-title {
	font-size: 1.2rem;
	font-weight: bold;
	color: #1b4332;
	margin-bottom: 20px;
	padding-bottom: 10px;
	border-bottom: 2px solid #2D6A4F;
	display: inline-block;
}

/* 2-1. 기본 정보 (규격 통일 및 박스 디자인 적용) */
.info-grid-top {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-bottom: 20px;
	padding-bottom: 20px;
	border-bottom: 1px dashed #ccc;
}

.info-grid-sub {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
}

.info-item {
	display: flex;
	flex-direction: column;
	justify-content: center;
	gap: 10px;
	background-color: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	border: 1px solid #e9ecef;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.02);
	height: 100%; /* 박스 높이 규격 맞춤 */
}

.info-label {
	font-size: 0.95rem;
	color: #666;
	font-weight: bold;
}

.info-value {
	font-size: 1.15rem;
	color: #222;
	font-weight: bold;
}

.status-badge {
	background-color: #3b5bdb;
	color: #fff;
	font-size: 0.85rem;
	padding: 4px 12px;
	border-radius: 20px;
}

/* ================= 3. AI 빅데이터 기반 로스율 예측 조회 (새로운 디자인) ================= */
.ai-dashboard {
	display: flex;
	gap: 20px;
	background-color: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	border: 1px solid #e9ecef;
	align-items: stretch;
}

/* AI 섹션 내부 공통 카드 스타일 */
.ai-card {
	background: #fff;
	border-radius: 8px;
	padding: 20px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	border: 1px solid #e0e0e0;
	display: flex;
	flex-direction: column;
}

/* 왼쪽: 입력부 */
.ai-input-wrap {
	flex: 1.2;
}

.ai-input-group {
	margin-bottom: 12px;
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.ai-input-group label {
	font-size: 0.85rem;
	font-weight: bold;
	color: #555;
}

.ai-input-group input {
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 0.95rem;
	transition: border-color 0.2s;
}

.ai-input-group input:focus {
	outline: none;
	border-color: #2D6A4F;
}

.ai-btn {
	margin-top: 10px;
	background-color: #1b4332;
	color: #fff;
	border: none;
	padding: 12px;
	border-radius: 4px;
	font-weight: bold;
	font-size: 1rem;
	cursor: pointer;
	transition: background 0.2s;
	text-align: center;
}

.ai-btn:hover {
	background-color: #081c15;
}

/* 중간: 진행 화살표 */
.ai-arrow-wrap {
  display: flex;
  cursor: pointer;
  font-size: 60px; /* 크기 조절 */
  color:  #2D6A4F;     /* 기본 색상 */
  margin-top: 155px;
  /* 위아래 움직임 애니메이션 적용 */
  animation: floating 1.5s ease-in-out infinite;
  
  /* 블러 및 세련된 효과 */
  text-shadow: 0 0 8px rgba(0, 0, 0, 0.2);
  transition: color 0.3s ease;
}

.ai-arrow-wrap:hover {
  color:  #B7E4C7; /* 마우스 올렸을 때 색상 변경 */
}

/* 애니메이션 정의 */
@keyframes floating {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-10px); } /* 위로 10px 이동 */
  100% { transform: translateY(0px); }
}

/* 오른쪽: 데이터 확인 및 결과부 래퍼 */
.ai-result-container {
	flex: 2;
	display: flex;
	gap: 15px;
}

/* 중간: 입력 데이터 확인부 */
.ai-preview-wrap {
	flex: 1;
	justify-content: center;
	gap: 15px;
}

.preview-row {
	display: flex;
	justify-content: space-between;
	border-bottom: 1px dashed #eee;
	padding-bottom: 8px;
}

.preview-row:last-child {
	border-bottom: none;
	padding-bottom: 0;
}

.preview-label {
	color: #777;
	font-size: 0.9rem;
}

.preview-val {
	font-weight: bold;
	color: #333;
}

/* 오른쪽: 최종 예측 결과 강조부 */
.ai-final-wrap {
	flex: 1;
	background: linear-gradient(135deg, #2D6A4F, #1b4332); /* 테마색 강조 */
	border: none;
	color: #fff;
	justify-content: center;
	align-items: center;
	text-align: center;
}

.ai-final-wrap span {
	font-size: 1.1rem;
	color: #d8f3dc;
	margin-bottom: 10px;
	font-weight: bold;
}

.ai-final-wrap strong {
	font-size: 3rem;
	color: #fff;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

/* ================= 4. 데이터 테이블 ================= */
.tbl-box {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
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

/* ================= 5. 모달 ================= */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 999;
	justify-content: center;
	align-items: center;
}

.modal-content {
	background: #fff;
	width: 800px;
	border-radius: 10px;
	padding: 30px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.modal-content h2 {
	margin-bottom: 20px;
	font-size: 1.5rem;
	color: #2D6A4F;
	border-bottom: 2px solid #2D6A4F;
	padding-bottom: 10px;
}

.modal-section-title {
	font-size: 1.1rem;
	font-weight: bold;
	color: #2D6A4F;
	margin: 20px 0 10px 0;
}

.modal-form-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
	margin-bottom: 20px;
}

.modal-form-grid input {
	padding: 8px;
	border: 1px solid #ccc;
	border-radius: 4px;
	width: 100%;
}

.modal-input-qty {
	width: 80px;
	padding: 5px;
	text-align: right;
}

.modal-btns {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 30px;
}

.modal-btns button {
	padding: 10px 30px;
	font-size: 1.1rem;
	font-weight: bold;
	border-radius: 6px;
	cursor: pointer;
	border: 1px solid #999;
}

.btn-save {
	background-color: #2D6A4F;
	color: #fff;
	border-color: #2D6A4F;
}

.btn-cancel {
	background-color: #fff;
	color: #555;
}

.btn-save:hover {
	background-color: #1b4332;
}

.btn-cancel:hover {
	background-color: #f1f1f1;
}

.radio-group {
	display: flex;
	gap: 20px;
	margin-top: 10px;
}

.radio-label {
	display: flex;
	align-items: center;
	cursor: pointer;
	font-size: 0.95rem;
	color: #222;
}

.modal-form-grid input[type="radio"] {
	appearance: none;
	-webkit-appearance: none;
	width: 20px;
	height: 20px;
	border: 2px solid #ccc;
	border-radius: 50%;
	margin: 0;
	margin-right: 8px;
	padding: 0;
	transition: all 0.2s;
	position: relative;
	cursor: pointer;
}

.modal-form-grid input[type="radio"]:checked {
	border-color: #2D6A4F;
}

.modal-form-grid input[type="radio"]:checked::after {
	content: '';
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 10px;
	height: 10px;
	background-color: #2D6A4F;
	border-radius: 50%;
}

.modal-form-grid .status-container {
	grid-column: 1/-1;
}
</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="hdr">
					<h1>BOM 상세</h1>
					<div class="hdr-right">
					<c:if test="${sessionScope.role >= 2}">
						<button type="button" class="btn-action" onclick="openModal()">수정</button>
					</c:if>
						<a href="/selectBom" class="btn-action">목록으로</a>
					</div>
				</div>

				<div class="detail-section">
					<div class="section-title">기본 정보</div>
					<div class="info-grid-top">
						<div class="info-item">
							<span class="info-label">대상 품목명</span> <span class="info-value">${resultList[0].NAME}</span>
						</div>
						<div class="info-item">
							<span class="info-label">BOM 코드</span> <span class="info-value">${resultList[0].BOM_CODE}</span>
						</div>
						<div class="info-item">
							<span class="info-label">상태</span>
							 <span class="info-value">
							 <c:choose>
										<c:when test="${resultList[0].BOM_STATUS eq 'Y'}"><span class="status-badge">사용중</span></c:when>
										<c:otherwise><span class="status-badge" style="backgroundcolor:  #FFB703">미사용</span></c:otherwise>
									</c:choose>
									
									
									</span>
						</div>
						<div class="info-item">
							<span class="info-label">등록일</span> <span class="info-value">
								<fmt:formatDate value="${resultList[0].CREATED_AT}"
									pattern="yyyy-MM-dd" />
							</span>
						</div>
					</div>

					<div class="info-grid-sub">
						<div class="info-item">
							<span class="info-label">기준 생산 수량</span> <span class="info-value">${resultList[0].REQUIRED_QTY}</span>
						</div>
						<div class="info-item">
							<span class="info-label">단위</span> <span class="info-value">${resultList[0].UNIT}</span>
						</div>
						<div class="info-item">
							<span class="info-label">생산 품목 종류</span> <span class="info-value">${resultList[0].TYPE}</span>
						</div>
					</div>
				</div>

				<div class="detail-section">
					<div class="section-title">AI 빅데이터 기반 로스율 예측 조회</div>

					<input type="hidden" id="aiItemNum"
						value="${resultList[0].ITEM_NUM}">

					<div class="ai-dashboard">
						<div class="ai-card ai-input-wrap">
							<div class="ai-input-group">
								<label for="aiTargetQty">목표 생산 개수</label> <input type="number"
									id="aiTargetQty" value="${resultList[0].REQUIRED_QTY}"
									placeholder="예: 1000">
							</div>
							<div class="ai-input-group">
								<label for="aiTemp">작업장 온도 (°C)</label> <input type="number"
									id="aiTemp" placeholder="예: 24">
							</div>
							<div class="ai-input-group">
								<label for="aiHumidity">작업장 습도 (%)</label> <input type="number"
									id="aiHumidity" placeholder="예: 45">
							</div>
							<div class="ai-input-group">
								<label for="aiDate">작업 계획 날짜</label> <input type="date"
									id="aiDate" value="">
							</div>
							<button type="button" class="ai-btn" onclick="predictLoss()">AI
								예측 실행</button>
						</div>

						<div class="ai-arrow-wrap">▶</div>

						<div class="ai-result-container">
							<div class="ai-card ai-preview-wrap">
								<div class="preview-row">
									<span class="preview-label">생산 개수</span> <span
										class="preview-val" id="pvQty">-- 개</span>
								</div>
								<div class="preview-row">
									<span class="preview-label">설정 온도</span> <span
										class="preview-val" id="pvTemp">-- °C</span>
								</div>
								<div class="preview-row">
									<span class="preview-label">설정 습도</span> <span
										class="preview-val" id="pvHumidity">-- %</span>
								</div>
								<div class="preview-row">
									<span class="preview-label">계획 날짜</span> <span
										class="preview-val" id="pvDate">YYYY-MM-DD</span>
								</div>
							</div>

							<div class="ai-card ai-final-wrap">
								<span>예상 총 로스율</span> <strong id="pvResult">0%</strong>
							</div>
						</div>
					</div>
				</div>

				<div class="detail-section">
					<div class="section-title">투입 자재 리스트</div>
					<div class="tbl-box">
						<table class="stk-tbl">
							<thead>
								<tr>
									<th style="width: 80px;">번호</th>
									<th>자재명</th>
									<th>자재코드</th>
									<th>소요량</th>
									<th>단위</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty resultList}">
										<c:forEach var="mat" items="${resultList}" varStatus="vs">
											<tr>
												<td style="font-weight: bold; color: #555;">${vs.count}</td>
												<td>${mat.CNAME}</td>
												<td>${mat.CCODE}</td>
												<td>${mat.CHILD_QTY}</td>
												<td>${mat.CUNIT}</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="5" style="padding: 30px; color: #888;">투입되는
												자재 데이터가 없습니다.</td>
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

	<div id="bomEditModal" class="modal-overlay">
		<div class="modal-content">
			<h2>BOM 수정</h2>

			<form id="editForm" action="/updateStatus" method="post">

				<input type="hidden" name="bom_num" value="${resultList[0].BOM_NUM}">
				<div class="modal-section-title">생산품 정보</div>
				<div class="modal-form-grid">
					<div>
						<label class="info-label">품목명</label>
						<div class="info-value">${resultList[0].NAME}</div>
					</div>
					<div>
						<label class="info-label">기준 생산 수량</label>
						<div class="info-value">${resultList[0].REQUIRED_QTY}</div>
					</div>
					<div class="status-container">
						<label class="info-label">상태 변경</label>
						<div class="radio-group">
							<label class="radio-label"> <input type="radio"
								name="bom_status" value="Y"
								${resultList[0].BOM_STATUS == 'Y' ? 'checked' : ''}>사용
							</label> <label class="radio-label"> <input type="radio"
								name="bom_status" value="N"
								${resultList[0].BOM_STATUS == 'N' ? 'checked' : ''}>미사용
							</label>
						</div>
					</div>
				</div>

				<div class="modal-section-title"
					style="border-top: 1px dashed #ccc; padding-top: 15px;">| 2.
					소요 자재</div>
				<div class="tbl-box" style="height: 250px;">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th>자재명</th>
								<th>자재코드</th>
								<th>단위</th>
								<th style="width: 100px;">소요수량</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="mat" items="${resultList}" varStatus="vs">
								<tr>
									<td>${mat.CNAME}</td>
									<td>${mat.CCODE}</td>
									<td>${mat.CUNIT}</td>
									<td>${mat.CHILD_QTY}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="modal-btns">
					<button type="button" class="btn-save" onclick="submitEdit()">수정</button>
					<button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		function openModal() {
			document.getElementById('bomEditModal').style.display = 'flex';
		}

		function closeModal() {
			location.reload();
		}

		function submitEdit() {
			if(confirm("수정된 내용을 저장하시겠습니까?")) {
				document.getElementById('editForm').submit();
			}
		}

		function deleteBOM() {
			if(confirm("정말로 이 BOM 데이터를 삭제하시겠습니까?")) {
				location.href = "/bomDelete?BOM_CODE=${resultMap.BOM_CODE}";
			}
		}

		function predictLoss() {
		    let itemNum = document.getElementById('aiItemNum').value;
		    let qty = document.getElementById('aiTargetQty').value;
		    let temp = document.getElementById('aiTemp').value;
		    let hum = document.getElementById('aiHumidity').value;
		    let date = document.getElementById('aiDate').value;

		    if (!qty || !temp || !hum) {
		        alert("목표 생산 개수, 작업장 온도, 작업장 습도를 모두 입력해 주세요.");
		        return;
		    }

		    // 프리뷰 즉시 반영
		    document.getElementById('pvQty').innerText = qty + ' 개';
		    document.getElementById('pvTemp').innerText = temp + ' °C';
		    document.getElementById('pvHumidity').innerText = hum + ' %';
		    document.getElementById('pvDate').innerText = date || 'YYYY-MM-DD';
		    
		    document.getElementById('pvResult').innerText = "계산 중...";

		    // 컨트롤러(BomDTO) 양식에 맞춰 데이터 구성
		    const requestData = {
		        item_num: parseInt(itemNum),
		        count: parseInt(qty),
		        temp: parseFloat(temp),
		        humid: parseFloat(hum)
		    };

		    // 실제 자바 컨트롤러 호출
		    fetch('/predict-loss', { 
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/json'
		        },
		        body: JSON.stringify(requestData)
		    })
		    .then(response => response.json())
		    .then(data => {
		        if (data.predicted_loss !== undefined) {
		            // AI가 예측한 결과를 진짜 화면에 반영
		            document.getElementById('pvResult').innerText = data.predicted_loss + "%";
		        } else if (data.error) {
		            alert("예측 실패: " + data.error);
		            document.getElementById('pvResult').innerText = "에러";
		        }
		    })
		    .catch(error => {
		        console.error('Error:', error);
		        alert("서버 통신 오류가 발생했습니다.");
		        document.getElementById('pvResult').innerText = "--%";
		    });
		}
	</script>
</body>
</html>