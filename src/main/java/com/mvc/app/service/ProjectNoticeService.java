package com.mvc.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.domain.dto.ProjectNoticeFileDto;

public interface ProjectNoticeService {

	// 공지 CRUD
	void insertNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception;

	void updateNotice(ProjectNoticeDto dto, List<MultipartFile> files) throws Exception;

	void deleteNotice(long noticenum) throws Exception;

	// 목록 / 조회
	List<ProjectNoticeDto> listNotice(Map<String, Object> param);

	int countNotice(Map<String, Object> param);

	ProjectNoticeDto getNotice(long noticenum);

	// 프로젝트 목록
	List<Map<String, Object>> getMyProjects(String empId);

	// 파일
	void deleteFile(long filenum) throws Exception;

	ProjectNoticeFileDto getFile(long filenum);

	List<ProjectNoticeFileDto> getFiles(long noticenum);

	boolean isManager(String empId, long projectid);
}