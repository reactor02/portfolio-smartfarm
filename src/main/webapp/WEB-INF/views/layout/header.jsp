<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
body{
padding: 0px !important;
margin: 0px !important;
}
   .dashboard-wrapper {
    position: relative; 
    margin-left: 1px; 
    width: calc(100% - 5px); /* 원하는 수치로 변경 */
    max-width: calc(100% - 1px); /* 추가: 최대 너비 강제 고정 */
    flex: none; /* 추가: Flexbox 부모가 있을 경우 크기 자동 조절 방지 */
    margin-top: 0 !important; 
    z-index: 1000;
}

    /* 2. 상단 토글 바 (평상시 ▼ 버튼 영역) */
    .dashboard-toggle-bar {
        width: 100%;
        background-color: #f4f7f4; 
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    /* 상단 열기 버튼: 불필요한 여백을 없애서 영역 최소화 */
    .dashboard-toggle-bar button {
        background: transparent;
        border: none;
        cursor: pointer;
        font-size: 14px; 
        color: #2d5a27; 
        width: 100%;
        padding: 2px 0; 
        display: block;
    }
    

    /* 하단 닫기 버튼: 기존 여백 유지 */
    .dashboard-close-bar button {
        background: transparent;
        border: none;
        cursor: pointer;
        font-size: 16px;
        color: #2d5a27; 
        width: 100%;
        padding: 8px 0;
        display: block;
    }
    .dashboard-toggle-bar button:hover,
.dashboard-close-bar button:hover {
    background-color: #B7E4C7;
    transition: background-color 0.3s ease;
}

    /* 3. 슬라이드 패널 (열릴 때 나타나는 영역) */
    .dashboard-slide-panel {
        position: absolute;
        top: 100%; 
        left: 0;
        width: 100%;
        height: 0;
        background-color: #ffffff;
        z-index: 9999; 
        overflow: hidden;
        transition: height 0.4s ease-in-out;
    }

    /* 패널이 열렸을 때 상태 */
    .dashboard-slide-panel.open {
        height: 810px; /* 창 높이 30px 줄인 상태 복구 및 유지 */
        border-bottom: 2px solid #2d5a27;
        box-shadow: 0px 8px 16px rgba(0,0,0,0.15);
    }
    
    /* 4. 대시보드 컨텐츠 영역 */
    .dashboard-content-wrapper {
        padding: 20px;
        height: calc(100% - 35px); /* 하단 닫기버튼 높이 제외 */
        box-sizing: border-box;
        overflow-y: auto; 
    }

    /* 5. 하단 닫기 바 (열렸을 때 ▲ 버튼 영역) */
    .dashboard-close-bar {
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        background-color: #f4f7f4;
        border-top: 1px solid #ddd;
        height: 35px;
    }
</style>

<header class="hdr" style="margin-bottom: 0 !important;">
    <a href="/main" class="hdr-logo-area">
        <img src="<c:url value='/resources/img/logo.png'/>" alt="Logo" class="hdr-logo-img" onerror="this.style.display='none'">
        <span class="hdr-logo-txt">NodeFarm MES</span>
    </a>
    
    <div class="hdr-user">
        <c:choose>
            <c:when test="${empty sessionScope.loginUser}">
                <a href="/login">로그인</a>
            </c:when>
            
            <c:otherwise>
                <strong>${sessionScope.loginUser.ename}님</strong> 환영합니다 | 
                <a href="/mypage">마이페이지</a> | 
                <a href="/logout">로그아웃</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<div class="dashboard-wrapper">
    
    <div class="dashboard-toggle-bar">
        <button id="dashboardToggleBtn" onclick="toggleDashboard()">▼</button>
    </div>

    <div id="dashboardContainer" class="dashboard-slide-panel">
        
        <div class="dashboard-content-wrapper">
        <c:import url="/dashboard2" />
            </div>
        
        <div class="dashboard-close-bar">
            <button onclick="toggleDashboard()">▲</button>
        </div>
        
    </div>
</div>

<script>
    function toggleDashboard() {
        var panel = document.getElementById('dashboardContainer');
        var topBtn = document.getElementById('dashboardToggleBtn');
        
        // 클래스 토글로 CSS 애니메이션 실행
        panel.classList.toggle('open');
        
        // 패널이 열리면 위쪽(▼) 버튼 숨김, 닫히면 다시 보임
        if (panel.classList.contains('open')) {
            topBtn.style.visibility = 'hidden';
        } else {
            topBtn.style.visibility = 'visible';
        }
    }
</script>