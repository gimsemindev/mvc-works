<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지 등록</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/projectnoticeform.css">
<meta name="ctx" content="${pageContext.request.contextPath}">

<!-- Vue -->
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<!-- Quill -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css"
	rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
</head>

<body>
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	<jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

	<div id="app" v-cloak>
		<div class="main-content">
			<div class="page-header">
				<h2 class="page-title">공지사항 등록</h2>
			</div>

			<div class="notice-card">

				<!-- 프로젝트 선택 -->
				<div class="form-row">
					<label>프로젝트 *</label> <select v-model="selectedProjectId">
						<option value="">선택하세요</option>
						<option v-for="p in projects" :key="p.projectid"
							:value="p.projectid">{{ p.projectName }}</option>
					</select>
				</div>

				<!-- 제목 -->
				<div class="form-row">
					<label>제목 *</label> <input class="form-input" type="text"
						v-model="formData.subject" placeholder="제목을 입력하세요">
				</div>

				<!-- 내용 -->
				<div class="form-row">
					<label>내용</label>
					<div id="editor" style="height: 200px;"></div>
				</div>

				<!-- 첨부파일 -->
				<div class="form-row">
					<label>첨부 파일</label>
					<div class="file-area">
						<input type="file" @change="handleFiles" multiple>
						<ul class="file-list">
							<li v-for="f in formData.files" :key="f.name">{{ f.name }}</li>
						</ul>
					</div>
				</div>

				<!-- 버튼 -->
				<div class="form-buttons">
					<button class="btn-cancel" @click="goBack">취소</button>
					<button class="btn-save" @click="submitForm">저장</button>
				</div>

			</div>
		</div>
	</div>

	<script>
document.addEventListener('DOMContentLoaded', function() {
	const ctx = document.querySelector('meta[name="ctx"]').content;
	const { createApp } = Vue;

	createApp({
		data() {
			return {
				projects: [],
				selectedProjectId: '',
				formData: {
					subject: '',
					content: '',
					files: []
				},
				quill: null
			}
		},

		mounted() {
			// URL 파라미터 처리
			const params = new URLSearchParams(window.location.search);
			const pid = params.get("projectid");
			if (pid) this.selectedProjectId = pid;

			// Quill 초기화
			this.quill = new Quill('#editor', {
				theme: 'snow',
				placeholder: '내용을 입력하세요'
			});

			// 프로젝트 목록 가져오기
			fetch(ctx + "/api/projectnotice/myprojects/pm", {
			    credentials: "include"
			})
			.then(res => res.json())
			.then(data => {
			    this.projects = data.map(p => ({
			        projectid: p.PROJECTID,
			        projectName: p.PROJECTNAME
			    }));
			})
			.catch(err => console.error("프로젝트 가져오기 오류:", err));
		},

		methods: {
			handleFiles(e) {
				this.formData.files = Array.from(e.target.files);
			},

			async submitForm() {
				if (!this.selectedProjectId) {
					alert("프로젝트를 선택해주세요.");
					return;
				}
				if (!this.formData.subject) {
					alert("제목을 입력해주세요.");
					return;
				}

				this.formData.content = this.quill.root.innerHTML;

				if (!this.formData.content || this.formData.content === '<p><br></p>') {
					alert("내용을 입력해주세요.");
					return;
				}

				const form = new FormData();
				form.append("projectid", this.selectedProjectId);
				form.append("subject", this.formData.subject);
				form.append("content", this.formData.content);

				this.formData.files.forEach(f => form.append("files", f));

				try {
					const res = await fetch(ctx + "/api/projectnotice", {
						method: "POST",
						body: form,
						credentials: "include"
					});

					if (res.ok) {
						alert("공지 등록 완료");
						location.href = ctx + "/projects/projectNotice?projectid=" + this.selectedProjectId;
					} else {
						const text = await res.text();
						alert("등록 실패 : " + text);
					}
				} catch (err) {
					console.error(err);
					alert("등록 중 오류 발생");
				}
			},

			goBack() {
				history.back();
			}
		}
	}).mount("#app");
});
</script>

</body>
</html>