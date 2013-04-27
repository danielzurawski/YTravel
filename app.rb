require "sinatra/base"

class App < Sinatra::Base

	get '/' do 
		erb :hello, layout: true
	end

end
