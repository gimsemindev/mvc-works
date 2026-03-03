<%@ page contentType="text/html; charset=UTF-8"%>

<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>

<div class="form-section" v-if="store.selectedFormCode === 'FM005'">
    <div class="form-section-header">
        <div class="form-section-title">
            <span class="material-symbols-outlined">edit_note</span>
            세부 정보
        </div>
    </div>
    <div class="form-section-body">
        <div class="form-field">
            <label>신청서 목적 <span style="font-size:10px;color:#9aa0b4;">ⓘ</span></label>
            <input type="text" placeholder="신청서 목적을 입력하세요." v-model="store.detailData.generalPurpose">
        </div>
        <div class="form-field" style="margin-top:10px;">
            <label>상세 설명</label>
            <div id="general-editor" style="min-height:200px;"></div>
        </div>
        <div class="attach-row">
            <div class="form-field">
                <label>관련 첨부 <span style="font-size:10px;color:#9aa0b4;">ⓘ</span></label>
                <div class="attach-input-wrap">
                    <button class="btn-file-select" @click="fileInput.click()">파일 선택</button>
                    <span class="file-name-display">{{ fileName }}</span>
                    <input type="file" ref="fileInput" style="display:none" @change="onFileChange">
                </div>
            </div>
            <div class="form-field">
                <label>첨부된 파일</label>
                <div class="attach-preview">첨부된 파일이 없습니다.</div>
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    let quill = null;
    const observer = new MutationObserver(function() {
        const el = document.getElementById('general-editor');
        if (el && !quill) {
            quill = new Quill(el, {
                theme: 'snow',
                placeholder: '상세 내용을 입력해주세요.',
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, false] }],
                        ['bold', 'italic', 'underline', 'strike'],
                        [{ 'color': [] }, { 'background': [] }],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        [{ 'align': [] }],
                        ['link', 'image'],
                        ['clean']
                    ]
                }
            });
        }
    });
    const app = document.getElementById('vue-app');
    if (app) observer.observe(app, { childList: true, subtree: true });
})();
</script>