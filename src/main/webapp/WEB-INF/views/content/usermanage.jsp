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
<title>사용자 관리 시스템</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>

/* 공통 스타일: 전체 여백 리셋 및 기본 폰트 설정 */
*{box-sizing:border-box;margin:0;padding:0;font-family:'Malgun Gothic',sans-serif}
.mat-all{display:flex;flex-direction:column;min-height:100vh;background-color:#f4f7f6}
.mat-body{display:flex;flex:1}
.main-cont{flex:1;padding:2rem 2.5rem;min-width:0}

/* 사이드바 스타일: 좌측 고정 메뉴 영역 */
.side{width:250px;flex-shrink:0;background-color:#fff;border-right:1px solid #ddd}

/* 헤더 스타일: 상단 타이틀 바 및 제목 텍스트 */
.hdr{display:flex;justify-content:space-between;align-items:center;background-color:#2D6A4F;padding:15px 25px;border-radius:8px;margin-bottom:25px;box-shadow:0 4px 6px rgba(0,0,0,.1)}
.hdr h1{font-size:1.8rem;color:#fff;font-weight:700;letter-spacing:-1px}

/* 버튼 스타일: 등록 및 플러스 버튼 컴포넌트 */
.btn-plus{display:inline-block;background-color:#fff;color:#2D6A4F;padding:10px 24px;border:1px solid #2D6A4F;border-radius:6px;font-size:1.05rem;font-weight:700;cursor:pointer;box-shadow:inset 0 1px 0 rgba(255,255,255,.2),0 2px 3px rgba(0,0,0,.2);transition:background-color .2s}
.btn-plus:hover{background-color:#B7E4C7}

/* 검색 영역: 검색창을 감싸는 외곽 박스 */
.sch-wrap{background-color:#fff;border:1px solid #bbb;border-radius:10px;padding:20px 25px;margin-bottom:25px;box-shadow:0 2px 8px rgba(0,0,0,.03)}
.sch-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:15px}
.sch-row:last-child{margin-bottom:0}
.sch-left{display:flex;align-items:center;gap:12px}
.sch-right{display:flex;align-items:center;gap:12px}
.label{display:flex;align-items:center;font-size:.95rem;font-weight:700;color:#333}

/* 폼 요소 공통 규격: 인풋 및 셀렉트 박스 기본 스타일 */
.form-control{height:38px;padding:0 10px;border:1px solid #aaa;border-radius:4px;font-size:.95rem;outline:none;transition:border-color .2s}
.form-control:focus{border-color:#2D6A4F}
select.form-control{width:110px}

/* 커스텀 검색창: 돋보기 아이콘 등이 들어가는 검색 입력 박스 */
.sch-input-box{display:flex;align-items:center;height:38px;width:220px;padding-left:10px;background:#fff;border:1px solid #aaa;border-radius:4px}
.sch-input-box input{flex:1;height:100%;padding:0 5px;border:none;outline:none;font-size:.95rem}

/* 검색 버튼: 검색 실행 버튼 */
.btn-sch{height:38px;padding:0 20px;background-color:#fff;color:#2D6A4F;border:1px solid #2D6A4F;border-radius:4px;font-size:1rem;font-weight:700;cursor:pointer;transition:.2s}
.btn-sch:hover{background-color:#B7E4C7}

/* 초기화 버튼: 조건 리셋 버튼 */
.select-reset{height:38px;padding:0 20px;background-color:#fff;color:#2D6A4F;border:1px solid #2D6A4F;border-radius:4px;font-size:1rem;font-weight:700;cursor:pointer;transition:.2s}
.select-reset:hover{background-color:#FFB703}

/* 커스텀 라디오 버튼: 기본 라디오 라벨 스타일 */
.radio-label{display:flex;align-items:center;gap:6px;font-size:.95rem;font-weight:700;color:#333;cursor:pointer}
.radio-label input[type="radio"]{appearance:none;-webkit-appearance:none;width:18px;height:18px;border:2px solid #aaa;border-radius:50%;position:relative;outline:none;cursor:pointer}
.radio-label input[type="radio"]:checked{border-color:#4A90E2}
.radio-label input[type="radio"]:checked::after{content:"";position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:10px;height:10px;border-radius:50%;background-color:#4A90E2}

/* 데이터 테이블: 전체 레이아웃 및 행 호버 스타일 */
.tbl-box{background:#fff;border-radius:8px;padding:15px;box-shadow:0 2px 8px rgba(0,0,0,.03)}
.stk-tbl{width:100%;border-collapse:collapse;border-top:2px solid #555;border-bottom:2px solid #555}
.stk-tbl th{background-color:#e9ecef;color:#222;padding:12px 10px;border:1px solid #ccc;border-top:none;font-weight:700;font-size:.95rem}
.stk-tbl td{padding:12px 10px;border:1px solid #ccc;text-align:center;color:#333;font-size:.95rem}
.stk-tbl tbody tr:hover{background-color:#f1f8f5}

/* 테이블 내 링크: 링크 기본 상태 및 호버 스타일 */
.link-txt{color:#2D6A4F;text-decoration:none;font-weight:700}
.link-txt:hover{text-decoration:underline}

/* 모달창: 배경 암전 및 콘텐츠 중앙 정렬 스타일 */
.modal-overlay{position:fixed;top:0;left:0;width:100vw;height:100vh;background-color:rgba(0,0,0,.5);z-index:1000}
.modal-box{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:100%;max-width:600px;padding:30px;background-color:#fff;border-radius:10px;box-shadow:0 4px 15px rgba(0,0,0,.15);box-sizing:border-box}

/* 모달 그리드: 필드 배치 및 너비 가변형 클래스 */
.modal-grid{display:flex;flex-wrap:wrap;gap:15px 20px;margin-bottom:20px;width:100%;box-sizing:border-box}
.modal-field{display:flex;flex-direction:column;gap:6px;width:calc(50% - 10px);box-sizing:border-box}
.modal-field.quarter{width:calc(25% - 15px)}
.modal-field.full{width:100%}

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>사용자 관리</h1>
					<button type="button" class="btn-reg">+ 등록하기</button>
				</div>

		<form name="searchFrm" id="searchFrm" action="/usersearch" method="get">
	<div class="sch-wrap">
		<div class="sch-row">
			<div class="sch-left">
				<span class="label">▶ 부서</span> 
				<!-- 💡 name="dept_num" 추가 -->
				<select id="dType" name="dept_num" class="form-control">
					<option value="">선택</option>
					<c:forEach var="b" items="${ selectd }">
						<!-- 💡 value에 이름이 아닌 부서'번호'를 바인딩해야 정확히 검색됩니다 -->
						<option value="${b.dept_num}">${ b.dept_name }</option>
					</c:forEach>
				</select> 
				
				<span class="label">▶ 권한</span> 
				<!-- 💡 name="e_level" 추가 -->
				<select id="lType" name="e_level" class="form-control">
					<option value="">선택</option>
					<c:forEach var="l" items="${ selectl }">
						<option value="${l.e_level}">${ l.e_level }</option>
					</c:forEach>
				</select>
			</div>

			<div class="sch-right">
				<div class="sch-input-box">
					<span style="color: #888;">🔍</span> 
					<!-- 💡 name="keyword" 추가 -->
					<input type="text" id="keyword" name="keyword" value="${param.keyword}" placeholder=" 사원번호 / 이름">
				</div>
				<!-- 💡 함수 연결을 위해 onclick 속성 부여 -->
				<button type="button" class="btn-sch" >검색</button>
				<!-- onclick="doSearch()"-->
				<button type="button" class="select-reset" onclick="resetSearch()">검색 초기화</button>
			</div>
		</div>
	</div>
</form>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>사원번호</th>
								<th>이름</th>
								<th>권한</th>
								<th>부서</th>
								<th>입사일</th>
								<th>퇴사일</th>
								<th>재직여부</th>
							</tr>
						</thead>
						<tbody id="stock-body">
							<c:choose>
								<c:when test="${not empty userList}">
									<c:forEach var="a" items="${userList}" varStatus="vs">
										<tr onclick="location.href='/userdetail?emp_num=${a.emp_num}'"
											style="cursor: pointer;">
											<td style="font-weight: bold; color: #555;">${vs.count}</td>
											<td>${a.emp_num}</td>
											<td><span class="link-txt">${a.ename}</span></td>
											<td>${a.e_level}</td>
											<td>${a.dept_name}</td>
											<td>${a.hire_date}</td>
											<td>${not empty a.termination_date ? a.termination_date : "-"}</td>
											<td>${a.status}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" begin="1" end="5">
										<tr>
											<td style="font-weight: bold; color: #888;">${i}</td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<div class="table-responsive"></div>
				<div id="paging-area">
					<jsp:include page="/WEB-INF/views/common/paging.jsp" />
				</div>
			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>
	<!-- 사용자 등록 -->
	<div id="regModal" class="modal-overlay" style="display: none;">
		<div class="modal-box">
			<h3 class="modal-title">사용자 등록</h3>

			<form method="POST" action="/userinsert" id="insert-form">
				<div class="modal-grid">


					<div class="modal-field">
						<label for="quantity">이름</label> <input type="text" name="ename"
							id="ename" placeholder="이름">
					</div>
					<div class="modal-field">
						<label for="quantity">연락처</label> <input type="text" name="tel"
							id="tel" placeholder="연락처">
					</div>
					<div class="modal-field">
						<label for="quantity">비밀번호</label> <input type="password"
							name="pw" placeholder="비밀번호를 입력해주세요." class="input-field"
							required
							pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
							title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
					</div>
					<div class="modal-field">
						<label for="quantity">비밀번호 확인</label> <input type="password"
							name="pw2" placeholder="비밀번호를 입력해주세요." class="input-field"
							required
							pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
							title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
					</div>
					<div class="modal-field">
						<label for="quantity">개인정보</label> <input type="text"
							name="secret" id="secret" placeholder="개인정보">
					</div>

					<!-- 1. 맨 위 div를 modal-grid로 바꾸고 flex 스타일 주입 -->
					<!-- 부서와 권한을 한 세트로 묶어 오른쪽 48.5% 공간을 정확하게 차지하도록 설정 -->
					<div class="dept-auth-wrap"
						style="width: 48% !important; display: flex !important; justify-content: space-between !important; align-items: flex-end !important; box-sizing: border-box !important;">

						<!-- 부서 영역 (우측 세트 내부에서 왼쪽 반 차지) -->
						<div class="modal-field"
							style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
							<label for="dType-e">부서</label> <select id="dType-e"
								class="form-control" name="dept_num"
								style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
								<option value="all">선택</option>
								<c:forEach var="b" items="${ selectd }">
									<option value="${b.dept_num}">${ b.dept_name }</option>
								</c:forEach>
							</select>
						</div>

						<!-- 권한 영역 (우측 세트 내부에서 오른쪽 반 차지) -->
						<div class="modal-field"
							style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
							<label for="lType-e">권한</label> <select id="lType-e"
								class="form-control" name="e_level"
								style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
								<option value="all">선택</option>
								<c:forEach var="b" items="${ selectl }">
									<option value="${b.e_level}">${ b.e_level }</option>
								</c:forEach>
							</select>
						</div>

					</div>




				</div>

				<div class="modal-btn-wrap" style="margin-top: 20px;">
					<button type="button" class="btn-plus">등록</button>
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>



	<!-- 스크립트 -->
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
		
		
		
		
		function renderPagination(pInfo) {
		    let pagingHtml = "";
		    
		    // 이전
		    if (!pInfo.isFirstPage) {
		        // pg-btn -> page-link
		        pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum - 1})">이전</a>`;
		    }
		    
		    // 번호
		    pInfo.navigatepageNums.forEach(num => {
		        // pg-btn -> page-link, pg-active -> active (원하시는 명칭으로)
		        pagingHtml += `<a class="page-link prev-next \${num === pInfo.pageNum ? 'active' : ''}" href="javascript:movePage(\${num})">\${num}</a>`;
		    });
		    
		    // 다음
		    if (!pInfo.isLastPage) {
		        // pg-btn -> page-link
		        pagingHtml += `<a class="page-link prev-next" href="javascript:movePage(${pInfo.pageNum + 1})">다음</a>`;
		    }
		    
		    document.querySelector(".pagination-container").innerHTML = pagingHtml;
		}
		
		
		// 🔍 검색 실행 함수
// 		function doSearch() {
// 		    const form = document.searchFrm;
// 		    const dept = document.getElementById("dType").value;
// 		    const level = document.getElementById("lType").value;
// 		    const keyword = document.getElementById("keyword").value.trim();

// 		    // [선택 사항] 아무 조건도 선택/입력하지 않고 검색을 누른 경우 차단 로직
// 		    if (!dept && !level && !keyword) {
// 		        alert("검색 조건을 하나 이상 선택하거나 입력해주세요.");
// 		        return;
// 		    }

// 		    // 앞뒤 불필요한 공백을 제거한 키워드를 다시 세팅
// 		    document.getElementById("keyword").value = keyword;

// 		    // 폼 전송 실행
// 		    form.submit();
// 		}
		
		
// date format (YYYY-MM-DD HH:mm:ss)
function formatDate(value) {
    if (!value) return "--";

    // 서버에서 넘어오는 값이 타임스탬프(숫자)인지 날짜 문자열인지 판별
    const date = new Date(isNaN(Number(value)) ? value : Number(value));

    if (isNaN(date.getTime())) return "--";

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    
    // 시, 분, 초 추가 및 2자리 패딩 처리
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    // JSP 파일 내부이므로 $ 앞에 반드시 백슬래시(\)를 붙여야 에러가 나지 않습니다.
    return `\${year}-\${month}-\${day} \${hours}:\${minutes}:\${seconds}`;
}

		////////////////////////
		// 종한 로직
// 		검색 버튼 클릭시 아작스
		const btn_sch = document.querySelector(".btn-sch");
		btn_sch.addEventListener('click', ()=>{
			movePage(1)
		})
		
		//페이징 관련 함수
		function movePage(pageNum) {
	    
	    const type = document.getElementById("dType").value;
	    const level = document.getElementById("lType").value;
	    const keyword = document.getElementById("keyword").value.trim();

	    const params = new URLSearchParams();
	    params.append("page", pageNum); // 누른 페이지 번호를 전달
	    params.append("type", type);
	    params.append("level", level);
	    params.append("keyword", keyword);
	    
	    fetch(`/usersearch?\${params.toString()}`)
	    .then(response => response.json())
	    .then(data => {
	    	if(data.searchResult.length == 0){
	    		 let tbody = document.querySelector("#stock-body");
	    	    tbody.innerHTML = "<tr><td colspan='8'>조회된 결과가 없습니다.</td></tr>";
	    	    renderPagination(data.pageInfo); // 페이지 정보도 갱신하여 페이징 버튼도 사라지게 처리
	    	    return;
	    	}
	        if(data.status === "good"){
	            // 1. 테이블 데이터 갱신
	            let tbody = document.querySelector("#stock-body");
	            tbody.innerHTML = "";
	            
	            
	            let html = "";
	            for(let i = 0; i < data.searchResult.length; i++) {
	                let item = data.searchResult[i];
	                
	            // 퇴사일 데이터 유무 처리를 위한 자바스크립트 변수 정의
                let termDate = item.TERMINATION_DATE ? item.TERMINATION_DATE : "-";
	            
	                html += `<tr>
	                    <td style='font-weight: bold; color: #555;'>\${i + 1 + (data.pageInfo.pageNum - 1) * 5}</td>
	                    <td>\${item.EMP_NUM}</td>
	                    <td><a href='/userdetail?emp_num=\${item.EMP_NUM}' class='link-txt'>\${item.ENAME}</a></td>
	                    <td>\${item.E_LEVEL}</td>
	                    <td>\${item.DEPT_NAME}</td>
	                    <td>\${formatDate(item.HIRE_DATE)}</td>
	                    <td>\${termDate}</td> <!-- 수정 완료 -->
	                    <td>\${item.STATUS}</td>
	                </tr>`;
	            }
	            tbody.innerHTML = html;
	            
	            renderPagination(data.pageInfo);
	
	            const newUrl = window.location.pathname + `?page=\${pageNum}&type=\${type}&level=\${level}&keyword=\${keyword}`;
	            window.history.pushState({path: newUrl}, '', newUrl);
	        }
	    });
	}
		
		
		/////////////////////////////////
		//////////////////////////////////
		

		// 🔄 검색 초기화 함수
		function resetSearch() {
		    // 1. 입력 요소들 값을 초기화
		    document.getElementById("dType").value = "";
		    document.getElementById("lType").value = "";
		    document.getElementById("keyword").value = "";

		    // 2. 검색 조건이 없는 깨끗한 본래 페이지 상태로 리다이렉트
		    // (현재 보고 있는 컨트롤러 GetMapping 주소로 이동시킵니다)
		    location.href = "/usermanage"; 
		}

		// ⌨️ 키워드 입력창에서 엔터키를 눌렀을 때도 검색이 실행되도록 편의성 추가
		document.getElementById("keyword").addEventListener("keyup", function(event) {
		    if (event.key === "Enter") {
		        event.preventDefault(); // 엔터키 본래의 서브밋 기능 일시 중단
// 		        doSearch(); // 작성한 커스텀 검색 함수 실행
		    }
		});
			

		
		
		
		
		
		////////모달 영역
		const plus_btn = document.querySelector(".btn-reg");
			const modal =  document.querySelector(".modal-overlay");
		plus_btn.addEventListener('click', ()=>{
			modal.style.display = "block";
		})
		
			//취소 버튼 클릭
			const cancel = document.querySelector(".btn-cancel");
			cancel.addEventListener('click',()=>{
				modal.style.display = "none";
			})
			
			
			
		//모달///////////////////////////////////////////////
	
			
		
				
				
				
				// 등록버튼 누르면 유효성 검증 후 전송
const btn_plus = document.querySelector(".btn-plus");
if (btn_plus) {
    btn_plus.addEventListener('click', () => {
        
        // 1. 인풋 및 셀렉트 객체 가져오기 (상사 제외)
        const id = document.querySelector("input[name='ename']");
        const pw = document.querySelector("input[name='pw']");
        const pw2 = document.querySelector("input[name='pw2']");
        
        // 💡 부서와 권한 셀렉트 박스만 값을 읽어옵니다.
        const dType = document.querySelector("#dType-e").value; // 부서
        const lType = document.querySelector("#lType-e").value; // 권한

        // 2. HTML5 required 및 정규식 패턴 검사
        if (!id.checkValidity() || !pw.checkValidity() || !pw2.checkValidity()) {
            id.reportValidity() || pw.reportValidity() || pw2.reportValidity();
            return;
        }

        // 3. 비밀번호 일치 확인
        if (pw.value !== pw2.value) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            pw2.focus();
            return;
        }

        // 4. 셀렉트 박스 필수 선택 검증 (💡 mType 검증 제거)
        if (dType === "all") {
            alert("부서를 선택해주세요.");
            return;
        }
        if (lType === "all") {
            alert("권한을 선택해주세요.");
            return;
        }

        // 5. 모든 관문 통과 시 전송
        const insert_form = document.querySelector("#insert-form");
        insert_form.submit();
    });
}

				// [팀 표준] 알림창 제어 및 주소창 쿼리스트링 제거
				const msgFlag = "${msg}";
				console.log("msgFlag: ", msgFlag);
				if (msgFlag == "true") {
				    alert("등록되었습니다.");
				    window.history.replaceState({}, document.title, window.location.pathname);
				} else if (msgFlag == "false") {
				    alert("등록에 실패했습니다.");
				}

				// [팀 표준] 취소 버튼 연동 (화면 리셋)
				const btn_cancel = document.querySelector(".btn-cancel");
				btn_cancel.addEventListener('click', () => {
				    if (confirm("등록을 취소하시겠습니까?")) {
				        location.reload();
				    }
				});
				
   
	</script>
	

</body>
</html>