/* 인사관리 사이드바 토글 스크립트 */
document.addEventListener('DOMContentLoaded', function () {
    const hrmToggle = document.getElementById('hrmToggle');

    if (hrmToggle) {
        hrmToggle.addEventListener('click', function (e) {
            e.preventDefault();

            const subMenu = document.getElementById('hrmSubMenu');
            const arrow = document.getElementById('hrmArrow');

            const isOpen = subMenu.style.display === 'block';

            subMenu.style.display = isOpen ? 'none' : 'block';
            arrow.classList.toggle('open', !isOpen);
        });
    }

    /* 그룹웨어 사이드바 토글 스크립트 */
    const groupToggle = document.getElementById('groupToggle');

    if (groupToggle) {
        groupToggle.addEventListener('click', function (e) {
            e.preventDefault();

            const subMenu = document.getElementById('groupSubMenu');
            const arrow = document.getElementById('groupArrow');

            const isOpen = subMenu.style.display === 'block';

            subMenu.style.display = isOpen ? 'none' : 'block';
            arrow.classList.toggle('open', !isOpen);
        });
    }
});