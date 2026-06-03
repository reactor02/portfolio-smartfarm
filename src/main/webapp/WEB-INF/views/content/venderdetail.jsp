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
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

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
	margin: 20px;
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

/* 작업 등록 모달 */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	justify-content: center;
	align-items: center;
}

.modal-box {
	background: #fff;
	border-radius: 10px;
	padding: 30px;
	width: 520px;
	max-height: 90vh;
	overflow-y: auto;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.modal-title {
	font-size: 1.2rem;
	font-weight: bold;
	color: var(- -m-cl);
	margin-bottom: 20px;
}

.modal-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 16px;
}

.modal-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.modal-field label {
	font-size: 12px;
	color: #777;
	font-weight: bold;
}

.modal-field input, .modal-field select, .modal-field textarea {
	padding: 8px 10px;
	border: 1px solid var(- -border-cl);
	border-radius: 6px;
	font-size: 13px;
	font-family: inherit;
}

.modal-field-full {
	grid-column: 1/-1;
}

.modal-btn-wrap {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 20px;
}

.modal-btn-wrap button {
	padding: 9px 22px;
	border
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

.btn-group {
    display: flex;
    gap: 10px; /* 버튼 사이 간격 */
}
.mar {
	display : block;
	margin-bottom : 20px;
}
</style>
</head>
<body>


	<main class="main-cont">
		<!--  페이지 헤더 -->

		<div class="hdr">
			<h1>거래처 페이지 상세</h1>
			
			<div class="btn-group">
			<c:if test="${sessionScope.role >= 2}">
				<button type="button" class="btn-action1" id="btnOpenWorkModal">수정</button>
				<button type="button" class="btn-action1" onclick="deleteVender()">삭제</button>

				<form id="deleteForm" action="/vender/delete" method="post">
					<input type="hidden" name="vender_num"
						value="${venderDTO.vender_num}">
				</form>
			</c:if>
			<a href="/vender" class="btn-list">목록으로</a>
			</div>
		</div>

		<!-- 1. 기본 정보 -->
		<div class="detail-section">
		
		<div class="info-grid">
			<div class="info-item">
				<span class="info-label">거래처명</span><span class="info-value">${venderDTO.vender_name}</span>
			</div>
			<div class="info-item">
				<span class="info-label">대표자명</span><span class="info-value">${venderDTO.ven_ename}</span>
			</div>
			<div class="info-item">
				<span class="info-label">사업자등록번호</span><span class="info-value">${venderDTO.biz_no}</span>
			</div>
			<div class="info-item">
				<span class="info-label">거래처타입</span><span class="info-value">${venderDTO.vender_type}</span>
			</div>
			<div class="info-item">
				<span class="info-label">연락처</span><span class="info-value">${venderDTO.vender_phone}</span>
			</div>
			<div class="info-item">
				<span class="info-label">주소</span><span class="info-value">${venderDTO.vender_addr}</span>
			</div>
			<div class="info-item">
				<span class="info-label">담당 사원</span><span class="info-value">${venderDTO.ename}</span>
			</div>
		</div>
		</div>

		<!-- 2. 거래처 지도API -->
		<div class="detail-section"><span class="mar">■ 거래처 위치</span>

		<div id="map" style="width: 100%; height: 350px;"></div>
		
		</div>

		<!--  3. 거래처 이력 -->
		<div class="detail-section"><span class="mar">■ 거래처 이력</span>
		<div>
			<table class="stk-tbl">
						<thead>
							<tr>
								<th class="col-no">번호</th>
								<th>요청번호</th>
								<th>납기일</th>
								<th>거래처명</th>
								<th>품목명</th>
								<th>수량</th>
								<th>담당자</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody id="request-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}" varStatus="vs">
										<tr>
											<td class="num-cell">${vs.count}</td>
											<td><a href="/requestDetail/${item.REQUEST_ID}" class="link-id">${item.REQUEST_ID}</a></td>
											<td>${item.DUE_DATE}</td>
											<td>${item.VENDER_NAME}</td>
											<td>${item.NAME}</td>
											<td>${item.REQUEST_QTY}</td>
											<td>${item.ENAME}</td>
											<td>
												<span class="badge
													<c:choose>
														<c:when test="${item.REQUEST_STATUS == '접수'}">badge-progress</c:when>
														<c:when test="${item.REQUEST_STATUS == '출하대기'}">badge-waiting</c:when>
														<c:when test="${item.REQUEST_STATUS == '출하완료'}">badge-done</c:when>
														<c:when test="${item.REQUEST_STATUS == '취소'}">badge-cancel</c:when>
													</c:choose>
												">${item.REQUEST_STATUS}</span>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td colspan="8" class="empty-cell">등록된 출하 요청이 없습니다.</td></tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
		</div>
		</div>


		<input type="hidden" id="addr" value="${venderDTO.vender_addr}">

		<!-- 거래처 수정 모달 -->
		<div id="workModal" class="modal-overlay">
			<div class="modal-box">
				<h3 class="modal-title">거래처 수정</h3>
				<form id="venRegForm" action="/vender/update" method="post"
					accept-charset="UTF-8">
					<input type="hidden" name="vender_num"
						value="${venderDTO.vender_num}">
					<div class="modal-grid">
						<div class="modal-field">
							<label>거래처명</label> <input type="text" name="vender_name"
								placeholder="거래처명" value="${venderDTO.vender_name}">
						</div>
						<div class="modal-field">
							<label>대표자명</label> <input type="text" name="ven_ename"
								placeholder="대표자명" value="${venderDTO.ven_ename}">
						</div>
						<div class="modal-field">
							<label>사업자등록번호</label> <input type="text" name="biz_no"
								placeholder="사업자 등록번호" value="${venderDTO.biz_no}">
						</div>
						<div class="modal-field">
							<label>거래처 타입</label> <input type="text" name="vender_type"
								placeholder="거래처 타입" value="${venderDTO.vender_type}">
						</div>
						<div class="modal-field">
							<label>연락처</label> <input type="number" name="vender_phone"
								placeholder="연락처" value="${venderDTO.vender_phone}">
						</div>
						<div class="modal-field">
							<label>주소</label> <input type="text" name="vender_addr"
								placeholder="주소" value="${venderDTO.vender_addr}">
						</div>
						<div class="modal-field">
							<label>담당 사원</label> <input type="text" name="emp_num"
								placeholder="사원번호" value="${venderDTO.emp_num}">
						</div>
					</div>
					<div class="modal-btn-wrap">
						<button type="submit" class="btn-submit">등록</button>
						<button type="button" class="btn-close" id="btnCloseWorkModal">닫기</button>
					</div>
				</form>
			</div>
		</div>

	</main>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=24620b100f0d7aeedc2ea1937af652d6&libraries=services&autoload=false"></script>

	<script>
		/* 작업 등록 모달 */
		var btnOpenWork = document.getElementById('btnOpenWorkModal');
		if (btnOpenWork)
			btnOpenWork.addEventListener('click', function() {
				document.getElementById('workModal').style.display = 'flex';
			});
		document
				.getElementById('btnCloseWorkModal')
				.addEventListener(
						'click',
						function() {
							document.getElementById('workModal').style.display = 'none';
						});
		document.getElementById('workModal').addEventListener('click',
				function(e) {
					if (e.target == this)
						this.style.display = 'none';
				});

		/* 지도API 관련 */

		kakao.maps.load(function() {

			var addrEl = document.getElementById("addr");
			if (!addrEl)
				return;

			var addr = addrEl.value;
			if (!addr || addr.trim() === "")
				return;

			var mapContainer = document.getElementById('map');
			var mapOption = {
				center : new kakao.maps.LatLng(37.5665, 126.9780),
				level : 3
			};

			var map = new kakao.maps.Map(mapContainer, mapOption);

			var geocoder = new kakao.maps.services.Geocoder();

			geocoder.addressSearch(addr,
					function(result, status) {

						if (status === kakao.maps.services.Status.OK) {

							var coords = new kakao.maps.LatLng(result[0].y,
									result[0].x);

							map.setCenter(coords);

							new kakao.maps.Marker({
								map : map,
								position : coords
							});
						}
					});

		});

		function deleteVender() {
			if (confirm("삭제하시겠습니까?")) {
				document.getElementById("deleteForm").submit();
			}
		}
	</script>


</body>
</html>