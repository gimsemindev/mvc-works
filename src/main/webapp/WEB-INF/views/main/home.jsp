<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
</head>
<body>
<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main>
	<div class="section">
		<div class="container">
			메인 화면 입니다.
		</div>
	</div>
</main>
</body>
</html>