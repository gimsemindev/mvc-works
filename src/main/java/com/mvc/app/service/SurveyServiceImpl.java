package com.mvc.app.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mvc.app.domain.dto.SurveyAnswerDto;
import com.mvc.app.domain.dto.SurveyDto;
import com.mvc.app.domain.dto.SurveyOptionDto;
import com.mvc.app.domain.dto.SurveyQuestionDto;
import com.mvc.app.domain.dto.SurveyResponseDto;
import com.mvc.app.domain.dto.SurveyTargetDto;
import com.mvc.app.mapper.SurveyMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SurveyServiceImpl implements SurveyService {

    private final SurveyMapper mapper;

    @Override
    public Map<String, Object> listSurvey(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countSurvey(map);
        List<SurveyDto> list = mapper.listSurvey(map);
        return Map.of("totalCount", totalCount, "list", list);
    }

    @Override
    public Map<String, Object> findById(long surveyId) throws Exception {
        SurveyDto survey = mapper.findById(surveyId);

        // 질문 목록 + 각 질문의 선택지
        List<SurveyQuestionDto> questions = mapper.listQuestion(surveyId);
        for (SurveyQuestionDto q : questions) {
            if ("SINGLE".equals(q.getQuestionType()) || "MULTI".equals(q.getQuestionType())) {
                q.setOptions(mapper.listOption(q.getQuestionId()));
            }
        }

        // 대상자 목록
        List<SurveyTargetDto> targets = mapper.listTarget(surveyId);

        Map<String, Object> result = new HashMap<>();
        result.put("survey", survey);
        result.put("questions", questions);
        result.put("targets", targets);
        return result;
    }

    @Override
    @Transactional
    public void createSurvey(SurveyDto dto, List<SurveyQuestionDto> questions, List<SurveyTargetDto> targets) throws Exception {
        // 1. 설문 마스터 등록
        mapper.insertSurvey(dto);
        long surveyId = dto.getSurveyId();

        // 2. 질문 + 선택지 등록
        for (SurveyQuestionDto q : questions) {
            q.setSurveyId(surveyId);
            mapper.insertQuestion(q);

            if (q.getOptions() != null) {
                for (SurveyOptionDto opt : q.getOptions()) {
                    opt.setQuestionId(q.getQuestionId());
                    mapper.insertOption(opt);
                }
            }
        }

        // 3. 대상자 등록
        for (SurveyTargetDto t : targets) {
            t.setSurveyId(surveyId);
            mapper.insertTarget(t);
        }
    }

    @Override
    @Transactional
    public void updateSurvey(SurveyDto dto, List<SurveyQuestionDto> questions, List<SurveyTargetDto> targets) throws Exception {
        long surveyId = dto.getSurveyId();

        // 1. 기존 자식 삭제 (선택지 → 질문 → 대상자)
        List<SurveyQuestionDto> oldQuestions = mapper.listQuestion(surveyId);
        for (SurveyQuestionDto q : oldQuestions) {
            mapper.deleteOptionsByQuestionId(q.getQuestionId());
        }
        mapper.deleteQuestionsBySurveyId(surveyId);
        mapper.deleteTargetsBySurveyId(surveyId);

        // 2. 설문 마스터 수정
        mapper.updateSurvey(dto);

        // 3. 질문 + 선택지 새로 등록
        for (SurveyQuestionDto q : questions) {
            q.setSurveyId(surveyId);
            mapper.insertQuestion(q);

            if (q.getOptions() != null) {
                for (SurveyOptionDto opt : q.getOptions()) {
                    opt.setQuestionId(q.getQuestionId());
                    mapper.insertOption(opt);
                }
            }
        }

        // 4. 대상자 새로 등록
        for (SurveyTargetDto t : targets) {
            t.setSurveyId(surveyId);
            mapper.insertTarget(t);
        }
    }
    
    @Override
    public void updateStatus(long surveyId, String status) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("surveyId", surveyId);
        map.put("status", status);
        mapper.updateStatus(map);
    }

    @Override
    @Transactional
    public void deleteSurvey(long surveyId) throws Exception {
        // 자식 → 부모 순서로 삭제

        // 1. 답변 + 응답 삭제 (혹시 DRAFT인데 테스트 데이터가 있을 수 있으므로)
        // answer는 response에 종속 → response를 지우려면 answer 먼저
        // 하지만 DRAFT에서만 삭제 가능하므로 응답이 없을 수 있음. 안전하게 처리
        // (직접 SQL로 처리 — Mapper에 별도 메서드 없으므로)

        // 2. 선택지 → 질문 삭제
        List<SurveyQuestionDto> questions = mapper.listQuestion(surveyId);
        for (SurveyQuestionDto q : questions) {
            mapper.deleteOptionsByQuestionId(q.getQuestionId());
        }
        mapper.deleteQuestionsBySurveyId(surveyId);

        // 3. 대상자 삭제
        mapper.deleteTargetsBySurveyId(surveyId);

        // 4. 설문 마스터 삭제
        mapper.deleteSurvey(surveyId);
    }

    @Override
    public boolean checkTarget(long surveyId, String empId, String deptCode) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("surveyId", surveyId);
        map.put("empId", empId);
        map.put("deptCode", deptCode);
        return mapper.checkTarget(map) > 0;
    }

    @Override
    public boolean checkResponse(long surveyId, String empId) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("surveyId", surveyId);
        map.put("empId", empId);
        return mapper.checkResponse(map) > 0;
    }

    @Override
    @Transactional
    public void submitResponse(SurveyResponseDto dto) throws Exception {
        // 1. 응답 등록 → responseId 자동 세팅
        mapper.insertResponse(dto);

        // 2. 각 답변 등록
        if (dto.getAnswers() != null) {
            for (SurveyAnswerDto answer : dto.getAnswers()) {
                answer.setResponseId(dto.getResponseId());
                mapper.insertAnswer(answer);
            }
        }
    }

    @Override
    public Map<String, Object> getResult(long surveyId) throws Exception {
        SurveyDto survey = mapper.findById(surveyId);
        int responseCount = mapper.countResponse(surveyId);

        // 질문별 통계 조합
        List<SurveyQuestionDto> questions = mapper.listQuestion(surveyId);
        List<Map<String, Object>> stats = new ArrayList<>();

        for (SurveyQuestionDto q : questions) {
            Map<String, Object> stat = new HashMap<>();
            stat.put("question", q);

            switch (q.getQuestionType()) {
                case "SINGLE":
                case "MULTI":
                    stat.put("options", mapper.statOptionCount(q.getQuestionId()));
                    break;
                case "TEXT":
                    stat.put("textAnswers", mapper.statTextAnswers(q.getQuestionId()));
                    break;
                case "SCORE":
                    stat.put("avgScore", mapper.statScoreAvg(q.getQuestionId()));
                    break;
            }

            stats.add(stat);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("survey", survey);
        result.put("responseCount", responseCount);
        result.put("stats", stats);
        return result;
    }    
}