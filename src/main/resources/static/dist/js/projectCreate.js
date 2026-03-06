(function () {
    const TOTAL_STEPS = 4;
    let currentStep = 1;

    // ─── 개인 프로젝트 여부 ─────────────────────────────────────────────────
    function isPersonal() {
        const el = document.getElementById('projectType');
        return el && el.value === 'I';
    }

    // ─── 개인일 때 step2 멤버 영역 숨김/표시 ───────────────────────────────
    // step2의 .form-section 순서: [0]총인원, [1]팀멤버, [2]시작일, [3]제목/설명, [4]종료일
    function applyPersonalModeToStep2() {
        const sections = document.querySelectorAll('#step-panel-2 .form-section');
        if (sections.length >= 2) {
            sections[0].style.display = isPersonal() ? 'none' : ''; // 총 인원
            sections[1].style.display = isPersonal() ? 'none' : ''; // 팀 멤버
        }
    }

    // ─── 다음/이전 스텝 계산 (개인이면 step3 스킵) ─────────────────────────
    function getNextStep(from) {
        if (from === 2 && isPersonal()) return 4;
        return from < TOTAL_STEPS ? from + 1 : from;
    }
    function getPrevStep(from) {
        if (from === 4 && isPersonal()) return 2;
        return from > 1 ? from - 1 : from;
    }

    // ─── Step3 멤버 리스트 렌더링 ───────────────────────────────────────────
    function renderStep3MemberList() {
        const container = document.getElementById('step3MemberList');
        if (!container) return;

        const dataMap      = window.__memberDataMap || {};
        const hiddenInputs = document.querySelectorAll('#hiddenInputContainer input[name="memberIds"]');

        if (hiddenInputs.length === 0) {
            container.innerHTML = '<p class="text-muted">선택된 멤버가 없습니다. 이전 단계에서 멤버를 추가하세요.</p>';
            return;
        }

        container.innerHTML = '';

        hiddenInputs.forEach((input, idx) => {
            const empId = input.value;
            const data  = dataMap[empId] || {};
            const name  = data.name  || empId;
            const dept  = data.dept  || '';
            const grade = data.grade || '';

            // 이름 첫 글자 이니셜 (한글은 첫 글자, 영문은 첫 글자 대문자)
            const initial = name ? name.charAt(0) : '?';
            // 이니셜 배경색: empId 기반으로 고정 색상 부여
            const colors  = ['#4f86c6','#e07b54','#6abf69','#9b6db5','#e5a823','#3ab0b0','#d95f7f'];
            const colorIdx = empId.split('').reduce((acc, c) => acc + c.charCodeAt(0), 0) % colors.length;
            const bgColor  = colors[colorIdx];
            const avatarHtml = '<div class="avatar" style="background:' + bgColor + ';color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1rem;flex-shrink:0;">' + initial + '</div>';

            const row = document.createElement('div');
            row.className = 'member-row';
            row.innerHTML =
                '<div class="member-info">' +
                    avatarHtml +
                    '<div class="d-flex align-items-center gap-2 flex-wrap">' +
                        '<div class="member-name fw-bold">' + name + '</div>' +
                        '<div class="text-muted small">' +
                            '<span class="member-dept">' + dept + '</span>' +
                            '<span class="mx-1">/</span>' +
                            '<span class="member-grade">' + grade + '</span>' +
                        '</div>' +
                    '</div>' +
                    '<div class="custom-dropdown">' +
                        '<div class="selected-value badge-role"><span class="status-dot"></span>역할</div>' +
                        '<ul class="dropdown-menu">' +
                            '<li class="badge-manager"    data-label="매니저"   data-class="badge-manager"    data-code="M"><span class="status-dot"></span>매니저</li>' +
                            '<li class="badge-designer"   data-label="디자이너" data-class="badge-designer"   data-code="D"><span class="status-dot"></span>디자이너</li>' +
                            '<li class="badge-developer"  data-label="개발자"   data-class="badge-developer"  data-code="P"><span class="status-dot"></span>개발자</li>' +
                            '<li class="badge-supervisor" data-label="책임자"   data-class="badge-supervisor" data-code="S"><span class="status-dot"></span>책임자</li>' +
                        '</ul>' +
                        '<input type="hidden" class="role-input" name="memberRoles" data-emp-id="' + empId + '" value="">' +
                    '</div>' +
                '</div>';
            container.appendChild(row);
        });
    }

    // ─── 단계 이동 ──────────────────────────────────────────────────────────
    function goToStep(step) {
        if (step < 1 || step > TOTAL_STEPS) return;

        if (step === 2) applyPersonalModeToStep2();
        if (step === 3) renderStep3MemberList();

        document.querySelectorAll('.step-content').forEach(function(panel) {
            panel.classList.remove('active');
        });
        document.getElementById('step-panel-' + step).classList.add('active');

        // 스테퍼 nav: 개인이면 step3 흐리게 + 클릭 막기
        document.querySelectorAll('.stepper-nav .step-item').forEach(function(item) {
            const s = parseInt(item.getAttribute('data-step'));
            item.classList.remove('active');
            if (s === step) item.classList.add('active');

            if (s === 3 && isPersonal()) {
                item.style.opacity       = '0.35';
                item.style.pointerEvents = 'none';
            } else {
                item.style.opacity       = '';
                item.style.pointerEvents = '';
            }
        });

        document.getElementById('btnPrev').style.visibility = (step === 1) ? 'hidden' : 'visible';

        if (step === TOTAL_STEPS) {
            document.getElementById('btnNext').style.display     = 'none';
            document.getElementById('btnComplete').style.display = 'inline-block';
        } else {
            document.getElementById('btnNext').style.display     = 'inline-block';
            document.getElementById('btnComplete').style.display = 'none';
        }

        currentStep = step;
    }

    // ─── 버튼 이벤트 ────────────────────────────────────────────────────────
    document.getElementById('btnNext').addEventListener('click', function () {
        goToStep(getNextStep(currentStep));
    });
    document.getElementById('btnPrev').addEventListener('click', function () {
        goToStep(getPrevStep(currentStep));
    });

    document.getElementById('btnComplete').addEventListener('click', function () {

        // Step1
        const projectType = document.getElementById('projectType').value;
        const pmoType     = document.getElementById('pmoType').value;
        const personal    = (projectType === 'I');

        // Step2
        const title       = document.querySelector('[name="title"]').value;
        const description = document.querySelector('[name="description"]').value;
        const startDate   = document.querySelector('[name="startDate"]').value;
        const endDate     = document.querySelector('[name="endDate"]').value;

        // 유효성 검사 (공통)
        if (!title)     { alert('프로젝트 제목을 입력하세요.'); return; }
        if (!startDate) { alert('시작일을 입력하세요.'); return; }
        if (!endDate)   { alert('종료일을 입력하세요.'); return; }

        // Step3 - 팀 프로젝트일 때만 멤버/역할 수집
        let members = [];
        if (!personal) {
            const memberIds  = [...document.querySelectorAll('input[name="memberIds"]')].map(i => i.value);
            const roleInputs = [...document.querySelectorAll('input.role-input')];

            if (memberIds.length === 0) { alert('팀 멤버를 추가하세요.'); return; }

            const unassigned = roleInputs.filter(r => !r.value);
            if (unassigned.length > 0) { alert('모든 멤버의 역할을 선택해 주세요.'); return; }

            members = memberIds.map(empId => {
                const roleInput = document.querySelector('.role-input[data-emp-id="' + empId + '"]');
                return { empId: empId, role: roleInput ? roleInput.value : 'P' };
            });
        }

        // Step4 - 단계
        const stages = [...document.querySelectorAll('#phaseContainer .phase-card')].map((card, i) => {
            const titleInput = card.querySelector('.phase-title-input');
            const titleText  = card.querySelector('.phase-title');
            const stgTitle   = titleInput
                ? titleInput.value.trim()
                : titleText.textContent.replace(/^\d+\s*/, '').trim();
            return { sequence: i + 1, stgTitle: stgTitle };
        });

        fetch('/projects/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                projectType: projectType,
                pmoType:     pmoType,
                title:       title,
                description: description,
                startDate:   startDate,
                endDate:     endDate,
                members:     members,
                stages:      stages
            })
        })
        .then(res => {
            if (res.ok) {
                location.href = '/projects/list';
            } else {
                alert('생성 실패');
            }
        })
        .catch(err => {
            console.error(err);
            alert('서버 오류가 발생했습니다.');
        });
    });

    document.querySelectorAll('.stepper-nav .step-item').forEach(function(item) {
        item.addEventListener('click', function () {
            goToStep(parseInt(item.getAttribute('data-step')));
        });
    });

    goToStep(1);
})();
