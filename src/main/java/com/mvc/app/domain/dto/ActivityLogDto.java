package com.mvc.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ActivityLogDto {

    private Long   logId;

    // 수행자
    private String actorEmpId;      // 작업 수행자 사원번호
    private String actorName;       // 작업 수행자 이름

    // 작업 분류
    private String actionType;      // INSERT / UPDATE / DELETE / BULK_UPDATE / EXCEL_IMPORT
    private String targetMenu;      // 작업 메뉴 구분

    // 대상 직원
    private String targetEmpIds;    // 대상 사원번호

    // 변경 내용
    private String beforeData;      // 변경 전 데이터
    private String afterData;       // 변경 후 데이터

    // 처리 결과
    private String result;          // SUCCESS / FAIL
    private String errorMsg;        // 실패 시 오류 메시지

    // 접속 정보
    private String ipAddr;          // 접속 IP

    // 시간
    private String logDate;         // 로그 기록 시각
}
