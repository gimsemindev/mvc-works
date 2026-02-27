<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>직원관리 - Duralux ERP</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<style>
/* ====================================================
   직원관리 페이지 전용 스타일 (employee-list)
   기존 CSS 변수 및 클래스와 충돌 방지를 위해
   .emp- 접두사 네이밍 사용
   ==================================================== */

/* ---- 레이아웃: 사이드바 + 컨텐츠 ---- */
.emp-wrapper {
    display: flex;
    min-height: 100vh;
}

.emp-content {
    margin-left: 260px; /* sidebar width */
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #f4f7fe;
    min-height: 100vh;
}

/* ---- 헤더 영역 (navbar-custom은 고정이므로 여백 확보) ---- */
.emp-content .navbar-custom {
    margin-left: 0;
}

/* ---- 본문 컨텐츠 영역 ---- */
.emp-main {
    padding: 28px 28px 40px;
    flex: 1;
}

/* ---- 페이지 타이틀 ---- */
.emp-page-title {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
}

.emp-page-title h2 {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--heading-color);
    margin: 0;
}

.emp-page-title .emp-title-icon {
    font-size: 1.4rem;
    color: var(--accent-color);
}

.emp-page-title .emp-help-icon {
    font-size: 0.95rem;
    color: #94a3b8;
    cursor: pointer;
}

/* ---- 검색 필터 카드 ---- */
.emp-filter-card {
    background: #fff;
    border: 1px solid var(--border-color, #eaecf0);
    border-radius: 10px;
    padding: 16px 20px;
    margin-bottom: 16px;
}

.emp-filter-row {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    align-items: flex-end;
}

.emp-filter-group {
    display: flex;
    flex-direction: column;
    gap: 4px;
    min-width: 140px;
}

.emp-filter-group label {
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-gray, #64748b);
    margin-bottom: 0;
    text-transform: uppercase;
    letter-spacing: 0.4px;
}

.emp-filter-group input[type="text"],
.emp-filter-group select {
    font-size: 0.85rem;
    padding: 6px 10px;
    border: 1px solid #d1d9e0;
    border-radius: 6px;
    color: var(--default-color, #333);
    background: #fff;
    transition: border-color 0.2s;
    height: 34px;
}

.emp-filter-group input[type="text"]:focus,
.emp-filter-group select:focus {
    outline: none;
    border-color: var(--accent-color, #106eea);
    box-shadow: 0 0 0 3px rgba(16, 110, 234, 0.08);
}

/* PMO 체크박스 그룹 */
.emp-filter-check-group {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.emp-filter-check-group label.group-label {
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-gray, #64748b);
    text-transform: uppercase;
    letter-spacing: 0.4px;
}

.emp-check-items {
    display: flex;
    align-items: center;
    gap: 12px;
    height: 34px;
}

.emp-check-item {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 0.85rem;
    color: var(--default-color, #333);
    cursor: pointer;
}

.emp-check-item input[type="checkbox"] {
    width: 15px;
    height: 15px;
    accent-color: var(--accent-color, #106eea);
    cursor: pointer;
    margin: 0;
}

/* 검색/초기화 버튼 그룹 */
.emp-filter-btns {
    display: flex;
    align-items: flex-end;
    gap: 6px;
    padding-bottom: 0;
}

.emp-btn {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-size: 0.82rem;
    font-weight: 600;
    padding: 6px 13px;
    border-radius: 6px;
    border: 1px solid transparent;
    cursor: pointer;
    transition: all 0.2s;
    height: 34px;
    white-space: nowrap;
}

.emp-btn i { font-size: 0.8rem; }

.emp-btn-search {
    background: var(--accent-color, #106eea);
    color: #fff;
    border-color: var(--accent-color, #106eea);
}
.emp-btn-search:hover { background: #0058c8; border-color: #0058c8; }

.emp-btn-reset {
    background: #fff;
    color: var(--text-gray, #64748b);
    border-color: #d1d9e0;
}
.emp-btn-reset:hover { border-color: #94a3b8; color: #333; }

/* ---- 테이블 툴바 ---- */
.emp-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.emp-toolbar-left {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.85rem;
    color: var(--text-gray, #64748b);
}

.emp-toolbar-right {
    display: flex;
    align-items: center;
    gap: 6px;
}

/* 버튼 색상 변형 */
.emp-btn-add    { background: #17c964; color: #fff; border-color: #17c964; }
.emp-btn-add:hover { background: #12a955; border-color: #12a955; }

.emp-btn-save   { background: #f5a623; color: #fff; border-color: #f5a623; }
.emp-btn-save:hover { background: #d9911a; border-color: #d9911a; }

.emp-btn-delete { background: #ea4252; color: #fff; border-color: #ea4252; }
.emp-btn-delete:hover { background: #cc2f3e; border-color: #cc2f3e; }

.emp-btn-cancel { background: #fff; color: #64748b; border-color: #d1d9e0; }
.emp-btn-cancel:hover { background: #f1f3f5; border-color: #94a3b8; }

.emp-btn-excel-down { background: #0a7e3f; color: #fff; border-color: #0a7e3f; }
.emp-btn-excel-down:hover { background: #086432; border-color: #086432; }

.emp-btn-excel-up { background: #106eea; color: #fff; border-color: #106eea; }
.emp-btn-excel-up:hover { background: #0058c8; border-color: #0058c8; }

/* ---- 테이블 카드 ---- */
.emp-table-card {
    background: #fff;
    border: 1px solid var(--border-color, #eaecf0);
    border-radius: 10px;
    overflow: hidden;
}

/* ---- 테이블 ---- */
.emp-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.85rem;
}

.emp-table thead tr {
    background: #f8fafc;
    border-bottom: 1px solid var(--border-color, #eaecf0);
}

.emp-table thead th {
    padding: 11px 14px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.4px;
    color: var(--text-gray, #64748b);
    white-space: nowrap;
    vertical-align: middle;
}

.emp-table thead th.sortable {
    cursor: pointer;
    user-select: none;
}

.emp-table thead th.sortable:hover {
    color: var(--accent-color, #106eea);
}

.emp-table thead th .sort-icons {
    display: inline-flex;
    flex-direction: column;
    margin-left: 4px;
    font-size: 0.55rem;
    line-height: 1;
    vertical-align: middle;
    color: #c0c8d2;
}

.emp-table thead th .sort-icons.asc .bi-caret-up-fill,
.emp-table thead th .sort-icons.desc .bi-caret-down-fill {
    color: var(--accent-color, #106eea);
}

.emp-table tbody tr {
    border-bottom: 1px solid var(--border-color, #eaecf0);
    transition: background 0.15s;
}

.emp-table tbody tr:last-child {
    border-bottom: none;
}

.emp-table tbody tr:hover {
    background: #f0f6ff;
}

.emp-table tbody tr.selected {
    background: #eef4ff;
}

.emp-table tbody td {
    padding: 13px 14px;
    color: var(--default-color, #333);
    vertical-align: middle;
}

/* 아바타 */
.emp-avatar {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #e2e8f0;
    margin-right: 8px;
    vertical-align: middle;
}

.emp-avatar-placeholder {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: #e9ecef;
    color: #94a3b8;
    font-size: 1rem;
    margin-right: 8px;
    vertical-align: middle;
    flex-shrink: 0;
}

.emp-name-cell {
    display: flex;
    align-items: center;
}

/* 재직상태 배지 */
.emp-status-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 3px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 600;
    white-space: nowrap;
}

.emp-status-employed  { background: #f0fdf4; color: #166534; }
.emp-status-employed .emp-dot  { background: #22c55e; }

.emp-status-leave     { background: #fffbeb; color: #92400e; }
.emp-status-leave .emp-dot     { background: #f59e0b; }

.emp-status-resigned  { background: #fef2f2; color: #b42318; }
.emp-status-resigned .emp-dot  { background: #ef4444; }

.emp-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    flex-shrink: 0;
}

/* 권한 배지 */
.emp-role-badge {
    display: inline-block;
    padding: 3px 9px;
    border-radius: 6px;
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 0.3px;
    white-space: nowrap;
}

.emp-role-master      { background: #fdf4ff; color: #7c3aed; border: 1px solid #e9d5ff; }
.emp-role-executive   { background: #fff7ed; color: #c2410c; border: 1px solid #fed7aa; }
.emp-role-coordinator { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
.emp-role-participant { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
.emp-role-watcher     { background: #f8fafc; color: #64748b; border: 1px solid #e2e8f0; }

/* PMO 배지 */
.emp-pmo-yes { color: var(--accent-color, #106eea); font-weight: 700; }
.emp-pmo-no  { color: #94a3b8; }

/* 체크박스 컬럼 */
.emp-table th.col-chk,
.emp-table td.col-chk {
    width: 42px;
    text-align: center;
    padding-left: 14px;
    padding-right: 6px;
}

.emp-table input[type="checkbox"] {
    width: 15px;
    height: 15px;
    accent-color: var(--accent-color, #106eea);
    cursor: pointer;
    margin: 0;
}

/* ---- 페이지네이션 ---- */
.emp-pagination {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 18px;
    border-top: 1px solid var(--border-color, #eaecf0);
    background: #fff;
    font-size: 0.82rem;
    color: var(--text-gray, #64748b);
}

.emp-pagination-pages {
    display: flex;
    gap: 4px;
    align-items: center;
}

.emp-page-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 30px;
    height: 30px;
    border-radius: 6px;
    border: 1px solid #e2e8f0;
    background: #fff;
    color: var(--default-color, #333);
    font-size: 0.82rem;
    cursor: pointer;
    transition: all 0.15s;
    text-decoration: none;
}

.emp-page-btn:hover    { border-color: var(--accent-color, #106eea); color: var(--accent-color, #106eea); }
.emp-page-btn.active   { background: var(--accent-color, #106eea); border-color: var(--accent-color, #106eea); color: #fff; }
.emp-page-btn.disabled { pointer-events: none; opacity: 0.4; }

/* ---- 더블클릭 인라인 편집 ---- */

/* 수정 모드 진입한 행 */
.emp-table tbody tr.editing {
    background: #fffbeb !important;
    outline: 2px solid #f5a623;
    outline-offset: -2px;
}

/* 수정된 값이 있는 행 (저장 전 pending 상태) */
.emp-table tbody tr.dirty {
    position: relative;
}
.emp-table tbody tr.dirty td:first-child::before {
    content: '';
    display: block;
    width: 4px;
    height: 100%;
    background: #f5a623;
    position: absolute;
    left: 0;
    top: 0;
    border-radius: 0 2px 2px 0;
}

/* 편집 가능 셀 */
td.emp-editable {
    cursor: pointer;
}

/* 편집 불가 셀 */
td.emp-readonly {
    cursor: default;
    color: var(--default-color, #333);
}

/* 편집 모드의 select */
td.emp-editable .emp-edit-select {
    font-size: 0.82rem;
    width: 100%;
    padding: 4px 6px;
    height: 30px;
    border: 1px solid var(--accent-color, #106eea);
    border-radius: 5px;
    background: #fff;
    color: var(--default-color, #333);
    box-shadow: 0 0 0 3px rgba(16, 110, 234, 0.1);
    cursor: pointer;
    outline: none;
}
td.emp-editable .emp-edit-select:focus {
    border-color: #0050d0;
    box-shadow: 0 0 0 3px rgba(16, 110, 234, 0.18);
}

/* 수정 pending 배지 (행 상태 표시) */
.emp-pending-dot {
    display: inline-block;
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #f5a623;
    margin-left: 5px;
    vertical-align: middle;
    flex-shrink: 0;
}
</style>
</head>
<body>

<div class="emp-wrapper">

    <!-- ===== 사이드바 ===== -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <!-- ===== 메인 콘텐츠 영역 ===== -->
    <div class="emp-content">

        <!-- 상단 네비게이션 바 -->
        <header>
            <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
        </header>

        <!-- 본문 -->
        <div class="emp-main">

            <!-- 페이지 타이틀 -->
            <div class="emp-page-title">
                <i class="bi bi-people-fill emp-title-icon"></i>
                <h2>직원관리</h2>
                <i class="bi bi-question-circle emp-help-icon" title="도움말"></i>
            </div>

            <!-- ===== 검색 필터 카드 ===== -->
            <div class="emp-filter-card">
                <div class="emp-filter-row">

                    <!-- 이름 -->
                    <div class="emp-filter-group">
                        <label>이름</label>
                        <input type="text" id="searchName" name="searchName" placeholder="이름 입력">
                    </div>

                    <!-- 사원번호 -->
                    <div class="emp-filter-group">
                        <label>사원번호</label>
                        <input type="text" id="searchEmpNo" name="searchEmpNo" placeholder="사원번호 입력">
                    </div>

                    <!-- 참여 프로젝트 -->
                    <div class="emp-filter-group" style="min-width:160px;">
                        <label>참여 프로젝트</label>
                        <input type="text" id="searchProject" name="searchProject" placeholder="프로젝트명 입력">
                    </div>

                    <!-- 재직상태 -->
                    <div class="emp-filter-group">
                        <label>재직상태</label>
                        <select id="searchStatus" name="searchStatus">
                            <option value="">전체</option>
                            <option value="EMPLOYED">재직</option>
                            <option value="LEAVE">휴직</option>
                            <option value="RESIGNED">퇴직</option>
                        </select>
                    </div>

                    <!-- 권한레벨 -->
                    <div class="emp-filter-group" style="min-width:150px;">
                        <label>권한레벨</label>
                        <select id="searchRole" name="searchRole">
                            <option value="">전체</option>
                            <option value="MASTER">MASTER</option>
                            <option value="EXECUTIVE">EXECUTIVE</option>
                            <option value="COORDINATOR">COORDINATOR</option>
                            <option value="PARTICIPANT">PARTICIPANT</option>
                            <option value="WATCHER">WATCHER</option>
                        </select>
                    </div>

                    <!-- PMO 체크박스 -->
                    <div class="emp-filter-check-group">
                        <label class="group-label">PMO</label>
                        <div class="emp-check-items">
                            <label class="emp-check-item">
                                <input type="checkbox" id="pmoY" name="pmo" value="Y"> Y
                            </label>
                            <label class="emp-check-item">
                                <input type="checkbox" id="pmoN" name="pmo" value="N"> N
                            </label>
                        </div>
                    </div>

                    <!-- 검색 버튼 -->
                    <div class="emp-filter-btns">
                        <button class="emp-btn emp-btn-search" onclick="doSearch()">
                            <i class="bi bi-search"></i> 검색
                        </button>
                        <button class="emp-btn emp-btn-reset" onclick="doReset()">
                            <i class="bi bi-arrow-counterclockwise"></i> 초기화
                        </button>
                    </div>

                </div>
            </div>
            <!-- /검색 필터 카드 -->

            <!-- ===== 테이블 툴바 ===== -->
            <div class="emp-toolbar">
                <!-- 좌측: 총 건수 -->
                <div class="emp-toolbar-left">
                    전체 <strong class="mx-1" id="totalCount">5</strong>건
                </div>

                <!-- 우측: 액션 버튼 -->
                <div class="emp-toolbar-right">
                    <button class="emp-btn emp-btn-add" onclick="addRow()">
                        <i class="bi bi-plus-lg"></i> 행 추가
                    </button>
                    <button class="emp-btn emp-btn-save" onclick="saveRows()">
                        <i class="bi bi-floppy"></i> 저장
                    </button>
                    <button class="emp-btn emp-btn-delete" onclick="deleteSelected()">
                        <i class="bi bi-trash3"></i> 삭제
                    </button>
                    <button class="emp-btn emp-btn-cancel" onclick="cancelEdit()">
                        <i class="bi bi-x-lg"></i> 취소
                    </button>
                    <button class="emp-btn emp-btn-excel-down" onclick="excelDownload()">
                        <i class="bi bi-file-earmark-arrow-down"></i> 엑셀 다운로드
                    </button>
                    <button class="emp-btn emp-btn-excel-up" onclick="document.getElementById('excelUploadInput').click()">
                        <i class="bi bi-file-earmark-arrow-up"></i> 엑셀 업로드
                    </button>
                    <input type="file" id="excelUploadInput" accept=".xlsx,.xls" style="display:none;" onchange="excelUpload(this)">
                </div>
            </div>

            <!-- ===== 테이블 카드 ===== -->
            <div class="emp-table-card">
                <div style="overflow-x:auto;">
                    <table class="emp-table">
                        <thead>
                            <tr>
                                <!-- 전체 선택 체크박스 -->
                                <th class="col-chk">
                                    <input type="checkbox" id="chkAll" title="전체 선택" onchange="toggleAll(this)">
                                </th>
                                <th>순번</th>
                                <th class="sortable" onclick="sortBy('name')">
                                    이름
                                    <span class="sort-icons">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th class="sortable" onclick="sortBy('empNo')">
                                    사원번호
                                    <span class="sort-icons">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th>참여 프로젝트</th>
                                <th class="sortable" onclick="sortBy('dept')">
                                    부서
                                    <span class="sort-icons">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th class="sortable" onclick="sortBy('rank')">
                                    직급
                                    <span class="sort-icons">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                                <th>권한</th>
                                <th>PMO</th>
                                <th class="sortable" onclick="sortBy('status')">
                                    재직상태
                                    <span class="sort-icons">
                                        <i class="bi bi-caret-up-fill"></i>
                                        <i class="bi bi-caret-down-fill"></i>
                                    </span>
                                </th>
                            </tr>
                        </thead>
                        <tbody id="empTableBody">

                            <%-- ============================================================
                                 아래는 JSTL c:forEach 예시 (실제 데이터 바인딩 시 사용)
                                 ===========================================================
                            <c:forEach var="emp" items="${empList}" varStatus="vs">
                            <tr>
                                <td class="col-chk">
                                    <input type="checkbox" class="row-chk" value="${emp.empId}">
                                </td>
                                <td>${vs.count}</td>
                                <td>
                                    <div class="emp-name-cell">
                                        <c:choose>
                                            <c:when test="${not empty emp.avatar}">
                                                <img src="${pageContext.request.contextPath}/uploads/member/${emp.avatar}"
                                                     class="emp-avatar"
                                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/dist/images/avatar.png';">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>
                                            </c:otherwise>
                                        </c:choose>
                                        ${emp.name}
                                    </div>
                                </td>
                                <td>${emp.empNo}</td>
                                <td>${emp.projectNames}</td>
                                <td>${emp.deptName}</td>
                                <td>${emp.rankName}</td>
                                <td>
                                    <span class="emp-role-badge emp-role-${fn:toLowerCase(emp.role)}">${emp.role}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${emp.pmo eq 'Y'}"><span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span></c:when>
                                        <c:otherwise><span class="emp-pmo-no">N</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${emp.status eq 'EMPLOYED'}">
                                            <span class="emp-status-badge emp-status-employed"><span class="emp-dot"></span>재직</span>
                                        </c:when>
                                        <c:when test="${emp.status eq 'LEAVE'}">
                                            <span class="emp-status-badge emp-status-leave"><span class="emp-dot"></span>휴직</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="emp-status-badge emp-status-resigned"><span class="emp-dot"></span>퇴직</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            ============================================================ --%>

                            <%-- ===== 더미 데이터 (개발 확인용) ===== --%>
                            <%-- 실제 서버 연동 시 아래 data-* 값을 JSTL ${emp.xxx} 로 교체 --%>
                            <tr data-id="1" data-dept="" data-rank="" data-role="MASTER" data-pmo="Y" data-status="EMPLOYED">
                                <td class="col-chk"><input type="checkbox" class="row-chk" value="1"></td>
                                <td>1</td>
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>
                                        김설규
                                    </div>
                                </td>
                                <td class="emp-readonly">EMP-2024-001</td>
                                <td class="emp-readonly">-</td>
                                <td class="emp-editable" data-field="dept">-</td>
                                <td class="emp-editable" data-field="rank">-</td>
                                <td class="emp-editable" data-field="role"><span class="emp-role-badge emp-role-master">MASTER</span></td>
                                <td class="emp-editable" data-field="pmo"><span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span></td>
                                <td class="emp-editable" data-field="status"><span class="emp-status-badge emp-status-employed"><span class="emp-dot"></span>재직</span></td>
                            </tr>
                            <tr data-id="2" data-dept="" data-rank="" data-role="EXECUTIVE" data-pmo="N" data-status="EMPLOYED">
                                <td class="col-chk"><input type="checkbox" class="row-chk" value="2"></td>
                                <td>2</td>
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>
                                        김세문
                                    </div>
                                </td>
                                <td class="emp-readonly">EMP-2024-002</td>
                                <td class="emp-readonly">-</td>
                                <td class="emp-editable" data-field="dept">-</td>
                                <td class="emp-editable" data-field="rank">-</td>
                                <td class="emp-editable" data-field="role"><span class="emp-role-badge emp-role-executive">EXECUTIVE</span></td>
                                <td class="emp-editable" data-field="pmo"><span class="emp-pmo-no">N</span></td>
                                <td class="emp-editable" data-field="status"><span class="emp-status-badge emp-status-employed"><span class="emp-dot"></span>재직</span></td>
                            </tr>
                            <tr data-id="3" data-dept="개발팀" data-rank="부장" data-role="COORDINATOR" data-pmo="Y" data-status="EMPLOYED">
                                <td class="col-chk"><input type="checkbox" class="row-chk" value="3"></td>
                                <td>3</td>
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>
                                        김세민
                                    </div>
                                </td>
                                <td class="emp-readonly">EMP-2024-003</td>
                                <td class="emp-readonly">Alpha 프로젝트, Beta 프로젝트</td>
                                <td class="emp-editable" data-field="dept">개발팀</td>
                                <td class="emp-editable" data-field="rank">부장</td>
                                <td class="emp-editable" data-field="role"><span class="emp-role-badge emp-role-coordinator">COORDINATOR</span></td>
                                <td class="emp-editable" data-field="pmo"><span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span></td>
                                <td class="emp-editable" data-field="status"><span class="emp-status-badge emp-status-employed"><span class="emp-dot"></span>재직</span></td>
                            </tr>
                            <tr data-id="4" data-dept="경영기획팀" data-rank="이사" data-role="PARTICIPANT" data-pmo="N" data-status="LEAVE">
                                <td class="col-chk"><input type="checkbox" class="row-chk" value="4"></td>
                                <td>4</td>
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>
                                        김초원
                                    </div>
                                </td>
                                <td class="emp-readonly">EMP-2024-004</td>
                                <td class="emp-readonly">Beta 프로젝트</td>
                                <td class="emp-editable" data-field="dept">경영기획팀</td>
                                <td class="emp-editable" data-field="rank">이사</td>
                                <td class="emp-editable" data-field="role"><span class="emp-role-badge emp-role-participant">PARTICIPANT</span></td>
                                <td class="emp-editable" data-field="pmo"><span class="emp-pmo-no">N</span></td>
                                <td class="emp-editable" data-field="status"><span class="emp-status-badge emp-status-leave"><span class="emp-dot"></span>휴직</span></td>
                            </tr>
                            <tr data-id="5" data-dept="경영지원팀" data-rank="대표" data-role="MASTER" data-pmo="Y" data-status="EMPLOYED">
                                <td class="col-chk"><input type="checkbox" class="row-chk" value="5"></td>
                                <td>5</td>
                                <td class="emp-readonly">
                                    <div class="emp-name-cell">
                                        <img src="${pageContext.request.contextPath}/dist/images/avatar.png"
                                             class="emp-avatar"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/dist/images/avatar.png';">
                                        신준안
                                    </div>
                                </td>
                                <td class="emp-readonly">EMP-2020-001</td>
                                <td class="emp-readonly">Alpha, Beta, Gamma 프로젝트</td>
                                <td class="emp-editable" data-field="dept">경영지원팀</td>
                                <td class="emp-editable" data-field="rank">대표</td>
                                <td class="emp-editable" data-field="role"><span class="emp-role-badge emp-role-master">MASTER</span></td>
                                <td class="emp-editable" data-field="pmo"><span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span></td>
                                <td class="emp-editable" data-field="status"><span class="emp-status-badge emp-status-employed"><span class="emp-dot"></span>재직</span></td>
                            </tr>

                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션 -->
                <div class="emp-pagination">
                    <div>총 <strong>5</strong>건 / 1 페이지</div>
                    <div class="emp-pagination-pages">
                        <a href="#" class="emp-page-btn disabled"><i class="bi bi-chevron-double-left"></i></a>
                        <a href="#" class="emp-page-btn disabled"><i class="bi bi-chevron-left"></i></a>
                        <a href="#" class="emp-page-btn active">1</a>
                        <a href="#" class="emp-page-btn disabled"><i class="bi bi-chevron-right"></i></a>
                        <a href="#" class="emp-page-btn disabled"><i class="bi bi-chevron-double-right"></i></a>
                    </div>
                </div>

            </div>
            <!-- /테이블 카드 -->

        </div>
        <!-- /emp-main -->

    </div>
    <!-- /emp-content -->

</div>
<!-- /emp-wrapper -->


<%-- JS 템플릿 리터럴의 ${} 가 JSP EL로 파싱되지 않도록 isELIgnored 지시어 대신
     scriptlet으로 JS 코드 시작 전 EL 충돌 방지: 백틱 내부 ${ 는 문자열 연결로 우회 --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
AOS.init();

/* ==========================================================
   핵심 설계:
   - pendingChanges: { rowId → { field → value } }
     더블클릭으로 편집한 값을 행 단위로 누적 저장
     다른 행 더블클릭 시 기존 행 편집값은 유지 (초기화 X)
   - 저장 버튼: pendingChanges 전체를 서버에 전송
   - 취소 버튼: pendingChanges 초기화 + 화면 원복
   ========================================================== */

const pendingChanges = {};  // { rowId: { dept, rank, role, pmo, status, ... } }

/* ----------------------------------------------------------
   select 옵션 정의
---------------------------------------------------------- */
const SELECT_OPTIONS = {
    dept: [
        { value: '',       label: '(없음)' },
        { value: '개발팀',   label: '개발팀' },
        { value: '경영기획팀', label: '경영기획팀' },
        { value: '경영지원팀', label: '경영지원팀' },
        { value: '영업팀',   label: '영업팀' },
        { value: '인사팀',   label: '인사팀' },
        { value: '재무팀',   label: '재무팀' },
    ],
    rank: [
        { value: '',    label: '(없음)' },
        { value: '사원', label: '사원' },
        { value: '대리', label: '대리' },
        { value: '과장', label: '과장' },
        { value: '차장', label: '차장' },
        { value: '부장', label: '부장' },
        { value: '이사', label: '이사' },
        { value: '상무', label: '상무' },
        { value: '전무', label: '전무' },
        { value: '대표', label: '대표' },
    ],
    role: [
        { value: 'MASTER',      label: 'MASTER' },
        { value: 'EXECUTIVE',   label: 'EXECUTIVE' },
        { value: 'COORDINATOR', label: 'COORDINATOR' },
        { value: 'PARTICIPANT', label: 'PARTICIPANT' },
        { value: 'WATCHER',     label: 'WATCHER' },
    ],
    pmo: [
        { value: 'Y', label: 'Y' },
        { value: 'N', label: 'N' },
    ],
    status: [
        { value: 'EMPLOYED', label: '재직' },
        { value: 'LEAVE',    label: '휴직' },
        { value: 'RESIGNED', label: '퇴직' },
    ]
};

/* ----------------------------------------------------------
   현재 편집 중인 행 추적
   (한 번에 한 행만 select 열림 상태)
---------------------------------------------------------- */
let currentEditingRow = null;

/* ----------------------------------------------------------
   행의 현재 값 읽기
   pendingChanges 우선 → data 속성 fallback
---------------------------------------------------------- */
function getRowValue(tr, field) {
    const id = tr.dataset.id;
    if (pendingChanges[id] && pendingChanges[id][field] !== undefined) {
        return pendingChanges[id][field];
    }
    return tr.dataset[field] || '';
}

/* ----------------------------------------------------------
   편집 모드 활성화 (더블클릭 시)
   - 이전에 열려있던 행이 있으면 먼저 닫기 (값 유지)
   - 새 행에 select 렌더링
---------------------------------------------------------- */
function activateRowEdit(tr) {
    // 이미 같은 행이면 아무것도 안 함
    if (currentEditingRow === tr) return;

    // 이전 편집 행이 있으면 닫기 (값은 pendingChanges에 보존)
    if (currentEditingRow && currentEditingRow !== tr) {
        closeRowEdit(currentEditingRow, false);
    }

    currentEditingRow = tr;
    tr.classList.add('editing');

    const editFields = ['dept', 'rank', 'role', 'pmo', 'status'];
    editFields.forEach(field => {
        const td = tr.querySelector('td[data-field="' + field + '"]');
        if (!td) return;

        const currentVal = getRowValue(tr, field);
        const opts = SELECT_OPTIONS[field] || [];

        let optionsHtml = opts.map(function(o) {
            var sel = (o.value === currentVal) ? ' selected' : '';
            return '<option value="' + o.value + '"' + sel + '>' + o.label + '</option>';
        }).join('');

        td.innerHTML = '<select class="emp-edit-select" data-field="' + field + '">' + optionsHtml + '</select>';
    });
}

/* ----------------------------------------------------------
   편집 모드 닫기
   - save=true  → pendingChanges에 저장 + 화면 배지 업데이트
   - save=false → pendingChanges 기존값 유지, 화면만 배지로 복원
---------------------------------------------------------- */
function closeRowEdit(tr, save) {
    if (!tr) return;

    tr.classList.remove('editing');
    const id = tr.dataset.id;

    const editFields = ['dept', 'rank', 'role', 'pmo', 'status'];
    editFields.forEach(field => {
        const td = tr.querySelector('td[data-field="' + field + '"]');
        if (!td) return;

        const sel = td.querySelector('select.emp-edit-select');
        if (sel && save) {
            const newVal = sel.value;
            // pendingChanges에 누적
            if (!pendingChanges[id]) pendingChanges[id] = {};
            pendingChanges[id][field] = newVal;
            // data 속성도 업데이트 (다음번 열기 시 기준값)
            tr.dataset[field] = newVal;
        }

        // 최종 값(pendingChanges 또는 data 속성) 으로 배지 렌더링
        const displayVal = getRowValue(tr, field);
        td.innerHTML = renderCell(field, displayVal);
    });

    // 수정된 내용이 있으면 dirty 마킹
    if (pendingChanges[id] && Object.keys(pendingChanges[id]).length > 0) {
        tr.classList.add('dirty');
    }

    if (currentEditingRow === tr) currentEditingRow = null;
}

/* ----------------------------------------------------------
   필드별 배지 HTML 렌더링
---------------------------------------------------------- */
function renderCell(field, value) {
    switch (field) {
        case 'dept':
            return value || '-';
        case 'rank':
            return value || '-';
        case 'role': {
            var cls = 'emp-role-' + value.toLowerCase();
            return '<span class="emp-role-badge ' + cls + '">' + value + '</span>';
        }
        case 'pmo':
            if (value === 'Y') return `<span class="emp-pmo-yes"><i class="bi bi-check-circle-fill"></i> Y</span>`;
            return `<span class="emp-pmo-no">N</span>`;
        case 'status': {
            var statusMap = {
                EMPLOYED: ['emp-status-employed', '재직'],
                LEAVE:    ['emp-status-leave',    '휴직'],
                RESIGNED: ['emp-status-resigned', '퇴직'],
            };
            var statusInfo = statusMap[value] || ['emp-status-employed', '재직'];
            return '<span class="emp-status-badge ' + statusInfo[0] + '"><span class="emp-dot"></span>' + statusInfo[1] + '</span>';
        }
        default:
            return value || '-';
    }
}

/* ----------------------------------------------------------
   더블클릭 이벤트 위임
   - tbody 전체에 한 번만 등록
   - td.emp-editable 더블클릭 → 해당 행 편집 활성화
   - td.emp-readonly 더블클릭 → 아무 동작 없음
---------------------------------------------------------- */
document.getElementById('empTableBody').addEventListener('dblclick', function(e) {
    const td = e.target.closest('td');
    if (!td) return;

    // select 내부 클릭은 무시 (select 자체 동작 보장)
    if (e.target.tagName === 'SELECT' || e.target.tagName === 'OPTION') return;

    const tr = td.closest('tr');
    if (!tr) return;

    // readonly 셀이면 무시
    if (td.classList.contains('emp-readonly')) return;

    // 편집 가능 셀이면 행 편집 활성화
    if (td.classList.contains('emp-editable')) {
        activateRowEdit(tr);
    }
});

/* ----------------------------------------------------------
   select 변경 즉시 pendingChanges 반영
   (닫히기 전에도 값을 유지하기 위해)
---------------------------------------------------------- */
document.getElementById('empTableBody').addEventListener('change', function(e) {
    const el = e.target;

    // row-chk (행 선택 체크박스) 처리
    if (el.classList.contains('row-chk')) {
        el.closest('tr').classList.toggle('selected', el.checked);
        const all = document.querySelectorAll('.row-chk');
        const checked = document.querySelectorAll('.row-chk:checked');
        document.getElementById('chkAll').checked = (all.length === checked.length);
        document.getElementById('chkAll').indeterminate = (checked.length > 0 && checked.length < all.length);
        return;
    }

    // emp-edit-select 변경 → 즉시 pendingChanges 저장
    if (el.classList.contains('emp-edit-select')) {
        const tr = el.closest('tr');
        const id = tr.dataset.id;
        const field = el.dataset.field;
        if (!pendingChanges[id]) pendingChanges[id] = {};
        pendingChanges[id][field] = el.value;
    }
});

/* ----------------------------------------------------------
   테이블 외부 클릭 시 현재 편집 행 닫기 (값 저장)
---------------------------------------------------------- */
document.addEventListener('mousedown', function(e) {
    if (!currentEditingRow) return;
    // 편집 중인 행 내부 클릭이면 무시
    if (currentEditingRow.contains(e.target)) return;
    closeRowEdit(currentEditingRow, true);
});

/* ----------------------------------------------------------
   전체 선택 / 해제
---------------------------------------------------------- */
function toggleAll(masterChk) {
    document.querySelectorAll('.row-chk').forEach(chk => {
        chk.checked = masterChk.checked;
        chk.closest('tr').classList.toggle('selected', masterChk.checked);
    });
}

/* ----------------------------------------------------------
   검색 / 초기화
---------------------------------------------------------- */
function doSearch() {
    const params = {
        name:    document.getElementById('searchName').value.trim(),
        empNo:   document.getElementById('searchEmpNo').value.trim(),
        project: document.getElementById('searchProject').value.trim(),
        status:  document.getElementById('searchStatus').value,
        role:    document.getElementById('searchRole').value,
        pmoY:    document.getElementById('pmoY').checked,
        pmoN:    document.getElementById('pmoN').checked,
    };
    console.log('검색 파라미터:', params);
    // TODO: fetch('/api/employees?' + new URLSearchParams(params)) ...
    alert('검색 기능은 서버 연동 후 활성화됩니다.');
}

function doReset() {
    document.getElementById('searchName').value    = '';
    document.getElementById('searchEmpNo').value   = '';
    document.getElementById('searchProject').value = '';
    document.getElementById('searchStatus').value  = '';
    document.getElementById('searchRole').value    = '';
    document.getElementById('pmoY').checked        = false;
    document.getElementById('pmoN').checked        = false;
}

/* ----------------------------------------------------------
   저장 버튼
   pendingChanges를 수집하여 서버에 PUT 요청
---------------------------------------------------------- */
function saveRows() {
    // 현재 편집 중인 행이 있으면 먼저 닫기
    if (currentEditingRow) closeRowEdit(currentEditingRow, true);

    const changedIds = Object.keys(pendingChanges);
    if (changedIds.length === 0) {
        alert('변경된 내용이 없습니다.');
        return;
    }

    // 저장할 데이터 구성
    const payload = changedIds.map(id => ({
        empId: id,
        ...pendingChanges[id]
    }));

    console.log('저장 payload:', payload);

    /* TODO: 실제 서버 연동
    fetch('/api/employees/bulk-update', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // pendingChanges 초기화, dirty 클래스 제거
            Object.keys(pendingChanges).forEach(k => delete pendingChanges[k]);
            document.querySelectorAll('tr.dirty').forEach(tr => tr.classList.remove('dirty'));
            alert('저장되었습니다.');
        }
    });
    */

    alert(changedIds.length + '건이 저장 처리됩니다.\n(서버 연동 후 활성화)\n\n변경 내용:\n' + JSON.stringify(payload, null, 2));

    // 임시: pendingChanges 클리어 & dirty 제거 (서버 연동 시 응답 후 처리)
    changedIds.forEach(k => delete pendingChanges[k]);
    document.querySelectorAll('tr.dirty').forEach(tr => tr.classList.remove('dirty'));
}

/* ----------------------------------------------------------
   취소 버튼
   pendingChanges 초기화 + 원본 data 속성값으로 화면 복원
---------------------------------------------------------- */
function cancelEdit() {
    if (!confirm('수정 중인 내용을 모두 취소하시겠습니까?')) return;

    // 현재 편집 행 닫기 (저장 안 함)
    if (currentEditingRow) closeRowEdit(currentEditingRow, false);

    const changedIds = Object.keys(pendingChanges);
    changedIds.forEach(id => {
        const tr = document.querySelector('tr[data-id="' + id + '"]');
        if (!tr) return;

        // data 속성을 원본(서버 최초 로드값)으로 되돌리기
        // → 실제로는 서버 원본을 data-orig-* 에 별도 저장 권장
        //   여기서는 pendingChanges 적용 전 data 값이 남아있으므로 복원
        const fields = pendingChanges[id];
        Object.keys(fields).forEach(field => {
            // data 속성 원복 (현재는 이미 바뀐 상태이므로 서버 재조회 권장)
            const td = tr.querySelector('td[data-field="' + field + '"]');
            if (td) td.innerHTML = renderCell(field, tr.dataset[field] || '');
        });

        delete pendingChanges[id];
        tr.classList.remove('dirty');
    });

    if (changedIds.length === 0) alert('취소할 수정 내용이 없습니다.');
}

/* ----------------------------------------------------------
   행 추가 버튼
   새 행은 처음부터 select 상태로 추가
---------------------------------------------------------- */
function addRow() {
    // 현재 편집 중인 행 닫기
    if (currentEditingRow) closeRowEdit(currentEditingRow, true);

    const tbody = document.getElementById('empTableBody');
    const newId = 'new_' + Date.now();
    const rowCount = tbody.querySelectorAll('tr').length + 1;

    const tr = document.createElement('tr');
    tr.dataset.id = newId;
    tr.dataset.dept   = '';
    tr.dataset.rank   = '';
    tr.dataset.role   = 'PARTICIPANT';
    tr.dataset.pmo    = 'N';
    tr.dataset.status = 'EMPLOYED';
    tr.classList.add('selected');

    tr.innerHTML =
        '<td class="col-chk"><input type="checkbox" class="row-chk" checked></td>' +
        '<td>' + rowCount + '</td>' +
        '<td class="emp-readonly">' +
            '<div class="emp-name-cell">' +
                '<span class="emp-avatar-placeholder"><i class="bi bi-person"></i></span>' +
                '<input type="text" placeholder="이름" style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:80px;background:transparent;">' +
            '</div>' +
        '</td>' +
        '<td class="emp-readonly">' +
            '<input type="text" placeholder="사원번호" style="border:none;border-bottom:1px solid #ccc;outline:none;font-size:0.85rem;width:100px;background:transparent;">' +
        '</td>' +
        '<td class="emp-readonly" style="color:#94a3b8;font-size:0.8rem;">자동 연동</td>' +
        '<td class="emp-editable" data-field="dept">' + renderCell('dept', '') + '</td>' +
        '<td class="emp-editable" data-field="rank">' + renderCell('rank', '') + '</td>' +
        '<td class="emp-editable" data-field="role">' + renderCell('role', 'PARTICIPANT') + '</td>' +
        '<td class="emp-editable" data-field="pmo">'  + renderCell('pmo',  'N')           + '</td>' +
        '<td class="emp-editable" data-field="status">' + renderCell('status', 'EMPLOYED') + '</td>';
    tbody.appendChild(tr);

    // 새 행 자동 편집 활성화
    activateRowEdit(tr);

    // 전체 선택 체크박스 indeterminate
    document.getElementById('chkAll').indeterminate = true;
}

/* ----------------------------------------------------------
   삭제 버튼
---------------------------------------------------------- */
function deleteSelected() {
    const checked = document.querySelectorAll('.row-chk:checked');
    if (checked.length === 0) { alert('삭제할 항목을 선택해 주세요.'); return; }
    if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;

    checked.forEach(chk => {
        const tr = chk.closest('tr');
        const id = tr.dataset.id;
        if (pendingChanges[id]) delete pendingChanges[id];
        if (currentEditingRow === tr) currentEditingRow = null;
        tr.remove();
    });
    document.getElementById('chkAll').checked = false;
    // TODO: 서버에 DELETE 요청
}

/* ----------------------------------------------------------
   엑셀 다운로드 / 업로드
---------------------------------------------------------- */
function excelDownload() {
    alert('엑셀 다운로드 기능은 서버 연동 후 활성화됩니다.');
}

function excelUpload(input) {
    if (!input.files || input.files.length === 0) return;
    const file = input.files[0];
    alert('엑셀 업로드: ' + file.name + '\n서버 연동 후 활성화됩니다.');
    input.value = '';
}

/* ----------------------------------------------------------
   정렬
---------------------------------------------------------- */
function sortBy(col) {
    console.log('정렬 컬럼:', col);
    // TODO: 정렬 파라미터 추가 후 재검색
}
</script>

</body>
</html>
