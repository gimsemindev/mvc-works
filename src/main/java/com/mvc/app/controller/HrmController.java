package com.mvc.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/hrm/*")
public class HrmController {
	@GetMapping("list")
	public String list(Model model) throws Exception {
		
		return "hrm/employeeList";
	}
}
