package com.mvc.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.domain.dto.ProjectNoticeFileDto;

public interface ProjectNoticeService {

	// 공지 CRUD
	public void insertNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception;

	public void updateNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception;

	public void deleteNotice(long noticenum) throws Exception;

	// 목록 / 조회
	public List<ProjectNoticeDto> listNotice(Map<String, Object> param);

	public int countNotice(Map<String, Object> param);

	public ProjectNoticeDto getNotice(long noticenum);

	// 프로젝트 목록
	public List<Map<String, Object>> getMyProjects(String empId);

	// 파일
	public void deleteFile(long filenum) throws Exception;

	public ProjectNoticeFileDto getFile(long filenum);

	public List<ProjectNoticeFileDto> getFiles(long noticenum);

	public boolean isManager(String empId, long projectid);

	public List<Map<String, Object>> getMyPmProjects(String empId);
}