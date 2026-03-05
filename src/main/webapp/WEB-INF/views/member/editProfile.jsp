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

	<main class="d-flex justify-content-center align-items-center py-5">

		<form method="post" enctype="multipart/form-data"
			action="${pageContext.request.contextPath}/member/update"
			onsubmit="return sendOk();">

			<div class="profile-card">

				<h4 class="mb-4 fw-bold">Edit Profile</h4>

				<!-- 프로필 영역 -->
				<div class="d-flex align-items-center gap-4">

					<c:choose>
						<c:when test="${empty dto.profilePhoto}">
							<img
								src="${pageContext.request.contextPath}/dist/images/avatar.png"
								class="large-avatar">
						</c:when>
						<c:otherwise>
							<img
								src="${pageContext.request.contextPath}/uploads/member/${dto.profilePhoto}"
								class="large-avatar"
								onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/avatar.png';">
						</c:otherwise>
					</c:choose>
					<div>
						<input type="file" name="selectFile" class="form-control mb-2">
						<button type="button" class="btn btn-outline-danger btn-sm"
							onclick="deleteProfilePhoto()">Remove</button>
					</div>

				</div>
				<hr class="divider">

				<!-- 개인정보 -->
				<div>
					<div class="section-title">Personal Information</div>

					<div class="row g-4">
						<div class="col-md-6">
							<label class="form-label">이름</label> <input type="text"
								class="form-control" value="${dto.name}" disabled>
						</div>

						<div class="col-md-6">
							<label class="form-label">사원번호</label> <input type="text"
								class="form-control" value="${dto.empId}" disabled>
						</div>

						<div class="col-md-6">
							<label class="form-label">휴대폰</label> <input type="text"
								class="form-control" name="tel" value="${dto.tel}">
						</div>

						<div class="col-md-6">
							<label class="form-label">이메일</label> <input type="email"
								class="form-control" name="email" value="${dto.email}">
						</div>
					</div>
				</div>

				<hr class="divider">

				<!-- 비밀번호 -->
				<div>
					<div class="section-title">비밀번호 변경 (선택)</div>

					<div class="row g-4">
						<div class="col-md-6">
							<label class="form-label">새 비밀번호</label> <input type="password"
								class="form-control" name="newPwd"
								placeholder="Min 8 characters">
						</div>

						<div class="col-md-6">
							<label class="form-label">새 비밀번호 확인</label> <input
								type="password" class="form-control" name="confirmPwd">
						</div>
					</div>
				</div>

				<input type="hidden" name="empId" value="${dto.empId}"> <input
					type="hidden" name="profilePhoto" value="${dto.profilePhoto}">
				<input type="hidden" name="name" value="${dto.name}">

				<div class="action-footer">
					<input type="hidden" name="deleteProfile" value="">
					<button type="submit" class="btn-save">변경하기</button>
				</div>

			</div>
		</form>
	</main>
	<script>
		document
				.querySelector("input[name='selectFile']")
				.addEventListener(
						"change",
						function(e) {

							const file = e.target.files[0];

							if (!file)
								return;

							const reader = new FileReader();

							reader.onload = function(event) {

								document.querySelector(".large-avatar").src = event.target.result;
							};

							reader.readAsDataURL(file);
						});
		
	function deleteProfilePhoto(){

	    if(!confirm("프로필 사진을 삭제하시겠습니까?")){
	        return;
	    }

	    const formData = new FormData();
	    formData.append("profilePhoto", "Y");

	    fetch("${pageContext.request.contextPath}/member/deleteProfile", {
	        method: "POST",
	        body: formData
	    })
	    .then(response => response.json())
	    .then(data => {

	        if(data.state === "true"){
	            document.querySelector(".large-avatar").src =
	                "${pageContext.request.contextPath}/dist/images/avatar.png";
	        }
	    });
	}
	
	function sendOk() {

	    const newPwd = document.querySelector("input[name='newPwd']").value;
	    const confirmPwd = document.querySelector("input[name='confirmPwd']").value;

	    if(newPwd || confirmPwd){

	        if(newPwd !== confirmPwd){
	            alert("비밀번호가 일치하지 않습니다.");
	            return false;
	        }

	        if(newPwd.length < 8){
	            alert("비밀번호는 8자 이상 입력하세요.");
	            return false;
	        }
	    }

	    return true;
	}
	</script>
</body>
</html>