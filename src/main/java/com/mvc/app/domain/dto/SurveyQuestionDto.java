package com.mvc.app.domain.dto;

import java.util.List;
import lombok.Data;

@Data
public class SurveyQuestionDto {
    private long questionId;
    private long surveyId;
    private String questionText;
    private String questionType;
    private int sortOrder;
    private List<SurveyOptionDto> options;
}