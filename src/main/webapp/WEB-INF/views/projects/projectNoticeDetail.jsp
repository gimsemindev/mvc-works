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

/* 하단 버튼 정렬 */
.notice-footer {
	display: flex;
	align-items: center;
	margin-top: 10px;
}

/* 왼쪽: 목록 */
.btn-list:first-child {
	margin-right: auto;
}

/* 오른쪽 버튼 간격 */
.notice-footer .btn-list {
	margin-left: 6px;
}

/* 삭제 버튼만 강조 */
.notice-footer .btn-list:last-child {
	border-color: #ef4444;
	color: #ef4444;
}

.notice-footer .btn-list:last-child:hover {
	background: #fee2e2;
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

					<!-- ⭐ 매니저만 -->
					<button v-if="isManager" class="btn-list" @click="goEdit">수정</button>
					<button v-if="isManager" class="btn-list" @click="deleteNotice">삭제</button>
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
				detail: {},
				isManager: false // ⭐ 추가
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

					// ⭐ 구조 변경 반영
					this.detail = data.detail
					this.isManager = data.isManager

				} catch (e) {
					alert("공지사항을 불러오지 못했습니다.")
					console.error(e)
				}
			},

			downloadFile(filenum) {
				window.open(ctx + '/api/projectnotice/file/' + filenum)
			},

			goList() {
				location.href = ctx + '/projects/projectNotice'
			},

			// ⭐ 수정
			goEdit() {
				location.href = ctx + '/projects/projectNotice/projectNoticeForm?noticenum=' + this.detail.noticenum
			},

			// ⭐ 삭제
			async deleteNotice() {
				if (!confirm("삭제하시겠습니까?")) return

				try {
					const res = await fetch(ctx + '/api/projectnotice/delete?noticenum=' + this.detail.noticenum, {
						method: "POST",
						credentials: "include"
					})

					if (res.ok) {
						alert("삭제 완료")
						this.goList()
					} else {
						alert("삭제 실패")
					}
				} catch (e) {
					console.error(e)
				}
			}
		}
	}).mount('#app')
})
</script>
</body>
</html>