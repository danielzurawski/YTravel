require 'date'
module YTravel
	class LandmarkController 
	
		def find_landmarks(data)
			landmarks = Array.new
			
			@client = GooglePlaces::Client.new("AIzaSyBfQ0RtDqywSlAauWtPvNH_cwYpJdiN_T0")
			
			puts 'latitutde: ' + data[:lat].to_s + ', long: ' + data[:long].to_s
			
			@client.spots(data[:lat], data[:long], :radius => 50000, :types => ['museum', 'establishment', 'art_gallery', 'cafe'], :exclude => ['airport', 'transit_station', 'bus_station'] 
				).each {
				|spot|
				landmarks << {:lat => spot.lat, :long => spot.lng,
							  :name => spot.name, :rating => spot.rating,
							  :formatted_address => spot.formatted_address,
							  :formatted_phone_number => spot.formatted_phone_number	}
			}

			best_entries_for_period(landmarks, data[:start_date], data[:end_date])
		end

		def best_entries_for_period(data, start_date, end_date)
			period = ((Time.at(end_date).to_date - Time.at(start_date).to_date).round * 24) / 2;
			data.sort_by { |hsh| hsh[:rating] }
			puts "Taking " + period.to_s + " entries."
			data.take(period)
		end

		def find_expedia_landmarks(data)
			landmarks = Array.new
			date_start = Date.new(params[:from])
			date_end = Date.new(params[:end])
			api = Expedia::Api.new
			
			
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
