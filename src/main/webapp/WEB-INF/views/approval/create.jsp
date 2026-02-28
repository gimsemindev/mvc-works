<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/projectlist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvalcreate.css" type="text/css">
<meta name="ctx" content="${pageContext.request.contextPath}">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">


    <!-- 페이지 타이틀 + 문서 타이틀 한 줄 -->
    <div class="page-header">
        <span class="material-symbols-outlined">forward_to_inbox</span>
        <span class="page-header-label">전자결재</span>
        <span class="page-header-divider">›</span>
        <span class="page-header-doc" id="formDocTitle"></span>
    </div>

    <!-- 결재양식 선택 모달 -->
    <div class="modal-overlay" id="formSelectModal">
        <div class="modal-box">
            <div class="modal-header">
                <div class="modal-breadcrumb">전자 결재 &gt; <span>등록</span></div>
                <div class="modal-header-btns">
                    <button title="전체화면"><span class="material-symbols-outlined" style="font-size:18px">open_in_full</span></button>
                    <button title="닫기" onclick="closeModal()"><span class="material-symbols-outlined" style="font-size:18px">close</span></button>
                </div>
            </div>
            <div class="modal-body">
                <div class="modal-section-title">
                    <span class="material-symbols-outlined">description</span>
                    결재양식 선택
                </div>
                <div class="form-type-list" id="formTypeList">
                    <!-- DB에서 동적으로 로딩 -->
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-close-modal" onclick="closeModal()">닫기</button>
            </div>
        </div>
    </div>

    <!-- 결재 작성 폼 -->
    <div class="approval-form-wrap" id="approvalForm">

        <div class="form-doc-title" id="formDocTitle"></div>

        <!-- 기본 정보 -->
        <div class="form-section">
            <div class="form-section-header">
                <div class="form-section-title">
                    <span class="material-symbols-outlined">info</span>
                    기본 정보
                </div>
            </div>
            <div class="form-section-body">
                <div class="info-grid">
                    <div class="form-field">
                        <label>문서번호</label>
                        <input type="text" value="자동으로 생성됩니다" readonly>
                    </div>
                    <div class="form-field">
                        <label>작성일</label>
                        <input type="text" id="todayDate" readonly>
                    </div>
                    <div class="form-field">
                        <label>작성자</label>
                        <input type="text" value="경영지원팀 | 신준안 대표" readonly>
                    </div>
                </div>
            </div>
        </div>

        <!-- 결재선 + 참조자 -->
        <div class="form-section">
            <div class="form-section-header">
                <div class="form-section-title">
                    <span class="material-symbols-outlined">group</span>
                    결재선 정보
                </div>
                <div class="badge-group">
                    <button class="badge-btn orange">★ 작동</button>
                    <button class="badge-btn green">● 설정</button>
                </div>
            </div>
            <div class="form-section-body">
                <div class="approver-layout">
                    <div>
                        <div class="approver-grid">
                            <div class="form-field">
                                <label>결재자 1</label>
                                <select><option value="">선택</option></select>
                            </div>
                            <div class="form-field">
                                <label>결재자 2</label>
                                <select><option value="">선택</option></select>
                            </div>
                            <div class="form-field">
                                <label>결재자 3</label>
                                <select><option value="">선택</option></select>
                            </div>
                            <div class="form-field">
                                <label>결재자 4</label>
                                <select><option value="">선택</option></select>
                            </div>
                        </div>
                    </div>
                    <div class="approver-ref">
                        <div class="form-section-title" style="margin-bottom:10px;">
                            <span class="material-symbols-outlined">person_add</span>
                            참조자 정보
                        </div>
                        <div class="form-field">
                            <label>참조 목록</label>
                            <select><option value="">선택</option></select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 세부 정보 -->
        <div class="form-section" id="detailSection">
            <div class="form-section-header">
                <div class="form-section-title">
                    <span class="material-symbols-outlined">edit_note</span>
                    세부 정보
                </div>
            </div>
            <div class="form-section-body">
                <div class="detail-grid">
                    <div class="form-field">
                        <label>휴가 종류</label>
                        <select>
                            <option value="">선택</option>
                            <option>연차</option>
                            <option>반차(오전)</option>
                            <option>반차(오후)</option>
                            <option>병가</option>
                            <option>예비군</option>
                            <option>무급</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>휴가 시작일</label>
                        <div class="detail-grid-input">
                            <input type="date">
                            <select><option>종일</option><option>오전</option><option>오후</option></select>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>휴가 종료일</label>
                        <div class="detail-grid-input">
                            <input type="date">
                            <select><option>종일</option><option>오전</option><option>오후</option></select>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>총 휴가일 수</label>
                        <div class="detail-grid-input">
                            <input type="number" placeholder="0">
                            <span style="font-size:13px;color:#667085;white-space:nowrap;">일</span>
                        </div>
                    </div>
                </div>
                <div class="form-field">
                    <label>상세 설명</label>
                    <textarea rows="4" placeholder="상세 내용을 입력해주세요."></textarea>
                </div>
                <div class="attach-row">
                    <div class="form-field">
                        <label>관련 첨부 <span style="font-size:10px;color:#9aa0b4;">ⓘ</span></label>
                        <div class="attach-input-wrap">
                            <button class="btn-file-select" onclick="document.getElementById('fileInput').click()">파일 선택</button>
                            <span class="file-name-display">선택된 파일 없음</span>
                            <input type="file" id="fileInput" style="display:none" onchange="updateFileName(this)">
                        </div>
                    </div>
                    <div class="form-field">
                        <label>첨부된 파일</label>
                        <div class="attach-preview">첨부된 파일이 없습니다.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 참고사항 -->
        <div class="form-section">
            <div class="form-section-header">
                <div class="form-section-title">
                    <span class="material-symbols-outlined">menu_book</span>
                    참고사항
                </div>
            </div>
            <div class="form-section-body">
                <ul class="reference-list">
                    <li><strong>[예비군 / 민방위 신청시]</strong> 동서서 스캔하여 파일 첨부</li>
                    <li><strong>[경조휴가 신청시]</strong> 각종 증빙서류 스캔하여 파일 첨부 (예: 청첩장, 등본 등)</li>
                    <li>기타 필요한 내용은 상세 설명란에 기입</li>
                </ul>
            </div>
        </div>

        <!-- 하단 버튼 -->
        <div class="form-footer">
            <button class="btn-save-temp">
                <span class="material-symbols-outlined" style="font-size:16px">save</span>
                임시저장
            </button>
            <button class="btn-submit">
                <span class="material-symbols-outlined" style="font-size:16px">send</span>
                결재전송
            </button>
            <button class="btn-cancel" onclick="location.href='${pageContext.request.contextPath}/approval/list'">
                <span class="material-symbols-outlined" style="font-size:16px">close</span>
                목록
            </button>
        </div>

    </div>

</main>

<script>
const ctx = document.querySelector('meta[name="ctx"]').content;

// 오늘 날짜 표시
document.getElementById('todayDate').value = new Date().toLocaleDateString('ko-KR', {
    year: 'numeric', month: '2-digit', day: '2-digit', weekday: 'short'
});

// 문서유형 목록 로딩 (DB 연동)
(async function() {
    try {
        const res = await fetch(ctx + '/api/approval/doctype', {
            headers: { 'AJAX': 'true' }
        });
        const data = await res.json();

        const activeList = data.list.filter(item => item.useYn === 'Y');
        const container = document.getElementById('formTypeList');

        if (activeList.length === 0) {
            container.innerHTML = '<div style="text-align:center; color:#9aa0b4; padding:40px;">등록된 문서유형이 없습니다.</div>';
            return;
        }

        container.innerHTML = activeList.map(item =>
            '<div class="form-type-item" onclick="selectForm(' + item.docTypeId + ', \'' + item.typeName + '\')">' +
                '<span class="material-symbols-outlined">description</span>' +
                '<div class="form-type-item-content">' +
                    '<div class="form-type-item-title">' + item.typeName + '</div>' +
                    '<div class="form-type-item-desc">' + (item.description ? '• ' + item.description : '') + '</div>' +
                '</div>' +
            '</div>'
        ).join('');

    } catch (e) {
        console.error('문서유형 로딩 실패:', e);
    }
})();

let selectedDocTypeId = null;

function selectForm(docTypeId, typeName) {
    selectedDocTypeId = docTypeId;
    document.getElementById('formSelectModal').classList.add('hidden');
    document.getElementById('approvalForm').classList.add('active');
    document.getElementById('formDocTitle').textContent = typeName;
}

function closeModal() {
    document.getElementById('formSelectModal').classList.add('hidden');
    location.href = ctx + '/approval/list';
}

function updateFileName(input) {
    const name = input.files[0] ? input.files[0].name : '선택된 파일 없음';
    input.closest('.attach-input-wrap').querySelector('.file-name-display').textContent = name;
}
</script>
</body>
</html>
