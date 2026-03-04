import { defineStore } from 'pinia';
import http from 'http';

export const useApprovalListStore = defineStore('approvalList', {
    state: () => ({
        list: [],
        totalCount: 0,
        filterType: 'draft',
        keyword: '',
        startDate: '',
        endDate: '',
        pageNo: 1,
        pageSize: 20,
        loading: false
    }),

    getters: {
        totalPages: (state) => {
            return Math.ceil(state.totalCount / state.pageSize) || 1;
        }
    },

    actions: {
        async fetchList() {
            this.loading = true;
            try {
                const params = new URLSearchParams();
                if (this.keyword) params.append('keyword', this.keyword);
                if (this.startDate) params.append('startDate', this.startDate);
                if (this.endDate) params.append('endDate', this.endDate);
                params.append('pageNo', this.pageNo);
                params.append('pageSize', this.pageSize);

                const res = await http.get('/approval/doc?' + params.toString());
                this.list = res.data.list || [];
                this.totalCount = res.data.totalCount || 0;
            } catch (e) {
                console.error('목록 조회 실패:', e);
            } finally {
                this.loading = false;
            }
        },

        search() {
            this.pageNo = 1;
            this.fetchList();
        },

        changePage(page) {
            if (page < 1 || page > this.totalPages) return;
            this.pageNo = page;
            this.fetchList();
        },

        changePageSize(size) {
            this.pageSize = size;
            this.pageNo = 1;
            this.fetchList();
        }
    }
});