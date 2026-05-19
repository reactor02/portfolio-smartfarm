<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

.menu-item.active {
    color: #000000;
    text-decoration: underline;
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

/* 중앙 본문 영역 */
.content-body {
    flex: 1;
    background-color: #ffffff;
    padding: 40px 20px;
    display: flex;
    justify-content: center;
    align-items: flex-start;
}

/* 2분할 가로 배열 그리드 */
.dashboard-grid {
    display: flex;
    gap: 30px;
    width: 100%;
    max-width: 900px;
}

/* 개별 카드 공통 박스 스타일 */
.card-box {
    flex: 1;
    border: 1px solid #000000;
    border-radius: 15px;
    padding: 20px;
    background-color: #ffffff;
    min-height: 380px;
}

/* 카드 상단 타이틀 영역 */
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 10px;
}

.card-header.border-none {
    justify-content: center;
    padding-bottom: 0;
}

.card-title {
    font-size: 18px;
    font-weight: bold;
    color: #333333;
}

.card-title.center {
    text-align: center;
}

/* 1. 내 정보 수정 버튼 */
.edit-btn {
    background-color: #aaaaaa;
    border: 1px solid #777777;
    font-size: 11px;
    padding: 4px 10px;
    cursor: pointer;
    border-radius: 4px;
}

/* 2. 사용자 정보 입력창 스타일 */
.card-content {
    display: flex;
    flex-direction: column;
}

.card-content.flex-column {
    height: calc(100% - 40px);
}

.info-group {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
}

.info-group label {
    width: 70px;
    font-size: 13px;
    color: #333333;
    text-align: right;
    margin-right: 15px;
}

.info-group input {
    flex: 1;
    height: 35px;
    padding: 0 10px;
    background-color: #aaaaaa;
    border: 1px solid #777777;
    color: #000000;
    font-size: 14px;
}

/* 3. 오늘 작업 목록 상태 바 */
.status-bar {
    display: flex;
    justify-content: space-between;
    font-size: 13px;
    margin-bottom: 15px;
    font-weight: bold;
}

.status-item {
    padding: 3px 8px;
}

.badge-dark {
    background-color: #555555;
    color: #ffffff;
}

/* 내부 회색 큰 작업 내역 박스 */
.work-list-box {
    flex: 1;
    background-color: #aaaaaa;
    border: 1px solid #777777;
    min-height: 160px;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 15px;
}

.work-item-placeholder {
    font-size: 16px;
    color: #333333;
}

/* 4. 하단 이동 링크 */
.nav-section {
    display: flex;
    justify-content: flex-start;
}

.nav-link {
    font-size: 13px;
    color: #d11a2a; /* 설계서상 붉은색 테두리 강조선 느낌을 반영한 컬러 */
    text-decoration: none;
    font-weight: bold;
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

        <!-- 하단 콘텐츠 영역 -->
        <div class="content-wrapper">
            
            <!-- 왼쪽 사이드바 메뉴 -->
            <aside class="sidebar">
                <nav class="menu-group">
                    <a href="#" class="menu-item active">마이페이지</a>
                    <a href="#" class="menu-item">대시보드</a>
                    
                    <div class="menu-section">
                        <p class="section-name">기준 관리</p>
                        <a href="#" class="sub-item">공통 코드 관리</a>
                        <a href="#" class="sub-item">자재 관리</a>
                        <a href="#" class="sub-item">BOM 관리</a>
                        <a href="#" class="sub-item">공정 관리</a>
                        <a href="#" class="sub-item">설비 관리</a>
                        <a href="#" class="sub-item">거래처 관리</a>
                        <a href="#" class="sub-item">사용자/권한 관리</a>
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

            <!-- 메인 본문 (2분할 카드 레이아웃) -->
            <main class="content-body">
                <div class="dashboard-grid">
                    
                    <!-- 왼쪽 카드: 마이페이지 (사용자 정보) -->
                    <section class="card-box">
                        <div class="card-header">
                            <h2 class="card-title">마이페이지</h2>
                            <!-- 1. 정보 수정 버튼 -->
                            <button type="button" class="edit-btn">내 정보 수정</button>
                        </div>
                        
                        <!-- 2. 사용자 정보 입력창 -->
                        <div class="card-content">
                            <div class="info-group">
                                <label for="user-name">이름 :</label>
                                <input type="text" id="user-name" value="-" readonly>
                            </div>
                            <div class="info-group">
                                <label for="user-pw">PW :</label>
                                <input type="password" id="user-pw" value="*****" readonly>
                            </div>
                            <div class="info-group">
                                <label for="user-phone">연락처 :</label>
                                <input type="text" id="user-phone" value="-" readonly>
                            </div>
                            <div class="info-group">
                                <label for="user-dept">부서 :</label>
                                <input type="text" id="user-dept" value="-" readonly>
                            </div>
                            <div class="info-group">
                                <label for="join-date">입사일 :</label>
                                <input type="text" id="join-date" value="-" readonly>
                            </div>
                        </div>
                    </section>

                    <!-- 오른쪽 카드: 내 오늘 작업 -->
                    <section class="card-box">
                        <div class="card-header border-none">
                            <h2 class="card-title center">내 오늘 작업</h2>
                        </div>
                        
                        <!-- 3. 오늘 작업 목록 및 대기/진행/완료 현황 -->
                        <div class="card-content flex-column">
                            <div class="status-bar">
                                <div class="status-item badge-dark">대기 : 1건</div>
                                <div class="status-item">진행중 : 1건</div>
                                <div class="status-item">완료 : 1건</div>
                            </div>
                            
                            <div class="work-list-box">
                                <div class="work-item-placeholder">-</div>
                            </div>

                            <!-- 4. 작업 지시서 링크 -->
                            <div class="nav-section">
                                <a href="#" class="nav-link">작업지시서로</a>
                            </div>
                        </div>
                    </section>

                </div>
            </main>

        </div>
    </div>

</body>
</html>