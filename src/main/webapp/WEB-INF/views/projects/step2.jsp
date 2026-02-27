<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="mb-5">
    <h2 class="fw-bold fs-3">Project details</h2>
    <p class="text-muted">프로젝트의 상세 정보를 입력해 주세요.</p>
</div>


<div class="form-section">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <label class="form-label mb-0">팀 멤버 상세 구성</label>
        <div class="position-relative">
            <button type="button" class="btn btn-sm btn-outline-primary" id="btnAddDept">
                <i class="fas fa-plus"></i>
            </button>
            
            <ul class="dept-dropdown" id="deptDropdown">
                <li data-dept="개발팀"><span class="team-dept dept-dev"><span class="status-dot"></span>개발팀</span></li>
                <li data-dept="인사팀"><span class="team-dept dept-hr"><span class="status-dot"></span>인사팀</span></li>
                <li data-dept="디자인팀"><span class="team-dept dept-design"><span class="status-dot"></span>디자인팀</span></li>
                <li data-dept="기타"><span class="team-dept dept-others"><span class="status-dot"></span>기타</span></li>
            </ul>
        </div>
    </div>
    
    <div id="deptSectionContainer"></div>
</div>

<div class="form-section">
    <div class="col-md-6">
        <label class="form-label">Project 시작일</label>
        <input type="date" class="form-control">
    </div>
</div>

<div class="form-section">
    <div class="mb-4">
        <label class="form-label">Project 제목</label>
        <input type="text" class="form-control" placeholder="프로젝트 제목을 입력하세요.">
    </div>
    <div>
        <label class="form-label">프로젝트 상세 설명</label>
        <textarea class="form-control" rows="6" placeholder="상세 내용을 입력하세요"></textarea>
    </div>
</div>

<div class="form-section">
    <div class="col-md-6">
        <label class="form-label">프로젝트 종료일</label>
        <input type="date" class="form-control">
    </div>
</div>


<script type="text/javascript">
(function () {
    const btnAddDept = document.getElementById('btnAddDept');
    const deptDropdown = document.getElementById('deptDropdown');
    const container = document.getElementById('deptSectionContainer');

    /* 부서 추가 버튼 - 드롭다운 토글 */
    btnAddDept.addEventListener('click', function (e) {
        e.stopPropagation();
        const isOpen = deptDropdown.style.display === 'block';
        deptDropdown.style.display = isOpen ? 'none' : 'block';
    });

    /* 외부 클릭 시 드롭다운 닫기 */
    document.addEventListener('click', function () {
        deptDropdown.style.display = 'none';
    });

    /* 부서 선택 */
    deptDropdown.addEventListener('click', function (e) {
        const li = e.target.closest('li');
        if (!li || li.classList.contains('disabled')) return;

        const deptName = li.getAttribute('data-dept');
        const deptClass = li.querySelector('.team-dept').className.replace('team-dept', '').trim();
        addDeptSection(deptName, deptClass);

        li.classList.add('disabled');
        deptDropdown.style.display = 'none';
    });

    /* 부서 섹션 생성 */
    function addDeptSection(deptName, deptClass) {
        const section = document.createElement('div');
        section.className = 'dept-section';
        section.setAttribute('data-dept', deptName);

        /* 헤더 */
        const header = document.createElement('div');
        header.className = 'dept-section-header';

        const title = document.createElement('div');
        title.className = 'dept-section-title';
        title.innerHTML = '<span class="team-dept ' + deptClass + '"><span class="status-dot"></span>' + deptName + '</span>';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'btn-dept-remove';
        removeBtn.innerHTML = '<i class="fas fa-times"></i>';
        removeBtn.addEventListener('click', function () {
            const li = deptDropdown.querySelector('li[data-dept="' + deptName + '"]');
            if (li) li.classList.remove('disabled');
            section.remove();
        });

        header.appendChild(title);
        header.appendChild(removeBtn);

        /* 멤버 태그 컨테이너 */
        const tagContainer = document.createElement('div');
        tagContainer.className = 'member-tag-container';

        /* 검색 영역 */
        const searchWrap = document.createElement('div');
        searchWrap.className = 'member-search-wrap';

        const searchInput = document.createElement('input');
        searchInput.type = 'text';
        searchInput.className = 'member-search-input';
        searchInput.placeholder = '이름으로 검색...';

        const resultList = document.createElement('ul');
        resultList.className = 'member-search-result';

        // TODO: 추후 Ajax 연동 - 지금은 더미 데이터
        const dummyData = {
            '개발팀'  : ['김개발', '이코딩', '박서버', '최프론트'],
            '인사팀'  : ['홍인사', '정채용', '강급여'],
            '디자인팀': ['윤디자인', '임UI', '한UX'],
            '기타'    : ['조총무', '배지원']
        };

        /* 검색 input 이벤트 */
        searchInput.addEventListener('input', function () {
            const keyword = searchInput.value.trim();
            resultList.innerHTML = '';

            if (keyword === '') {
                resultList.style.display = 'none';
                return;
            }

            const members = dummyData[deptName] || [];
            const filtered = members.filter(function (name) {
                return name.indexOf(keyword) !== -1;
            });

            if (filtered.length === 0) {
                resultList.style.display = 'none';
                return;
            }

            filtered.forEach(function (name) {
                const li = document.createElement('li');
                li.textContent = name;
                li.addEventListener('click', function () {
                    addMemberTag(tagContainer, name);
                    searchInput.value = '';
                    resultList.style.display = 'none';
                });
                resultList.appendChild(li);
            });

            resultList.style.display = 'block';
        });
        
        searchInput.addEventListener('keydown', function (e) {
            if (e.key !== 'Enter') return;
            e.preventDefault();
            e.stopImmediatePropagation();
            const firstItem = resultList.querySelector('li');
            if (firstItem) {
                const name = firstItem.textContent;
                addMemberTag(tagContainer, name);
                searchInput.value = '';
                resultList.style.display = 'none';
            }
        });

        /* 검색 결과 외부 클릭 시 닫기 */
        document.addEventListener('click', function (e) {
            if (!searchWrap.contains(e.target)) {
                resultList.style.display = 'none';
            }
        });

        searchWrap.appendChild(searchInput);
        searchWrap.appendChild(resultList);

        section.appendChild(header);
        section.appendChild(tagContainer);
        section.appendChild(searchWrap);

        container.appendChild(section);
        searchInput.focus();
    }
    
    

    /* 멤버 태그 추가 */
    function addMemberTag(tagContainer, name) {
        const existing = tagContainer.querySelectorAll('.member-tag');
        for (let i = 0; i < existing.length; i++) {
            if (existing[i].getAttribute('data-name') === name) return;
        }

        const tag = document.createElement('span');
        tag.className = 'member-tag';
        tag.setAttribute('data-name', name);

        const nameSpan = document.createElement('span');
        nameSpan.textContent = name;

        const removeBtn = document.createElement('span');
        removeBtn.className = 'tag-remove';
        removeBtn.innerHTML = '<i class="fas fa-times"></i>';
        removeBtn.addEventListener('click', function () {
            tag.remove();
        });

        tag.appendChild(nameSpan);
        tag.appendChild(removeBtn);
        tagContainer.appendChild(tag);
    }

})();
</script>