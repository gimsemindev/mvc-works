<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC - 설문 응답</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/surveyRespond.css" type="text/css">
<meta name="ctx" content="${pageContext.request.contextPath}">
<style>[v-cloak] { display: none; }</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
    <div id="vue-app" v-cloak>

        <!-- 로딩 -->
        <div v-if="store.loading" style="text-align:center;padding:60px;color:#9aa0b4;">
            설문을 불러오는 중...
        </div>

        <!-- 대상자 아님 -->
        <div v-else-if="!store.isTarget" class="respond-done">
            <div class="done-icon"><i class="fas fa-ban"></i></div>
            <h3>응답 권한이 없습니다</h3>
            <p>이 설문의 대상자가 아닙니다.</p>
            <button class="btn-back" style="margin-top:20px;" @click="goList">
                <i class="fas fa-arrow-left"></i> 목록으로
            </button>
        </div>

        <!-- 이미 응답 완료 -->
        <div v-else-if="store.responded" class="respond-done">
            <div class="done-icon"><i class="fas fa-check-circle"></i></div>
            <h3>이미 응답을 완료했습니다</h3>
            <p>해당 설문에 대한 응답이 이미 제출되었습니다.</p>
            <button class="btn-back" style="margin-top:20px;" @click="goList">
                <i class="fas fa-arrow-left"></i> 목록으로
            </button>
        </div>

        <!-- 설문 응답 폼 -->
        <div v-else>

            <!-- 뒤로가기 -->
            <button class="btn-back" @click="goList">
                <i class="fas fa-arrow-left"></i> 설문 목록
            </button>

            <!-- 설문 안내 헤더 -->
            <div class="respond-header">
                <h2>{{ store.survey.title }}</h2>
                <p class="respond-desc" v-if="store.survey.description">{{ store.survey.description }}</p>
                <div class="respond-meta">
                    <span><i class="far fa-calendar"></i> {{ store.survey.startDate || '-' }} ~ {{ store.survey.endDate || '-' }}</span>
                    <span><i class="fas fa-user-secret"></i> {{ store.survey.anonymousYn === 'Y' ? '익명 설문' : '실명 설문' }}</span>
                    <span><i class="fas fa-list-ol"></i> 총 {{ store.questions.length }}개 질문</span>
                </div>
            </div>

            <!-- 질문 카드 반복 -->
            <div class="respond-question" v-for="(q, qi) in store.questions" :key="q.questionId">
                <div class="q-label">Q{{ qi + 1 }}. {{ q.questionText }}</div>
                <span class="q-type-badge" :class="q.questionType">{{ typeName(q.questionType) }}</span>

                <!-- SINGLE: 라디오 -->
                <div v-if="q.questionType === 'SINGLE'" class="respond-options">
                    <div class="respond-option"
                         v-for="opt in q.options" :key="opt.optionId"
                         :class="{ selected: store.answers[q.questionId] === opt.optionId }"
                         @click="store.answers[q.questionId] = opt.optionId">
                        <input type="radio" :name="'q_' + q.questionId"
                               :value="opt.optionId"
                               v-model="store.answers[q.questionId]">
                        <label>{{ opt.optionText }}</label>
                    </div>
                </div>

                <!-- MULTI: 체크박스 -->
                <div v-if="q.questionType === 'MULTI'" class="respond-options">
                    <div class="respond-option"
                         v-for="opt in q.options" :key="opt.optionId"
                         :class="{ selected: store.answers[q.questionId] && store.answers[q.questionId].includes(opt.optionId) }"
                         @click="store.toggleMulti(q.questionId, opt.optionId)">
                        <input type="checkbox"
                               :checked="store.answers[q.questionId] && store.answers[q.questionId].includes(opt.optionId)">
                        <label>{{ opt.optionText }}</label>
                    </div>
                </div>

                <!-- TEXT: 서술형 -->
                <div v-if="q.questionType === 'TEXT'">
                    <textarea class="respond-textarea"
                              v-model="store.answers[q.questionId]"
                              placeholder="답변을 입력해주세요"></textarea>
                </div>

                <!-- SCORE: 점수 -->
                <div v-if="q.questionType === 'SCORE'">
                    <div class="respond-score">
                        <button class="score-btn" v-for="n in 5" :key="n"
                                :class="{ selected: store.answers[q.questionId] === n }"
                                @click="store.answers[q.questionId] = n">{{ n }}</button>
                    </div>
                    <div class="score-labels">
                        <span>매우 불만족</span>
                        <span>매우 만족</span>
                    </div>
                </div>
            </div>

            <!-- 제출 버튼 -->
            <div class="respond-footer">
                <button class="btn-submit" @click="doSubmit">응답 제출</button>
            </div>

        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
    "imports": {
        "http": "${pageContext.request.contextPath}/dist/util/http.js",
        "surveyRespondStore": "${pageContext.request.contextPath}/dist/util/store/surveyRespondStore.js?v=2"
    }
}
</script>

<script type="module">
import { createApp, ref, onMounted } from 'vue';
import { createPinia } from 'pinia';
import { useSurveyRespondStore } from 'surveyRespondStore';

const app = createApp({
    setup() {
        const store = useSurveyRespondStore();

        // URL에서 surveyId 추출
        const params = new URLSearchParams(location.search);
        const surveyId = Number(params.get('surveyId'));

        // 질문유형 한글
        function typeName(code) {
            const map = { 'SINGLE': '단일선택', 'MULTI': '복수선택', 'TEXT': '서술형', 'SCORE': '점수형' };
            return map[code] || code;
        }

        // 목록으로
        function goList() {
            location.href = document.querySelector('meta[name="ctx"]').content + '/survey/list';
        }

        // 응답 제출
        async function doSubmit() {
            if (!confirm('응답을 제출하시겠습니까? 제출 후에는 수정할 수 없습니다.')) return;
            const ok = await store.submitResponse(surveyId);
            if (ok) {
                alert('응답이 제출되었습니다.');
            }
        }

        onMounted(() => {
            if (surveyId) {
                store.fetchSurvey(surveyId);
            }
        });

        return { store, typeName, goList, doSubmit };
    }
});

app.use(createPinia());
app.mount('#vue-app');
</script>
