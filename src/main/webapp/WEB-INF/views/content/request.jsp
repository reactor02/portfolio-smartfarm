<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>


<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/list-common.css">
<link rel="stylesheet" href="/resources/css/modal.css">
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="page-hdr">
					<h1>주문 관리</h1>
					<button type="button" class="btn-reg" id="btnOpenModal">+ 등록하기</button>
				</div>

				<div class="sch-wrap">
					<!-- 1행: 기간 -->
					<div class="sch-row-1">
						<span class="label">▶ 주문일자</span>
						<input type="date" id="sDate" class="form-control" onchange="validateDate()">
						<span class="date-sep">~</span>
						<input type="date" id="eDate" class="form-control" onchange="validateDate()">
					</div>

					<!-- 2행: 상태 | 품목분류 -->
					<div class="sch-row-2">
						<div>
							<span class="label">▶ 상태</span>
							<select id="status" class="form-control">
								<option value="all">전체</option>
								<option value="접수">접수</option>
								<option value="완료">완료</option>
								<option value="취소">취소</option>
							</select>
						</div>
					</div>

					<!-- 3행: 키워드 검색 -->
					<div class="sch-row-3">
						<div class="sch-input-box">
							<span class="sch-icon">&#128269;</span>
							<input type="text" id="keyword" placeholder="거래처명 또는 요청번호 검색">
						</div>
						<button type="button" class="btn-sch" id="btnSearch">검색</button>
						<button type="button" class="select-reset" id="btnReset">검색 초기화</button>
					</div>
				</div>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th class="col-no">번호</th>
								<th>요청번호</th>
								<th>주문일</th>
								<th>납기일</th>
								<th>거래처명</th>
								<th>품목명</th>
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
											<td>${item.REQUEST_ID}</td>
											<td>${item.REQUEST_DATE}</td>
											<td>${item.DUE_DATE}</td>
											<td>${item.VENDER_NAME}</td>
											<td>${item.NAME}</td>
											<td>${item.ENAME}</td>
											<td>
												<span class="badge
													<c:choose>
														<c:when test="${item.REQUEST_STATUS == '접수'}">badge-progress</c:when>
														<c:when test="${item.REQUEST_STATUS == '완료'}">badge-done</c:when>
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

				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<!-- ===== 출하 요청 등록 모달 ===== -->
	<div id="regModal" class="modal-overlay" style="display:none;">
		<div class="modal-box">
			<h3 class="modal-title">출하 요청 등록</h3>

			<form method="POST" action="/insertRequest" id="insert-form">

				<h4 class="section-title">1. 거래처 선택</h4>
				<div class="modal-grid">
					<div class="modal-field">
						<label for="venderSearch">거래처명 검색</label>
						<input type="text" id="venderSearch" placeholder="거래처명 검색">
					</div>

					<div class="modal-field">
						<label for="dueDate">납기일</label>
						<input type="date" name="due_date" id="dueDate">
					</div>

					<div class="modal-field modal-field-full" id="selectedVenderContainer" style="display:none; margin-top:10px;">
						<span style="display:inline-block; padding:6px 12px; background-color:#e6f7ff; color:#1890ff; border:1px solid #91d5ff; border-radius:4px; font-weight:bold; font-size:14px;">
							📌 선택된 거래처: <span id="selectedVenderName" style="color:#0050b3;">-</span>
						</span>
					</div>

					<div class="modal-field modal-field-full" style="margin-top:15px;">
						<label>거래처 목록 (클릭하여 선택하세요)</label>
						<div id="venderResultArea" style="width:100%; height:180px; border:1px solid #ccc; background:#fff; overflow-y:scroll; border-radius:4px;">
							<table style="width:100%; border-collapse:collapse; text-align:left; font-size:14px; table-layout:fixed;">
								<colgroup>
									<col style="width:10%;">
									<col style="width:30%;">
									<col style="width:30%;">
									<col style="width:30%;">
								</colgroup>
								<thead style="background:#f5f5f5; position:sticky; top:0; border-bottom:1px solid #ddd; z-index:10;">
									<tr>
										<th style="padding:10px; text-align:center;">선택</th>
										<th style="padding:10px;">거래처명</th>
										<th style="padding:10px;">유형</th>
										<th style="padding:10px;">담당자</th>
									</tr>
								</thead>
								<tbody id="venderList">
									<tr id="venderEmptyMsg">
										<td colspan="4" style="padding:40px 10px; text-align:center; color:#999;">
											거래처명을 입력하면 검색 결과가 표시됩니다.
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<hr style="margin:25px 0; border:0; border-top:1px dashed #ccc;">

				<h4 class="section-title">2. 품목 선택</h4>
				<div class="modal-grid">
					<div class="modal-field modal-field-full">
						<label>요청할 품목을 선택하세요.</label>
						<div id="itemResultArea" style="width:100%; height:180px; border:1px solid #ccc; background:#fff; overflow-y:scroll; border-radius:4px; margin-top:5px;">
							<table style="width:100%; border-collapse:collapse; text-align:center; font-size:14px; table-layout:fixed;">
								<colgroup>
									<col style="width:10%;">
									<col style="width:30%;">
									<col style="width:30%;">
									<col style="width:15%;">
									<col style="width:15%;">
								</colgroup>
								<thead style="background:#f5f5f5; position:sticky; top:0; border-bottom:1px solid #ddd; z-index:10;">
									<tr>
										<th style="padding:10px;">선택</th>
										<th style="padding:10px;">품목명</th>
										<th style="padding:10px;">품목코드</th>
										<th style="padding:10px;">분류</th>
										<th style="padding:10px;">단위</th>
									</tr>
								</thead>
								<tbody id="itemList">
									<tr>
										<td colspan="5" style="padding:40px 10px; text-align:center; color:#999;">
											거래처를 먼저 선택하면 품목 목록이 표시됩니다.
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<input type="hidden" name="vender_seq" id="selectedVenderSeq">
				<input type="hidden" name="item_num"   id="selectedItemNum">

				<div class="modal-btn-wrap" style="margin-top:25px;">
					<button type="button" class="btn-reg" id="btnInsert">등록</button>
					<button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		function validateDate() {
			const start = document.getElementById('sDate').value;
			const end   = document.getElementById('eDate').value;
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('eDate').value = "";
			}
		}

		function renderPagination(pInfo) {
			let html = "";
			if (!pInfo.isFirstPage) {
				html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum - 1) + ')">이전</a>';
			}
			pInfo.navigatepageNums.forEach(function(num) {
				html += '<a class="page-link prev-next ' + (num == pInfo.pageNum ? 'active' : '') + '" href="javascript:movePage(' + num + ')">' + num + '</a>';
			});
			if (!pInfo.isLastPage) {
				html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum + 1) + ')">다음</a>';
			}
			document.querySelector(".pagination-container").innerHTML = html;
		}

		function movePage(pageNum) {
			const sDate   = document.getElementById('sDate').value;
			const eDate   = document.getElementById('eDate').value;
			const status  = document.getElementById('status').value;
			const type    = document.getElementById('type').value;
			const keyword = document.getElementById('keyword').value;

			const params = new URLSearchParams();
			params.append("page",    pageNum);
			params.append("sDate",   sDate);
			params.append("eDate",   eDate);
			params.append("status",  status);
			params.append("type",    type);
			params.append("keyword", keyword);

			fetch('/searchRequest?' + params.toString())
				.then(res => res.json())
				.then(data => {
					const tbody = document.getElementById('request-body');
					if (!data.searchResult || data.searchResult.length === 0) {
						tbody.innerHTML = "<tr><td colspan='8' class='empty-cell'>조회된 결과가 없습니다.</td></tr>";
						renderPagination(data.pageInfo);
						return;
					}
					if (data.status === "good") {
						let html = "";
						data.searchResult.forEach(function(item, i) {
							const statusClass =
								item.REQUEST_STATUS === '접수' ? 'badge-progress' :
								item.REQUEST_STATUS === '완료' ? 'badge-done' :
								item.REQUEST_STATUS === '취소' ? 'badge-cancel' : '';
							html += '<tr>'
								+ '<td class="num-cell">' + (i + 1 + (data.pageInfo.pageNum - 1) * data.pageInfo.pageSize) + '</td>'
								+ '<td>' + (item.REQUEST_ID   || '') + '</td>'
								+ '<td>' + (item.REQUEST_DATE || '') + '</td>'
								+ '<td>' + (item.DUE_DATE     || '') + '</td>'
								+ '<td>' + (item.VENDER_NAME  || '') + '</td>'
								+ '<td>' + (item.NAME         || '') + '</td>'
								+ '<td>' + (item.ENAME        || '') + '</td>'
								+ '<td><span class="badge ' + statusClass + '">' + (item.REQUEST_STATUS || '') + '</span></td>'
								+ '</tr>';
						});
						tbody.innerHTML = html;
						renderPagination(data.pageInfo);
					}
				})
				.catch(err => console.error("데이터 통신 오류:", err));
		}

		document.getElementById('btnSearch').addEventListener('click', () => movePage(1));

		document.getElementById('btnReset').addEventListener('click', () => location.reload());

		/* ── 모달 열기/닫기 ── */
		document.getElementById('btnOpenModal').addEventListener('click', () => {
			document.getElementById('regModal').style.display = 'flex';
		});
		document.getElementById('btnCloseModal').addEventListener('click', () => {
			document.getElementById('regModal').style.display = 'none';
		});
		document.getElementById('regModal').addEventListener('click', function(e) {
			if (e.target === this) this.style.display = 'none';
		});

		/* ── 거래처 검색 ── */
		document.getElementById('venderSearch').addEventListener('input', function() {
			const query = this.value.trim();
			if (!query) return;
			fetch('/searchVender?keyword=' + encodeURIComponent(query))
				.then(res => res.json())
				.then(data => renderVenderList(data))
				.catch(err => console.error("거래처 검색 오류:", err));
		});

		function renderVenderList(list) {
			const tbody = document.getElementById('venderList');
			if (!list || list.length === 0) {
				tbody.innerHTML = '<tr><td colspan="4" style="padding:20px;text-align:center;color:#999;">검색 결과가 없습니다.</td></tr>';
				return;
			}
			let html = "";
			list.forEach(function(v) {
				html += '<tr style="cursor:pointer;" onclick="selectVender(\'' + v.VENDER_NUM + '\',\'' + v.VENDER_NAME + '\',\'' + v.VENDER_TYPE + '\',\'' + (v.ENAME||'') + '\')">'
					+ '<td style="text-align:center;"><input type="radio" name="vender_radio" value="' + v.VENDER_NUM + '"></td>'
					+ '<td>' + (v.VENDER_NAME || '') + '</td>'
					+ '<td>' + (v.VENDER_TYPE || '') + '</td>'
					+ '<td>' + (v.ENAME       || '') + '</td>'
					+ '</tr>';
			});
			tbody.innerHTML = html;
		}

		function selectVender(num, name, type, ename) {
			document.getElementById('selectedVenderSeq').value   = num;
			document.getElementById('selectedVenderName').innerText = name;
			document.getElementById('selectedVenderContainer').style.display = 'block';
			loadItems();
		}

		function loadItems() {
			fetch('/loadItems')
				.then(res => res.json())
				.then(data => renderItemList(data))
				.catch(err => console.error("품목 로드 오류:", err));
		}

		function renderItemList(list) {
			const tbody = document.getElementById('itemList');
			if (!list || list.length === 0) {
				tbody.innerHTML = '<tr><td colspan="5" style="padding:20px;text-align:center;color:#999;">등록된 품목이 없습니다.</td></tr>';
				return;
			}
			let html = "";
			list.forEach(function(i) {
				const typeLabel =
					i.TYPE === 'PRODUCT'     ? '완제품' :
					i.TYPE === 'SEMIPRODUCT' ? '반제품' :
					i.TYPE === 'MATERIAL'    ? '자재'   :
					i.TYPE === 'RAW'         ? '원자재' : (i.TYPE || '');
				html += '<tr style="cursor:pointer;" onclick="selectItem(\'' + i.ITEM_NUM + '\',\'' + (i.NAME||'').replace(/'/g, "\\'") + '\')">'
					+ '<td><input type="radio" name="item_radio" value="' + i.ITEM_NUM + '"></td>'
					+ '<td>' + (i.NAME  || '') + '</td>'
					+ '<td>' + (i.CODE  || '') + '</td>'
					+ '<td>' + typeLabel + '</td>'
					+ '<td>' + (i.UNIT  || '') + '</td>'
					+ '</tr>';
			});
			tbody.innerHTML = html;
		}

		function selectItem(num, name) {
			document.getElementById('selectedItemNum').value = num;
			document.querySelectorAll('#itemList input[name="item_radio"]').forEach(r => {
				r.checked = (r.value == num);
			});
		}

		document.getElementById('btnInsert').addEventListener('click', () => {
			const venderSeq = document.getElementById('selectedVenderSeq').value;
			const itemNum   = document.getElementById('selectedItemNum').value;
			const dueDate   = document.getElementById('dueDate').value;

			if (!venderSeq) { alert('거래처를 선택해주세요.'); return; }
			if (!itemNum)   { alert('품목을 선택해주세요.');   return; }
			if (!dueDate)   { alert('납기일을 입력해주세요.'); return; }

			document.getElementById('insert-form').submit();
		});
	</script>
</body>
</html>
