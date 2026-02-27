(function () {
    const TOTAL_STEPS = 4;
    let currentStep = 1;

    function goToStep(step) {
        if (step < 1 || step > TOTAL_STEPS) return;

        document.querySelectorAll('.step-content').forEach(function(panel) {
            panel.classList.remove('active');
        });
        document.getElementById('step-panel-' + step).classList.add('active');

        document.querySelectorAll('.stepper-nav .step-item').forEach(function(item) {
            item.classList.remove('active');
            if (parseInt(item.getAttribute('data-step')) === step) {
                item.classList.add('active');
            }
        });

        document.getElementById('btnPrev').style.visibility = (step === 1) ? 'hidden' : 'visible';

        if (step === TOTAL_STEPS) {
            document.getElementById('btnNext').style.display = 'none';
            document.getElementById('btnComplete').style.display = 'inline-block';
        } else {
            document.getElementById('btnNext').style.display = 'inline-block';
            document.getElementById('btnComplete').style.display = 'none';
        }

        currentStep = step;
    }

    document.getElementById('btnNext').addEventListener('click', function () {
        goToStep(currentStep + 1);
    });
    document.getElementById('btnPrev').addEventListener('click', function () {
        goToStep(currentStep - 1);
    });

    document.getElementById('btnComplete').addEventListener('click', function () {
        // TODO: insert 처리 (form submit 또는 fetch/ajax)
    });

    document.querySelectorAll('.stepper-nav .step-item').forEach(function(item) {
        item.addEventListener('click', function () {
            goToStep(parseInt(item.getAttribute('data-step')));
        });
    });

    goToStep(1);
})();