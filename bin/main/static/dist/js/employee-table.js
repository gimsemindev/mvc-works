/* ==============================================================
   employee-table.js
   위치: /dist/js/employee-table.js
   역할: 직원관리 테이블 전용 - 체크박스 / 더블클릭 인라인 편집 /
         행 추가·저장·삭제·취소 / 검색·초기화 / 엑셀 / 정렬
   ============================================================== */

/* --------------------------------------------------------------
   핵심 설계
   - pendingChanges: { rowId → { field → value } }
     더블클릭으로 편집한 값을 행 단위로 누적 저장
     다른 행 더블클릭 시 기존 행 편집값은 유지 (초기화 X)
   - 저장 버튼: pendingChanges 전체를 서버에 전송
   - 취소 버튼: pendingChanges 초기화 + 화면 원복
-------------------------------------------------------------- */

const pendingChanges = {};   // { rowId: { dept, rank, role, pmo, status, ... } }
let currentEditingRow = null; // 현재 편집 중인 <tr> 참조

/* --------------------------------------------------------------
   셀렉트 옵션 정의
-------------------------------------------------------------- */
const SELECT_OPTIONS = {
    dept: [
        { value: '',         label: '(없음)' },
        { value: '개발팀',    label: '개발팀' },
        { value: '경영기획팀', label: '경영기획팀' },
        { value: '경영지원팀', label: '경영지원팀' },
        { value: '영업팀',    label: '영업팀' },
        { value: '인사팀',    label: '인사팀' },
        { value: '재무팀',    label: '재무팀' },
    ],
    rank: [
        { value: '',    label: '(없음)' },
        { value: '사원', label: '사원' },
        { value: '대리', label: '대리' },
        { value: '과장', label: '과장' },
        { value: '차장', label: '차장' },
        { value: '부장', label: '부장' },
        { value: '이사', label: '이사' },
        { value: '상무', label: '상무' },
        { value: '전무', label: '전무' },
        { value: '대표', label: '대표' },
    ],
    role: [
        { value: 'MASTER',       label: 'MASTER' },
        { value: 'EXECUTIVE',    label: 'EXECUTIVE' },
        { value: 'COORDINATOR',  label: 'COORDINATOR' },
        { value: 'PARTICIPANT',  label: 'PARTICIPANT' },
        { value: 'WATCHER',      label: 'WATCHER' },
    ],
    pmo: [
        { value: 'Y', label: 'Y' },
        { value: 'N', label: 'N' },
    ],
    status: [
        { value: 'EMPLOYED', label: '재직' },
        { value: 'LEAVE',    label: '휴직' },
        { value: 'RESIGNED', label: '퇴직' },
    ]
};

/* --------------------------------------------------------------
   행의 현재 값 읽기
   pendingChanges 우선 → data 속성 fallback
-------------------------------------------------------------- */
function getRowValue(tr, field) {
    const id = tr.dataset.id;
    if (pendingChanges[id] && pendingChanges[id][field] !== undefined) {
        return pendingChanges[id][field];
    }
    return tr.dataset[field] || '';
}

/* --------------------------------------------------------------
   편집 모드 활성화 (더블클릭 시)
   - 이전에 열려있던 행이 있으면 먼저 닫기 (값 유지)
   - 새 행에 select 렌더링
-------------------------------------------------------------- */
function activateRowEdit(tr) {
    if (currentEditingRow === tr) return;

    if (currentEditingRow && currentEditingRow !== tr) {
        closeRowEdit(currentEditingRow, false);
    }

    currentEditingRow = tr;
    tr.classList.add('editing');

    const editFields = ['dept', 'rank', 'role', 'pmo', 'status'];
    editFields.forEach(field => {
        const td = tr.querySelector('td[data-field="' + field + '"]');
        if (!td) return;

        const currentVal = getRowValue(tr, field);
        const opts = SELECT_OPTIONS[field] || [];

        const optionsHtml = opts.map(o => {
            const sel = (o.value === currentVal) ? ' selected' : '';
            return '<option value="' + o.value + '"' + sel + '>' + o.label + '</option>';
        }).join('');

        td.innerHTML = '<select class="emp-edit-select" data-field="' + field + '">' + optionsHtml + '</select>';
    });
}

/* --------------------------------------------------------------
   편집 모드 닫기
   - save=true  → pendingChanges에 저장 + 화면 배지 업데이트
   - save=false → pendingChanges 기존값 유지, 화면만 배지로 복원
-------------------------------------------------------------- */
function closeRowEdit(tr, save) {
    if (!tr) return;

    tr.classList.remove('editing');
    const id = tr.dataset.id;

    const editFields = ['dept', 'rank', 'role', 'pmo', 'status'];
    editFields.forEach(field => {
        const td = tr.querySelector('td[data-field="' + field + '"]');
        if (!td) return;

        const sel = td.querySelector('select.emp-edit-select');
        if (sel && save) {
            const newVal = sel.value;
            if (!pendingChanges[id]) pendingChanges[id] = {};
            pendingChanges[id][field] = newVal;
            tr.dataset[field] = newVal;
        }

        const displayVal = getRowValue(tr, field);
        td.innerHTML = renderCell(field, displayVal);
    });

    if (pendingChanges[id] && Object.keys(pendingChanges[id]).length > 0) {
        tr.classList.add('dirty');
    }

    if (currentEditingRow === tr) currentEditingRow = null;
}

/* --------------------------------------------------------------
   필드별 배지 HTML 렌더링
-------------------------------------------------------------- */
function renderCell(field, value) {
    switch (field) {
        case 'dept':
        case 'rank':
            return value || '-';

        case 'role': {
            const cls = 'emp-role-' + value.toLowerCase();
            return '<span class="emp-role-badge ' + cls + '">' + value + '</span>';
        }
        case 'pmo':
            if (value === 'Y') return '<span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span>';
            return '<span class="emp-pmo-no">N</span>';

        case 'status': {
            const statusMap = {
                EMPLOYED: ['emp-status-employed', '재직'],
                LEAVE:    ['emp-status-leave',    '휴직'],
                RESIGNED: ['emp-status-resigned', '퇴직'],
            };
            const info = statusMap[value] || ['emp-status-employed', '재직'];
            return '<span class="emp-status-badge ' + info[0] + '"><span class="emp-dot"></span>' + info[1] + '</span>';
        }
        default:
            return value || '-';
    }
}

/* --------------------------------------------------------------
   전체 선택 / 해제 (헤더 체크박스)
-------------------------------------------------------------- */
function toggleAll(masterChk) {
    document.querySelectorAll('.row-chk').forEach(chk => {
        chk.checked = masterChk.checked;
        chk.closest('tr').classList.toggle('selected', masterChk.checked);
    });
}

/* --------------------------------------------------------------
   검색
-------------------------------------------------------------- */
function doSearch() {
    const params = {
        name:    document.getElementById('searchName').value.trim(),
        empNo:   document.getElementById('searchEmpNo').value.trim(),
        project: document.getElementById('searchProject').value.trim(),
        status:  document.getElementById('searchStatus').value,
        role:    document.getElementById('searchRole').value,
        pmoY:    document.getElementById('pmoY').checked,
        pmoN:    document.getElementById('pmoN').checked,
    };
    console.log('검색 파라미터:', params);
    // TODO: fetch('/api/hrm?' + new URLSearchParams(params)) ...
    alert('검색 기능은 서버 연동 후 활성화됩니다.');
}

/* --------------------------------------------------------------
   검색 초기화
-------------------------------------------------------------- */
function doReset() {
    document.getElementById('searchName').value    = '';
    document.getElementById('searchEmpNo').value   = '';
    document.getElementById('searchProject').value = '';
    document.getElementById('searchStatus').value  = '';
    document.getElementById('searchRole').value    = '';
    document.getElementById('pmoY').checked        = false;
    document.getElementById('pmoN').checked        = false;
}

/* --------------------------------------------------------------
   저장 버튼
   pendingChanges를 수집하여 서버에 PUT 요청
-------------------------------------------------------------- */
function saveRows() {
    if (currentEditingRow) closeRowEdit(currentEditingRow, true);

    const changedIds = Object.keys(pendingChanges);
    if (changedIds.length === 0) {
        alert('변경된 내용이 없습니다.');
        return;
    }

    const payload = changedIds.map(id => ({
        empId: id,
        ...pendingChanges[id]
    }));

    console.log('저장 payload:', payload);

    /* TODO: 실제 서버 연동
    fetch('/api/hrm/bulk', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', 'AJAX': 'true' },
        body: JSON.stringify(payload)
    })
    .then(res => {
        if (!res.ok) throw new Error('저장 실패');
        changedIds.forEach(k => delete pendingChanges[k]);
        document.querySelectorAll('tr.dirty').forEach(tr => tr.classList.remove('dirty'));
        alert('저장되었습니다.');
    })
    .catch(err => alert(err.message));
    */

    alert(changedIds.length + '건이 저장 처리됩니다.\n(서버 연동 후 활성화)\n\n변경 내용:\n' + JSON.stringify(payload, null, 2));

    // 임시: pendingChanges 클리어 & dirty 제거
    changedIds.forEach(k => delete pendingChanges[k]);
    document.querySelectorAll('tr.dirty').forEach(tr => tr.classList.remove('dirty'));
}

/* --------------------------------------------------------------
   취소 버튼
   pendingChanges 초기화 + 원본 data 속성값으로 화면 복원
-------------------------------------------------------------- */
function cancelEdit() {
    if (!confirm('수정 중인 내용을 모두 취소하시겠습니까?')) return;

    if (currentEditingRow) closeRowEdit(currentEditingRow, false);

    const changedIds = Object.keys(pendingChanges);
    if (changedIds.length === 0) {
        alert('취소할 수정 내용이 없습니다.');
        return;
    }

    changedIds.forEach(id => {
        const tr = document.querySelector('tr[data-id="' + id + '"]');
        if (!tr) return;

        const fields = pendingChanges[id];
        Object.keys(fields).forEach(field => {
            const td = tr.querySelector('td[data-field="' + field + '"]');
            if (td) td.innerHTML = renderCell(field, tr.dataset[field] || '');
        });

        delete pendingChanges[id];
        tr.classList.remove('dirty');
    });
}

/* --------------------------------------------------------------
   행 추가 버튼
   새 행은 처음부터 select 상태로 추가
-------------------------------------------------------------- */
function addRow() {
    if (currentEditingRow) closeRowEdit(currentEditingRow, true);

    const tbody = document.getElementById('empTableBody');
    const newId = 'new_' + Date.now();
    const rowCount = tbody.querySelectorAll('tr').length + 1;

    const tr = document.createElement('tr');
    tr.dataset.id     = newId;
    tr.dataset.dept   = '';
    tr.dataset.rank   = '';
    tr.dataset.role   = 'PARTICIPANT';
    tr.dataset.pmo    = 'N';
    tr.dataset.status = 'EMPLOYED';
    tr.classList.add('selected');

    tr.innerHTML =
        '<td class="col-chk"><input type="checkbox" class="row-chk" checked></td>' +
        '<td>' + rowCount + '</td>' +
        '<td class="emp-readonly">' +
            '<div class="emp-name-cell">' +
                '<span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>' +
                '<input type="text" placeholder="이름" ' +
                    'style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:80px;background:transparent;">' +
            '</div>' +
        '</td>' +
        '<td class="emp-readonly">' +
            '<input type="text" placeholder="사원번호" ' +
                'style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:100px;background:transparent;">' +
        '</td>' +
        '<td class="emp-readonly" style="color:#94a3b8;font-size:0.8rem;">자동 연동</td>' +
        '<td class="emp-editable" data-field="dept">'   + renderCell('dept',   '')            + '</td>' +
        '<td class="emp-editable" data-field="rank">'   + renderCell('rank',   '')            + '</td>' +
        '<td class="emp-editable" data-field="role">'   + renderCell('role',   'PARTICIPANT') + '</td>' +
        '<td class="emp-editable" data-field="pmo">'    + renderCell('pmo',    'N')           + '</td>' +
        '<td class="emp-editable" data-field="status">' + renderCell('status', 'EMPLOYED')    + '</td>' +
        '<td class="col-del"><button class="emp-btn-row-del" onclick="deleteRow(this)" title="행 삭제"><i class="bi bi-x"></i></button></td>';

    tbody.appendChild(tr);
    activateRowEdit(tr);

    document.getElementById('chkAll').indeterminate = true;
}

/* --------------------------------------------------------------
   삭제 버튼 (선택 삭제)
-------------------------------------------------------------- */
function deleteSelected() {
    const checked = document.querySelectorAll('.row-chk:checked');
    if (checked.length === 0) { alert('삭제할 항목을 선택해 주세요.'); return; }
    if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;

    checked.forEach(chk => {
        const tr = chk.closest('tr');
        const id = tr.dataset.id;
        if (pendingChanges[id]) delete pendingChanges[id];
        if (currentEditingRow === tr) currentEditingRow = null;
        tr.remove();
    });

    document.getElementById('chkAll').checked = false;
    // TODO: 서버에 DELETE /api/hrm 요청 (ids 배열 전송)
}

/* --------------------------------------------------------------
   행 개별 삭제 버튼 (각 행 오른쪽 X 버튼)
-------------------------------------------------------------- */
function deleteRow(btn) {
    const tr = btn.closest('tr');
    const id = tr.dataset.id;
    const isNew = id && id.startsWith('new_');

    // 신규 행은 확인 없이 즉시 제거
    if (isNew) {
        if (pendingChanges[id]) delete pendingChanges[id];
        if (currentEditingRow === tr) currentEditingRow = null;
        tr.remove();
        return;
    }

    if (!confirm('해당 행을 삭제하시겠습니까?')) return;

    if (pendingChanges[id]) delete pendingChanges[id];
    if (currentEditingRow === tr) currentEditingRow = null;
    tr.remove();

    // TODO: 서버에 DELETE /api/hrm 요청
    // fetch('/api/hrm', {
    //     method: 'DELETE',
    //     headers: { 'Content-Type': 'application/json', 'AJAX': 'true' },
    //     body: JSON.stringify({ ids: [id] })
    // });
}

/* --------------------------------------------------------------
   엑셀 다운로드 / 업로드
-------------------------------------------------------------- */
function excelDownload() {
    alert('엑셀 다운로드 기능은 서버 연동 후 활성화됩니다.');
    // TODO: location.href = '/api/hrm/excel/download?' + new URLSearchParams(...)
}

function excelUpload(input) {
    if (!input.files || input.files.length === 0) return;
    const file = input.files[0];
    alert('엑셀 업로드: ' + file.name + '\n서버 연동 후 활성화됩니다.');
    // TODO: FormData + fetch POST /api/hrm/excel/upload
    input.value = '';
}

/* --------------------------------------------------------------
   정렬
-------------------------------------------------------------- */
function sortBy(col) {
    console.log('정렬 컬럼:', col);
    // TODO: 정렬 파라미터 추가 후 재검색
}

/* ==============================================================
   이벤트 등록 (DOMContentLoaded 후 실행)
   - tbody 더블클릭 위임 → 인라인 편집 활성화
   - tbody change 위임  → 체크박스 / select 변경 처리
   - document mousedown → 편집 행 외부 클릭 시 닫기
   ============================================================== */
document.addEventListener('DOMContentLoaded', function () {

    const tbody  = document.getElementById('empTableBody');
    const chkAll = document.getElementById('chkAll');

    if (!tbody) return; // 페이지에 테이블이 없으면 종료

    /* ── 더블클릭: 인라인 편집 활성화 ── */
    tbody.addEventListener('dblclick', function (e) {
        const td = e.target.closest('td');
        if (!td) return;
        if (e.target.tagName === 'SELECT' || e.target.tagName === 'OPTION') return;

        const tr = td.closest('tr');
        if (!tr) return;
        if (td.classList.contains('emp-readonly')) return;
        if (td.classList.contains('emp-editable')) activateRowEdit(tr);
    });

    /* ── change: 체크박스 / 셀렉트 변경 처리 ── */
    tbody.addEventListener('change', function (e) {
        const el = e.target;

        /* 행 체크박스 */
        if (el.classList.contains('row-chk')) {
            el.closest('tr').classList.toggle('selected', el.checked);
            const all     = document.querySelectorAll('.row-chk');
            const checked = document.querySelectorAll('.row-chk:checked');
            if (chkAll) {
                chkAll.checked       = (all.length === checked.length);
                chkAll.indeterminate = (checked.length > 0 && checked.length < all.length);
            }
            return;
        }

        /* 편집 셀렉트 → 즉시 pendingChanges 저장 */
        if (el.classList.contains('emp-edit-select')) {
            const tr    = el.closest('tr');
            const id    = tr.dataset.id;
            const field = el.dataset.field;
            if (!pendingChanges[id]) pendingChanges[id] = {};
            pendingChanges[id][field] = el.value;
        }
    });

    /* ── mousedown: 편집 행 외부 클릭 시 닫기 ── */
    document.addEventListener('mousedown', function (e) {
        if (!currentEditingRow) return;
        if (currentEditingRow.contains(e.target)) return;
        closeRowEdit(currentEditingRow, true);
    });
});
