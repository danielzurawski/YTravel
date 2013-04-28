var geocoder;
var map;
var locations;
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var currentDay = 1;
var markersArray = [];

function initializeMap() {
	geocoder = new google.maps.Geocoder();
	directionsDisplay = new google.maps.DirectionsRenderer();
	var mapOptions = {
		zoom : 8,
		center : new google.maps.LatLng(51.5171, 0.1062),
		mapTypeId : google.maps.MapTypeId.ROADMAP
	}
	map = new google.maps.Map(document.getElementById("map_container"),
			mapOptions);
	directionsDisplay.setMap(map);
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
    	overlayIn.run();
   	}
};

function codeAddress() {
	var address = document.getElementById("search_location").value;
	geocoder.geocode({
		'address' : address
	}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			getPlacesOfInterest(results[0].geometry.location.lat(),
					results[0].geometry.location.lng(), address, Y.one(
							'#calendarFromTxt').get('value'), Y.one(
							'#calendarToTxt').get('value'));
		} else {
			alert("Geocode was not successful for the following reason: "
					+ status);
		}
	});
};

function drawLocations() {
	clearMarkers();
	var infoWindow = new google.maps.InfoWindow();

	var startindex = (currentDay - 1) * 6;
	var endindex;
	if (locations.length >= currentDay * 6)
		endindex = currentDay * 6;
	else
		endindex = locations.length;

	changeItineraryPhoto(startindex);
	for ( var i = startindex; i < endindex; i++) {
		var marker = new google.maps.Marker({
			position : new google.maps.LatLng(locations[i].lat,
					locations[i].long),
			map : map,
			title : locations[i].name,
			html : "<img src='" + locations[i].icon
					+ "' class='location_icon'/>" + locations[i].name
					+ "<br/>" + "Rating: " + locations[i].rating //+ "<img src='" + locations[i].photo + "' class='location_photo'>"
		});
		markersArray[markersArray.length] = marker;

		if (i == startindex) {
			infoWindow = new google.maps.InfoWindow();
			infoWindow.setContent("Start: " + marker.html);
			infoWindow.open(map, marker);
		} else if (i == endindex-1) {
			infoWindow = new google.maps.InfoWindow();
			infoWindow.setContent("End: " + marker.html);
			infoWindow.open(map, marker);
		} else {
			google.maps.event.addListener(marker, 'click', function() {
				infoWindow.setContent(this.html);
				infoWindow.open(map, this);
			});
		}
	}
	drawRoute();
}

function drawRoute() {

	var startindex = (currentDay - 1) * 6;
	var endindex;
	if (locations.length >= currentDay * 6)
		endindex = currentDay * 6 - 1;
	else
		endindex = locations.length - 1;

	var start = new google.maps.LatLng(locations[startindex].lat,
			locations[startindex].long);
	var end = new google.maps.LatLng(locations[endindex].lat,
			locations[endindex].long);

	var waypts = [];

	var startpoint = (currentDay - 1) * 6 + 1;
	var endpoint;
	if (locations.length > currentDay * 6)
		endpoint = currentDay * 6 - 1;
	else
		endpoint = locations.length - 1;

	for ( var i = startindex + 1; i < endindex; i++) {
		waypts.push({
			location : new google.maps.LatLng(locations[i].lat,
					locations[i].long),
			stopover : true
		});
	}

	var request = {
		origin : start,
		destination : end,
		waypoints : waypts,
		optimizeWaypoints : true,
		travelMode : google.maps.TravelMode.WALKING
	};
	directionsService.route(request, function(result, status) {
		if (status == google.maps.DirectionsStatus.OK) {
			directionsDisplay.setDirections(result);
			drawRouteInstructions(result.routes[0].legs[0]);
		}
	});
}

function drawRouteInstructions(myRoute) {
	var html = "<h1><button onClick='goDay(-1)' class='yui3-button'>back</button>" + " Day "
			+ currentDay + " <button onClick='goDay(1)' class='yui3-button'>next</button></h1> "
			+ "<h2>Landmarks:</h2><ol>";

	var startindex = (currentDay - 1)*6;
	var endindex;
	if (locations.length >= currentDay*6)
		endindex = currentDay * 6;
	else
		endindex = locations.length;

	for ( var i = startindex; i < endindex; i++) {
		html = html + "<li><a href='#' onClick='changeItineraryPhoto("+ i +")'>" + locations[i].name + "</a></li>";
	}

	html = html + "</ol><h2>Itinerary:</h2><ul>";

	for ( var i = 0; i < myRoute.steps.length; i++) {
		html = html + "<li>" + myRoute.steps[i].instructions + "</li>";
	}
	Y.one('#itinerary_text').setHTML(html + "</ul>");
}

function goDay(movement) {
	if (movement == -1) {
		if (!(currentDay > 1))
			return;
	} else if (!(locations.length > currentDay * 6))
		return;

	currentDay = currentDay + movement;
	drawLocations();
	drawRoute();
}

function clearMarkers() {
	if (markersArray) {
		for (i in markersArray) {
			markersArray[i].setMap(null);
		}
		markersArray.length = 0;
	}
}