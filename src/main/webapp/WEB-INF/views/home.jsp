<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 현재 시간 구하기 (테스트용) --%>
<jsp:useBean id="now" class="java.util.Date" />

<style>
    .test-container { padding: 10px; }
    .status-cards { display: flex; gap: 20px; margin-top: 20px; }
    .card { 
        flex: 1; padding: 20px; border-radius: 8px; color: #fff;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .card.blue { background-color: #3498db; }
    .card.green { background-color: #2ecc71; }
    .card.orange { background-color: #e67e22; }
    .card h3 { margin-bottom: 10px; font-size: 1.1rem; }
    .card p { font-size: 1.5rem; font-weight: bold; }
</style>

<div class="test-container">
    <h2>🚀 NodeFarm MES 대시보드 테스트</h2>
    <p style="color: #666; margin-bottom: 20px;">
        현재 서버 시간: <strong><fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss" /></strong>
    </p>

    <hr>

    <div class="status-cards">
        <div class="card blue">
            <h3>금일 생산 계획</h3>
            <p>1,250 개</p>
        </div>
        <div class="card green">
            <h3>현재 가동 설비</h3>
            <p>8 / 10 대</p>
        </div>
        <div class="card orange">
            <h3>검사 대기 건수</h3>
            <p>42 건</p>
        </div>
    </div>

    <div style="margin-top: 30px; padding: 20px; border: 1px dashed #ccc; background: #fff;">
        <h4>Tiles 연결 확인 체크리스트</h4>
        <ul style="margin-left: 20px; line-height: 2;">
            <li>상단 헤더가 <strong>NodeFarm MES</strong>로 잘 나오는가?</li>
            <li>왼쪽 사이드바의 <strong>메뉴 토글</strong>이 부드럽게 작동하는가?</li>
            <li>지금 이 내용이 <strong>중앙 컨텐츠 영역</strong>에만 표시되는가?</li>
            <li>하단 푸터에 <strong>2026 NodeFarm</strong> 문구가 보이는가?</li>
        </ul>
    </div>
</div>