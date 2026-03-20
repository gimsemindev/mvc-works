<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC - 설문 결과</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/surveyResult.css" type="text/css">
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
            결과를 불러오는 중...
        </div>

        <div v-else>

            <!-- 뒤로가기 -->
            <button class="btn-back" @click="goList">
                <i class="fas fa-arrow-left"></i> 설문 목록
            </button>

            <!-- 결과 헤더 -->
            <div class="result-header">
                <h2>{{ store.survey.title }}</h2>
                <div class="result-meta">
                    <span><i class="far fa-calendar"></i> {{ store.survey.startDate || '-' }} ~ {{ store.survey.endDate || '-' }}</span>
                    <span><i class="fas fa-users"></i> 총 응답: <strong class="response-count">{{ store.responseCount }}명</strong></span>
                    <span><i class="fas fa-user-secret"></i> {{ store.survey.anonymousYn === 'Y' ? '익명' : '실명' }}</span>
                    <span>
                        <i class="fas fa-circle" :style="{ color: store.survey.status === 'ACTIVE' ? '#1a9660' : '#9aa0b4', fontSize: '8px' }"></i>
                        {{ store.survey.status === 'ACTIVE' ? '진행중' : '마감' }}
                    </span>
                </div>
            </div>

            <!-- 응답 없음 -->
            <div v-if="store.responseCount === 0" class="no-response">
                <i class="fas fa-chart-bar" style="font-size:36px;margin-bottom:12px;display:block;"></i>
                아직 응답이 없습니다.
            </div>

            <!-- 질문별 통계 카드 -->
            <div class="result-card" v-for="(stat, si) in store.stats" :key="si">
                <div class="q-title">Q{{ si + 1 }}. {{ stat.question.questionText }}</div>
                <span class="q-type-badge" :class="stat.question.questionType">{{ typeName(stat.question.questionType) }}</span>

                <!-- SINGLE / MULTI: 가로 막대 차트 -->
                <div v-if="stat.question.questionType === 'SINGLE' || stat.question.questionType === 'MULTI'" class="bar-chart">
                    <div class="bar-item" v-for="opt in stat.options" :key="opt.optionId">
                        <span class="bar-label">{{ opt.optionText }}</span>
                        <div class="bar-track">
                            <div class="bar-fill" :style="{ width: store.percent(opt.selectCount) + '%' }"></div>
                        </div>
                        <span class="bar-value">{{ opt.selectCount }}표 ({{ store.percent(opt.selectCount) }}%)</span>
                    </div>
                </div>

                <!-- TEXT: 서술형 답변 목록 -->
                <div v-if="stat.question.questionType === 'TEXT'" class="text-answers">
                    <div v-if="!stat.textAnswers || stat.textAnswers.length === 0" style="color:#9aa0b4;font-size:13px;">
                        텍스트 응답이 없습니다.
                    </div>
                    <div class="text-answer-item" v-for="(txt, ti) in stat.textAnswers" :key="ti">
                        {{ txt.answerText }}
                    </div>
                </div>

                <!-- SCORE: 평균 점수 + 별 -->
                <div v-if="stat.question.questionType === 'SCORE'" class="score-result">
                    <div>
                        <div class="score-big">{{ stat.avgScore ? stat.avgScore.toFixed(1) : '0.0' }}</div>
                        <div class="score-label">/ 5.0점</div>
                    </div>
                    <div>
                        <div class="score-stars">
                            <span v-for="(s, idx) in store.starArray(stat.avgScore || 0)" :key="idx"
                                  :class="s === 'filled' ? 'star-filled' : 'star-empty'">&#9733;</span>
                        </div>
                        <div class="score-label" style="margin-top:4px;">{{ store.responseCount }}명 응답</div>
                    </div>
                </div>
            </div>

        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
    "imports": {
        "http": "${pageContext.request.contextPath}/dist/util/http.js",
        "surveyResultStore": "${pageContext.request.contextPath}/dist/util/store/surveyResultStore.js?v=2"
    }
}
</script>

<script type="module">
import { createApp, ref, onMounted } from 'vue';
import { createPinia } from 'pinia';
import { useSurveyResultStore } from 'surveyResultStore';

const app = createApp({
    setup() {
        const store = useSurveyResultStore();

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

        onMounted(() => {
            if (surveyId) {
                store.fetchResult(surveyId);
            }
        });

        return { store, typeName, goList };
    }
});

app.use(createPinia());
app.mount('#vue-app');
</script>
