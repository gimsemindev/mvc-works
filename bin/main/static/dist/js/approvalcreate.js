// 오늘 날짜 표시
document.getElementById('todayDate').value = new Date().toLocaleDateString('ko-KR', {
    year: 'numeric', month: '2-digit', day: '2-digit', weekday: 'short'
});

// 양식 선택
function selectForm(type) {
    document.getElementById('formSelectModal').classList.add('hidden');
    document.getElementById('approvalForm').classList.add('active');
    // 상단 헤더에 선택한 양식명 표시
    document.getElementById('formDocTitle').textContent = type;
}

// 모달 닫기
function closeModal() {
    document.getElementById('formSelectModal').classList.add('hidden');
    location.href = document.querySelector('meta[name="ctx"]').content + '/approval/list';
}

// 파일명 업데이트
function updateFileName(input) {
    const name = input.files[0] ? input.files[0].name : '선택된 파일 없음';
    input.closest('.attach-input-wrap').querySelector('.file-name-display').textContent = name;
}