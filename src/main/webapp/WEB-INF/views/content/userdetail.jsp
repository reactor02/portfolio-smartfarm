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
<title>사용자 상세</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>

/* 공통 및 메인 레이아웃 스타일 */
* { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; }
.mat-all { display: flex; flex-direction: column; min-height: 100vh; background-color: #f4f7f6; }
.mat-body { display: flex; flex: 1; }
.main-cont { flex: 1; padding: 2rem 2.5rem; min-width: 0; }

/* 상단 타이틀 헤더 스타일 */
.hdr { display: flex; justify-content: space-between; align-items: center; background-color: #2D6A4F; padding: 15px 25px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, .1); }
.hdr h1 { font-size: 1.8rem; color: #fff; font-weight: 700; letter-spacing: -1px; }

/* 버튼 컴포넌트 스타일 (목록, 등록, 플러스) */
.btn-list, .btn-plus { display: inline-block; background-color: #fff; color: #2D6A4F; padding: 10px 24px; border: 1px solid #2D6A4F; border-radius: 6px; font-size: 1.05rem; font-weight: 700; text-decoration: none; cursor: pointer; box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 2px 3px rgba(0, 0, 0, .2); transition: background-color .2s; }
.btn-list:hover, .btn-plus:hover { background-color: #B7E4C7; }

/* 상세 페이지 전용 섹션 및 콘텐츠 타이틀 스타일 */
.detail-section { background-color: #fff; border: 1px solid #bbb; border-radius: 10px; padding: 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }
.section-title { display: inline-block; font-size: 1.15rem; font-weight: 700; color: #333; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #2D6A4F; }

/* 상세 정보 그리드: 정보창 레이아웃 및 3칸/4칸 구조 */
.info-grid-top { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
.info-grid-sub { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }

/* 그리드 내 항목: 라벨 및 데이터 텍스트 스타일 */
.info-item { display: flex; flex-direction: column; gap: 8px; }
.info-label { font-size: .9rem; color: #777; font-weight: 700; }
.info-value { font-size: 1.1rem; color: #222; font-weight: 700; }

/* 데이터 테이블: 테이블 외곽 스크롤 박스 */
.tbl-box { height: 350px; overflow-y: auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }

/* 테이블 본체: 헤더 고정 및 테두리 스타일 */
.stk-tbl { width: 100%; border-collapse: collapse; border-top: 2px solid #555; border-bottom: 2px solid #555; }
.stk-tbl th { position: sticky; top: 0; z-index: 10; background-color: #e9ecef; color: #222; padding: 12px 10px; border: 1px solid #ccc; border-top: none; font-weight: 700; }
.stk-tbl td { padding: 12px 10px; border: 1px solid #ccc; text-align: center; color: #333; }

/* 테이블 공통 규격: 텍스트 크기 및 마우스 호버 효과 */
.stk-tbl th, .stk-tbl td { font-size: .95rem; }
.stk-tbl tbody tr:hover { background-color: #f1f8f5; }

/* 폼 요소 공통 규격: 인풋 및 셀렉트 박스 기본 스타일 */
.form-control { height: 38px; padding: 0 10px; border: 1px solid #aaa; border-radius: 4px; font-size: .95rem; outline: none; transition: border-color .2s; }
.form-control:focus { border-color: #2D6A4F; }

/* 모달창 기본 골격: 배경 암전 처리 스타일 */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0, 0, 0, .5); z-index: 1000; }

/* 모달 컨텐츠 박스: 화면 정중앙 배치 스타일 */
.modal-box { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 100%; max-width: 600px; padding: 30px; background-color: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0, 0, 0, .15); box-sizing: border-box; }

/* 모달 내부 레이아웃: 그리드 정렬 구조 */
.modal-grid { display: flex; flex-wrap: wrap; gap: 15px 20px; margin-bottom: 20px; width: 100%; box-sizing: border-box; }

/* 모달 필드 규격: 기본 기본 반 칸(50%) 구조 */
.modal-field { display: flex; flex-direction: column; gap: 6px; width: calc(50% - 10px); box-sizing: border-box; }

/* 모달 필드 확장: 쿼터 칸(25%) 배치 구조 */
.modal-field.quarter { width: calc(25% - 15px); }

/* 모달 필드 확장: 전체 한 칸(100%) 배치 구조 */
.modal-field.full { width: 100%; }

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">

				<div class="hdr">
					<h1>사용자 상세</h1>
					<div>
						<button type="button" class="btn-list" id="edit">수정</button>
					    
					    <c:if test="${ loginUser.e_level == 3 }">
						<button type="button" class="btn-list" id="level">권한</button>
					
						<button type="button" class="btn-list" id="retire">퇴사</button>
						</c:if>
						
						<a href="/usermanage" class="btn-list" id>목록으로</a>

					</div>
				</div>

				<div class="detail-section">
					<div class="info-grid-top">
						<div class="info-item">
							<span class="info-label">사원번호</span> <span class="info-value">${list.emp_num}</span>
						</div>
						<div class="info-item">
							<span class="info-label">이름</span> <span class="info-value">${list.ename}</span>
						</div>
						<div class="info-item">
							<span class="info-label">부서</span> <span class="info-value">${list.dept_name}</span>
						</div>
					</div>

					<div class="info-grid-sub">
						<div class="info-item">
							<span class="info-label">부서번호</span> <span class="info-value">${list.dept_num}</span>
						</div>
						<div class="info-item">
							<span class="info-label">연락처</span> <span class="info-value">${list.tel}</span>
						</div>
						<div class="info-item">
							<span class="info-label">입사일</span> <span class="info-value">${list.hire_date}</span>
						</div>
						<div class="info-item">
							<span class="info-label">재직여부</span> <span class="info-value">${list.status}</span>
						</div>
					</div>
				</div>



			</main>
		</div>

		<tiles:insertAttribute name="footer" ignore="true" />
	</div>

	<!-- 사용자 수정 모달 -->
	<div id="regModal" class="modal-overlay" style="display: none;">
		<div class="modal-box">
			<h3 class="modal-title">사용자 수정</h3>
			<!-- 💡 수정으로 명칭 변경 -->

			<!-- 💡 action 주소를 수정 처리 주소인 /userupdate 로 변경 -->
			<form method="POST" action="/userupdate" id="insert-form">

				<!-- 💡 중요: DB 업데이트를 위해 사원번호(emp_num)를 hidden 필드로 숨겨서 전송 -->
				<input type="hidden" name="emp_num" value="${list.emp_num}">

				<div class="modal-grid">
					<div class="modal-field">
						<!-- 💡 value에 상세 조회 데이터 매핑 -->
						<label for="ename">이름</label>
						<!-- 기존 input 태그를 데이터 출력용 div로 변경 -->
						<div id="ename" class="form-control"
							style="background-color: #eee; display: flex; align-items: center; color: #555;">
							${list.ename}</div>
					</div>
					<div class="modal-field">
						<label for="tel">연락처</label>
						<!-- 기존 input 태그를 데이터 출력용 div로 변경 -->
						<div id="tel" class="form-control"
							style="background-color: #eee; display: flex; align-items: center; color: #555;">
							${list.tel}</div>
					</div>

					<div class="dept-auth-wrap"
						style="width: 48% !important; display: flex !important; justify-content: space-between !important; align-items: flex-end !important; box-sizing: border-box !important;">
						<c:if test="${ loginUser.e_level > 1 }">
						<!-- 부서 영역 -->
						<div class="modal-field"
							style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
							<label for="dType-e">부서</label> <select id="dType-e"
								class="form-control" name="dept_num"
								style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
								<option value="">선택</option>
								<c:forEach var="b" items="${ selectd }">
									<!-- 💡 기존 사원의 부서 번호와 일치하면 자동으로 선택(selected) 상태로 만듦 -->
									<option value="${b.dept_num}"
										${b.dept_num == userDetail.dept_num ? 'selected' : ''}>${ b.dept_name }</option>
								</c:forEach>
							</select>
						</div>
						
						</c:if>
						<c:if test="${ loginUser.e_level == 3 }">
						<!-- 권한 영역 -->
						<div class="modal-field"
							style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
							<label for="lType-e">권한</label> <select id="lType-e"
								class="form-control" name="e_level"
								style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
								<option value="">선택</option>
								<c:forEach var="b" items="${ selectl }">
									<!-- 💡 기존 사원의 권한 등급과 일치하면 자동으로 선택(selected) 상태로 만듦 -->
									<option value="${b.e_level}"
										${b.e_level == requestScope.list.e_level ? 'selected' : ''}>${ b.e_level }</option>
								</c:forEach>
							</select>
						</div>
						</c:if>
						
						
					</div>
				</div>

				<div class="modal-btn-wrap" style="margin-top: 20px;">
					<button type="button" class="btn-plus edit">수정 완료</button>
					<!-- 💡 텍스트 수정 -->
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 권한 변경 모달 -->
	<div id="pModal" class="modal-overlay" style="display: none;">
		<div class="modal-box">
			<h3 class="modal-title">권한 변경</h3>

			<!-- 💡 전용 action 주소와 중복되지 않는 고유 ID 부여 -->
			<form method="POST" action="/userlevelupdate" id="level-form">

				<!-- 💡 권한을 변경할 대상 사원의 식별자 전송 -->
				<input type="hidden" name="emp_num" value="${userDetail.emp_num}">

				<div class="modal-grid">
					<!-- 💡 이름은 정보 수정창이 아니므로 disabled 처리하여 수정을 방지 -->
					<div class="modal-field">
					<input type="hidden" name="emp_num" value="${list.emp_num}">
						<label for="ename">이름</label> <input type="text" name="ename"
							id="ename" placeholder="이름" value="${list.ename}" disabled>
					</div>

					<!-- 권한 영역 -->
					<div class="modal-field"
						style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
						<label for="lType-e">권한</label> <select id="lType-p"
							class="form-control" name="e_level"
							style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
							<option value="">선택</option>
							<c:forEach var="b" items="${ selectl }">
								<!-- 💡 기존 사원의 현재 권한을 기본 선택(selected) 상태로 래핑 -->
								<option value="${b.e_level}"
									${b.e_level == requestScope.list.e_level ? 'selected' : ''}>${ b.e_level }</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<!-- 💡 전체 div 닫는 태그 누락 오류가 있어 폼 태그 내부로 깔끔하게 재배치했습니다 -->
				<div class="modal-btn-wrap" style="margin-top: 20px;">
					<button type="button" class="btn-plus ">변경 완료</button>
					<button type="button" class="btn-cancel">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script type="text/javascript">	
	
	// ==========================================
	// 사용자 수정 모달 제어 및 유효성 검증
	// ==========================================

	// 1. 모달 및 트리거 버튼 객체 생성
	const editBtn = document.querySelector("#edit");       // 상단 헤더의 수정 버튼
	const regModal = document.querySelector("#regModal");   // 수정 모달창 오버레이
	const cancelBtn = document.querySelector(".btn-cancel"); // 모달 내부 취소 버튼

	// 2. 수정 버튼 클릭 시 모달창 열기
	if (editBtn && regModal) {
	    editBtn.addEventListener('click', () => {
	        regModal.style.display = "block";
	    });
	}



	// 4. [수정 완료] 버튼 클릭 시 유효성 검증 및 제출
	const btnSubmit = document.querySelector(".edit"); // 모달 내 수정완료(구 btn-plus) 버튼
	if (btnSubmit) {
	    btnSubmit.addEventListener('click', () => {
	        
	        // 폼 필드 객체 및 값 확보

	        const dType = document.querySelector("#dType-e").value; // 부서 선택값
	      //  const lType = document.querySelector("#lType-e").value; // 권한 선택값

	        // HTML5 기본 제약조건(required, pattern) 검증 실행
	       // if (!ename.checkValidity() || !pw.checkValidity() || !pw2.checkValidity()) {
	       //     ename.reportValidity() || pw.reportValidity() || pw2.reportValidity();
	       //     return;
	       // }

	        // 새 비밀번호 일치 여부 확인
	      //  if (pw.value !== pw2.value) {
	      //      alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
	      //      pw2.focus();
	      //      return;
	      //  }

	        // 부서 및 권한 선택 여부 검증 (value="" 또는 "all" 방어)
	        if (dType === "" || dType === "all") {
	            alert("부서를 선택해주세요.");
	            return;
	        }
	       // if (lType === "" || lType === "all") {
	       //     alert("권한을 center 선택해주세요.");
	       //     return;
	       // }

	        // 모든 검증 완료 시 폼 제출 (/userupdate 로 POST 전송)
	        const updateForm = document.querySelector("#insert-form");
	        if (updateForm) {
	            if (confirm("이대로 사원 정보를 수정하시겠습니까?")) {
	                updateForm.submit();
	            }
	        }
	    });
	}
	
	// ==========================================
	// 권한 변경 모달 제어 및 유효성 검증
	// ==========================================

	// 1. 객체 확보 (수정 모달 등 타 컴포넌트와 클래스/ID 충돌 방지)
	const levelBtn = document.querySelector("#level");            // 상단 헤더의 권한 버튼
	const pModal = document.querySelector("#pModal");              // 권한 모달창 오버레이

	const btnLevelSubmit = document.querySelector(".btn-level-submit"); // 권한 모달 내부 변경 완료 버튼

	// 2. 권한 버튼 클릭 시 모달창 열기
	if (levelBtn && pModal) {
	    levelBtn.addEventListener('click', () => {
	        pModal.style.display = "block";
	    });
	}


	// 4. [변경 완료] 버튼 클릭 시 유효성 검증 및 제출
	if (btnLevelSubmit) {
	    btnLevelSubmit.addEventListener('click', () => {
	        
	        // 권한 셀렉트 박스의 값 추출 (위 HTML에서 수정한 id인 #lType-p로 타겟팅)
	        const lType = document.querySelector("#lType-p").value;

	        // 권한 선택 여부 검증
	        if (lType === "" || lType === "all") {
	            alert("변경할 권한을 선택해주세요.");
	            return;
	        }

	        // 폼 최종 제출
	        const levelForm = document.querySelector("#level-form");
	        if (levelForm) {
	            if (confirm("사원의 권한을 변경하시겠습니까?")) {
	                levelForm.submit();
	            }
	        }
	    });
	}
	
	
	const btn_cancel = document.querySelectorAll(".btn-cancel");

	if (btn_cancel) {
	    // NodeList(배열) 안의 모든 취소 버튼을 하나씩 순회하며 이벤트를 심어줍니다.
	    btn_cancel.forEach(btn => {
	        btn.addEventListener('click', () => {
	            if (confirm("취소하시겠습니까? 변경사항이 저장되지 않습니다.")) {
	                location.reload(); // 화면 새로고침으로 데이터 및 모달 초기화
	            }
	        });
	    });
	}
	
	// 1. 코스트(const)로 버튼 요소 찾기
	const retireBtn = document.querySelector('#retire');

	// 2. 버튼에 바로 클릭 이벤트리스너 걸기
	retireBtn.addEventListener('click', function() {
	    
	    // 사원번호 수집
	    const empNum = "${list.emp_num}"; 
	    
	    // 확인창 띄우기
	    if (confirm("정말 이 사원을 퇴사 처리하시겠습니까?")) {
	        
	        // 서버로 사원번호 전송 (기본 fetch)
	        fetch('/userRetire', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded'
	            },
	            body: 'emp_num=' + encodeURIComponent(empNum)
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data === "success") {
	                alert("퇴사 처리가 완료되었습니다.");
	                location.href = '/usermanage'; // 목록 이동
	            } else {
	                alert("처리에 실패했습니다.");
	            }
	        });
	        
	    }
	});
	
	// ==========================================
// 1. 모달창 열기/닫기 제어
// ==========================================
// 등록 버튼 클릭 시 모달창(암전 배경) 표시
const plus_btn = document.querySelector(".btn-reg");
const modal = document.querySelector(".modal-overlay");

if (plus_btn && modal) {
    plus_btn.addEventListener('click', () => {
        modal.style.display = "block";
    });
}

// ==========================================
// 2. 사원 등록 유효성 검증 및 폼 전송
// ==========================================
const btn_plus = document.querySelector(".btn-plus");
if (btn_plus) {
    btn_plus.addEventListener('click', () => {
        
        // 인풋 및 셀렉트 객체 가져오기
        const id = document.querySelector("input[name='ename']");
        const pw = document.querySelector("input[name='pw']");
        const pw2 = document.querySelector("input[name='pw2']");
        
        // 부서와 권한 셀렉트 박스 선택 값 읽기
        const dType = document.querySelector("#dType-e").value; // 부서
        const lType = document.querySelector("#lType-e").value; // 권한

        // HTML5 required 속성 및 정규식 패턴(pattern) 자동 유효성 검사
        if (!id.checkValidity() || !pw.checkValidity() || !pw2.checkValidity()) {
            id.reportValidity() || pw.reportValidity() || pw2.reportValidity();
            return;
        }

        // 비밀번호와 비밀번호 확인 필드 일치 여부 검증
        if (pw.value !== pw2.value) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            pw2.focus();
            return;
        }

        // 셀렉트 박스 필수 선택 검증 (HTML의 value=""와 매핑)
        if (dType === "") {
            alert("부서를 선택해주세요.");
            return;
        }
        if (lType === "") {
            alert("권한을 선택해주세요.");
            return;
        }

        // 모든 유효성 검사 통과 시 서버로 폼 데이터 최종 전송
        const insert_form = document.querySelector("#insert-form");
        if (insert_form) {
            insert_form.submit();
        }
    });
}

// ==========================================
// 3. [팀 표준] 서버 응답 결과 알림 및 주소창 정제
// ==========================================
// 컨트롤러(FlashAttribute)에서 넘어온 성패 데이터 확인
const msgType = "${msgType}";
const msgContent = "${msgContent}";

if (msgType) {
    // 성패 메세지 알림창 출력
    alert(msgContent);
    
    // 알림창 확인 후, 새로고침 시 알림창이 다시 뜨지 않도록 주소창 뒤의 쿼리스트링 깔끔히 제거
    window.history.replaceState({}, document.title, window.location.pathname);
}
	
	</script>



</body>
</html>