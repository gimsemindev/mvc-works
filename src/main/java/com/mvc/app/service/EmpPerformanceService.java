package com.mvc.app.service;

import com.mvc.app.domain.dto.EmpPerformanceDto;

import java.util.List;
import java.util.Map;

public interface EmpPerformanceService {

    //전체 건수
    int dataCount(Map<String, Object> params);

    //직원 목록
    List<EmpPerformanceDto> listEmpPerformance(Map<String, Object> params);

    //empId 기준 소속 프로젝트 목록

    List<Map<String, Object>> listMyProjects(String empId);

    //재직상태 공통코드 목록 (codeGroup = 'EMPSTATUS')

    List<Map<String, Object>> listEmpStatusCodes();

    //해당 직원의 보고서가 존재하는 연도 목록

    List<Integer> listEvalYears(String empId);

    //연도별 월 주차 평가 데이터
    List<EmpPerformanceDto> listEvalGrid(Map<String, Object> params);
}
