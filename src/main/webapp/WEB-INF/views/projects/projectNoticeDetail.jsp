<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 상세</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp" />

<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet">

<meta name="ctx" content="${pageContext.request.contextPath}">

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<style>
[v-cloak] {
	display: none !important;
}

.main-content {
	margin-left: 260px;
	padding: 30px;
	background: #f4f6f9;
	min-height: 100vh;
}

.notice-card {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	overflow: hidden;
}

.notice-header {
	padding: 20px 25px;
	border-bottom: 1px solid #eee;
}

.notice-title {
	font-size: 20px;
	font-weight: 600;
	margin-bottom: 8px;
}

.notice-meta {
	font-size: 13px;
	color: #777;
	display: flex;
	gap: 15px;
}

.notice-content {
	padding: 25px;
	min-height: 200px;
	line-height: 1.6;
}

.notice-files {
	padding: 20px 25px;
	border-top: 1px solid #eee;
}

.file-item {
	display: inline-block;
	padding: 8px 12px;
	background: #eef1ff;
	border-radius: 8px;
	font-size: 13px;
	cursor: pointer;
	margin-top: 5px;
}

.file-item:hover {
	background: #dde3ff;
}

.notice-footer {
	padding: 20px 25px;
	border-top: 1px solid #eee;
}

.btn-list {
	padding: 8px 16px;
	border-radius: 6px;
	border: 1px solid #ccc;
	background: #fff;
	cursor: pointer;
}
</style>
</head>

<body>
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	<jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

	<div id="app" v-cloak>
		<div class="main-content">
			<div class="notice-card">

				<!-- 제목 -->
				<div class="notice-header">
					<div class="notice-title">{{ detail.subject }}</div>
					<div class="notice-meta">
						<span>작성자: {{ detail.authorName }}</span> <span>작성일: {{
							detail.regdate }}</span> <span>조회수: {{ detail.hitcount }}</span>
					</div>
				</div>

				<!-- 내용 -->
				<div class="notice-content" v-html="detail.content"></div>

				<!-- 첨부파일 -->
				<div class="notice-files"
					v-if="detail.files && detail.files.length > 0">
					<div style="font-weight: 500; margin-bottom: 10px;">첨부파일</div>

					<div v-for="f in detail.files" :key="f.filenum" class="file-item"
						@click="downloadFile(f.filenum)">📎 {{ f.originalfilename }}
					</div>
				</div>

				<!-- 하단 -->
				<div class="notice-footer">
					<button class="btn-list" @click="goList">목록</button>
				</div>

			</div>
		</div>
	</div>

	<script>
document.addEventListener('DOMContentLoaded', function() {
	const ctx = document.querySelector('meta[name="ctx"]').content
	const { createApp } = Vue

	createApp({
		data() {
			return {
				detail: {}
			}
		},
		mounted() {
			this.loadDetail()
		},
		methods: {
			async loadDetail() {
				const params = new URLSearchParams(location.search)
				const noticenum = params.get("noticenum")

				try {
					const res = await fetch(ctx + '/api/projectnotice/detail?noticenum=' + noticenum, {
					    credentials: "include"
					})
					const data = await res.json()
					this.detail = data
				} catch (e) {
					alert("공지사항을 불러오지 못했습니다.")
					console.error(e)
				}
			},

			downloadFile(filenum) {
				window.open(ctx + '/api/projectnotice/file/' + filenum)
			},

			goList() {
				window.location.href = ctx + '/projects/projectNotice'
			}
		}
	}).mount('#app')
})
</script>

</body>
</html>