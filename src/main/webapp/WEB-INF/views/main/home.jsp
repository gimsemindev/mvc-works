<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/core.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/editProfile.css">
</head>

<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	<jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

	<div class="dashboard">

		<!-- 프로필 -->
		<div class="card profile-card">
			<div class="profile-top">

				<img src="/uploads/member/${sessionScope.member.avatar}"
					class="profile-avatar" onerror="this.src='/dist/images/avatar.png'">

				<div>
					<div class="profile-name">${sessionScope.member.name}</div>
					<div class="profile-grade">${sessionScope.member.gradeName}</div>
				</div>

			</div>

		</div>


		<!-- 프로젝트 진행률 -->
		<div class="card project-card">

			<div class="card-title">프로젝트 진행률</div>

			<c:forEach var="p" items="${projectList}">

				<div class="project-item">

					<div class="project-top">
						<span>${p.title}</span> <span>${p.progress}%</span>
					</div>

					<div class="progress-bg">
						<div class="progress-fill" style="width:${p.progress}%"></div>
					</div>

				</div>

			</c:forEach>

		</div>


		<!-- 결재 현황 -->
		<div class="card approval-card">

			<div class="card-title">결재 현황</div>

			<div class="approval-grid">

				<div class="approval-box">
					<div class="approval-count">${approval.wait}</div>
					<div>미결재 문서</div>
				</div>

				<div class="approval-box">
					<div class="approval-count">${approval.progress}</div>
					<div>미확인 문서</div>
				</div>

				<div class="approval-box">
					<div class="approval-count">${approval.done}</div>
					<div>받은 문서</div>
				</div>

			</div>

		</div>

		<!-- 내 할일 -->
		<div class="card todo-card">

			<div class="card-title">내 할일</div>

			<c:forEach var="t" items="${todoList}">
				<div class="todo-item">

					<input type="checkbox"> <span>${t.title}</span> <span
						class="todo-date">${t.deadline}</span>

				</div>
			</c:forEach>

		</div>



		<!-- 프로젝트 캘린더 -->
		<div class="card calendar-card">

			<div class="card-title">프로젝트 캘린더</div>

			<div id="calendar"></div>

		</div>

	</div>

	<script>
document.addEventListener('DOMContentLoaded', function() {

	let calendarEl = document.getElementById('calendar');

	let calendar = new FullCalendar.Calendar(calendarEl, {

		initialView: 'dayGridMonth',

		events: [
			<c:forEach var="e" items="${calendarList}">
			{
				title: "${e.title}",
				start: "${e.startDate}"
			},
			</c:forEach>
		]

	});

	calendar.render();
});
</script>
</body>
</html>