<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%-- sidebar 전용 참조 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main-sidebar.css">

<aside id="sidebar">
    <div class="sidebar-brand">MVC</div>

    <div class="nav-section">Navigation</div>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> Dashboards</a>
    <%-- 그룹웨어 토글 메뉴 --%>
    <a href="#" class="nav-link nav-toggle" id="groupToggle">
        <i class="fas fa-file-invoice"></i> 그룹웨어
        <i class="fas fa-chevron-down toggle-icon" id="groupArrow"></i>
    </a>
    <ul class="sub-menu" id="groupSubMenu">
        <li><a href="${pageContext.request.contextPath}/">공지사항 - 미구현</a></li>
        <li><a href="${pageContext.request.contextPath}/report/main">주간보고서 - 구현 중</a></li>
        <li><a href="${pageContext.request.contextPath}/">채팅 - 미구현</a></li>
    </ul>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> Applications</a>

    <%-- 인사관리 토글 메뉴 --%>
    <a href="#" class="nav-link nav-toggle" id="hrmToggle">
        <i class="fas fa-file-signature"></i> 인사관리
        <i class="fas fa-chevron-down toggle-icon" id="hrmArrow"></i>
    </a>
    <ul class="sub-menu" id="hrmSubMenu">
        <li><a href="${pageContext.request.contextPath}/hrm">직원 정보통합 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/activity-log">직원 조직 관리 - 미구현</a></li>
        <li><a href="${pageContext.request.contextPath}/activity-log">직원 성과 관리 - 미구현</a></li>
        <li><a href="${pageContext.request.contextPath}/activity-log">인사관리 기록</a></li>
    </ul>
    
    <div class="nav-section">Approval</div>
		<a href="#" class="nav-link nav-toggle" id="approvalToggle">
    		<i class="fas fa-briefcase"></i> 결재관리
    		<i class="fas fa-chevron-down toggle-icon" id="approvalArrow"></i>
		</a>
	<ul class="sub-menu" id="approvalSubMenu">
        <li><a href="${pageContext.request.contextPath}/approval/manage/doctype">문서유형 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/approval/create">결재 상신</a></li>
        <li><a href="${pageContext.request.contextPath}/approval/list">결재 리스트</a></li>
    	<li><a href="${pageContext.request.contextPath}/approval/absence">부재 등록</a></li>
    </ul>    
    <div class="nav-section">Projects</div>
    <a class="nav-link active"><i class="fas fa-briefcase"></i> Projects</a>
    <ul class="sub-menu">
        <li><a href="${pageContext.request.contextPath}/projects/list" class="active">Projects List</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/gantt">Projects Gantt</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/task">Projects Task</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/create">Projects Create</a></li>
    </ul>

    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-cog"></i> Settings</a>
</aside>

<%-- sidebar 전용 Js --%>
<script src="${pageContext.request.contextPath}/dist/js/main-sidebar.js"></script>
