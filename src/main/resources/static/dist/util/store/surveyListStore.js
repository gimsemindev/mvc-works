import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import http from 'http';

export const useSurveyListStore = defineStore('surveyList', () => {

    // ── state ──
    const list = ref([]);
    const totalCount = ref(0);
    const pageNo = ref(1);
    const pageSize = ref(20);
    const keyword = ref('');
    const statusFilter = ref('');
    const loading = ref(false);

    // 폼 (생성/수정)
    const form = ref({
        surveyId: null,
        title: '',
        description: '',
        anonymousYn: 'N',
        status: 'DRAFT',
        startDate: '',
        endDate: '',
        questions: [],
        targets: []
    });

    // ── 목록 조회 ──
    async function fetchList() {
        loading.value = true;
        try {
            const res = await http.get('/survey', {
                params: {
                    keyword: keyword.value,
                    status: statusFilter.value,
                    pageNo: pageNo.value,
                    pageSize: pageSize.value
                }
            });
            list.value = res.data.list || [];
            totalCount.value = res.data.totalCount || 0;
        } catch (e) {
            console.error('설문 목록 조회 실패:', e);
        } finally {
            loading.value = false;
        }
    }

    // 검색
    function search() {
        pageNo.value = 1;
        fetchList();
    }

    // ── 상세 조회 ──
    async function fetchDetail(surveyId) {
        try {
            const res = await http.get('/survey/' + surveyId);
            const data = res.data;

            form.value = {
                surveyId: data.survey.surveyId,
                title: data.survey.title,
                description: data.survey.description || '',
                anonymousYn: data.survey.anonymousYn || 'N',
                status: data.survey.status,
                startDate: data.survey.startDate || '',
                endDate: data.survey.endDate || '',
                questions: data.questions || [],
                targets: data.targets || []
            };
        } catch (e) {
            console.error('설문 상세 조회 실패:', e);
        }
    }

    // ── 폼 초기화 ──
    function resetForm() {
        form.value = {
            surveyId: null,
            title: '',
            description: '',
            anonymousYn: 'N',
            status: 'DRAFT',
            startDate: '',
            endDate: '',
            questions: [],
            targets: []
        };
    }

    // ── 질문 추가 ──
    function addQuestion() {
        form.value.questions.push({
            questionText: '',
            questionType: 'SINGLE',
            sortOrder: form.value.questions.length + 1,
            options: [{ optionText: '', sortOrder: 1 }]
        });
    }

    // 질문 삭제
    function removeQuestion(index) {
        form.value.questions.splice(index, 1);
        form.value.questions.forEach((q, i) => q.sortOrder = i + 1);
    }

    // ── 선택지 추가 ──
    function addOption(qIndex) {
        const q = form.value.questions[qIndex];
        q.options.push({
            optionText: '',
            sortOrder: q.options.length + 1
        });
    }

    // 선택지 삭제
    function removeOption(qIndex, oIndex) {
        const q = form.value.questions[qIndex];
        q.options.splice(oIndex, 1);
        q.options.forEach((o, i) => o.sortOrder = i + 1);
    }

    // ── 저장 (등록/수정) ──
    async function saveForm() {
        const body = {
            title: form.value.title,
            description: form.value.description,
            anonymousYn: form.value.anonymousYn,
            status: form.value.status,
            startDate: form.value.startDate,
            endDate: form.value.endDate,
            questions: form.value.questions,
            targets: form.value.targets
        };

        try {
            if (form.value.surveyId) {
                await http.post('/survey/' + form.value.surveyId, body);
            } else {
                const res = await http.post('/survey', body);
                form.value.surveyId = res.data.surveyId;
            }
            return true;
        } catch (e) {
            console.error('설문 저장 실패:', e);
            console.error('서버 응답:', e.response?.data);
            alert('저장 실패: ' + (e.response?.data?.error || e.message));
            return false;
        }
    }

    // ── 삭제 ──
    async function deleteSurvey(surveyId) {
        try {
            await http.delete('/survey/' + surveyId);
            await fetchList();
            return true;
        } catch (e) {
            console.error('설문 삭제 실패:', e);
            return false;
        }
    }

    // ── 배포 (DRAFT → ACTIVE) ──
    async function publish(surveyId) {
        try {
            await http.post('/survey/' + surveyId + '/publish');
            return true;
        } catch (e) {
            console.error('설문 배포 실패:', e);
            return false;
        }
    }

    // ── 마감 (ACTIVE → CLOSED) ──
    async function closeSurvey(surveyId) {
        try {
            await http.post('/survey/' + surveyId + '/close');
            return true;
        } catch (e) {
            console.error('설문 마감 실패:', e);
            return false;
        }
    }

    // ── 페이징 ──
    const totalPages = computed(() => Math.ceil(totalCount.value / pageSize.value));

    function goPage(n) {
        pageNo.value = n;
        fetchList();
    }

    return {
        list, totalCount, pageNo, pageSize, keyword, statusFilter, loading,
        form, totalPages,
        fetchList, search, fetchDetail, resetForm,
        addQuestion, removeQuestion, addOption, removeOption,
        saveForm, deleteSurvey, publish, closeSurvey, goPage
    };
});