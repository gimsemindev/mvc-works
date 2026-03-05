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
import java.util.HashMap;
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
            // 편집 모드: 기존 DRAFT 삭제
            if (dto.getOldDocId() > 0) {
                mapper.deleteFiles(dto.getOldDocId());
                mapper.deleteRefs(dto.getOldDocId());
                mapper.deleteLines(dto.getOldDocId());
                mapper.deleteDoc(dto.getOldDocId());
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
    
    @Override
    public Map<String, Object> listSent(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countSent(map);
        List<ApprovalDocDto> list = mapper.listSent(map);
        return Map.of("totalCount", totalCount, "list", list);
    }

    @Override
    public Map<String, Object> listInbox(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countInbox(map);
        List<ApprovalDocDto> list = mapper.listInbox(map);
        return Map.of("totalCount", totalCount, "list", list);
    }
    
    @Override
    public Map<String, Object> listRef(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countRef(map);
        List<ApprovalDocDto> list = mapper.listRef(map);
        return Map.of("totalCount", totalCount, "list", list);
    }

    @Override
    public Map<String, Object> listAll(Map<String, Object> map) throws Exception {
        int totalCount = mapper.countAll(map);
        List<ApprovalDocDto> list = mapper.listAll(map);
        return Map.of("totalCount", totalCount, "list", list);
    }
    
    @Override
    public ApprovalDocDto getDoc(long docId) throws Exception {
        ApprovalDocDto doc = mapper.getDoc(docId);
        if (doc != null) {
            doc.setLines(mapper.getLines(docId));
            doc.setFiles(mapper.getFiles(docId));
            doc.setRefs(mapper.getRefs(docId));
        }
        return doc;
    }

    @Override
    public boolean cancelDoc(long docId, String empId) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("docId", docId);
        map.put("empId", empId);
        int cnt = mapper.cancelDoc(map);
        return cnt > 0;
    }
}