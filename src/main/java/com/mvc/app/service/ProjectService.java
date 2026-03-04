package com.mvc.app.service;

import java.util.List;
import java.util.Map;

import com.mvc.app.domain.dto.ProjectsDto;

public interface ProjectService {
	// 프로젝트 생성
	public void insertProject(ProjectsDto dto) throws Exception;
	
	// 프로젝트 생성 step3 구성원 인서트
	public void insertProjectMembers(ProjectsDto dto) throws Exception;
	
	public List<ProjectsDto> projectslist(Map<String, Object> map);
}
