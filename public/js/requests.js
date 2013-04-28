var uri = "http://frozen-woodland-9065.herokuapp.com/trip/plan";

function getPlacesOfInterest(lat, long, startDate, endDate) {
	var lat = lat;
	var long = long;
	var startDate = new Date(startDate);
	var endDate = new Date(endDate);

	var jsonData = '{"lat": ' + lat + ', "long": ' + long + ', "start_date": ' + startDate.getTime()/1000 + ', "end_date": ' + endDate.getTime()/1000 + '}';

	$.ajax({
		  type: "POST",
		  url: uri,
		  data: jsonData,
		  success: populateLocations
		});
}

function populateLocations(data) {
	locations = jQuery.parseJSON(data);
	console.log(data);
	drawLocations();
}