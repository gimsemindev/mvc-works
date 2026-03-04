package com.mvc.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.common.StorageService;
import com.mvc.app.domain.dto.ApprovalDocDto;
import com.mvc.app.domain.dto.ApprovalFileDto;
import com.mvc.app.domain.dto.ApprovalLineDto;
import com.mvc.app.domain.dto.ApprovalRefDto;
import com.mvc.app.mapper.ApprovalDocMapper;
import java.util.List;
import java.util.Map;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ApprovalDocServiceImpl implements ApprovalDocService {
    private final ApprovalDocMapper mapper;
    private final StorageService storageService;  // 추가

    @Value("${file.upload-root}/approval")
    private String uploadPath;
    
    @Override
    @Transactional
    public void saveDraft(ApprovalDocDto dto, MultipartFile[] files) throws Exception {
        try {
            // 1. 결재 저장
        	if (dto.getDocStatus() == null || dto.getDocStatus().isBlank()) {
        	    dto.setDocStatus("DRAFT");
        	}
            mapper.insertDoc(dto);

            // 2. 결재선 저장
            if (dto.getLines() != null) {
                int order = 1;
                for (ApprovalLineDto line : dto.getLines()) {
                    line.setDocId(dto.getDocId());
                    line.setStepOrder(order++);
                    mapper.insertLine(line);
                }
            }

            // 3. 참조자 저장
            if (dto.getRefs() != null) {
                for (ApprovalRefDto ref : dto.getRefs()) {
                    ref.setDocId(dto.getDocId());
                    mapper.insertRef(ref);
                }
            }

            // 4. 첨부파일 저장
            if (files != null) {
                for (MultipartFile file : files) {
                    if (file.isEmpty()) continue;
                    String saveFilename = storageService.uploadFileToServer(file, uploadPath);
                    ApprovalFileDto fileDto = new ApprovalFileDto();
                    fileDto.setDocId(dto.getDocId());
                    fileDto.setOriFilename(file.getOriginalFilename());
                    fileDto.setSaveFilename(saveFilename);
                    fileDto.setFileSize(file.getSize());
                    mapper.insertFile(fileDto);
                }
            }
        } catch (Exception e) {
            log.info("saveDraft : ", e);
            throw e;
        }
    }
    
    @Override
    public Map<String, Object> listDraft(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countDraft(map);
        List<ApprovalDocDto> list = mapper.listDraft(map);
        return Map.of("totalCount", totalCount, "list", list);
    }
}