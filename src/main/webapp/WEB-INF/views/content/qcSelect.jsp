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
    
    
<link rel="stylesheet" href="/resources/css/table.css">
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 1. 부모 컨테이너 설정 */
.sch-right {
    display: flex  ;
    align-items: center  ;
    flex-wrap: wrap  ;     /* 공간이 아주 모자라면 글자가 깨지는 대신 통째로 아래로 내려감 */
    gap: 5px  ;            /* 요소들 사이의 간격 격차 확보 */
    white-space: nowrap  ; /* 태그 없는 일반 텍스트(검사단계, ~)가 세로로 쪼개지는 것 절대 방지 */
}

/* 2. 내부의 모든 자식 요소들 찌러짐 방지 */
.sch-right > * {
    flex-shrink: 0  ;      /* 어떤 상황에서도 자식 요소들의 너비가 압축되지 않도록 설정 */
    white-space: nowrap  ; /* input 박스나 div 안의 텍스트 줄바꿈 방지 */
}

/* 3. 이미지처럼 한 줄로 정렬하기 위해 <br> 태그 무력화 */
.sch-right br {
    display: none  ;       /* HTML에 있는 <br>이 줄바꿈을 유도해 레이아웃 깨는 것 방지 */
}

/* 4. 버튼 너비 강제 고정 해제 */
.sch-right .btn-sch, 
.sch-right .select-reset {
    width: auto  ;
    min-width: max-content  ; /* 버튼 안의 글자 길이에 맞게 너비 자동 확장 */
    padding: 6px 14px;       /* 버튼 글자 좌우 여백 */
}


/* 전체 텍스트 및 버튼 폰트 크기 축소 (기본보다 한 단계 작게) */
.sch-right, 
.sch-right input, 
.sch-right select, 
.sch-right button,
.sch-input-box input {
    font-size: 12px  ;
}

/* 입력창과 셀렉트 박스 여백 줄이기 */
.sch-right .form-control,
.sch-input-box {
    padding: 4px 5px  ;
    height: auto  ; /* 부트스트랩 높이 강제 고정 해제 */
}

/* 검색창 내부 인풋 여백 조정 */
.sch-input-box input {
    padding: 2px 3px  ;
}

/* 버튼 크기(여백) 줄이기 */
.sch-right .btn-sch, 
.sch-right .select-reset {
    padding: 4px 7px  ;
}


</style>

</head>
<body>


<div class="mat-all">
	<!-- header -->
	<tiles:insertAttribute name="header" ignore="true" />
	
	<div class="mat-body">
			<main class="main-cont">
			
				<!-- 타이틀 & 등록 버튼 -->
				<div class="hdr">
				    <h1>품질관리</h1>
<%-- 				    <c:if test="${sessionScope.role >= 2}"> --%>
			    	<button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
<%-- 				    </c:if> --%>
				</div>
				
				<!-- search form -->
				<form name="searchFrm" action="" method="get">
					<div class="sch-wrap">
						<div class="sch-row">
						
							<div class="sch-right">
								<span class="label">▶ 조회날짜</span> 
									<input type="date" id="sDate" class="form-control">
									~
									<input type="date" id="eDate" class="form-control">
									
									타입 
									<select id="mType" class="form-control">
										<option value="all">선택</option>
										<option value="PASS">PASS</option>
										<option value="FAILED">FAILED</option>
										<option value="WAITING">WAITING</option>
									</select>
									
									<div class="sch-input-box">
										<span style="color: #888;">&#128269;</span> 
										<input type="text" id="keyword" value="" placeholder="품목명 검색">
									</div>
									
								<button type="button" class="btn-sch">검색</button>
								<button type="button" class="select-reset">검색 초기화</button>
							</div>
							
						</div>
					</div>
				</form>
								          
				<!-- table -->
				<div class="tbl-box">
					<table class="tbl">
						<thead>
							<tr>
								<th>lot코드</th>
								<th>품목명</th>
								<th>검사일</th>
								<th>검사구분</th>
								<th>통과여부</th>
								<th>자재량</th>
								<th>담당자</th>
							</tr>
						</thead>	
						
						<tbody id="tbody">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}">
										<tr>
											<td>
												<a href="/qcDetail?io_num=${item.io_num}">
													${item.lot_code}
												</a>
											</td>
											<td>${item.name}</td>
											<td>${item.io_date}</td>
											<td>${item.qc_type}</td>
											<td>${item.qc_pass}</td>
											<td>${item.io_qty}${item.unit}</td>
											<td>${item.ename}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
										<tr>
											<td>조회 결과가 없습니다</td>
										</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
								
				<!-- paging -->
				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
		
		</main>
	</div>
</div>
	
	<!-- footer -->
	<tiles:insertAttribute name="footer" ignore="true" />
	
	<!-- 등록 모달 -->
	<div id="regModal" class="modal-overlay" style="display:none;">
	    <div class="modal-box">
	        <h3 class="modal-title">품질검사 등록</h3>
	        <form id="regForm" action="${pageContext.request.contextPath}/insertQc" method="post">
	            <div class="modal-grid">
	                <div class="modal-field">
	                    <label>검사 품목 lot</label>
	                   	<select name="io_num">
	                   		<option value="">lot코드 / 품목명 / 입고날짜 / 총량  </option>
	                   		<c:forEach var="i" items="${waiting}">
	                            <option value="${i.io_num}">${i.lot_code} / ${i.name} / ${i.io_date} / ${i.io_qty}${i.unit}  </option>
	                        </c:forEach>
	                   	</select>
	                </div>
	                
	                <div class="modal-field">
	                    <label>PASS 개수</label>
	                   	<input id="qty-id" type="number" name="io_qty">
	                   	<span></span>
	                </div>
	                <div class="modal-field">
	                    <label>검사 구분</label>
	                   	<select name="qc_num">
	                        <option value="">선택</option>
	                        <c:forEach var="qc" items="${qc}">
	                        	<c:if test="${qc.qc_pass eq 'PASS' and qc.qc_type ne 'EQUIP'}">
	                            	<option value="${qc.qc_num}">${qc.qc_type} ${qc.qc_pass}</option>
	                            </c:if> 
	                        </c:forEach>
	                    </select>
	                </div>
	                <div class="modal-field">
	                    <label>확인자</label>
	                    <select name="emp_num">
	                        <option value="">선택</option>
	                        <c:forEach var="e" items="${emp}">
	                            <option value="${e.emp_num}">${e.ename}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	
	            <div class="modal-btn-wrap">
	                <button type="submit" class="btn-reg">등록</button>
	                <button type="button" class="btn-cancel" id="btnCloseModal">취소</button>
	            </div>
	        </div>
       	</form>
       	
		</div>
     </div>
   
</body>
<script>

// 검색 초기화 버튼 클릭시 새로고침
const select_reset = document.querySelector(".select-reset");
select_reset.addEventListener('click', () => {
	location.reload();
})

// 검색 버튼 클릭시 아작스
const btn_sch = document.querySelector(".btn-sch");
btn_sch.addEventListener('click', ()=>{
	validateDate()
	movePage(1)
})

// 검색 아작스 로직 
function movePage(pageNum) {
	console.log("pageNum===", pageNum);
    let sDate = document.querySelector("#sDate").value;
    let eDate = document.querySelector("#eDate").value;
    let type = document.querySelector("#mType").value;
    let keyword = document.querySelector("#keyword").value;
    
    const params = new URLSearchParams();
	 // 누른 페이지 번호를 전달
    params.append("page", pageNum); 
    params.append("sDate", sDate);
    params.append("eDate", eDate);
    params.append("type", type);
    params.append("keyword", keyword);
    
    fetch(`/searchQc?\${params.toString()}`)
    .then(response => response.json())
    .then(data => {
    	if(data.searchResult.length == 0){
    		 let tbody = document.querySelector("#tbody");
    	    tbody.innerHTML = "<tr><td colspan='8'>조회된 결과가 없습니다.</td></tr>";
    	    renderPagination(data.pageInfo); // 페이지 정보도 갱신하여 페이징 버튼도 사라지게 처리
    	    return;
    	}
        if(data.status === "good"){
            // 1. 테이블 데이터 갱신
            let tbody = document.querySelector("#tbody");
            tbody.innerHTML = "";
            
            let html = "";
            for(let i = 0; i < data.searchResult.length; i++) {
                let item = data.searchResult[i];
                console.log(item);
                html += `
                    <tr>
                        <td>
	                        <a href="/qcDetail?io_num=\${item.IO_NUM}">
	                        	\${item.LOT_CODE}
							</a>
                        </td>
                        <td>\${item.NAME}</td>
                        <td>\${formatDate(item.IO_DATE)}</td>
                        <td>\${item.QC_TYPE}</td>
                        <td>\${item.QC_PASS}</td>
                        <td>\${item.IO_QTY}\${item.UNIT}</td>
                        <td>\${item.ENAME}</td>
                    </tr>
                `;
            }
            tbody.innerHTML = html;
            
            // paging 갱신
            renderPagination(data.pageInfo);

         	// 주소 변경
            const newUrl = window.location.pathname + `?page=\${pageNum}&Type=\${type}&keyword=\${keyword}`;
            window.history.pushState({path: newUrl}, '', newUrl);
        }
    });
}

// 검색 페이지네이션
function renderPagination(pInfo) {
	let pagingHtml = "";
	if (!pInfo.isFirstPage) {
		pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum - 1})">이전</a>`;
	}
	pInfo.navigatepageNums.forEach(num => {
		pagingHtml += `<a class="page-link prev-next \${num === pInfo.pageNum ? 'active' : ''}" href="javascript:movePage(\${num})">\${num}</a>`;
	});
	if (!pInfo.isLastPage) {
		pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum + 1})">다음</a>`;
	}
	document.querySelector(".pagination-container").innerHTML = pagingHtml;
}
              
/* 등록 모달 열기/닫기 */
document.getElementById('btnOpenModal').addEventListener('click', function() {
    document.getElementById('regModal').style.display = 'flex';
});
document.getElementById('btnCloseModal').addEventListener('click', function() {
    document.getElementById('regModal').style.display = 'none';
});
document.getElementById('regModal').addEventListener('click', function(e) {
    if (e.target === this) this.style.display = 'none';
});


/* 날짜 유효성 검사 로직 */
function validateDate() {
	const start = document.getElementById('sDate').value;
	const end = document.getElementById('eDate').value;
	//(start && end) start와 end가 존재할 때 start의 값이 end보다 크면
	if (start && end && start > end) {
		alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
		document.getElementById('eDate').value = "";
	}
}

// date format
function formatDate(value) {
    if (!value) return "--";

    // 서버에서 넘어오는 값이 타임스탬프(숫자)인지 날짜 문자열인지 판별
    const date = new Date(isNaN(Number(value)) ? value : Number(value));

    if (isNaN(date.getTime())) return "--";

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    // JSP 파일 내부이므로 $ 앞에 반드시 백슬래시(\)를 붙여야 에러가 나지 않습니다.
    return `\${year}-\${month}-\${day}`;
}

//모달//////////////////////////////////////////////

//모달 검색창 인풋 ajax
const itemSearch = document.querySelector("#itemSearch");
	itemSearch.addEventListener('input', ()=>{
		const query = itemSearch.value.trim();
		
		if(query === ""){
			document.querySelector("#suggestList").innerHTML = "";
			suggestList.innerHTML = `
	            <tr id="emptyMessage">
	                <td colspan="5" style="padding: 50px 10px; text-align: center; color: #999;">
	                    품목명을 입력하면 조건에 맞는 기준관리 항목이 여기에 표시됩니다.
	                </td>
	            </tr>
	        `;
			return;
		}
		
		fetch(`/modal?search=\${encodeURIComponent(query)}`)
		.then(response => response.json())
		.then(data=>{
			//여기에 받은 데이터 화면 갱신 로직 넣기 메서드 만들어서 넣으면 될듯 전달인자로 data넣어서
			uploadData(data);
		})
		.catch(error=>{
			console.log("등록모달 검색 에러 났음", error);
		});
	})
	
	
	
	//받은 data를 들고 테이블 만드는 함수
	function uploadData(data){
		const suggestList = document.getElementById('suggestList');
		const Message = document.getElementById('emptyMessage');
		
		
		const rows = suggestList.querySelectorAll('tr');
		rows.forEach(row=>{
			//테이블에 있는 tr중에 id가 emptyMessage(메시지)인것 빼고 제거
			if(row.id !== 'emptyMessage'){
				row.remove();
			}
		});//rows.forEach
		const itemList = data.result;
		if(itemList && itemList.length> 0){
			Message.style.display = 'none';
			
			let html = "";
			itemList.forEach(item =>{
				html += `<tr>
					<td style="text-align:center;"><input type="radio" name="item_num" value="\${item.ITEM_NUM || ''}"></td>
	                <td>\${item.CODE || ''}</td>
	                <td>\${item.NAME || ''}</td>
	                <td>\${item.TYPE || ''}</td>
	                <td>\${item.UNIT || 0}</td>
	            </tr>`;
	        });//data.forEach
			
	        //insertAdjacentHTML: html문자열을 태그로 바꿔서 넣음
	        //'beforeend': suggestList의 태그가 닫히기 직전에 넣음
			suggestList.insertAdjacentHTML('beforeend', html);
			}//if(data && data.length> 0)
			else{
				Message.querySelector('td').innerText = '검색한 조건에 맞는 항목이 없습니다.';
				Message.style.display = 'table-row';
			}
		}	//메서드 끝	
		
		
		
		//등록버튼 누르면 insert
		const btn_plus = document.querySelector(".btn-plus");
		btn_plus.addEventListener('click',()=>{
			
			
			if(quantity < 0){
				alert("개수를 제대로 확인해주세요");
				return;
			}
			const insert_form = document.querySelector("#insert-form");
			insert_form.submit();
		});
			const msgFlag = "${msg}";
			console.log("msgFlag:  ",msgFlag);
			if(msgFlag == "true"){
				
				alert("등록되었습니다.");
				//알림창 뜬 후에 주소창 쿼리스트링 제거
				window.history.replaceState({}, document.title, window.location.pathname);
			}else if(msgFlag == "false"){
				alert("등록에 실패했습니다.");
			}
			

</script>
</html>