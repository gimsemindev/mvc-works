package com.mvc.app.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mvc.app.domain.dto.ProjectNoticeDto;
import com.mvc.app.domain.dto.ProjectNoticeFileDto;
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

	// 매니저 프로젝트 목록 (공지 등록용)
	@GetMapping("/myprojects/pm")
	public ResponseEntity<?> myPmProjects(@AuthenticationPrincipal UserDetails user) {
		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		String empId = user.getUsername();
		List<Map<String, Object>> list = service.getMyPmProjects(empId);

		return ResponseEntity.ok(list);
	}

	// 공지 목록 (전체/프로젝트별)
	@GetMapping("/list")
	public ResponseEntity<?> list(@RequestParam(value = "projectid", required = false) Long projectid, // null이면 전체
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@AuthenticationPrincipal UserDetails user) {
		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		String empId = user.getUsername();
		int pageSize = 10;
		int offset = (page - 1) * pageSize;

		Map<String, Object> param = new HashMap<>();
		param.put("projectid", projectid); // null이면 전체 공지
		param.put("keyword", keyword);
		param.put("offset", offset);
		param.put("pageSize", pageSize);

		List<ProjectNoticeDto> list = service.listNotice(param);
		int total = service.countNotice(param);

		// 전체 공지일 경우 isManager = false
		boolean isManager = (projectid != null) ? service.isManager(empId, projectid) : false;

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

	// 공지 상세
	@GetMapping("/detail")
	public ResponseEntity<?> detail(@RequestParam("noticenum") long noticenum,
			@AuthenticationPrincipal UserDetails user) {
		if (user == null)
			return ResponseEntity.status(401).body("로그인 필요");

		ProjectNoticeDto dto = service.getNoticeDetail(noticenum);
		if (dto == null)
			return ResponseEntity.status(404).body("공지 없음");

		return ResponseEntity.ok(dto);
	}

	// 파일 다운로드
	@GetMapping("/file/{filenum}")
	public ResponseEntity<?> downloadFile(@PathVariable("filenum") long filenum) {
		try {
			ProjectNoticeFileDto file = service.getFile(filenum);
			if (file == null)
				return ResponseEntity.notFound().build();

			File f = new File(uploadRoot, file.getSavefilename());
			if (!f.exists())
				return ResponseEntity.notFound().build();

			Resource resource = new FileSystemResource(f);
			String encodedName = URLEncoder.encode(file.getOriginalfilename(), "UTF-8").replaceAll("\\+", "%20");

			return ResponseEntity.ok()
					.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"")
					.contentLength(f.length()).contentType(MediaType.APPLICATION_OCTET_STREAM).body(resource);

		} catch (Exception e) {
			log.error("file download error", e);
			return ResponseEntity.status(500).body("파일 다운로드 실패");
		}
	}
}