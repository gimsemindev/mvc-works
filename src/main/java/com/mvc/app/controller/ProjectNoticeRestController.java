package com.mvc.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.service.ProjectNoticeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/projectnotice")
@RequiredArgsConstructor
public class ProjectNoticeRestController {

	private final ProjectNoticeService service;

	@Value("${file.upload-root}")
	private String uploadRoot;

	// 참여중인 프로젝트 목록
	@GetMapping("/myprojects")
	public ResponseEntity<?> myProjects(@AuthenticationPrincipal UserDetails user) {

		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		String empId = user.getUsername();

		List<Map<String, Object>> list = service.getMyProjects(empId);

		return ResponseEntity.ok(list);
	}

	// 공지 목록
	@GetMapping("/list")
	public ResponseEntity<?> list(@RequestParam("projectid") long projectid,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@AuthenticationPrincipal UserDetails user) {

		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		String empId = user.getUsername();

		int pageSize = 10;
		int offset = (page - 1) * pageSize;

		Map<String, Object> param = new HashMap<>();
		param.put("projectid", projectid);
		param.put("keyword", keyword);
		param.put("offset", offset);
		param.put("pageSize", pageSize);

		List<ProjectNoticeDto> list = service.listNotice(param);
		int total = service.countNotice(param);

		boolean isManager = service.isManager(empId, projectid);

		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("total", total);
		result.put("page", page);
		result.put("pageSize", pageSize);
		result.put("isManager", isManager);

		return ResponseEntity.ok(result);
	}

	// 공지 등록
	@PostMapping
	public ResponseEntity<?> insert(@RequestParam("projectid") long projectid, @RequestParam("subject") String subject,
			@RequestParam("content") String content, @RequestParam(value = "isnotice", defaultValue = "0") int isnotice,
			@RequestParam(value = "files", required = false) List<MultipartFile> files,
			@AuthenticationPrincipal UserDetails user) {

		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		String empId = user.getUsername();

		// 매니저 권한 체크
		if (!service.isManager(empId, projectid))
			return ResponseEntity.status(403).body("권한 없음");

		try {

			ProjectNoticeDto dto = new ProjectNoticeDto();
			dto.setProjectid(projectid);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setIsnotice(isnotice);
			dto.setAuthorempid(empId);

			service.insertNotice(dto, files);

			return ResponseEntity.ok("등록 완료");

		} catch (Exception e) {
			log.error("insertNotice", e);
			return ResponseEntity.status(500).body("등록 실패");
		}
	}
}