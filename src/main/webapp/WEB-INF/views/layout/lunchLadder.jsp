<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game Zone</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/lunchLadder.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
    <div class="gz-wrap">

        <div class="gz-header">
            <h4><i class="fas fa-gamepad"></i> Game Zone</h4>
            <p class="gz-desc">Team games for lunch picks and more</p>
        </div>

        <div class="game-grid">

            <div class="game-card" onclick="openModal('ladder')">
                <div class="game-icon ladder-icon">
                    <i class="fas fa-grip-lines"></i>
                </div>
                <div class="game-info">
                    <div class="game-name">Lunch Ladder</div>
                    <div class="game-desc">Classic ladder game to pick who pays</div>
                </div>
                <div class="game-badge">2 - 8 players</div>
            </div>

            <div class="game-card" onclick="openModal('roulette')">
                <div class="game-icon roulette-icon">
                    <i class="fas fa-circle-notch"></i>
                </div>
                <div class="game-info">
                    <div class="game-name">Roulette</div>
                    <div class="game-desc">Spin the wheel and let fate decide</div>
                </div>
                <div class="game-badge">2 - 8 players</div>
            </div>

            <div class="game-card" onclick="openModal('luckydraw')">
                <div class="game-icon lucky-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="game-info">
                    <div class="game-name">Lucky Draw</div>
                    <div class="game-desc">Flip a card and reveal your fate</div>
                </div>
                <div class="game-badge">2 - 8 players</div>
            </div>

        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/layout/lunchLadderGames.jsp" %>

<script>
function openModal(type) {
    document.getElementById('modal-' + type).style.display = 'flex';
}
</script>

</body>
</html>
