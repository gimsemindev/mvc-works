package com.mvc.app.group.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class ReportDto {

    //report
    private Long   filenum;
    private String subject;          // 제목
    private String content;          // 본문
    private Long   groupnum;         // 그룹 번호
    private int    depth;            // 0=보고서, 1=피드백
    private int    orderno;          // 정렬 순서
    private Long   parent;           // 피드백인 경우 원본 보고서
    private int    hitcount;         // 조회수
    private String regdate;          // 작성일
    private String updatedate;       // 수정일
    private String periodStart;      // 보고 기간 시작
    private String periodEnd;        // 보고 기간 종료
    private String empId;            // 작성자 사원번호
    private String evaluation;       // 인사평가

    //조회 전용
    private String writerName;       // 작성자 이름
    private String deptName;         // 부서명
    private String gradeName;        // 직급명
    private int    feedbackCount;    // 피드백 수

    //원본 보고서 참조
    private String refSubject;       // 원본 보고서 제목
    private String refWriterName;    // 원본 보고서 작성자 이름
    private String refDeptName;      // 원본 보고서 작성자 부서
    private String refPeriodStart;   // 원본 보고서 보고 기간 시작
    private String refPeriodEnd;     // 원본 보고서 보고 기간 종료

    //첨부파일 목록
    private List<ReportFileDto> fileList;

    //검색 파라미터
    private String searchWriterName; // 작성자명 검색
    private String searchSubject;    // 제목 검색
    private String searchPeriodStart;
    private String searchPeriodEnd;
    private String feedbackYn;       // 피드백 여부
    private String searchTargetName; // 피드백 탭, 대상 직원명
    private String searchStartDate;  // 피드백 탭, 작성일 시작
    private String searchEndDate;    // 피드백 탭, 작성일 종료
}
