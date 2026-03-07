document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-box input');
    const filterBtn = document.getElementById('myFilterBtn');
    const filterMenu = document.getElementById('myFilterMenu');
    const filterItems = filterMenu.querySelectorAll('.dropdown-item');
    const tableRows = document.querySelectorAll('tbody tr');

    let currentStatus = "";


    function applyFilters() {
        const searchTerm = searchInput.value.toLowerCase().trim();

        tableRows.forEach(row => {
            const projectName = row.cells[1].textContent.toLowerCase();
            const rowStatusClean = row.cells[7].textContent.replace(/\s/g, "").trim();
            const selectedStatusClean = currentStatus.replace(/\s/g, "").trim();

            const matchesSearch = projectName.includes(searchTerm);
            const matchesStatus = (currentStatus === "") || rowStatusClean.includes(selectedStatusClean);

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
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
            

            currentStatus = this.querySelector('.status-badge').innerText.trim();
            
            applyFilters();
            filterMenu.classList.remove('show');
            filterBtn.style.color = "#4e73df"; 
        });
    });
	

});