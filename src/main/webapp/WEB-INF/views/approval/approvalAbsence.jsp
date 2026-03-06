<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC - 부재 등록</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvalAbsencelist.css" type="text/css">
<meta name="ctx" content="${pageContext.request.contextPath}">
<style>[v-cloak] { display: none; }</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
<div id="vue-app" v-cloak>

    <!-- 상단 액션 바 -->
    <div class="absence-topbar">
        <button class="btn-new-absence" @click="openForm">
            <span class="material-symbols-outlined">add</span>
            + 부재 등록
        </button>
    </div>

    <!-- 본문 영역 -->
    <div class="absence-body">

        <!-- 왼쪽: 부재 등록 폼 (토글) -->
        <div class="form-panel" v-if="showForm">
            <div class="form-panel-header">
                <span class="material-symbols-outlined">event_busy</span>
                부재 등록
            </div>
            <div class="form-panel-body">

                <!-- 적용 프로젝트 -->
                <div class="form-info-box">
                    <span class="material-symbols-outlined" style="color:#1bbfb0; font-size:16px;">check_circle</span>
                    <div>
                        <div class="form-info-project">프로젝트A</div>
                        <div class="form-info-desc">현재 선택된 프로젝트에만 적용됩니다.</div>
                    </div>
                </div>

                <!-- 부재 기간 -->
                <div class="form-field">
                    <label class="form-label">부재 기간 <span class="required">*</span></label>
                    <div class="date-range">
                        <input type="date" v-model="form.startDate" class="form-input">
                        <span class="date-sep">~</span>
                        <input type="date" v-model="form.endDate" class="form-input">
                    </div>
                </div>

                <!-- 부재 사유 -->
                <div class="form-field">
                    <label class="form-label">부재 사유</label>
                    <select v-model="form.reason" class="form-select">
                        <option value="">사유 선택 (선택)</option>
                        <option value="VACATION">연차/휴가</option>
                        <option value="BUSINESS">출장</option>
                        <option value="SICK">병가</option>
                        <option value="OTHER">기타</option>
                    </select>
                </div>

                <!-- 대결자 검색 -->
                <div class="form-field">
                    <label class="form-label">대결자 <span class="required">*</span></label>
                    <div class="search-bar">
                        <input type="text" v-model="searchKeyword"
                               class="form-input"
                               placeholder="이름 또는 부서로 검색...">
                        <button class="btn-search" @click="searchMembers">
                            <span class="material-symbols-outlined">search</span>
                        </button>
                    </div>

                    <!-- 검색 결과 -->
                    <div class="member-list" v-if="memberList.length > 0">
                        <div class="member-item" v-for="member in memberList" :key="member.empId"
                             :class="{ selected: form.substituteId === member.empId }">
                            <div class="member-avatar" :style="{ background: member.avatarColor }">
                                {{ member.empName.charAt(0) }}
                            </div>
                            <div class="member-info">
                                <div class="member-name">{{ member.empName }}</div>
                                <div class="member-dept">{{ member.deptName }} · {{ member.gradeName }}</div>
                            </div>
                            <button class="btn-select"
                                    :class="{ 'btn-selected': form.substituteId === member.empId }"
                                    @click="selectMember(member)">
                                {{ form.substituteId === member.empId ? '선택됨' : '선택' }}
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 안내 박스 -->
                <div class="notice-box">
                    <span class="material-symbols-outlined" style="font-size:14px; color:#d97706;">info</span>
                    부재 기간 중 배정된 결재는 선택한 대결자가 처리합니다. 대결자는 동일 프로젝트 투입 인원이어야 합니다.
                </div>

                <!-- 버튼 -->
                <div class="form-footer">
                    <button class="btn-cancel-form" @click="cancelForm">취소</button>
                    <button class="btn-submit" @click="submitForm">등록</button>
                </div>
            </div>
        </div>

        <!-- 오른쪽: 부재 목록 테이블 -->
        <div class="table-panel">
            <table class="absence-table">
                <thead>
                    <tr>
                        <th>부재 기간</th>
                        <th>부재 사유</th>
                        <th>대결자</th>
                        <th>부서 · 직급</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="absenceList.length === 0">
                        <td colspan="6" style="text-align:center; padding:40px; color:#9aa0b4;">
                            등록된 부재 일정이 없습니다.
                        </td>
                    </tr>
                    <tr v-for="item in absenceList" :key="item.absenceId">
                        <td>
                            <div class="td-period">{{ item.startDate }} ~ {{ item.endDate }}</div>
                            <div class="td-days">{{ item.days }}일간</div>
                        </td>
                        <td>{{ item.reasonName || '-' }}</td>
                        <td>{{ item.substituteName }}</td>
                        <td>{{ item.substituteDept }} · {{ item.substituteGrade }}</td>
                        <td>
                            <span class="status-badge" :class="'status-' + item.status">
                                {{ item.statusName }}
                            </span>
                        </td>
                        <td>
                            <button class="btn-delete" @click="deleteAbsence(item.absenceId)">취소</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
    "imports": {
        "http": "/dist/util/http.js",
        "absenceStore": "/dist/util/store/absenceStore.js"
    }
}
</script>

<script type="module">
    import { createApp, ref, } from 'vue';
    import { createPinia } from 'pinia';

    const app = createApp({
        setup() {
            const ctx = document.querySelector('meta[name="ctx"]').content;

            const showForm      = ref(false);
            const searchKeyword = ref('');
            const memberList    = ref([]);
            const absenceList   = ref([]);

            const form = ref({
                startDate:    '',
                endDate:      '',
                reason:       '',
                substituteId: null,
                substituteName: ''
            });

            const openForm   = () => { showForm.value = true; };
            const cancelForm = () => {
                showForm.value = false;
                resetForm();
            };

            const resetForm = () => {
                form.value = { startDate: '', endDate: '', reason: '', substituteId: null, substituteName: '' };
                searchKeyword.value = '';
                memberList.value = [];
            };

            const searchMembers = async () => {
                if (!searchKeyword.value.trim()) return;
                try {
                    const res = await fetch(ctx + '/api/absence/members?keyword=' + encodeURIComponent(searchKeyword.value));
                    const data = await res.json();
                    const colors = ['#4e73df','#1bbfb0','#e06c6c','#9b59b6','#e67e22'];
                    memberList.value = data.map((m, i) => ({
                        ...m,
                        avatarColor: colors[i % colors.length]
                    }));
                } catch(e) {
                    console.error('멤버 검색 실패:', e);
                }
            };

            const selectMember = (member) => {
                form.value.substituteId   = member.empId;
                form.value.substituteName = member.empName;
            };

            const submitForm = async () => {
                if (!form.value.startDate || !form.value.endDate) {
                    alert('부재 기간을 입력해주세요.'); return;
                }
                if (!form.value.substituteId) {
                    alert('대결자를 선택해주세요.'); return;
                }
                try {
                    await fetch(ctx + '/api/absence', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(form.value)
                    });
                    alert('부재가 등록되었습니다.');
                    cancelForm();
                    fetchAbsenceList();
                } catch(e) {
                    alert('등록 중 오류가 발생했습니다.');
                }
            };

            const deleteAbsence = async (id) => {
                if (!confirm('부재 일정을 취소하시겠습니까?')) return;
                try {
                    await fetch(ctx + '/api/absence/' + id, { method: 'DELETE' });
                    fetchAbsenceList();
                } catch(e) {
                    alert('취소 중 오류가 발생했습니다.');
                }
            };

            const fetchAbsenceList = async () => {
                try {
                    const res = await fetch(ctx + '/api/absence/list');
                    absenceList.value = await res.json();
                } catch(e) {
                    console.error('부재 목록 조회 실패:', e);
                }
            };

            return {
                showForm, searchKeyword, memberList, absenceList, form,
                openForm, cancelForm, searchMembers, selectMember,
                submitForm, deleteAbsence
            };
        }
    });

    app.use(createPinia());
    app.mount('#vue-app');
</script>

</body>
</html>
