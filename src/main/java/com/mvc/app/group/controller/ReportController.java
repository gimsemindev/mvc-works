package com.mvc.app.group.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/report/*")
public class ReportController {
	@GetMapping("main")
	public String projectlist() {
		return "report/reportMain";
	}
}
