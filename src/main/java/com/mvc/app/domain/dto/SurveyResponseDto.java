package com.mvc.app.domain.dto;

import java.util.List;
import lombok.Data;

@Data
public class SurveyResponseDto {
    private long responseId;
    private long surveyId;
    private String empId;
    private String respondedDate;
    private List<SurveyAnswerDto> answers;
}