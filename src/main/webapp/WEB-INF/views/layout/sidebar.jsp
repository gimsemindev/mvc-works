<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%-- sidebar 전용 참조 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main-sidebar.css">

<aside id="sidebar">
    <div class="sidebar-brand">MVC</div>

    <div class="nav-section">Navigation</div>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> __Dashboards__</a>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-file-invoice"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> Applications</a>

    <%-- 인사관리 토글 메뉴 --%>
    <a href="#" class="nav-link nav-toggle" id="hrmToggle">
        <i class="fas fa-file-signature"></i> 인사관리
        <i class="fas fa-chevron-down toggle-icon" id="hrmArrow"></i>
    </a>
    <ul class="sub-menu" id="hrmSubMenu">
        <li><a href="${pageContext.request.contextPath}/hrm/list">직원 정보통합 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/hrm/org">직원 조직 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/hrm/performance">직원 성과 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/hrm/records">인사관리 기록</a></li>
    </ul>

    <div class="nav-section">Projects</div>
    <a href="${pageContext.request.contextPath}/project" class="nav-link active"><i class="fas fa-briefcase"></i> Projects</a>
    <ul class="sub-menu">
        <li><a href="${pageContext.request.contextPath}/projects/list" class="active">Projects List</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/list">Projects View</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/create">Projects Create</a></li>
    </ul>

    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-cog"></i> Settings</a>
</aside>

<%-- sidebar 전용 Js --%>
<script src="${pageContext.request.contextPath}/dist/js/main-sidebar.js"></script>
