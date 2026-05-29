<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="hdr">
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