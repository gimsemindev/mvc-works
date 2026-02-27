<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<nav class="navbar-custom">
    <div class="navbar-left">
    </div>
    <div class="navbar-right">
        <%-- 알림 버튼 --%>
        <button class="nav-icon-btn position-relative">
            <i class="far fa-bell"></i>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger navbar-badge">5</span>
        </button>

        <%-- 로그인 상태 --%>
        <sec:authorize access="isAuthenticated()">
            <%-- 로그아웃 버튼 --%>
            <a href="${pageContext.request.contextPath}/member/logout" class="nav-icon-btn" title="로그아웃">
                <i class="fas fa-sign-out-alt"></i>
            </a>

            <%-- 아바타 + 드롭다운 메뉴들 --%>
            <sec:authentication property="principal.member.avatar" var="avatar" />
            <div class="dropdown">
                <c:choose>
                    <c:when test="${not empty avatar}">
                        <img src="${pageContext.request.contextPath}/uploads/member/${avatar}"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/avatar.png';"
                             class="navbar-avatar dropdown-toggle" data-bs-toggle="dropdown"
                             aria-expanded="false" title="내 메뉴">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/dist/images/avatar.png"
                             class="navbar-avatar dropdown-toggle" data-bs-toggle="dropdown"
                             aria-expanded="false" title="내 메뉴">
                    </c:otherwise>
                </c:choose>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a href="${pageContext.request.contextPath}/" class="dropdown-item"><i class="fas fa-images me-2"></i>사진첩</a></li>
                    <li><a href="${pageContext.request.contextPath}/" class="dropdown-item"><i class="fas fa-calendar me-2"></i>일정관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/" class="dropdown-item"><i class="fas fa-envelope me-2"></i>쪽지함</a></li>
                    <li><a href="${pageContext.request.contextPath}/" class="dropdown-item"><i class="fas fa-mail-bulk me-2"></i>메일</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a href="${pageContext.request.contextPath}/member/pwd" class="dropdown-item"><i class="fas fa-user-edit me-2"></i>정보수정</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/logout" class="dropdown-item text-danger"><i class="fas fa-sign-out-alt me-2"></i>로그아웃</a></li>
                </ul>
            </div>

        </sec:authorize>
    </div>
</nav>

