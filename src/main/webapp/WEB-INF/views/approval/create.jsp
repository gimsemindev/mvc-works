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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectlist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvalcreate.css" type="text/css">
<meta name="ctx" content="${pageContext.request.contextPath}">
<style>[v-cloak] { display: none; }</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">

    <div id="vue-app" v-cloak>

        <!-- 페이지 타이틀 + 문서 타이틀 한 줄 -->
        <div class="page-header">
            <span class="material-symbols-outlined">forward_to_inbox</span>
            <span class="page-header-label">전자결재</span>
            <span class="page-header-divider">›</span>
            <span class="page-header-doc">{{ store.selectedDocTypeName }}</span>
        </div>

        <!-- 결재양식 선택 모달 -->
        <div class="modal-overlay" v-if="!store.formVisible">
            <div class="modal-box">
                <div class="modal-header">
                    <div class="modal-breadcrumb">전자 결재 &gt; <span>등록</span></div>
                    <div class="modal-header-btns">
                        <button title="전체화면">
                            <span class="material-symbols-outlined" style="font-size:18px">open_in_full</span>
                        </button>
                        <button title="닫기" @click="goList">
                            <span class="material-symbols-outlined" style="font-size:18px">close</span>
                        </button>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="modal-section-title">
                        <span class="material-symbols-outlined">description</span>
                        결재양식 선택
                    </div>
                    <div class="form-type-list">
                        <div v-if="store.docTypeList.length === 0"
                             style="text-align:center; color:#9aa0b4; padding:40px;">
                            등록된 문서유형이 없습니다.
                        </div>
                        <div v-for="item in store.docTypeList" :key="item.docTypeId"
                             class="form-type-item"
                             @click="store.selectDocType(item.docTypeId, item.typeName)">
                            <span class="material-symbols-outlined">description</span>
                            <div class="form-type-item-content">
                                <div class="form-type-item-title">{{ item.typeName }}</div>
                                <div class="form-type-item-desc">{{ item.description ? '• ' + item.description : '' }}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-close-modal" @click="goList">닫기</button>
                </div>
            </div>
        </div>

        <!-- 결재자 검색 모달 (재사용 컴포넌트) -->
        <org-search-modal
            v-model:visible="approverModalVisible"
            title="결재자 검색"
            :added-emp-ids="approverEmpIds"
            @add="store.addApprover($event)">
        </org-search-modal>

        <!-- 참조자 검색 모달 (재사용 컴포넌트) -->
        <org-search-modal
            v-model:visible="referenceModalVisible"
            title="참조자 검색"
            :added-emp-ids="referenceEmpIds"
            @add="store.addReference($event)">
        </org-search-modal>

        <!-- 결재 작성 폼 -->
        <div class="approval-form-wrap" :class="{ active: store.formVisible }">

            <div class="form-doc-title">{{ store.selectedDocTypeName }}</div>

            <!-- 기본 정보 -->
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-title">
                        <span class="material-symbols-outlined">info</span>
                        기본 정보
                    </div>
                </div>
                <div class="form-section-body">
                    <div class="info-grid">
                        <div class="form-field">
                            <label>문서번호</label>
                            <input type="text" value="자동으로 생성됩니다" readonly>
                        </div>
                        <div class="form-field">
                            <label>작성일</label>
                            <input type="text" :value="todayDate" readonly>
                        </div>
                        <div class="form-field">
                            <label>작성자</label>
                            <input type="text" value="경영지원팀 | 신준안 대표" readonly>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 결재선 정보 -->
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-title">
                        <span class="material-symbols-outlined">group</span>
                        결재선 정보
                    </div>
                    <button class="btn-add-line" @click="approverModalVisible = true">
                        <span class="material-symbols-outlined" style="font-size:15px">person_add</span>
                        결재자 추가
                    </button>
                </div>
                <div class="form-section-body">
                    <div class="line-list">
                        <div v-if="store.approvers.length === 0" class="line-empty">
                            <span class="material-symbols-outlined">how_to_reg</span>
                            결재자를 추가해 주세요.
                        </div>
                        <div v-for="(p, idx) in store.approvers" :key="p.empId"
                             class="line-item" draggable="true"
                             :class="{ dragging: drag.fromIdx === idx, 'drag-over': drag.overIdx === idx }"
                             @dragstart="onDragStart(idx, $event)"
                             @dragover.prevent="onDragOver(idx)"
                             @drop.prevent="onDrop(idx)"
                             @dragend="onDragEnd">
                            <span class="drag-handle">&#9776;</span>
                            <span class="line-seq">{{ idx + 1 }}</span>
                            <span class="line-name">{{ p.name }}</span>
                            <span class="line-dept">{{ p.dept }}</span>
                            <span class="line-grade">{{ p.grade }}</span>
                            <button class="btn-line-remove" @click.stop="store.removeApprover(idx)">
                                <span class="material-symbols-outlined" style="font-size:14px">close</span>
                            </button>
                        </div>
                    </div>
                    <div v-if="store.approvers.length > 0" class="line-hint">
                        <span class="material-symbols-outlined" style="font-size:13px">info</span>
                        드래그하여 결재 순서를 변경할 수 있습니다.
                    </div>
                </div>
            </div>

            <!-- 참조자 정보 -->
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-title">
                        <span class="material-symbols-outlined">person_add</span>
                        참조자 정보
                    </div>
                    <button class="btn-add-line" @click="referenceModalVisible = true">
                        <span class="material-symbols-outlined" style="font-size:15px">group_add</span>
                        참조자 추가
                    </button>
                </div>
                <div class="form-section-body">
                    <div class="line-list ref-list">
                        <div v-if="store.references.length === 0" class="line-empty">
                            <span class="material-symbols-outlined">group</span>
                            참조자를 추가해 주세요.
                        </div>
                        <div v-for="(p, idx) in store.references" :key="p.empId"
                             class="line-item ref-item">
                            <span class="line-name">{{ p.name }}</span>
                            <span class="line-dept">{{ p.dept }}</span>
                            <span class="line-grade">{{ p.grade }}</span>
                            <button class="btn-line-remove" @click="store.removeReference(idx)">
                                <span class="material-symbols-outlined" style="font-size:14px">close</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 세부 정보 -->
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-title">
                        <span class="material-symbols-outlined">edit_note</span>
                        세부 정보
                    </div>
                </div>
                <div class="form-section-body">
                    <div class="detail-grid">
                        <div class="form-field">
                            <label>휴가 종류</label>
                            <select>
                                <option value="">선택</option>
                                <option>연차</option>
                                <option>반차(오전)</option>
                                <option>반차(오후)</option>
                                <option>병가</option>
                                <option>예비군</option>
                                <option>무급</option>
                            </select>
                        </div>
                        <div class="form-field">
                            <label>휴가 시작일</label>
                            <div class="detail-grid-input">
                                <input type="date">
                                <select><option>종일</option><option>오전</option><option>오후</option></select>
                            </div>
                        </div>
                        <div class="form-field">
                            <label>휴가 종료일</label>
                            <div class="detail-grid-input">
                                <input type="date">
                                <select><option>종일</option><option>오전</option><option>오후</option></select>
                            </div>
                        </div>
                        <div class="form-field">
                            <label>총 휴가일 수</label>
                            <div class="detail-grid-input">
                                <input type="number" placeholder="0">
                                <span style="font-size:13px;color:#667085;white-space:nowrap;">일</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>상세 설명</label>
                        <textarea rows="4" placeholder="상세 내용을 입력해주세요."></textarea>
                    </div>
                    <div class="attach-row">
                        <div class="form-field">
                            <label>관련 첨부 <span style="font-size:10px;color:#9aa0b4;">ⓘ</span></label>
                            <div class="attach-input-wrap">
                                <button class="btn-file-select" @click="fileInput.click()">파일 선택</button>
                                <span class="file-name-display">{{ fileName }}</span>
                                <input type="file" ref="fileInput" style="display:none" @change="onFileChange">
                            </div>
                        </div>
                        <div class="form-field">
                            <label>첨부된 파일</label>
                            <div class="attach-preview">첨부된 파일이 없습니다.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 참고사항 -->
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-title">
                        <span class="material-symbols-outlined">menu_book</span>
                        참고사항
                    </div>
                </div>
                <div class="form-section-body">
                    <ul class="reference-list">
                        <li><strong>[예비군 / 민방위 신청시]</strong> 동서서 스캔하여 파일 첨부</li>
                        <li><strong>[경조휴가 신청시]</strong> 각종 증빙서류 스캔하여 파일 첨부 (예: 청첩장, 등본 등)</li>
                        <li>기타 필요한 내용은 상세 설명란에 기입</li>
                    </ul>
                </div>
            </div>

            <!-- 하단 버튼 -->
            <div class="form-footer">
                <button class="btn-save-temp">
                    <span class="material-symbols-outlined" style="font-size:16px">save</span>
                    임시저장
                </button>
                <button class="btn-submit">
                    <span class="material-symbols-outlined" style="font-size:16px">send</span>
                    결재전송
                </button>
                <button class="btn-cancel" @click="goList">
                    <span class="material-symbols-outlined" style="font-size:16px">close</span>
                    목록
                </button>
            </div>

        </div>

    </div>

</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
	"imports": {
		"http": "/dist/util/http.js?v=2",
		"approvalCreateStore": "/dist/util/store/approvalCreateStore.js?v=2",
		"OrgSearchModal": "/dist/util/component/OrgSearchModal.js?v=1"
	}
}
</script>

<script type="module">
    import { createApp, ref, reactive, computed, onMounted } from 'vue';
    import { createPinia } from 'pinia';
    import { useApprovalCreateStore } from 'approvalCreateStore';
    import { OrgSearchModal } from 'OrgSearchModal';

    const app = createApp({
        setup() {
            const store = useApprovalCreateStore();
            const ctx = document.querySelector('meta[name="ctx"]').content;

            const todayDate = new Date().toLocaleDateString('ko-KR', {
                year: 'numeric', month: '2-digit', day: '2-digit', weekday: 'short'
            });

            // 모달 상태 (각각 독립)
            const approverModalVisible = ref(false);
            const referenceModalVisible = ref(false);
            const approverEmpIds = computed(() => store.approvers.map(a => a.empId));
            const referenceEmpIds = computed(() => store.references.map(r => r.empId));

            // 파일 첨부
            const fileName = ref('선택된 파일 없음');
            const fileInput = ref(null);
            const onFileChange = (e) => {
                fileName.value = e.target.files[0] ? e.target.files[0].name : '선택된 파일 없음';
            };

            // 네비게이션
            const goList = () => { location.href = ctx + '/approval/list'; };

            // 드래그 앤 드롭
            const drag = reactive({ fromIdx: null, overIdx: null });

            const onDragStart = (idx, e) => {
                drag.fromIdx = idx;
                e.dataTransfer.effectAllowed = 'move';
            };
            const onDragOver = (idx) => { drag.overIdx = idx; };
            const onDrop = (toIdx) => {
                if (drag.fromIdx !== null) {
                    store.reorderApprover(drag.fromIdx, toIdx);
                }
                drag.fromIdx = null;
                drag.overIdx = null;
            };
            const onDragEnd = () => {
                drag.fromIdx = null;
                drag.overIdx = null;
            };

            onMounted(() => store.fetchDocTypes());

            return {
                store, todayDate,
                approverModalVisible, referenceModalVisible,
                approverEmpIds, referenceEmpIds,
                fileName, fileInput, onFileChange,
                goList,
                drag, onDragStart, onDragOver, onDrop, onDragEnd
            };
        }
    });

    app.component('org-search-modal', OrgSearchModal);
    app.use(createPinia());
    app.mount('#vue-app');
</script>

</body>
</html>
