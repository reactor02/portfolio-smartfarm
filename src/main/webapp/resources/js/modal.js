window.onload = function () {
    bind();
}

function bind() {
    // 등록하기 버튼
    document.getElementById('btnOpenModal').addEventListener('click', function () {
        document.getElementById('regModal').style.display = 'flex';
    });

    // 취소 버튼
    document.querySelector('.btn-cancel').addEventListener('click', function () {
        closeModal();
    });

    // 바깥 클릭
    document.getElementById('regModal').addEventListener('click', function (e) {
        if (e.target === this) closeModal();
    });

    // 텍스트에어리어 넘칠 때만 resize 활성화
    document.querySelector('textarea[name="content"]').addEventListener('input', function () {
        if (this.scrollHeight > 80) {
            this.style.maxHeight = 'none';
            this.style.resize = 'vertical';
        } else {
            this.style.maxHeight = '80px';
            this.style.resize = 'none';
        }
    });
}

function closeModal() {
    document.getElementById('regModal').style.display = 'none';
}