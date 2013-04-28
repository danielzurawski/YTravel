var geocoder;
var map;
var locations;
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();

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
};

function codeAddress() {
	var address = document.getElementById("search_location").value;
	geocoder.geocode({
		'address' : address
	}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			getPlacesOfInterest(results[0].geometry.location.lat(),
					results[0].geometry.location.lng(), Y.one(
							'#calendarFromTxt').get('value'), Y.one(
							'#calendarToTxt').get('value'));
		} else {
			alert("Geocode was not successful for the following reason: "
					+ status);
		}
	});
};

function drawLocations() {
	var infoWindow = new google.maps.InfoWindow({
		content : "holding"
	});

	for ( var i = 0; i < locations.length; i++) {
		var marker = new google.maps.Marker({
			position : new google.maps.LatLng(locations[i].lat,
					locations[i].long),
			map : map,
			title : locations[i].name,
			html : locations[i].name + "<br/>" + "Rating: "
					+ locations[i].rating
		});

		if(i == 0) {
			infoWindow = new google.maps.InfoWindow({
				content : "holding"
			});
			infoWindow.setContent("Start: " + marker.html);
			infoWindow.open(map, marker);
		} else if(i == locations.length-1) {
			infoWindow = new google.maps.InfoWindow({
				content : "holding"
			});
			infoWindow.setContent("End: " + marker.html);
			infoWindow.open(map, marker);
		}
		google.maps.event.addListener(marker, 'click', function() {
			infoWindow.setContent(this.html);
			infoWindow.open(map, this);
		});
	}
	drawRoute();
}

function drawRoute() {

	var start = new google.maps.LatLng(locations[0].lat, locations[0].long);
	var end = new google.maps.LatLng(locations[locations.length-1].lat, locations[locations.length-1].long);
	var waypts = [];
	for (var i = 1; i < locations.length-1; i++) {
		waypts.push(
				{
					location: new google.maps.LatLng(locations[i].lat, locations[i].long),
					stopover: true
				});
	}

	var request = {
			origin : start,
			destination : end,
			waypoints: waypts,
			optimizeWaypoints: true,
			travelMode : google.maps.TravelMode.WALKING
		};
		directionsService.route(request, function(result, status) {
			if (status == google.maps.DirectionsStatus.OK) {
				directionsDisplay.setDirections(result);
			}
		});
}
