module YTravel
	class TripController < YTravel::Controller
		get '/' do
			erb :index, layout: true
		end

		get '/plan/:lat/:long/:start_date/:end_date' do |lat, long, start_date, end_date|
			LandmarkController.new.find_landmarks({:lat => lat.to_f, :long => long.to_f, :start_date => start_date.to_i, :end_date => end_date.to_i}).to_json
		end
	end
end