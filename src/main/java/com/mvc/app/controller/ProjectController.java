package com.mvc.app.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mvc.app.common.MyUtil;
import com.mvc.app.common.PaginateUtil;
import com.mvc.app.common.StorageService;
import com.mvc.app.domain.dto.ProjectsDto;
import com.mvc.app.service.ProjectService;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/projects/*")
public class ProjectController {
	private final ProjectService service;
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	@GetMapping("list")
	public String projectlist() {
		return "projects/list";
	}
	
	@GetMapping("create")
	public String projectCreate() {
	    return "projects/create";
	}
	
	@PostMapping("create")
	@ResponseBody
	public ResponseEntity<?> createFullProject(@RequestBody ProjectsDto dto, HttpServletRequest req) throws Exception {
		try {
			
			service.createFullProject(dto, dto.getMembers(), dto.getStages());
			return ResponseEntity.ok().build();
			
		} catch (Exception e) {
			log.info("createFullProject : ", e);
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
		}
	}
	
	@GetMapping("article")
	public String projectarticle() {
		return "projects/article";
	}
	
	@GetMapping("gantt")
	public String projectgantt() {
		return "projects/gantt";
	}
	
	@GetMapping("ganttarticle")
	public String projectganttarticle() {
		return "projects/ganttarticle";
	}
	
	@GetMapping("task")
	public String projecttask() {
		return "projects/task";
	}
	
	
	@GetMapping("taskarticle")
	public String projecttaskarticle() {
		return "projects/taskarticle";
	}
}
