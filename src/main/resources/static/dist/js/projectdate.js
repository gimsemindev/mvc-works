document.addEventListener('DOMContentLoaded', function () {
    initDatePickers();
});

function initDatePickers() {
    document.querySelectorAll('input[type=date]').forEach(function (input) {
        if (input._flatpickr) return;

        const currentValue = input.value;

		flatpickr(input, {
		    locale: 'ko',
		    dateFormat: 'Y-m-d',
		    defaultDate: currentValue || null,
		    disableMobile: true,
		    allowInput: false,

			disable: [
			    function (date) {
			        if (date.getDay() === 0 || date.getDay() === 6) return true;

			        const projectStartEl = document.getElementById('hiddenProjectStart');
			        const projectEndEl = document.getElementById('hiddenProjectEnd');

			        if (projectStartEl && projectEndEl) {
			            const projectStart = new Date(projectStartEl.value.replace(/\//g, '-'));
			            const projectEnd = new Date(projectEndEl.value.replace(/\//g, '-'));
			            // 시간 제거하고 날짜만 비교
			            projectStart.setHours(0, 0, 0, 0);
			            projectEnd.setHours(0, 0, 0, 0);
			            date.setHours(0, 0, 0, 0);
			            if (date < projectStart || date > projectEnd) return true;
			        }

			        return false;
			    }
			],

            onReady: function (selectedDates, dateStr, instance) {
				setDefaultMonth(instance);
				    
				    const yearInput = instance.calendarContainer.querySelector('.numInput.cur-year');
				    if (yearInput) {
				        yearInput.addEventListener('change', function () {
				            instance.changeYear(parseInt(this.value));
				        });
				        yearInput.addEventListener('keyup', function () {
				            if (this.value.length === 4) {
				                instance.changeYear(parseInt(this.value));
				            }
				        });
				    }
				},
            onOpen: function (selectedDates, dateStr, instance) {
                setDefaultMonth(instance);
            },

			onChange: function (selectedDates, dateStr, instance) {
			    const nativeInput = instance.input;
			    nativeInput.value = dateStr;

			    const taskId = nativeInput.getAttribute('data-task-id');
			    const type = nativeInput.getAttribute('data-type');
			    if (taskId && type) {
			        updateTask(taskId, type);
			    } else {
			        const event = new Event('change', { bubbles: true });
			        nativeInput.dispatchEvent(event);
			    }
			}
        });

        if (currentValue) {
            input._flatpickr.setDate(currentValue, false);
        }
    });
}


function setDefaultMonth(instance) {
    const input = instance.input;

    if (instance.selectedDates.length > 0) return;

    const row = input.closest('tr');
    if (!row) return;

    const prevRow = row.previousElementSibling;
    if (prevRow) {
        const prevEndInput = prevRow.querySelectorAll('.cell-date')[1];
        if (prevEndInput && prevEndInput._flatpickr && prevEndInput._flatpickr.selectedDates.length > 0) {
            const prevEndDate = prevEndInput._flatpickr.selectedDates[0];
            instance.changeYear(prevEndDate.getFullYear());
            instance.changeMonth(prevEndDate.getMonth() - instance.currentMonth, true);
            return;
        }
    }


    const dates = row.querySelectorAll('.cell-date');
    dates.forEach(function (d) {
        if (d !== input && d._flatpickr && d._flatpickr.selectedDates.length > 0) {
            const refDate = d._flatpickr.selectedDates[0];
            instance.changeYear(refDate.getFullYear());
            instance.changeMonth(refDate.getMonth() - instance.currentMonth, true);
        }
    });
}


const observer = new MutationObserver(function () {
    initDatePickers();
});

observer.observe(document.body, { childList: true, subtree: true });