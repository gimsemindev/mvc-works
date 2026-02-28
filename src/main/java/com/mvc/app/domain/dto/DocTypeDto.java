package com.mvc.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class DocTypeDto {
    private long docTypeId;      // 문서유형ID (PK)
    private String typeName;     // 유형명 (예: 휴가신청서)
    private String typeCode;     // 유형코드 (DOC-001 자동생성)
    private String description;  // 설명 (예: 연차, 병가 등 각종 휴가 사용 시 제출)
    private int sortOrder;       // 정렬순서
    private String useYn;        // 사용여부 (Y/N)
    private String regEmpId;     // 등록자 사원번호
    private String regDate;      // 등록일
}
