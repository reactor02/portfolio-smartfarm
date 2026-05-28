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
<link rel="stylesheet" href="/resources/css/request/request.css">
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
						<span class="label">▶ 납기일자</span>
						<input type="date" id="sDate" class="form-control" onchange="validateDate()">
						<span class="date-sep">~</span>
						<input type="date" id="eDate" class="form-control" onchange="validateDate()">
					</div>

					<!-- 2행: 상태 -->
					<div class="sch-row-2">
						<div>
							<span class="label">▶ 상태</span>
							<select id="status" class="form-control">
								<option value="all">전체</option>
								<option value="접수">접수</option>
								<option value="출하대기">출하대기</option>
								<option value="출하완료">출하완료</option>
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

				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<!-- ===== 주문 등록 모달 ===== -->
	<div id="regModal" class="modal-overlay">
		<div class="modal-box">
			<h3 class="modal-title">주문 등록</h3>

			<form method="POST" action="/insertRequest" id="insert-form">
				<div class="modal-grid">

					<!-- 거래처 검색 (드롭다운 방식) -->
					<div class="modal-field modal-field-full">
						<label>거래처명 <span class="required-mark">*</span></label>
						<div class="vender-search-wrap">
							<input type="text" id="venderSearch" placeholder="거래처명 입력 (클릭하면 전체 표시)" autocomplete="off">
							<div id="venderDropdown">
								<table class="vender-tbl">
									<colgroup>
										<col><col><col>
									</colgroup>
									<tbody id="venderList"></tbody>
								</table>
							</div>
						</div>
					</div>

					<!-- 주문일 | 납기일 -->
					<div class="modal-field">
						<label>주문일 <span class="required-mark">*</span></label>
						<input type="date" name="request_date" id="requestDate">
					</div>
					<div class="modal-field">
						<label>납기일 <span class="required-mark">*</span></label>
						<input type="date" name="due_date" id="dueDate">
					</div>

					<!-- 품목 (full) -->
					<div class="modal-field modal-field-full">
						<label>품목 <span class="required-mark">*</span></label>
						<select name="item_num" id="itemSelect">
							<option value="">-- 품목 선택 --</option>
							<c:forEach var="item" items="${itemList}">
								<option value="${item.ITEM_NUM}">${item.NAME}</option>
							</c:forEach>
						</select>
					</div>

					<!-- 수량 -->
					<div class="modal-field">
						<label>수량 <span class="required-mark">*</span></label>
						<input type="number" name="request_qty" id="requestQty" min="1" value="1">
					</div>

				</div>

				<input type="hidden" name="vender_seq" id="selectedVenderSeq">

				<div class="modal-btn-wrap">
					<button type="button" class="btn-reg" id="btnInsert">등록</button>
					<button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		/* ── 날짜 유효성 ── */
		function validateDate() {
			const start = document.getElementById('sDate').value;
			const end   = document.getElementById('eDate').value;
			if (start && end && start > end) {
				alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
				document.getElementById('eDate').value = "";
			}
		}

		/* ── 페이징 렌더링 ── */
		function renderPagination(pInfo) {
			let html = "";
			if (!pInfo.isFirstPage)
				html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum - 1) + ')">이전</a>';
			pInfo.navigatepageNums.forEach(function(num) {
				html += '<a class="page-link prev-next ' + (num == pInfo.pageNum ? 'active' : '') + '" href="javascript:movePage(' + num + ')">' + num + '</a>';
			});
			if (!pInfo.isLastPage)
				html += '<a class="page-link prev-next" href="javascript:movePage(' + (pInfo.pageNum + 1) + ')">다음</a>';
			document.querySelector(".pagination-container").innerHTML = html;
		}

		/* ── 목록 검색 / 페이지 이동 ── */
		function movePage(pageNum) {
			const sDate   = document.getElementById('sDate').value;
			const eDate   = document.getElementById('eDate').value;
			const status  = document.getElementById('status').value;
			const keyword = document.getElementById('keyword').value;

			const params = new URLSearchParams();
			params.append("page",    pageNum);
			params.append("sDate",   sDate);
			params.append("eDate",   eDate);
			params.append("status",  status);
			params.append("type",    '');
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
								item.REQUEST_STATUS === '접수'    ? 'badge-progress' :
								item.REQUEST_STATUS === '출하대기' ? 'badge-waiting'  :
								item.REQUEST_STATUS === '출하완료' ? 'badge-done'     :
								item.REQUEST_STATUS === '취소'    ? 'badge-cancel'   : '';

							html += '<tr>'
								+ '<td class="num-cell">' + (i + 1 + (data.pageInfo.pageNum - 1) * data.pageInfo.pageSize) + '</td>'
								+ '<td><a href="/requestDetail/' + (item.REQUEST_ID || '') + '" class="link-id">' + (item.REQUEST_ID || '') + '</a></td>'
								+ '<td>' + (item.DUE_DATE      || '') + '</td>'
								+ '<td>' + (item.VENDER_NAME   || '') + '</td>'
								+ '<td>' + (item.NAME          || '') + '</td>'
								+ '<td>' + (item.REQUEST_QTY   || '') + '</td>'
								+ '<td>' + (item.ENAME         || '') + '</td>'
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

		/* ════════════════════════════════
		   모달 열기 / 닫기 / 초기화
		   ════════════════════════════════ */
		document.getElementById('btnOpenModal').addEventListener('click', openModal);
		document.getElementById('btnCloseModal').addEventListener('click', closeModal);
		document.getElementById('regModal').addEventListener('click', function(e) {
			if (e.target === this) closeModal();
		});

		function openModal() {
			resetModal();
			document.getElementById('regModal').style.display = 'flex';
		}

		function closeModal() {
			document.getElementById('regModal').style.display = 'none';
			resetModal();
		}

		function resetModal() {
			document.getElementById('venderSearch').value       = '';
			document.getElementById('selectedVenderSeq').value  = '';
			document.getElementById('dueDate').value            = '';
			document.getElementById('requestQty').value         = '1';
			document.getElementById('itemSelect').selectedIndex = 0;
			document.getElementById('venderDropdown').style.display = 'none';
			document.getElementById('requestDate').value = new Date().toISOString().split('T')[0];
		}

		/* ════════════════════════════════
		   거래처 검색 (드롭다운 방식)
		   ════════════════════════════════ */
		document.getElementById('venderSearch').addEventListener('focus', function() {
			loadVenderList(this.value.trim());
			document.getElementById('venderDropdown').style.display = 'block';
		});

		document.getElementById('venderSearch').addEventListener('input', function() {
			loadVenderList(this.value.trim());
			document.getElementById('venderDropdown').style.display = 'block';
		});

		document.addEventListener('click', function(e) {
			const wrap = document.getElementById('venderSearch').closest('div');
			if (!wrap.contains(e.target)) {
				document.getElementById('venderDropdown').style.display = 'none';
			}
		});

		function loadVenderList(keyword) {
			fetch('/searchVender?keyword=' + encodeURIComponent(keyword))
				.then(res => res.json())
				.then(data => renderVenderTable(data))
				.catch(err => console.error("거래처 검색 오류:", err));
		}

		function renderVenderTable(list) {
			const tbody = document.getElementById('venderList');
			if (!list || list.length === 0) {
				tbody.innerHTML = '<tr><td colspan="3" class="vender-list-empty">검색 결과가 없습니다.</td></tr>';
				return;
			}
			let html = '';
			list.forEach(function(v) {
				const num  = v.vender_num  || '';
				const name = v.vender_name || '';
				const type = v.vender_type || '';
				const emp  = v.ven_ename   || v.ename || '';
				html += '<tr class="vender-list-row"'
					+ ' onclick="selectVender(' + num + ',\'' + name.replace(/'/g, "\\'") + '\')">'
					+ '<td class="vender-list-cell">' + name + '</td>'
					+ '<td class="vender-list-cell-muted">' + type + '</td>'
					+ '<td class="vender-list-cell-muted">' + emp  + '</td>'
					+ '</tr>';
			});
			tbody.innerHTML = html;
		}

		function selectVender(num, name) {
			document.getElementById('selectedVenderSeq').value  = num;
			document.getElementById('venderSearch').value       = name;
			document.getElementById('venderDropdown').style.display = 'none';
		}

		/* ── 등록 버튼 ── */
		document.getElementById('btnInsert').addEventListener('click', () => {
			const venderSeq   = document.getElementById('selectedVenderSeq').value;
			const itemNum     = document.getElementById('itemSelect').value;
			const requestDate = document.getElementById('requestDate').value;
			const dueDate     = document.getElementById('dueDate').value;
			const requestQty  = document.getElementById('requestQty').value;

			if (!venderSeq)   { alert('거래처를 선택해주세요.'); return; }
			if (!itemNum)     { alert('품목을 선택해주세요.');   return; }
			if (!requestDate) { alert('주문일을 입력해주세요.'); return; }
			if (!dueDate)     { alert('납기일을 입력해주세요.'); return; }
			if (!requestQty || requestQty < 1) { alert('수량을 입력해주세요.'); return; }

			document.getElementById('insert-form').submit();
		});
	</script>
</body>
</html>
