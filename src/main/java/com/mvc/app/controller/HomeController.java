package com.mvc.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class HomeController {

    //@GetMapping("/")
	@RequestMapping(value = {"/", ""}, method = {RequestMethod.GET, RequestMethod.POST})
	public String loginForm(@RequestParam(name = "error", required = false) String error, 
			Model model) {
		
		if(error != null) {
			model.addAttribute("message", "아이디 또는 패스워드가 일치하지 않습니다.");
		}
		
		return "member/login2";
	}
    
    @GetMapping("/home")
    public String loginHandleHome(Model model) {
        
    	return "main/home";
    }
}
