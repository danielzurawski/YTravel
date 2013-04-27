require 'sinatra'

get '/' do
	erb :index, layout: true
end

post '/plan-trip' do 
	puts "data: " + params
end

