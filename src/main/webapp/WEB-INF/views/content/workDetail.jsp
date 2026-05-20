<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업지시 상세</title>
<style>
    /* prodDetail.jsp CSS 그대로 + 추가 스타일 */
    :root {
        --m-cl: #2D6A4F;
        --s-cl: #49A47A;
        --p-cl: #B7E4C7;
        --bg: #F8F9FA;
        --txt: #333;
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

    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid var(--m-cl); }
    .page-title { font-size: 1.5rem; font-weight: bold; color: var(--txt); }

    .btn-group button { padding: 8px 18px; border-radius: 6px; border: 1px solid var(--border-cl); background: #FFF; cursor: pointer; font-weight: bold; margin-left: 6px; font-size: 13px; transition: background 0.2s; }
    .btn-group .btn-back { background-color: var(--m-cl); color: #FFF; border: none; }
    .btn-group .btn-back:hover { background-color: var(--s-cl); }
    .btn-group .btn-reg { background-color: var(--s-cl); color: #FFF; border: none; }
    .btn-group .btn-reg:hover { background-color: var(--m-cl); }
    .btn-group .btn-cancel:hover { background-color: var(--bg); }

    .section-title { font-size: 1.1rem; font-weight: bold; margin: 2rem 0 1rem 0; color: var(--m-cl); }

    /* 기본 정보 그리드 */
    .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; background-color: var(--bg); padding: 20px; border: 1px solid var(--border-cl); border-radius: 8px; }
    .info-item { display: flex; flex-direction: column; gap: 6px; }
    .info-label { font-size: 12px; color: #777; font-weight: bold; }
    .info-value { font-size: 14px; font-weight: bold; }
    .badge { background-color: var(--p-cl); color: var(--m-cl); padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; width: fit-content; }

    /* 작업 현황 */
    .status-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 1.5rem; text-align: center; }
    .status-card { background-color: #FFF; border: 1px solid var(--border-cl); padding: 16px; border-radius: 8px; }
    .status-num { font-size: 1.3rem; font-weight: bold; margin-top: 6px; }

    /* 진행률 바 */
    .progress-box { background-color: var(--bg); border: 1px solid var(--border-cl); padding: 20px; border-radius: 8px; }
    .progress-bar-bg { background-color: #E9ECEF; height: 12px; border-radius: 6px; overflow: hidden; margin-top: 8px; }
    .progress-bar-fill { background-color: var(--s-cl); height: 100%; transition: width 0.3s ease; }
    .progress-text { display: flex; justify-content: flex-end; font-size: 13px; font-weight: bold; color: var(--s-cl); margin-top: 6px; }

    /* 하단 2열 레이아웃 (공정 정보 + 불량 기록) */
    .bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 0.5rem; }

    /* 데이터 테이블 */
    .data-table { width: 100%; border-collapse: collapse; margin-top: 0.5rem; }
    .data-table th { background-color: var(--bg); border-bottom: 2px solid var(--s-cl); color: var(--txt); font-weight: bold; padding: 12px; text-align: center; font-size: 13px; }
    .data-table td { padding: 12px; border-bottom: 1px solid var(--border-cl); text-align: center; color: #555; }
    .data-table tbody tr:hover { background-color: rgba(183, 228, 199, 0.15); }

    /* 공정 정보 */
    .link-text { color: var(--s-cl); font-weight: bold; text-decoration: none; }
    .link-text:hover { text-decoration: underline; }
    .instruction-box { background-color: var(--bg); padding: 18px; border-left: 4px solid var(--s-cl); margin-top: 15px; border-top: 1px solid var(--border-cl); border-right: 1px solid var(--border-cl); border-bottom: 1px solid var(--border-cl); border-radius: 0 8px 8px 0; }

    /* 섹션 박스 */
    .section-box { border: 1px solid var(--border-cl); border-radius: 8px; padding: 20px; background-color: #FFF; }
    .section-box .section-title { margin-top: 0; }
</style>
</head>
<body>

    <main class="cont">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">작업지시 상세</h1>
            <div class="btn-group">
                <button class="btn-back" onclick="history.back();">목록으로</button>
                <button class="btn-reg">작업 등록</button>
                <button class="btn-cancel">취소</button>
            </div>
        </div>

        <!-- 1. 기본 정보 -->
        <div class="section-title">■ 기본 정보</div>
        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">작업번호</span>
                <span class="info-value">${workDTO.work_order_id}</span>
            </div>
            <div class="info-item">
                <span class="info-label">상태</span>
                <span class="badge">${workDTO.work_status}</span>
            </div>
            <div class="info-item">
                <span class="info-label">작업자</span>
                <span class="info-value">${workDTO.ename}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목명</span>
                <span class="info-value">${workDTO.item_name}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목 코드</span>
                <span class="info-value">${workDTO.code}</span>
            </div>
            <div class="info-item">
                <span class="info-label">품목 유형</span>
                <span class="info-value">${workDTO.type}</span>
            </div>
            <div class="info-item">
                <span class="info-label">작업일</span>
                <span class="info-value">${workDTO.order_start}</span>
            </div>
            <div class="info-item">
                <span class="info-label">작업완료</span>
                <span class="info-value">${workDTO.order_end}</span>
            </div>
            <div class="info-item">
                <span class="info-label">등록일</span>
                <span class="info-value">${workDTO.created_at}</span>
            </div>
        </div>

        <!-- 2. 작업 현황 -->
        <div class="section-title">■ 작업 현황</div>
        <div class="status-grid">
            <div class="status-card">
                <div class="info-label">계획 수량</div>
                <div class="status-num">${workDTO.plan_qty}</div>
            </div>
            <div class="status-card">
                <div class="info-label" style="color: var(--s-cl);">생산 완료</div>
                <div class="status-num" style="color: var(--s-cl);">${workDTO.current_qty}</div>
            </div>
            <div class="status-card">
                <div class="info-label">잔여 수량</div>
                <div class="status-num">
                    ${workDTO.plan_qty - workDTO.current_qty < 0 ? 0 : workDTO.plan_qty - workDTO.current_qty}
                </div>
            </div>
            <div class="status-card">
                <div class="info-label" style="color: var(--danger-cl);">불량 수량</div>
                <div class="status-num" style="color: var(--danger-cl);">${workDTO.scrap_qty}</div>
            </div>
        </div>
        <div class="progress-box">
            <div class="info-label">진행률</div>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" id="progressBar"></div>
            </div>
            <div class="progress-text" id="progressText"></div>
        </div>

        <!-- 3. 공정 정보 + 불량 기록 -->
        <div class="bottom-grid">

            <!-- 공정 정보 -->
            <div class="section-box">
                <div class="section-title">■ 공정 정보</div>
                <div style="margin-bottom: 8px;">
                    <span class="info-label">공정 정보 링크:</span>
                    <a href="#" class="link-text">${workDTO.item_name} 공정관리 링크</a>
                </div>
                <div class="instruction-box">
                    <span class="info-label" style="display:block; margin-bottom:6px;">상세 지시사항</span>
                    <strong>${workDTO.content}</strong>
                </div>
            </div>

            <!-- 불량 기록 -->
            <div class="section-box">
                <div class="section-title">■ 불량 기록</div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>불량 종류</th>
                            <th>수량</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty defectList}">
                                <c:forEach var="d" items="${defectList}">
                                    <tr>
                                        <td>${d.defect_type}</td>
                                        <td>${d.defect_qty}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="2">불량 기록 없음</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </div>

    </main>

<script>
    window.onload = function () {
        setProgress();
    }

    function setProgress() {
        var planQty  = ${workDTO.plan_qty};
        var currentQty = ${workDTO.current_qty};

        if (planQty <= 0) return;

        var pct = (currentQty / planQty) * 100;
        if (pct > 100) pct = 100;

        document.getElementById('progressBar').style.width = pct.toFixed(1) + '%';
        document.getElementById('progressText').innerText = pct.toFixed(1) + '%';
    }
</script>

</body>
</html>