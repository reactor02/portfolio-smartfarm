<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    /* 핵심 브랜드 컬러 변수 정의 */
    :root { --m-cl: #2D6A4F; --s-cl: #49A47A; --p-cl: #B7E4C7; }
    
    /* 레이아웃 중앙 정렬 및 박스 초기화 */
    body { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: #F8F9FA; font-family: sans-serif; }
    * { box-sizing: border-box; margin: 0; padding: 0; }

    /* 컨테이너 및 섹션 */
    .login-container { width: 400px; padding: 30px 20px; background: #FFF; border: 1px solid #DDD; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    .section-title { text-align: center; font-size: 13px; font-weight: bold; color: var(--s-cl); margin-bottom: 15px; }
    .sns-login-section { margin-bottom: 25px; }
    .sns-buttons { display: flex; justify-content: center; gap: 12px; }
    
    /* 버튼 및 입력창 공통 크기 설정 */
    .sns-btn { width: 40px; height: 40px; border-radius: 50%; border: 1px solid #DDD; background: #FFF; cursor: pointer; }
    .sns-btn:hover { background: var(--p-cl); border-color: var(--s-cl); }
    .login-form { display: flex; flex-direction: column; }
    .input-field, .submit-btn { width: 100%; height: 45px; border-radius: 6px; font-size: 14px; }
    
    /* 입력창 및 링크 */
    .input-field { padding: 0 15px; margin-bottom: 10px; border: 1px solid #CCC; }
    .input-field:focus { outline: none; border-color: var(--m-cl); }
    .find-account-section { display: flex; justify-content: flex-end; margin-bottom: 15px; }
    .find-link { font-size: 13px; color: #666; text-decoration: none; }
    .find-link:hover { color: var(--m-cl); text-decoration: underline; }

    /* 로그인 제출 버튼 */
    .submit-btn { background: var(--m-cl); border: none; color: #FFF; font-weight: bold; cursor: pointer; }
    .submit-btn:hover { background: #1B4332; }
</style>

<div class="login-container">
    <!-- 1. SNS 로그인 -->
    <div class="sns-login-section">
        <p class="section-title">SNS 계정 간편 로그인</p>
        <div class="sns-buttons">
            <button type="button" class="sns-btn" title="네이버"></button>
            <button type="button" class="sns-btn" title="카카오"></button>
            <button type="button" class="sns-btn" title="구글"></button>
        </div>
    </div>

    <!-- 2. 로그인 입력 폼 -->
    <form class="login-form">
        <p class="section-title">사원 로그인</p>
        <input type="text" placeholder="사원번호를 입력해주세요." class="input-field" required>
        <input type="password" placeholder="비밀번호를 입력해주세요." class="input-field" required>
        
        <div class="find-account-section">
            <a href="#" class="find-link">아이디/패스워드 찾기</a>
        </div>

        <button type="submit" class="submit-btn">로그인하기</button>
    </form>
</div>

</body>
</html>