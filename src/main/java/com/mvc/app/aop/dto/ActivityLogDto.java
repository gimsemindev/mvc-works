package com.mvc.app.aop.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ActivityLogDto {

    private String actorEmpId;      // 작업 수행자 사원번호
    private String actorName;       // 작업 수행자 이름

    private String actionType;      // 작업 유형
    private String targetMenu;      // 작업 메뉴

    private String targetEmpIds;    // 대상 사원번호

    private String beforeData;      // 변경 전 JSON
    private String afterData;       // 변경 후 JSON

    private String result;          // "SUCCESS" / "FAIL"
    private String errorMsg;        // 실패 시 오류 메시지

    private String ipAddr;          // 접속 IP
}
