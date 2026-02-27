import { defineStore } from 'pinia';
import http from 'http';
import { getPagination } from 'paginate';

export const useHrmStore = defineStore('hrm', {

    // ──────────────────────────────────────────────
    // State (boardStore 패턴 + 직원 인라인 편집 전용 상태)
    // ──────────────────────────────────────────────
    state: () => ({
        list: [],           // 화면에 표시되는 직원 행 목록 (UI 메타 포함)
        sessionName: '',

        // 검색 파라미터 (boardStore.searchParams 패턴 동일)
        searchParams: {
            name:    '',
            empNo:   '',
            project: '',
            status:  '',
            role:    '',
            pmoY:    false,
            pmoN:    false,
            page:    1
        },

        pageInfo: { totalCount: 0, totalPage: 1, pageSize: 10 },
        pagination: null,
        loading: false,

        // 정렬 상태
        sortCol: '',
        sortDir: 'asc',   // 'asc' | 'desc'

        // ── 인라인 편집용 셀렉트 옵션 정의 ──
        deptOptions: ['개발팀', '경영기획팀', '경영지원팀', '영업팀', '인사팀', '재무팀'],
        rankOptions: ['사원', '대리', '과장', '차장', '부장', '이사', '상무', '전무', '대표'],
        roleOptions: ['MASTER', 'EXECUTIVE', 'COORDINATOR', 'PARTICIPANT', 'WATCHER'],
    }),

    // ──────────────────────────────────────────────
    // Getters
    // ──────────────────────────────────────────────
    getters: {
        isAllChecked: (state) => state.list.length > 0 && state.list.every(e => e._checked),
        isIndeterminate: (state) => state.list.some(e => e._checked) && !state.list.every(e => e._checked),
    },

    // ──────────────────────────────────────────────
    // Actions
    // ──────────────────────────────────────────────
    actions: {

        // ── 목록 조회 (boardStore.fetchList 패턴 동일) ────
        async fetchList(page = this.searchParams.page) {
            this.loading = true;
            this.searchParams.page = page;

            try {
                const res = await http.get('/hrm', {
                    params: {
                        ...this.searchParams,
                        pageSize: this.pageInfo.pageSize,
                        sortCol:  this.sortCol,
                        sortDir:  this.sortDir,
                    }
                });

                // 서버 응답 데이터에 UI 메타 필드 추가
                this.list = (res.data.list || []).map(emp => this._wrapRow(emp));

                this.pageInfo.totalCount = res.data.totalCount;
                this.pageInfo.totalPage  = res.data.totalPage;

                this.pagination = getPagination(
                    this.searchParams.page,
                    this.pageInfo.totalPage,
                    10
                );
            } catch (error) {
                console.error('직원 목록 조회 오류:', error);
                alert('목록을 불러오는 중 오류가 발생했습니다.');
            } finally {
                this.loading = false;
            }
        },

        // 서버 데이터에 UI 전용 메타 필드 부착
        _wrapRow(emp) {
            return {
                ...emp,
                _checked: false,   // 체크박스
                _editing: false,   // 더블클릭 편집 모드
                _dirty:   false,   // 변경 대기 마킹
                _isNew:   false,   // 신규 추가 행 여부
            };
        },

        // ── 검색 초기화 (boardStore.resetSearch 패턴 동일) ──
        resetSearch() {
            this.searchParams = {
                name:'', empNo:'', project:'',
                status:'', role:'', pmoY:false, pmoN:false, page:1
            };
            this.sortCol = '';
            this.sortDir = 'asc';
            this.fetchList(1);
        },

        // ── 체크박스 ────────────────────────────────
        toggleAll(checked) {
            this.list.forEach(emp => { emp._checked = checked; });
        },
        toggleRow(emp, checked) {
            emp._checked = checked;
        },

        // ── 더블클릭 인라인 편집 ─────────────────────
        activateRowEdit(emp) {
            // 기존 편집 행 닫기
            this.list.forEach(e => {
                if (e !== emp && e._editing) e._editing = false;
            });
            emp._editing = true;
        },

        // 편집 모드 해제 (외부 클릭 등)
        deactivateAll() {
            this.list.forEach(e => { e._editing = false; });
        },

        // dirty 마킹 (select 변경 시 호출)
        markDirty(emp) {
            emp._dirty = true;
        },

        // ── 저장 (벌크 PUT) ─────────────────────────
        async saveRows() {
            // 편집 중인 행 먼저 닫기
            this.deactivateAll();

            // 신규 행 + dirty 행 수집
            const newRows   = this.list.filter(e => e._isNew);
            const dirtyRows = this.list.filter(e => e._dirty && !e._isNew);

            if (newRows.length === 0 && dirtyRows.length === 0) {
                alert('변경된 내용이 없습니다.');
                return;
            }

            try {
                // 신규 등록 (POST)
                for (const emp of newRows) {
                    if (!emp.name || !emp.empNo) {
                        alert('이름과 사원번호는 필수입니다.');
                        return;
                    }
                    await http.post('/hrm', this._toPayload(emp));
                }

                // 기존 수정 (벌크 PUT)
                if (dirtyRows.length > 0) {
                    const payload = dirtyRows.map(e => this._toPayload(e));
                    await http.put('/hrm/bulk', payload);
                }

                alert('저장되었습니다.');
                this.fetchList();
            } catch (error) {
                console.error('저장 오류:', error);
                alert('저장 중 오류가 발생했습니다.');
            }
        },

        // 서버 전송용 페이로드 변환 (UI 메타 필드 제거)
        _toPayload(emp) {
            const { _checked, _editing, _dirty, _isNew, _tempId, ...payload } = emp;
            return payload;
        },

        // ── 취소 ─────────────────────────────────────
        cancelEdit() {
            const hasDirty = this.list.some(e => e._dirty || e._isNew);
            if (!hasDirty) { alert('취소할 수정 내용이 없습니다.'); return; }
            if (!confirm('수정 중인 내용을 모두 취소하시겠습니까?')) return;
            this.fetchList(); // 서버에서 원본 재조회
        },

        // ── 행 추가 ───────────────────────────────────
        addRow() {
            this.deactivateAll();
            const newEmp = {
                _tempId:  'new_' + Date.now(),
                empId:    null,
                name:     '',
                empNo:    '',
                projectNames: '',
                avatar:   '',
                dept:     '',
                rank:     '',
                role:     'PARTICIPANT',
                pmo:      'N',
                status:   'EMPLOYED',
                _checked: true,
                _editing: true,
                _dirty:   false,
                _isNew:   true,
            };
            this.list.push(newEmp);
        },

        // ── 선택 삭제 ─────────────────────────────────
        async deleteSelected() {
            const checked = this.list.filter(e => e._checked);
            if (checked.length === 0) { alert('삭제할 항목을 선택해 주세요.'); return; }
            if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;

            // 신규 행은 서버 요청 없이 바로 제거
            const newRows    = checked.filter(e => e._isNew);
            const serverRows = checked.filter(e => !e._isNew);

            newRows.forEach(e => {
                const idx = this.list.indexOf(e);
                if (idx > -1) this.list.splice(idx, 1);
            });

            if (serverRows.length > 0) {
                try {
                    const ids = serverRows.map(e => e.empId);
                    await http.delete('/hrm', { data: { ids } });
                    this.fetchList();
                } catch (error) {
                    console.error('삭제 오류:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                }
            }
        },

        // ── 정렬 ─────────────────────────────────────
        sortBy(col) {
            if (this.sortCol === col) {
                this.sortDir = this.sortDir === 'asc' ? 'desc' : 'asc';
            } else {
                this.sortCol = col;
                this.sortDir = 'asc';
            }
            this.fetchList(1);
        },

        getSortClass(col) {
            if (this.sortCol !== col) return '';
            return this.sortDir === 'asc' ? 'asc' : 'desc';
        },

        // ── 재직상태 라벨 변환 ────────────────────────
        statusLabel(status) {
            return { EMPLOYED: '재직', LEAVE: '휴직', RESIGNED: '퇴직' }[status] || status;
        },

        // ── 엑셀 다운로드 ─────────────────────────────
        excelDownload() {
            location.href = '/api/hrm/excel/download?' + new URLSearchParams(this.searchParams);
        },

        // ── 엑셀 업로드 트리거 (input[type=file] ref 대신 store에서 처리) ─
        triggerExcelUpload() {
            document.querySelector('input[type="file"][accept=".xlsx,.xls"]')?.click();
        },

        async excelUpload(event) {
            const file = event.target.files?.[0];
            if (!file) return;

            const formData = new FormData();
            formData.append('file', file);

            try {
                await http.post('/hrm/excel/upload', formData, {
                    headers: { 'Content-Type': 'multipart/form-data' }
                });
                alert('엑셀 업로드가 완료되었습니다.');
                this.fetchList(1);
            } catch (error) {
                console.error('엑셀 업로드 오류:', error);
                alert('엑셀 업로드 중 오류가 발생했습니다.');
            } finally {
                event.target.value = '';
            }
        },
    }
});
