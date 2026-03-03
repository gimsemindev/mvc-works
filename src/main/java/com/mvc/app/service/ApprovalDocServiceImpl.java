package com.mvc.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mvc.app.domain.dto.ApprovalDocDto;
import com.mvc.app.domain.dto.ApprovalLineDto;
import com.mvc.app.domain.dto.ApprovalRefDto;
import com.mvc.app.mapper.ApprovalDocMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ApprovalDocServiceImpl implements ApprovalDocService {
    private final ApprovalDocMapper mapper;

    @Override
    @Transactional
    public void saveDraft(ApprovalDocDto dto) throws Exception {
        try {
            // 1. 기안서 저장 (selectKey로 docId 자동 세팅)
            dto.setDocStatus("DRAFT");
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
        } catch (Exception e) {
            log.info("saveDraft : ", e);
            throw e;
        }
    }
}