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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectlist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=arrow_forward_ios" />
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item text-muted">Projects</li>
                <li class="breadcrumb-item text-muted">Home</li>
                <li class="breadcrumb-item active fw-bold">Projects List</li>
            </ol>
        </nav>

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card shadow-sm">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="fas fa-list-check"></i></div>
                        <span class="stat-trend bg-success bg-opacity-10 text-success">+12%</span>
                    </div>
                    <div class="stat-label">Total Projects</div>
                    <div class="stat-value">128</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card shadow-sm">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="fas fa-clock"></i></div>
                        <span class="stat-trend bg-light text-muted">Stable</span>
                    </div>
                    <div class="stat-label">Active Projects</div>
                    <div class="stat-value">45</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card shadow-sm">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="fas fa-check-circle"></i></div>
                        <span class="stat-trend bg-success bg-opacity-10 text-success">+5</span>
                    </div>
                    <div class="stat-label">Finished</div>
                    <div class="stat-value">73</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger"><i class="fas fa-exclamation-triangle"></i></div>
                        <span class="stat-trend bg-danger bg-opacity-10 text-danger">+2</span>
                    </div>
                    <div class="stat-label">Delayed</div>
                    <div class="stat-value">10</div>
                </div>
            </div>
        </div>

        <div class="project-container">
            <div class="table-header">
                <h5 class="mb-0 fw-bold">Project List</h5>
					 <div class="d-flex gap-2 align-items-center">
					    <div class="search-box">
					        <i class="fas fa-search"></i>
					        <input type="text" class="form-control" placeholder="Search project...">
					    </div>
					    
					    <div class="dropdown">
					        <button id="myFilterBtn" class="btn btn-filter" type="button">
					            <i class="fas fa-filter"></i>
					        </button>
					    <ul id=myFilterMenu class="dropdown-menu">
					        <li><h6 class="dropdown-header fw-bold">Status</h6></li>
					        <li><a class="dropdown-item"><span class="status-badge badge-inprogress"><span class="status-dot"></span>진행중</span></a></li>
					        <li><a class="dropdown-item"><span class="status-badge badge-pending"><span class="status-dot"></span>승인대기</span></a></li>
					        <li><a class="dropdown-item"><span class="status-badge badge-stop"><span class="status-dot"></span>중단</span></a></li>
					        <li><a class="dropdown-item"><span class="status-badge badge-finished"><span class="status-dot"></span>종료</span></a></li>
					        <li><a class="dropdown-item"><span class="status-badge badge-delayed"><span class="status-dot"></span>지연</span></a></li>
					    </ul>
					</div>
					
					<button class="btn btn-create" >+</button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th width="40"><input type="checkbox" class="form-check-input"></th>
                            <th>프로젝트</th>
                            <th>매니저</th>
                            <th>시작일</th>
                            <th>종료일</th>
                            <th>책임자</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">AI Research Initiative</td>
                            <td><img src="https://i.pravatar.cc/150?u=1" class="avatar"> Alex Miller</td>
                            <td>Nov 15, 2023</td>
                            <td>Jan 30, 2024</td>
                            <td><span class="member-badge">Sarah P.</span></td>
                            <td><span class="status-badge badge-inprogress"><span class="status-dot"></span>진행중</span></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">BI Research Initiative</td>
                            <td><img src="https://i.pravatar.cc/150?u=1" class="avatar"> Alex Miller</td>
                            <td>Nov 15, 2023</td>
                            <td>Jan 30, 2024</td>
                            <td><span class="member-badge">Sarah P.</span></td>
                            <td><span class="status-badge badge-inprogress"><span class="status-dot"></span>진행중</span></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">Website Redesign</td>
                            <td><img src="https://i.pravatar.cc/150?u=2" class="avatar"> Lucas White</td>
                            <td>Oct 28, 2023</td>
                            <td>Dec 20, 2023</td>
                            <td><span class="member-badge">Emily B.</span></td>
                            <td><span class="status-badge badge-pending"><span class="status-dot"></span>승인 대기</span></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">Cloud Migration Phase 1</td>
                            <td><img src="https://i.pravatar.cc/150?u=3" class="avatar"> Jessica Davis</td>
                            <td>Aug 12, 2023</td>
                            <td>Oct 15, 2023</td>
                            <td><span class="member-badge">David R.</span></td>
                            <td><span class="status-badge badge-finished"><span class="status-dot"></span>종료</span></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">Data Security Audit</td>
                            <td><img src="https://i.pravatar.cc/150?u=5" class="avatar"> Michael Thompson</td>
                            <td>Oct 01, 2023</td>
                            <td>Dec 15, 2023</td>
                            <td><span class="member-badge">Alice V.</span></td>
                            <td><span class="status-badge badge-stop"><span class="status-dot"></span>중단</span></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="form-check-input"></td>
                            <td class="fw-medium">New Customer Portal</td>
                            <td><img src="https://i.pravatar.cc/150?u=6" class="avatar"> Karen Brown</td>
                            <td>Jan 02, 2024</td>
                            <td>Mar 30, 2024</td>
                            <td><span class="member-badge">Tom S.</span></td>
                            <td><span class="status-badge badge-delayed"><span class="status-dot"></span>지연</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-center py-4 border-top">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item disabled"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">...</a></li>
                        <li class="page-item"><a class="page-link" href="#">12</a></li>
                        <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </main>


<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-box input');
    const filterBtn = document.getElementById('myFilterBtn');
    const filterMenu = document.getElementById('myFilterMenu');
    const filterItems = filterMenu.querySelectorAll('.dropdown-item');
    const tableRows = document.querySelectorAll('tbody tr');

    let currentStatus = "";


    function applyFilters() {
        const searchTerm = searchInput.value.toLowerCase().trim();

        tableRows.forEach(row => {
            const projectName = row.cells[1].textContent.toLowerCase();
            const rowStatusClean = row.cells[6].textContent.replace(/\s/g, "").trim();
            const selectedStatusClean = currentStatus.replace(/\s/g, "").trim();

            const matchesSearch = projectName.includes(searchTerm);
            const matchesStatus = (currentStatus === "") || rowStatusClean.includes(selectedStatusClean);

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }


    searchInput.addEventListener('input', applyFilters);

    if (filterBtn && filterMenu) {
        filterBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            filterMenu.classList.toggle('show');
        });

        document.addEventListener('click', function(e) {
            if (!filterBtn.contains(e.target) && !filterMenu.contains(e.target)) {
                filterMenu.classList.remove('show');
            }
        });
    }

    filterItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            

            currentStatus = this.querySelector('.status-badge').innerText.trim();
            
            applyFilters();
            filterMenu.classList.remove('show');
            filterBtn.style.color = "#4e73df"; 
        });
    });
});
</script>

</body>
</html>