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
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvallist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">

    <!-- ── 상단 액션 바 ── -->
    <div class="approval-topbar">
        <!-- 새 결재 작성 -->
        <button class="btn-new-approval" onclick="location.href='${pageContext.request.contextPath}/approval/create'">
            <span class="material-symbols-outlined">edit_square</span>
            새 결재 작성
        </button>

        <!-- 컨트롤 -->
        <div class="topbar-controls">
            <!-- 새로고침 -->
            <button class="btn-refresh" title="새로고침" onclick="location.reload()">
                <span class="material-symbols-outlined">refresh</span>
            </button>

            <!-- 페이지 크기 -->
            <select name="pageSize" id="pageSize">
                <option value="10">10개</option>
                <option value="20" selected>20개</option>
                <option value="50">50개</option>
            </select>

            <!-- 날짜 범위 -->
            <input type="date" id="startDate" name="startDate"
                   value="${not empty param.startDate ? param.startDate : '2025-08-27'}">
            <input type="date" id="endDate" name="endDate"
                   value="${not empty param.endDate ? param.endDate : '2026-02-27'}">

            <!-- 검색어 -->
            <input type="text" id="searchKeyword" name="keyword"
                   placeholder="검색어 입력"
                   value="${not empty param.keyword ? param.keyword : ''}">

            <!-- 검색 버튼 -->
            <button class="btn-search">
                <span class="material-symbols-outlined">search</span>
                검색
            </button>
        </div>

        <!-- 옵션 버튼 -->
        <button class="btn-options">
            <span class="material-symbols-outlined">tune</span>
            옵션
        </button>
    </div>

    <!-- ── 본문 (필터 + 테이블) ── -->
    <div class="approval-body">

        <!-- ── 왼쪽 필터 패널 ── -->
        <div class="filter-panel">

            <!-- Approval Action -->
            <div class="filter-section">
                <div class="filter-label">Approval Action</div>
                <a class="filter-link" href="#">
                    <span class="material-symbols-outlined">mail</span>
                    미결재 문서
                </a>
                <a class="filter-link" href="#">
                    <span class="material-symbols-outlined">mark_email_unread</span>
                    미확인 문서
                </a>
            </div>

            <!-- Approval List -->
            <div class="filter-section">
                <div class="filter-label">Approval List</div>
                <a class="filter-link active" href="#">
                    <span class="material-symbols-outlined">inbox</span>
                    전체 결재함
                </a>
                <a class="filter-link" href="#">
                    <span class="material-symbols-outlined">send</span>
                    보낸 결재함
                </a>
                <a class="filter-link" href="#">
                    <span class="material-symbols-outlined">move_to_inbox</span>
                    받은 결재함
                </a>
                <a class="filter-link" href="#">
                    <span class="material-symbols-outlined">bookmarks</span>
                    참조 결재함
                </a>
            </div>

            <!-- Status Filter -->
            <div class="filter-section">
                <div class="filter-label">Status Filter</div>
                <label class="filter-checkbox-item">
                    <input type="checkbox" name="status" value="임시"> 임시
                </label>
                <label class="filter-checkbox-item">
                    <input type="checkbox" name="status" value="진행"> 진행
                </label>
                <label class="filter-checkbox-item">
                    <input type="checkbox" name="status" value="완료"> 완료
                </label>
                <label class="filter-checkbox-item">
                    <input type="checkbox" name="status" value="반려"> 반려
                </label>
            </div>

        </div>
        <!-- /필터 패널 -->

        <!-- ── 오른쪽 테이블 ── -->
        <div class="table-panel">
            <table class="approval-table">
                <thead>
                    <tr>
                        <th class="cb-col">
                            <input type="checkbox" id="chkAll" title="전체선택">
                        </th>
                        <th>
                            <span class="th-inner">
                                최종 수정일
                                <span class="material-symbols-outlined">unfold_more</span>
                            </span>
                        </th>
                        <th>
                            <span class="th-inner">
                                결재 번호
                                <span class="material-symbols-outlined">unfold_more</span>
                            </span>
                        </th>
                        <th>결재 분류</th>
                        <th>제목</th>
                        <th>
                            <span class="th-inner">
                                작성자
                                <span class="material-symbols-outlined">unfold_more</span>
                            </span>
                        </th>
                        <th>결재 상태</th>
                        <th>결재 대기</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- ────────────────────────────────────────────────────────
                         실제 데이터 연동 시 아래 c:forEach 주석 해제 후 사용
                         <c:forEach var="item" items="${approvalList}">
                         <tr onclick="location.href='${pageContext.request.contextPath}/approval/view/${item.approvalId}'">
                             <td class="cb-col"><input type="checkbox" name="chk" value="${item.approvalId}"></td>
                             <td><fmt:formatDate value="${item.modifiedDate}" pattern="yyyy-MM-dd"/></td>
                             <td>${item.approvalNo}</td>
                             <td>${item.approvalType}</td>
                             <td class="td-title">
                                 ${item.title}
                                 <small>${item.subTitle}</small>
                             </td>
                             <td>${item.writerName} ${item.writerPosition}</td>
                             <td><span class="status-badge status-${item.approvalStatus}">${item.approvalStatus}</span></td>
                             <td>${item.waitCount}</td>
                         </tr>
                         </c:forEach>
                    ──────────────────────────────────────────────────────── --%>

                    <%-- 더미 데이터 (서버 연동 전 UI 확인용) --%>
                    <tr>
                        <td class="cb-col"><input type="checkbox" name="chk"></td>
                        <td>2026-02-27</td>
                        <td>AP260227-019</td>
                        <td>휴가신청서</td>
                        <td class="td-title">
                            [휴가신청서] 개발팀 김세민 260227
                            <small>연차</small>
                        </td>
                        <td>김세민 부장</td>
                        <td><span class="status-badge status-반려">반려</span></td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <td class="cb-col"><input type="checkbox" name="chk"></td>
                        <td>2026-02-27</td>
                        <td>AP260227-018</td>
                        <td>휴가신청서</td>
                        <td class="td-title">
                            [휴가신청서] 경영기획팀 김초원 260227
                            <small>연차</small>
                        </td>
                        <td>김초원 이사</td>
                        <td><span class="status-badge status-반려">반려</span></td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <td class="cb-col"><input type="checkbox" name="chk"></td>
                        <td>2026-02-26</td>
                        <td>AP260226-015</td>
                        <td>지출결의서</td>
                        <td class="td-title">
                            [지출결의서] 경영지원팀 신준안 260226
                            <small>최미나수 선물</small>
                        </td>
                        <td>신준안 대표</td>
                        <td><span class="status-badge status-반려">반려</span></td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <td class="cb-col"><input type="checkbox" name="chk"></td>
                        <td>2026-02-25</td>
                        <td>AP260225-012</td>
                        <td>품의서</td>
                        <td class="td-title">
                            [품의서] IT팀 장민준 260225
                            <small>서버 장비 구입</small>
                        </td>
                        <td>장민준 과장</td>
                        <td><span class="status-badge status-진행">진행</span></td>
                        <td>2</td>
                    </tr>
                    <tr>
                        <td class="cb-col"><input type="checkbox" name="chk"></td>
                        <td>2026-02-24</td>
                        <td>AP260224-009</td>
                        <td>출장신청서</td>
                        <td class="td-title">
                            [출장신청서] 영업팀 이수빈 260224
                            <small>부산 고객사 방문</small>
                        </td>
                        <td>이수빈 대리</td>
                        <td><span class="status-badge status-승인">승인</span></td>
                        <td>-</td>
                    </tr>

                </tbody>
            </table>

            <!-- 페이지네이션 -->
            <div class="table-pagination">
                <button class="page-btn" disabled>&laquo; 처음</button>
                <button class="page-btn" disabled>&lsaquo; 이전</button>
                <button class="page-btn active">1</button>
                <button class="page-btn">다음 &rsaquo;</button>
                <button class="page-btn">마지막 &raquo;</button>
            </div>
        </div>
        <!-- /테이블 -->

    </div>
    <!-- /본문 -->

</main>

</body>
</html>
