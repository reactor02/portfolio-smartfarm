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
</head>
<body>


<div class="mat-all">
	<!-- header -->
	<tiles:insertAttribute name="header" ignore="true" />
	
	<div class="mat-body">
			<main class="main-cont">
			
				<!-- 타이틀 & 등록 버튼 -->
				<div class="hdr">
				    <h1>시설관리 이력</h1>
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
									
									시설
									<select id="mType" class="form-control">
										<option value="all">선택</option>
										<c:forEach var="i" items="${fname.list}">
											<option>${i.facility_name}</option>
										</c:forEach>
									</select>
									
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
								<th style="width: 60px;">시설명</th>
								<th>온도</th>
								<th>습도</th>
								<th>토양 EC</th>
								<th>토양 pH</th>
								<th>조도</th>
								<th>정상체크</th>
								<th>등록일</th>
								<th>담당자</th>
							</tr>
						</thead>	
						
						<tbody id="tbody">
							<c:choose>
								<c:when test="${not empty result}">
									<c:forEach var="item" items="${result}">
										<tr>
											<td style="font-weight: bold; color: #555;">${item.facility_name}</td>
											<td>${item.temperature}</td>
											<td>${item.humidity}</td>
											<td>${item.soil_ec}</td>
											<td>${item.soil_ph}</td>
											<td>${item.illuminance}</td>
											<td>${item.facility_chk}</td>
											<td>
												<fmt:formatDate value="${item.managed_at}" pattern="yy-MM-dd HH:mm" />
											</td>
											<td>${item.ename}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td>조회 결과가 없습니다</td></tr>
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
       	
     
</body>
<script>

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
//date format
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
    let sDate = document.querySelector("#sDate").value;
    let eDate = document.querySelector("#eDate").value;
    let type = document.querySelector("#mType").value;
    
    const params = new URLSearchParams();
	
    // 누른 페이지 번호를 전달
    params.append("page", pageNum); 
    params.append("sDate", sDate);
    params.append("eDate", eDate);
    params.append("type", type);
    
    fetch(`/searchFM?\${params.toString()}`)
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
                        <td style="font-weight: bold; color: #555;">
                        	\${item.FACILITY_NAME}
                        </td>
                        <td>\${item.TEMPERATURE}</td>
                        <td>\${item.HUMIDITY}</td>
                        <td>\${item.SOIL_EC}</td>
                        <td>\${item.SOIL_PH}</td>
                        <td>\${item.ILLUMINANCE}</td>
                        <td>\${item.FACILITY_CHK}</td>
                        <td>\${formatDate(item.MANAGED_AT)}</td>
                        <td>\${item.ENAME}</td>
                    </tr>
                `;
            }
            tbody.innerHTML = html;
            
            // paging 갱신
            renderPagination(data.pageInfo);

         	// 주소 변경
            const newUrl = window.location.pathname + `?page=\${pageNum}&Type=\${type}`;
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





		
</script>
</html>