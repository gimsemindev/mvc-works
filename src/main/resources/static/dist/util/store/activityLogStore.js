import { defineStore } from 'pinia';
import http from 'http';
import { getPagination } from 'paginate';

export const useActivityLogStore = defineStore('activityLog', {

    // ──────────────────────────────────────────────
    // State
    // ──────────────────────────────────────────────
    state: () => ({
        list: [],
        sessionName: '',

        searchParams: {
            actorEmpId: '',     // 사원번호 (actor_emp_id) LIKE 검색
            actorName:  '',     // 이름 (actor_name) LIKE 검색
            targetMenu: '',     // 메뉴 (target_menu) LIKE 검색
            result:     '',     // 처리결과 (SUCCESS / FAIL / 전체='')
            actionType: '',     // 작업유형 (INSERT / UPDATE / DELETE / BULK_UPDATE / EXCEL_IMPORT)
            startDate:  '',     // 로그일 시작 (yyyy-MM-dd)
            endDate:    '',     // 로그일 종료 (yyyy-MM-dd)
            page:       1
        },

        pageInfo: { totalCount: 0, totalPage: 1, pageSize: 10 },
        pagination: null,
        loading: false,

        sortCol: 'logDate',
        sortDir: 'desc',

        // 상세 모달
        detailItem: null,
        showDetail: false,
    }),

    // ──────────────────────────────────────────────
    // Actions
    // ──────────────────────────────────────────────
    actions: {

        // ════════════════════════════════════════════
        // [1] 목록 조회 (GET /api/activity-log)
        // ════════════════════════════════════════════
        async fetchList(page = this.searchParams.page) {
            this.loading = true;
            this.searchParams.page = page;

            try {
                const res = await http.get('/activity-log', {
                    params: {
                        ...this.searchParams,
                        pageSize: this.pageInfo.pageSize,
                        sortCol:  this.sortCol,
                        sortDir:  this.sortDir,
                    }
                });

                this.list = res.data.list || [];

                this.pageInfo.totalCount = res.data.totalCount;
                this.pageInfo.totalPage  = res.data.totalPage;

                this.pagination = getPagination(
                    this.searchParams.page,
                    this.pageInfo.totalPage,
                    10
                );
            } catch (error) {
                console.error('활동 로그 조회 오류:', error);
                alert('목록을 불러오는 중 오류가 발생했습니다.');
            } finally {
                this.loading = false;
            }
        },

        // ════════════════════════════════════════════
        // [2] 검색 (1페이지부터)
        // ════════════════════════════════════════════
        search() {
            this.fetchList(1);
        },

        // ════════════════════════════════════════════
        // [3] 검색 조건 초기화
        // ════════════════════════════════════════════
        resetSearch() {
            this.searchParams = {
                actorEmpId: '',
                actorName:  '',
                targetMenu: '',
                result:     '',
                actionType: '',
                startDate:  '',
                endDate:    '',
                page:       1
            };
            this.sortCol = 'logDate';
            this.sortDir = 'desc';
            this.fetchList(1);
        },

        // ════════════════════════════════════════════
        // [4] 정렬
        // ════════════════════════════════════════════
        sortBy(col) {
            if (this.sortCol === col) {
                this.sortDir = this.sortDir === 'asc' ? 'desc' : 'asc';
            } else {
                this.sortCol = col;
                this.sortDir = 'desc';
            }
            this.fetchList(1);
        },
        getSortClass(col) {
            if (this.sortCol !== col) return '';
            return this.sortDir === 'asc' ? 'asc' : 'desc';
        },

        // ════════════════════════════════════════════
        // [5] 상세 모달 열기/닫기
        // ════════════════════════════════════════════
        openDetail(item) {
            this.detailItem = item;
            this.showDetail = true;
        },
        closeDetail() {
            this.detailItem = null;
            this.showDetail = false;
        },

        // ════════════════════════════════════════════
        // [6] 순번 계산
        // ════════════════════════════════════════════
        getRowNo(index) {
            const offset = (this.searchParams.page - 1) * this.pageInfo.pageSize;
            return this.pageInfo.totalCount - offset - index;
        },

        // ════════════════════════════════════════════
        // [7] 액션 타입 한글 라벨
        // ════════════════════════════════════════════
        actionLabel(type) {
            const map = {
                INSERT:       '등록',
                UPDATE:       '수정',
                DELETE:       '삭제',
                BULK_UPDATE:  '일괄수정',
                EXCEL_IMPORT: '엑셀 업로드',
            };
            return map[type] || type;
        },

        // ════════════════════════════════════════════
        // [8] JSON 포맷 (상세 모달 출력용)
        // ════════════════════════════════════════════
        formatJson(jsonStr) {
            if (!jsonStr) return '-';
            try {
                return JSON.stringify(JSON.parse(jsonStr), null, 2);
            } catch {
                return jsonStr;
            }
        },

        // ════════════════════════════════════════════
        // [9] 엑셀 다운로드
        // ════════════════════════════════════════════
        excelDownload() {
            const { actorEmpId, actorName, targetMenu, result, actionType, startDate, endDate } = this.searchParams;
            const qs = new URLSearchParams({ actorEmpId, actorName, targetMenu, result, actionType, startDate, endDate });
            location.href = '/api/activity-log/excel/download?' + qs;
        },
    }
});
