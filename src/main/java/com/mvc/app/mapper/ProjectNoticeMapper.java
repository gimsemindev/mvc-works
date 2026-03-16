package com.mvc.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.domain.dto.ProjectNoticeFileDto;

@Mapper
public interface ProjectNoticeMapper {

	// ───────────────── 공지 CRUD
	void insertNotice(ProjectNoticeDto dto);
	void updateNotice(ProjectNoticeDto dto);
	void deleteNotice(@Param("noticenum") long noticenum);
	void increaseHit(@Param("noticenum") long noticenum);

	// ───────────────── 목록 / 조회
	List<ProjectNoticeDto> listNotice(Map<String, Object> param);
	int countNotice(Map<String, Object> param);
	ProjectNoticeDto getNotice(@Param("noticenum") long noticenum);
	
	// ───────────────── 내 프로젝트 목록
	List<Map<String, Object>> getMyProjects(@Param("empId") String empId);
	
	// ───────────────── 파일
	void insertFile(ProjectNoticeFileDto dto);
	void deleteFile(@Param("filenum") long filenum);
	List<ProjectNoticeFileDto> getFiles(@Param("noticenum") long noticenum);
	ProjectNoticeFileDto getFile(@Param("filenum") long filenum);
}