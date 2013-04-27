module YTravel
	class TripController < YTravel::Controller
		get '/' do
			erb :index, layout: true
		end

		post '/plan' do 
			lc = LandmarkController.new
			landmarks = lc.find_landmarks(params)
			landmarks.to_json
		end
	end
end