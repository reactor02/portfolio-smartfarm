function filterProdItems() {
    var type = document.getElementById('prodItemType').value;
    var sel  = document.getElementById('prodItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

function validateDate() {
    var start = document.getElementById('startDate').value;
    var end   = document.getElementById('endDate').value;
    if (start && end && start > end) {
        alert('시작 날짜는 종료 날짜보다 이후일 수 없습니다.');
        document.getElementById('endDate').value = '';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    filterProdItems();

    document.getElementById('btnOpenModal').addEventListener('click', function() {
        document.getElementById('regModal').style.display = 'flex';
    });
    document.getElementById('btnCloseModal').addEventListener('click', function() {
        document.getElementById('regModal').style.display = 'none';
    });
    document.getElementById('regModal').addEventListener('click', function(e) {
        if (e.target === this) this.style.display = 'none';
    });
});
