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
<title>설비관리 페이지</title>

<style>

select.form-control {
	width: auto;
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
				    <h1>설비관리로그</h1>
				    <button type="button" id="btnOpenModal" class="btn-reg">+ 등록하기</button>
				</div>
				
				<!-- search form -->
				<form name="searchFrm" action="" method="get">
					<div class="sch-wrap">
						<div class="sch-row">
						
							<div class="sch-left">
								<span class="label">▶ 설비코드(설비명)</span> 
								<select id="mType" class="form-control">
									<option value="all">선택</option>
									<c:forEach var="i" items="${item}">
										<option value="${i.item_num}">${i.code} ${i.name}</option>
									</c:forEach>
								</select>
							</div>
			
							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">&#128269;</span> 
									<input type="text" id="keyword" value="" placeholder="설비 명 검색">
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
								<th style="width: 60px;">번호</th>
								<th>설비코드</th>
								<th>설비명</th>
								<th>상태</th>
								<th>이상여부</th>
								<th>조치사항</th>
								<th>점검날짜</th>
								<th>가동시작</th>
								<th>가동종료</th>
								<th>확인자</th>
								<th>누적시간</th>
							</tr>
						</thead>	
						
						<tbody id="equip-body">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}">
										<tr>
											<td style="font-weight: bold; color: #555;">${item.equip_num}</td>
											<td>${item.code}</td>
											<td>${item.name}</td>
											<td>${item.equip_status}</td>
											<td>${item.error_sign}</td>
											<td>${item.equip_action}</td>
											<td>${item.maintenance_date}</td>
											<td>${item.start_date}</td>
											<td>${item.end_date}</td>
											<td>${item.ename}</td>
											<td>${item.total_runtime}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" begin="1" end="10">
										<tr>
											<h1>데이터 없음</h1>
										</tr>
									</c:forEach>
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
	        <h3 class="modal-title">설비관리 등록</h3>
	        <form id="regForm" action="/prod/create" method="post">
	            <div class="modal-grid">
	                <div class="modal-field">
	                    <label>설비코드(설비명)</label>
	                   	<select name="item_num">
	                   		<option value="">선택</option>
	                   		<c:forEach var="i" items="${item}">
	                            <option value="${i.code}">${i.name}</option>
	                        </c:forEach>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>상태</label>
	                   	<select name="equip_status">
	                   		<option value="RUNNING">RUNNING</option>
	                   		<option value="ERROR">ERROR</option>
	                   		<option value="MAINTENANCE">MAINTENANCE</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>에러여부</label>
	                   	<select name="equip_sign">
	                   		<option value="Y">Y</option>
	                   		<option value="N">N</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>조치사항</label>
	                   	<select name="equip_action">
	                   		<option value="NONE">NONE</option>
	                   		<option value="REPAIR">REPAIR</option>
	                   		<option value="CHECK">CHECK</option>
	                   	</select>
	                </div>
	                <div class="modal-field">
	                    <label>가동시작일자</label>
	                   	<input type="date" name="start_date">
	                </div>
	                <div class="modal-field">
	                    <label>가동종료일자</label>
	                   	<input type="date" name="end_date">
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
	            </form>
</div>   
<script>

// 검색 초기화 버튼 클릭시 새로고침
const select_reset = document.querySelector(".select-reset");
select_reset.addEventListener('click', () => {
	location.reload();
})

// 검색 버튼 클릭시 아작스
const btn_sch = document.querySelector(".btn-sch");
btn_sch.addEventListener('click', ()=>{
	movePage(1)
})

// 검색 아작스 로직 
function movePage(pageNum) {
	console.log("pageNum===", pageNum);
    let type = document.querySelector("#mType").value;
    let keyword = document.querySelector("#keyword").value;
    
    const params = new URLSearchParams();
	 // 누른 페이지 번호를 전달
    params.append("page", pageNum); 
    params.append("type", type);
    params.append("keyword", keyword);
    
    fetch(`/searchEquip?\${params.toString()}`)
    .then(response => response.json())
    .then(data => {
    	if(data.searchResult.length == 0){
    		 let tbody = document.querySelector("#equip-body");
    	    tbody.innerHTML = "<tr><td colspan='8'>조회된 결과가 없습니다.</td></tr>";
    	    renderPagination(data.pageInfo); // 페이지 정보도 갱신하여 페이징 버튼도 사라지게 처리
    	    return;
    	}
        if(data.status === "good"){
            // 1. 테이블 데이터 갱신
            let tbody = document.querySelector("#equip-body");
            tbody.innerHTML = "";
            
            let html = "";
            for(let i = 0; i < data.searchResult.length; i++) {
                let item = data.searchResult[i];
                html += `
                    <tr>
                		<td style="font-weight: bold; color: #555;">
                			\${item.equip_num}
                		</td>
                        <td>\${item.CODE}</td>
                        <td>\${item.NAME}</td>
                        <td>\${item.EQUIP_STATUS}</td>
                        <td>\${item.ERROR_SIGN}</td>
                        <td>\${item.EQUIP_ACTION}</td>
                        <td>\${item.MAINTENANCE_DATE}</td>
                        <td>\${item.START_DATE}</td>
                        <td>\${item.END_DATE}</td>
                        <td>\${item.ENAME}</td>
                        <td>\${item.TOTAL_RUNTIME}</td>
                    </tr>
                `;
            }
            tbody.innerHTML = html;
            
            // paging 갱신
            console.log("data.pageInfo===" + data.pageInfo);
            renderPagination(data.pageInfo);

         	// 주소 변경
            const newUrl = window.location.pathname + `?page=\${pageNum}&Type=\${type}&keyword=\${keyword}`;
            window.history.pushState({path: newUrl}, '', newUrl);
        }
    });
}

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
	const start = document.querySelector('#start_date').value;
	const end = document.querySelector('#end_date').value;
	//(start && end) start와 end가 존재할 때 start의 값이 end보다 크면
	if (start && end && start > end) {
		alert("시작 날짜는 종료 날짜보다 이후일 수 없습니다.");
		document.querySelector('#end_date').value = ""; // 초기화
	}
}


</script>
</body>
</html>