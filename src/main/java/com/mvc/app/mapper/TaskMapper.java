package com.mvc.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.repository.query.Param;

import com.mvc.app.domain.dto.ProjectsDto;

@Mapper
public interface TaskMapper {

	public void insertProjectTask(ProjectsDto dto) throws SQLException;

	public void insertNewStage(ProjectsDto dto) throws SQLException;

	List<ProjectsDto> findStagesByProjectId(long projectId) throws SQLException;

	public void insertEmpTask(ProjectsDto dto) throws SQLException;

	public void updateProjectTask(ProjectsDto dto) throws SQLException;

	public void updateProjectEmp(ProjectsDto dto) throws SQLException;

	public int countEmpTask(String taskId) throws SQLException;

	public void cancelProjectTask(String taskId) throws SQLException;

	public List<ProjectsDto> tasklist(Map<String, Object> map);

	public int taskDataCount(Map<String, Object> map) throws SQLException;

	List<Map<String, Object>> findByEmpId(@Param("empId") String empId);

	public void insertTaskDailylog(ProjectsDto dto) throws SQLException;

	public List<ProjectsDto> taskDailylist(@Param("empTaskId") String empTaskId) throws SQLException;

	public void projectUpdateProgress(long projectId) throws SQLException;

	public void taskUpdateStatus(String taskId) throws SQLException;

	public List<ProjectsDto> myProjectslist(Map<String, Object> map) throws SQLException;

	public int myDataCount(Map<String, Object> map) throws SQLException;

	public void taskAutoDelay() throws SQLException;

	public void projectAutoComplete(long projectId) throws SQLException;

	public void taskForceStopByProject(long projectId) throws SQLException;

	public String findEmpTaskId(String taskId);

	List<ProjectsDto> myTasklist(Map<String, Object> map) throws SQLException;

	int myTaskDataCount(Map<String, Object> map) throws SQLException;
}
