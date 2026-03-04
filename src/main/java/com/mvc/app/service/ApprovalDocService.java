package com.mvc.app.service;

import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ApprovalDocDto;

public interface ApprovalDocService {
	public void saveDraft(ApprovalDocDto dto, MultipartFile[] files) throws Exception;
}