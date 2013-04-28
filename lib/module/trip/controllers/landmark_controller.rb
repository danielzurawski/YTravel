require 'date'
require 'base64'
module YTravel
	class LandmarkController 
	
		def find_landmarks(data)
			landmarks = Array.new
			@API_KEY = "AIzaSyBfQ0RtDqywSlAauWtPvNH_cwYpJdiN_T0"
			@client = GooglePlaces::Client.new(@API_KEY)
			
			puts 'latitutde: ' + data[:lat].to_s + ', long: ' + data[:long].to_s
			
			@client.spots(data[:lat], data[:long], :radius => 10000, :types => ['museum', 'establishment', 'art_gallery', 'cafe'], :exclude => ['airport', 'transit_station', 'bus_station', 'hotel'] 
				).each {
					|spot|

				#puts "spot photos: "
				#puts spot.photos.inspect
				#unless spot.photos.first.nil?
					#photo = Base64.strict_encode64(GoogleApi.new.get_photo(@API_KEY, spot.photos.first[:photo_reference]))
				#end
				
				photo_url = ""
				query_result = YahooApi.new.nearby_images(data[:city], spot.name)
				puts 'landmark controller: query result content: ' + query_result.inspect
				unless query_result.nil? || query_result["query"].nil? || query_result["query"]["results"].nil?

					query_result["query"]["results"]["size"].each {
						|image|
						
						if image["label"] == "Medium"
							photo_url = image["source"]
							puts "acquired photo source: " + photo_url + ", for spot name: " + spot.name
							break
						end
					}
				end
				

				# photo_url = GoogleApi.new.google_search_image(spot.name)
				# photo_url = photo_url[:results].first[:url]
				
				landmarks << {:lat => spot.lat, :long => spot.lng,
							  :name => spot.name, :rating => spot.rating,
							  :formatted_address => spot.formatted_address,
							  :formatted_phone_number => spot.formatted_phone_number, :icon => spot.icon, :photo => photo_url}
			}

			best_entries_for_period(landmarks, data[:start_date], data[:end_date])
		end

		def best_entries_for_period(data, start_date, end_date)
			if Time.at(end_date) > Time.at(start_date)
				period = ((Time.at(end_date).to_date - Time.at(start_date).to_date).round * 24) / 4;
				data.sort_by { |hsh| [hsh[:rating] ? 0 : 1,hsh[:rating] || 0] }
				
				#for i in 0..data.size
				#	for j in i+1..data.size
				#		if j > data.size then
				#			break
				#		GoogleApi.new.calculate_distance(
				#			data[i][:lat], data[i][:long],
				#			data[j][:long], data[j][:long]
				#		)
				#	end
				#end

				#GoogleApi.new.calculate_distance(
				#	data.first[:lat], data.first[:long], 
				#	data[1][:lat], data[1][:long]
				#)
				puts "Taking " + period.to_s + " entries."
				data.take(period)
			end
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
