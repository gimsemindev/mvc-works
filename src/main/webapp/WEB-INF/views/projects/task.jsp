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
                <input type="text" placeholder="태스크 검색...">
            </div>
            <button class="btn-search">Search</button>
            <button class="btn-icon btn-add"><i class="fas fa-plus"></i></button>
            <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
            <button class="btn-icon btn-delete"><i class="fas fa-trash-alt"></i></button>
            <button class="btn-icon btn-refresh"><i class="fas fa-sync-alt"></i></button>
        </div>

        <div class="gantt-wrapper gantt-scroll-area">
            <div class="task-list">
                <table class="gantt-table">
                    <thead>
                        <tr>
                            <th width="50">NO</th>
                            <th>TASK NAME</th>
                            <th width="100">START</th>
                            <th width="100">END</th>
                            <th width="60">DUR</th>
                            <th width="120">MEMBERS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td class="fw-bold">UI/UX 설계 및 프로토타입</td>
                            <td>06-01</td>
                            <td>06-05</td>
                            <td>5d</td>
                            <td>
                                <div class="member-info">
                                    <img src="https://i.pravatar.cc/150?u=1" class="avatar-sm"> Alice
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td class="fw-bold">API Gateway 고도화</td>
                            <td>06-04</td>
                            <td>06-12</td>
                            <td>9d</td>
                            <td>
                                <div class="member-info">
                                    <img src="https://i.pravatar.cc/150?u=2" class="avatar-sm"> Bob
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="chart-area">
                <div class="grid-container">
                    <script>
                        for (let i = 1; i <= 30; i++) {
                            document.write(`<div class="grid-header-cell">${i}</div>`);
                        }
                    </script>

                    <div class="grid-cell">
                        <div class="task-bar" style="width: 175px; left: 0;"></div>
                    </div>
                    <script>
                        for (let i = 2; i <= 30; i++) document.write('<div class="grid-cell"></div>');
                    </script>

                    <div class="grid-cell"></div>
                    <div class="grid-cell"></div>
                    <div class="grid-cell"></div>
                    <div class="grid-cell">
                        <div class="task-bar" style="width: 315px; left: 0; background-color: var(--primary-amber);"></div>
                    </div>
                    <script>
                        for (let i = 5; i <= 30; i++) document.write('<div class="grid-cell"></div>');
                    </script>
                </div>
            </div>
        </div>
    </main>

</body>
</html>