package com.mvc.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.mvc.app.common.MyUtil;
import com.mvc.app.domain.dto.ProjectsDto;
import com.mvc.app.mapper.ProjectsMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProjectServiceImpl implements ProjectService {
	private final ProjectsMapper mapper;
	private final MyUtil myUtil;
	
	@Override
	public void insertProject(ProjectsDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<ProjectsDto> projectslist(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void insertProjectMembers(ProjectsDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}
	
}
