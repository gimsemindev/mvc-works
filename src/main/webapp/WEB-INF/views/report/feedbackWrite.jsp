<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>피드백 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css">
<style>
    /* 피드백 에디터 - 초록 강조 */
    #editor-feedback { height: 340px; }
    .rp-editor-wrap.feedback .rp-editor-label {
        background: #f0fdf4;
        color: #166534;
        border-bottom-color: #bbf7d0;
    }
    .rp-editor-wrap.feedback .rp-editor-label i { color: #198754; }
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
            <h2>관리자 피드백 작성</h2>
        </div>

        <!-- 원본 보고서 참조 카드 -->
        <div class="rp-ref-card">
            <div class="rp-ref-header">
                <h6>
                    <i class="bi bi-file-earmark-text"></i>
                    원본 보고서 (참조)
                </h6>
                <a href="${pageContext.request.contextPath}/report/detail?filenum=${param.refFilenum}"
                   class="rp-btn rp-btn-secondary rp-btn-sm" target="_blank">
                    <i class="bi bi-box-arrow-up-right"></i> 원본 보기
                </a>
            </div>
            <div class="rp-ref-body">
                <%-- 실제 구현 시 refDto 로 출력 --%>
                <div class="rp-ref-item">
                    <strong>제목</strong> 2025년 1분기 마케팅 주간보고서
                </div>
                <div class="rp-ref-item">
                    <strong>작성자</strong> 홍길동 (마케팅팀)
                </div>
                <div class="rp-ref-item">
                    <strong>보고 기간</strong> 2025.03.03 ~ 2025.03.07
                </div>
            </div>
        </div>

        <!-- 피드백 작성 카드 -->
        <div class="rp-section-card">
            <div class="rp-section-header">
                <h5>
                    <i class="bi bi-chat-left-dots" style="color:#198754;"></i>
                    피드백 작성
                </h5>
                <span style="font-size:0.78rem; color:#94a3b8;">
                    <i class="bi bi-info-circle"></i>&nbsp;
                    <span style="color:#dc3545;">*</span> 표시는 필수 입력 항목입니다.
                </span>
            </div>
            <div class="rp-section-body">

                <form id="feedbackWriteForm"
                      action="${pageContext.request.contextPath}/report/feedback/write"
                      method="post" enctype="multipart/form-data">

                    <input type="hidden" name="parent" value="${param.refFilenum}">

                    <table class="rp-form-table">
                        <colgroup>
                            <col style="width:120px;">
                            <col>
                            <col style="width:120px;">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>피드백 제목<span class="rp-required">*</span></th>
                                <td colspan="3">
                                    <input type="text" name="subject" id="feedbackSubject"
                                           placeholder="피드백 제목을 입력하세요"
                                           maxlength="255" required>
                                </td>
                            </tr>
                            <tr>
                                <th>작성자</th>
                                <td>
                                    <input type="text" value="${sessionScope.member.name}" readonly>
                                </td>
                                <th>사원번호</th>
                                <td>
                                    <input type="text" value="${sessionScope.member.empId}" readonly>
                                </td>
                            </tr>
                            <tr>
                                <th>대상 직원</th>
                                <td colspan="3">
                                    <%-- 실제 구현 시 refDto 작성자 정보 출력 --%>
                                    <input type="text" value="홍길동 (EMP2023001 / 마케팅팀)" readonly>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Quill 에디터 -->
                    <div class="rp-editor-wrap feedback">
                        <div class="rp-editor-label">
                            <i class="bi bi-chat-left-dots"></i>
                            피드백 내용<span class="rp-required">*</span>
                        </div>
                        <div id="editor-feedback">${dto.content}</div>
                        <input type="hidden" name="content" id="hiddenFeedbackContent">
                    </div>

                    <!-- 파일 첨부 -->
                    <div class="rp-attach-area">
                        <div class="rp-attach-label">
                            <i class="bi bi-paperclip"></i> 파일 첨부 (선택)
                        </div>
                        <input type="file" name="files" multiple style="font-size:0.85rem;">
                        <div class="rp-attach-hint">
                            <i class="bi bi-info-circle"></i>
                            파일은 최대 10MB, 최대 5개까지 첨부 가능합니다.
                        </div>
                    </div>

                    <!-- 하단 버튼 -->
                    <div class="rp-form-actions">
                        <a href="${pageContext.request.contextPath}/report/detail?filenum=${param.refFilenum}"
                           class="rp-btn rp-btn-secondary">
                            <i class="bi bi-x-lg"></i> 취소
                        </a>
                        <button type="button" class="rp-btn rp-btn-success"
                                onclick="rpSubmitFeedback()">
                            <i class="bi bi-send"></i> 피드백 등록
                        </button>
                    </div>

                </form>

            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<script src="${pageContext.request.contextPath}/dist/posts/qeditor.js"></script>

<script>
var quillFeedback = new Quill('#editor-feedback', {
    theme: 'snow',
    modules: {
        toolbar: [
            [{ 'header': [1, 2, 3, false] }],
            ['bold', 'italic', 'underline', 'strike'],
            [{ 'color': [] }, { 'background': [] }],
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
            [{ 'align': [] }],
            ['link', 'image'],
            ['clean']
        ],
        resize: {}
    },
    placeholder: '직원의 보고서에 대한 피드백을 작성해 주세요.\n(잘된 점 / 개선 제안 / 다음 주 방향 등)'
});

function rpSubmitFeedback() {
    var subject = document.getElementById('feedbackSubject').value.trim();
    if (!subject) {
        alert('피드백 제목을 입력해 주세요.');
        document.getElementById('feedbackSubject').focus();
        return;
    }
    var content = quillFeedback.root.innerHTML;
    if (!content || content === '<p><br></p>') {
        alert('피드백 내용을 입력해 주세요.');
        return;
    }
    document.getElementById('hiddenFeedbackContent').value = content;
    document.getElementById('feedbackWriteForm').submit();
}
</script>

</body>
</html>
