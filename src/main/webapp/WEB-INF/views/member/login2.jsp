<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>mvc-works</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/login-full.css"
	type="text/css">
</head>
<body>

	<main class="full-main">
		<div class="card-container">
			<div class="full-main-bg">
				<div class="large-circle-1"></div>
				<div class="small-circle-1"></div>
				<div class="large-circle-2"></div>
				<div class="small-circle-2"></div>
			</div>

			<div class="card-wrapper">
				<div class="card-header">
					<a href="<c:url value='/' />"> <span class="brand-icon"><i
							class="bi bi-stars"></i></span> <span class="brand-name">mvc-works</span>
					</a>
				</div>

				<div class="login-form">
					<div class="login-form-header">
						<h3>Login</h3>
					</div>
					<div class="login-form-body">

						<form name="loginForm" action="" method=post class="row g-3">
							<div>
								<input type="text" name="empId" class="form-control"
									placeholder="아이디">
							</div>
							<div>
								<input type="password" name="password" class="form-control"
									autocomplete="off" placeholder="패스워드">
							</div>
							<div class="d-flex justify-content-between">
								<div class="form-check">
									<input class="form-check-input rememberMe" type="checkbox"
										id="rememberMeModel"> <label class="form-check-label"
										for="rememberMeModel"> 아이디 저장</label>
								</div>
							</div>
							<div>
								<button type="button" class="btn-accent btn-lg w-100"
									onclick="sendLogin();">Login</button>
							</div>
							<div>
								<p class="form-control-plaintext text-center text-danger p-0">
									<small>${message}</small>
								</p>
								<p class="form-control-plaintext text-center">
									<a href="#" class="border-link-right me-2">패스워드를 잊으셨나요 ?</a>
								</p>
							</div>
						</form>
					</div>
				</div>

			</div>
		</div>
	</main>

	<script type="text/javascript">
		function sendLogin() {
			const f = document.loginForm;

			if (!f.empId.value.trim()) {
				f.empId.focus();
				return;
			}

			if (!f.password.value.trim()) {
				f.password.focus();
				return;
			}

			f.action = '${pageContext.request.contextPath}/member/login';
			f.submit();
		}
	</script>

	<!-- Vendor JS Files -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

</body>
</html>