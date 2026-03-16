// 날짜를 YYYY-MM-DD 문자열로 변환
function toDateStr(d) {
    return d.getFullYear() + '-' +
        String(d.getMonth() + 1).padStart(2, '0') + '-' +
        String(d.getDate()).padStart(2, '0');
}

// 단계 색상 전역 관리
const stageColors = [
    { bg: '#eff4ff', color: '#4e73df', bar: '#a8d8ea' },
    { bg: '#f0fdf4', color: '#16a34a', bar: '#b5ead7' },
    { bg: '#fdf4ff', color: '#9333ea', bar: '#aa96da' },
    { bg: '#fff7ed', color: '#ea580c', bar: '#ffdac1' },
    { bg: '#fef2f2', color: '#dc2626', bar: '#fcbad3' },
    { bg: '#f0f9ff', color: '#0284c7', bar: '#ffe5d9' },
    { bg: '#fafaf9', color: '#57534e', bar: '#ffffd2' },
];

const stageMap = {};
let stageIdx = 0;

function applyStageColors() {
    document.querySelectorAll('.stage-badge').forEach(badge => {
        const stageId = badge.dataset.stage;
        if (!stageMap[stageId]) {
            stageMap[stageId] = stageColors[stageIdx % stageColors.length];
            stageIdx++;
        }
        const c = stageMap[stageId];
        badge.style.backgroundColor = c.bg;
        badge.style.color = c.color;
    });
}

// 간트 차트 렌더링 함수
function renderGanttChart() {
    const grid = document.getElementById('ganttGrid');
    grid.innerHTML = '';

    const rows = document.querySelectorAll('#taskTableBody tr[data-task-id]');

    const projectStart = new Date(document.getElementById('hiddenProjectStart').value.replace(/\//g, '-'));
    const projectEnd = new Date(document.getElementById('hiddenProjectEnd').value.replace(/\//g, '-'));
    const totalDays = Math.round((projectEnd - projectStart) / (1000 * 60 * 60 * 24)) + 1;

    const allDates = [];
    const cur = new Date(projectStart);
    while (cur <= projectEnd) {
        allDates.push(new Date(cur));
        cur.setDate(cur.getDate() + 1);
    }

    if (totalDays <= 62) {
        const CELL_W = 35;
        const WEEKEND_W = 10;

        allDates.forEach(d => {
            const isWeekend = d.getDay() === 0 || d.getDay() === 6;
            const cell = document.createElement('div');
            cell.className = 'grid-header-cell' + (isWeekend ? ' is-weekend' : '');
            if (!isWeekend) {
                cell.textContent = (d.getMonth() + 1) + '/' + d.getDate();
            }
            grid.appendChild(cell);
        });

        if (rows.length === 0) {
            allDates.forEach(d => {
                const isWeekend = d.getDay() === 0 || d.getDay() === 6;
                const cell = document.createElement('div');
                cell.className = 'grid-cell' + (isWeekend ? ' is-weekend-cell' : '');
                grid.appendChild(cell);
            });
        } else {
            rows.forEach(function (row, idx) {
                const taskStartStr = row.dataset.start || null;
                const taskEndStr = row.dataset.end || null;
                const badge = row.querySelector('.stage-badge');
                const stageId = badge ? badge.dataset.stage : null;
                const barColor = stageId && stageMap[stageId] ? stageMap[stageId].bar : '#4e73df';

                allDates.forEach((cellDate, colIdx) => {
                    const isWeekend = cellDate.getDay() === 0 || cellDate.getDay() === 6;
                    const cell = document.createElement('div');
                    cell.className = 'grid-cell' + (isWeekend ? ' is-weekend-cell' : '');

                    if (taskStartStr && taskEndStr && toDateStr(cellDate) === taskStartStr) {
                        let barWidth = 0;
                        for (let i = colIdx; i < allDates.length; i++) {
                            if (toDateStr(allDates[i]) <= taskEndStr) {
                                const isWe = allDates[i].getDay() === 0 || allDates[i].getDay() === 6;
                                barWidth += isWe ? WEEKEND_W : CELL_W;
                            } else break;
                        }
                        const bar = document.createElement('div');
                        bar.className = 'task-bar';
                        bar.style.width = (barWidth - 4) + 'px';
                        bar.style.left = '2px';
                        bar.style.background = barColor;
                        bar.style.borderRadius = '4px';
                        cell.appendChild(bar);
                    }
                    grid.appendChild(cell);
                });
            });
        }

        grid.style.gridTemplateColumns = allDates.map(d => {
            const isWeekend = d.getDay() === 0 || d.getDay() === 6;
            return (isWeekend ? WEEKEND_W : CELL_W) + 'px';
        }).join(' ');

    } else {
        const CELL_W = 60;
        const WEEKEND_W = 15;

        const columns = [];
        let i = 0;

        while (i < allDates.length) {
            const d = allDates[i];
            const day = d.getDay();

            if (day === 6) {
                const sat = d;
                const nextDate = allDates[i + 1];
                if (nextDate && nextDate.getDay() === 0) {
                    columns.push({ type: 'weekend', dates: [sat, nextDate] });
                    i += 2;
                } else {
                    columns.push({ type: 'weekend', dates: [sat] });
                    i++;
                }
            } else if (day === 0) {
                columns.push({ type: 'weekend', dates: [d] });
                i++;
            } else {
                const weekdays = [];
                while (i < allDates.length && allDates[i].getDay() !== 0 && allDates[i].getDay() !== 6) {
                    weekdays.push(allDates[i]);
                    i++;
                }
                if (weekdays.length > 0) {
                    const first = weekdays[0];
                    const last = weekdays[weekdays.length - 1];
                    const label = (first.getMonth() + 1) + '/' + first.getDate() + '\n~\n' + (last.getMonth() + 1) + '/' + last.getDate();
                    columns.push({ type: 'weekday', dates: weekdays, label });
                }
            }
        }

        columns.forEach(col => {
            const cell = document.createElement('div');
            cell.className = 'grid-header-cell' + (col.type === 'weekend' ? ' is-weekend' : '');
            if (col.type === 'weekday') {
                cell.style.whiteSpace = 'pre-line';
                cell.style.fontSize = '10px';
                cell.style.lineHeight = '1.2';
                cell.style.textAlign = 'center';
                cell.textContent = col.label;
            }
            grid.appendChild(cell);
        });

        if (rows.length === 0) {
            columns.forEach(col => {
                const cell = document.createElement('div');
                cell.className = 'grid-cell' + (col.type === 'weekend' ? ' is-weekend-cell' : '');
                grid.appendChild(cell);
            });
        } else {
            rows.forEach(function (row, idx) {
                const taskStartStr = row.dataset.start || null;
                const taskEndStr = row.dataset.end || null;
                const badge = row.querySelector('.stage-badge');
                const stageId = badge ? badge.dataset.stage : null;
                const barColor = stageId && stageMap[stageId] ? stageMap[stageId].bar : '#aa96da';

                let startColIdx = -1;
                if (taskStartStr && taskEndStr) {
                    for (let ci = 0; ci < columns.length; ci++) {
                        for (const cd of columns[ci].dates) {
                            if (toDateStr(cd) === taskStartStr) {
                                startColIdx = ci;
                                break;
                            }
                        }
                        if (startColIdx !== -1) break;
                    }
                }

                columns.forEach((col, colIdx) => {
                    const cell = document.createElement('div');
                    cell.className = 'grid-cell' + (col.type === 'weekend' ? ' is-weekend-cell' : '');

                    if (taskStartStr && taskEndStr && colIdx === startColIdx) {
                        let barWidth = 0;
                        for (let ci = startColIdx; ci < columns.length; ci++) {
                            const c = columns[ci];
                            if (toDateStr(c.dates[0]) <= taskEndStr) {
                                barWidth += c.type === 'weekend' ? WEEKEND_W : CELL_W;
                            } else break;
                        }
                        const bar = document.createElement('div');
                        bar.className = 'task-bar';
                        bar.style.width = (barWidth - 4) + 'px';
                        bar.style.left = '2px';
                        bar.style.background = barColor;
                        bar.style.borderRadius = '4px';
                        cell.appendChild(bar);
                    }
                    grid.appendChild(cell);
                });
            });
        }

        grid.style.gridTemplateColumns = columns.map(col =>
            (col.type === 'weekend' ? WEEKEND_W : CELL_W) + 'px'
        ).join(' ');
    }
}


// SweetAlert2 유틸
const toast = (msg) => {
    Swal.fire({
        html: `<div style="font-size:0.95rem; font-weight:500; text-align:center; display:flex; align-items:center; justify-content:center; min-height:40px;">${msg}</div>`,
        showConfirmButton: false,
        timer: 1500,
        timerProgressBar: false,
        iconColor: '#4e73df',
        width: '320px',
        padding: '1rem'
    });
};

const ask = (msg, callback) => {
    Swal.fire({
        text: msg,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#4e73df',
        cancelButtonColor: '#f8f9fc',
        confirmButtonText: '확인',
        cancelButtonText: '취소',
        width: '320px',
        padding: '1.2rem'
    }).then((result) => {
        if (result.isConfirmed) callback();
    });
};


// 모달 열기 / 닫기
function openTaskModal() {
    document.getElementById('taskModal').style.display = 'flex';
}

function closeTaskModal() {
    document.getElementById('taskModal').style.display = 'none';
}


// 이벤트 바인딩
document.addEventListener('DOMContentLoaded', function () {

    applyStageColors();  // 배지 색상 먼저
    renderGanttChart();  // 그 다음 차트

    document.getElementById('taskModal').addEventListener('click', function (e) {
        if (e.target === this) closeTaskModal();
    });

    document.querySelectorAll('.status-cell').forEach(select => {
        updateStatusStyle(select);
    });

    document.getElementById('modalStageId').addEventListener('change', function () {
        const directRow = document.getElementById('directStageRow');
        directRow.style.display = this.value === 'direct' ? 'flex' : 'none';
        if (this.value !== 'direct') {
            document.getElementById('modalDirectStage').value = '';
        }
    });
});


// 태스크 등록
function submitTask() {
    let stageId = document.getElementById('modalStageId').value;
    const directStage = document.getElementById('modalDirectStage').value.trim();
    const taskTitle = document.getElementById('modalTaskTitle').value.trim();
    const startDate = document.getElementById('modalStartDate').value;
    const endDate = document.getElementById('modalEndDate').value;
    const taskDesc = document.getElementById('modalTaskDesc').value.trim();
    const empId = document.getElementById('modalMember').value;
    const projectId = document.getElementById('hiddenProjectId').value;
    const isDirect = stageId === 'direct';
    const projectStart = document.getElementById('hiddenProjectStart').value.replace(/\//g, '-');
    const projectEnd = document.getElementById('hiddenProjectEnd').value.replace(/\//g, '-');

    if (!stageId) { toast('단계를 선택해주세요.'); return; }
    if (stageId === 'direct' && !directStage) { toast('단계명을 입력해주세요.'); return; }
    if (!empId) { toast('담당자를 선택해주세요.'); return; }
    if (!taskTitle) { toast('Task명을 입력해주세요.'); return; }
    if (!startDate) { toast('시작일을 입력해주세요.'); return; }
    if (!endDate) { toast('종료일을 입력해주세요.'); return; }
    if (endDate < startDate) { toast('종료일은 시작일보다 빠를 수 없습니다.'); return; }
    if (startDate < projectStart) { toast('시작일은 프로젝트 시작일(' + projectStart + ') 이후여야 합니다.'); return; }
    if (endDate > projectEnd) { toast('종료일은 프로젝트 종료일(' + projectEnd + ') 이전이어야 합니다.'); return; }

    if (stageId === 'direct') stageId = null;

    fetch(contextPath + '/projects/task/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            projectId: projectId,
            stageId: isDirect ? null : stageId,
            stgTitle: isDirect ? directStage : null,
            empId: empId,
            taskTitle: taskTitle,
            taskStartDate: startDate,
            taskEndDate: endDate,
            taskDescription: taskDesc
        })
    })
    .then(res => {
        if (res.ok) {
            toast('Task가 생성되었습니다.');
            setTimeout(() => {
                closeTaskModal();
                location.reload();
            }, 1500);
        } else {
            toast('생성 실패. 다시 시도해주세요.');
        }
    })
    .catch(err => {
        console.error(err);
        toast('서버 오류가 발생했습니다.');
    });
}

let editMode = false;
let currentTaskEmpId = '';

function toggleEditMode() {
    const isManager = document.getElementById('hiddenIsManager').value === 'true';
    if (!isManager) {
        toast('매니저만 편집할 수 있습니다.');
        return;
    }

    editMode = !editMode;
    const btn = document.getElementById('editBtn');

    if (editMode) {
        btn.innerHTML = '<i class="fas fa-check"></i>';
        btn.style.background = '#28a745';
        toast('편집 모드가 활성화되었습니다.');
    } else {
        btn.innerHTML = '<i class="fas fa-pencil-alt"></i>';
        btn.style.background = '';
        toast('편집이 완료되었습니다.');
    }
}

function updateTask(taskId, type) {
    if (!editMode) {
        toast('편집 모드를 활성화해주세요.');

        const row = document.querySelector(`tr[data-task-id="${taskId}"]`);
        if (type === 'startDate') {
            row.querySelectorAll('.cell-date')[0].value = row.dataset.start;
        } else if (type === 'endDate') {
            row.querySelectorAll('.cell-date')[1].value = row.dataset.end;
        } else if (type === 'status') {
            const statusSelect = row.querySelector('.status-cell');
            statusSelect.value = statusSelect.dataset.status;
        } else if (type === 'assignee') {
            const assigneeSelect = row.querySelector('.cell-assignee');
            assigneeSelect.value = assigneeSelect.dataset.empId;
        }
        return;
    }

    const row = document.querySelector(`tr[data-task-id="${taskId}"]`);
    const dates = row.querySelectorAll('.cell-date');
    const startDate = dates[0].value;
    const endDate = dates[1].value;
    const empId = row.querySelector('.cell-assignee').value;
    const statusSelect = row.querySelector('.status-cell');
    const today = new Date().toISOString().split('T')[0];

    const projectStart = document.getElementById('hiddenProjectStart').value.replace(/\//g, '-');
    const projectEnd = document.getElementById('hiddenProjectEnd').value.replace(/\//g, '-');

    if (type === 'startDate' || type === 'endDate') {
        if (startDate < projectStart) {
            toast('시작일은 프로젝트 시작일(' + projectStart + ') 이후여야 합니다.');
            dates[0].value = row.dataset.start;
            return;
        }
        if (endDate > projectEnd) {
            toast('종료일은 프로젝트 종료일(' + projectEnd + ') 이전이어야 합니다.');
            dates[1].value = row.dataset.end;
            return;
        }
        if (endDate && startDate && endDate < startDate) {
            toast('종료일은 시작일보다 빠를 수 없습니다.');
            if (type === 'startDate') dates[0].value = row.dataset.start;
            else dates[1].value = row.dataset.end;
            return;
        }
    }

    let taskStatus = statusSelect.value;
    if (type === 'startDate' || type === 'endDate') {
        if (startDate && endDate) {
            if (endDate < today) {
                taskStatus = '4';
            } else if (startDate <= today && endDate >= today) {
                taskStatus = '2';
            } else {
                taskStatus = '1';
            }
            statusSelect.value = taskStatus;
            updateStatusStyle(statusSelect);
        }
    }

    fetch(contextPath + '/projects/task/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify([{
            taskId,
            taskStartDate: startDate,
            taskEndDate: endDate,
            taskStatus: taskStatus,
            empId: empId
        }])
    })
    .then(res => {
        if (!res.ok) {
            toast('저장 실패.');
        } else {
            row.dataset.start = startDate;
            row.dataset.end = endDate;
            applyStageColors();
            renderGanttChart();
        }
    })
    .catch(err => console.error(err));
}

function updateStatusStyle(select) {
    select.dataset.status = select.value;
    const colors = {
        '1': '#1d2939',
        '2': '#0d6efd',
        '3': '#fd7e14',
        '4': '#198754',
        '5': '#dc3545',
        '6': '#adb5bd'
    };
    select.style.color = colors[select.value] || '#1d2939';
}


function openTaskDailyModal(taskId, title, startStr, endStr, status, assignee, assigneeEmpId) {
    const taskStatusMap = {
        '1': '시작전', '2': '진행', '3': '승인대기',
        '4': '종료', '5': '지연', '6': '중단'
    };

    currentTaskEmpId = assigneeEmpId;

    document.getElementById('dailyModalTitle').textContent = title;
    document.getElementById('dailyModalPeriod').textContent = startStr + ' ~ ' + endStr;
    document.getElementById('dailyModalStatus').textContent = taskStatusMap[status] || status;
    document.getElementById('dailyModalAssignee').textContent = assignee;

    const grid = document.getElementById('dailyGrid');
    grid.innerHTML = '';

    const start = new Date(startStr);
    const end = new Date(endStr);
    const CELL_W = 40;
    const WEEKEND_W = 12;

    function toStr(d) {
        return d.getFullYear() + '-' +
            String(d.getMonth()+1).padStart(2,'0') + '-' +
            String(d.getDate()).padStart(2,'0');
    }

    const allDates = [];
    const cur = new Date(start);
    while (cur <= end) {
        allDates.push(new Date(cur));
        cur.setDate(cur.getDate() + 1);
    }

    // 헤더
    allDates.forEach(d => {
        const isWe = d.getDay() === 0 || d.getDay() === 6;
        const cell = document.createElement('div');
        cell.style.cssText = `
            height:40px; background:${isWe ? '#e8e8e8' : '#f9fafb'};
            border-right:1px solid #eaecf0; border-bottom:1px solid #eaecf0;
            display:flex; align-items:center; justify-content:center;
            font-weight:700; font-size:0.72rem;
            color:${isWe ? '#ef4444' : '#667085'};
        `;
        cell.textContent = (d.getMonth()+1) + '/' + d.getDate();
        grid.appendChild(cell);
    });

    // 체크 칸
    allDates.forEach(d => {
        const isWe = d.getDay() === 0 || d.getDay() === 6;
        const cell = document.createElement('div');
        cell.style.cssText = `
            height:52px; background:${isWe ? '#f5f5f5' : '#fff'};
            border-right:1px solid #eaecf0; border-bottom:1px solid #eaecf0;
            display:flex; align-items:center; justify-content:center;
            cursor:${isWe ? 'default' : 'pointer'}; transition:background 0.15s;
        `;
        cell.addEventListener('mouseenter', () => { if(!isWe) cell.style.background = '#f0f4ff'; });
        cell.addEventListener('mouseleave', () => { cell.style.background = isWe ? '#f5f5f5' : '#fff'; });
        cell.addEventListener('click', () => {
            if (!isWe) openDailyCheckModal(toStr(d));
        });
        grid.appendChild(cell);
    });

    grid.style.gridTemplateColumns = allDates.map(d => {
        const isWe = d.getDay() === 0 || d.getDay() === 6;
        return (isWe ? WEEKEND_W : CELL_W) + 'px';
    }).join(' ');

    document.getElementById('taskDailyModal').style.display = 'flex';
}

function closeTaskDailyModal() {
    document.getElementById('taskDailyModal').style.display = 'none';
}

function openDailyCheckModal(dateStr) {
    const loginEmpId = document.getElementById('hiddenLoginEmpId').value;

    if(loginEmpId !== currentTaskEmpId) {
        toast('담당자만 체크할 수 있습니다.');
        return;
    }

    document.getElementById('checkDate').textContent = dateStr;
    document.getElementById('taskDailyCheckModal').style.display = 'flex';
}

function closeDailyCheckModal() {
    document.getElementById('taskDailyCheckModal').style.display = 'none';
}