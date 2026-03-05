<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>피드백 상세보기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css">
<style>
    .rp-detail-body .ql-container.ql-snow { border: none; }
    .rp-detail-body .ql-editor { padding: 0; min-height: unset; }
    /* 피드백 섹션 - 좌측 초록 강조 라인 */
    .rp-section-card.feedback {
        border-left: 4px solid #198754;
    }
    .rp-section-card.feedback .rp-section-header {
        background: #f0fdf4;
        border-bottom-color: #bbf7d0;
    }
    .rp-section-card.feedback .rp-section-header h5 i {
        color: #198754;
    }
</style>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<div class="rp-content">

    <header>
        <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    </header>

    <div class="rp-main">

        <!-- 페이지 타이틀 -->
        <div class="rp-page-title">
            <i class="bi bi-chat-left-dots rp-title-icon" style="color:#198754;"></i>
            <h2>관리자 피드백 상세보기</h2>
        </div>

        <!-- 원본 보고서 참조 카드 -->
        <div class="rp-ref-card">
            <div class="rp-ref-header">
                <h6>
                    <i class="bi bi-file-earmark-text"></i>
                    원본 보고서 (참조)
                </h6>
                <a href="${pageContext.request.contextPath}/report/detail?filenum=${feedbackDto.parent}"
                   class="rp-btn rp-btn-secondary rp-btn-sm">
                    <i class="bi bi-box-arrow-up-right"></i> 원본 보고서 보기
                </a>
            </div>
            <div class="rp-ref-body">
                <%-- 실제 구현 시 refDto 로 출력 --%>
                <div class="rp-ref-item">
                    <strong>보고서 제목</strong> 2025년 1분기 마케팅 주간보고서
                </div>
                <div class="rp-ref-item">
                    <strong>보고자</strong> 홍길동 (마케팅팀)
                </div>
                <div class="rp-ref-item">
                    <strong>보고 기간</strong> 2025.03.03 ~ 2025.03.07
                </div>
            </div>
        </div>

        <!-- 피드백 상세 카드 -->
        <div class="rp-section-card feedback">
            <div class="rp-section-header">
                <h5>
                    <i class="bi bi-chat-left-dots-fill"></i>
                    피드백 내용
                </h5>
                <span class="rp-result-badge rp-badge-feedback">
                    <span class="rp-dot"></span> 관리자 피드백
                </span>
            </div>
            <div class="rp-section-body">

                <!-- 피드백 제목 -->
                <div class="rp-detail-title">
                    홍길동 3/1주차 보고서 피드백
                    <%-- 실제 구현 시: ${feedbackDto.subject} --%>
                </div>

                <!-- 메타 정보 -->
                <table class="rp-meta-table">
                    <tbody>
                        <tr>
                            <th>작성자 (관리자)</th>
                            <td>관리자 (김부장)</td>
                            <th>작성일</th>
                            <td>2025.03.08</td>
                        </tr>
                        <tr>
                            <th>대상 직원</th>
                            <td>홍길동 (EMP2023001)</td>
                            <th>조회수</th>
                            <td>12</td>
                        </tr>
                    </tbody>
                </table>

                <!-- 본문 -->
                <div class="rp-detail-body">
                    <%-- 실제 구현 시: <div id="viewer">${feedbackDto.content}</div> 후 readOnly Quill 초기화 --%>
                    <p>이번 주 보고서 잘 받았습니다. 수치 기반 분석이 인상적이었습니다.</p>
                    <br>
                    <p><strong>✅ 잘된 점</strong></p>
                    <ul>
                        <li>업무 진행 현황이 구체적인 수치와 함께 정리되어 있어 진척도 파악이 용이합니다.</li>
                        <li>이슈 없이 계획대로 진행 중인 점 우수합니다.</li>
                    </ul>
                    <br>
                    <p><strong>💡 개선 제안</strong></p>
                    <ul>
                        <li>Q2 예산 검토 시 <strong>전년도 집행 내역</strong>을 함께 첨부해 주시면 검토에 도움이 됩니다.</li>
                        <li>외부 디자인 업체 미팅 결과 요약도 포함해 주시면 좋겠습니다.</li>
                    </ul>
                    <br>
                    <p>계속 좋은 성과 보여 주세요. 수고하셨습니다.</p>
                </div>

                <!-- 첨부파일 -->
                <div class="rp-attach-area" style="margin-top:14px;">
                    <div class="rp-attach-label">
                        <i class="bi bi-paperclip"></i> 첨부파일
                    </div>
                    <ul class="rp-attach-list">
                        <li>
                            <i class="bi bi-file-earmark-pdf" style="color:#dc3545;"></i>
                            <a href="#">피드백_참고자료.pdf</a>
                            <span class="rp-attach-size">(320 KB)</span>
                        </li>
                    </ul>
                </div>

                <!-- 하단 액션 -->
                <div class="rp-detail-actions">
                    <div class="rp-actions-left">
                        <a href="${pageContext.request.contextPath}/report/list"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-list-ul"></i> 목록
                        </a>
                        <a href="${pageContext.request.contextPath}/report/detail?filenum=${feedbackDto.parent}"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-file-earmark-text"></i> 원본 보고서
                        </a>
                    </div>
                    <div class="rp-actions-right">
                        <%-- 수정/삭제: 관리자 권한 처리 이후 구현 --%>
                        <a href="${pageContext.request.contextPath}/report/feedback/edit?filenum=${feedbackDto.filenum}"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-pencil"></i> 수정
                        </a>
                        <button type="button" class="rp-btn rp-btn-danger"
                                onclick="rpConfirmFeedbackDelete(${feedbackDto.filenum})">
                            <i class="bi bi-trash3"></i> 삭제
                        </button>
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
function rpConfirmFeedbackDelete(filenum) {
    if (confirm('이 피드백을 삭제하시겠습니까?\n삭제 후 복구가 불가능합니다.')) {
        location.href = '${pageContext.request.contextPath}/report/feedback/delete?filenum=' + filenum;
    }
}
</script>

</body>
</html>
