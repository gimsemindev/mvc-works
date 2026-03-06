package com.mvc.app.service;

import java.util.List;
import java.util.Map;

import com.mvc.app.domain.dto.ProjectsDto;

public interface ProjectService {
	// 프로젝트 생성
	public void createFullProject(ProjectsDto dto, List<Map<String, Object>> members, List<Map<String, Object>> stages) throws Exception;
	
	public List<ProjectsDto> projectslist(Map<String, Object> map) throws Exception;
	
	public List<ProjectsDto> projectslist(String empId) throws Exception;
}
