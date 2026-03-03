import { defineStore } from 'pinia';
import http from 'http';

export const useApprovalCreateStore = defineStore('approvalCreate', {
    state: () => ({
        // 문서유형
        docTypeList: [],
        selectedDocTypeId: null,
        selectedDocTypeName: '',
        formVisible: false,
		selectedFormCode: '',
		selectedNotice: '',
		expenseRows: [{ date: '', content: '', vendor: '', amount: 0, remark: '' }],

        // 결재선 / 참조자
        approvers: [],
        references: []
    }),

	getters: {
	    expenseTotal: (state) => {
	        return state.expenseRows.reduce((sum, row) => sum + (row.amount || 0), 0);
	    }
	},
		
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
		    const doc = this.docTypeList.find(d => d.docTypeId === id);
		    this.selectedFormCode = doc ? doc.formCode : '';
		    this.selectedNotice = doc ? doc.notice : '';
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
        },

		addExpenseRow() {
		    this.expenseRows.push({ date: '', content: '', vendor: '', amount: 0, remark: '' });
		},
		removeExpenseRow() {
		    if (this.expenseRows.length > 1) this.expenseRows.pop();
		},
						
		async saveTemplate(tempName) {
		    if (this.approvers.length === 0) {
		        alert('결재자를 먼저 추가해 주세요.');
		        return false;
		    }

		    try {
		        const data = {
		            tempName: tempName,
		            lines: this.approvers.map(p => ({
		                apprEmpId: p.empId,
		                apprEmpName: p.name,
		                apprDeptCode: p.deptCode || '',
		                apprDeptName: p.dept || '',
		                apprGradeCode: p.gradeCode || '',
		                apprGradeName: p.grade || ''
		            }))
		        };

		        await http.post('/approval/template', data);
		        alert('템플릿이 저장되었습니다.');
		        return true;
		    } catch (e) {
		        console.error('템플릿 저장 실패:', e);
		        alert('템플릿 저장 중 오류가 발생했습니다.');
		        return false;
		    }
		},
		
		// ── 템플릿 목록 조회 ──
		async fetchTemplates() {
		    try {
		        const res = await http.get('/approval/template');
		        return res.data.list || [];
		    } catch (e) {
		        console.error('템플릿 목록 조회 실패:', e);
		        return [];
		     }
		},

		// ── 템플릿 불러오기 (결재선에 적용) ──
		async loadTemplate(tempId) {
		    try {
		        const res = await http.get('/approval/template/' + tempId);
		        const lines = res.data.lines || [];

		        this.approvers = lines.map(l => ({
		            empId: l.apprEmpId,
		            name: l.apprEmpName,
		            deptCode: l.apprDeptCode,
		            dept: l.apprDeptName,
		            gradeCode: l.apprGradeCode,
		            grade: l.apprGradeName
		        }));

		        return true;
		    } catch (e) {
		        console.error('템플릿 불러오기 실패:', e);
		        alert('템플릿 불러오기 중 오류가 발생했습니다.');
		        return false;
		    }
		},

		// ── 템플릿 삭제 ──
		async deleteTemplate(tempId) {
		    try {
		        await http.delete('/approval/template/' + tempId);
		        return true;
		    } catch (e) {
		        console.error('템플릿 삭제 실패:', e);
		        alert('템플릿 삭제 중 오류가 발생했습니다.');
		        return false;
		    }
		}
    }
});
