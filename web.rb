require 'sinatra'

get '/' do
	erb :index, layout: true
end