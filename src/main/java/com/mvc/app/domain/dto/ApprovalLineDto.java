package com.mvc.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ApprovalLineDto {
    private long lineId;
    private long docId;
    private int stepOrder;
    private String apprEmpId;
    private String apprEmpName;
    private String apprDeptCode;
    private String apprDeptName;
    private String apprGradeCode;
    private String apprGradeName;
    private String apprTypeCode;    // APPROVER
    private String apprStatus;      // PENDING, APPROVED, REJECTED
}