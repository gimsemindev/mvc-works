package com.mvc.app.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mvc.app.service.ProjectNoticeService;

@Controller
@RequestMapping("/projects/projectNotice")
public class ProjectNoticeController {

    private final ProjectNoticeService projectNoticeService;

    public ProjectNoticeController(ProjectNoticeService projectNoticeService) {
        this.projectNoticeService = projectNoticeService;
    }

    // 공지사항 리스트 페이지
    @GetMapping("")
    public String list(@AuthenticationPrincipal UserDetails user, Model model) {

        if (user == null) {
            return "redirect:/";
        }

        String empId = user.getUsername();

        // 사용자가 참여 중인 프로젝트 목록
        List<Map<String, Object>> projectList = projectNoticeService.getMyProjects(empId);
        model.addAttribute("projectList", projectList);

        // 전체 공지를 처음에 선택 상태로 보여주기 위해 "all" 값 추가
        model.addAttribute("selectedProjectId", "all");

        return "projects/projectNotice";
    }

    // 공지 등록 폼
    @GetMapping("/projectNoticeForm")
    public String projectNoticeForm(
            @AuthenticationPrincipal UserDetails user,
            Model model,
            @RequestParam(name = "projectid", required = false) String projectid) { // ← 수정

        if (user == null) {
            return "redirect:/";
        }

        String empId = user.getUsername();

        // 참여중인 프로젝트 목록
        List<Map<String, Object>> projectList = projectNoticeService.getMyProjects(empId);
        model.addAttribute("projectList", projectList);

        // 선택 프로젝트 지정
        model.addAttribute("selectedProjectId", projectid);

        return "projects/projectNoticeForm";
    }

    // 공지 상세 페이지
    @GetMapping("/projectNoticeDetail")
    public String detail(
            @AuthenticationPrincipal UserDetails user,
            Model model,
            @RequestParam(name = "noticenum", required = true) Long noticenum) { // ← 수정

        if (user == null) {
            return "redirect:/";
        }

        if (noticenum == null) {
            model.addAttribute("error", "잘못된 접근입니다.");
            return "redirect:/projects/projectNotice";
        }

        // JSP에서 Vue fetch로 상세 데이터를 불러오기 때문에, 최소한 noticenum만 전달
        model.addAttribute("noticenum", noticenum);

        return "projects/projectNoticeDetail";
    }
}