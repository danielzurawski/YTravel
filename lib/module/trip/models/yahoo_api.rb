require 'open-uri'

class YahooApi
	def nearby_images(location, term)
		#yql = Yql::Client.new
		#query = Yql::QueryBuilder.new 'select * from flickr.photos.sizes where photo_id in (select id from flickr.photos.search where has_geo="true" and text="' + term + '" and woe_id in ( select woeid from geo.places where text = "' + location + '") and api_key="92bd0de55a63046155c09f1a06876875") and api_key="92bd0de55a63046155c09f1a06876875"'

		#query.to_s
		#yql.query = query
		
		#response = yql.get #=> Yql::Response object
		#puts "BOSS query result: " + response.show.to_s

		uri = URI(
			'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.sizes%20where%20photo_id%20in%20(select%20id%20from%20flickr.photos.search%20where%20has_geo%3D%22true%22%20and%20text%3D%22' + URI::encode(term.to_s) + '%22%20and%20woe_id%20in%20(%20select%20woeid%20from%20geo.places%20where%20text%20%3D%20%22' + URI::encode(location.to_s) + '%22)%20and%20api_key%3D%2292bd0de55a63046155c09f1a06876875%22)%20and%20api_key%3D%2292bd0de55a63046155c09f1a06876875%22&format=json&callback=')
		res = Net::HTTP.get(uri)
		
		json = JSON.parse(res)
		puts "json from nearby images: " + json.to_s
		json

		#puts "Yahoo nearby images Net::HTTP response: " + res.inspect

		#uri = URI("http://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=" + 
		#		photoreference + "&sensor=false&key=" + key)
		#res = Net::HTTP.get(uri)

		#http://api.flickr.com/services/rest/?&method=flickr.photos.geo.photosForLocation&api_key=8a216d186c3a98e3f52296ed47931eb1&lat=&long=


	end
end