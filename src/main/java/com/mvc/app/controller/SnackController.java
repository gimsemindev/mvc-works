package com.mvc.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/snack")
public class SnackController {

    @GetMapping
    public String snack() {
        return "snack/snack"; // /WEB-INF/views/snack/snack.jsp
    }
}
