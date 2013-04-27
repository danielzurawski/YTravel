module YTravel
	class TripController < YTravel::Controller

		get '/' do
			erb :index, layout: true
		end
		
		post '/plan' do 
			LandmarkController.new.find_landmarks(params).to_json
		end
	end
end