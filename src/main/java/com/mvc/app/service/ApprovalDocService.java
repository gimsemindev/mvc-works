package com.mvc.app.service;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ApprovalDocDto;

public interface ApprovalDocService {
	public void saveDraft(ApprovalDocDto dto, MultipartFile[] files) throws Exception;
	public Map<String, Object> listDraft(Map<String, Object> map) throws Exception;
	public Map<String, Object> listSent(Map<String, Object> map) throws Exception;
	public Map<String, Object> listInbox(Map<String, Object> map) throws Exception;
	public Map<String, Object> listRef(Map<String, Object> map) throws Exception;
    public Map<String, Object> listAll(Map<String, Object> map) throws Exception;
    public ApprovalDocDto getDoc(long docId) throws Exception;
    
}

