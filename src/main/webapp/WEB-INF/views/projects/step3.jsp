<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="mb-5">
    <h2 class="fw-bold fs-3">Project 팀 구성</h2>
    <p class="text-muted">Project 팀원들의 역할을 설정하세요.</p>
</div>

<div class="card-custom">
    <div class="section-title"><i class="fas fa-user-tag me-2"></i>Team Project Member</div>

    <div class="member-list">
        <div class="member-row">
            <div class="member-info">
                <img src="https://i.pravatar.cc/150?u=1" class="avatar">
                <div>
                    <div class="member-name">Alice Cooper</div>
                    <div class="member-email">alice@example.com</div>
                </div>
                <div class="custom-dropdown">
                    <div class="selected-value badge-role">
                        <span class="status-dot"></span>역할
                    </div>
                    <ul class="dropdown-menu">
                        <li class="badge-manager"    data-label="매니저"   data-class="badge-manager"><span class="status-dot"></span>매니저</li>
                        <li class="badge-supervisor" data-label="책임자"   data-class="badge-supervisor"><span class="status-dot"></span>책임자</li>
                        <li class="badge-designer"   data-label="디자이너" data-class="badge-designer"><span class="status-dot"></span>디자이너</li>
                        <li class="badge-developer"  data-label="개발자"   data-class="badge-developer"><span class="status-dot"></span>개발자</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="member-row">
            <div class="member-info">
                <img src="https://i.pravatar.cc/150?u=2" class="avatar">
                <div>
                    <div class="member-name">Bob Dylan</div>
                    <div class="member-email">bob@example.com</div>
                </div>
                <div class="custom-dropdown">
                    <div class="selected-value badge-role">
                        <span class="status-dot"></span>역할
                    </div>
                    <ul class="dropdown-menu">
                        <li class="badge-manager"    data-label="매니저"   data-class="badge-manager"><span class="status-dot"></span>매니저</li>
                        <li class="badge-supervisor" data-label="책임자"   data-class="badge-supervisor"><span class="status-dot"></span>책임자</li>
                        <li class="badge-designer"   data-label="디자이너" data-class="badge-designer"><span class="status-dot"></span>디자이너</li>
                        <li class="badge-developer"  data-label="개발자"   data-class="badge-developer"><span class="status-dot"></span>개발자</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
document.addEventListener('click', function (e) {
    const item = e.target.closest('.dropdown-menu li');
    if (item) {
        const dropdown = item.closest('.custom-dropdown');
        const displayArea = dropdown.querySelector('.selected-value');
        displayArea.innerHTML = '<span class="status-dot"></span>' + item.getAttribute('data-label');
        displayArea.className = 'selected-value ' + item.getAttribute('data-class');
        dropdown.querySelector('.dropdown-menu').style.display = 'none';
        return;
    }

    const selectedBtn = e.target.closest('.selected-value');
    if (selectedBtn) {
        const menu = selectedBtn.nextElementSibling;
        const isOpen = menu.style.display === 'block';
        document.querySelectorAll('.dropdown-menu').forEach(m => m.style.display = 'none');
        menu.style.display = isOpen ? 'none' : 'block';
        e.stopPropagation();
    } else {
        document.querySelectorAll('.dropdown-menu').forEach(m => m.style.display = 'none');
    }
});
</script>
