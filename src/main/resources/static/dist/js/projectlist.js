document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-box input');
    const filterBtn = document.getElementById('myFilterBtn');
    const filterMenu = document.getElementById('myFilterMenu');
    const filterItems = filterMenu.querySelectorAll('.dropdown-item');

    let currentStatus = "";


	function applyFilters() {
	    const searchTerm = searchInput.value.toLowerCase().trim();
	    const schType = document.querySelector('select[name="schType"]').value;
	    const rows = document.querySelectorAll('tbody tr');

	    rows.forEach(row => {
	        if (row.cells.length < 8) return;

	        const projectName = row.cells[1].textContent.toLowerCase();
	        const managerName = row.cells[2].textContent.toLowerCase();
	        const startDate = row.cells[3].textContent.toLowerCase();
	        const endDate = row.cells[4].textContent.toLowerCase();
	        const rowStatusClean = row.cells[7].textContent.replace(/\s/g, "").trim();
	        const selectedStatusClean = currentStatus.replace(/\s/g, "").trim();

	        let matchesSearch = false;
			if (searchTerm === '') {
			    matchesSearch = true;
			} else if (schType === 'all') {
			    const normalizedStart = startDate.replace(/[-\/]/g, '');
			    const normalizedEnd = endDate.replace(/[-\/]/g, '');
			    const normalizedTerm = searchTerm.replace(/[-\/]/g, '');
			    matchesSearch = projectName.includes(searchTerm) ||
			                    managerName.includes(searchTerm) ||
			                    normalizedStart.includes(normalizedTerm) ||
			                    normalizedEnd.includes(normalizedTerm);
			} else if (schType === 'title') {
			    matchesSearch = projectName.includes(searchTerm);
			} else if (schType === 'manager') {
			    matchesSearch = managerName.includes(searchTerm);
			} else if (schType === 'startDate') {
			    const normalizedStart = startDate.replace(/[-\/]/g, '');
			    const normalizedTerm = searchTerm.replace(/[-\/]/g, '');
			    matchesSearch = normalizedStart.includes(normalizedTerm);
			} else if (schType === 'endDate') {
			    const normalizedEnd = endDate.replace(/[-\/]/g, '');
			    const normalizedTerm = searchTerm.replace(/[-\/]/g, '');
			    matchesSearch = normalizedEnd.includes(normalizedTerm);
			} else if (schType === 'status') {
			    matchesSearch = rowStatusClean.includes(searchTerm);
			}

	        const matchesStatus = (currentStatus === "") || rowStatusClean.includes(selectedStatusClean);

	        row.style.display = (matchesSearch && matchesStatus) ? '' : 'none';
	    });
	}


    searchInput.addEventListener('input', applyFilters);

    if (filterBtn && filterMenu) {
        filterBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            filterMenu.classList.toggle('show');
        });

        document.addEventListener('click', function(e) {
            if (!filterBtn.contains(e.target) && !filterMenu.contains(e.target)) {
                filterMenu.classList.remove('show');
            }
        });
    }

	filterItems.forEach(item => {
	    item.addEventListener('click', function(e) {
	        e.preventDefault();

	        const statusText = this.querySelector('.status-badge').innerText.trim();

	        // 상태 텍스트 → status 코드 매핑
	        const statusMap = {
	            '진행중': '2',
	            '승인대기': '3',
	            '중단': '6',
	            '종료': '4',
	            '지연': '5',
	            '시작전': '1'
	        };

	        const statusCode = statusMap[statusText] || '';

	        // 현재 폼에 status 값 추가해서 서버로 제출
	        const form = document.querySelector('.search-box').closest('form');
	        
	        let statusInput = form.querySelector('input[name="status"]');
	        if (!statusInput) {
	            statusInput = document.createElement('input');
	            statusInput.type = 'hidden';
	            statusInput.name = 'status';
	            form.appendChild(statusInput);
	        }
	        statusInput.value = statusCode;
	        form.submit();

	        filterMenu.classList.remove('show');
	        filterBtn.style.color = "#4e73df";
	    });
	});

});