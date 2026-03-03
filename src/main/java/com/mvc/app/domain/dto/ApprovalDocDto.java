package com.mvc.app.domain.dto;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ApprovalDocDto {
    private long docId;
    private long docTypeId;
    private String title;
    private String content;
    private String detailData;      // 세부양식 JSON 문자열
    private String docStatus;       // DRAFT, PENDING, APPROVED, REJECTED
    private String writerEmpId;
    private String writerEmpName;
    private String writerDeptCode;
    private String writerDeptName;
    private String writerGradeCode;
    private String writerGradeName;
    private String regDate;

    // 결재선 + 참조자
    private List<ApprovalLineDto> lines;
    private List<ApprovalRefDto> refs;
}