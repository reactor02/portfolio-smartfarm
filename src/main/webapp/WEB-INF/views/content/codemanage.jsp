<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>사용자 관리 시스템</title>
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<style>

/* 공통 스타일: 전체 여백 리셋, 기본 폰트 및 기본 최외곽 레이아웃 설정 */
* { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; }
.mat-all { display: flex; flex-direction: column; min-height: 100vh; background-color: #f4f7f6; }
.mat-body { display: flex; flex: 1; }
.main-cont { flex: 1; padding: 2rem 2.5rem; min-width: 0; }

/* 사이드바 스타일: 좌측 고정 메뉴 가로 크기 및 경계선 설정 */
.side { width: 250px; flex-shrink: 0; background-color: #fff; border-right: 1px solid #ddd; }

/* 타이틀 헤더 스타일: 상단 타이틀 바 정렬, 배경색 및 대제목 글자 설정 */
.hdr { display: flex; justify-content: space-between; align-items: center; background-color: #2D6A4F; padding: 15px 25px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, .1); }
.hdr h1 { font-size: 1.8rem; color: #fff; font-weight: 700; letter-spacing: -1px; }

/* 버튼 스타일: 등록용 플러스 버튼 기본 규격, 그림자 및 마우스 호버 효과 설정 */
.btn-plus { display: inline-block; background-color: #fff; color: #2D6A4F; padding: 10px 24px; border: 1px solid #2D6A4F; border-radius: 6px; font-size: 1.05rem; font-weight: 700; cursor: pointer; box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 2px 3px rgba(0, 0, 0, .2); transition: background-color .2s; }
.btn-plus:hover { background-color: #B7E4C7; }

/* 검색 영역 스타일: 상단 검색창 외곽 박스, 내부 행 정렬 및 타이틀 라벨 설정 */
.sch-wrap { background-color: #fff; border: 1px solid #bbb; border-radius: 10px; padding: 20px 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }
.sch-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
.sch-row:last-child { margin-bottom: 0; }
.sch-left { display: flex; align-items: center; gap: 12px; }
.sch-right { display: flex; align-items: center; gap: 12px; }
.label { display: flex; align-items: center; font-size: .95rem; font-weight: 700; color: #333; }

/* 폼 요소 규격 스타일: 인풋 및 셀렉트 박스 높이, 포커스 강조 색상 및 가로 너비 설정 */
.form-control { height: 38px; padding: 0 10px; border: 1px solid #aaa; border-radius: 4px; font-size: .95rem; outline: none; transition: border-color .2s; }
.form-control:focus { border-color: #2D6A4F; }
select.form-control { width: 110px; }

/* 검색 입력 박스: 돋보기 아이콘이 들어가는 검색인풋 외곽 박스 및 내부 테두리 제거 스타일 */
.sch-input-box { display: flex; align-items: center; height: 38px; width: 220px; padding-left: 10px; background: #fff; border: 1px solid #aaa; border-radius: 4px; }
.sch-input-box input { flex: 1; height: 100%; padding: 0 5px; border: none; outline: none; font-size: .95rem; }

/* 검색 버튼: 검색 실행 버튼 규격 설정 및 마우스 호버 시 딥그린 테마 피드백 색상 주입 */
.btn-sch { height: 38px; padding: 0 20px; background-color: #fff; color: #2D6A4F; border: 1px solid #2D6A4F; border-radius: 4px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: .2s; }
.btn-sch:hover { background-color: #B7E4C7; }

/* 초기화 버튼: 검색 조건 리셋 버튼 규격 설정 및 마우스 호버 시 주황색 피드백 색상 주입 */
.select-reset { height: 38px; padding: 0 20px; background-color: #fff; color: #2D6A4F; border: 1px solid #2D6A4F; border-radius: 4px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: .2s; }
.select-reset:hover { background-color: #FFB703; }

/* 라디오 버튼: 순정 디자인 해제 후 원형 선택 마크 및 블루 테마 컬러 커스텀 스타일 */
.radio-label { display: flex; align-items: center; gap: 6px; font-size: .95rem; font-weight: 700; color: #333; cursor: pointer; }
.radio-label input[type="radio"] { appearance: none; -webkit-appearance: none; width: 18px; height: 18px; border: 2px solid #aaa; border-radius: 50%; position: relative; outline: none; cursor: pointer; }
.radio-label input[type="radio"]:checked { border-color: #4A90E2; }
.radio-label input[type="radio"]:checked::after { content: ""; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 10px; height: 10px; border-radius: 50%; background-color: #4A90E2; }

/* 데이터 테이블: 테이블을 감싸는 박스의 배경색, 그림자 및 내부 행 마우스 호버 시 연그린 피드백 적용 */
.tbl-box { background: #fff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 8px rgba(0, 0, 0, .03); }
.stk-tbl { width: 100%; border-collapse: collapse; border-top: 2px solid #555; border-bottom: 2px solid #555; }
.stk-tbl th { background-color: #e9ecef; color: #222; padding: 12px 10px; border: 1px solid #ccc; border-top: none; font-weight: 700; font-size: .95rem; }
.stk-tbl td { padding: 12px 10px; border: 1px solid #ccc; text-align: center; color: #333; font-size: .95rem; }
.stk-tbl tbody tr:hover { background-color: #f1f8f5; }

/* 테이블 내 링크: 기본 상태 딥그린 볼드 처리 및 마우스 호버 시 밑줄 효과 주입 */
.link-txt { color: #2D6A4F; text-decoration: none; font-weight: 700; }
.link-txt:hover { text-decoration: underline; }

/* 모달창 기본 구조: 전 화면 암전 오버레이 레이아웃 및 중앙 정렬 콘텐츠 박스 설정 */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0, 0, 0, .5); z-index: 1000; }
.modal-box { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 100%; max-width: 600px; padding: 30px; background-color: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0, 0, 0, .15); box-sizing: border-box; }

/* 모달 그리드: 유연한 필드 배치를 위한 플렉스 그리드 구조 및 크기별 가변 클래스 설정 */
.modal-grid { display: flex; flex-wrap: wrap; gap: 15px 20px; margin-bottom: 20px; width: 100%; box-sizing: border-box; }
.modal-field { display: flex; flex-direction: column; gap: 6px; width: calc(50% - 10px); box-sizing: border-box; }
.modal-field.quarter { width: calc(25% - 15px); box-sizing: border-box; }
.modal-field.full { width: 100%; box-sizing: border-box; }

</style>
</head>
<body>

	<div class="mat-all">
		<tiles:insertAttribute name="header" ignore="true" />

		<div class="mat-body">
			<main class="main-cont">
				<div class="hdr">
					<h1>코드 관리</h1>
					<button type="button" class="btn-reg">+ 등록하기</button>
				</div>

				<form name="searchFrm" id="searchFrm" action="/codesearch"
					method="get">
					<div class="sch-wrap">
						<div class="sch-row">
							<div class="sch-left">
								<span class="label">▶ 타입</span>
								<!-- 💡 name="type" 추가 -->
								<select id="dType" name="type" class="form-control">
									<option value="">선택</option>
									<c:forEach var="b" items="${ selectd }">
										<!-- 💡 value에 이름이 아닌 부서'번호'를 바인딩해야 정확히 검색됩니다 -->
										<option value="${b.type}">${ b.type }</option>
									</c:forEach>
								</select> <span class="label">▶ 단위</span>
								<!-- 💡 name="unit" 추가 -->
								<select id="lType" name="unit" class="form-control">
									<option value="">선택</option>
									<c:forEach var="l" items="${ selectl }">
										<option value="${l.unit}">${ l.unit }</option>
									</c:forEach>
								</select>
							</div>

							<div class="sch-right">
								<div class="sch-input-box">
									<span style="color: #888;">🔍</span>
									<!-- 💡 name="keyword" 추가 -->
									<input type="text" id="keyword" name="keyword"
										value="${param.keyword}" placeholder=" 제품명 / 코드명">
								</div>
								<!-- 💡 함수 연결을 위해 onclick 속성 부여 -->
								<button type="button" class="btn-sch" onclick="doSearch()">검색</button>
								<button type="button" class="select-reset"
									onclick="resetSearch()">검색 초기화</button>
							</div>
						</div>
					</div>
				</form>

				<div class="tbl-box">
					<table class="stk-tbl">
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>시퀀스</th>
								<th>코드명</th>
								<th>유형</th>
								<th>단위</th>
								<th>가격</th>
								<th>사용여부</th>
								<th>안전재고</th>
								<th style="width: 100px;">기능</th>
								<!-- 💡 헤더에 기능 칸 추가 -->
							</tr>
						</thead>
						<tbody id="stock-body">
							<c:choose>
								<c:when test="${not empty CodeList}">
									<c:forEach var="a" items="${CodeList}" varStatus="vs">
										<tr>
											<td>${a.item_num}</td>
											<td>${a.code}</td>
											<td><span class="link-txt">${a.name}</span></td>
											<td>${a.type}</td>
											<td>${a.unit}</td>
											<td>${a.price}</td>
											<td>${a.item_status}</td>
											<td>${a.safe}</td>
											<td>
											<c:if test="${a.item_status eq 'A'}">
													<button type="button" class="btn-disable"
														onclick="disableItem('${a.item_num}')"
														style="padding: 4px 8px; background-color: #ff4d4d; color: white; border: none; border-radius: 4px; cursor: pointer;">
														비활성화</button>
												</c:if> <c:if test="${a.item_status eq 'N'}">
													<span style="color: #aaa; font-size: 13px;">중단됨</span>
												</c:if>
												</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<!-- 데이터 없을 때 출력되는 5줄 (colspan을 9로 확장) -->
									<c:forEach var="i" begin="1" end="5">
										<tr>
											<td style="font-weight: bold; color: #888;">${i}</td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
				<!-- 코드 등록 -->
				<div id="regModal" class="modal-overlay" style="display: none;">
					<div class="modal-box">
						<h3 class="modal-title">코드 등록</h3>

						<form method="POST" action="/codeinsert" id="insert-form">
							<div class="modal-grid">

								<div class="modal-field">
									<label for="quantity">제품명</label> <input type="text"
										name="name" id="name" placeholder="이름">
								</div>
								<div class="modal-field">
									<label for="quantity">기준가격</label> <input type="text"
										name="price" id="price" placeholder="기준가격">
								</div>

								<div class="modal-field">
									<label for="quantity">안전재고</label> <input type="text"
										name="safe" id="safe" placeholder="안전재고">
								</div>

								<!-- 1. 맨 위 div를 modal-grid로 바꾸고 flex 스타일 주입 -->
								<!-- type, unit, emp_num을 한 세트로 묶어 오른쪽 48.5% 공간을 정확하게 차지하도록 설정 -->
								<div class="dept-auth-wrap"
									style="width: 48% !important; display: flex !important; justify-content: space-between !important; align-items: flex-end !important; box-sizing: border-box !important;">

									<!-- type 영역 (우측 세트 내부에서 왼쪽 반 차지) -->
									<div class="modal-field"
										style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
										<label for="dType-e">타입</label> <select id="dType-e"
											class="form-control" name="type"
											style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
											<option value="all">선택</option>
											<c:forEach var="b" items="${ selectd }">
												<option value="${b.type}">${ b.type }</option>
											</c:forEach>
										</select>
									</div>

									<!-- unit 영역 (우측 세트 내부에서 오른쪽 반 차지) -->
									<div class="modal-field"
										style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
										<label for="lType-e">단위</label> <select id="lType-e"
											class="form-control" name="unit"
											style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
											<option value="all">선택</option>
											<c:forEach var="b" items="${ selectl }">
												<option value="${b.unit}">${ b.unit }</option>
											</c:forEach>
										</select>
									</div>

								</div>
								<!-- emp_num 영역 (우측 세트 내부에서 오른쪽 반 차지) -->
								<div class="modal-field"
									style="width: 47% !important; display: flex !important; flex-direction: column !important; gap: 6px !important;">
									<label for="lType-e">담당자</label> <select id="lType-n"
										class="form-control" name="emp_num"
										style="width: 100% !important; min-width: 100% !important; height: 38px !important; box-sizing: border-box !important;">
										<option value="all">선택</option>
										<c:forEach var="b" items="${ selectm }">
											<option value="${b.emp_num}">${ b.ename }</option>
										</c:forEach>
									</select>
								</div>

							</div>

							<div class="modal-btn-wrap" style="margin-top: 20px;">
								<button type="button" class="btn-plus">등록</button>
								<button type="button" class="btn-cancel">취소</button>
							</div>
						</form>
					</div>
				</div>



				<!-- 스크립트 -->
				<!-- 스크립트 -->
				<script>
    // ==========================================
    // 1. 모달창 열기 / 닫기 및 [팀 표준] 취소 제어
    // ==========================================
    const plus_btn = document.querySelector(".btn-reg");     // + 등록하기 버튼
    const modal = document.querySelector(".modal-overlay");  // 모달창 껍데기
    const btn_cancel = document.querySelector(".btn-cancel"); // 취소 버튼

    // [열기] 등록하기 버튼 클릭 시 모달 띄우기
    if (plus_btn && modal) {
        plus_btn.addEventListener('click', () => {
            modal.style.display = "block";
        });
    }

    // [닫기 및 리셋] [팀 표준] 취소 버튼 연동 (컨펌 후 화면 리셋)
    if (btn_cancel) {
        btn_cancel.addEventListener('click', () => {
            if (confirm("등록을 취소하시겠습니까?")) {
                location.reload(); // 화면을 새로고침하여 입력값 초기화 및 모달 닫기
            }
        });
    }

    // ==========================================
    // 2. [팀 표준] 알림창 제어 및 주소창 쿼리스트링 제거
    // ==========================================
    const msgFlag = "${msg}";
    console.log("msgFlag: ", msgFlag);
    if (msgFlag == "true") {
        alert("등록되었습니다.");
        // 등록 성공 후 주소창에 남아있는 ?msg=true 쓰레기 값 깨끗이 청소
        window.history.replaceState({}, document.title, window.location.pathname);
    } else if (msgFlag == "false") {
        alert("등록에 실패했습니다.");
    }

    // ==========================================
    // 3. 🔍 검색 실행 및 초기화 기능 (type, unit 구조 맞춤)
    // ==========================================
    // [검색 실행]
    function doSearch() {
        const form = document.searchFrm;
        const type = document.getElementById("dType").value;
        const unit = document.getElementById("lType").value;
        const keyword = document.getElementById("keyword").value.trim();

        // 아무 조건도 선택/입력하지 않고 검색을 누른 경우 차단
        if (!type && !unit && !keyword) {
            alert("검색 조건을 하나 이상 선택하거나 입력해주세요.");
            return;
        }

        // 공백 제거 키워드 재세팅 후 폼 서브밋
        document.getElementById("keyword").value = keyword;
        form.submit();
    }

    // [검색 초기화]
    function resetSearch() {
        document.getElementById("dType").value = "";
        document.getElementById("lType").value = "";
        document.getElementById("keyword").value = "";
        
        // 코드 관리 컨트롤러 본래 주소로 깔끔하게 리다이렉트
        location.href = "/codesearch"; 
    }

    // [엔터키 검색 편의성 증가]
    const keywordInput = document.getElementById("keyword");
    if (keywordInput) {
        keywordInput.addEventListener("keyup", function(event) {
            if (event.key === "Enter") {
                event.preventDefault(); 
                doSearch(); 
            }
        });
    }

    // ==========================================
    // 4. 💾 모달창 코드 등록 유효성 검증 및 전송
    // ==========================================
    const btn_plus = document.querySelector(".btn-plus");
    if (btn_plus) {
        btn_plus.addEventListener('click', () => {
            
            // HTML 도면에 정의된 인풋 및 셀렉트 객체 정확히 매핑
            const nameInput = document.querySelector("input[name='name']");      // 제품명
            const priceInput = document.querySelector("input[name='price']");    // 기준가격
            const safeInput = document.querySelector("input[name='safe']");      // 안전재고
            
            const dType = document.querySelector("#dType-e").value; // 타입 셀렉트
            const lType = document.querySelector("#lType-e").value; // 단위 셀렉트
            const mType = document.querySelector("#lType-n").value; // 담당자 셀렉트 (#lType-n 반영)

            // 제품명 빈값 검증
            if (!nameInput.value.trim()) {
                alert("제품명을 입력해주세요.");
                nameInput.focus();
                return;
            }
            
            // 기준가격 빈값 및 숫자 검증 (오라클 ORA-01722 무조건 방어)
            if (!priceInput.value.trim()) {
                alert("기준가격을 입력해주세요.");
                priceInput.focus();
                return;
            }
            if (isNaN(priceInput.value.trim())) {
                alert("기준가격은 숫자만 입력 가능합니다.");
                priceInput.focus();
                return;
            }
            
            // 안전재고 빈값 및 숫자 검증
            if (!safeInput.value.trim()) {
                alert("안전재고를 입력해주세요.");
                safeInput.focus();
                return;
            }
            if (isNaN(safeInput.value.trim())) {
                alert("안전재고는 숫자만 입력 가능합니다.");
                safeInput.focus();
                return;
            }

            // 셀렉트 박스 필수 선택 검증 (HTML의 "all" 또는 빈값 선택 차단)
            if (dType === "all" || dType === "") {
                alert("타입을 선택해주세요.");
                return;
            }
            if (lType === "all" || lType === "") {
                alert("단위를 선택해주세요.");
                return;
            }
            if (mType === "all" || mType === "") {
                alert("담당자를 선택해주세요.");
                return;
            }

            // 모든 유효성 관문 통과 시 /codeinsert 주소로 전송
            const insert_form = document.querySelector("#insert-form");
            insert_form.submit();
        });
    }
    
    // ==========================================
    // 5. 🚫 [GET 방식] 항목 비활성화 다이렉트 전송 함수
    // ==========================================
    function disableItem(itemNum) {
        // HTML 버튼에서 던져준 진짜 item_num 숫자가 매개변수로 쏙 들어옵니다.
        if (confirm(`번호 [\${itemNum}] 항목을 비활성화(N) 처리하시겠습니까?`)) {
            // 요청하신 /codemanage 주소 규격에 맞춰 GET 방식으로 화면을 전환합니다
            location.href = `/codeDisable?item_num=\${itemNum}`;
        }
    }
    
    
</script>
</body>
</html>