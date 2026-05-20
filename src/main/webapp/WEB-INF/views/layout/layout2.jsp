<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>NodeFarm MES</title>
<style>
    * { 
        box-sizing: border-box; 
        margin: 0; 
        padding: 0; 
    }
    body { 
        font-family: 'Malgun Gothic', sans-serif; 
        background-color: #F8F9FA; 
    }
    /* 화면 전체를 flex 컨테이너로 만들어 정중앙 정렬 */
    .mat-all { 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        min-height: 100vh; 
        width: 100vw;
    }
    /* 본문 영역 최적화 */
    .cont { 
        width: 100%;
        max-width: 500px; /* 로그인 박스가 너무 퍼지지 않도록 최대 너비 제한 */
        padding: 2rem; 
    }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/page.css">
</head>
<body>

<div class="mat-all">
    <main class="cont">
        <tiles:insertAttribute name="content" />
    </main>
</div>

</body>
</html>