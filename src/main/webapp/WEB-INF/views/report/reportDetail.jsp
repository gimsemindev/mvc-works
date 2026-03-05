<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주간보고서 상세</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css">
<style>
    /* 읽기 전용 Quill - 툴바/테두리 제거 */
    .rp-detail-body .ql-container.ql-snow { border: none; }
    .rp-detail-body .ql-editor { padding: 0; min-height: unset; }
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
            <i class="bi bi-file-earmark-text rp-title-icon"></i>
            <h2>보고서 상세보기</h2>
        </div>

        <!-- 보고서 상세 카드 -->
        <div class="rp-section-card">
            <div class="rp-section-header">
                <h5>
                    <i class="bi bi-file-earmark-text"></i>
                    보고서 내용
                </h5>
                <%-- 피드백 완료 여부 표시 (실제 구현 시 c:choose 처리) --%>
                <span class="rp-result-badge rp-badge-done">
                    <span class="rp-dot"></span> 피드백 완료
                </span>
            </div>
            <div class="rp-section-body">

                <!-- 제목 -->
                <div class="rp-detail-title">
                    2025년 1분기 마케팅 주간보고서
                    <%-- 실제 구현 시: ${dto.subject} --%>
                </div>

                <!-- 메타 정보 -->
                <table class="rp-meta-table">
                    <tbody>
                        <tr>
                            <th>작성자</th>
                            <td>홍길동</td>
                            <th>부서/직책</th>
                            <td>마케팅팀</td>
                        </tr>
                        <tr>
                            <th>사원번호</th>
                            <td>EMP2023001</td>
                            <th>작성일</th>
                            <td>2025.03.07</td>
                        </tr>
                        <tr>
                            <th>보고 기간</th>
                            <td colspan="3">2025년 3월 3일 (월) ~ 2025년 3월 7일 (금)</td>
                        </tr>
                        <tr>
                            <th>조회수</th>
                            <td>24</td>
                            <th>최종 수정일</th>
                            <td>2025.03.07</td>
                        </tr>
                    </tbody>
                </table>

                <!-- 본문 -->
                <div class="rp-detail-body">
                    <%-- 실제 구현 시: <div id="viewer">${dto.content}</div> 후 readOnly Quill 초기화 --%>
                    <p><strong>이번 주 주요 업무</strong></p>
                    <ul>
                        <li>신규 SNS 캠페인 기획안 초안 작성 완료</li>
                        <li>Q1 마케팅 성과 분석 보고서 데이터 취합</li>
                        <li>외부 디자인 업체 미팅 참석 (3/4 화요일)</li>
                    </ul>
                    <br>
                    <p><strong>다음 주 계획</strong></p>
                    <ul>
                        <li>SNS 캠페인 기획안 최종 확정 및 팀장 보고</li>
                        <li>Q2 마케팅 예산 초안 검토</li>
                    </ul>
                </div>

                <!-- 첨부파일 -->
                <div class="rp-attach-area" style="margin-top:14px;">
                    <div class="rp-attach-label">
                        <i class="bi bi-paperclip"></i> 첨부파일
                    </div>
                    <ul class="rp-attach-list">
                        <li>
                            <i class="bi bi-file-earmark-excel"></i>
                            <a href="#">마케팅_성과분석_2025Q1.xlsx</a>
                            <span class="rp-attach-size">(48 KB)</span>
                        </li>
                        <li>
                            <i class="bi bi-file-earmark-image"></i>
                            <a href="#">캠페인_기획안_초안.png</a>
                            <span class="rp-attach-size">(1.2 MB)</span>
                        </li>
                    </ul>
                </div>

                <!-- 관리자 피드백 인라인 -->
                <div class="rp-feedback-inline">
                    <div class="rp-feedback-inline-header">
                        <h6>
                            <i class="bi bi-chat-left-dots-fill"></i>
                            관리자 피드백
                        </h6>
                        <a href="${pageContext.request.contextPath}/report/feedback/detail?filenum=3"
                           class="rp-btn rp-btn-secondary rp-btn-sm">
                            <i class="bi bi-box-arrow-up-right"></i> 전체보기
                        </a>
                    </div>
                    <div class="rp-feedback-inline-body">
                        <%-- 실제 구현 시 feedbackDto.content 출력 / 미작성 시 c:choose 처리 --%>
                        <p>이번 주 보고서 잘 받았습니다. 수치 기반 분석이 인상적이었습니다.</p>
                        <p>다음 주 계획 중 <strong>Q2 예산 검토 시 전년도 집행 내역</strong>을 함께 첨부해 주시면 검토에 도움이 됩니다.</p>
                    </div>
                    <div class="rp-feedback-inline-footer">
                        <span><i class="bi bi-person" style="margin-right:3px;"></i>관리자 (김부장)</span>
                        <span><i class="bi bi-clock" style="margin-right:3px;"></i>2025.03.08</span>
                    </div>
                </div>

                <!-- 하단 액션 버튼 -->
                <div class="rp-detail-actions">
                    <div class="rp-actions-left">
                        <a href="${pageContext.request.contextPath}/report/list"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-list-ul"></i> 목록
                        </a>
                    </div>
                    <div class="rp-actions-right">
                        <%-- 피드백 남기기 (관리자 권한 - 이후 sec:authorize 처리) --%>
                        <a href="${pageContext.request.contextPath}/report/feedback/write?refFilenum=${dto.filenum}"
                           class="rp-btn rp-btn-success" id="btnWriteFeedback">
                            <i class="bi bi-chat-left-dots"></i> 피드백 남기기
                        </a>
                        <%-- 수정/삭제 (본인 권한 - 이후 처리) --%>
                        <a href="${pageContext.request.contextPath}/report/edit?filenum=${dto.filenum}"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-pencil"></i> 수정
                        </a>
                        <button type="button" class="rp-btn rp-btn-danger"
                                onclick="rpConfirmDelete(${dto.filenum})">
                            <i class="bi bi-trash3"></i> 삭제
                        </button>
                    </div>
                </div>

            </div><%-- /rp-section-body --%>
        </div><%-- /rp-section-card --%>

    </div><%-- /rp-main --%>
</div><%-- /rp-content --%>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
function rpConfirmDelete(filenum) {
    if (confirm('이 보고서를 삭제하시겠습니까?\n삭제 후 복구가 불가능합니다.')) {
        location.href = '${pageContext.request.contextPath}/report/delete?filenum=' + filenum;
    }
}
</script>
</body>
</html>
