package com.mvc.app.service;

import com.mvc.app.domain.dto.HrmDto;
import com.mvc.app.mapper.HrmMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class HrmServiceImpl implements HrmService {

    private final HrmMapper       mapper;
    private final PasswordEncoder passwordEncoder;   // BCryptPasswordEncoder 빈 주입

    /**
     * 엑셀 컬럼 순서 (다운로드 헤더 / 업로드 파싱 공통)
     * 0:사원번호 1:이름 2:비밀번호 3:부서코드 4:직급코드 5:권한레벨 6:재직상태 7:참여프로젝트
     */
    private static final String[] EXCEL_HEADERS = {
        "사원번호", "이름", "비밀번호(신규)", "부서코드", "직급코드",
        "권한레벨", "재직상태(E/L/R)", "참여프로젝트"
    };

    // ──────────────────────────────────────────────
    // [1] 목록 조회
    // ──────────────────────────────────────────────
    @Override
    public int dataCount(Map<String, Object> params) {
        int result = 0;
        try {
            result = mapper.dataCount(params);
        } catch (Exception e) {
            log.error("dataCount error", e);
        }
        return result;
    }

    @Override
    public List<HrmDto> listEmployee(Map<String, Object> params) {
        List<HrmDto> list = new ArrayList<>();
        try {
            list = mapper.listEmployee(params);
            // 비밀번호 마스킹 (* 8자리 고정)
            list.forEach(e -> e.setPassword("********"));
        } catch (Exception e) {
            log.error("listEmployee error", e);
        }
        return list;
    }

    // ──────────────────────────────────────────────
    // [2] 사원번호 중복 체크
    // ──────────────────────────────────────────────
    @Override
    public boolean isDuplicateEmpId(String empId) {
        try {
            return mapper.findByEmpId(empId) != null;
        } catch (Exception e) {
            log.error("isDuplicateEmpId error", e);
            return false;
        }
    }

    // ──────────────────────────────────────────────
    // [3] 직원 신규 등록
    //   employee1(인증) INSERT → employee2(인적) INSERT
    //   FK 제약 순서 반드시 준수
    // ──────────────────────────────────────────────
    @Override
    @Transactional
    public void insertEmployee(HrmDto dto) throws Exception {
        try {
            // 사원번호 중복 체크
            if (isDuplicateEmpId(dto.getEmpId())) {
                throw new IllegalArgumentException("이미 존재하는 사원번호입니다: " + dto.getEmpId());
            }
            // 비밀번호 BCrypt 암호화
            if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
                dto.setPassword(passwordEncoder.encode(dto.getPassword()));
            } else {
                throw new IllegalArgumentException("비밀번호는 필수입니다.");
            }
            // 기본값 처리
            if (dto.getEnabled()       == null) dto.setEnabled(1);
            if (dto.getEmpStatusCode() == null || dto.getEmpStatusCode().isBlank()) {
                dto.setEmpStatusCode("E");   // 기본: 재직
            }
            if (dto.getLevelCode() == null) dto.setLevelCode(1);

            // INSERT 순서: employee1 먼저 (FK 부모)
            mapper.insertEmployee1(dto);
            mapper.insertEmployee2(dto);

        } catch (Exception e) {
            log.error("insertEmployee error", e);
            throw e;
        }
    }

    // ──────────────────────────────────────────────
    // [4] 단건 수정
    //   - 사원번호(empId)는 절대 변경하지 않음
    //   - 비밀번호가 null / "" / "********" 이면 password 컬럼 수정 안 함
    // ──────────────────────────────────────────────
    @Override
    @Transactional
    public void updateEmployee(HrmDto dto) throws Exception {
        try {
            String pw = dto.getPassword();
            if (pw == null || pw.isBlank() || "********".equals(pw)) {
                dto.setPassword(null);   // XML의 <if test="password != null"> 에 걸려 수정 제외
            } else {
                dto.setPassword(passwordEncoder.encode(pw));
            }
            // employee1(인증정보), employee2(인적정보) 각각 UPDATE
            mapper.updateEmployee1(dto);
            mapper.updateEmployee2(dto);

        } catch (Exception e) {
            log.error("updateEmployee error", e);
            throw e;
        }
    }

    // ──────────────────────────────────────────────
    // [5] 벌크 수정
    // ──────────────────────────────────────────────
    @Override
    @Transactional
    public void updateEmployees(List<HrmDto> dtoList) throws Exception {
        for (HrmDto dto : dtoList) {
            updateEmployee(dto);
        }
    }

    // ──────────────────────────────────────────────
    // [6] 선택 삭제
    //   FK 제약: employee2 먼저 삭제 → employee1 삭제
    // ──────────────────────────────────────────────
    @Override
    @Transactional
    public void deleteEmployees(List<String> ids) throws Exception {
        try {
            mapper.deleteEmployees2(ids);   // 자식 먼저
            mapper.deleteEmployees1(ids);   // 부모 나중
        } catch (Exception e) {
            log.error("deleteEmployees error", e);
            throw e;
        }
    }

    // ──────────────────────────────────────────────
    // [7] 엑셀 다운로드 (Apache POI)
    //   비밀번호 컬럼은 보안상 출력하지 않음
    // ──────────────────────────────────────────────
    @Override
    public Resource exportExcel(Map<String, Object> params) throws Exception {
        // 페이징 없이 전체 조회
        params.put("offset", 0);
        params.put("size", Integer.MAX_VALUE);
        List<HrmDto> list = mapper.listEmployee(params);

        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("직원목록");

            // 헤더 스타일
            CellStyle headerStyle = wb.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            Font hFont = wb.createFont();
            hFont.setBold(true);
            hFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(hFont);

            // 헤더 행 (비밀번호 컬럼 제외한 헤더)
            String[] downloadHeaders = {
                "사원번호", "이름", "부서코드", "직급코드",
                "권한레벨", "재직상태", "입사일", "참여프로젝트"
            };
            Row header = sheet.createRow(0);
            for (int i = 0; i < downloadHeaders.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(downloadHeaders[i]);
                cell.setCellStyle(headerStyle);
                sheet.setColumnWidth(i, 5000);
            }

            // 데이터 행
            int rowNum = 1;
            for (HrmDto dto : list) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(nvl(dto.getEmpId()));
                row.createCell(1).setCellValue(nvl(dto.getName()));
                row.createCell(2).setCellValue(nvl(dto.getDeptCode()));
                row.createCell(3).setCellValue(nvl(dto.getGradeCode()));
                row.createCell(4).setCellValue(dto.getLevelCode() != null
                        ? String.valueOf(dto.getLevelCode()) : "");
                row.createCell(5).setCellValue(statusLabel(dto.getEmpStatusCode()));
                row.createCell(6).setCellValue(nvl(dto.getHireDate()));
                row.createCell(7).setCellValue(nvl(dto.getProjectNames()));
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            wb.write(baos);
            return new ByteArrayResource(baos.toByteArray());
        }
    }

    // ──────────────────────────────────────────────
    // [8] 엑셀 업로드 (Apache POI)
    //   업로드 컬럼 순서 (헤더 행=0, 데이터=1행부터):
    //   0:사원번호 | 1:이름 | 2:비밀번호 | 3:부서코드 | 4:직급코드
    //   5:권한레벨 | 6:재직상태(E/L/R)
    // ──────────────────────────────────────────────
    @Override
    @Transactional
    public int importExcel(MultipartFile file) throws Exception {
        int count = 0;
        try (Workbook wb = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = wb.getSheetAt(0);
            int lastRow = sheet.getLastRowNum();

            for (int i = 1; i <= lastRow; i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String empId = cellStr(row, 0);
                String name  = cellStr(row, 1);
                if (empId.isBlank() || name.isBlank()) continue;   // 필수값 없으면 스킵

                // 중복 사원번호 스킵
                if (isDuplicateEmpId(empId)) {
                    log.warn("엑셀 업로드 - 중복 사원번호 스킵: {}", empId);
                    continue;
                }

                HrmDto dto = new HrmDto();
                dto.setEmpId(empId);
                dto.setName(name);
                dto.setPassword(cellStr(row, 2));                          // 비밀번호
                dto.setDeptCode(cellStr(row, 3));
                dto.setGradeCode(cellStr(row, 4));

                // 권한레벨 (숫자)
                String levelStr = cellStr(row, 5);
                if (!levelStr.isBlank()) {
                    try { dto.setLevelCode(Integer.parseInt(levelStr)); }
                    catch (NumberFormatException ignore) { dto.setLevelCode(1); }
                }

                // 재직상태 (E/L/R)
                dto.setEmpStatusCode(cellStrDefault(row, 6, "E"));

                insertEmployee(dto);
                count++;
            }
        }
        return count;
    }

    // ── 재직상태 코드 → 라벨 변환 ─────────────────────────────
    private String statusLabel(String code) {
        if (code == null) return "";
        return switch (code) {
            case "E" -> "재직";
            case "L" -> "휴직";
            case "R" -> "퇴직";
            default  -> code;
        };
    }

    // ── 내부 유틸 ─────────────────────────────────────────────
    private String nvl(String s) { return s == null ? "" : s; }

    private String cellStr(Row row, int col) {
        Cell cell = row.getCell(col);
        if (cell == null) return "";
        cell.setCellType(CellType.STRING);
        return cell.getStringCellValue().trim();
    }

    private String cellStrDefault(Row row, int col, String defaultVal) {
        String val = cellStr(row, col);
        return val.isBlank() ? defaultVal : val;
    }
}
