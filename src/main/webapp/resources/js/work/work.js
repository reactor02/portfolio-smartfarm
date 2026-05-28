function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}

function filterWorkItems() {
    var type = document.getElementById('workItemType').value;
    var sel  = document.getElementById('workItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

function validateReg() {
    if (!document.getElementById('planNumInput').value) {
        alert('생산계획을 선택해주세요.');
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

function openPlanModal() {
    document.getElementById('planSearchModal').style.display = 'flex';
    document.getElementById('planKeyword').value = '';
    searchPlans(1);
}

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

function fmtDate(ts) {
    if (!ts) return '-';
    var d   = new Date(ts);
    var y   = d.getFullYear();
    var m   = String(d.getMonth() + 1).padStart(2, '0');
    var day = String(d.getDate()).padStart(2, '0');
    return y + '-' + m + '-' + day;
}

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
});
