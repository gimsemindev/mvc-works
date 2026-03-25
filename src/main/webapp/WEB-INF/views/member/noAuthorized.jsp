<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>접근 권한 없음 | Duralux ERP</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<style>
  /* ── 403 전용 오버레이 영역 ── */
  .no-auth-wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: calc(100vh - 64px); /* 헤더(64px) 제외 */
    padding: 40px 20px;
    background: #f4f6f9;
  }

  .no-auth-card {
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
    padding: 56px 52px 48px;
    max-width: 460px;
    width: 100%;
    text-align: center;
    animation: fadeUp 0.45s ease both;
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* 아이콘 원형 배경 */
  .no-auth-icon-wrap {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 90px;
    height: 90px;
    border-radius: 50%;
    background: #fff3f3;
    margin-bottom: 28px;
  }
  .no-auth-icon-wrap i {
    font-size: 40px;
    color: #e53e3e;
    line-height: 1;
  }

  /* 상태 코드 */
  .no-auth-code {
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 2px;
    color: #e53e3e;
    text-transform: uppercase;
    margin-bottom: 10px;
  }

  /* 타이틀 */
  .no-auth-title {
    font-size: 22px;
    font-weight: 700;
    color: #1a1a2e;
    margin-bottom: 12px;
    font-family: var(--heading-font);
  }

  /* 설명 문구 */
  .no-auth-desc {
    font-size: 14px;
    color: #6c757d;
    line-height: 1.75;
    margin-bottom: 36px;
  }
  .no-auth-desc strong {
    color: #444;
  }

  /* 구분선 */
  .no-auth-divider {
    height: 1px;
    background: #f0f0f0;
    margin-bottom: 28px;
  }

  /* 버튼 */
  .no-auth-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    width: 100%;
    padding: 13px 20px;
    border-radius: 10px;
    border: none;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
    text-decoration: none;
  }

  .no-auth-btn-primary {
    background: var(--accent-color, #106eea);
    color: #ffffff !important;
  }
  .no-auth-btn-primary:hover {
    background: color-mix(in srgb, var(--accent-color, #106eea), #000 12%);
    color: #ffffff !important;
    transform: translateY(-1px);
    box-shadow: 0 6px 18px rgba(16, 110, 234, 0.28);
  }

  .no-auth-btn-secondary {
    background: #f4f6f9;
    color: #444 !important;
    margin-top: 10px;
  }
  .no-auth-btn-secondary:hover {
    background: #e8ecf3;
    color: #222 !important;
    transform: translateY(-1px);
  }

  /* 힌트 텍스트 */
  .no-auth-hint {
    font-size: 12px;
    color: #adb5bd;
    margin-top: 20px;
  }

  /* 반응형 */
  @media (max-width: 768px) {
    .no-auth-card {
      padding: 40px 28px 36px;
    }
    .no-auth-title {
      font-size: 20px;
    }
  }
</style>
</head>
<body>

<%-- 헤더 (navbar-custom) --%>
<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<%-- 메인: 사이드바 없이 전체 너비 콘텐츠 --%>
<main>
  <div class="no-auth-wrapper">
    <div class="no-auth-card">

      <%-- 아이콘 --%>
      <div class="no-auth-icon-wrap">
        <i class="bi bi-shield-lock-fill"></i>
      </div>

      <%-- 상태 코드 레이블 --%>
      <p class="no-auth-code">403 Forbidden</p>

      <%-- 타이틀 --%>
      <h2 class="no-auth-title">접근 권한이 없습니다</h2>

      <%-- 설명 --%>
      <p class="no-auth-desc">
        요청하신 페이지에 접근할 수 있는 <strong>권한이 없습니다.</strong><br>
        담당 관리자에게 권한을 요청하거나,<br>
        아래 버튼을 눌러 홈 화면으로 돌아가세요.
      </p>

      <div class="no-auth-divider"></div>

      <%-- 홈으로 이동 버튼 --%>
      <a href="${pageContext.request.contextPath}/home" class="no-auth-btn no-auth-btn-primary">
        <i class="bi bi-house-door-fill"></i>
        홈 화면으로 돌아가기
      </a>

      <%-- 뒤로가기 버튼 --%>
      <button type="button" class="no-auth-btn no-auth-btn-secondary" onclick="history.back()">
        <i class="bi bi-arrow-left"></i>
        이전 페이지로 돌아가기
      </button>

      <%-- 힌트 --%>
      <p class="no-auth-hint">
        문제가 지속되면 시스템 관리자에게 문의하세요.
      </p>

    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
<script>
  if (window.AOS) AOS.init();
</script>
</body>
</html>
