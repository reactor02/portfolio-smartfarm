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

    <form class="pw-change-form">
        <div class="input-group-container">
            <!-- 사원번호 입력 -->
            <div class="input-group">
                <label for="emp-no">사원번호 :</label>
                <input type="text" id="emp-no" required>
            </div>
            <!-- 현재 비밀번호 입력 -->
            <div class="input-group">
                <label for="current-pw">현재 PW :</label>
                <input type="password" id="current-pw" required>
            </div>
            <!-- 새 비밀번호 입력 -->
            <div class="input-group">
                <label for="new-pw">새 PW :</label>
                <input type="password" id="new-pw" required>
            </div>
        </div>

        <!-- 변경 실행 버튼 -->
        <button type="submit" class="submit-btn">비밀번호 변경</button>

        <!-- 로그인 화면 복귀 링크 -->
        <div class="nav-section">
            <a href="#" class="nav-link">← 로그인으로 돌아가기</a>
        </div>
    </form>
</div>

</body>
</html>