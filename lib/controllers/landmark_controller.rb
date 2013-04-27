module YTravel
	class LandmarkController 
	
		def find_landmarks(data)
			@client = GooglePlaces::Client.new("AIzaSyBfQ0RtDqywSlAauWtPvNH_cwYpJdiN_T0")
			landmark = Landmark.new(:address => data[:location])
			landmark.save
			puts 'location latitude: ' + landmark.latitude.to_s
			puts 'location: ' + landmark.longitude.to_s

			@client.spots(landmark.latitude, landmark.longitude, 
				:types => 'point_of_interest', :radius => 15000)
		end

		def find_expedia_landmarks(data)
			landmarks = Array.new
			date_start = Date.new(params[:from])
			date_end = Date.new(params[:end])
			api = Expedia::Api.new
			
			entries = ((date_end - date_start) * 24) / 2;
			puts "Called find_landmarks with: " + data[:location]
			
			puts "Start date: " + date_start.to_s
			puts "End date: " + date_start.to_s

			response = api.geo_search({:destinationString => data[:location], :type => 2})
			
			response.body['LocationInfoResponse']['LocationInfos']['LocationInfo'].each { |landmark|
					landmarks << {:description => landmark['description'], :latitude => landmark['latitude'], :longitude => landmark['longitude']}
			}

			landmarks
		end
	end

end
