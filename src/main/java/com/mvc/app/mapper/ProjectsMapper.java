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
	
	// 프로젝트 생성 시 구성원 인서트
	public void insertProjectMembers(ProjectsDto dto) throws SQLException;
	
	public List<ProjectsDto> projectlist(Map<String, Object> map);
}
