package com.mvc.app.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    public ResponseEntity<?> saveDraft(
            @RequestPart("data") ApprovalDocDto dto,
            @RequestPart(value = "files", required = false) MultipartFile[] files) {
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
            
            service.saveDraft(dto, files);
            return ResponseEntity.ok(Map.of("msg", "임시저장 완료"));
        } catch (Exception e) {
            log.info("saveDraft : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "임시저장 실패"));
        }
    }
    
    @GetMapping
    public ResponseEntity<?> listDraft(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            @RequestParam(name = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(name = "pageSize", defaultValue = "20") int pageSize) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            Map<String, Object> map = new HashMap<>();
            map.put("empId", info.getEmpId());
            map.put("keyword", keyword);
            map.put("startDate", startDate);
            map.put("endDate", endDate);
            map.put("pageSize", pageSize);
            map.put("offset", (pageNo - 1) * pageSize);

            Map<String, Object> result = service.listDraft(map);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.info("listDraft : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "목록 조회 실패"));
        }
    }
    
    // 보낸 결재함
    @GetMapping("/sent")
    public ResponseEntity<?> listSent(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            @RequestParam(name = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(name = "pageSize", defaultValue = "20") int pageSize) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            Map<String, Object> map = new HashMap<>();
            map.put("empId", info.getEmpId());
            map.put("keyword", keyword);
            map.put("startDate", startDate);
            map.put("endDate", endDate);
            map.put("pageSize", pageSize);
            map.put("offset", (pageNo - 1) * pageSize);
            return ResponseEntity.ok(service.listSent(map));
        } catch (Exception e) {
            log.info("listSent : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "목록 조회 실패"));
        }
    }

    // 받은 결재함
    @GetMapping("/inbox")
    public ResponseEntity<?> listInbox(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            @RequestParam(name = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(name = "pageSize", defaultValue = "20") int pageSize) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            Map<String, Object> map = new HashMap<>();
            map.put("empId", info.getEmpId());
            map.put("keyword", keyword);
            map.put("startDate", startDate);
            map.put("endDate", endDate);
            map.put("pageSize", pageSize);
            map.put("offset", (pageNo - 1) * pageSize);
            return ResponseEntity.ok(service.listInbox(map));
        } catch (Exception e) {
            log.info("listInbox : ", e);
            return ResponseEntity.badRequest().body(Map.of("msg", "목록 조회 실패"));
        }
    }
    
    @GetMapping("/ref")
    public ResponseEntity<?> listRef(
            @RequestParam(name = "keyword",   required = false) String keyword,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate",   required = false) String endDate,
            @RequestParam(name = "pageNo",    defaultValue = "1")  int pageNo,
            @RequestParam(name = "pageSize",  defaultValue = "20") int pageSize) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            Map<String, Object> map = new HashMap<>();
            map.put("empId",     info.getEmpId());
            map.put("keyword",   keyword);
            map.put("startDate", startDate);
            map.put("endDate",   endDate);
            map.put("pageSize",  pageSize);
            map.put("offset",    (pageNo - 1) * pageSize);
            return ResponseEntity.ok(service.listRef(map));
        } catch (Exception e) {
            log.info("listRef : ", e);
            return ResponseEntity.internalServerError().body(Map.of("msg", "목록 조회 실패"));
        }
    }

    @GetMapping("/all")
    public ResponseEntity<?> listAll(
            @RequestParam(name = "keyword",   required = false) String keyword,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate",   required = false) String endDate,
            @RequestParam(name = "pageNo",    defaultValue = "1")  int pageNo,
            @RequestParam(name = "pageSize",  defaultValue = "20") int pageSize) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            Map<String, Object> map = new HashMap<>();
            map.put("empId",     info.getEmpId());
            map.put("keyword",   keyword);
            map.put("startDate", startDate);
            map.put("endDate",   endDate);
            map.put("pageSize",  pageSize);
            map.put("offset",    (pageNo - 1) * pageSize);
            return ResponseEntity.ok(service.listAll(map));
        } catch (Exception e) {
            log.info("listAll : ", e);
            return ResponseEntity.internalServerError().body(Map.of("msg", "목록 조회 실패"));
        }
    }

}