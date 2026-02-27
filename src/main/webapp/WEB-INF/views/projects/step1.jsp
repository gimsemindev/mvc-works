<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="mb-5">
    <h2 class="section-title">Project type</h2>
    <p class="section-desc">먼저 프로젝트의 타입을 선택해 주세요.</p>

    <div class="select-card" onclick="selectOnlyOne(event.currentTarget, 'type-group')">
        <div class="icon-box"><i class="fas fa-user"></i></div>
        <div class="card-content">
            <div class="title">Personal Project</div>
            <div class="desc">개인적인 업무 관리 및 트래킹을 위한 프로젝트입니다.</div>
        </div>
        <i class="fas fa-check-circle check-mark"></i>
    </div>

    <div class="select-card" onclick="selectOnlyOne(event.currentTarget, 'type-group')">
        <div class="icon-box"><i class="fas fa-users"></i></div>
        <div class="card-content">
            <div class="title">Team Project</div>
            <div class="desc">팀원들과 협업하고 역할을 분담하는 프로젝트입니다.</div>
        </div>
        <i class="fas fa-check-circle check-mark"></i>
    </div>
</div>

<div class="mb-5">
    <h2 class="section-title">Project manage</h2>
    <p class="section-desc">프로젝트를 관리할 수 있는 권한을 설정합니다.</p>

    <div class="select-card" onclick="selectOnlyOne(event.currentTarget, 'manage-group')">
        <div class="icon-box"><i class="fas fa-globe"></i></div>
        <div class="card-content">
            <div class="title">Everyone</div>
            <div class="desc">모든 구성원이 프로젝트를 보고 참여할 수 있습니다.</div>
        </div>
        <i class="fas fa-check-circle check-mark"></i>
    </div>

    <div class="select-card" onclick="selectOnlyOne(event.currentTarget, 'manage-group')">
        <div class="icon-box"><i class="fas fa-user-shield"></i></div>
        <div class="card-content">
            <div class="title">Select Specific Managers</div>
            <div class="desc">지정된 관리자만 프로젝트 설정 권한을 가집니다.</div>
        </div>
        <i class="fas fa-check-circle check-mark"></i>
    </div>
</div>

<script type="text/javascript">
function selectOnlyOne(element, groupName) {
    const parentSection = element.parentElement;
    parentSection.querySelectorAll('.select-card').forEach(card => {
        card.classList.remove('selected');
    });
    element.classList.add('selected');
}
</script>
