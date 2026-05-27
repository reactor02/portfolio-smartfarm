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
    * { box-sizing: border-box; margin: 0; padding: 0; }

    /* 컨테이너 및 타이틀 */
    .pw-change-container { width: 400px; padding: 30px 25px; background: #FFF; border: 1px solid #DDD; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
    .section-title { text-align: center; font-size: 15px; font-weight: bold; color: var(--s-cl); margin-bottom: 25px; }
    .pw-change-form { display: flex; flex-direction: column; }
    .input-group-container { margin-bottom: 20px; }

    /* 입력창 및 레이블 정렬 */
    .input-group { display: flex; align-items: center; margin-bottom: 12px; }
    .input-group label { width: 80px; font-size: 13px; color: #333; text-align: right; margin-right: 10px; font-weight: bold; }
    .input-group input { flex: 1; height: 38px; padding: 0 10px; border: 1px solid #CCC; border-radius: 4px; font-size: 14px; }
    .input-group input:focus { outline: none; border-color: var(--m-cl); }

    /* 변경 버튼 */
    .submit-btn { width: 80%; height: 42px; margin: 10px auto 20px auto; background: var(--m-cl); border: none; border-radius: 4px; color: #FFF; font-size: 14px; font-weight: bold; cursor: pointer; transition: background 0.2s; }
    .submit-btn:hover { background: #1B4332; }

    /* 하단 하이퍼링크 */
    .nav-section { display: flex; padding-left: 10px; }
    .nav-link { font-size: 13px; color: #666; text-decoration: none; }
    .nav-link:hover { color: var(--m-cl); text-decoration: underline; }
</style>

<div class="pw-change-container">
    <p class="section-title">비밀번호 변경</p>

    <form method="post" action="/changepw" class="pw-change-form">
        <div class="input-group-container">
            <!-- 사원번호 입력 -->
            <!-- 현재 비밀번호 입력 -->
            <div class="input-group">
                <label for="current-pw">새 비밀번호 :</label>
                 <input type="password" 
                 id="current-pw"
           name="pw" 
           placeholder="비밀번호를 입력해주세요." 
           class="input-field" 
           required
           pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
           title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
            </div>
            <!-- 새 비밀번호 입력 -->
            <div class="input-group">
                <label for="new-pw" style="font-size : 0.75em;">비밀번호확인 :</label>
                 <input type="password" 
                 id="new-pw"
           name="pw2" 
           placeholder="비밀번호를 입력해주세요." 
           class="input-field" 
           required
           pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
           title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
            </div>
        </div>

        <!-- 변경 실행 버튼 -->
        <button type="submit" class="submit-btn">비밀번호 변경</button>

        <!-- 로그인 화면 복귀 링크 -->
        <div class="nav-section">
            <a href="/login" class="nav-link">← 로그인으로 돌아가기</a>
        </div>
    </form>
</div>

<script>

// 프론트엔드 Ajax 요청 예시 (fetch 사용 시)
fetch('/changepw', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(passwordData)
})
.then(res => res.json())
.then(data => {
    if (data.success) {
        alert(data.message); // "비밀번호가 변경되었습니다."
        location.href = "/login"; // [성공] 로그인 페이지로 이동!
    } else {
        alert(data.message); // "비밀번호 변경에 실패했습니다." 또는 "인증 만료"
        // [실패] 페이지 이동 없이 현재 화면 유지 (입력란 초기화 등)
        document.getElementById("newPassword").value = "";
    }
});
</script>

</body>
</html>