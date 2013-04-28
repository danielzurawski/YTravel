// Some global variables
var Y = YUI();

Y.use('calendar', 'anim', 'autocomplete', function(Y) {
	// Create a new instance of Calendar, setting its width
	// and height, allowing the dates from the previous
	// and next month to be visible and setting the initial
	// date to be November, 1982.
	var calendar = new Y.Calendar({
		contentBox : "#calendarFrom",
		height : '300px',
		width : '300px',
		showPrevMonth : true,
		showNextMonth : true,
		date : new Date()
	}).render();


	var calendar2 = new Y.Calendar({
		contentBox : "#calendarTo",
		height : '300px',
		width : '300px',
		showPrevMonth : true,
		showNextMonth : true,
		date : new Date()
	}).render();

	registerListener(calendar2, "#calendarToTxt");
	registerListener(calendar, "#calendarFromTxt");

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