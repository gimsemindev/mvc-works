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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectarticle.css" type="text/css">
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
        <div class="card-header-project">
            <h1 class="project-title">Duralux || CRM Applications & Admin Dashboard</h1>
            
            <div class="team-section">
                <div class="team-label">
                    <i class="fas fa-palette"></i> Design Team
                </div>
                <div class="member-list">
                    <div class="member-chip">
                        <img src="https://i.pravatar.cc/150?u=a" class="member-avatar"> Alice Cooper
                    </div>
                    <div class="member-chip">
                        <img src="https://i.pravatar.cc/150?u=b" class="member-avatar"> Bob Dylan
                    </div>
                </div>
            </div>

            <div class="team-section">
                <div class="team-label">
                    <i class="fas fa-code"></i> Development Team
                </div>
                <div class="member-list">
                    <div class="member-chip">
                        <img src="https://i.pravatar.cc/150?u=c" class="member-avatar"> Sarah Jenkins
                    </div>
                    <div class="member-chip">
                        <img src="https://i.pravatar.cc/150?u=d" class="member-avatar"> Mike Ross
                    </div>
                </div>
            </div>
        </div>

        <div class="card-progress">
            <div class="progress-header">
                <div class="progress-label">Projects in Progress <i class="fas fa-link ms-1 fa-xs"></i></div>
                <div class="progress-stats text-muted">16/25 Tasks Completed <span class="text-dark">(78%)</span></div>
            </div>
            <div class="progress">
                <div class="progress-bar" role="progressbar" style="width: 78%;" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
        </div>

        <div class="bottom-grid">
            <div class="card-details">
                <div class="details-title text-primary">
                    <i class="fas fa-info-circle"></i> Project Details
                </div>
                
                <div class="info-group">
                    <span class="info-label">Project Manager</span>
                    <div class="manager-info">
                        <img src="https://i.pravatar.cc/150?u=mgr" class="manager-avatar">
                        <div>
                            <div class="manager-name">Alex Rivers</div>
                            <div class="manager-email">alex.rivers@duralux.com</div>
                        </div>
                    </div>
                </div>

                <div class="info-group mb-0">
                    <span class="info-label">Project Description</span>
                    <p class="description-text">
                        This project focuses on building a modern CRM application integrated with a comprehensive admin dashboard. 
                        Key features include client management, automated reporting, task scheduling, and real-time activity tracking. 
                        The design priority is high usability for non-technical administrators while maintaining robust backend performance for data-heavy operations.
                    </p>
                </div>
            </div>

            <div class="action-grid">
                <div class="action-card">
                    <div class="action-icon"><i class="far fa-calendar-alt"></i></div>
                    <span class="action-label">Start Date</span>
                    <span class="action-value">2023-02-25</span>
                </div>
                <div class="action-card">
                    <div class="action-icon text-warning"><i class="far fa-calendar-check"></i></div>
                    <span class="action-label">End Date</span>
                    <span class="action-value">2023-03-20</span>
                </div>
                <div class="action-card">
                    <div class="action-icon text-success"><i class="fas fa-calendar-day"></i></div>
                    <span class="action-label">Schedule</span>
                    <span class="action-value">Go to Calendar</span>
                </div>
                <div class="action-card">
                    <div class="action-icon text-dark"><i class="fas fa-tasks"></i></div>
                    <span class="action-label">Workflow</span>
                    <span class="action-value">Go to Tasks</span>
                </div>
            </div>
        </div>
    </main>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
