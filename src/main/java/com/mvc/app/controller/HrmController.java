package com.mvc.app.controller;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.common.MyUtil;
import com.mvc.app.common.StorageService;
import com.mvc.app.domain.dto.EmployeeDto;
import com.mvc.app.domain.dto.SessionInfo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/hrm")
public class HrmController {

    //private final HrmService     hrmService;
    private final StorageService storageService;
    private final MyUtil         myUtil;

    @Value("${file.upload-root}/hrm")
    private String uploadPath;

    // ──────────────────────────────────────────────
    // 직원 목록 조회 (GET /api/hrm)
    // boardRestController.handleList 패턴 동일
    // ──────────────────────────────────────────────
    @GetMapping
    public ResponseEntity<?> handleList(
            @RequestParam(name = "page",     defaultValue = "1")   int currentPage,
            @RequestParam(name = "pageSize", defaultValue = "10")  int size,
            @RequestParam(name = "name",     defaultValue = "")    String name,
            @RequestParam(name = "empNo",    defaultValue = "")    String empNo,
            @RequestParam(name = "project",  defaultValue = "")    String project,
            @RequestParam(name = "status",   defaultValue = "")    String status,
            @RequestParam(name = "role",     defaultValue = "")    String role,
            @RequestParam(name = "pmoY",     defaultValue = "false") boolean pmoY,
            @RequestParam(name = "pmoN",     defaultValue = "false") boolean pmoN,
            @RequestParam(name = "sortCol",  defaultValue = "")    String sortCol,
            @RequestParam(name = "sortDir",  defaultValue = "asc") String sortDir) throws Exception {

        try {
            int totalPage  = 0;
            int totalCount = 0;

            Map<String, Object> map = new HashMap<>();
            map.put("name",    name);
            map.put("empNo",   empNo);
            map.put("project", project);
            map.put("status",  status);
            map.put("role",    role);
            map.put("pmoY",    pmoY);
            map.put("pmoN",    pmoN);
            map.put("sortCol", sortCol);
            map.put("sortDir", "desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");

            //totalCount  = hrmService.dataCount(map);
            if (totalCount != 0) {
                totalPage = totalCount / size + (totalCount % size > 0 ? 1 : 0);
            }

            currentPage = Math.min(currentPage, Math.max(totalPage, 1));

            int offset = Math.max((currentPage - 1) * size, 0);
            map.put("offset", offset);
            map.put("size",   size);

            //List<EmployeeDto> list = hrmService.listEmployee(map);

            return ResponseEntity.ok(Map.of(
                //"list",       list,
                "page",       currentPage,
                "totalPage",  totalPage,
                "totalCount", totalCount
            ));
        } catch (Exception e) {
            log.error("직원 목록 조회 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    /*
    // ──────────────────────────────────────────────
    // 직원 단건 등록 (POST /api/hrm)
    // 신규 행 추가 후 저장 시 사용
    // ──────────────────────────────────────────────
    @PostMapping
    public ResponseEntity<?> handleSave(
            @RequestBody EmployeeDto dto,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            dto.setRegisterId(info.getMember_id());
            hrmService.insertEmployee(dto);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("직원 등록 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // 직원 벌크 수정 (PUT /api/hrm/bulk)
    // 인라인 편집 후 저장 버튼 클릭 시 사용
    // ──────────────────────────────────────────────
    @PutMapping("/bulk")
    public ResponseEntity<?> handleBulkUpdate(
            @RequestBody List<EmployeeDto> dtoList,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            // 관리자(레벨 51 이상) 또는 자신의 데이터만 수정 허용
            for (EmployeeDto dto : dtoList) {
                hrmService.updateEmployee(dto);
            }
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("직원 벌크 수정 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // 직원 선택 삭제 (DELETE /api/hrm)
    // 체크된 행 삭제
    // ──────────────────────────────────────────────
    @DeleteMapping
    public ResponseEntity<?> handleDelete(
            @RequestBody Map<String, List<Long>> body,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            List<Long> ids = body.get("ids");
            if (ids == null || ids.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("삭제할 항목이 없습니다.");
            }

            // 관리자 권한 체크
            if (info.getUserLevel() < 51) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제 권한이 없습니다.");
            }

            hrmService.deleteEmployees(ids);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("직원 삭제 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // 엑셀 다운로드 (GET /api/hrm/excel/download)
    // boardRestController.download 패턴 동일
    // ──────────────────────────────────────────────
    @GetMapping("/excel/download")
    public ResponseEntity<?> excelDownload(
            @RequestParam(name = "name",    defaultValue = "") String name,
            @RequestParam(name = "status",  defaultValue = "") String status,
            @RequestParam(name = "role",    defaultValue = "") String role) throws Exception {

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("name",   name);
            params.put("status", status);
            params.put("role",   role);

            Resource resource = hrmService.exportExcel(params);
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=\"employees.xlsx\"")
                    .header("Content-Type",
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                    .body(resource);
        } catch (Exception e) {
            log.error("엑셀 다운로드 오류", e);
            String redirectUrl = "/error/downloadFailed";
            return ResponseEntity.status(HttpStatus.FOUND)
                    .location(URI.create(redirectUrl)).build();
        }
    }

    // ──────────────────────────────────────────────
    // 엑셀 업로드 (POST /api/hrm/excel/upload)
    // ──────────────────────────────────────────────
    @PostMapping("/excel/upload")
    public ResponseEntity<?> excelUpload(
            @RequestParam("file") MultipartFile file,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            if (info.getUserLevel() < 51) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("업로드 권한이 없습니다.");
            }

            int insertedCount = hrmService.importExcel(file);

            return ResponseEntity.ok(Map.of(
                "message",       "업로드 완료",
                "insertedCount", insertedCount
            ));
        } catch (Exception e) {
            log.error("엑셀 업로드 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    */
}
