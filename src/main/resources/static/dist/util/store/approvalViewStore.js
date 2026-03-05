import { defineStore } from 'pinia';
import http from 'http';

export const useApprovalViewStore = defineStore('approvalView', {
    state: () => ({
        doc: null,
        loading: false,
        error: null,
        // 세부정보 - create 때와 동일한 구조로 파싱해서 채움
        selectedFormCode: '',
        detailData: {},
        expenseRows: []
    }),

    actions: {
        async fetchDoc(docId) {
            this.loading = true;
            this.error   = null;
            try {
                const res = await http.get('/approval/doc/' + docId);
                this.doc  = res.data;

                // docTypeId → selectedFormCode 매핑
                const codeMap = {
                    1: 'FM001',  // 휴가신청서
                    2: 'FM002',  // 출장신청서
                    3: 'FM003',  // 지출결의서
                    4: 'FM004',  // 비용청구서
                    5: 'FM005',  // 일반신청서
                };
                this.selectedFormCode = codeMap[this.doc.docTypeId] || '';

                // detailData JSON 파싱
                if (this.doc.detailData) {
                    try {
                        const parsed = JSON.parse(this.doc.detailData);
                        this.detailData  = parsed.detailData  || parsed || {};
                        this.expenseRows = parsed.expenseRows || [];
                    } catch(e) {
                        console.warn('detailData 파싱 실패:', e);
                        this.detailData  = {};
                        this.expenseRows = [];
                    }
                }

            } catch (e) {
                console.error('문서 조회 실패:', e);
                this.error = '문서를 불러오지 못했습니다.';
            } finally {
                this.loading = false;
            }
        },

        // 파일 크기 포맷
        formatSize(bytes) {
            if (!bytes) return '0 B';
            if (bytes < 1024)        return bytes + ' B';
            if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
            return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
        },

        // 상태 한글 변환
        statusLabel(code) {
            return { DRAFT: '임시저장', PENDING: '결재중', APPROVED: '승인', REJECTED: '반려' }[code] || code;
        },

        // 결재선 상태 한글 변환
        lineStatusLabel(code) {
            return { WAIT: '대기', APPROVED: '승인', REJECTED: '반려' }[code] || code;
        }
    },

    getters: {
        expenseTotal: (state) => {
            return (state.expenseRows || []).reduce((sum, r) => sum + (Number(r.amount) || 0), 0);
        }
    }
});