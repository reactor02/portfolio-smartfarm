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

/* 수정된 그리드 레이아웃: 한 줄에 3개씩, 균등한 간격으로 배치 */
.info-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr); /* 3개의 열을 동일한 비율로 분할 */
    row-gap: 25px; /* 위아래 줄 간격 */
    column-gap: 20px; /* 좌우 항목 간격 */
    width: 100%;
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

.desc-container {
	display: flex;
	gap: 20px;
	height: 350px;
}

.desc-image-area {
	flex: 1;
	border: 1px solid #ccc;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	background-color: #f9f9f9;
}

.desc-image-area img {
	width: 100%;
	height: 100%;
	object-fit: contain;
}

.desc-content-area {
	flex: 1;
	border: 1px solid #ccc;
	border-radius: 8px;
	padding: 15px;
	overflow-y: auto;
	font-size: 0.95rem;
	line-height: 1.6;
	color: #333;
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

.btn-action1 {
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
	margin-left: 475px;
}

.btn-action1:hover {
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

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				
				<div class="hdr">
					<h1>공정 관리 상세</h1>
					<button type="button" class="btn-action1" onclick="openModal()">수정</button>
					<a href="/process" class="btn-list">목록으로</a>
				</div>

				<div class="detail-section">
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">공정 품목</span>
                            <span class="info-value">${resultList[0].NAME}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">공정 제품 타입</span>
                            <span class="info-value">${resultList[0].TYPE}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">작업 순서</span>
                            <span class="info-value">${resultList[0].FLOW}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">작업 인원</span>
                            <span class="info-value">${resultList[0].HEAD_COUNT}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">등록 일자</span>
                            <span class="info-value">${resultList[0].CREATED_AT}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">사용 여부</span>
                            <span class="info-value">${resultList[0].PROCESS_STATUS}</span>
                        </div>
                    </div>
                </div>

				<div class="detail-section">
					<div class="section-title">공정 설명</div>
					<div class="desc-container">
						<div class="desc-image-area">
							<img src="/displayImage?fileName=${resultList[0].IMAGE}" alt="공정 이미지" onerror="this.style.display='none'">
						</div>
						<div class="desc-content-area">
							${resultList[0].PROCESS_CONTENT}
						</div>
					</div>
				</div>

			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>




<!-- 		모달영역 -->

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

</script>
</body>
</html>