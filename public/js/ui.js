Y.use('calendar', 'anim', 'autocomplete', 'button', 'tabview', function(Y) {

	Y.on('domready', function() {
		var calendar = new Y.Calendar({
			contentBox : "#calendarFrom",
			height : '250px',
			width : '300px',
			showPrevMonth : true,
			showNextMonth : true,
			date : new Date()
		}).render();


		var calendar2 = new Y.Calendar({
			contentBox : "#calendarTo",
			height : '250px',
			width : '300px',
			showPrevMonth : true,
			showNextMonth : true,
			date : new Date()
		}).render();

		registerListener(calendar2, "#calendarToTxt");
		registerListener(calendar, "#calendarFromTxt");

		// A push button widget
	    var button = new Y.Button({
	        srcNode: '#search_submit'
	    });
	});
});

// Helpers

function registerListener(calendar, calendarDivID) {

	// Get a reference to Y.DataType.Date
    var dtdate = Y.DataType.Date;
	calendar.on("selectionChange", function (ev) {

	      // Get the date from the list of selected
	      // dates returned with the event (since only
	      // single selection is enabled by default,
	      // we expect there to be only one date)
	      var newDate = ev.newSelection[0];

	      // Format the date and output it to a DOM
	      // element.
	      Y.one(calendarDivID).set('value', dtdate.format(newDate));
	    });
}

function changeItineraryPhoto(i) {
	Y.one('#itinerary_photo').setHTML('<img src="' + locations[i].photo + '" class="location_photo"/>');
}