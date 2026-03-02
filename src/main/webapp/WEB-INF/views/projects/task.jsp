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

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projecttask.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=arrow_forward_ios" />
    
    <style>
        :root {
            --gt-sidebar-width: 240px;
            --gt-primary-blue: #4e73df;
            --gt-primary-amber: #f59e0b;
            --gt-primary-red: #ef4444;
            --gt-bg-light: #f8f9fc;
            --gt-border-color: #eaecf0;
            --gt-text-dark: #1d2939;
            --gt-text-muted: #667085;
            --gt-row-height: 52px;
            --gt-cell-width: 35px;
        }

        #main-content-gt {
            padding: 24px 40px;
            background-color: var(--gt-bg-light);
        }

        .gt-toolbar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }

        .gt-search-group {
            display: flex;
            align-items: center;
            border: 1px solid var(--gt-border-color);
            border-radius: 8px;
            padding: 0 12px;
            background: #fff;
            width: 280px;
        }

        .gt-search-group input {
            border: none;
            padding: 8px 0;
            font-size: 0.9rem;
            outline: none;
            width: 100%;
        }

        .gt-search-group i {
            color: var(--gt-text-muted);
            margin-right: 8px;
        }

        .gt-btn-search {
            background-color: #344054;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .gt-btn-icon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .gt-btn-add { background-color: var(--gt-primary-blue); }
        .gt-btn-edit { background-color: var(--gt-primary-amber); }
        .gt-btn-delete { background-color: var(--gt-primary-red); }
        .gt-btn-refresh {
            background-color: #fff;
            border: 1px solid var(--gt-border-color);
            color: var(--gt-text-muted);
        }

        .gt-wrapper {
            display: flex;
            border: 1px solid var(--gt-border-color);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            width: 100%;
        }

        .gt-task-list-side {
            width: 650px;
            flex-shrink: 0;
            border-right: 1px solid var(--gt-border-color);
            background-color: #fff;
        }

        .gt-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .gt-table th, .gt-table td {
            border-right: 1px solid var(--gt-border-color);
            border-bottom: 1px solid var(--gt-border-color);
            height: var(--gt-row-height);
            padding: 0 10px;
            font-size: 0.85rem;
            vertical-align: middle;
        }

        .gt-table th {
            background-color: #f9fafb;
            font-weight: 700;
            color: var(--gt-text-muted);
            text-align: center;
        }

        .gt-chart-area {
            flex-grow: 1;
            overflow-x: auto;
            position: relative;
        }

        .gt-grid-container {
            display: grid;
            grid-template-columns: repeat(31, var(--gt-cell-width));
        }

        .gt-grid-header-cell {
            height: 52px;
            background-color: #f9fafb;
            border-right: 1px solid var(--gt-border-color);
            border-bottom: 1px solid var(--gt-border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gt-text-dark);
            font-weight: 700;
            font-size: 0.8rem;
        }

        .gt-grid-cell {
            height: var(--gt-row-height);
            border-right: 1px solid var(--gt-border-color);
            border-bottom: 1px solid var(--gt-border-color);
            position: relative;
        }

        .gt-task-bar {
            position: absolute;
            top: 14px;
            height: 24px;
            background-color: var(--gt-primary-blue);
            border-radius: 4px;
            z-index: 10;
        }

        .gt-avatar-sm { width: 24px; height: 24px; border-radius: 50%; margin-right: 5px; }
        .gt-member-info { display: flex; align-items: center; }
        .is-weekend { background-color: #f8fafc; }
        
        /* 기존 .gt-table td 스타일 부분에 추가 */
.gt-table td.gt-task-name {
    cursor: pointer; /* 마우스 포인터를 손가락 모양으로 변경 */
    transition: color 0.2s;
}

.gt-table td.gt-task-name:hover {
    color: var(--gt-primary-blue); /* 마우스 올렸을 때 색상 변화 (선택사항) */
    text-decoration: underline;    /* 밑줄 추가 (선택사항) */
}
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <main id="main-content">
        <div id="main-content-gt">
            <div class="gt-toolbar">
                <div class="gt-search-group">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="태스크 검색...">
                </div>
                <button class="gt-btn-search">Search</button>
                <button class="gt-btn-icon gt-btn-add"><i class="fas fa-plus"></i></button>
                <button class="gt-btn-icon gt-btn-edit"><i class="fas fa-pencil-alt"></i></button>
                <button class="gt-btn-icon gt-btn-delete"><i class="fas fa-trash-alt"></i></button>
                <button class="gt-btn-icon gt-btn-refresh"><i class="fas fa-sync-alt"></i></button>
            </div>

            <div class="gt-wrapper">
                <div class="gt-task-list-side">
                    <table class="gt-table">
                        <thead>
                            <tr>
                                <th width="50">NO</th>
                                <th>TASK NAME</th>
                                <th width="80">START</th>
                                <th width="80">END</th>
                                <th width="50">DUR</th>
                                <th width="120">MEMBERS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center">1</td>
                                <td class="fw-bold gt-task-name" onclick="location.href='${pageContext.request.contextPath}/projects/taskarticle'">UI/UX 설계 및 프로토타입</td>
                                <td class="text-center">06-01</td>
                                <td class="text-center">06-05</td>
                                <td class="text-center">5d</td>
                                <td>
                                    <div class="gt-member-info">
                                        <img src="https://i.pravatar.cc/150?u=1" class="gt-avatar-sm"> Alice
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">2</td>
                                <td class="fw-bold">API Gateway 고도화</td>
                                <td class="text-center">06-04</td>
                                <td class="text-center">06-12</td>
                                <td class="text-center">9d</td>
                                <td>
                                    <div class="gt-member-info">
                                        <img src="https://i.pravatar.cc/150?u=2" class="gt-avatar-sm"> Bob
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="gt-chart-area">
                    <div class="gt-grid-container">
                        <script>
                            for (let i = 1; i <= 31; i++) {
                                const isWeekend = (i % 7 === 6 || i % 7 === 0) ? 'is-weekend' : '';
                                document.write(`<div class="gt-grid-header-cell ${isWeekend}">${i}</div>`);
                            }
                        </script>
                        
                        <div class="gt-grid-cell">
                            <div class="gt-task-bar" style="width: calc(var(--gt-cell-width) * 5); left: 0;"></div>
                        </div>
                        <script>for (let i = 2; i <= 31; i++) document.write('<div class="gt-grid-cell"></div>');</script>

                        <div class="gt-grid-cell"></div><div class="gt-grid-cell"></div><div class="gt-grid-cell"></div>
                        <div class="gt-grid-cell">
                            <div class="gt-task-bar" style="width: calc(var(--gt-cell-width) * 9); left: 0; background-color: var(--gt-primary-amber);"></div>
                        </div>
                        <script>for (let i = 5; i <= 31; i++) document.write('<div class="gt-grid-cell"></div>');</script>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>