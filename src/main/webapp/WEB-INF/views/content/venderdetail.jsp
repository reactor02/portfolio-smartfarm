<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
	 
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
:root {
    --m-cl: #2D6A4F;
    --s-cl: #49A47A;
    --p-cl: #B7E4C7;
    --bg: #F8F9FA;
    --txt: #333;
    --warning-cl: #FFB703;
    --danger-cl: #E63946;
    --border-cl: #E9ECEF;
}

* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Malgun Gothic', sans-serif;
	color: var(--txt);
	background-color: var(--bg);
}

.mat-all {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

.hdr {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: var(--m-cl);
	color: #FFF;
	padding: 0 20px;
	height: 60px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.hdr-logo-area {
	display: flex;
	align-items: center;
	text-decoration: none;
	color: #FFF;
}

.hdr-logo-img {
	height: 40px;
	width: auto;
	margin-right: 10px;
}

.hdr-logo-txt {
	font-size: 1.4rem;
	font-weight: bold;
	letter-spacing: -1px;
}

.hdr-user {
	font-size: 0.9rem;
}

.hdr-user a {
	color: var(--p-cl);
	text-decoration: none;
	margin-left: 10px;
}

.wrap {
	display: flex;
	flex: 1;
}

.side {
	width: 240px;
	background-color: #FFF;
	border-right: 1px solid #DDD;
}

.nav-list {
	list-style: none;
}

.nav-item {
	border-bottom: 1px solid #EEE;
}

.nav-btn {
	display: block;
	padding: 1rem 1.5rem;
	cursor: pointer;
	font-weight: bold;
	color: var(--m-cl);
	transition: background 0.3s;
	text-decoration: none;
	user-select: none;
}

.nav-btn:hover {
	background-color: var(--p-cl);
}

.sub-nav {
	list-style: none;
	display: none;
	background-color: #F9FDFB;
}

.sub-nav.on {
	display: block;
}

.sub-nav a {
	display: block;
	padding: 0.7rem 1.5rem 0.7rem 2.5rem;
	font-size: 0.9rem;
	color: #555;
	text-decoration: none;
}

.sub-nav a:hover {
	color: var(--m-cl);
	font-weight: bold;
	text-decoration: underline;
	text-underline-offset: 4px;
}

.cont {
	flex: 1;
	padding: 2rem;
	background-color: #FFF;
}

.ftr {
	text-align: center;
	padding: 1rem 0;
	background-color: #EEE;
	font-size: 0.8rem;
	color: #777;
	margin-top: auto;
}

.page-header {
	display: flex;
	flex-direction: column;
	margin-bottom: 2rem;
	padding-bottom: 1rem;
	border-bottom: 2px solid var(--m-cl);
}

.page-title {
	font-size: 1.5rem;
	font-weight: bold;
	color: var(--txt);
}

.btn-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 0.75rem;
}

.btn-row button {
	padding: 8px 18px;
	border-radius: 6px;
	border: 1px solid var(--border-cl);
	background: #FFF;
	cursor: pointer;
	font-weight: bold;
	font-size: 13px;
	transition: background 0.2s;
}

.btn-row .btn-back {
	background-color: var(--m-cl);
	color: #FFF;
	border: none;
}

.btn-row .btn-back:hover {
	background-color: var(--s-cl);
}

.btn-row .btn-reg {
	background-color: var(--s-cl);
	color: #FFF;
	border: none;
}

.btn-row .btn-reg:hover {
	background-color: var(- -m-cl);
}

.btn-row .btn-cancel {
	background-color: #DC3545;
	color: #FFF;
	border: none;
}

.btn-row .btn-cancel:active {
	background-color: #C82333;
}

.section-title {
	font-size: 1.1rem;
	font-weight: bold;
	margin: 2rem 0 1rem 0;
	color: var(--m-cl);
}

.info-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	background-color: var(--bg);
	padding: 20px;
	border: 1px solid var(--border-cl);
	border-radius: 8px;
}

.info-item {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.info-label {
	font-size: 12px;
	color: #777;
	font-weight: bold;
}

.info-value {
	font-size: 14px;
	font-weight: bold;
}

.badge {
	background-color: var(--p-cl);
	color: var(--m-cl);
	padding: 3px 10px;
	border-radius: 12px;
	font-size: 11px;
	font-weight: bold;
	width: fit-content;
}

.status-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	margin-bottom: 1.5rem;
	text-align: center;
}

.status-card {
	background-color: #FFF;
	border: 1px solid var(--border-cl);
	padding: 16px;
	border-radius: 8px;
}

.status-num {
	font-size: 1.3rem;
	font-weight: bold;
	margin-top: 6px;
}

.progress-box {
	background-color: var(--bg);
	border: 1px solid var(--border-cl);
	padding: 20px;
	border-radius: 8px;
}

.progress-bar-bg {
	background-color: #E9ECEF;
	height: 12px;
	border-radius: 6px;
	overflow: hidden;
	margin-top: 8px;
}

.progress-bar-fill {
	background-color: var(--s-cl);
	height: 100%;
	width: 0%;
	transition: width 0.3s ease;
}

.progress-text {
	display: flex;
	justify-content: flex-end;
	font-size: 13px;
	font-weight: bold;
	color: var(--s-cl);
	margin-top: 6px;
}

.data-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 0.5rem;
}

.data-table th {
	background-color: var(--bg);
	border-bottom: 2px solid var(--s-cl);
	color: var(--txt);
	font-weight: bold;
	padding: 12px;
	text-align: center;
	font-size: 13px;
}

.data-table td {
	padding: 12px;
	border-bottom: 1px solid var(--border-cl);
	text-align: center;
	color: #555;
}

.data-table tbody tr:hover {
	background-color: rgba(183, 228, 199, 0.15);
}

.link-text {
	color: var(--s-cl);
	font-weight: bold;
	text-decoration: none;
}

.link-text:hover {
	text-decoration: underline;
}

.instruction-box {
	background-color: var(--bg);
	padding: 18px;
	border-left: 4px solid var(--s-cl);
	margin-top: 15px;
	border-top: 1px solid var(--border-cl);
	border-right: 1px solid var(--border-cl);
	border-bottom: 1px solid var(--border-cl);
	border-radius: 0 8px 8px 0;
}

/* 페이징 */
.wo-paging {
	text-align: center;
	margin-top: 1rem;
}

.wo-paging a {
	display: inline-block;
	padding: 5px 11px;
	margin: 0 2px;
	border: 1px solid var(--border-cl);
	border-radius: 4px;
	text-decoration: none;
	color: var(--txt);
	font-size: 13px;
	cursor: pointer;
}

.wo-paging a:hover {
	background: var(--p-cl);
}

.wo-paging .current {
	background: var(--m-cl);
	color: #FFF;
	border-color: var(--m-cl);
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
	color: var(--m-cl);
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
	border: 1px solid var(--border-cl);
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
</style>
</head>
<body>


	<main class="cont">
		<!--  페이지 헤더 -->
		<div class="page-header">
			<div class="btn-row">
				<button class="btn-back" onclick="location.href='/vender'">목록으로</button>
				<div>
					<button class="btn_reg" id="btnOpenWorkModal">수정</button>
					<button class="btn_reg" onclick="deleteVender()">삭제</button>
					
					<form id="deleteForm" action="/vender/delete" method="post"> 
						<input type="hidden" name="vender_num" value="${venderDTO.vender_num}">
					</form>
				</div>
			</div>
			<h1 class=page-title">거래처 페이지 상세</h1>
		</div>

		<!-- 1. 기본 정보 -->
		<div class="section-title">■ 기본 정보</div>
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

		<!-- 2. 거래처 지도API -->
		<div class="section-title">■ 거래처 위치</div>

		<div id="map" style="width: 100%; height: 350px;"></div>

		<!--  3. 거래처 이력 -->
		<div class="section-title">■ 거래처 이력</div>
		<div>
			<table class="data-table">
				<thead>
					<tr>
						<th style="width: 8%;">번호</th>

					</tr>
				</thead>

			</table>
		</div>


		<input type="hidden" id="addr" value="${venderDTO.vender_addr}">

		<!-- 거래처 수정 모달 -->
		<div id="workModal" class="modal-overlay">
			<div class="modal-box">
				<h3 class="modal-title">거래처 수정</h3>
				<form id="venRegForm" action="/vender/update" method="post" accept-charset="UTF-8" >
					<input type="hidden" name="vender_num"
						value="${venderDTO.vender_num}">
					<div class="modal-grid">
						<div class="modal-field">
							<label>거래처명</label> 
							<input type="text" name="vender_name"
								placeholder="거래처명" value="${venderDTO.vender_name}">
						</div>
						<div class="modal-field">
							<label>대표자명</label> 
							<input type="text" name="ven_ename"
								placeholder="대표자명" value="${venderDTO.ven_ename}">
						</div>
						<div class="modal-field">
							<label>사업자등록번호</label>
							<input type="text" name="biz_no"
								placeholder="사업자 등록번호" value="${venderDTO.biz_no}">
						</div>
						<div class="modal-field">
							<label>거래처 타입</label>
							<input type="text" name="vender_type"
								placeholder="거래처 타입" value="${venderDTO.vender_type}">
						</div>
						<div class="modal-field">
							<label>연락처</label>
							<input type="number" name="vender_phone"
								placeholder="연락처" value="${venderDTO.vender_phone}">
						</div>
						<div class="modal-field">
							<label>주소</label>
							<input type="text" name="vender_addr"
								placeholder="주소" value="${venderDTO.vender_addr}">
						</div>
						<div class="modal-field">
							<label>담당 사원</label>
							<input type="text" name="emp_num"
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
		
		function deleteVender(){
			if(confirm("삭제하시겠습니까?")){
				document.getElementById("deleteForm").submit();
			}
		}
	</script>


</body>
</html>