<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectlist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvalview.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvalcreate.css" type="text/css">
<meta name="ctx"   content="${pageContext.request.contextPath}">
<meta name="docId" content="${param.docId}">
<style>[v-cloak] { display: none; }</style>
<style>
.form-section input,
.form-section select,
.form-section textarea {
    pointer-events: none;
    background-color: #f9fafb;
    color: #344054;
}
.btn-expense-add, .btn-expense-remove {
    display: none;
}
.ql-toolbar { display: none; }
.ql-editor { pointer-events: none; background-color: #f9fafb; color: #344054; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
<div id="vue-app" v-cloak>

   
    <div v-if="store.loading" style="text-align:center; padding:60px; color:#9aa0b4;">
        <span class="material-symbols-outlined" style="font-size:32px;">hourglass_empty</span>
        <p>불러오는 중...</p>
    </div>

    
    <div v-else-if="store.error" style="text-align:center; padding:60px; color:#e53e3e;">
        <span class="material-symbols-outlined" style="font-size:32px;">error</span>
        <p>{{ store.error }}</p>
    </div>

    
    <template v-else-if="store.doc">

        
        <div class="page-header">
            <span class="material-symbols-outlined">forward_to_inbox</span>
            <span class="page-header-label">전자결재</span>
            <span class="page-header-divider">›</span>
            <span class="page-header-doc">{{ store.doc.typeName }}</span>
        </div>

        
        <div class="view-section">
            <div class="view-section-header">
                <span class="material-symbols-outlined">info</span>
                기본 정보
            </div>
            <div class="view-section-body">
                <div class="info-grid">
                    <div class="view-field">
                        <label>문서번호</label>
                        <div class="view-value">{{ store.doc.docId }}</div>
                    </div>
                    <div class="view-field">
                        <label>작성일</label>
                        <div class="view-value">{{ store.doc.regDate }}</div>
                    </div>
                    <div class="view-field">
                        <label>작성자</label>
                        <div class="view-value">{{ store.doc.writerDeptName }} | {{ store.doc.writerEmpName }} {{ store.doc.writerGradeName }}</div>
                    </div>
                    <div class="view-field">
                        <label>결재 유형</label>
                        <div class="view-value">{{ store.doc.typeName }}</div>
                    </div>
                    <div class="view-field">
                        <label>제목</label>
                        <div class="view-value">{{ store.doc.title }}</div>
                    </div>
                    <div class="view-field">
                        <label>결재 상태</label>
                        <div class="view-value">
                            <span class="status-badge" :class="'status-' + store.doc.docStatus">
                                {{ store.statusLabel(store.doc.docStatus) }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        
        <div class="view-section">
            <div class="view-section-header">
                <span class="material-symbols-outlined">group</span>
                결재선 정보
            </div>
            <div class="view-section-body">
                <div v-if="store.doc.lines && store.doc.lines.length > 0" class="line-grid">
                    <div class="line-card" :class="'line-' + line.apprStatus" v-for="line in store.doc.lines" :key="line.lineId">
                        <div class="line-card-header">{{ line.stepOrder }}단계</div>
                        <div class="line-card-body">
                            <div class="line-card-name">{{ line.apprEmpName }}</div>
                            <div class="line-card-dept">{{ line.apprDeptName }} · {{ line.apprGradeName }}</div>
                            <span class="status-badge" :class="'status-' + line.apprStatus">
                                {{ store.lineStatusLabel(line.apprStatus) }}
                            </span>
                        </div>
                    </div>
                </div>
                <div v-else style="font-size:12px; color:#9aa0b4;">결재선 정보가 없습니다.</div>
            </div>
        </div>

        <!-- 참조자 정보 -->
        <div class="view-section" v-if="store.doc.refs && store.doc.refs.length > 0">
            <div class="view-section-header">
                <span class="material-symbols-outlined">visibility</span>
                참조자 정보
            </div>
            <div class="view-section-body">
                <div class="line-grid">
                    <div class="line-card" v-for="ref in store.doc.refs" :key="ref.refId">
                        <div class="line-card-body">
                            <div class="line-card-name">{{ ref.refEmpName }}</div>
                            <div class="line-card-dept">{{ ref.refDeptName }} · {{ ref.refGradeName }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <jsp:include page="/WEB-INF/views/approval/include/approvalDetailLeave.jsp"/>
        <jsp:include page="/WEB-INF/views/approval/include/approvalDetailBiztrip.jsp"/>
        <jsp:include page="/WEB-INF/views/approval/include/approvalDetailExpense.jsp"/>
        <jsp:include page="/WEB-INF/views/approval/include/approvalDetailClaim.jsp"/>
        <jsp:include page="/WEB-INF/views/approval/include/approvalDetailGeneral.jsp"/>

        
        <div class="view-section">
            <div class="view-section-header">
                <span class="material-symbols-outlined">attach_file</span>
                첨부파일
            </div>
            <div class="view-section-body">
                <div v-if="store.doc.files && store.doc.files.length > 0" class="file-list">
                    <div class="file-item" v-for="file in store.doc.files" :key="file.fileId">
                        <span class="material-symbols-outlined">description</span>
                        <span class="file-item-name">{{ file.oriFilename }}</span>
                        <span class="file-item-size">{{ store.formatSize(file.fileSize) }}</span>
                        <button class="file-item-btn"
                                @click="download(file.saveFilename, file.oriFilename)">
                            다운로드
                        </button>
                    </div>
                </div>
                <div v-else class="no-file">첨부된 파일이 없습니다.</div>
            </div>
        </div>

        
        <div class="view-footer">
            <button class="btn-cancel"
                    v-if="store.doc.writerEmpId === currentEmpId && store.canCancel"
                    @click="cancelDoc">
                <span class="material-symbols-outlined" style="font-size:15px">cancel</span>
                결재취소
            </button>
            <button class="btn-back" @click="goList">
                <span class="material-symbols-outlined" style="font-size:15px">arrow_back</span>
                목록
            </button>
        </div>

    </template>

</div>
</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
    "imports": {
        "http":              "/dist/util/http.js",
        "approvalViewStore": "/dist/util/store/approvalViewStore.js",
        "commonCodeStore":   "/dist/util/store/commonCodeStore.js"
    }
}
</script>

<script type="module">
    import { createApp, onMounted } from 'vue';
    import { createPinia } from 'pinia';
    import { useApprovalViewStore } from 'approvalViewStore';
    import { useCommonCodeStore }   from 'commonCodeStore';

    const pinia = createPinia();

    const app = createApp({
        setup() {
            const store     = useApprovalViewStore();
            const codeStore = useCommonCodeStore();   // ← Leave.jsp 에서 사용
            const ctx   = document.querySelector('meta[name="ctx"]').content;
            const docId = document.querySelector('meta[name="docId"]').content;

            const currentEmpId = '${sessionScope.member.empId}';

            const goList = () => { location.href = ctx + '/approval/list'; };

            const cancelDoc = async () => {
                if (!confirm('결재를 취소하시겠습니까?')) return;
                const ok = await store.cancelDoc(docId);
                if (ok) location.href = ctx + '/approval/list';
            };

            const download = (saveFilename, oriFilename) => {
                const a = document.createElement('a');
                a.href     = ctx + '/api/approval/file/' + saveFilename;
                a.download = oriFilename;
                a.click();
            };

            onMounted(async () => {
                  await codeStore.fetchCodes('DOCSTATUS');
                  await codeStore.fetchCodes('LINESTATUS');
                  if (docId) {
   					  await store.fetchDoc(docId);
      				  // formCode에 따라 필요한 공통코드 로드
      				  if (store.selectedFormCode === 'FM001') {
                          await codeStore.fetchCodes('LEAVETYPE');
                      }
            }


                if (typeof Quill !== 'undefined') {
                    const tryInit = setInterval(() => {
                        const el = document.getElementById('general-editor');
                        if (el && !el.__quill) {
                            el.__quill = new Quill(el, {
                                theme: 'snow',
                                placeholder: '상세 내용을 입력해주세요.',
                                modules: {
                                    toolbar: [
                                        [{ 'header': [1, 2, 3, false] }],
                                        ['bold', 'italic', 'underline', 'strike'],
                                        [{ 'color': [] }, { 'background': [] }],
                                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                                        [{ 'align': [] }],
                                        ['link', 'image'],
                                        ['clean']
                                    ]
                                }
                            });
                            // 저장된 내용 복원
                            if (store.detailData?.description) {
                                el.__quill.root.innerHTML = store.detailData.description;
                            }
                            clearInterval(tryInit);
                        }
                    }, 300);
                }
            });

            return { store, codeStore, goList, download, cancelDoc, currentEmpId };
        }
    });

    app.use(pinia);
    app.mount('#vue-app');
</script>

</body>
</html>
