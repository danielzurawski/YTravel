module YTravel
	class TripController < YTravel::Controller		
		post '/plan' do 
			LandmarkController.new.find_landmarks(params).to_json
		end
	end
end