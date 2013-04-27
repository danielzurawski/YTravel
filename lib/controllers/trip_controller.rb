module YTravel
	class TripController < YTravel::Controller
		get '/' do
			erb :index, layout: true
		end

		post '/plan' do 
			puts "data: " + params.to_s
		end
	end
end