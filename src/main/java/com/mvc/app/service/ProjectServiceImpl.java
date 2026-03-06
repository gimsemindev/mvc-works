package com.mvc.app.service;

import java.util.HashMap;
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
	public void createFullProject(ProjectsDto dto, List<Map<String, Object>> members, List<Map<String, Object>> stages) throws Exception {
		// 프로젝트 생성
		try {
			
			// 프로젝트
			mapper.insertProject(dto);
			long project = dto.getProjectId();
			
			// 구성원
			if (members != null && !members.isEmpty()) {
				Map<String, Object> memberParam = new HashMap<>();
				memberParam.put("projectId", project);
				memberParam.put("members", members);
				mapper.insertProjectMembers(memberParam);
			}

			if (stages != null && !stages.isEmpty()) {
				Map<String, Object> stage = new HashMap<>();
				stage.put("projectId", project);
				stage.put("stages", stages);
				mapper.insertProjectStep(stage);
			}
			
		} catch (Exception e) {
			log.info("createFullProject : ", e);
			throw e;
		}
		
	}


	@Override
	public List<ProjectsDto> projectslist(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public List<ProjectsDto> projectslist(String empId) throws Exception {
		try {
			return mapper.findProjectsByEmpId(empId);
		} catch (Exception e) {
			log.info("projectslist : ", e);
			throw e;
		}
	}
}
