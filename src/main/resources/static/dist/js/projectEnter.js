document.addEventListener('keydown', function(e) {
    if (e.key !== 'Enter') return;
    const tag = e.target.tagName.toLowerCase();
    if (tag === 'input') {
		
        if (e.target.classList.contains('sub-plan-input') || 
            e.target.classList.contains('phase-title-input')) return;
        e.preventDefault();
        e.stopPropagation();
    }
});