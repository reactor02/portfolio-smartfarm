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

/* 모달 오버레이 */
body .modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0,0,0,.5); z-index: 2000; }

/* 모달 콘텐츠 박스: 자바스크립트가 부모를 block으로 바꿔도 무조건 화면 정중앙 고정 */
body .modal-box.password-modal-size { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 100%; max-width: 400px; padding: 25px 30px; background-color: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,.15); box-sizing: border-box; }

/* 입력 폼 그룹 */
div .mp-form-group-vertical { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
div .mp-form-group-vertical label { font-size: .9rem; font-weight: 700; color: #333; }
div .mp-form-group-vertical .form-control { width: 100%; height: 38px; padding: 0 10px; border: 1px solid #aaa; border-radius: 4px; font-size: .95rem; outline: none; }
div .mp-form-group-vertical .form-control:focus { border-color: #2D6A4F; }

/* 검증 메시지 */
div .pwd-msg-box { font-size: .85rem; font-weight: 700; margin-top: 4px; min-height: 18px; }


</style>
</head>
<body>

<!-- 타이틀 헤더: 공통 .hdr 스타일 적용 -->
<div class="hdr"  style="max-width: 955px !important; margin: 30px 0 0 30px !important; ">
    <h1>마이페이지</h1>
    <div>
    
    <button name="pw-btn" id="pw-btn" type="button" class="btn-reg">비밀번호 변경</button>
    </div>
</div>

<!-- 마이페이지 콘텐츠 영역: 인라인 스타일로 최대 폭(max-width)과 수평 정렬 강제 고정 -->
<!-- 마이페이지 콘텐츠 영역: 가로 최대 너비를 800px로 확 줄이고, 양옆 마진(auto)으로 중앙 배치 정돈 -->
<div class="mypage-wrapper" style="display: flex !important; gap: 40px !important; width: 100% !important; max-width: 950px !important; margin: 30px 0 0 30px !important; padding-bottom: 30px !important; align-items: flex-start !important;">
    
    <!-- [왼쪽] 마이페이지 내 정보 카드 -->
<div class="mp-card" style="flex: 1 !important; min-width: 0 !important; min-height: 440px !important; display: flex !important; flex-direction: column !important; background: #fff !important; border: 1px solid #bbb !important; border-radius: 10px !important; padding: 22px 25px !important; box-shadow: 0 2px 8px rgba(0, 0, 0, .03) !important;">
    <div class="mp-card-hdr" style="display: flex !important; justify-content: space-between !important; align-items: center !important; padding-bottom: 10px !important; margin-bottom: 20px !important; border-bottom: 1px solid #ddd !important;">
        <h2 style="font-size: 1.25rem !important; color: #222 !important; font-weight: 700 !important; margin: 0 !important;">내 정보 카드</h2>
    </div>
    
    <form id="info-form" action="/user/updateInfo" method="post" style="margin: 0;">
        <div class="mp-profile-form" style="display: flex !important; flex-direction: column !important; gap: 12px !important;">
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">이름</label>
                <!-- 💡 수정을 위해 id="user-ename" 및 name="ename" 추가 -->
                <input type="text" id="user-ename" name="ename" class="form-control read-only-field" value="${loginUser.ename}"  style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important; transition: all 0.2s;" />
            </div>
            
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">비밀번호</label>
                <div style="flex: 1 !important; display: flex !important; gap: 10px !important;">
                    <input type="password" class="form-control read-only-field" value="********" readonly style="flex: 1 !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
                </div>
            </div>
            
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">연락처</label>
                <input type="text" id="user-tel" name="tel" class="form-control read-only-field" value="${loginUser.tel}" style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important; transition: all 0.2s;" />
            </div>
            
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">부서코드</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.dept_num}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            
            <div class="mp-form-group" style="display: flex !important; align-items: center !important;">
                <label style="width: 85px !important; flex-shrink: 0 !important; font-size: .95rem !important; font-weight: 700 !important; color: #333 !important;">입사일</label>
                <input type="text" class="form-control read-only-field" value="${loginUser.hire_date}" readonly style="flex: 1 !important; width: 100% !important; height: 38px !important; padding: 0 10px !important; background-color: #f9f9f9 !important; color: #555 !important; border: 1px solid #aaa !important; border-radius: 4px !important; font-size: .95rem !important; cursor: default !important;" />
            </div>
            
            <div id="btn-group-normal" style="margin-top: 15px; display: block;">
                <button id="edit-btn" type="button" class="btn-reg" style="width: 100%;">내 정보 수정</button>
            </div>
            
            <div id="btn-group-edit" style="margin-top: 15px; display: none; gap: 10px;">
                <button id="save-btn" type="button" class="btn-reg" style="flex: 1; background-color: #2D6A4F !important; color: #fff !important; border-color: #2D6A4F !important;">저장</button>
                <button id="cancel-btn" type="button" class="select-reset" style="flex: 1; margin: 0;">취소</button>
            </div>
        </div>
    </form>
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
                

                <!-- 새 비밀번호 -->
                <div class="mp-form-group-vertical">
                    <label for="newPwd">새 비밀번호</label>
                     <!-- 새 비밀번호 입력창 수정본 -->
<input type="password" 
       name="pw" 
       placeholder="비밀번호를 입력해주세요." 
       class="form-control" 
       required
       pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,20}"
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
       pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,20}"
       title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
                    <!-- 메시지 출력 공간 (비밀번호 일치 여부 등 텍스트 노출) -->
                    <div id="pwdMsg" class="pwd-msg-box"></div>
                </div>

            </div>

            <!-- 하단 버튼 영역 (공통 테마 맞춤) -->
            <div class="modal-btn-wrap" style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px;">
                <!-- 공통 .btn-plus 기반 스타일 활용 -->
                <button type="button" id="btnPwdSubmit" class="mp-btn-edit btn-reg" style="background-color: #2D6A4F; color: #fff;">변경</button>
                <button type="button" id="btnPwdCancel" class="mp-btn-edit btn-reg">취소</button>
            </div>
        </form>
    </div>
</div>


				<!-- 스크립트 -->
				<!-- 스크립트 -->
				<script>
				
				
				/* ==========================================
				 * [1] 엘리먼트 정의 및 쿼리 매핑
				 * ========================================== */
				const pwBtn = document.querySelector('#pw-btn');
				const pwdModal = document.getElementById("pwdModal");
				const pwdForm = document.getElementById("pwd-form");
				// currentPwd 정의 제거 (화면에 없으므로 삭제)
				const pw = document.querySelector('input[name="pw"]');
				const pw2 = document.querySelector('input[name="pw2"]');
				const pwdMsg = document.getElementById("pwdMsg");

				/* ==========================================
				 * [2] 모달 개폐 및 초기화 이벤트
				 * ========================================== */
				pwBtn.addEventListener('click', () => pwdModal.style.display = "block");

				document.getElementById("btnPwdCancel").addEventListener("click", () => {
				    pwdModal.style.display = "none";
				    pwdForm.reset();
				    pwdMsg.textContent = "";
				});

				/* ==========================================
				 * [3] 실시간 비밀번호 일치 검증
				 * ========================================== */
				pw2.addEventListener("input", () => {
				    if (!pw.value && !pw2.value) { 
				        pwdMsg.textContent = ""; 
				        return; 
				    }
				    const isMatch = pw.value === pw2.value;
				    pwdMsg.textContent = isMatch ? "비밀번호가 일치합니다." : "새 비밀번호가 일치하지 않습니다.";
				    pwdMsg.style.color = isMatch ? "#2D6A4F" : "#d9534f";
				});

				/* ==========================================
				 * [4] 최종 정형 검증 및 비동기(Fetch) 제출
				 * ========================================== */
				document.getElementById("btnPwdSubmit").addEventListener("click", function(e) {
				    e.preventDefault(); 

				    // 1. 공백 유무 검증
				    if (!pw.value || !pw2.value) {
				        alert("모든 필드를 입력해주세요.");
				        return;
				    }
				    
				    // 2. 새 비밀번호 일치 최종 검증
				    if (pw.value !== pw2.value) {
				        alert("새 비밀번호 확인이 일치하지 않습니다.");
				        return;
				    }

				    // ⭐ 3. HTML5 pattern (정규식) 유효성 강제 검증 추가
				    if (!pwdForm.checkValidity()) {
				        // pattern 지침에 적힌 title 메시지를 경고창으로 출력
				        alert(pw.title || "비밀번호 형식이 올바르지 않습니다.");
				        return;
				    }

				    // 4. 최종 컨펌 후 비동기 데이터 전송
				    if (confirm("비밀번호를 변경하시겠습니까?")) {
				        
				        // ⭐ 스프링 DTO 커맨드 객체가 매핑할 수 있도록 URLSearchParams 형식으로 변환
				        const searchParams = new URLSearchParams();
				        searchParams.append("pw", pw.value);
				        searchParams.append("pw2", pw2.value);

				        fetch('/mpchangepw', { 
				            method: 'POST',
				            headers: {
				                'Content-Type': 'application/x-www-form-urlencoded' // 폼 전송 표준 헤더 명시
				            },
				            body: searchParams
				        })
				        .then(response => {
				            // 서버 응답이 JSON이 아닐 경우(예: 404, 500 에러 페이지) 처리
				            if (!response.ok) {
				                throw new Error('서버 응답 오류 발생');
				            }
				            return response.json();
				        })
				        .then(data => {
				            if (data.success) {
				                alert('비밀번호가 성공적으로 변경되었습니다.');
				                pwdModal.style.display = 'none'; 
				                pwdForm.reset();                 
				                pwdMsg.textContent = "";     
				                
				                // 💡 필요 시 로그인 페이지 이동 추가
				                window.location.href = '/login'; 
				            } else {
				                alert('비밀번호 변경에 실패했습니다: ' + data.message);
				            }
				        })
				        .catch(error => {
				            console.error('Error:', error);
				            alert('오류가 발생했습니다. 입력 형식을 다시 확인하거나 잠시 후 시도해주세요.');
				        });
				    }
				});
				
    
</script>
</body>
</html>