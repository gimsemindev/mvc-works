package com.mvc.app.domain.dto;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ApprovalTemplateDto {
    private long tempId;
    private String tempName;
    private String writerEmpId;
    private String regDate;
    private List<ApprovalTemplateLineDto> lines;
}