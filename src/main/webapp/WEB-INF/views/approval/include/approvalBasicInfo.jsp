<%@ page contentType="text/html; charset=UTF-8"%>

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
                <input type="text" :value="todayDate" readonly>
            </div>
            <div class="form-field">
                <label>작성자</label>
                <input type="text" value="경영지원팀 | 신준안 대표" readonly>
            </div>
        </div>
    </div>
</div>