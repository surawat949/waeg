/**
 * Created by thomas.schnocklake on 04.01.18.
 */
({
	setCalendarDate: function(cmp) {
		// http://momentjs.com/docs/#/displaying/format/
		var view = $('#calendar').fullCalendar('getView').name;
		var moment = $('#calendar').fullCalendar('getDate');
		var headerDate;
		if (view.includes('month')) {
			headerDate = moment.format('MMMM YYYY');
		} else
		if (view.includes('day')) {
			headerDate = moment.format('MMMM DD, YYYY');
		} else
		if (view.includes('week') || view.includes('Week'))  {
			var startDay = moment.startOf('week').format('DD');
			var endDay = moment.endOf('week').format('DD');
			headerDate = moment.format('MMM ') + startDay + ' – ' + endDay + moment.format(', YYYY');
		}
		cmp.set('v.headerDate',headerDate);
	}

})