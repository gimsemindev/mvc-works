<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<aside id="sidebar">
    <div class="sidebar-brand">MVC</div>

    <div class="nav-section">Navigation</div>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> Dashboards</a>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-file-invoice"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-th-large"></i> Applications</a>
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-file-signature"></i> Proposal</a>

    <div class="nav-section">Projects</div>
    <a href="${pageContext.request.contextPath}/project" class="nav-link active"><i class="fas fa-briefcase"></i> Projects</a>
    <ul class="sub-menu">
        <li><a href="${pageContext.request.contextPath}/projects/list" class="active">Projects List</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/list">Projects View</a></li>
        <li><a href="${pageContext.request.contextPath}/projects/create">Projects Create</a></li>
    </ul>

    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-cog"></i> Settings</a>
</aside>
