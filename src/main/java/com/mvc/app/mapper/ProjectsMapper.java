package com.mvc.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.mvc.app.domain.dto.ProjectsDto;

@Mapper
public interface ProjectsMapper {
	// 프로젝트 생성
	public void insertProject(ProjectsDto dto) throws SQLException;
	// 프로젝트 생성 시 구성원 조성 및 역할부여
	public void insertProjectMembers(Map<String, Object> member) throws SQLException;
	// 프로젝트 단계 설정
	public void insertProjectStep(Map<String, Object> stage) throws SQLException;
	
	public void insertProjectTask(ProjectsDto dto) throws SQLException;
	
	
	public List<ProjectsDto> projectlist(Map<String, Object> map);
}
