class GoogleApi
	def calculate_distance(lat1, long1, lat2, long2)
		
		# http://maps.googleapis.com/maps/api/distancematrix/output?parameters

		uri = URI("http://maps.googleapis.com/maps/api/distancematrix/json?origins=" + lat1.to_s + "," + long1.to_s + "&destinations=" + lat2.to_s + "," + long2.to_s + "&sensor=false")
		res = Net::HTTP.get(uri)

		puts JSON.parse(res.force_encoding('UTF-8'))
		#puts JSON.parse(res)

		#if res.is_a?(Net::HTTPSuccess)
		#	return JSON.parse(res.body)
		#else
	end

	def get_photo(key, photoreference)

		#https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CoQBegAAAFg5U0y-iQEtUVMfqw4KpXYe60QwJC-wl59NZlcaxSQZNgAhGrjmUKD2NkXatfQF1QRap-PQCx3kMfsKQCcxtkZqQ&sensor=true&key=AddYourOwnKeyHere
		uri = URI("http://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=" + 
				photoreference + "&sensor=false&key=" + key)
		res = Net::HTTP.get(uri)
		#puts JSON.parse(res.force_encoding('UTF-8'))
	end
end
