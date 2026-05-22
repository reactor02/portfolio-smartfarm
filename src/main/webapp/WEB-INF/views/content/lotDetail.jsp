<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOT 관리 상세</title>
<style>
    :root { --m-cl:#2D6A4F; --s-cl:#49A47A; --p-cl:#B7E4C7; --bg:#F8F9FA; --txt:#333; --border-cl:#E9ECEF; --danger-cl:#E63946; }
    * { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Malgun Gothic',sans-serif; color:var(--txt); background:var(--bg); }
    .cont { flex:1; padding:2rem; background:#FFF; }

    .page-header { display:flex; flex-direction:column; margin-bottom:2rem; padding-bottom:1rem; border-bottom:2px solid var(--m-cl); }
    .page-title  { font-size:1.5rem; font-weight:bold; color:var(--txt); }
    .btn-row     { display:flex; justify-content:space-between; align-items:center; margin-bottom:0.75rem; }
    .btn-row button { padding:8px 18px; border-radius:6px; border:1px solid var(--border-cl); background:#FFF; cursor:pointer; font-weight:bold; font-size:13px; transition:background 0.2s; }
    .btn-row .btn-back   { background:var(--m-cl); color:#FFF; border:none; }
    .btn-row .btn-back:hover { background:var(--s-cl); }

    .section-title { font-size:1.1rem; font-weight:bold; margin:2rem 0 1rem 0; color:var(--m-cl); }
    .info-grid  { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; background:var(--bg); padding:20px; border:1px solid var(--border-cl); border-radius:8px; }
    .info-item  { display:flex; flex-direction:column; gap:6px; }
    .info-label { font-size:12px; color:#777; font-weight:bold; }
    .info-value { font-size:14px; font-weight:bold; }
    .badge      { background:var(--p-cl); color:var(--m-cl); padding:3px 10px; border-radius:12px; font-size:11px; font-weight:bold; width:fit-content; }

    /* 하단 2열 */
    .bottom-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-top:0.5rem; }
    .section-box { border:1px solid var(--border-cl); border-radius:8px; padding:20px; background:#FFF; }
    .section-box .section-title { margin-top:0; }

    /* 공정 이력 트리 */
    .lot-tree { list-style:none; padding-left:0; }
    .lot-tree li { padding:4px 0; font-size:13px; color:#555; }
    .lot-tree ul { list-style:none; padding-left:20px; border-left:2px solid var(--border-cl); margin-left:8px; }

    /* 소모 자재 테이블 */
    .data-table { width:100%; border-collapse:collapse; margin-top:0.5rem; }
    .data-table th { background:var(--bg); border-bottom:2px solid var(--s-cl); padding:10px; text-align:center; font-size:13px; font-weight:bold; }
    .data-table td { padding:10px; border-bottom:1px solid var(--border-cl); text-align:center; font-size:13px; color:#555; }
</style>
</head>
<body>
<main class="cont">

    <div class="page-header">
        <div class="btn-row">
            <button class="btn-back" onclick="location.href='/lot'">목록으로</button>
        </div>
        <h1 class="page-title">LOT 관리 상세</h1>
    </div>

    <!-- 1. 기본 정보 -->
    <div class="section-title">■ 기본 정보</div>
    <div class="info-grid">
        <div class="info-item">
            <span class="info-label">LOT 번호</span>
            <span class="info-value">${lotDTO.lot_code}</span>
        </div>
        <div class="info-item">
            <span class="info-label">상태</span>
            <span class="badge">${lotDTO.lot_status}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목 유형</span>
            <span class="info-value">${lotDTO.type}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목명</span>
            <span class="info-value">${lotDTO.item_name}</span>
        </div>
        <div class="info-item">
            <span class="info-label">품목 코드</span>
            <span class="info-value">${lotDTO.code}</span>
        </div>
        <div class="info-item">
            <span class="info-label">초기 수량</span>
            <span class="info-value">${lotDTO.init_qty}</span>
        </div>
        <div class="info-item">
            <span class="info-label">현재 수량</span>
            <span class="info-value">${lotDTO.current_qty}</span>
        </div>
        <div class="info-item">
            <span class="info-label">만료일</span>
            <span class="info-value"><fmt:formatDate value="${lotDTO.expiry_date}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="info-item">
            <span class="info-label">생성일</span>
            <span class="info-value"><fmt:formatDate value="${lotDTO.lot_date}" pattern="yyyy-MM-dd"/></span>
        </div>
    </div>

    <!-- 2. 공정 이력 + 소모 자재 -->
    <div class="bottom-grid">

        <!-- 공정 이력 -->
        <div class="section-box">
            <div class="section-title">■ 공정 이력</div>
            <ul class="lot-tree">
                <li>▼ ${lotDTO.lot_code}
                    <ul>
                        <li>등록된 공정 이력이 없습니다.</li>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- 소모 자재 -->
        <div class="section-box">
            <div class="section-title">■ 소모 자재</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>품목명</th>
                        <th>수량</th>
                        <th>소모일</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td colspan="5" style="padding:20px; color:#aaa;">등록된 소모 자재가 없습니다.</td></tr>
                </tbody>
            </table>
        </div>

    </div>

</main>
</body>
</html>
