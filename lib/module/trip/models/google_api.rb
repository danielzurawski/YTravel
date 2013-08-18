module YTravel
	class GoogleApi
		def calculate_distance(lat1, long1, lat2, long2)
			uri = URI("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{lat1.to_s},#{long1.to_s}&destinations=#{lat2.to_s},#{long2.to_s}&sensor=false&mode=walking");
			res = Net::HTTP.get(uri)

			yes = JSON.parse(res.force_encoding('UTF-8'))['rows'].first['elements'].first['distance']['text']
		end
	end
end
