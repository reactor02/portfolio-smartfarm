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
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 2px 3px
		rgba(0, 0, 0, 0.2);
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

.info-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	row-gap: 25px;
	column-gap: 20px;
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

#processDesc {
	max-height: 200px;
}

.textarea-desc {
	width: 100%;
	border: 1px solid #aaa;
	border-radius: 4px;
	padding: 10px;
	font-size: 0.95rem;
	font-family: 'Malgun Gothic', sans-serif;
	outline: none;
	resize: vertical;
}

.textarea-desc:focus {
	border-color: #2D6A4F;
}

#processDesc {
	max-height: 200px;
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
					<c:if test="${sessionScope.role >= 2}">
					<button type="button" class="btn-action1" onclick="openModal()">수정</button>
					</c:if>
					<a href="/process" class="btn-list">목록으로</a>
				</div>

				<div class="detail-section">
					<div class="info-grid">
						<div class="info-item">
							<span class="info-label">공정 품목</span> <span class="info-value">${resultList[0].NAME}</span>
						</div>
						<div class="info-item">
							<span class="info-label">공정 제품 타입</span> <span class="info-value">${resultList[0].TYPE}</span>
						</div>
						<div class="info-item">
							<span class="info-label">작업 순서</span> <span class="info-value">${resultList[0].FLOW}</span>
						</div>

						<div class="info-item">
							<span class="info-label">작업 인원</span> <span class="info-value">${resultList[0].HEAD_COUNT}</span>
						</div>
						<div class="info-item">
							<span class="info-label">등록 일자</span> <span class="info-value">${resultList[0].CREATED_AT}</span>
						</div>
						<div class="info-item">
							<span class="info-label">사용 여부</span> <span class="info-value">${resultList[0].PROCESS_STATUS}</span>
						</div>
					</div>
				</div>

				<div class="detail-section">
					<div class="section-title">공정 설명</div>
					<div class="desc-container">

						<c:forEach var="detail" items="${resultList}">
							<div class="desc-image-area">
								<img src="data:image/png;base64,${detail.base64Image}"
									alt="공정 이미지" onerror="this.style.display='none'">
							</div>
						</c:forEach>
						<div class="desc-content-area">
							${resultList[0].PROCESS_CONTENT}</div>
					</div>
				</div>

			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<div id="bomEditModal" class="modal-overlay">
		<div class="modal-content">
			<h2>BOM 수정</h2>

			<form id="editForm" accept-charset="UTF-8"
			enctype="multipart/form-data" action="/PupdateStatus" method="post">

				<input type="hidden" name="process_num"
					value="${resultList[0].PROCESS_NUM}">
				<div class="modal-section-title">공정 정보</div>
				<div class="modal-form-grid">
					<div>
						<label class="info-label">품목명</label>
						<div class="info-value">${resultList[0].NAME}</div>
					</div>
					<div>
						<label class="info-label">작업인원</label> <input type="text" name="head_count"
							value="${resultList[0].HEAD_COUNT}">
					</div>
					<div>
						<label class="info-label">작업순서</label> <input type="text" name="flow"
							value="${resultList[0].FLOW}">
					</div>
					<div>
						<label class="info-label">상태 변경</label>
						<div class="radio-group">
							<label class="radio-label"> <input type="radio"
								name="process_status" value="사용"
								${resultList[0].PROCESS_STATUS == '사용' || resultList[0].PROCESS_STATUS == '사용중' ? 'checked' : ''}>사용
							</label> <label class="radio-label"> <input type="radio"
								name="process_status" value="미사용"
								${resultList[0].PROCESS_STATUS == '미사용' ? 'checked' : ''}>미사용
							</label>
						</div>
					</div>
				</div>

				<div class="modal-field modal-field-full"
					style="display: flex; flex-direction: row; gap: 20px; margin-top: 20px;">
					<div
						style="flex: 1; display: flex; flex-direction: column; gap: 10px;">
						<div>
							<label for="processImage">공정 이미지 첨부</label> <input type="file"
								name="image" id="processImage" accept="image/*"
								style="width: 100%; border: 1px solid #aaa; border-radius: 4px; padding: 6px; background: #fff; cursor: pointer; margin-top: 5px;"
								onchange="previewModalImage(this)">
						</div>
						<div id="imagePreviewContainer"
							style="width: 100%; min-height: 150px; border: 1px solid #ddd; border-radius: 4px; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9; overflow: hidden; flex: 1;">
							<c:choose>
								<c:when test="${not empty resultList[0].base64Image}">
									<span id="noImageText" style="display: none; color: #999; font-size: 14px;">첨부 된 이미지가 없습니다.</span>
									<img id="previewImage"
										src="data:image/png;base64,${resultList[0].base64Image}"
										alt="미리보기"
										style="max-width: 100%; max-height: 200px; object-fit: contain;">
								</c:when>
								<c:otherwise>
									<span id="noImageText" style="color: #999; font-size: 14px;">첨부 된 이미지가 없습니다.</span>
									<img id="previewImage" src="#" alt="미리보기"
										style="display: none; max-width: 100%; max-height: 200px; object-fit: contain;">
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<div style="flex: 1; display: flex; flex-direction: column;">
						<label for="processDesc">공정 설명</label>
						<textarea name="process_content" id="processDesc"
							class="textarea-desc" placeholder="해당 공정에 대한 상세 설명을 작성해주세요."
							style="margin-top: 5px; flex: 1; resize: none;">${resultList[0].PROCESS_CONTENT}</textarea>
					</div>
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
			if (confirm("수정된 내용을 저장하시겠습니까?")) {
				document.getElementById('editForm').submit();
			}
		}

		function previewModalImage(input) {
			const previewImg = document.getElementById('previewImage');
			const noImgText = document.getElementById('noImageText');
			
			if (input.files && input.files[0]) {
				const reader = new FileReader();
				reader.onload = function(e) {
					previewImg.src = e.target.result;
					previewImg.style.display = 'block';
					if(noImgText) noImgText.style.display = 'none';
				}
				reader.readAsDataURL(input.files[0]);
			} else {
				// 파일 선택을 취소했을 때 기존 이미지가 있다면 유지, 없다면 초기화 로직 구현 가능
				// 현재는 파일이 없을 경우 변경하지 않음.
			}
		}
	</script>
</body>
</html>