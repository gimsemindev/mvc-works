package com.mvc.app.service;

import com.mvc.app.domain.dto.ApprovalDocDto;

public interface ApprovalDocService {
    public void saveDraft(ApprovalDocDto dto) throws Exception;
}