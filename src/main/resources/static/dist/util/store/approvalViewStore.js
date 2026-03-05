import { defineStore } from 'pinia';
import http from 'http';
import { useCommonCodeStore } from 'commonCodeStore';

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

				// DB에서 가져온 formCode 사용
				this.selectedFormCode = this.doc.formCode || '';

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

        // 상태 한글 변환 (공통코드 DOCSTATUS)
        statusLabel(code) {
            const codeStore = useCommonCodeStore();
            const found = codeStore.getCodes('DOCSTATUS').find(c => c.code === code);
            return found ? found.name : code;
        },

        // 결재선 상태 한글 변환 (공통코드 LINESTATUS)
        lineStatusLabel(code) {
            const codeStore = useCommonCodeStore();
            const found = codeStore.getCodes('LINESTATUS').find(c => c.code === code);
            return found ? found.name : code;
        },

        // 결재취소
        async cancelDoc(docId) {
            try {
                await http.post('/approval/doc/' + docId + '/cancel');
                alert('결재가 취소되었습니다.');
                return true;
            } catch (e) {
                const msg = e.response?.data?.msg || '취소 처리 중 오류가 발생했습니다.';
                alert(msg);
                return false;
            }
        }
    },

    getters: {
        expenseTotal: (state) => {
            return (state.expenseRows || []).reduce((sum, r) => sum + (Number(r.amount) || 0), 0);
        },
        canCancel: (state) => {
            if (!state.doc) return false;
            const s = state.doc.docStatus;
            if (s === 'REJECTED') return true;
            if (s === 'PENDING' && state.doc.lines) {
                return state.doc.lines.every(l => l.apprStatus === 'WAIT');
            }
            return false;
        }
    }
});