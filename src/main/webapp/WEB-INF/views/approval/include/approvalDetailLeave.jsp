<%@ page contentType="text/html; charset=UTF-8"%>

<!-- 세부 정보 -->
<div class="form-section">
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
                    <option v-for="lv in codeStore.getCodes('LEAVETYPE')"
                            :key="lv.code"
                            :value="lv.code">
                        {{ lv.name }}
                    </option>
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