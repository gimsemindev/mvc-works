<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<style>
/* 세부 계획 행 - 호버 시 삭제 버튼 살짝 표시 */
.sub-plan-item {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 6px;
    position: relative;
}
.sub-plan-item .btn-sub-delete {
    background: none;
    border: none;
    color: transparent;
    cursor: pointer;
    padding: 2px 5px;
    font-size: 0.75rem;
    border-radius: 3px;
    flex-shrink: 0;
    transition: color 0.15s;
}
.sub-plan-item:hover .btn-sub-delete {
    color: #ccc;
}
.sub-plan-item .btn-sub-delete:hover {
    color: #e74c3c !important;
}

/* 새로 추가되는 단계 제목 input */
.phase-title-input {
    border: none;
    background: transparent;
    font-weight: 600;
    font-size: 1rem;
    outline: none;
    flex: 1;
    padding: 2px 4px;
}
.phase-title-input:focus {
    border-bottom-color: #0d6efd;
}
</style>

<div class="section-header">
    <div>
        <h2 class="fw-bold fs-3">상세 단계 설정</h2>
        <p class="text-muted">각 단계별 세부 계획을 수립하세요.</p>
    </div>
    <button class="btn btn-sm btn-outline-primary fw-bold px-3" id="btnAddPhase">+</button>
</div>

<div class="phase-container" id="phaseContainer">

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">1</span> 요구사항 분석 및 기획</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list">
            <div class="sub-plan-item">
                <input type="text" class="sub-plan-input" value="고객사 인터뷰 및 요구사항 정의서 작성">
            </div>
        </div>
        <button class="btn-add-sub"><i class="fas fa-plus me-1"></i> 세부 계획 추가</button>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">2</span> 설계 (UI/UX, 시스템)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <button class="btn-add-sub"><i class="fas fa-plus me-1"></i> 세부 계획 추가</button>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">3</span> 개발 및 구현</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <button class="btn-add-sub"><i class="fas fa-plus me-1"></i> 세부 계획 추가</button>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">4</span> 테스트(단위 / 통합)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <button class="btn-add-sub"><i class="fas fa-plus me-1"></i> 세부 계획 추가</button>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">5</span> 배포(배포 / 유지보수)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <button class="btn-add-sub"><i class="fas fa-plus me-1"></i> 세부 계획 추가</button>
    </div>

</div>



<script type="text/javascript">
(function () {
    const container = document.getElementById('phaseContainer');

    /* 세부 계획 item 생성 함수 */
    function createSubItem(value) {
        const newItem = document.createElement('div');
        newItem.className = 'sub-plan-item';

        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'sub-plan-input';
        input.placeholder = '세부 계획을 입력하세요';
        if (value) input.value = value;

        const delBtn = document.createElement('button');
        delBtn.className = 'btn-sub-delete';
        delBtn.title = '삭제';
        delBtn.innerHTML = '<i class="fas fa-times"></i>';

        newItem.appendChild(input);
        newItem.appendChild(delBtn);
        return newItem;
    }

    /* 기존 sub-plan-item에 삭제 버튼 추가 */
    container.querySelectorAll('.sub-plan-item').forEach(function(item) {
        if (!item.querySelector('.btn-sub-delete')) {
            const delBtn = document.createElement('button');
            delBtn.className = 'btn-sub-delete';
            delBtn.title = '삭제';
            delBtn.innerHTML = '<i class="fas fa-times"></i>';
            item.appendChild(delBtn);
        }
    });

    /* 단계 번호 재정렬 */
    function reorderPhaseNumbers() {
        container.querySelectorAll('.phase-number').forEach(function(el, i) {
            el.textContent = i + 1;
        });
    }
    
    /* 엔터 키 이벤트 위임 */
    container.addEventListener('keydown', function (e) {
        if (e.key !== 'Enter') return;
        e.preventDefault();
        e.stopImmediatePropagation(); // ← 추가

        // 세부 계획 input에서 엔터 → 다음 세부 계획 항목 추가
        if (e.target.classList.contains('sub-plan-input')) {
            const currentItem = e.target.closest('.sub-plan-item');
            const list = currentItem.parentElement;
            const newItem = createSubItem('');
            // 현재 항목 바로 다음에 삽입
            currentItem.after(newItem);
            newItem.querySelector('input').focus();
            return;
        }

        // 단계 이름 input에서 엔터 → 첫 번째 세부 계획 추가 후 포커스
        if (e.target.classList.contains('phase-title-input')) {
            const card = e.target.closest('.phase-card');
            const list = card.querySelector('.sub-plan-list');
            const newItem = createSubItem('');
            list.appendChild(newItem);
            newItem.querySelector('input').focus();
            return;
        }
    });

    /* 이벤트 위임 */
    container.addEventListener('click', function (e) {

        // 세부 계획 추가 버튼
        if (e.target.closest('.btn-add-sub')) {
            const btn = e.target.closest('.btn-add-sub');
            const list = btn.previousElementSibling;
            const newItem = createSubItem('');
            list.appendChild(newItem);
            newItem.querySelector('input').focus();
            return;
        }

        // 세부 계획 삭제 버튼
        if (e.target.closest('.btn-sub-delete')) {
            e.target.closest('.sub-plan-item').remove();
            return;
        }

        // 단계 카드 삭제 버튼
        if (e.target.closest('.btn-delete')) {
            e.target.closest('.phase-card').remove();
            reorderPhaseNumbers();
            return;
        }
    });

    /* 단계 추가 버튼 - 새 단계만 제목 input으로 생성 */
    document.getElementById('btnAddPhase').addEventListener('click', function () {
        const count = container.querySelectorAll('.phase-card').length + 1;

        const card = document.createElement('div');
        card.className = 'phase-card';

        const header = document.createElement('div');
        header.className = 'phase-header';

        const titleWrap = document.createElement('div');
        titleWrap.className = 'phase-title';
        titleWrap.style.display = 'flex';
        titleWrap.style.alignItems = 'center';
        titleWrap.style.gap = '8px';
        titleWrap.style.flex = '1';

        const numSpan = document.createElement('span');
        numSpan.className = 'phase-number';
        numSpan.textContent = count;

        const titleInput = document.createElement('input');
        titleInput.type = 'text';
        titleInput.className = 'phase-title-input';
        titleInput.placeholder = '단계 이름을 입력하세요';

        titleWrap.appendChild(numSpan);
        titleWrap.appendChild(titleInput);

        const delBtn = document.createElement('button');
        delBtn.className = 'btn-delete';
        delBtn.title = '삭제';
        delBtn.innerHTML = '<i class="fas fa-minus"></i>';

        header.appendChild(titleWrap);
        header.appendChild(delBtn);

        const subList = document.createElement('div');
        subList.className = 'sub-plan-list';

        const addSubBtn = document.createElement('button');
        addSubBtn.className = 'btn-add-sub';
        addSubBtn.innerHTML = '<i class="fas fa-plus me-1"></i> 세부 계획 추가';

        card.appendChild(header);
        card.appendChild(subList);
        card.appendChild(addSubBtn);

        container.appendChild(card);
        titleInput.focus();
    });

})();
</script>
