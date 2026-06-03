/*
 * work.js — 작업지시 목록 화면 스크립트
 *   - 페이징 / 품목 타입 필터
 *   - 작업지시 등록 모달 유효성 검사(validateReg)
 *   - 생산계획 검색 모달(AJAX): 검색·렌더·페이징·선택
 */

/** 페이지 번호를 hidden input에 넣고 검색 폼 제출 */
function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}

/** 품목 타입 선택값에 맞는 품목만 드롭다운에 표시 */
function filterWorkItems() {
    var type = document.getElementById('workItemType').value;
    var sel  = document.getElementById('workItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

/**
 * 등록 모달 제출 전 유효성 검사.
 * 생산계획 선택 여부, 작업시작일 입력 여부, 그리고
 * 작업시작일이 생산계획 기간(planStart~planEnd) 내인지 확인한다.
 */
function validateReg() {
    if (!document.getElementById('planNumInput').value) {
        alert('생산계획을 선택해주세요.');
        return false;
    }
    if (!document.getElementById('workerNumInput').value) {
        alert('실무자를 선택해주세요.');
        return false;
    }
    var orderQty = parseInt(document.querySelector('[name="order_qty"]').value);
    if (!orderQty || orderQty < 1) {
        alert('지시수량은 1 이상이어야 합니다.');
        return false;
    }
    var orderStart = document.getElementById('orderStartInput').value;
    if (!orderStart) {
        alert('작업시작일을 선택해주세요.');
        return false;
    }
    var planStart = document.getElementById('planStartInput').value;
    var planEnd   = document.getElementById('planEndInput').value;
    if (planStart && planStart !== '-' && planEnd && planEnd !== '-'
            && (orderStart < planStart || orderStart > planEnd)) {
        alert('작업시작일은 생산계획 기간 내에서 선택해주세요.\n(' + planStart + ' ~ ' + planEnd + ')');
        return false;
    }
    return true;
}

/** 생산계획 검색 모달 열기 + 키워드 초기화 후 1페이지 검색 */
function openPlanModal() {
    document.getElementById('planSearchModal').style.display = 'flex';
    document.getElementById('planKeyword').value = '';
    searchPlans(1);
}

/** 생산계획 검색 AJAX — 결과를 테이블/페이징으로 렌더링 */
function searchPlans(page) {
    var keyword = document.getElementById('planKeyword').value;
    fetch('/work/plans?keyword=' + encodeURIComponent(keyword) + '&page=' + page)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            renderPlanTable(data.list);
            renderPlanPaging(data.currentPage, data.totalPages);
        })
        .catch(function() { alert('검색 중 오류가 발생했습니다.'); });
}

/** 검색된 생산계획 목록을 모달 테이블 행으로 그린다(행 클릭 시 selectPlan) */
function renderPlanTable(list) {
    var tbody = document.getElementById('planSearchBody');
    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;color:#888;">검색 결과가 없습니다.</td></tr>';
        return;
    }
    var html = '';
    list.forEach(function(p) {
        html += '<tr style="cursor:pointer;" onclick="selectPlan(\'' + p.plan_id + '\',\'' + p.plan_num + '\',\'' + fmtDate(p.plan_start) + '\',\'' + fmtDate(p.plan_end) + '\')">'
              + '<td style="text-align:center;">' + (p.plan_id    || '') + '</td>'
              + '<td style="text-align:center;">' + (p.item_name  || '') + '</td>'
              + '<td style="text-align:center;">' + (p.plan_qty   || '') + '</td>'
              + '<td style="text-align:center;">' + fmtDate(p.plan_start) + '</td>'
              + '<td style="text-align:center;">' + fmtDate(p.plan_end)   + '</td>'
              + '<td style="text-align:center;">' + (p.plan_status || '') + '</td>'
              + '</tr>';
    });
    tbody.innerHTML = html;
}

/** 타임스탬프/날짜값을 yyyy-MM-dd 문자열로 변환 (없으면 '-') */
function fmtDate(ts) {
    if (!ts) return '-';
    var d   = new Date(ts);
    var y   = d.getFullYear();
    var m   = String(d.getMonth() + 1).padStart(2, '0');
    var day = String(d.getDate()).padStart(2, '0');
    return y + '-' + m + '-' + day;
}

/** 생산계획 검색 모달의 페이지네이션 버튼 렌더링 */
function renderPlanPaging(cur, total) {
    var wrap = document.getElementById('planPagination');
    var html = '';
    if (cur > 1)
        html += '<a href="#" class="pg-btn" onclick="searchPlans(' + (cur - 1) + ');return false;">이전</a>';
    for (var p = 1; p <= total; p++) {
        html += p === cur
            ? '<a href="#" class="pg-btn pg-active">' + p + '</a>'
            : '<a href="#" class="pg-btn" onclick="searchPlans(' + p + ');return false;">' + p + '</a>';
    }
    if (cur < total)
        html += '<a href="#" class="pg-btn" onclick="searchPlans(' + (cur + 1) + ');return false;">다음</a>';
    wrap.innerHTML = html;
}

/** 모달에서 생산계획 선택 — 폼에 값 채우고 작업시작일 선택 범위를 계획 기간으로 제한 */
function selectPlan(planId, planNum, planStart, planEnd) {
    document.getElementById('planDisplay').value    = planId;
    document.getElementById('planNumInput').value   = planNum;
    document.getElementById('planStartInput').value = planStart || '';
    document.getElementById('planEndInput').value   = planEnd   || '';

    // 작업시작일 날짜 선택 범위를 생산계획 기간으로 제한 (유효한 날짜일 때만)
    var dateInput = document.getElementById('orderStartInput');
    if (dateInput) {
        dateInput.min   = (planStart && planStart !== '-') ? planStart : '';
        dateInput.max   = (planEnd   && planEnd   !== '-') ? planEnd   : '';
        dateInput.value = '';  // 계획 변경 시 날짜 초기화
    }

    document.getElementById('planSearchModal').style.display = 'none';
}

/** 실무자 검색 모달 열기 + 키워드 초기화 후 1페이지 검색 */
function openWorkerModal() {
    document.getElementById('workerSearchModal').style.display = 'flex';
    document.getElementById('workerKeyword').value = '';
    searchWorkers(1);
}

/** 실무자 검색 AJAX — 부서 3·5 재직자를 테이블/페이징으로 렌더링 */
function searchWorkers(page) {
    var keyword = document.getElementById('workerKeyword').value;
    fetch('/work/workers?keyword=' + encodeURIComponent(keyword) + '&page=' + page)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            renderWorkerTable(data.list);
            renderWorkerPaging(data.currentPage, data.totalPages);
        })
        .catch(function() { alert('검색 중 오류가 발생했습니다.'); });
}

/** 검색된 실무자 목록을 모달 테이블 행으로 그린다(행 클릭 시 selectWorker) */
function renderWorkerTable(list) {
    var tbody = document.getElementById('workerSearchBody');
    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:#888;">검색 결과가 없습니다.</td></tr>';
        return;
    }
    var html = '';
    list.forEach(function(w) {
        var empNum = w.EMP_NUM   || '';
        var ename  = w.ENAME     || '';
        var dept   = w.DEPT_NAME || '';
        var tel    = w.TEL       || '';
        html += '<tr style="cursor:pointer;" onclick="selectWorker(\'' + empNum + '\',\'' + ename + '\')">'
              + '<td style="text-align:center;">' + empNum + '</td>'
              + '<td style="text-align:center;">' + ename  + '</td>'
              + '<td style="text-align:center;">' + dept   + '</td>'
              + '<td style="text-align:center;">' + tel    + '</td>'
              + '</tr>';
    });
    tbody.innerHTML = html;
}

/** 실무자 검색 모달의 페이지네이션 버튼 렌더링 */
function renderWorkerPaging(cur, total) {
    var wrap = document.getElementById('workerPagination');
    var html = '';
    if (cur > 1)
        html += '<a href="#" class="pg-btn" onclick="searchWorkers(' + (cur - 1) + ');return false;">이전</a>';
    for (var p = 1; p <= total; p++) {
        html += p === cur
            ? '<a href="#" class="pg-btn pg-active">' + p + '</a>'
            : '<a href="#" class="pg-btn" onclick="searchWorkers(' + p + ');return false;">' + p + '</a>';
    }
    if (cur < total)
        html += '<a href="#" class="pg-btn" onclick="searchWorkers(' + (cur + 1) + ');return false;">다음</a>';
    wrap.innerHTML = html;
}

/** 모달에서 실무자 선택 — 폼에 표시값(이름+사번)과 hidden 사번을 채운다 */
function selectWorker(empNum, ename) {
    document.getElementById('workerDisplay').value  = ename + ' (' + empNum + ')';
    document.getElementById('workerNumInput').value = empNum;
    document.getElementById('workerSearchModal').style.display = 'none';
}

// 초기화: 품목 필터 1회 적용 + 모달 바깥 클릭 닫기 + 검색창 Enter 바인딩
document.addEventListener('DOMContentLoaded', function() {
    filterWorkItems();

    document.getElementById('workRegModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
    document.getElementById('planSearchModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
    document.getElementById('planKeyword').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') searchPlans(1);
    });
    document.getElementById('workerSearchModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
    document.getElementById('workerKeyword').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') searchWorkers(1);
    });
});
