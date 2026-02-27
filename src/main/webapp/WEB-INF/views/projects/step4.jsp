<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

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
        <div class="phase-footer">
            <button class="btn-add-sub"><i class="fas fa-plus me-1"></i></button>
            <button class="btn-phase-done" title="완료"><i class="fas fa-check"></i></button>
        </div>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">2</span> 설계 (UI/UX, 시스템)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <div class="phase-footer">
            <button class="btn-add-sub"><i class="fas fa-plus me-1"></i></button>
            <button class="btn-phase-done" title="완료"><i class="fas fa-check"></i></button>
        </div>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">3</span> 개발 및 구현</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <div class="phase-footer">
            <button class="btn-add-sub"><i class="fas fa-plus me-1"></i></button>
            <button class="btn-phase-done" title="완료"><i class="fas fa-check"></i></button>
        </div>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">4</span> 테스트(단위 / 통합)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <div class="phase-footer">
            <button class="btn-add-sub"><i class="fas fa-plus me-1"></i></button>
            <button class="btn-phase-done" title="완료"><i class="fas fa-check"></i></button>
        </div>
    </div>

    <div class="phase-card">
        <div class="phase-header">
            <div class="phase-title"><span class="phase-number">5</span> 배포(배포 / 유지보수)</div>
            <button class="btn-delete" title="삭제"><i class="fas fa-minus"></i></button>
        </div>
        <div class="sub-plan-list"></div>
        <div class="phase-footer">
            <button class="btn-add-sub"><i class="fas fa-plus me-1"></i></button>
            <button class="btn-phase-done" title="완료"><i class="fas fa-check"></i></button>
        </div>
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
        e.stopImmediatePropagation();

        if (e.target.classList.contains('sub-plan-input')) {
            const currentItem = e.target.closest('.sub-plan-item');
            const list = currentItem.parentElement;
            const newItem = createSubItem('');
            currentItem.after(newItem);
            newItem.querySelector('input').focus();
            return;
        }

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
            const footer = btn.closest('.phase-footer');
            const list = footer.previousElementSibling;
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

        // 단계 완료 버튼
        if (e.target.closest('.btn-phase-done')) {
            const btn = e.target.closest('.btn-phase-done');
            const card = btn.closest('.phase-card');
            const isDone = btn.classList.contains('done');
            btn.classList.toggle('done');
            card.classList.toggle('done-card');
            // 완료 시 input 비활성화 / 취소 시 활성화
            card.querySelectorAll('.sub-plan-input').forEach(function(input) {
                input.disabled = !isDone;
            });
            return;
        }

        // 단계 카드 삭제 버튼
        if (e.target.closest('.btn-delete')) {
            e.target.closest('.phase-card').remove();
            reorderPhaseNumbers();
            return;
        }
    });

    /* 단계 추가 버튼 */
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

        const footer = document.createElement('div');
        footer.className = 'phase-footer';

        const addSubBtn = document.createElement('button');
        addSubBtn.className = 'btn-add-sub';
        addSubBtn.innerHTML = '<i class="fas fa-plus me-1"></i>';

        const doneBtn = document.createElement('button');
        doneBtn.className = 'btn-phase-done';
        doneBtn.title = '완료';
        doneBtn.innerHTML = '<i class="fas fa-check"></i>';

        footer.appendChild(addSubBtn);
        footer.appendChild(doneBtn);

        card.appendChild(header);
        card.appendChild(subList);
        card.appendChild(footer);

        container.appendChild(card);
        titleInput.focus();
    });

})();
</script>