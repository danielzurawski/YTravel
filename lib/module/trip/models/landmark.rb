require 'date'
require 'base64'
require 'enumerator'
module YTravel
	class Landmark 
	
		def find_landmarks(data)
			landmarks = Array.new
			@API_KEY = "AIzaSyBfQ0RtDqywSlAauWtPvNH_cwYpJdiN_T0"
			@client = GooglePlaces::Client.new(@API_KEY)
			
			puts 'latitutde: ' + data[:lat].to_s + ', long: ' + data[:long].to_s
			
			@client.spots(data[:lat], data[:long], 
						  :radius => 10000, 
						  :types => ['museum', 'establishment', 'art_gallery', 'cafe'], 
						  :exclude => ['airport', 'transit_station', 'bus_station', 'hotel'] ).each { |spot|

				landmarks << {:lat => spot.lat, :long => spot.lng,
							  :name => spot.name, :rating => spot.rating,
							  :formatted_address => spot.formatted_address,
							  :formatted_phone_number => spot.formatted_phone_number, 
							  :icon => spot.icon, :photo => (get_related_images_yboss(data[:city], spot.name) || '')}
			}

			sorted_landmarks = best_entries_for_period(landmarks, data[:start_date], data[:end_date])
			remove_hotels(sorted_landmarks)
		
			{'distances' => calculate_distances(sorted_landmarks),
			 'landmarks' => sorted_landmarks}
		end

		def get_related_images_yboss(city, name)
			query_result = YahooApi.new.nearby_images(city, name)
			puts 'landmark controller: query result content: ' + query_result.inspect
			unless query_result.nil? || query_result["query"].nil? || #query_result["query"]["results"].nil?
				query_result["query"]["results"]["size"].each { |image|
					if image["label"] == "Medium"
						return image["source"]
						break
					end
				}
			end
		end

		def calculate_distances(landmarks)
			gapi = GoogleApi.new

			distances = Array.new
			landmarks.each_slice(2) { |current, n|
				unless n.nil? 
					distance = gapi.calculate_distance(current[:lat], current[:long], n[:lat], n[:long])
					distances.push({'current' => current[:name], 'next' => n[:name], 'distance' => distance})
				end
			}
			distances
		end

		def remove_hotels(landmarks)
			landmarks.delete_if { |landmark| landmark[:name].downcase.include? 'hotel' }
		end

		def best_entries_for_period(data, start_date, end_date)
			if Time.at(end_date) > Time.at(start_date)
				period = ((Time.at(end_date).to_date - Time.at(start_date).to_date).round * 24) / 4;
				data.sort_by { |hsh| [hsh[:rating] ? 0 : 1,hsh[:rating] || 0] }
				
				puts "Taking " + period.to_s + " entries."
				data.take(period)
			end
		end
	end
end
