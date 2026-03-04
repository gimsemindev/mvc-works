<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="mb-5">
    <h2 class="fw-bold fs-3">Project details</h2>
    <p class="text-muted">프로젝트의 상세 정보를 입력해 주세요.</p>
</div>


<div class="form-section">
		        	<div class="row g-4">
		        		<div class="col-md-6">
		        			<label class="form-label">총 인원 구성</label>
		       					<div class="input-group">
		                            <input type="number" class="form-control" placeholder="0" min="0">
		                            <span class="input-group-text bg-light border-start-0 text-muted">명</span>
		                        </div>
		                    </div>
		        		<div class="col-md-4"></div> 					
		        	</div>
				</div>


<div class="form-section">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <label class="form-label mb-0">팀 멤버 상세 구성</label>
        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#memberSearchModal">
        	<i class="fas fa-plus"></i>
       </button>
     </div>
     
     <div id="selectedMemberList" class="d-flex flex-wrap gap-2 p-3 border rounded bg-light">
		<p class="text-muted mb-0" id="noMemberText">선택된 멤버가 없습니다.</p>
     </div>
</div>

<div id="hiddenInputContainer"></div>

<div class="form-section">
    <div class="col-md-6">
        <label class="form-label">Project 시작일</label>
        <input type="date" name="startDate" class="form-control">
    </div>
</div>

<div class="form-section">
    <div class="mb-4">
        <label class="form-label">Project 제목</label>
        <input type="text" name="title" class="form-control" placeholder="프로젝트 제목을 입력하세요.">
    </div>
    <div>
        <label class="form-label">프로젝트 상세 설명</label>
        <textarea name="description" class="form-control" rows="6" placeholder="상세 내용을 입력하세요"></textarea>
    </div>
</div>

<div class="form-section">
    <div class="col-md-6">
        <label class="form-label">프로젝트 종료일</label>
        <input type="date" name="endDate" class="form-control">
    </div>
</div>

<div class="modal fade" id="memberSearchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Project 멤버</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0">
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group">
                        <input type="text" id="memberSearchKeyword" class="form-control" placeholder="이름, 부서, 직급으로 검색...">
                        <button class="btn btn-primary" type="button" onclick="searchMembers()">
                            <i class="fas fa-search"></i> 검색
                        </button>
                    </div>
                </div>
                
                <div class="d-flex" style="height: 450px;">
                    <!-- 조직도 트리 패널 -->
                    <div class="border-end p-3" style="width: 30%; overflow-y: auto;">
                        <h6 class="fw-bold mb-3">조직도</h6>
                        <ul class="list-unstyled shadow-none mb-0" id="deptTree"></ul>
                    </div>
                    
                    <!-- 사원 목록 패널 -->
                    <div class="p-3 flex-grow-1" style="overflow-y: auto;">
                        <h6 class="fw-bold mb-3" id="selectedDeptName">부서를 선택하세요</h6>
                        <div id="modalMemberList" class="row row-cols-1 row-cols-md-2 g-2"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" onclick="confirmSelection()">선택 완료</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
// ── 트리 렌더링 ──
function renderDeptTree(nodes, parentEl, depth) {
    nodes.forEach(dept => {
        const hasChildren = dept.children && dept.children.length > 0;
        const li = document.createElement('li');

        // 노드 행
        const row = document.createElement('div');
        row.className = 'dept-item';
        row.dataset.deptCode = dept.deptCode;
        row.dataset.deptName = dept.deptName;

        // 펼침 아이콘 (자식 있을 때만)
        const toggle = document.createElement('span');
        toggle.className = 'dept-toggle';
        toggle.innerHTML = hasChildren ? '&#9654;' : '&nbsp;';
        row.appendChild(toggle);

        // 폴더 아이콘
        const icon = document.createElement('i');
        icon.className = depth === 0
            ? 'fas fa-building text-secondary'
            : 'fas fa-folder text-warning';
        icon.style.fontSize = '0.8rem';
        row.appendChild(icon);

        // 부서명
        const label = document.createElement('span');
        label.textContent = dept.deptName;
        row.appendChild(label);

        li.appendChild(row);

        // 자식 트리
        let childUl = null;
        if (hasChildren) {
            childUl = document.createElement('ul');
            childUl.className = 'list-unstyled mb-0 dept-children';
            renderDeptTree(dept.children, childUl, depth + 1);
            li.appendChild(childUl);

            // 펼침/접힘 토글
            toggle.addEventListener('click', (e) => {
                e.stopPropagation();
                const isOpen = childUl.classList.toggle('open');
                toggle.classList.toggle('open', isOpen);
            });
        }

        // 부서 선택 → 사원 로드
        row.addEventListener('click', () => {
            document.querySelectorAll('.dept-item.active').forEach(el => el.classList.remove('active'));
            row.classList.add('active');
            loadDeptMembers(dept.deptCode, dept.deptName);
        });

        parentEl.appendChild(li);
    });
}

// 1. 모달 열릴 때 조직도 로드
document.getElementById('memberSearchModal').addEventListener('show.bs.modal', () => {
    const deptTreeEl = document.getElementById('deptTree');
    if (deptTreeEl.children.length > 0) return; // 이미 로드됨

    fetch('/api/approval/org/dept')
        .then(res => res.json())
        .then(res => {
            deptTreeEl.innerHTML = '';
            renderDeptTree(res.tree || [], deptTreeEl, 0);
        })
        .catch(err => console.error('부서 로드 실패:', err));
});

// 2. 부서 클릭 시 사원 목록 로드
function loadDeptMembers(deptCode, deptName) {
    document.getElementById('selectedDeptName').textContent = deptName + ' (조회 중...)';
    document.getElementById('modalMemberList').innerHTML =
        '<p class="text-muted p-2"><i class="fas fa-spinner fa-spin me-1"></i>불러오는 중...</p>';

    fetch('/api/approval/org/emp?deptCode=' + encodeURIComponent(deptCode))
        .then(res => res.json())
        .then(res => {
            document.getElementById('selectedDeptName').textContent =
                deptName + ' (' + (res.list ? res.list.length : 0) + '명)';
            renderMemberList(res.list);
        })
        .catch(err => {
            console.error('사원 로드 실패:', err);
            document.getElementById('selectedDeptName').textContent = deptName + ' (조회 실패)';
        });
}

// 3. 사원 검색
function searchMembers() {
    const keyword = document.getElementById('memberSearchKeyword').value.trim();
    if (!keyword) { alert('검색어를 입력하세요.'); return; }

    document.getElementById('selectedDeptName').textContent = '"' + keyword + '" 검색 중...';
    document.querySelectorAll('.dept-item.active').forEach(el => el.classList.remove('active'));

    fetch('/api/approval/org/emp/search?keyword=' + encodeURIComponent(keyword))
        .then(res => res.json())
        .then(res => {
            document.getElementById('selectedDeptName').textContent =
                '"' + keyword + '" 검색 결과 (' + (res.list ? res.list.length : 0) + '건)';
            renderMemberList(res.list);
        })
        .catch(err => console.error('검색 실패:', err));
}

// 4. 사원 카드 렌더링 (부서 / 직급 표시)
function renderMemberList(list) {
    const container = document.getElementById('modalMemberList');

    if (!list || list.length === 0) {
        container.innerHTML = '<p class="text-muted p-2">소속 사원이 없습니다.</p>';
        return;
    }

    container.innerHTML = '';

    list.forEach(emp => {
        // Oracle + MyBatis resultType="map" 키는 항상 대문자
        const empId = String(emp.EMPID || emp.empId || '');
        const name  = emp.NAME  || emp.name  || '';
        const dept  = emp.DEPT  || emp.dept  || '';
        const grade = emp.GRADE || emp.grade || '';
        const isAdded = !!document.getElementById('badge_' + empId);

        const col  = document.createElement('div');
        col.className = 'col';

        const card = document.createElement('div');
        card.className = 'member-card' + (isAdded ? ' added' : '');
        // data-* 속성 사용 → 이름에 따옴표/특수문자 있어도 안전
        card.dataset.empId = empId;
        card.dataset.name  = name;
        card.dataset.dept  = dept;
        card.dataset.grade = grade;

        card.innerHTML =
            '<div class="emp-name">' + name + '</div>' +
            '<div class="emp-meta">' +
                '<span>' + dept + '</span>' +
                '<span class="sep">|</span>' +
                '<span>' + grade + '</span>' +
            '</div>';

        card.addEventListener('click', function() {
            addMemberBadge({
                empId: this.dataset.empId,
                name:  this.dataset.name,
                dept:  this.dataset.dept,
                grade: this.dataset.grade
            });
        });

        col.appendChild(card);
        container.appendChild(col);
    });
}

// 5. 멤버 뱃지 추가
function addMemberBadge(emp) {
    const empId = emp.empId || emp.EMPID || '';
    const name  = emp.name  || emp.NAME  || '';
    const dept  = emp.dept  || emp.DEPT  || '';
    const grade = emp.grade || emp.GRADE || '';

    if (!empId || document.getElementById('badge_' + empId)) return; // 중복 방지

    document.getElementById('noMemberText').style.display = 'none';

    const badge = document.createElement('span');
    badge.className = 'badge bg-primary d-flex align-items-center gap-1 p-2';
    badge.id = 'badge_' + empId;

    // 이름
    const nameSpan = document.createElement('span');
    nameSpan.textContent = name;
    badge.appendChild(nameSpan);

    // 부서/직급 (연한 텍스트)
    const metaSpan = document.createElement('span');
    metaSpan.className = 'fw-normal opacity-75';
    metaSpan.style.fontSize = '0.75rem';
    metaSpan.textContent = dept + ' / ' + grade;
    badge.appendChild(metaSpan);

    // 삭제 버튼
    const delIcon = document.createElement('i');
    delIcon.className = 'fas fa-times ms-1';
    delIcon.style.cursor = 'pointer';
    delIcon.addEventListener('click', function(e) {
        e.stopPropagation();
        removeBadge(empId);
    });
    badge.appendChild(delIcon);

    document.getElementById('selectedMemberList').appendChild(badge);

    const input = document.createElement('input');
    input.type  = 'hidden';
    input.name  = 'memberIds';
    input.value = empId;
    input.id    = 'hidden_' + empId;
    document.getElementById('hiddenInputContainer').appendChild(input);

    // 카드를 added 상태로 갱신
    renderMemberListRefresh();
}

// 6. 뱃지 제거
function removeBadge(empId) {
    const badge  = document.getElementById('badge_'  + empId);
    const hidden = document.getElementById('hidden_' + empId);
    if (badge)  badge.remove();
    if (hidden) hidden.remove();

    if (document.getElementById('selectedMemberList').querySelectorAll('.badge').length === 0) {
        document.getElementById('noMemberText').style.display = '';
    }
    renderMemberListRefresh();
}

// 7. 현재 표시 중인 카드의 added 상태 갱신
function renderMemberListRefresh() {
    document.querySelectorAll('#modalMemberList .member-card').forEach(card => {
        const empId = card.dataset.empId;
        if (!empId) return;
        if (document.getElementById('badge_' + empId)) {
            card.classList.add('added');
        } else {
            card.classList.remove('added');
        }
    });
}

// 8. 선택 완료
function confirmSelection() {
    bootstrap.Modal.getInstance(document.getElementById('memberSearchModal')).hide();
}
</script>
