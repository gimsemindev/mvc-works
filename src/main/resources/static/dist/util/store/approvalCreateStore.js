import { defineStore } from 'pinia';
import http from 'http';

export const useApprovalCreateStore = defineStore('approvalCreate', {
    state: () => ({
        // 문서유형
        docTypeList: [],
        selectedDocTypeId: null,
        selectedDocTypeName: '',
        formVisible: false,

        // 결재선 / 참조자
        approvers: [],
        references: []
    }),

    actions: {
        // ── 문서유형 ──
        async fetchDocTypes() {
            try {
                const res = await http.get('/approval/doctype');
                this.docTypeList = (res.data.list || []).filter(i => i.useYn === 'Y');
            } catch (e) {
                console.error('문서유형 로딩 실패:', e);
            }
        },

        selectDocType(id, name) {
            this.selectedDocTypeId = id;
            this.selectedDocTypeName = name;
            this.formVisible = true;
        },

        // ── 결재자 ──
        addApprover(emp) {
            if (!this.approvers.some(p => p.empId === emp.empId)) {
                this.approvers.push({ ...emp });
            }
        },

        removeApprover(idx) {
            this.approvers.splice(idx, 1);
        },

        reorderApprover(fromIdx, toIdx) {
            if (fromIdx === toIdx) return;
            const [moved] = this.approvers.splice(fromIdx, 1);
            this.approvers.splice(toIdx, 0, moved);
        },

        // ── 참조자 ──
        addReference(emp) {
            if (!this.references.some(p => p.empId === emp.empId)) {
                this.references.push({ ...emp });
            }
        },

        removeReference(idx) {
            this.references.splice(idx, 1);
        }
    }
});
