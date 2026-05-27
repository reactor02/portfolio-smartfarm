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
    <div class="login-form">
        <p class="section-title">사원 로그인</p>
        <!-- 1. 사원번호 입력창 -->
   <!-- 1. 사원번호 입력창: 1글자 이상 입력 조건 -->
    <input type="text" 
           name="emp_num" 
           placeholder="사원번호를 입력해주세요." 
           class="input-field" 
           required
           pattern="\S+"
           title="사원번호를 입력해주세요.">
           
    <!-- 2. 비밀번호 입력창 -->
    <input type="password" 
           name="pw" 
           placeholder="비밀번호를 입력해주세요." 
           class="input-field" 
           required
           pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+~`\-={}\[\]:;&quot;'<>,.?\/]).{8,20}"
           title="비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자로 입력해주세요.">
        <div class="find-account-section">
            <a href="/searchpw" class="find-link" >아이디/패스워드 찾기</a>
        </div>

        <button type="submit" class="submit-btn">로그인하기</button>
    
    </div>
  
</div>

<script>
	const login = document.querySelector('.submit-btn');
	login.addEventListener('click', function() {
	const id = document.querySelector('input[name="emp_num"]');
	const pw = document.querySelector('input[name="pw"]');
	
	
	if( !id.checkValidity() || !pw.checkValidity() ) {
		
		id.reportValidity() || pw.reportValidity(); 
		console.log("규정에 맞춰 작성해주세요.")
		return;
	}
	
	let json = {
			emp_num : id.value,
			pw : pw.value	
	};
	
	const url = "/login";
	
	fetch( url, {
		method : 'POST',
		headers: {                          // [2] 무엇을 (데이터의 종류)?
		        'Content-Type': 'application/json' 
		    },
		body: JSON.stringify(json)
		
	}).then(response => {
		// [1단계] 서버가 보낸 택배(응답)의 '겉포장'을 뜯고 JSON 데이터로 읽기 변환
		 if (!response.ok) {
        throw new Error('서버 오류 발생!');
    	}
		
		return response.json();			
	}).then(data => {
	    // [2단계] 포장지 안의 '진짜 내용물(data)'을 꺼내서 화면 이동이나 알림창 띄우기
	    console.log(data); 
	    
	    if (data.success === true) {
	        alert(data.message);         // "로그인에 성공했습니다."
	        window.location.href = '/usermanage'; // 메인 화면으로 리다이렉트(이동)
	    } else {
	        alert(data.message);         // "사원번호 또는 비밀번호가 틀렸습니다."
	        // 화면 새로고침이 없으므로, 사용자는 입력했던 아이디/비번을 안 지우고 그대로 수정 가능!
	    }
	    
	}).catch(error => {
        // 💡 [핵심] 인터넷이 끊겼거나, 서버(Tomcat)가 완전히 다운되었을 때 이리로 들어옵니다.
        console.error('통신 에러 발생:', error); 
        
        // 유저에게 화면으로 친절하게 안내창을 띄워줍니다.
        alert('서버와의 통신이 원활하지 않습니다. 관리자에게 문의해 주세요.');
    });
	
	
		
	})
</script>
<script type="text/javascript">
    // 컨트롤러에서 model.addAttribute("message", "...")로 보낸 값이 여기에 주입됩니다.
    var alertMessage = "${message}";
    
    // 값이 존재할 때만 알림창(alert)을 띄웁니다.
    if (alertMessage && alertMessage.trim() !== "") {
        alert(alertMessage);
    }
</script>

</body>
</html>