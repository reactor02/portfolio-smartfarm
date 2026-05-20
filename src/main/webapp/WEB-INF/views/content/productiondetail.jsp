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
        /* [1] 보내주신 최종 레이아웃 CSS 스타일 (그대로 유지) */
        :root { 
            --m-cl: #2D6A4F; 
            --s-cl: #49A47A; 
            --p-cl: #B7E4C7; 
            --bg: #F8F9FA; 
            --txt: #333; 
            /* 상태 컬러 추가 정의 */
            --warning-cl: #FFB703;
            --danger-cl: #E63946;
            --border-cl: #E9ECEF;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Malgun Gothic', sans-serif; color: var(--txt); background-color: var(--bg); }
        .mat-all { display: flex; flex-direction: column; min-height: 100vh; }
        .hdr { display: flex; justify-content: space-between; align-items: center; background-color: var(--m-cl); color: #FFF; padding: 0 20px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .hdr-logo-area { display: flex; align-items: center; text-decoration: none; color: #FFF; }
        .hdr-logo-img { height: 40px; width: auto; margin-right: 10px; }
        .hdr-logo-txt { font-size: 1.4rem; font-weight: bold; letter-spacing: -1px; }
        .hdr-user { font-size: 0.9rem; }
        .hdr-user a { color: var(--p-cl); text-decoration: none; margin-left: 10px; }
        .wrap { display: flex; flex: 1; }
        .side { width: 240px; background-color: #FFF; border-right: 1px solid #DDD; }
        .nav-list { list-style: none; }
        .nav-item { border-bottom: 1px solid #EEE; }
        .nav-btn { display: block; padding: 1rem 1.5rem; cursor: pointer; font-weight: bold; color: var(--m-cl); transition: background 0.3s; text-decoration: none; user-select: none; }
        .nav-btn:hover { background-color: var(--p-cl); }
        .sub-nav { list-style: none; display: none; background-color: #F9FDFB; }
        .sub-nav.on { display: block; }
        .sub-nav a { display: block; padding: 0.7rem 1.5rem 0.7rem 2.5rem; font-size: 0.9rem; color: #555; text-decoration: none; }
        .sub-nav a:hover { color: var(--m-cl); font-weight: bold; text-decoration: underline; text-underline-offset: 4px; }
        .cont { flex: 1; padding: 2rem; background-color: #FFF; }
        .ftr { text-align: center; padding: 1rem 0; background-color: #EEE; font-size: 0.8rem; color: #777; margin-top: auto; }

        /* [2] 상세 본문 구성용 전용 디자인 속성 (브랜드 컬러와 동기화) */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid var(--m-cl); }
        .page-title { font-size: 1.5rem; font-weight: bold; color: var(--txt); }
        
        .btn-group button { padding: 8px 18px; border-radius: 6px; border: 1px solid var(--border-cl); background: #FFF; cursor: pointer; font-weight: bold; margin-left: 6px; font-size: 13px; transition: background 0.2s; }
        .btn-group .btn-back { background-color: var(--m-cl); color: #FFF; border: none; }
        .btn-group .btn-back:hover { background-color: var(--s-cl); }
        .btn-group .btn-cancel:hover { background-color: var(--bg); }
        
        .section-title { font-size: 1.1rem; font-weight: bold; margin: 2rem 0 1rem 0; color: var(--m-cl); }
        
        /* 기본 정보 그리드 */
        .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; background-color: var(--bg); padding: 20px; border: 1px solid var(--border-cl); border-radius: 8px; }
        .info-item { display: flex; flex-direction: column; gap: 6px; }
        .info-label { font-size: 12px; color: #777; font-weight: bold; }
        .info-value { font-size: 14px; font-weight: bold; }
        .badge { background-color: var(--p-cl); color: var(--m-cl); padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; width: fit-content; }

        /* 생산 진행 현황 */
        .status-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 1.5rem; text-align: center; }
        .status-card { background-color: #FFF; border: 1px solid var(--border-cl); padding: 16px; border-radius: 8px; }
        .status-num { font-size: 1.3rem; font-weight: bold; margin-top: 6px; }
        
        /* 진행률 바 */
        .progress-box { background-color: var(--bg); border: 1px solid var(--border-cl); padding: 20px; border-radius: 8px; }
        .progress-bar-bg { background-color: #E9ECEF; height: 12px; border-radius: 6px; overflow: hidden; margin-top: 8px; }
        .progress-bar-fill { background-color: var(--s-cl); height: 100%; width: 66%; transition: width 0.3s ease; }
        .progress-text { display: flex; justify-content: flex-end; font-size: 13px; font-weight: bold; color: var(--s-cl); margin-top: 6px; }

        /* 데이터 테이블 */
        .data-table { width: 100%; border-collapse: collapse; margin-top: 0.5rem; }
        .data-table th { background-color: var(--bg); border-bottom: 2px solid var(--s-cl); color: var(--txt); font-weight: bold; padding: 12px; text-align: center; font-size: 13px; }
        .data-table td { padding: 12px; border-bottom: 1px solid var(--border-cl); text-align: center; color: #555; }
        .data-table tbody tr:hover { background-color: rgba(183, 228, 199, 0.15); } /* 포인트 컬러 연하게 효과 */

        /* 공정 정보 */
        .link-text { color: var(--s-cl); font-weight: bold; text-decoration: none; }
        .link-text:hover { text-decoration: underline; }
        .instruction-box { background-color: var(--bg); padding: 18px; border-left: 4px solid var(--s-cl); margin-top: 15px; border-top: 1px solid var(--border-cl); border-right: 1px solid var(--border-cl); border-bottom: 1px solid var(--border-cl); border-radius: 0 8px 8px 0; }
    </style>
</head>
<body>

 
            
            <!-- 3. 본문 영역 (cont) -->
            <main class="cont">
                
                <div class="page-header">
                    <h1 class="page-title">생산계획 상세</h1>
                    <div class="btn-group">
                        <button class="btn-back" onclick="history.back();">목록으로</button>
                        <button class="btn-cancel">취소</button>
                    </div>
                </div>

                <!-- 1. 기본 정보 -->
                <div class="section-title">■ 기본 정보</div>
                <div class="info-grid">
                    <div class="info-item"><span class="info-label">계획번호</span><span class="info-value">pp-22</span></div>
                    <div class="info-item"><span class="info-label">상태</span><span class="badge">진행중</span></div>
                    <div class="info-item"><span class="info-label">담당자</span><span class="info-value">홍길동</span></div>
                    <div class="info-item"><span class="info-label">품목명</span><span class="info-value">반제품A</span></div>
                    <div class="info-item"><span class="info-label">품목 코드</span><span class="info-value">t-01</span></div>
                    <div class="info-item"><span class="info-label">품목 유형</span><span class="info-value">반제품</span></div>
                    <div class="info-item"><span class="info-label">생산시작일</span><span class="info-value">2026-05-07</span></div>
                    <div class="info-item"><span class="info-label">생산마감일</span><span class="info-value">2026-05-30</span></div>
                    <div class="info-item"><span class="info-label">등록일</span><span class="info-value">2026-05-03</span></div>
                </div>

                <!-- 2. 생산 진행 현황 -->
                <div class="section-title">■ 생산 진행 현황</div>
                <div class="status-grid">
                    <div class="status-card"><div class="info-label">계획 수량</div><div class="status-num">300 EA</div></div>
                    <div class="status-card"><div class="info-label" style="color: var(--s-cl);">생산 완료</div><div class="status-num" style="color: var(--s-cl);">200 EA</div></div>
                    <div class="status-card"><div class="info-label">잔여 수량</div><div class="status-num">100 EA</div></div>
                    <div class="status-card"><div class="info-label" style="color: var(--danger-cl);">불량 수량</div><div class="status-num" style="color: var(--danger-cl);">0 EA</div></div>
                </div>
                <div class="progress-box">
                    <div class="info-label">진행률</div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                    <div class="progress-text">66%</div>
                </div>

                <!-- 3. 작업 이력 -->
                <div class="section-title">■ 작업 이력</div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">번호</th>
                            <th>작업지시번호</th>
                            <th>작업일</th>
                            <th>작업자</th>
                            <th>생산수량</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>1</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
                        <tr><td>2</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
                        <tr><td>3</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
                    </tbody>
                </table>

                <!-- 4. 공정 정보 -->
                <div class="section-title">■ 공정 정보</div>
                <div style="margin-bottom: 8px;"><span class="info-label">공정 정보 링크:</span> <a href="#" class="link-text">반제품A 공정관리 링크</a></div>
                <div class="instruction-box">
                    <span class="info-label" style="display:block; margin-bottom:6px;">상세 지시사항</span>
                    <strong>지정된 공정 매뉴얼에 따라 안전하게 작업해 주세요.</strong>
                </div>
                
            </main>
        </div>
        
        <!-- 4. 푸터 영역 -->
        <footer class="ftr">
            Copyright © Smart Factory. All Rights Reserved.
        </footer>
    </div>



</body>
</html>