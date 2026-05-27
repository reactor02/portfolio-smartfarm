function movePage(p) {
    document.getElementById('pageInput').value = p;
    document.getElementById('searchForm').submit();
}

function filterLotItems() {
    var type = document.getElementById('lotItemType').value;
    var sel  = document.getElementById('lotItemNum');
    sel.value = '0';
    Array.from(sel.options).forEach(function(opt) {
        if (!opt.value || opt.value === '0') return;
        opt.style.display = (!type || opt.dataset.type === type) ? '' : 'none';
    });
}

document.addEventListener('DOMContentLoaded', function() {
    filterLotItems();
});
