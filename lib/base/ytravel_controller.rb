module YTravel
	class Controller < Sinatra::Base
		before do
			body_parameters = request.body.read
			params.merge!(JSON.parse(body_parameters)) unless body_parameters.nil? || body_parameters == ''
		end
	end
end

