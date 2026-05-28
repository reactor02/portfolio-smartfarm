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
/* 마이페이지 메인 레이아웃: 목록 검색창 너비와 완벽히 핏을 맞추기 위한 가로 플렉스 및 하단 여백 강제 고정 */
.mypage-wrapper { display: flex !important; gap: 24px !important; width: 100% !important; max-width: 100% !important; margin: 0 auto !important; padding-bottom: 30px !important; align-items: flex-start !important; }

/* 대시보드 전용 카드 박스: 목록 박스의 테두리 두께 및 곡률(#bbb, 10px)을 그대로 이식하고 답답한 내부 여백 축소 */
.mypage-wrapper .mp-card { flex: 1 !important; min-width: 0 !important; min-height: 440px !important; display: flex !important; flex-direction: column !important; background: #fff !important; border: 1px solid #bbb !important; border-radius: 10px !important; padding: 22px 25px !important; box-shadow: 0 2px 8px rgba(0, 0, 0, .03) !important; }

/* 카드 내부 헤더 영역: 제목과 버튼의 수평 정렬 밸런스를 맞추고 하단 경계선의 밀착도 미세조정 */
.mypage-wrapper .mp-card-hdr { display: flex !important; justify-content: space-between !important; align-items: center !important; padding-bottom: 10px !important; margin-bottom: 20px !important; border-bottom: 1px solid #ddd !important; }
.mypage-wrapper .mp-card-hdr h2 { font-size: 1.2rem !important; color: #222 !important; font-weight: 700 !important; margin: 0 !important; }

/* 내 정보 수정 버튼: 테이블 우상단 '+ 등록하기' 버튼의 압축된 크기감을 그대로 반영한 콤팩트 규격 */
.mypage-wrapper .mp-btn-edit { background-color: #fff !important; color: #2D6A4F !important; padding: 5px 14px !important; border: 1px solid #2D6A4F !important; border-radius: 4px !important; font-size: .85rem !important; font-weight: 700 !important; cursor: pointer !important; transition: .2s !important; }
.mypage-wrapper .mp-btn-edit:hover { background-color: #B7E4C7 !important; }

/* 프로필 입력 폼 레이아웃: 테이블 행(Row) 높이의 컴팩트한 감각을 반영하여 입력 필드 간 수직 간격 밀착 */
.mypage-wrapper .mp-profile-form { display: flex !important; flex-direction: column !important; gap: 12px !important; }
.mypage-wrapper .mp-form-group { display: flex !important; align-items: center !important; }
.mypage-wrapper .mp-form-group label { width: 85px !important; flex-shrink: 0 !important; font-size: .9rem !important; font-weight: 700 !important; color: #333 !important; }

/* 마이페이지 전용 읽기창: 기존 .form-control 규격을 강제 상속하며 테두리 색상과 좌우 여백 미세 정돈 */
.mypage-wrapper .form-control.read-only-field { flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .9rem !important; cursor: default !important; }

/* 현황판 위젯 레이아웃: 목록 테이블 헤더의 콤팩트한 비율을 계승하여 상하 크기를 슬림하게 줄인 3단 보드 */
.mypage-wrapper .mp-status-board { display: flex !important; gap: 12px !important; margin-bottom: 15px !important; }
.mypage-wrapper .mp-status-item { flex: 1 !important; display: flex !important; flex-direction: column !important; align-items: center !important; padding: 12px 10px !important; border-radius: 6px !important; border: 1px solid #ccc !important; }

/* 위젯 상태별 파스텔톤 배경: 목록 화면의 깔끔한 톤앤매너와 어우러지는 소프트 피드백 색상 매칭 */
.mypage-wrapper .status-waiting { background-color: #EBF8FF !important; border-color: #BEE3F8 !important; }
.mypage-wrapper .status-ongoing { background-color: #FEFCBF !important; border-color: #FAF089 !important; }
.mypage-wrapper .status-complete { background-color: #E6F4EA !important; border-color: #B7E4C7 !important; }
.mypage-wrapper .status-title { font-size: .85rem !important; color: #555 !important; font-weight: 700 !important; margin-bottom: 2px !important; }
.mypage-wrapper .status-number { font-size: 1.1rem !important; color: #222 !important; font-weight: 700 !important; }

/* 중앙 안내 문구 영역: 과도하게 자리를 차지하던 가짜 박스 형태를 완전히 지우고 여백 유연화 처리 */
.mypage-wrapper .mp-summary-zone { flex: 1 !important; display: flex !important; align-items: center !important; justify-content: center !important; padding: 15px !important; margin-bottom: 15px !important; background: none !important; border: none !important; }
.mypage-wrapper .mp-summary-zone p { font-size: .9rem !important; color: #666 !important; text-align: center !important; }

/* 하단 푸터 바로가기 영역: 전체 카드 높이가 줄어듦에 따라 자연스럽게 우하단에 안착되도록 여백 조정 */
.mypage-wrapper .mp-card-footer { margin-top: auto !important; text-align: right !important; }

</style>
</head>
<body>

<!-- 타이틀 헤더: 공통 .hdr 스타일 적용 -->
<div class="hdr"  style="max-width: 955px !important; margin: 30px 0 0 30px !important; ">
    <h1>사용자 관리</h1>
    <div>
    
    <button type="button" class="btn-reg">비밀번호 변경</button>
    </div>
</div>

<!-- 마이페이지 콘텐츠 영역: 인라인 스타일로 최대 폭(max-width)과 수평 정렬 강제 고정 -->
<!-- 마이페이지 콘텐츠 영역: 가로 최대 너비를 800px로 확 줄이고, 양옆 마진(auto)으로 중앙 배치 정돈 -->
<div class="mypage-wrapper" style="display: flex !important; gap: 40px !important; width: 100% !important; max-width: 950px !important; margin: 30px 0 0 30px !important; padding-bottom: 30px !important; align-items: flex-start !important;">
    
    <!-- [왼쪽] 마이페이지 내 정보 카드 -->
    <div class="mp-card" style="flex: 1 !important; min-width: 0 !important; min-height: 440px !important; display: flex !important; flex-direction: column !important; background: #fff !important; border: 1px solid #bbb !important; border-radius: 10px !important; padding: 22px 25px !important; box-shadow: 0 2px 8px rgba(0, 0, 0, .03) !important;">
        <div class="mp-card-hdr" style="display: flex !important; justify-content: space-between !important; align-items: center !important; padding-bottom: 10px !important; margin-bottom: 20px !important; border-bottom: 1px solid #ddd !important;">
            <h2 style="font-size: 1.25rem !important; color: #222 !important; font-weight: 700 !important; margin: 0 !important;">마이페이지</h2>
        </div>
        
        <div class="mp-profile-form" style="display: flex !important; flex-direction: column !important; gap: 12px !important;">
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">이름</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.ename}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">비밀번호</label>
                <input type="password" class="form-control read-only-field" value="********" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">연락처</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.tel}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">부서코드</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.dept_num}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">입사일</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.hire_date}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            
            <button type="button" class="btn-reg" style="margin-top : 15px;">내 정보 수정</button>
        </div>
    </div>

    <!-- [오른쪽] 내 오늘 작업 대시보드 카드 -->
    <div class="mp-card" style="flex: 1 !important; min-width: 0 !important; min-height: 440px !important; display: flex !important; flex-direction: column !important; background: #fff !important; border: 1px solid #bbb !important; border-radius: 10px !important; padding: 22px 25px !important; box-shadow: 0 2px 8px rgba(0, 0, 0, .03) !important;">
        <div class="mp-card-hdr" style="display: flex !important; justify-content: space-between !important; align-items: center !important; padding-bottom: 10px !important; margin-bottom: 20px !important; border-bottom: 1px solid #ddd !important;">
            <h2 style="font-size: 1.25rem !important; color: #222 !important; font-weight: 700 !important; margin: 0 !important;">내 오늘 작업</h2>
        </div>
        
        <div class="mp-status-board" style="display: flex !important; gap: 12px !important; margin-bottom: 15px !important;">
            <div class="mp-status-item status-waiting" style="flex: 1 !important; display: flex !important; flex-direction: column !important; align-items: center !important; padding: 12px 10px !important; border-radius: 6px !important; border: 1px solid #BEE3F8 !important; background-color: #EBF8FF !important;">
                <span class="status-title" style="font-size: .9rem !important; color: #555 !important; font-weight: 700 !important; margin-bottom: 2px !important;">대기</span>
                <span class="status-number" style="font-size: 1.15rem !important; color: #222 !important; font-weight: 700 !important;">${taskCount.waiting}건</span>
            </div>
            <div class="mp-status-item status-ongoing" style="flex: 1 !important; display: flex !important; flex-direction: column !important; align-items: center !important; padding: 12px 10px !important; border-radius: 6px !important; border: 1px solid #FAF089 !important; background-color: #FEFCBF !important;">
                <span class="status-title" style="font-size: .9rem !important; color: #555 !important; font-weight: 700 !important; margin-bottom: 2px !important;">진행중</span>
                <span class="status-number" style="font-size: 1.15rem !important; color: #222 !important; font-weight: 700 !important;">${taskCount.ongoing}건</span>
            </div>
            <div class="mp-status-item status-complete" style="flex: 1 !important; display: flex !important; flex-direction: column !important; align-items: center !important; padding: 12px 10px !important; border-radius: 6px !important; border: 1px solid #B7E4C7 !important; background-color: #E6F4EA !important;">
                <span class="status-title" style="font-size: .9rem !important; color: #555 !important; font-weight: 700 !important; margin-bottom: 2px !important;">완료</span>
                <span class="status-number" style="font-size: 1.15rem !important; color: #222 !important; font-weight: 700 !important;">${taskCount.complete}건</span>
            </div>
        </div>
        
        <div class="mp-summary-zone" style="flex: 1 !important; display: flex !important; align-items: center !important; justify-content: center !important; padding: 15px !important; margin-bottom: 15px !important; background: none !important; border: none !important;">
            <p style="font-size: .95rem !important; color: #666 !important; text-align: center !important; margin: 0 !important;">오늘 처리해야 할 대기/진행 작업이 있습니다.</p>
        </div>

        <div class="mp-card-footer" style="margin-top: auto !important; text-align: right !important;">
            <a href="/production/workorder" class="link-txt" style="color: #2D6A4F !important; text-decoration: none !important; font-weight: 700 !important; font-size: .95rem !important;">작업 지시서 바로가기 &rarr;</a>
        </div>
    </div>
</div>
			
			
			<!-- 비밀번호 변경 모달창 -->
<div id="pwdModal" class="modal-overlay" style="display: none;">
    <div class="modal-box password-modal-size">
        <!-- 모달 제목 -->
        <h3 class="mp-card-hdr" style="border-bottom: 2px solid #2D6A4F; padding-bottom: 10px; margin-bottom: 20px; font-size: 1.25rem; font-weight: 700;">
            비밀번호 변경
        </h3>

        <form method="POST" action="/pwdUpdate" id="pwd-form">
            <div class="pwd-modal-body">
                
                <!-- 현재 비밀번호 -->
                <div class="mp-form-group-vertical">
                    <label for="currentPwd">현재 비밀번호</label>
                    <input type="password" name="currentPwd" id="currentPwd" class="form-control" placeholder="현재 비밀번호를 입력하세요.">
                </div>

                <!-- 새 비밀번호 -->
                <div class="mp-form-group-vertical">
                    <label for="newPwd">새 비밀번호</label>
                     <input type="password" 
           name="pw" 
           placeholder="비밀번호를 입력해주세요." 
           class="form-control" 
           required
           pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
           title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
                </div>

                <!-- 새 비밀번호 확인 -->
                <div class="mp-form-group-vertical">
                    <label for="confirmPwd">새 비밀번호 확인</label>
                   <input type="password" 
           name="pw2" 
           placeholder="비밀번호를 입력해주세요." 
           class="form-control" 
           required
           pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
           title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
                    <!-- 메시지 출력 공간 (비밀번호 일치 여부 등 텍스트 노출) -->
                    <div id="pwdMsg" class="pwd-msg-box"></div>
                </div>

            </div>

            <!-- 하단 버튼 영역 (공통 테마 맞춤) -->
            <div class="modal-btn-wrap" style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px;">
                <!-- 공통 .btn-plus 기반 스타일 활용 -->
                <button type="button" id="btnPwdSubmit" class="mp-btn-edit" style="background-color: #2D6A4F; color: #fff;">변경</button>
                <button type="button" id="btnPwdCancel" class="mp-btn-edit">취소</button>
            </div>
        </form>
    </div>
</div>


				<!-- 스크립트 -->
				<!-- 스크립트 -->
				<script>
				const pwdModal = document.getElementById("pwdModal");
				const pwdForm = document.getElementById("pwd-form");
				const pw = document.querySelector('input[name="pw"]');
				const pw2 = document.querySelector('input[name="pw2"]');
				const pwdMsg = document.getElementById("pwdMsg");

				// 1. 모달 열기 및 취소
				document.getElementById("btnOpenPwdModal")?.addEventListener("click", () => pwdModal.style.display = "block");
				document.getElementById("btnPwdCancel").addEventListener("click", () => {
				    pwdModal.style.display = "none";
				    pwdForm.reset();
				    pwdMsg.textContent = "";
				});

				// 2. pw2 타이핑할 때마다 실시간 일치 여부 검사 (추가된 기능 🚀)
				pw2.addEventListener("input", () => {
				    const isMatch = pw.value === pw2.value;
				    pwdMsg.textContent = isMatch ? "비밀번호가 일치합니다." : "새 비밀번호가 일치하지 않습니다.";
				    pwdMsg.style.color = isMatch ? "#2D6A4F" : "#d9534f"; // 일치하면 딥그린, 다르면 레드
				});

				// 3. 변경 버튼 클릭 시 최종 검증 및 제출
				document.getElementById("btnPwdSubmit").addEventListener("click", () => {
				    if (!document.getElementById("currentPwd").value || !pw.value || !pw2.value) {
				        alert("모든 필드를 입력해주세요.");
				        return;
				    }
				    if (pw.value !== pw2.value) {
				        alert("새 비밀번호 확인이 일치하지 않습니다.");
				        return;
				    }
				    if (confirm("비밀번호를 변경하시겠습니까?")) {
				        pwdForm.submit();
				    }
				});
    
    
</script>
</body>
</html>