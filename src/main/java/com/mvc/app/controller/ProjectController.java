package com.mvc.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/projects/*")
public class ProjectController {

	@GetMapping("list")
	public String projectlist() {
		return "projects/list";
	}
	
	@GetMapping("create")
	public String projectcreate() {
		return "projects/create";
	}
	
	@GetMapping("article")
	public String projectarticle() {
		return "projects/article";
	}
}
