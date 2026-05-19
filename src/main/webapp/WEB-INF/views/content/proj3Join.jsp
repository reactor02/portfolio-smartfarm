<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 기본 스타일 초기화 */
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: sans-serif;
}

body {
    background-color: #ffffff;
    padding: 20px;
}

/* 상단 경로 표시 */
.page-path {
    font-size: 14px;
    margin-bottom: 10px;
    color: #333333;
}

/* 메인 구조 */
.main-container {
    border: 1px solid #cccccc;
    display: flex;
    flex-direction: column;
    min-height: 800px;
}

/* 상단 헤더 바 */
.header-bar {
    display: flex;
    align-items: center;
    background-color: #555555;
    color: #ffffff;
    padding: 10px 20px;
    height: 50px;
}

.logo {
    font-weight: bold;
    font-size: 16px;
    width: 150px;
}

.header-title {
    flex: 1;
    text-align: center;
    font-size: 22px;
    font-weight: bold;
    color: #333333; /* 설계서 상에서 '사용자 관리' 글씨 색상이 어두우므로 수정 가능 */
}

/* 실제 설계서처럼 헤더 텍스트를 밖으로 빼거나 다르게 처리하려면 조정 가능합니다 */
.header-bar .header-title {
    color: #ffffff; 
}

.user-info {
    display: flex;
    gap: 15px;
    font-size: 14px;
}

.logout-btn {
    color: #ffffff;
    text-decoration: none;
}

/* 하단 레이아웃 (사이드바 + 본문) */
.content-wrapper {
    display: flex;
    flex: 1;
}

/* 왼쪽 사이드바 */
.sidebar {
    width: 180px;
    background-color: #eaeaea;
    padding: 15px 10px;
    border-right: 1px solid #cccccc;
}

.menu-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.menu-item {
    font-size: 14px;
    font-weight: bold;
    color: #333333;
    text-decoration: none;
    margin-bottom: 5px;
}

.menu-section {
    margin-bottom: 8px;
}

.section-name {
    font-size: 14px;
    font-weight: bold;
    color: #333333;
    margin-bottom: 4px;
}

.sub-item {
    display: block;
    font-size: 11px;
    color: #666666;
    text-decoration: none;
    padding-left: 10px;
    margin-bottom: 3px;
}

.sub-item.active {
    font-weight: bold;
    color: #000000;
}

/* 중앙 본문 영역 */
.content-body {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #ffffff;
    padding: 40px;
}

/* 등록 폼 박스 */
.register-container {
    width: 420px;
    padding: 30px 25px;
    background-color: #ffffff;
    border: 1px solid #000000;
    border-radius: 15px;
}

.register-title {
    text-align: center;
    font-size: 15px;
    font-weight: bold;
    color: #333333;
    margin-bottom: 25px;
}

.register-form {
    display: flex;
    flex-direction: column;
}

/* 1. 입력창 영역 */
.input-group-container {
    margin-bottom: 20px;
}

.input-group {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
}

.input-group label {
    width: 70px;
    font-size: 13px;
    color: #333333;
    text-align: right;
    margin-right: 10px;
}

.input-group input {
    flex: 1;
    height: 35px;
    padding: 0 10px;
    background-color: #aaaaaa;
    border: 1px solid #777777;
    color: #000000;
    font-size: 14px;
}

/* 부서 및 내선번호 복합 행 */
.flex-row {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 5px;
}

.flex-row select {
    flex: 1;
    height: 35px;
    background-color: #aaaaaa;
    border: 1px solid #777777;
    padding: 0 5px;
}

.label-inline {
    font-size: 12px;
    white-space: nowrap;
    color: #333333;
}

/* 2. 회원가입 버튼 */
.submit-btn {
    width: 80%;
    height: 40px;
    margin: 0 auto 20px auto;
    background-color: #aaaaaa;
    border: 1px solid #777777;
    color: #333333;
    font-size: 14px;
    cursor: pointer;
}

.submit-btn:hover {
    background-color: #999999;
}

/* 3. 하단 이동 링크 */
.nav-section {
    display: flex;
    justify-content: flex-start;
    padding-left: 10px;
}

.nav-link {
    font-size: 13px;
    color: #555555;
    text-decoration: none;
}

.nav-link:hover {
    text-decoration: underline;
}
</style>
</head>
<body>

 <!-- 상단 네비게이션 경로 -->
    <div class="page-path">Page > SAMPLE</div>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        
        <!-- 상단 헤더 바 -->
        <header class="header-bar">
            <div class="logo">LOGO</div>
            <div class="header-title">사용자 관리</div>
            <div class="user-info">
                <span>000님</span>
                <a href="#" class="logout-btn">로그아웃</a>
            </div>
        </header>

        <!-- 하단 콘텐츠 영역 (사이드바 + 메인 본문) -->
        <div class="content-wrapper">
            
            <!-- 왼쪽 사이드바 메뉴 -->
            <aside class="sidebar">
                <nav class="menu-group">
                    <a href="#" class="menu-item">마이페이지</a>
                    <a href="#" class="menu-item">대시보드</a>
                    
                    <div class="menu-section">
                        <p class="section-name">기준 관리</p>
                        <a href="#" class="sub-item">공통 코드 관리</a>
                        <a href="#" class="sub-item">자재 관리</a>
                        <a href="#" class="sub-item">BOM 관리</a>
                        <a href="#" class="sub-item">공정 관리</a>
                        <a href="#" class="sub-item">설비 관리</a>
                        <a href="#" class="sub-item">거래처 관리</a>
                        <a href="#" class="sub-item active">사용자/권한 관리</a>
                    </div>

                    <div class="menu-section">
                        <p class="section-name">생산 관리</p>
                        <a href="#" class="sub-item">생산 계획</a>
                        <a href="#" class="sub-item">작업 지시</a>
                    </div>

                    <div class="menu-section">
                        <p class="section-name">품질 관리</p>
                        <a href="#" class="sub-item">품질 검사</a>
                        <a href="#" class="sub-item">불량 관리</a>
                    </div>

                    <div class="menu-section">
                        <p class="section-name">창고 관리</p>
                        <a href="#" class="sub-item">입/출고 관리</a>
                        <a href="#" class="sub-item">재고 현황</a>
                    </div>

                    <div class="menu-section">
                        <p class="section-name">이력 및 추적 관리</p>
                        <a href="#" class="sub-item">Lot 번호 관리</a>
                        <a href="#" class="sub-item">이력 추적</a>
                    </div>

                    <a href="#" class="menu-item">게시판</a>
                    <a href="#" class="menu-item">리포트</a>
                </nav>
            </aside>

            <!-- 중앙 사용자 등록 폼 영역 -->
            <main class="content-body">
                <div class="register-container">
                    <p class="register-title">----- 사용자 등록 -----</p>

                    <form class="register-form">
                        <!-- 1. 사용자 등록 인풋창 -->
                        <div class="input-group-container">
                            <div class="input-group">
                                <label for="user-name">이름 :</label>
                                <input type="text" id="user-name" required>
                            </div>
                            <div class="input-group">
                                <label for="user-pw">PW :</label>
                                <input type="password" id="user-pw" required>
                            </div>
                            <div class="input-group">
                                <label for="user-phone">연락처 :</label>
                                <input type="text" id="user-phone" required>
                            </div>
                            <div class="input-group">
                                <label for="user-dept">부서 :</label>
                                <div class="flex-row">
                                    <select id="user-dept">
                                        <option value="">선택</option>
                                    </select>
                                    <span class="label-inline">내선번호 :</span>
                                    <select id="extension-no">
                                        <option value="">선택</option>
                                    </select>
                                </div>
                            </div>
                            <div class="input-group">
                                <label for="user-auth">지급품 :</label>
                                <input type="text" id="user-auth">
                            </div>
                        </div>

                        <!-- 2. 사용자 등록 버튼 -->
                        <button type="submit" class="submit-btn">회원가입</button>

                        <!-- 3. 사용자 관리 페이지로 이동 링크 -->
                        <div class="nav-section">
                            <a href="#" class="nav-link">사용자 관리 페이지로</a>
                        </div>
                    </form>
                </div>
            </main>

        </div>
    </div>

</body>
</html>