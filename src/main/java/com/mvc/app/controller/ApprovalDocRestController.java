package com.mvc.app.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mvc.app.domain.dto.ApprovalDocDto;
import com.mvc.app.domain.dto.SessionInfo;
import com.mvc.app.security.LoginMemberUtil;
import com.mvc.app.service.ApprovalDocService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/approval/doc")
public class ApprovalDocRestController {
    private final ApprovalDocService service;

    // 임시저장
    @PostMapping
    public ResponseEntity<?> saveDraft(@RequestBody ApprovalDocDto dto) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            dto.setWriterEmpId(info.getEmpId());
            dto.setWriterEmpName(info.getName());
            dto.setWriterDeptCode(info.getDeptCode());
            dto.setWriterDeptName(info.getDeptName());
            dto.setWriterGradeCode(info.getGradeCode());
            dto.setWriterGradeName(info.getGradeName());
        	
            log.info("★ deptCode={}, deptName={}, gradeCode={}, gradeName={}",
            	      info.getDeptCode(), info.getDeptName(), info.getGradeCode(), info.getGradeName());
            
            service.saveDraft(dto);
            return ResponseEntity.ok(Map.of("msg", "임시저장 완료"));
        } catch (Exception e) {
            log.info("saveDraft : ", e);
            return ResponseEntity.internalServerError().body(Map.of("msg", "임시저장 실패"));
        }
    }
}