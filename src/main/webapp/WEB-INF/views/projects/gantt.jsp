<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectmain.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectgantt.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=arrow_forward_ios" />
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

	<main id="main-content">
        <div aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item text-muted">Projects</li>
                <li class="breadcrumb-item text-muted">Home</li>
                <li class="breadcrumb-item active fw-bold">Projects List</li>
            </ol>
        </div>
        
        <div class="toolbar">
            <div class="search-group">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="검색어를 입력하세요...">
            </div>
            <button class="btn-search">검색</button>
            <button class="btn-icon btn-add"><i class="fas fa-plus"></i></button>
            <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
            <button class="btn-icon btn-delete"><i class="fas fa-trash-alt"></i></button>
            <button class="btn-icon btn-refresh"><i class="fas fa-sync-alt"></i></button>
        </div>

        <div class="table-wrapper">
            <table class="project-table">
                <thead>
                    <tr>
                        <th width="60" class="text-center">No.</th>
                        <th>프로젝트 명칭</th>
                        <th width="120" class="text-center">시작일</th>
                        <th width="120" class="text-center">종료일</th>
                        <th width="160" class="text-center">잔여/전체</th>
                        <th width="300">진척도</th>
                        <th width="150">담당 매니저</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="text-center">1</td>
                        <td class="project-name">Duralux ERP 시스템 고도화</td>
                        <td class="text-center">2024.01.01</td>
                        <td class="text-center">2024.06.30</td>
                        <td class="text-center">92 / 182 일</td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="progress-container flex-grow-1">
                                    <div class="progress-bar" style="width: 65%;"></div>
                                </div>
                                <span class="progress-text">65%</span>
                            </div>
                        </td>
                        <td>
                            <div class="manager-info">
                                <i class="fas fa-user-circle text-muted"></i> 김팀장
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-center">2</td>
                        <td class="project-name">신규 고객사 온보딩 모듈 개발</td>
                        <td class="text-center">2024.02.15</td>
                        <td class="text-center">2024.04.10</td>
                        <td class="text-center">15 / 55 일</td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="progress-container flex-grow-1">
                                    <div class="progress-bar" style="width: 85%; background-color: #10b981;"></div>
                                </div>
                                <span class="progress-text">85%</span>
                            </div>
                        </td>
                        <td>
                            <div class="manager-info">
                                <i class="fas fa-user-circle text-muted"></i> 박과장
                            </div>
                        </td>
                    </tr>
					

                </tbody>
            </table>
        </div>
								    <div class="pagination-area">
        <div>Showing 1 to 4 of 24 entries</div>
        <div class="pagination">
            <div class="page-item"><i class="fas fa-step-backward fa-xs"></i></div>
            <div class="page-item"><i class="fas fa-chevron-left fa-xs"></i></div>
            <div class="page-item active">1</div>
            <div class="page-item">2</div>
            <div class="page-item">3</div>
            <div class="page-item"><i class="fas fa-chevron-right fa-xs"></i></div>
            <div class="page-item"><i class="fas fa-step-forward fa-xs"></i></div>
        </div>
    </div>
    </main>


</body>
</html>