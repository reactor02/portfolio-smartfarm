<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="hdr">
    <a href="/main" class="hdr-logo-area">
        <img src="<c:url value='/resources/img/logo.png'/>" alt="Logo" class="hdr-logo-img" onerror="this.style.display='none'">
        <span class="hdr-logo-txt">NodeFarm MES</span>
    </a>
    <div class="hdr-user">
        <strong>관리자님</strong> 환영합니다 | <a href="#">로그아웃</a>
    </div>
</header>