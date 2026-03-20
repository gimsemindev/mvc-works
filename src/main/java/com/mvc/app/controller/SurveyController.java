package com.mvc.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/survey")
public class SurveyController {

    @GetMapping("/list")
    public String list() {
        return "survey/list";
    }

    @GetMapping("/respond")
    public String respond() {
        return "survey/respond";
    }

    @GetMapping("/result")
    public String result() {
        return "survey/result";
    }
}