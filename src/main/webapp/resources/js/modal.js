/**
 * modal.js
 * 전역 모달 유틸리티 — 등록 모달(#regModal) 열기/닫기 공통 처리
 *
 * layout.jsp에서 모든 페이지에 로드된다.
 * 페이지에 따라 #btnOpenModal, .btn-cancel, textarea[name="content"] 등이
 * 존재하지 않을 수 있으므로 null 방어(if 체크) 후 이벤트를 바인딩한다.
 */

// 페이지 로드 완료 후 이벤트 바인딩 실행
window.onload = function () {
    bind();
}

/**
 * 모달 관련 이벤트 바인딩
 * - #btnOpenModal : 모달 열기 버튼 (없는 페이지에서는 skip)
 * - .btn-cancel   : 모달 닫기 버튼 (없는 페이지에서는 skip)
 * - #regModal     : 모달 바깥 영역 클릭 시 닫기
 * - textarea      : 내용이 기본 높이(80px)를 넘으면 세로 resize 활성화
 */
function bind() {
    var openBtn = document.getElementById('btnOpenModal');
    if (!openBtn) return; // 해당 페이지에 등록 버튼이 없으면 전체 바인딩 skip

    // 등록하기 버튼 클릭 → 모달 표시
    openBtn.addEventListener('click', function () {
        var modal = document.getElementById('regModal');
        if (modal) modal.style.display = 'flex';
    });

    // 취소 버튼 클릭 → 모달 닫기 (null 방어: 일부 페이지에 없을 수 있음)
    var cancelBtn = document.querySelector('.btn-cancel');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function () {
            closeModal();
        });
    }

    // 모달 바깥 영역(backdrop) 클릭 → 모달 닫기 (null 방어)
    var regModal = document.getElementById('regModal');
    if (regModal) {
        regModal.addEventListener('click', function (e) {
            if (e.target === this) closeModal(); // 클릭 대상이 모달 자체(backdrop)일 때만 닫기
        });
    }

    // textarea 자동 높이 조절 (null 방어: request.jsp 외 일부 페이지에는 없음)
    var textarea = document.querySelector('textarea[name="content"]');
    if (textarea) {
        textarea.addEventListener('input', function () {
            if (this.scrollHeight > 80) {
                // 내용이 기본 높이를 넘으면 수동 resize 허용
                this.style.maxHeight = 'none';
                this.style.resize = 'vertical';
            } else {
                // 기본 높이 이하이면 고정 크기 유지
                this.style.maxHeight = '80px';
                this.style.resize = 'none';
            }
        });
    }
}

/**
 * 등록 모달을 닫는다.
 * closeModal()은 다른 JS 파일에서 직접 호출될 수 있으므로 전역 함수로 선언.
 */
function closeModal() {
    var modal = document.getElementById('regModal');
    if (modal) modal.style.display = 'none';
}
