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
    
    
<link rel="stylesheet" href="/resources/css/facility/facility.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet" href="/resources/css/paging.css">
<link rel="stylesheet" href="/resources/css/table.css">

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>시설 관리 페이지</title>

</head>
<body>


<div class="mat-all">
	<!-- header -->
	<tiles:insertAttribute name="header" ignore="true" />
	
	<div class="mat-body">
		<main class="main-cont">
			
			<!-- 타이틀 & 등록 버튼 -->
			<div class="hdr">
			    <h1>시설관리</h1>
                <div class="modal-field">
                    <label>확인자</label>
                    <select name="emp_num">
                        <option value="">선택</option>
                        <c:forEach var="e" items="${emp}">
                            <option value="${e.emp_num}">${e.ename}</option>
                        </c:forEach>
                    </select>
                </div>
			</div>
			
			 <!-- 상단 상태 -->
		    <div class="status-wrap">
		
		        <div class="status-card">
		            <div class="status-title">전체 시설</div>
		            <div class="status-count">${result.countAll}<span class="status-unit">개</span></div>
		        </div>
		
		        <div class="status-card status-normal">
		            <div class="status-title">정상 운영</div>
		            <div class="status-count"><span id="green">0</span><span class="status-unit">개</span></div>
		        </div>
		
		        <div class="status-card status-warning">
		            <div class="status-title">점검 필요</div>
		            <div class="status-count"><span id="yellow">0</span><span class="status-unit">개</span></div>
		        </div>
		
		        <div class="status-card status-danger">
		            <div class="status-title">경보 발생</div>
		            <div class="status-count"><span id="red">0</span><span class="status-unit">개</span></div>
		        </div>
		
		    </div>
		
		    <!-- 시설 카드 -->
		    <div class="facility-grid">
				<!-- ajax로 받기 -->
		    </div>
		
		</main>
	</div>
	
</div>
	
	<!-- footer -->
	<tiles:insertAttribute name="footer" ignore="true" />
	
       	

</body>
<script>
window.addEventListener('load', () => {
    loadFacilityData(); // 최초 1회 실행
    setInterval(loadFacilityData, 3000); // 3초마다 갱신
});

// 10% 이상 편차 발생 시 점검 필요 (Yellow)
function checkYellow(baseValue, currentValue){
    if (!baseValue || !currentValue) return false;
    const min = baseValue * 0.9;
    const max = baseValue * 1.1;
    return currentValue < min || currentValue > max;
}

// 15% 이상 편차 발생 시 경보 발생 (Red)
function checkRed(baseValue, currentValue){
    if (!baseValue || !currentValue) return false;
    const min = baseValue * 0.85;
    const max = baseValue * 1.15;
    return currentValue < min || currentValue > max;
}

function loadFacilityData() {
    fetch('/ajaxList')
        .then(response => response.json())
        .then(data => {
            console.log(data); 
            
            const grid = document.querySelector('.facility-grid');
            let html = '';
            
            // 상단 상태 카운트 초기화
            let green = 0;
            let yellow = 0;
            let red = 0;

         // 리스트 루프 돌기
            data.list.forEach(item => {
                
                // 이 카드의 최종 상태를 결정할 변수 (green -> yellow -> red 순으로 심각도 상승)
                let itemStatus = 'green'; 
                
                // 센서 상태를 판별하는 헬퍼 함수
                const judgeStatus = (base, current) => {
                    if (base == null || current == null || base === '' || current === '') return 'green';
                    if (checkRed(Number(base), Number(current))) return 'red';     // 15% 이상 튀면 레드
                    if (checkYellow(Number(base), Number(current))) return 'yellow'; // 10% 이상 튀면 옐로우
                    return 'green';
                };

                // 각 센서별 글자 색상 클래스를 담을 변수
                let tempClass = '', humClass = '', ecClass = '', phClass = '', lightClass = '';

                // 1. 온도 상태 확인
                if (item.c_temperature != null && item.c_temperature !== '') {
                    const status = judgeStatus(item.m_temperature, item.c_temperature);
                    if (status === 'red') { itemStatus = 'red'; tempClass = 'text-danger'; }
                    else if (status === 'yellow') { tempClass = 'text-warning'; if (itemStatus !== 'red') itemStatus = 'yellow'; }
                }

                // 2. 습도 상태 확인
                if (item.c_humidity != null && item.c_humidity !== '') {
                    const status = judgeStatus(item.m_humidity, item.c_humidity);
                    if (status === 'red') { itemStatus = 'red'; humClass = 'text-danger'; }
                    else if (status === 'yellow') { humClass = 'text-warning'; if (itemStatus !== 'red') itemStatus = 'yellow'; }
                }

                // 3. 토양 EC 상태 확인
                if (item.c_soil_ec != null && item.c_soil_ec !== '') {
                    const status = judgeStatus(item.m_soil_ec, item.c_soil_ec);
                    if (status === 'red') { itemStatus = 'red'; ecClass = 'text-danger'; }
                    else if (status === 'yellow') { ecClass = 'text-warning'; if (itemStatus !== 'red') itemStatus = 'yellow'; }
                }

                // 4. 토양 pH 상태 확인
                if (item.c_soil_ph != null && item.c_soil_ph !== '') {
                    const status = judgeStatus(item.m_soil_ph, item.c_soil_ph);
                    if (status === 'red') { itemStatus = 'red'; phClass = 'text-danger'; }
                    else if (status === 'yellow') { phClass = 'text-warning'; if (itemStatus !== 'red') itemStatus = 'yellow'; }
                }

                // 5. 조도 상태 확인
                if (item.c_illuminance != null && item.c_illuminance !== '') {
                    const status = judgeStatus(item.m_illuminance, item.c_illuminance);
                    if (status === 'red') { itemStatus = 'red'; lightClass = 'text-danger'; }
                    else if (status === 'yellow') { lightClass = 'text-warning'; if (itemStatus !== 'red') itemStatus = 'yellow'; }
                }
                
                // 최종 결정된 설비 상태 카운트에 누적
                if (itemStatus === 'red') red++;
                else if (itemStatus === 'yellow') yellow++;
                else green++;

                // 기존 CSS 클래스명(facility-warning, facility-danger)과 매핑 시켜줍니다.
                let cardColorClass = '';
                if (itemStatus === 'yellow') cardColorClass = 'facility-warning';
                else if (itemStatus === 'red') cardColorClass = 'facility-danger';

                // 기본 카드 레이아웃과 면적 세팅
                html += `
                    <div class="facility-card \${cardColorClass}">
                        <div class="facility-name">\${item.facility_name || '이름 없음'}</div>
                        <div class="facility-info" id="card-id\${item.facility_num}">
                            <div>
                                <span>면적</span> 
                                <span class="facility-value">
                                    <span>\${item.area || 0}</span>
                                    <span>㎡</span>
                                </span>
                            </div>
                `;

                // 온도 HTML 생성 (\${tempClass} 추가)
                if (item.c_temperature != null && item.c_temperature !== '') {
                    html += `
                            <div>
                                <span>온도</span> 
                                <span class="facility-value \${tempClass}">
                                    <span class="temp-value" data-base="\${item.c_temperature}">
                                        \${item.c_temperature}
                                    </span>
                                    <span>°C</span>
                                </span>
                            </div>
                    `;
                }

                // 습도 HTML 생성 (\${humClass} 추가)
                if (item.c_humidity != null && item.c_humidity !== '') {
                    html += `
                            <div>
                                <span>습도</span> 
                                <span class="facility-value \${humClass}">
                                    <span class="hum-value" data-base="\${item.c_humidity}">
                                        \${item.c_humidity}
                                    </span>
                                    <span>%</span>
                                </span>
                            </div>
                    `;
                }

                // 토양 EC HTML 생성 (\${ecClass} 추가)
                if (item.c_soil_ec != null && item.c_soil_ec !== '') {
                    html += `
                            <div>
                                <span>토양 EC</span> 
                                <span class="facility-value \${ecClass}">
                                    <span class="ec-value" data-base="\${item.c_soil_ec}">
                                        \${item.c_soil_ec}
                                    </span>
                                    <span>ppm</span>
                                </span>
                            </div>
                    `;
                }

                // 토양 pH HTML 생성 (\${phClass} 추가)
                if (item.c_soil_ph != null && item.c_soil_ph !== '') {
                    html += `
                            <div>
                                <span>토양 pH</span> 
                                <span class="facility-value \${phClass}">
                                    <span class="ph-value" data-base="\${item.c_soil_ph}">
                                        \${item.c_soil_ph}
                                    </span>
                                </span>
                            </div>
                    `;
                }

                // 조도 HTML 생성 (\${lightClass} 추가)
                if (item.c_illuminance != null && item.c_illuminance !== '') {
                    html += `
                            <div>
                                <span>조도</span> 
                                <span class="facility-value \${lightClass}">
                                    <span class="light-value" data-base="\${item.c_illuminance}">
                                        \${item.c_illuminance}
                                    </span>
                                </span>
                            </div>
                    `;
                }

                // 태그 닫기
                html += `
                        </div>
                    </div>
                `;
            });

            // 완성된 HTML 문자열을 화면에 삽입
            grid.innerHTML = html;

            document.querySelector("#green").textContent = green;
            document.querySelector("#yellow").textContent = yellow;
            document.querySelector("#red").textContent = red;
        })
        .catch(error => {
            console.error('실시간 데이터를 불러오는 중 오류가 발생했습니다:', error);
        });
}
</script>
</html>